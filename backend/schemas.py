from pydantic import BaseModel, EmailStr
from typing import Optional


# -------------------------
# REGISTER
# -------------------------
class RegisterRequest(BaseModel):
    name: str
    email: EmailStr
    password: str
    phone: Optional[str] = None


# -------------------------
# LOGIN
# -------------------------
class LoginRequest(BaseModel):
    email: EmailStr
    password: str


# -------------------------
# SUBJECT
# -------------------------
class SubjectRequest(BaseModel):
    name: str
    description: Optional[str] = None


# -------------------------
# NOTE
# -------------------------
class NoteRequest(BaseModel):
    title: str
    content: str


# -------------------------
# BOOKMARK
# -------------------------
class BookmarkRequest(BaseModel):
    title: str
    url: Optional[str] = None


# -------------------------
# STUDY PLANNER
# -------------------------
class TaskRequest(BaseModel):
    subject: str
    task: str
    date: str


# -------------------------
# QUIZ RESULT
# -------------------------
class QuizRequest(BaseModel):
    subject: str
    score: int
    total_questions: int


# -------------------------
# PROGRESS
# -------------------------
class ProgressRequest(BaseModel):
    subject: str
    progress: float
    study_hours: float


# -------------------------
# REMINDER
# -------------------------
class ReminderRequest(BaseModel):
    title: str
    reminder_time: str


# -------------------------
# AI CHAT
# -------------------------
class ChatRequest(BaseModel):
    message: str


# -------------------------
# SEARCH
# -------------------------
class SearchRequest(BaseModel):
    query: str