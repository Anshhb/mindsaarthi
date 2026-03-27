import json
import requests
import os
import re
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("GEMINI_API_KEY")


def get_ai_reply(user_input):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key={API_KEY}"

    prompt = f"""
You are a mental health assistant.

User: {user_input}

Respond ONLY in valid JSON format.

Format:
{{
  "reply": "...",
  "actions": ["...", "...", "..."]
}}
"""

    response = requests.post(
        url,
        json={
            "contents": [{"parts": [{"text": prompt}]}]
        }
    )

    data = response.json()

    print("FULL GEMINI RESPONSE:", data)  

    if "error" in data:
        print("API ERROR:", data["error"])
        return {
            "reply": "AI service unavailable right now.",
            "actions": ["Try again later"]
        }

    try:
        text = data["candidates"][0]["content"]["parts"][0]["text"]

        print("RAW TEXT:", text)

        text = re.sub(r"```json|```", "", text).strip()

        match = re.search(r"\{.*\}", text, re.DOTALL)
        if match:
            text = match.group()

        parsed = json.loads(text)

        return {
            "reply": parsed.get("reply", "I am here for you."),
            "actions": parsed.get("actions", [])
        }

    except Exception as e:
        print("PARSE ERROR:", e)
        return {
            "reply": "I am here for you.",
            "actions": ["Take a deep breath", "Drink water"]
        }