#!/usr/bin/env python3
"""Install only into the named, isolated compact-tabs-dev Firefox profile."""
import argparse
import configparser
from pathlib import Path
import shutil


ROOT = Path(__file__).resolve().parents[1]
MARKER = '/* Managed by compact-tabs/scripts/install-dev.py */'


def find_profile():
    base = Path.home() / 'Library/Application Support/Firefox'
    config = configparser.ConfigParser()
    config.read(base / 'profiles.ini')
    profiles = []
    for name in config.sections():
        section = config[name]
        if section.get('Name') == 'compact-tabs-dev' and section.get('Path'):
            path = Path(section['Path'])
            if section.get('IsRelative', '1') == '1':
                path = base / path
            profiles.append(path.resolve())
    if len(profiles) != 1 or not profiles[0].is_dir():
        raise SystemExit('Expected one existing compact-tabs-dev profile; no files changed.')
    return profiles[0]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mode', choices=['geometry', 'single-row', 'anchor-probe', 'selected-address'], default='geometry')
    parser.add_argument('--remove', action='store_true', help='Remove this installer\'s entry stylesheet only.')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    profile = find_profile()
    chrome = profile / 'chrome'
    entry = chrome / 'userChrome.css'
    if entry.exists() and not entry.read_text().startswith(MARKER):
        raise SystemExit('Unmanaged userChrome.css exists; refusing to overwrite it.')
    print('Profile:', profile)
    print('Action:', 'remove entry stylesheet' if args.remove else f'install {args.mode}')
    if args.dry_run:
        return
    if args.remove:
        if entry.exists():
            entry.unlink()
        print('Theme disabled after restarting this profile. Other files were retained.')
        return
    chrome.mkdir(exist_ok=True)
    assets = chrome / 'compact-tabs'
    assets.mkdir(exist_ok=True)
    shutil.copy2(ROOT / 'chrome/geometry.css', assets / 'geometry.css')
    imports = ['@import url("compact-tabs/geometry.css");']
    if args.mode != 'geometry':
        shutil.copy2(ROOT / f'experiments/{args.mode}.css', assets / f'{args.mode}.css')
        imports.append(f'@import url("compact-tabs/{args.mode}.css");')
    entry.write_text(MARKER + '\n' + '\n'.join(imports) + '\n')
    print('Installed. Restart only compact-tabs-dev to load CSS.')
    print('Requires toolkit.legacyUserProfileCustomizations.stylesheets=true in that profile.')


if __name__ == '__main__':
    main()
