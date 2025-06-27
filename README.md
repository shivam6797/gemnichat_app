# 💬 GemniChat App

**GemniChat** is a modern, AI-powered chatbot application built with **Flutter** and integrated with **Google's Gemini API**. It simulates an intelligent chat experience with real-time responses from the Gemini model. This app showcases how to architect a scalable Flutter project using clean code principles, feature-based structure, and API integration with secure environment management.

---

## 🌟 What’s Inside?

This app demonstrates:

- 🧠 Integration with Gemini (Generative AI) API
- 🔐 Secure API key management using `.env` files
- 🧱 Clean architecture using feature-based folder structure
- 📦 State management using BLoC pattern
- 🎨 Responsive and intuitive UI built with Flutter
- 💾 Shared preferences for local storage
- 🚫 Proper use of `.gitignore` to avoid committing sensitive files like `.env`

---

## 📁 `.env.example` File

To keep your API keys safe, the app uses a `.env` file located in the `assets/` folder. The `.env.example` file is provided as a **template**. You must rename and fill in your own API key.

### Example:

assets/.env.example → rename to → .env
GEMINI_API_KEY=your_gemini_api_key_here

🚀 Features
✅ Gemini API integration (via secure .env)

✨ Real-time chat response from AI

📦 BLoC-based state management

💬 Beautiful chat UI with typing effects and error animations

🔧 Shared preferences helper for storing light user data

🧩 Modular codebase (easy to scale or maintain)

Clone the Repository
git clone https://github.com/shivam6797/gemnichat_app.git
cd gemnichat_app

Install Dependencies
flutter pub get

Run the App
flutter run

Folder Structure
lib/
├── app/                     # Main app configuration and routing
├── config/                  # Firebase and API config files
├── core/                    # Theme, shared helpers, error classes
├── features/
│   ├── auth/                # Authentication module (login, splash)
│   └── chat/                # Chat module (UI, BLoC, API integration)
├── main.dart                # App entry point
assets/
└── .env.example             # Sample .env file for your API key

🖼️ Screenshots
Coming Soon!

🤝 Contributing
  Contributions are welcome!
Feel free to open issues or submit PRs for bugs, new features, or improvements.

✨ Made with ❤️ by Shivam6797
