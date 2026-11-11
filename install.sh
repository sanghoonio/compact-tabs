#!/usr/bin/env bash
# Install Compact Tabs into a Firefox profile.
#
#   ./install.sh                         choose a profile from a list
#   ./install.sh --profile NAME          profile name as in about:profiles
#   ./install.sh --profile-path DIR      profile folder
#   ./install.sh --dev ...               also add Browser Toolbox prefs
#   ./install.sh --yes ...               no confirmation prompt
#
# Copies chrome/compact-tabs/ into the profile, adds two @import lines at the
# top of its userChrome.css and the prefs from user.js at the end of its
# user.js, each between "compact-tabs" BEGIN/END markers. Anything else in
# those files is kept. Running it again updates the theme.
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
. "$REPO/scripts/common.sh"

NAME="" PATH_ARG="" DEV=0 ASSUME_YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    --profile) NAME="${2:-}"; shift 2 ;;
    --profile-path) PATH_ARG="${2:-}"; shift 2 ;;
    --dev) DEV=1; shift ;;
    -y|--yes) ASSUME_YES=1; shift ;;
    -h|--help) sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "Unknown option: $1 (see --help)" ;;
  esac
done

require_macos
choose_profile "$NAME" "$PATH_ARG"
echo "Profile: $PROFILE_DIR"
confirm "Install Compact Tabs into this profile?"

CHROME="$PROFILE_DIR/chrome"
mkdir -p "$CHROME"

# Theme files: replace the folder so removed files do not linger.
rm -rf "$CHROME/compact-tabs"
cp -R "$REPO/chrome/compact-tabs" "$CHROME/compact-tabs"

# userChrome.css: the import block must come first.
rest="$(strip_block "$CHROME/userChrome.css" "$CSS_BEGIN" "$CSS_END")"
{
  echo "$CSS_BEGIN"
  grep '^@import' "$REPO/chrome/userChrome.css"
  echo "$CSS_END"
  is_blank "$rest" || printf '%s\n' "$rest"
} > "$CHROME/userChrome.css.tmp"
mv "$CHROME/userChrome.css.tmp" "$CHROME/userChrome.css"

# user.js: the block goes last, so its values win over earlier lines.
prefs=("$REPO/user.js")
[ "$DEV" = 1 ] && prefs+=("$REPO/scripts/dev-prefs.js")
rest="$(strip_block "$PROFILE_DIR/user.js" "$JS_BEGIN" "$JS_END")"
clashes="$(comm -12 <(printf '%s\n' "$rest" | grep -o 'user_pref("[^"]*"' | sed 's/.*("//; s/"$//' | sort -u) \
                    <(pref_names "${prefs[@]}") | tr '\n' ' ')"
{
  is_blank "$rest" || printf '%s\n' "$rest"
  echo "$JS_BEGIN (installed by Compact Tabs; uninstall.sh removes this block)"
  for f in "${prefs[@]}"; do grep -v '^[[:space:]]*$' "$f"; done
  echo "$JS_END"
} > "$PROFILE_DIR/user.js.tmp"
mv "$PROFILE_DIR/user.js.tmp" "$PROFILE_DIR/user.js"

echo "Installed."
[ -n "$clashes" ] && echo "Note: also set elsewhere in user.js (the theme's values win): $clashes"
if profile_running "$PROFILE_DIR"; then
  echo "Restart Firefox to load the theme."
else
  echo "Start Firefox with this profile to see it."
fi
