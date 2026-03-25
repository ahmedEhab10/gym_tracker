# 🏋️‍♂️ Gym Progress Tracker (Hobix)

A premium, modern Flutter application designed to be your **Personal Gym OS**. Hobix helps athletes train smarter, track everything, and grow stronger with an intuitive, glassmorphic dark-themed interface.

> *Note: UI Screenshots will be added here once the app reaches final production release.*
> 
> <!-- 
> 📸 Placeholder for Screenshots: 
> | Home Dashboard | Workout History | Log Measurement | Setup Flow |
> | :---: | :---: | :---: | :---: |
> | ![Home](screenshot_path) | ![History](screenshot_path) | ![Measures](screenshot_path) | ![Setup](screenshot_path) |
> -->

---

## ✨ Key Features

### 🚀 First-Time User Setup Flow
- **Personalized Onboarding:** A smooth, animated 5-step `PageView` collecting the user's Name, Age, Gender (with custom SVGs), Weight, and Fitness Goals.
- **Smart Initialization:** Automatically logs the initial weight as the first entry in the Measurement history and remembers the user securely using `SharedPreferences`.

### 📊 Comprehensive Measurements Tracking
- **Body & Tape Metrics:** Log over 17 distinct optional body measurements (Body Weight, Body Fat %, Lean Mass, Biceps, Chest, Calves, etc.).
- **Progress Pictures:** Integrated image picker allows users to upload side-by-side progress photos saved securely to the local device storage.
- **Historical List:** View past entries organized chronologically on the Measures page.

### 🗓️ Workout History & Calendar
- **Interactive Calendar:** Built with `table_calendar` to visualize activity streaks, rest days, and workout frequencies at a glance.
- **Daily Summaries:** Tap on any highlighted day to see exactly which workout route or exercises were completed.

### ⏱️ Active Workout Sessions
- **Live Session Engine:** Persistent bottom bar during active workouts with Start, Pause, and Finish controls.
- **Timer & Duration Tracking:** Global `WorkoutTimerCubit` ensures your session time is perfectly recorded in the background.

### 🗺️ Custom Workout Routes (Programs)
- **Design Your Routine:** Create customized `WorkoutRoutes` and nest `RouteDays` to build 4-day splits, PPLs, or full-body programs.
- **Exercise Library:** A rich, pre-seeded JSON library of 50+ exercises categorized by muscle groups with fast, interactive filter chips.

### 👤 Profile & Dashboard Insights
- **Dynamic Dashboard:** The Home Screen aggregates real data, displaying sets completed and active day achievements.
- **Premium Profile UI:** Features a glowing avatar, "PRO" badge indicator, and glassmorphic horizontal scroll cards for Body Stats and Personal Records (e.g., Bench Press, Squat).
- **Edit Profile:** Instantly update your display name and profile picture.

---

## 🏗️ Architecture & Tech Stack

This project strictly adheres to **Clean Architecture** principles, ensuring scalability, testability, and separation of concerns.

### 📂 Layered Directory Structure
1. **Domain Layer:** Contains core business logic, `Entities`, and `UseCases`. Totally independent of external packages.
2. **Data Layer:** Contains `Models` (Hive adapters), `Repositories` implementations, and local `DataSources`.
3. **Presentation Layer:** Contains UI components (`Widgets`, `Screens`) and State Management (`Cubits`, `Blocs`).

### 🛠️ Core Technologies Used
* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **State Management:** `flutter_bloc` & `equatable`
* **Dependency Injection:** `get_it`
* **Local Database / Storage:** `hive` & `hive_flutter` for blazing-fast NoSQL local persistence. `shared_preferences` for lightweight flags.
* **Functional Programming:** `dartz` for Either types and robust error handling.
* **UI Design & Animations:** `flutter_screenutil` (responsive sizing), `google_fonts` (Space Grotesk typography), `flutter_svg`, and custom implicitly animated widgets.
* **Utilities:** `image_picker`, `path_provider`, `table_calendar`, `intl`, `uuid`.

---

## 🏃 Getting Started

### Prerequisites
* Flutter SDK (`^3.10.4` or higher)
* Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/try_my_tracker.git
   cd try_my_tracker
   ```

2. **Fetch Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters & Code**
   Because this project uses Hive for local data storage, you must run the build runner to generate the database models before launching:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

---

## 🎨 Design Philosophy
Hobix is built with an unapologetic focus on **Aesthetics and Usability**. 
- Deep `AppColors.background` (Dark theme) eliminates eye strain.
- Neon `AppColors.primary` (Green) accents draw focus to Call-to-Actions.
- Background glow orbs and glassmorphic translucent panels (`Container` with low alpha values and blurs) provide a futuristic **Gym OS** feel.

---
*Developed with clean code and heavy lifting. Ready for production.* 🚀
