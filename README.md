# PhishGuard

**A mobile app to instantly analyze emails, messages, and screenshots for phishing threats.**

*A project for the CS310 course.*

---

## Table of Contents

- [About The Project](#about-the-project)
- [Core Features](#core-features)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [The Team](#the-team)

---

## About The Project

To combat the growing threat of phishing, **PhishGuard** offers an immediate first line of defense. Our mobile app allows you to quickly analyze suspicious messages by pasting text or uploading a screenshot. In seconds, you get a clear risk score from 0 to 100, empowering you to identify and avoid dangerous scams before you click.

---

## Core Features

* **Easy Input**: Paste text directly or upload a screenshot for analysis.
* **Image Scanning (OCR)**: Automatically extracts text from any uploaded image using Optical Character Recognition.
* **Content Analysis**: Scans text for common scam-related keywords and checks for insecure link protocols (`http` vs. `https`).
* **Instant Risk Score**: A clear, easy-to-understand risk score from 0 to 100 is generated in seconds.
* **Secure User Accounts**: Users can sign up and log in securely using Firebase Authentication.
* **Scan History**: A private history of all past scans is saved to the user's account for their reference.
* **Community Reporting**: Users can anonymously report the senders of high-risk messages, helping to build a community-driven database of emerging threats that warns other users.

---

## Technology Stack

We are building PhishGuard using a modern, cross-platform technology stack to ensure a seamless experience on both iOS and Android.

* **Frontend**: [Flutter](https://flutter.dev/) - Allows for a single codebase for both iOS and Android platforms.
* **Backend & Database**: [Firebase](https://firebase.google.com/)
    * **Authentication**: For secure user sign-up and login.
    * **Firestore**: A NoSQL database for storing user data, scan histories, and community reports.
    * **Cloud Storage for Firebase**: To handle image uploads for OCR analysis.

---

## Getting Started

To contribute to or run this project, you will need the following software installed on your machine:

* Flutter SDK: [Installation Guide](https://docs.flutter.dev/get-started/install)
* An editor like VS Code or Android Studio.
* A configured Firebase project to connect with the application.

---

## The Team

This project is being developed by a dedicated team of students:

- Ardıl Yüce
- Kartal Özbalkanlı
- Zeynep Zilan Turunç
- Utku Çağlar
- Arin Ikizogullari
- Ayberk Savaş
