# backend/main.py
from fastapi import FastAPI
from backend.database import db_session
from backend.config import settings

app = FastAPI(title="Scholr ID API", version="1.0.0")

@app.get("/health")
def health():
    with db_session() as conn:
        count = conn.execute("SELECT COUNT(*) FROM scholarships").fetchone()[0]
    
    nim_status = "placeholder" if "PLACEHOLDER" in settings.NVIDIA_NIM_API_KEY else "configured"
    
    return {
        "status": "ok",
        "scholarships_count": count,
        "nim_api_key": nim_status
    }
