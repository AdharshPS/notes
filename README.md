# 📝 Notes App (Flutter)

A clean and simple **Notes application built with Flutter**, following **Clean Architecture** principles and using **Hive** for local storage.


## 📦 Downloads

👉 [Download latest version](https://github.com/AdharshPS/notes/releases/latest)


---

## 🚀 Features

- ✏️ Create, edit, and delete notes
- 🎨 Color-coded notes
- 💾 Offline-first (Hive local database)
- 🧱 Clean Architecture (Domain / Data / Presentation)
- 🔄 State management with Provider
- 📤 Share notes via system share sheet
- ⚙️ CI/CD with GitHub Actions

---

## 🏗️ Architecture

The app follows **Clean Architecture**:

```md

lib/
├── features/
│ └── notes/
│ ├── domain/
│ │ ├── entities/
│ │ ├── repositories/
│ │ └── usecases/
│ ├── data/
│ │ ├── models/
│ │ ├── datasources/
│ │ └── repositories/
│ └── presentation/
│ ├── pages/
│ └── providers/

```

## 🧰 Tech Stack

- **Flutter** (Dart)
- **Hive** – Local database
- **Provider** – State management
- **share_plus** – Sharing notes
- **GitHub Actions** – CI/CD

---



## ▶️ Getting Started

### Prerequisites
- Flutter SDK `>= 3.22.0`
- Dart SDK
- Android Studio / VS Code

---

### Clone the repository

```bash
git clone https://github.com/your-username/notes-app.git
cd notes-app

flutter pub get

flutter run

```

🧪 CI/CD

This project uses GitHub Actions for CI/CD.

CI

Runs on every push and pull_request

Includes:

flutter analyze

flutter test

Debug build

CD

Triggered when a version tag is pushed (e.g. v1.0.0)

Builds a release APK

Publishes it to GitHub Releases


git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0


📦 Download

Release APKs are available under
GitHub → Releases

---

📌 Future Improvements

- App lock (PIN / Biometrics)

- todo and notification

- Cloud sync

- Search & filter notes

- More test coverage


---

👨‍💻 Author

Adharsh P S
Flutter Developer

GitHub: https://github.com/AdharshPS/

LinkedIn: https://www.linkedin.com/in/adharshzps/


📄 License

This project is licensed under the MIT License.

---

# 4️⃣ Now let’s TEACH you how this works (important)

## 🧠 Markdown basics you must know

### Headings
```md
# Big
## Medium
### Small


**bold**
*italic*


- Item
- Item


🚀 📝 🎨
