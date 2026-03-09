from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from course import router as course_router
from user import router as user_router
import uvicorn

app = FastAPI(title="P6IX Premium E-Learning (Flat Async)")

# CORS settings
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3700",
        "http://127.0.0.1:3700",
        "http://localhost:5173", # Vite default
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Domain Routers
app.include_router(course_router.router)
app.include_router(user_router.router)

@app.get("/")
async def root():
    return {"status": "ok", "message": "P6IX Flat Architecture Backend is Running"}

if __name__ == "__main__":
    import os
    port = int(os.getenv("BACKEND_PORT", 8700))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=True)
