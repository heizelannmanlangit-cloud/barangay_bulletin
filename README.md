# Barangay Bulletin

An offline-first community board for a barangay. Residents can post announcements,
log community/infrastructure issues, track their status, and manage archived
(soft-deleted) entries — all without internet. Built with Flutter + Hive.

## Features
- Announcements: create, edit, pin, soft-delete, filter by category
- Reports: create, edit, change status, soft-delete, filter by status + category
- Archive: restore or permanently delete soft-deleted items
- All data stored locally with Hive (works fully offline)

## Setup
1. Get the packages:
   flutter pub get
2. Generate the Hive adapters:
   dart run build_runner build --delete-conflicting-outputs
3. Run the app:
   flutter run

## Known limitations
- Filter chips are styled buttons (function are the same tho).
- Archive "All" view lists announcements first, then reports (not mixed by date).
