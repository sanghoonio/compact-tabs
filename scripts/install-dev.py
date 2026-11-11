#!/usr/bin/env python3
"""Install only into the named, isolated compact-tabs-dev Firefox profile.

Writes two things, each fenced so nothing else in the profile is touched:
  chrome/userChrome.css  - entry stylesheet, refused if not created by us
  user.js                - a marked block with scripts/prefs.js; other lines kept
"""
import argparse
import configparser
from pathlib import Path
import re
import shutil
import subprocess


ROOT = Path(__file__).resolve().parents[1]
PROFILE_NAME = 'compact-tabs-dev'
CSS_MARKER = '/* Managed by compact-tabs/scripts/install-dev.py */'
PREFS_SOURCE = ROOT / 'scripts/prefs.js'
BLOCK_BEGIN = '// BEGIN compact-tabs managed prefs (scripts/install-dev.py)'
BLOCK_END = '// END compact-tabs managed prefs'
BLOCK_RE = re.compile(re.escape(BLOCK_BEGIN) + r'.*?' + re.escape(BLOCK_END) + r'\n?', re.S)
PREF_RE = re.compile(r'^\s*user_pref\(\s*"([^"]+)"', re.M)
MODES = {
    'geometry': [],
    'selected-address': ['experiments/selected-address.css'],
}


def find_profile():
    base = Path.home() / 'Library/Application Support/Firefox'
    config = configparser.ConfigParser()
    config.read(base / 'profiles.ini')
    profiles = []
    for name in config.sections():
        section = config[name]
        if section.get('Name') == PROFILE_NAME and section.get('Path'):
            path = Path(section['Path'])
            if section.get('IsRelative', '1') == '1':
                path = base / path
            profiles.append(path.resolve())
    if len(profiles) != 1 or not profiles[0].is_dir():
        raise SystemExit(f'Expected one existing {PROFILE_NAME} profile; no files changed.')
    return profiles[0]


def profile_running(profile):
    result = subprocess.run(['pgrep', '-f', str(profile)], capture_output=True)
    return result.returncode == 0


def managed_block():
    body = PREFS_SOURCE.read_text().rstrip('\n')
    return f'{BLOCK_BEGIN}\n{body}\n{BLOCK_END}\n'


def pref_names(text):
    return set(PREF_RE.findall(text))


def plan_user_js(user_js, remove):
    """Return (new_text, notes) for user.js; everything outside the block is kept."""
    old = user_js.read_text() if user_js.exists() else ''
    outside = BLOCK_RE.sub('', old)
    notes = []
    if remove:
        new = outside
    else:
        clashes = sorted(pref_names(outside) & pref_names(PREFS_SOURCE.read_text()))
        if clashes:
            notes.append('Also set outside the managed block (left as is; the block comes '
                         'last, so its values win): ' + ', '.join(clashes))
        if outside and not outside.endswith('\n'):
            outside += '\n'
        new = outside + managed_block()
    return old, new, notes


def reset_prefs_js(profile, names):
    """Drop our prefs from prefs.js so Firefox falls back to its defaults."""
    prefs_js = profile / 'prefs.js'
    if not prefs_js.exists():
        return []
    lines = prefs_js.read_text().splitlines(keepends=True)
    kept = [line for line in lines if not (m := PREF_RE.match(line)) or m.group(1) not in names]
    dropped = len(lines) - len(kept)
    if dropped:
        prefs_js.write_text(''.join(kept))
    return dropped


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    action = parser.add_mutually_exclusive_group()
    action.add_argument('--mode', choices=MODES, default='geometry')
    action.add_argument('--remove', action='store_true',
                        help='Remove the entry stylesheet and the managed user.js block only.')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()

    profile = find_profile()
    chrome = profile / 'chrome'
    entry = chrome / 'userChrome.css'
    if entry.exists() and not entry.read_text().startswith(CSS_MARKER):
        raise SystemExit('Unmanaged userChrome.css exists; refusing to overwrite it.')
    user_js = profile / 'user.js'
    old_js, new_js, notes = plan_user_js(user_js, args.remove)

    print('Profile:', profile)
    print('Action:', 'remove' if args.remove else f'install {args.mode}')
    print('user.js:', 'unchanged' if old_js == new_js else 'managed block ' + ('removed' if args.remove else 'written'))
    for note in notes:
        print('Note:', note)
    if args.dry_run:
        return

    if old_js != new_js:
        user_js.write_text(new_js)

    if args.remove:
        if entry.exists():
            entry.unlink()
        names = pref_names(PREFS_SOURCE.read_text())
        if profile_running(profile):
            print('Firefox is running this profile, so its saved values were left in prefs.js. '
                  'Quit it and run --remove again, or reset these in about:config:', ', '.join(sorted(names)))
        else:
            print(f'Reset {reset_prefs_js(profile, names)} saved preference(s) in prefs.js to Firefox defaults.')
        print('Theme disabled after restarting this profile. Copied CSS assets were retained.')
        return

    chrome.mkdir(exist_ok=True)
    assets = chrome / 'compact-tabs'
    assets.mkdir(exist_ok=True)
    imports = []
    for source in ['chrome/geometry.css', *MODES[args.mode]]:
        shutil.copy2(ROOT / source, assets / Path(source).name)
        imports.append(f'@import url("compact-tabs/{Path(source).name}");')
    entry.write_text(CSS_MARKER + '\n' + '\n'.join(imports) + '\n')
    print(f'Installed. Restart only {PROFILE_NAME} to load CSS and preferences.')


if __name__ == '__main__':
    main()
