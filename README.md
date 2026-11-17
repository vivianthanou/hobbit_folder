# Hobbit

**Find people who share your hobbies and join (or host) activities near you.**

Hobbit is a cross-platform Flutter app backed by a Flask + MySQL API. Users sign up with their interests (basketball, hiking, biking, …), browse events by category, and create their own events with a date, time and a location picked on a map.

> ⚠️ **Status: prototype / work in progress.** Core flows (sign-up, login, profile editing, event creation, event listing) exist, but several parts are unfinished. See [Known limitations](#known-limitations).

## Features

- **Accounts** – sign-up with name, username, email, phone, date of birth and interests; login
- **Profile** – edit username, description, profile picture and interests
- **Events** – create an event with title, category, date, time, description, photo and map location
- **Explore** – browse events by category (basketball, football, volleyball, skateboard, hiking, bowling, biking, running, sightseeing)
- **Maps** – Google Maps integration to pick/show event locations
- **Chat** – placeholder page (not implemented yet)

## Tech stack

| Layer    | Technology |
|----------|------------|
| Client   | Flutter (Dart SDK ^3.1.1), `provider`, `flutter_bloc`, `google_maps_flutter`, `location`, `image_picker`, `table_calendar`, `http`, `shared_preferences` |
| Backend  | Python, Flask, Flask-CORS, `mysql-connector-python`, passlib |
| Database | MySQL (`utf8mb4`) |
| Other    | Firebase (auth/core, currently commented out in `main.dart`); a small Express.js stub in `hobbit/lib/server_database.js` |

Targets: Android, Web, Windows, Linux, macOS (Flutter scaffolding for each is included).

## Repository structure

```
.
├── app.py              # Flask API (most complete version)
├── hobbit.sql          # MySQL schema
├── hobbit/             # Flutter application
│   ├── lib/
│   │   ├── main.dart           # Entry point, routes
│   │   ├── pages/              # login, register, profile, explore, event, map, chat, ...
│   │   ├── components/         # reusable widgets (button, text field)
│   │   ├── auth/               # login/register switcher
│   │   ├── mysql.dart          # direct MySQL connection helper (experimental)
│   │   ├── app.py              # older copy of the Flask API
│   │   └── server_database.js  # Express.js stub (experimental)
│   ├── android/ web/ windows/ linux/ macos/   # platform folders
│   └── pubspec.yaml
├── create_event.dart, event.dart, explore.dart, map.dart, profile_page.dart   # loose copies of page sources
└── AndroidManifest.xml
```

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ≥ 3.1.1)
- Python 3.9+
- MySQL 8 (or MariaDB)
- A Google Maps API key (for map features)

### 1. Database

```bash
mysql -u root -p -e "CREATE DATABASE hobbit CHARACTER SET utf8mb4;"
mysql -u root -p hobbit < hobbit.sql
```

The schema defines three tables: `user`, `events` and `participation`.
The API also expects a `user_interests (user_id, interest)` table and `latitude`, `longitude`, `image_url` columns on `events`; add them until the schema is updated (see [Known limitations](#known-limitations)).

### 2. Backend

```bash
pip install flask flask-cors mysql-connector-python passlib
python app.py
```

The server listens on `0.0.0.0:5000`. Database credentials are set at the top of `app.py` (default: `root` with an empty password on `127.0.0.1:3306`, database `hobbit`) – change them to match your setup.

### 3. Flutter app

```bash
cd hobbit
flutter pub get
```

1. **Point the app at your backend.** The API address is currently hard-coded as `http://192.168.43.86:5000` in `lib/pages/` (`login_page.dart`, `register_page.dart`, `profile_page.dart`, `event.dart`). Replace it with your machine's LAN IP (or `10.0.2.2` for the Android emulator).
2. **Add your Google Maps key** to `android/app/src/main/AndroidManifest.xml` (and the equivalent web/iOS config if you target them).
3. **Firebase (optional).** Firebase initialization is commented out in `lib/main.dart`. To enable it, generate your own config with `flutterfire configure` and uncomment the init code.

Run it:

```bash
flutter run                 # connected device / emulator
flutter run -d chrome       # web
```

## API reference

Base URL: `http://<host>:5000`

| Method | Endpoint             | Description |
|--------|----------------------|-------------|
| POST   | `/login`             | Log in with `email` and `password` |
| POST   | `/signup`            | Register a user (`username`, `password`, `email`, `phone_number`, `first_name`, `last_name`, `date_of_birth`, `interests[]`) |
| GET    | `/getdata?userId=`   | Fetch a user with their interests |
| POST   | `/updateUsername`    | Change username |
| POST   | `/updateDescription` | Change profile description |
| POST   | `/updateImage`       | Change profile image |
| POST   | `/updateInterests`   | Replace interests |
| POST   | `/create_event`      | Create an event (title, date, time, location, lat/lng, category, description, `host_id`, optional image) |
| GET    | `/getUserEvents?userId=` | Events hosted by a user |
| GET    | `/getCategoryEvents?category=` | Events in a category |

## Known limitations

This is a student-style prototype. Before using it for anything real, be aware of:

- **Passwords are stored and compared in plain text.** `passlib`/bcrypt is imported but not used. Hash passwords before deploying.
- **Hard-coded configuration** – server IP, DB credentials, and port numbers are embedded in source files.
- **`google-services.json` and `firebase_options.dart` are committed.** If these belong to a real Firebase project, rotate the keys and keep them out of version control.
- **Schema drift** – `hobbit.sql` doesn't yet match what `app.py` queries (`user_interests`, `phone_number`, `latitude`, `longitude`, `image_url`), and `user.interests` is a single `ENUM` while the API treats interests as a list.
- **Known bugs in the API** – e.g. `/getUserEvents` contains a malformed SQL statement, `/getdata` closes the global DB connection after each call, and `/create_event` calls a `get_db_connection()` helper that exists only in the root `app.py` copy.
- **Unimplemented pieces** – chat, joining events (`participation` table is unused by the API), and the Express/MySQL helper files are stubs.
- Duplicated source files at the repo root and in `hobbit/lib/` should be consolidated.

## Roadmap ideas

- [ ] Password hashing and token-based auth
- [ ] Event join/leave and participant lists
- [ ] Real-time chat
- [ ] Config via environment variables / `.env`
- [ ] Align SQL schema with the API; add migrations
- [ ] Tests and CI
