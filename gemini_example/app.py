from flask import Flask, request, jsonify, render_template
import base64
import requests
import os

# Lese AUTH_TOKEN und PROJECT_ID aus Umgebungsvariablen
AUTH_TOKEN = os.getenv('AUTH_TOKEN')
PROJECT_ID = os.getenv('PROJECT_ID')

app = Flask(__name__)


@app.route('/')
def index():
    return render_template("index.html")

@app.route('/upload', methods=['POST'])
def upload():
    if 'file' not in request.files:
        return jsonify({'error': 'Keine Datei gefunden'}), 400
    
    file = request.files['file']
    # Bild in Base64 umwandeln
    file_bytes = file.read()
    encoded_image = base64.b64encode(file_bytes).decode('utf-8')
    
    # API URL und Token anpassen
    api_url = f"https://us-central1-aiplatform.googleapis.com/v1/projects/{PROJECT_ID}/locations/us-central1/publishers/google/models/gemini-1.0-pro-vision:streamGenerateContent"
    
    headers = {
        "Authorization": f"Bearer {AUTH_TOKEN}",
        "Content-Type": "application/json; charset=utf-8",
    }
    data = {
      "contents": {
        "role": "USER",
        "parts": [
          {
            "inlineData": {
              "mimeType": file.mimetype,  # z.B. "image/jpeg"
              "data": encoded_image
            }
          },
          {
            "text": "Describe this picture."
          }
        ]
      },
      "safety_settings": {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_LOW_AND_ABOVE"
      },
      "generation_config": {
        "temperature": 0.4,
        "topP": 1.0,
        "topK": 32,
        "maxOutputTokens": 2048
      }
    } 
 
    response = requests.post(api_url, json=data, headers=headers)
    
    if response.status_code == 200:
        api_response = response.json()  # Ersetze dies mit dem tatsächlichen Aufruf der API und der Antwortverarbeitung
        try:
            # Gehe davon aus, dass die API mehrere Kandidaten zurückgeben kann und wir die Beschreibung aus dem ersten nehmen
            description = api_response[0]['candidates'][0]['content']['parts'][0]['text']
            return description  # Direkte Rückgabe der Beschreibung als String
        except (IndexError, KeyError) as e:
            return 'Fehler beim Extrahieren der Beschreibung aus der API-Antwort'  # Fehler-String Rückgabe
    else:
        print(response.content)
        return 'Fehler bei der Verarbeitung der Anfrage'  # Fehler-String Rückgabe


if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)

