# main.py
from fastapi import FastAPI
from app.routers import auth, users, drinks, cafes, likes, consumptions
from app.dependencies import init_db

app = FastAPI()

app.include_router(auth.router)
app.include_router(users.router)
app.include_router(drinks.router)
app.include_router(cafes.router)
app.include_router(likes.router)
app.include_router(consumptions.router)

@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/")
async def root():
    return {"message": "Welcome to Suguard!"}
