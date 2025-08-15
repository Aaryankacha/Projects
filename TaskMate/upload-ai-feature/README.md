
# 📦 TaskMate Backend – Upload & TaskPilot AI Chatbot

This folder contains the **Flask backend** for TaskMate’s file upload system and the **TaskPilot AI assistant**.

---

## 🚀 Features

* **📤 File Upload API** – Upload files (attachments, images, documents) to the server.
* **🤖 TaskPilot AI API** – Ask questions and get AI-powered answers using [OpenRouter](https://openrouter.ai/) models.
* **📂 File Serving** – Download uploaded files via generated URLs.
* **🌐 CORS Enabled** – Safe communication with the Flutter frontend.

---

## 📁 API Endpoints

### 1️⃣ Upload File

**POST** `/upload`

* **Body:** Multipart form-data with key `file`
* **Returns:** JSON with the file’s URL
* **Example Response:**

```json
{
  "url": "/uploads/filename.png"
}
```

### 2️⃣ Serve Uploaded Files

**GET** `/uploads/<filename>`

* Fetches the uploaded file from the server.

### 3️⃣ Ask TaskPilot

**POST** `/ask`

* **Body (JSON):**

```json
{
  "prompt": "What tasks do I have today?"
}
```

* **Returns:** AI-generated response from TaskPilot.

---

## ⚙️ Setup

1. **Install dependencies:**

```bash
pip install flask flask-cors python-dotenv requests werkzeug
```

2. **Create `.env` file:**

```env
OPENROUTER_API_KEY=your_api_key_here
```

3. **Run the server:**

```bash
python app.py
```

4. **Access in browser:**

```
http://localhost:3000
```

---

## 📌 Notes

* This backend **only** handles uploads and AI responses – no authentication or database is included here.
* You **must** set your own `OPENROUTER_API_KEY` in the `.env` file.
* The AI model used here: `mistralai/mistral-7b-instruct`.

---

