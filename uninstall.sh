#!/usr/bin/env bash
# Remove Compact Tabs from a Firefox profile.
#
#   ./uninstall.sh                       choose a profile from a list
#   ./uninstall.sh --profile NAME        profile name as in about:profiles
#   ./uninstall.sh --profile-path DIR    profile folder
#   ./uninstall.sh --yes ...             no confirmation prompt
#
# Removes chrome/compact-tabs/ and the theme's blocks in userChrome.css and
# user.js, deleting either file if nothing else is left in it. With Firefox
# closed, it also clears the theme's prefs from prefs.js so Firefox's defaults
# return; the stylesheet pref stays on if other custom CSS remains, and the
# bookmark hint count is kept.
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
. "$REPO/scripts/common.sh"

NAME="" PATH_ARG="" ASSUME_YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    --profile) NAME="${2:-}"; shift 2 ;;
    --profile-path) PATH_ARG="${2:-}"; shift 2 ;;
    -y|--yes) ASSUME_YES=1; shift ;;
    -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "Unknown option: $1 (see --help)" ;;
  esac
done

require_macos
choose_profile "$NAME" "$PATH_ARG"
echo "Profile: $PROFILE_DIR"
confirm "Remove Compact Tabs from this profile?"

CHROME="$PROFILE_DIR/chrome"
rm -rf "$CHROME/compact-tabs"

# Rewrite a file without the theme's block; delete it if nothing is left.
remove_block() {
  local file="$1" rest
  [ -f "$file" ] || return 0
  rest="$(strip_block "$file" "$2" "$3")"
  if is_blank "$rest"; then rm -f "$file"; else printf '%s\n' "$rest" > "$file"; fi
}
remove_block "$CHROME/userChrome.css" "$CSS_BEGIN" "$CSS_END"
remove_block "$PROFILE_DIR/user.js" "$JS_BEGIN" "$JS_END"
rmdir "$CHROME" 2>/dev/null || true

# Firefox keeps applied prefs in prefs.js after user.js stops setting them.
# The bookmark hint count is left as is: Firefox only ever counts it up, and
# resetting it would bring the "Saved to bookmarks" note back.
names="$(pref_names "$REPO/user.js" "$REPO/scripts/dev-prefs.js" |
  grep -vx 'browser.bookmarks.editDialog.confirmationHintShowCount' || true)"
if [ -f "$CHROME/userChrome.css" ] || [ -f "$CHROME/userContent.css" ]; then
  names="$(printf '%s\n' "$names" | grep -vx 'toolkit.legacyUserProfileCustomizations.stylesheets' || true)"
fi
if profile_running "$PROFILE_DIR"; then
  echo "Removed the theme files. Firefox is running this profile, so the theme's"
  echo "prefs are still saved in prefs.js. Quit Firefox and run this again to"
  echo "reset them, or reset them in about:config:"
  printf '  %s\n' $names
elif [ -f "$PROFILE_DIR/prefs.js" ]; then
  CT_PREFS="$names" awk '
    BEGIN { n = split(ENVIRON["CT_PREFS"], a, "\n"); for (i = 1; i <= n; i++) if (a[i] != "") drop["user_pref(\"" a[i] "\","] = 1 }
    { for (k in drop) if (index($0, k) == 1) next; print }
  ' "$PROFILE_DIR/prefs.js" > "$PROFILE_DIR/prefs.js.tmp"
  mv "$PROFILE_DIR/prefs.js.tmp" "$PROFILE_DIR/prefs.js"
  echo "Removed. Firefox's defaults return for the theme's prefs."
else
  echo "Removed."
fi
