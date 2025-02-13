# Changelog
All changes will be documented in this file

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2023-06-06
### Added
- Added SQL columns ACCEPT_ICON, ACCEPT_ICON_COLOR, DECLINE_ICON, DECLINE_ICON_COLOR that allow us to set dynamically icons and colors to accept and decline links. [@quiccoli](https://github.com/quiccoli).
- Added SQL column NOTE_DATE that allow us to show a badge with notification date. [@quiccoli](https://github.com/quiccoli).

### Fixed
- fixed issue 17 of original project: "DEPRECATED: json_from_sql, use APEX_EXEC and APEX_JSON instead" [@quiccoli](https://github.com/quiccoli).
