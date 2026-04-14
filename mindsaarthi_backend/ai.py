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


def get_journal_suggestions():
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key={API_KEY}"

    prompt = """
Generate 10 creative and thoughtful journal prompts for mental health and self-reflection. Each prompt should be a question that encourages deep thinking and emotional exploration. Each prompt should be brief, maximum 1-2 lines, and highly relevant.

Respond ONLY in valid JSON format.

Format:
{
  "suggestions": ["Prompt 1?", "Prompt 2?", "..."]
}
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
        return ["What made you smile today?", "How did you handle stress today?", "What are you grateful for?"]

    try:
        text = data["candidates"][0]["content"]["parts"][0]["text"]

        print("RAW TEXT:", text)

        text = re.sub(r"```json|```", "", text).strip()

        match = re.search(r"\{.*\}", text, re.DOTALL)
        if match:
            text = match.group()

        parsed = json.loads(text)

        return parsed.get("suggestions", ["What made you smile today?", "How did you handle stress today?", "What are you grateful for?"])

    except Exception as e:
        print("PARSE ERROR:", e)
        return ["What made you smile today?", "How did you handle stress today?", "What are you grateful for?"]
        
