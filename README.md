
# 💧 JalRakshak: Smart Water Quality & AI Prescriptive System

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![ESP32](https://img.shields.io/badge/ESP32-000000?style=for-the-badge&logo=espressif&logoColor=white)

**JalRakshak** (Water Protector) is an enterprise-grade Cyber-Physical System built to combat water contamination. It bridges Edge IoT hardware, Cloud computing, and Machine Learning to not only monitor water quality in real-time but to dynamically classify its safety and prescribe specific chemical or physical treatments.

## 🌟 The 3 Pillars of Novelty
Unlike standard binary (Safe/Unsafe) water monitors, JalRakshak introduces three advanced engineering concepts:
1. **Multi-Purpose Classification (Triage):** Actively categorizes water into utility tiers (Drinking, Irrigation, Cleaning, or Critical).
2. **Prescriptive Analytics:** An AI engine that detects chemical/physical imbalances and prescribes real-world solutions (e.g., advising *Reverse Osmosis* for high TDS, or *Alum* for high Turbidity).
3. **Cost-Optimized Engineering:** Proving that high diagnostic accuracy can be achieved with a reduced, affordable sensor array for rural deployment.

---

## 🏗️ System Architecture
JalRakshak is a distributed full-stack system divided into four layers:
* **The Edge (Hardware):** ESP32 Microcontroller reading pH, TDS, and Turbidity.
* **The Bridge (Cloud):** Node.js & Firebase Realtime Database.
* **The Brain (AI):** Python-based Random Forest Classifier trained on WHO/BIS limits.
* **The Face (Mobile App):** A Flutter application utilizing Clean Architecture and Riverpod for reactive state management.

### Flutter App Clean Architecture (Current Repo)
```text
lib/
├── core/                  # Theme, Constants, Shared Resources
├── data/                  # API Clients, JSON Models, Repositories
├── domain/                # Business Logic, Entities, Use Cases
├── presentation/          # Riverpod Providers, Screens, UI Widgets
└── main.dart              # Application Entry Point
