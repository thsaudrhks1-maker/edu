from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from core.database import get_db
from .service import UserService
from .schema import UserCreate, UserResponse
from typing import List

router = APIRouter(prefix="/api/user", tags=["Users"])

@router.post("/signup")
async def signup(user: UserCreate, db: AsyncSession = Depends(get_db)):
    service = UserService(db)
    return await service.signup(user.model_dump())

@router.post("/login")
async def login(credentials: dict, db: AsyncSession = Depends(get_db)):
    service = UserService(db)
    return await service.login(credentials)
