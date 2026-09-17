import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    APP_ENV = os.getenv("APP_ENV", "development")
    PORT = int(os.getenv("PORT", 8000))
    DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///data/scholr.db")
    NVIDIA_NIM_API_KEY = os.getenv("NVIDIA_NIM_API_KEY", "")
    NIM_BASE_URL = os.getenv("NIM_BASE_URL", "https://integrate.api.nvidia.com/v1")
    NIM_MODEL_NAME = os.getenv("NIM_MODEL_NAME", "nvidia/nemotron-3-super-120b-a12b")
    TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")

settings = Settings()
