# Shared by install.sh and uninstall.sh. Not meant to be run directly.

FIREFOX_DIR="$HOME/Library/Application Support/Firefox"
PROFILES_INI="$FIREFOX_DIR/profiles.ini"

# Markers around everything the theme adds. Older installs used longer
# BEGIN/END lines and a whole-file marker; those are recognised too.
JS_BEGIN='// BEGIN compact-tabs'
JS_END='// END compact-tabs'
CSS_BEGIN='/* BEGIN compact-tabs */'
CSS_END='/* END compact-tabs */'
OLD_CSS_MARKER='/* Managed by compact-tabs/scripts/install-dev.py */'

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

require_macos() {
  [ "$(uname -s)" = Darwin ] || die "Compact Tabs is macOS only."
  [ -f "$PROFILES_INI" ] || die "No Firefox profiles found at $PROFILES_INI."
}

# Print "name<TAB>absolute path" for every profile in profiles.ini.
list_profiles() {
  awk -F= -v base="$FIREFOX_DIR" '
    function flush() {
      if (name != "" && path != "") print name "\t" (rel == "0" ? path : base "/" path)
      name = ""; path = ""; rel = "1"
    }
    /^\[/ { flush(); inprofile = ($0 ~ /^\[Profile[0-9]+\]$/); next }
    inprofile && $1 == "Name" { name = substr($0, 6) }
    inprofile && $1 == "Path" { path = substr($0, 6) }
    inprofile && $1 == "IsRelative" { rel = $2 }
    END { flush() }
  ' "$PROFILES_INI"
}

# Sets PROFILE_DIR from --profile NAME, --profile-path DIR, or a prompt.
# Never picks a profile on its own.
choose_profile() {
  local name="$1" path="$2"
  if [ -n "$path" ]; then
    PROFILE_DIR="$path"
  elif [ -n "$name" ]; then
    PROFILE_DIR="$(list_profiles | awk -F'\t' -v n="$name" '$1 == n { print $2; exit }')"
    [ -n "$PROFILE_DIR" ] || die "No profile named \"$name\". Run with no options to see the list."
  else
    [ -t 0 ] || die "Name a profile with --profile NAME or --profile-path DIR."
    local profiles count choice
    profiles="$(list_profiles)"
    [ -n "$profiles" ] || die "No profiles listed in $PROFILES_INI."
    echo "Firefox profiles:"
    printf '%s\n' "$profiles" | awk -F'\t' '{ printf "  %d) %s\n", NR, $1 }'
    count="$(printf '%s\n' "$profiles" | wc -l | tr -d ' ')"
    printf 'Choose a profile [1-%s]: ' "$count"
    read -r choice
    case "$choice" in ''|*[!0-9]*) die "Not a number." ;; esac
    [ "$choice" -ge 1 ] && [ "$choice" -le "$count" ] || die "Out of range."
    PROFILE_DIR="$(printf '%s\n' "$profiles" | awk -F'\t' -v i="$choice" 'NR == i { print $2 }')"
  fi
  [ -d "$PROFILE_DIR" ] || die "Profile folder not found: $PROFILE_DIR"
  PROFILE_DIR="$(cd "$PROFILE_DIR" && pwd)"
}

confirm() {
  [ "$ASSUME_YES" = 1 ] && return 0
  [ -t 0 ] || die "Add --yes to run without a prompt."
  printf '%s [y/N] ' "$1"
  local answer; read -r answer
  case "$answer" in y|Y|yes|YES) return 0 ;; *) echo "Cancelled."; exit 1 ;; esac
}

# Firefox holds .parentlock open while it runs a profile; a profile started
# with -profile also shows its path on the command line.
profile_running() {
  { [ -e "$1/.parentlock" ] && lsof -t "$1/.parentlock" >/dev/null 2>&1; } ||
    ps -axo command= | awk -v p="$1" '
      /^\/.*\.app\/Contents\/MacOS\/firefox/ && index($0, p) { found = 1 }
      END { exit !found }'
}

# Print a file without the theme's block (and without a whole-file old marker
# file). Missing files print nothing.
strip_block() {
  local file="$1" begin="$2" end="$3"
  [ -f "$file" ] || return 0
  if [ "$(head -n 1 "$file")" = "$OLD_CSS_MARKER" ]; then return 0; fi
  awk -v b="$begin" -v e="$end" '
    !skip && index($0, b) == 1 { skip = 1; next }
    skip && index($0, e) == 1 { skip = 0; next }
    !skip { print }
  ' "$file"
}

# Pref names set by a prefs file.
pref_names() {
  grep -o 'user_pref("[^"]*"' "$@" 2>/dev/null | sed 's/.*user_pref("//; s/"$//' | sort -u
}

is_blank() { [ -z "$(printf '%s' "$1" | tr -d '[:space:]')" ]; }
