import os

import cv2
from flask.cli import load_dotenv
import numpy as np
import requests
from deepface import DeepFace

def analyze_face(image_bytes):
    try:
        nparr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        result = DeepFace.analyze(
            img,
            actions=["emotion"],
            enforce_detection=False
        )

        emotion = result[0]["dominant_emotion"]
        confidence = max(result[0]["emotion"].values())

        suggestion = get_ai_suggestion(emotion)

        return {
            "emotion": emotion,
            "confidence": float(confidence),
            "suggestion": suggestion
        }

    except:
        return {
            "emotion": "unknown",
            "confidence": 0,
            "suggestion": "Try again with a clearer image."
        }

def get_suggestion(emotion):
    mapping = {
        "happy": "Keep spreading positivity 😊",
        "sad": "Talk to someone you trust 💙",
        "angry": "Take deep breaths and pause 🔴",
        "fear": "Ground yourself, you're safe 🟡",
        "surprise": "Take a moment to process 🤍",
        "neutral": "Stay balanced and mindful ⚖️"
    }

    return mapping.get(emotion, "Take care of yourself ❤️")


def analyze_video(video_bytes):
    import tempfile

    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as temp:
            temp.write(video_bytes)
            video_path = temp.name

        cap = cv2.VideoCapture(video_path)

        emotions = []

        frame_count = 0

        while True:
            ret, frame = cap.read()
            if not ret:
                break

            frame_count += 1

            if frame_count % 10 != 0:
                continue

            try:
                result = DeepFace.analyze(
                    frame,
                    actions=["emotion"],
                    enforce_detection=False
                )

                emotion = result[0]["dominant_emotion"]
                emotions.append(emotion)

            except:
                continue

        cap.release()

        if not emotions:
            return {
                "emotion": "unknown",
                "confidence": 0,
                "suggestion": "No face detected clearly."
            }

        from collections import Counter

        most_common = Counter(emotions).most_common(1)[0][0]

        suggestion = get_ai_suggestion(most_common)

        return {
            "emotion": most_common,
            "confidence": round(len([e for e in emotions if e == most_common]) / len(emotions), 2),
            "suggestion": suggestion
        }

    except Exception as e:
        return {
            "emotion": "error",
            "confidence": 0,
            "suggestion": "Video processing failed."
        }
    

load_dotenv()
API_KEY = os.getenv("GEMINI_API_KEY")


def get_ai_suggestion(emotion):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key={API_KEY}"

    prompt = f"""
    You are a mental wellness assistant.

    Detected emotion: {emotion}

    Give a short, supportive suggestion (max 12 words).
    Keep it calm, helpful, and human-like.

    Only return plain text. No JSON.
    """

    try:
        response = requests.post(url, json={
            "contents": [{"parts": [{"text": prompt}]}]
        })

        data = response.json()

        return data["candidates"][0]["content"]["parts"][0]["text"]

    except:
        return "Take a deep breath and relax."