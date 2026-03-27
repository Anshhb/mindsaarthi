#  Mindsaarthi

A smart mental wellness application combining **AI conversation**, **mood tracking**, and **personal journaling** to support users in managing their mental health.

---

##  Features

* 💬 AI Chat Assistant (Gemini API)
* 📊 Mood & Risk Analytics (ML-based)
* 📝 Daily Journal (User-specific)
* 😊 Mood Check-in System
* 🔐 Firebase Authentication (Email + Google + Phone)
* ☁️ Firestore Database (User-specific data)

---

##  Tech Stack

###  Frontend (Flutter)

* Flutter + Riverpod (state management)
* GoRouter (navigation)
* Firebase Auth & Firestore
* Modern dark UI

###  Backend (FastAPI)

* FastAPI (Python)
* Sentiment Analysis Model
* Risk Detection Logic
* Gemini API (AI responses)

---

##  Project Structure

```
mindsaarthi/
├── frontend/ (Flutter App)
│   ├── lib/
│   ├── assets/
│   └── ...
├── backend/ (FastAPI Server)
│   ├── main.py
│   ├── ai.py
│   ├── sentiment.py
│   ├── risk.py
│   └── ...
```

---

##  Setup Instructions

###  Backend

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

Create `.env` file:

```
GEMINI_API_KEY=your_api_key
```

---

###  Frontend

```bash
cd frontend
flutter pub get
flutter run
```

Make sure Firebase is configured.

---

##  Firebase Setup

* Enable Authentication:

  * Email/Password
  * Google Sign-In
  * Phone Auth
* Create Firestore Database

---

##  Data Structure

```
users/{userId}/
  ├── chats/
  ├── journal/
  └── mood/
```

---

##  Purpose

This project aims to:

* Provide accessible mental health support
* Track emotional patterns
* Encourage self-reflection through journaling

---


