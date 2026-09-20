# backend/main.py
import requests
from fastapi import FastAPI
from backend.database import db_session
from backend.config import settings

app = FastAPI(title="Scholr ID API", version="1.0.0")

@app.get("/health")
def health():
    with db_session() as conn:
        count = conn.execute("SELECT COUNT(*) FROM scholarships").fetchone()[0]
    
    llm_status = "missing"
    if settings.OPENAI_API_KEY and "PLACEHOLDER" not in settings.OPENAI_API_KEY:
        try:
            r = requests.post(
                f"{settings.OPENAI_BASE_URL}/chat/completions",
                headers={
                    "Authorization": f"Bearer {settings.OPENAI_API_KEY}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": settings.HERMES_MODEL,
                    "messages": [{"role": "user", "content": "hi"}],
                    "max_tokens": 5,
                    "stream": False
                },
                timeout=10
            )
            llm_status = "connected" if r.status_code == 200 else f"error_{r.status_code}"
        except Exception as e:
            llm_status = f"error: {str(e)[:50]}"
    
    return {
        "status": "ok",
        "scholarships_count": count,
        "llm_status": llm_status,
        "llm_model": settings.HERMES_MODEL
    }
