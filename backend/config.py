# backend/config.py
import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    APP_ENV = os.getenv("APP_ENV", "development")
    PORT = int(os.getenv("PORT", 8000))
    DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///data/scholr.db")
    
    # LLM via 9router (dari panitia)
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
    OPENAI_BASE_URL = os.getenv("OPENAI_BASE_URL", "https://9router.jcamp.io/v1")
    HERMES_MODEL = os.getenv("HERMES_MODEL", "openrouter/nvidia/nemotron-3-super-120b-a12b:free")
    
    TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")

settings = Settings()
