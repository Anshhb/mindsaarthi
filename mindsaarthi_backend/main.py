from fastapi import FastAPI
from sentiment import analyze_sentiment
from risk import compute_risk, get_recommendation
from ai import get_ai_reply

app = FastAPI()

@app.get("/")
def home():
    return {"message": "Mindsaarthi backend running"}

@app.post("/chat")
async def chat(data: dict):
    text = data["text"]

    sentiment, score = analyze_sentiment(text)
    risk = compute_risk(text, sentiment)

    ai_data = get_ai_reply(text)

    return {
        "reply": ai_data.get("reply", "I am here for you."),
        "actions": ai_data.get("actions", []),
        "sentiment": sentiment,
        "confidence": score,
        "risk": risk
    }