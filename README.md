# United Union Bank (GreenBank)

A modern, impact-driven banking application built with Flutter.

## Overview
United Union Bank (also known as GreenBank) is a financial technology application that combines traditional banking features with environmental and social impact tracking. It allows users to not only manage their finances but also monitor the real-world impact of their transactions (e.g., trees planted, CO2 offset, meals provided).

## Key Features
* **Modern Authentication Flow:** Secure login, sign up, email validation, and customizable onboarding regarding user's social causes.
* **Dashboard & Quick Actions:** Easy access to quick actions like Send, Request, Donate, Exchange, and Invest.
* **Send Money Flow:** A complete and intuitive multi-step UI for transferring funds to other banks, featuring recipient details, amount input, payment summary, and successful transfer impact tracking.
* **Impact Tracking:** Tracks and visually rewards users for the positive environmental/social impact of their transactions with "Impact Scores".
* **Profile Management:** Comprehensive and interactive profile settings, including personal information, email, phone number, security preferences, and app notifications.

## Tech Stack
* **Framework:** [Flutter](https://flutter.dev/)
* **Language:** Dart
* **State Management & Routing:** [GetX](https://pub.dev/packages/get)
* **Design:** Custom UI with fully mocked responsive screens using `GoogleFonts` and custom theming (`AppTheme`).

## Project Structure
* `lib/views/`: Contains the UI screens.
  * `authScreens/`: Login, Sign Up, Verify Email, Causes Selection, etc.
  * `tabs/`: Bottom navigation tabs (Home, Impact, Invest, Profile, Accounts).
  * `sendMoneyScreens/`: The entire fund transfer flow.
  * `profileScreens/`: Sub-menus for the profile tab.
* `lib/theme/`: Custom colors, gradients, and typography definitions.

## Getting Started

1. **Prerequisites:** Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. **Clone the repository.**
3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
4. **Run the App:**
   ```bash
   flutter run
   ```
