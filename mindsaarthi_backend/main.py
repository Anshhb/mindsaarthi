from fastapi import FastAPI
from sentiment import analyze_sentiment
from risk import compute_risk, get_recommendation
from ai import get_ai_reply, get_journal_suggestions
from fastapi import File, UploadFile
from vision import analyze_face
from vision import analyze_video
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

@app.post("/analyze-face")
async def analyze_face_api(file: UploadFile = File(...)):
    contents = await file.read()
    result = analyze_face(contents)
    return result


@app.post("/analyze-video")
async def analyze_video_api(file: UploadFile = File(...)):
    contents = await file.read()
    result = analyze_video(contents)
    return result

@app.get("/journal-suggestions")
def journal_suggestions():
    suggestions = get_journal_suggestions()
    return {"suggestions": suggestions}

@app.get("/daily-thought")
def daily_thought():
    thought = get_ai_reply("Generate a short, simple, and inspiring thought of the day for mental health and self-reflection. Keep it under 20 words.")
    return {"thought": thought["reply"]}