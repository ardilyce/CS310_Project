# PhishGuard

**A mobile app to instantly analyze emails, messages, and screenshots for phishing threats.**

*A project for the CS310 course.*

---

## Table of Contents

- [About The Project](#about-the-project)
- [Core Features](#core-features)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [Roadmap](#roadmap)
- [Challenges & Considerations](#challenges--considerations)
- [The Team](#the-team)

---

## About The Project

Phishing scams are becoming increasingly sophisticated, making it difficult for everyday users to distinguish between legitimate and malicious messages. This vulnerability puts people at constant risk of financial loss, data theft, and account compromise.

**PhishGuard** is designed to be a simple, fast, and effective first line of defense. It empowers users to quickly verify suspicious content by providing an instant risk score (from 0 to 100). By leveraging OCR, content analysis, and a unique community-powered reporting system, our goal is to help users make safer decisions before they click a dangerous link or give away sensitive information.

This app is built for everyone, especially:
* Users who are not tech-savvy, including older adults.
* Any daily smartphone user on iOS or Android.
* Office workers who are frequent targets of email-based scams.

---

## Core Features

* **Easy Input**: Paste text directly or upload a screenshot for analysis.
* **Image Scanning (OCR)**: Automatically extracts text from any uploaded image using Optical Character Recognition.
* **Content Analysis**: Scans text for common scam-related keywords and checks for insecure link protocols (`http` vs. `https`.)
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

## Roadmap

While our core features provide a solid foundation, we have several "nice-to-have" features planned for future development:

- [ ] **Dark Mode**: Implement a dark theme for user comfort.
- [ ] **Share Results**: Add a button to easily share the analysis results with others.
- [ ] **Advanced URL Checking**: Integrate with an external API like the **Google Safe Browsing API** for more robust link verification.
- [ ] **Security Tips**: Display actionable security advice to the user after each scan.

---

## Challenges & Considerations

We have identified the following potential challenges and our strategies to address them:

* **OCR Accuracy**: Text recognition from screenshots may not always be perfect.
    * **Solution**: We will implement a feature that allows users to review and edit the extracted text before the analysis is run.
* **Scoring Algorithm Fairness**: The scoring model must be balanced to avoid frequent false positives (flagging safe messages) or false negatives (missing real threats).
    * **Solution**: We will iteratively test and refine the algorithm based on a diverse set of real-world examples.
* **Data Privacy**: Users will be submitting potentially sensitive personal messages.
    * **Solution**: We are committed to user privacy by hashing all sensitive stored data (like reported email addresses), minimizing data collection, and maintaining a transparent privacy policy.

---

## The Team

This project is being developed by a dedicated team of students:

- Ardıl Yüce
- Kartal Özbalkanlı
- Zeynep Zilan Turunç
- Utku Çağlar
- Arin Ikizogullari
- Ayberk Savaş
