# PhishGuard

**A mobile app to instantly analyze emails, messages, and screenshots for phishing threats.**

*A project for the CS310 course.*

---

# Table of Contents

- [About The Project](#about-the-project)
- [Core Features](#core-features)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [Methodology](#methodology)
- [The Team](#the-team)

---

# About The Project

To combat the growing threat of phishing, **PhishGuard** offers an immediate first line of defense. Our mobile app allows you to quickly analyze suspicious messages by pasting text or uploading a screenshot. In seconds, you get a clear risk score from 0 to 100, empowering you to identify and avoid dangerous scams before you click.

---

# Core Features

* **Easy Input**: Paste text directly or upload a screenshot for analysis.
* **Image Scanning (OCR)**: Automatically extracts text from any uploaded image using Optical Character Recognition.
* **Content Analysis**: The system inspects messages for:  
  - **Suspicious keywords & phrases** commonly used in phishing.  
  - **Insecure or deceptive links** (`http` vs. `https`, shortened URLs, IP-based domains, knwon malicious urls).  
  - **Stylistic red flags** like excessive ALL-CAPS and multiple exclamation marks.  
* **Instant Risk Score**: A clear, easy-to-understand risk score from 0 to 100 is generated in seconds.
* **Secure User Accounts**: Users can sign up and log in securely using Firebase Authentication.
* **Scan History**: A private history of all past scans is saved to the user's account for their reference.
* **Community Reporting**: Users can anonymously report the senders of high-risk messages, helping to build a community-driven database of emerging threats that warns other users.

---

# Technology Stack

We are building PhishGuard using a modern, cross-platform technology stack to ensure a seamless experience on both iOS and Android.

* **Frontend**: [Flutter](https://flutter.dev/) - Allows for a single codebase for both iOS and Android platforms.
* **Backend & Database**: [Firebase](https://firebase.google.com/)
    * **Authentication**: For secure user sign-up and login.
    * **Firestore**: A NoSQL database for storing user data, scan histories, and community reports.
    * **Cloud Storage for Firebase**: To handle image uploads for OCR analysis.

---

# Getting Started

To contribute to or run this project, you will need the following software installed on your machine:

* Flutter SDK: [Installation Guide](https://docs.flutter.dev/get-started/install)
* An editor like VS Code or Android Studio.
* A configured Firebase project to connect with the application.

---

# Methodology  

*Albeit the current methodology provides a structured plan, it is tentative and minor changes may be made as the project progresses.*  

**PhishingGuard** analyzes messages suspected of being phishing attempts using a **rule-based scoring system**. The analysis follows five main steps:  

1. [Data Acquisition](#1-data-acquisition)  
2. [Preprocessing](#2-preprocessing)  
3. [Feature Extraction](#3-feature-extraction)  
4. [Scoring Mechanism](#4-scoring-mechanism)  
5. [Result Interpretation](#5-result-interpretation)  

---

## 1. Data Acquisition  
Messages can be provided in two formats:  

- **Text Input**: The user pastes or types the suspicious message.  
- **Image Input**: The user uploads or captures a screenshot/photo.  
  - The app uses **Optical Character Recognition (OCR)** (via [`google_mlkit_text_recognition`](https://pub.dev/packages/google_mlkit_text_recognition)) to extract text from the image.  

---

## 2. Preprocessing  
The message is cleaned and normalized before analysis:  

- Convert all text to lowercase.  
- Remove extra spaces and special characters.  
- Save URLs seperately for Link Analysis and remove them.  

This ensures consistent and safe input for analysis.  

---

## 3. Feature Extraction  
The system identifies **clues** that suggest a phishing attempt. These are grouped into three categories:  

### a) Keyword Detection  

Phishing messages often rely on recurring patterns of words and phrases such as *“verify your account”*, *“urgent”*, *“reset password”*, or *“OTP”* to manipulate users into taking immediate action. To capture these signals, PhishingGuard applies a ratio-based keyword detection approach rather than relying solely on raw keyword counts.  

The process begins with a curated list of suspicious terms and expressions that are frequently used in phishing attempts. When a message is analyzed, it is first tokenized into individual words, and the total word count is determined.  

Once the number of keyword matches has been identified, the system calculates the ratio of detected keywords to the overall number of words in the message. This ratio provides a more balanced measure of suspicious content. A high ratio indicates that a large proportion of the message is composed of phishing-related words, which is more likely to be dangerous. Based on this ratio, a score is assigned: messages where at least 20% of the words match suspicious keywords are treated as high risk and receive a strong score boost, while those with moderate or low keyword density receive smaller contributions to the total score.  

In addition to ratio-based detection, PhishingGuard also considers a subset of critical keywords such as *OTP*, *reset password*, or *IBAN*. These words are strongly associated with phishing activity and are treated as critical indicators. Whenever such terms appear, they contribute a fixed high score regardless of the overall ratio.  

This methodology ensures that short phishing-like messages such as *“Please verify your account”* are flagged with a high risk score, since most of the text is suspicious. At the same time, longer legitimate messages that might incidentally mention common words like *“account”* or *“password”* are not unfairly penalized, thereby reducing false positives. By combining ratio-based scoring with critical keyword detection, PhishingGuard provides a lightweight yet accurate mechanism for keyword-based phishing analysis without requiring a machine learning model.  
   

### b) Link Analysis  
Most phishing attempts attempt to trick users into clicking on an **active link** that leads to a malicious website. To address this, **PhishingGuard** analyzes all links in the message using two complementary methods:  

**i. Structural Examination of URLs**  
The system inspects each link for common phishing indicators, such as:  
- **Shortened links** that hide the true destination (e.g., `bit.ly`, `t.co`).  
- **Raw IP addresses** instead of domain names (e.g., `http://192.168.1.5/login`).  
- **Suspicious path segments** suggesting credential harvesting (e.g., `/login`, `/verify`, `/secure`).  

**ii. Cross-Referencing with a Malicious Link Database**  
To strengthen detection, PhishingGuard also cross-references each extracted link with a curated **malicious URL database**:  
- The database source is [URLhaus](https://urlhaus.abuse.ch/), a well-known repository of reported phishing and malware links.  
- The database is pre-downloaded, formatted into a `.txt` file, and stored locally with each malicious URL listed line by line.  
- If the examined link matches an entry in the database, the system immediately assigns a **high risk score** and warns the user that the message is almost certainly a phishing attempt.  

**Note:** At the current stage, the [database is handled **offline**](https://github.com/ardilyce/CS310_Project/blob/b273628f7249b9fc96cac1c578dbd822d6cf4ef3/datasets/urls.txt) to keep the system lightweight and functional without internet connectivity. However, as the project progresses, the design can be extended to perform **real-time API queries** to URLhaus or other threat intelligence services. This would ensure that the app always has access to the most up-to-date list of malicious links.  


### c) Heuristic Rules  
Detects general phishing patterns, by focusing on 2 key aspects:  
- Multiple exclamation marks (`!!!`).  
- Excessive ALL CAPS words.  

PhishingGuard supplements keyword and link analysis with a set of heuristic rules designed to capture stylistic patterns that are frequently found in phishing attempts. These rules focus on the excessive use of exclamation marks and the overuse of capital letters, both of which are common techniques employed by attackers to create urgency and pressure the user into taking immediate action. Each heuristic is measured using ratio-based formulas or burst detection to ensure that suspicious behavior is flagged without unfairly penalizing ordinary communication.  

Exclamation marks are a common tool used by attackers to manufacture urgency. PhishingGuard evaluates both the longest run of consecutive exclamations in a message and the overall density of exclamation marks per hundred characters. By combining burst detection with density thresholds, the system can differentiate between normal punctuation (e.g., “Thanks!”) and manipulative emphasis (e.g., “ACT NOW!!!!!”).  

Capitalization is another strong indicator. Fraudulent emails often rely on ALL-CAPS words or long spans of uppercase text to create alarm. To measure this, PhishingGuard calculates the proportion of uppercase words relative to total words, while ignoring short acronyms such as “PDF,” “OTP,” or “USA.” It also tracks the longest uninterrupted sequence of uppercase words. This ensures that legitimate professional emphasis is tolerated, while messages dominated by shouting behavior are penalized.  

The thresholds and scoring logic are summarized in the table below:  

| Heuristic            | Measurement Formula                                    | Thresholds & Score Contribution          | Notes                                                                 |
|-----------------------|---------------------------------------------------------|------------------------------------------|----------------------------------------------------------------------|
| **Exclamation Marks** | - Burst = longest consecutive run of `!`  <br> - Density = (count of `!` / total characters) × 100 | Burst ≥ 3 → +3 points  <br> Burst ≥ 5 → +6 points  <br> Density ≥ 2/100 chars → +2 points  <br> Density ≥ 4/100 chars → +4 points  <br> **Max contribution: +6** | Uses max of burst vs. density. Short messages (<40 chars) require both burst and density to trigger. |
| **ALL-CAPS Usage**    | - Caps ratio = (uppercase words ≥4 chars / total eligible words)  <br> - Span = longest consecutive uppercase word run | Caps ratio ≥ 0.15 → +3 points  <br> Caps ratio ≥ 0.25 → +6 points  <br> Span ≥ 3 words → +3 points  <br> Span ≥ 5 words → +6 points  <br> **Max contribution: +6** | Ignores acronyms/brands (PDF, OTP, USA). Very short words (<4 chars) excluded. |
| **Combined Cap**      | style_points = min(12, exclam + caps)       | **Max contribution from style heuristics: +12** | Prevents stylistic rules from dominating link/keyword analysis. |




---

## 4. Scoring Mechanism  
Each detected feature contributes to an **overall score**.  

**Example scoring scheme:**  
- Suspicious keyword (ratio) → +10
- High risk keywords (regadless of ratio) → + 5  
- Suspicious link → +20 
- Known Malicious Link → + 100  
- Link shortener → +15  
- Generic greeting → +5  
- Whitelisted domain (trusted) → -20  

The **total score** reflects the number and severity of phishing indicators.  

Based on the score, the message is classified into **risk levels**:  

- **0–20 points → Low Risk (Safe)**  
- **21–40 points → Medium Risk (Suspicious)**  
- **>40 points → High Risk (Likely Phishing)**  

---

## 5. Result Interpretation  
The app presents results in a **clear and explainable format**:  

- **Overall Score** 
- **Risk Level** (Low / Medium / High).  
- **Triggered Explanations** showing why the score was assigned:  
  - “Suspicious keyword detected: *‘verify your account’* (+10)”  
  - “Shortened link found: *bit.ly* (+15)”  
  - “Knwon Malicous URL Found: *{url}* (+100)”  

This allows users to understand the decision and make an informed choice.  


## Limitations Regarding Embedded Links and Attachments  

While **PhishingGuard** currently focuses on text-based analysis and URL inspection within message bodies, our team recognizes that phishing attempts often exploit more complex vectors. Two notable areas that remain partially addressed in this version of the system are:  

1. **Embedded Links in Rich Content**  
   - Phishing links are not always visible in plain text. They may be hidden within HTML emails (e.g., in `<a href>` tags), markdown documents, or redirected through clickable elements. These embedded links can bypass simple keyword checks and pose a higher risk if not carefully inspected.  

2. **Attachments Containing Links**  
   - Attackers frequently embed malicious links inside attachments such as **PDFs, Word documents, spreadsheets, or even images** (via QR codes or screenshots). These sources can contain active hyperlinks or hidden references that are not immediately visible to the user.  

Although these aspects are not fully integrated into the current scope of the project, our team is aware of their significance. If project timelines and resources allow, we intend to extend PhishingGuard’s capability to include **attachment parsing and deeper embedded link analysis**. This would improve resilience against more sophisticated phishing attempts and bring the system closer to real-world applicability.  

---

# The Team

This project is being developed by a dedicated team of students:

- Ardıl Yüce
- Kartal Özbalkanlı
- Zeynep Zilan Turunç
- Utku Çağlar
- Arin Ikizogullari
- Ayberk Savaş
