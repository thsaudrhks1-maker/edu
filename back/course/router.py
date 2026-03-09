from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from core.database import get_db
from .service import CourseService
from .schema import Course, CourseCreate
from typing import List

router = APIRouter(prefix="/api/courses", tags=["Courses"])

@router.get("/", response_model=List[Course])
async def read_courses(db: AsyncSession = Depends(get_db)):
    service = CourseService(db)
    return await service.fetch_all_courses()

@router.get("/{course_id}", response_model=Course)
async def read_course(course_id: int, db: AsyncSession = Depends(get_db)):
    service = CourseService(db)
    course = await service.fetch_course_details(course_id)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    return course

@router.post("/", response_model=int)
async def create_course(course: CourseCreate, db: AsyncSession = Depends(get_db)):
    service = CourseService(db)
    instructor_id = "temp-instructor-id" 
    return await service.register_new_course(course.model_dump(), instructor_id)
