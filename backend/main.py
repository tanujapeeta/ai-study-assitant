from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from database import Base, engine
import models

from routes.auth_routes import router as auth_router


# Create database tables
Base.metadata.create_all(bind=engine)


# Create FastAPI application
app = FastAPI(
    title="AI Study Assistant API",
    description="Backend API for AI Study Assistant App",
    version="1.0.0"
)


# Allow Flutter application to access backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Register authentication routes
app.include_router(auth_router)


# Home API
@app.get("/")
def home():
    return {
        "message": "AI Study Assistant Backend is running",
        "status": "success"
    }