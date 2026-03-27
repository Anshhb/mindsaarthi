def compute_risk(text, sentiment):
    risk = 0

    if sentiment == "NEGATIVE":
        risk += 2

    crisis_words = ["suicide", "kill myself", "die", "hopeless"]

    for word in crisis_words:
        if word in text.lower():
            risk += 5

    return risk

def get_recommendation(sentiment, risk):
    if risk >= 5:
        return "Please contact a helpline or trusted person."

    if sentiment == "NEGATIVE":
        return "Try journaling, breathing exercises, or a short walk."

    return "Maintain your positive routine and stay consistent."