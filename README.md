# Baseball Stats App

A Flutter mobile app that tracks baseball player statistics, with Firebase Authentication for user accounts. Built as part of the WeThinkCode_ Cohort 2025 Mobile Development elective.

---

## What It Does

- **User Authentication** — Sign up, login, and password reset via Firebase Auth
- **Player List** — Browse baseball players with team and key stats
- **Player Detail** — Tap a player to see full stats (AVG, HR, RBI, SB)
- **Refresh Stats** — Refresh button with "Updated X ago" timestamp
- **Account Section** — Shows the currently signed-in user's email
- **Loading Screen** — Displays random baseball facts while the app starts
- **Animated Header** — Custom animated baseball widget on the login screen

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.47.2 (Dart 3.13.2) |
| **Authentication** | Firebase Auth |
| **Platforms** | Web (Chrome), Android, Linux, Windows |

---
## Project Structure

```
baseball_stats_app/
├── lib/
│   └── main.dart              ← All app code (UI + logic + Firebase)
├── android/                   ← Android-specific config
├── web/                       ← Web-specific config (index.html)
├── linux/                     ← Linux desktop config
├── windows/                   ← Windows desktop config
├── pubspec.yaml               ← Dependencies
└── README.md
```


---

## How the App Works — Section by Section

Everything lives in `lib/main.dart`. Here's what each part does:

### 1. Imports & Firebase Config
Connects to Firebase using API keys in `FirebaseOptions`.

### 2. Baseball Facts List
A hardcoded list of 10 baseball facts, randomly picked on the loading screen.

### 3. `main()` Function
Initialises Flutter, connects to Firebase, launches the app.

### 4. `BaseballApp` — Root Widget
Sets the app theme (dark navy stadium background, red primary) and points to `AuthWrapper` as home.

### 5. `AuthWrapper` — Auth Gate
Uses `StreamBuilder` to listen to Firebase auth state:
- **Loading** → shows `LoadingScreen` with a random fact
- **Logged in** → shows `PlayerListScreen`
- **Logged out** → shows `LoginScreen`

### 6. `LoginScreen` + `_LoginScreenState`
Handles:
- **Login** — `signInWithEmailAndPassword()`
- **Signup** — `createUserWithEmailAndPassword()`
- **Password Reset** — `sendPasswordResetEmail()`

### 7. `LoadingScreen` + `_LoadingScreenState`
Shows while Firebase checks auth. Displays a random baseball fact and a spinner.

### 8. `PlayerListScreen`
Shows:
- **Account section** — signed-in email + avatar
- **Player list** — three players with name, team, AVG, HR
- **Tap a player** → navigates to `PlayerDetailScreen`
- **Logout** in the app bar

### 9. `PlayerDetailScreen` + `_PlayerDetailScreenState`
Shows full stats for one player:
- Avatar, name, team
- "Updated X ago" timestamp
- Stat rows for AVG, HR, RBI, SB
- **Refresh button** in the app bar

### 10. `AnimatedBaseballHeader`
Custom animated widget with three animations:
- **Glow pulse** — white/blue glow around the baseball
- **Bat swing** — batter icon rotates back and forth
- **Ball flight** — small baseball flies right and fades

Uses `AnimationController`, `Tween`, and `AnimatedBuilder`.

---

## Setup

### Prerequisites
- **Flutter SDK 3.47.2+** — [install guide](https://docs.flutter.dev/get-started/install)
- **Firebase account** — [firebase.google.com](https://firebase.google.com)

---

## Running the App

### Linux (Pop!_OS / Ubuntu)

```bash
cd ~/StudioProjects/baseball_stats_app
flutter pub get

# Web (any browser)
flutter run -d web-server --web-port 8080
# → open http://localhost:8080

# Chrome
flutter run -d chrome

# Linux desktop
flutter run -d linux

# Android
flutter run -d android

cd D:\baseball_stats_app-main
flutter pub get

flutter run -d chrome       # Chrome
flutter run -d edge         # Edge
flutter run -d windows      # Windows desktop
flutter run -d android      # Android

cd ~/StudioProjects/baseball_stats_app
flutter pub get
flutter run -d chrome
flutter run -d macos
flutter run -d android

## Common Commands

| Command | What It Does |
|---------|--------------|
| `flutter pub get` | Install dependencies |
| `flutter run` | Run on auto-detected device |
| `flutter run -d chrome` | Run in Chrome |
| `flutter run -d web-server --web-port 8080` | Run as web server |
| `flutter clean` | Clear build cache (fixes weird errors) |
| `flutter doctor` | Check Flutter setup |
| `flutter devices` | List devices |
| `flutter analyze` | Check for code errors |

---

## Firebase Setup (For Your Own Project)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. **Authentication → Sign-in method** → Enable **Email/Password**
4. Add **Web** as a platform
5. Copy the `firebaseConfig` object
6. Replace the `FirebaseOptions` values in `lib/main.dart`

---

## Using the App

1. **Sign Up** with any email and password (6+ characters)
2. You'll land on the **player list** with your account shown at the top
3. **Tap a player** to see their full stats
4. Tap the **refresh icon** to update the timestamp
5. Tap the **logout icon** to sign out
6. On login, use **"Forgot password?"** to send a reset email

---

## Demo

📹 **Demo Video:** *[YouTube link here]*

---

## What I Learned

- Building Flutter UIs with widgets, state, and layout
- Integrating Firebase Auth (login, signup, password reset)
- Real-time auth state with `StreamBuilder`
- Custom animations with `AnimationController`
- Handling form inputs, errors, and loading states
- Cross-platform development (web, desktop, mobile)

---

## Author

**Shafeeqah Moosa** — WeThinkCode_ Cohort 2025
- GitHub: [@shafeeqah-09](https://github.com/shafeeqah-09)

---

## License

Educational project — WeThinkCode_ Cohort 2025