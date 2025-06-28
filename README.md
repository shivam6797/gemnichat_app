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
<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/45383516-46c5-4e02-bf00-3ef3a824e777" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/935ec7c4-92dd-4c7a-a445-d708136ca6e5" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/dcfbbc05-ea26-4ddc-a0ea-6715ba32d7d9" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/2967b09b-9771-4d79-a447-4c56f872aa68" width="250" /></td>    
  </tr>
   <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/be6fbecf-090e-49c2-845d-bab0cbacc333" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/6023d8f0-261d-47d4-87d4-3fd4c3b8354e" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/674e3c6e-6a50-4643-abc5-4daeff06c88c" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/ef38d347-157b-49fc-91d0-6d66d6be4f38" width="250" /></td>    
  </tr>
  <tr>
     <td align="center"><img src="https://github.com/user-attachments/assets/0b53e665-a4d3-4a64-afa5-5a9a068b42d9" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/0e2ae6af-5248-458f-b256-a473c3884a67" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/5a144f5a-e1a8-4cae-8872-50e8b6ea7906" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/a05abd2d-9c71-4aad-afd8-fb75651424c3" width="250" /></td>
  </tr>
    <tr>
     <td align="center"><img src="https://github.com/user-attachments/assets/29d149a4-d0e9-4763-ae18-648e01f7963f" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/e5f0f253-1e00-41c2-9129-8cf1c13b78f1" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/ec6bdd9b-15e0-4b2d-9987-42bf2e3f6284" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/74269ff9-6b42-42e5-a369-0640e8edbb99" width="250" /></td>
  </tr>
    <tr>
     <td align="center"><img src="https://github.com/user-attachments/assets/bb2b9633-fbb7-4030-9291-dbb6bd223296" width="250" /></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/3d5144ed-19b3-41b6-bb72-947766a580d9" width="250" /></td>
  </tr>
</table>

🤝 Contributing
  Contributions are welcome!
Feel free to open issues or submit PRs for bugs, new features, or improvements.

✨ Made with ❤️ by Shivam6797
