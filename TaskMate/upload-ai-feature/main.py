from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from werkzeug.utils import secure_filename
import requests
import os
from dotenv import load_dotenv

load_dotenv()
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


@app.route("/upload", methods=["POST", "OPTIONS"])
def upload_file():
    if request.method == "OPTIONS":
        return '', 200

    if "file" not in request.files:
        return jsonify({"error": "No file part in request"}), 400

    file = request.files["file"]
    if file.filename == "":
        return jsonify({"error": "No file selected"}), 400

    filename = secure_filename(file.filename or "unnamed_file")
    file_path = os.path.join(UPLOAD_FOLDER, filename)
    file.save(file_path)

    return jsonify({"url": f"/uploads/{filename}"}), 200

@app.route("/uploads/<filename>")
def serve_file(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)


@app.route("/ask", methods=["POST"])
def ask_taskpilot():
    prompt = request.get_json().get("prompt", "")
    if not prompt:
        return jsonify({"error": "Prompt is missing"}), 400

    try:
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {OPENROUTER_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": "mistralai/mistral-7b-instruct", 
                "messages": [
                    {"role": "system", "content": "You are TaskPilot, a helpful assistant."},
                    {"role": "user", "content": prompt}
                ]
            }
        )

        response.raise_for_status()
        data = response.json()
        reply = data["choices"][0]["message"]["content"]
        return jsonify({"response": reply})

    except Exception as e:
        return jsonify({"error": f"TaskPilot Error: {str(e)}"}), 500

@app.route("/")
def home():
    return "✅ TaskMate backend is running!"

    


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
