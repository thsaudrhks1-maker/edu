from sqlalchemy.ext.asyncio import AsyncSession
from core.database import fetch_all, fetch_one, insert_and_return
from typing import List, Optional

class CourseRepository:
    """기존의 CRUD 로직 대신 core.database의 Raw SQL 비동기 함수를 직접 사용합니다."""
    
    async def get_all_courses(self) -> List[dict]:
        sql = "SELECT * FROM courses ORDER BY created_at DESC"
        return await fetch_all(sql)

    async def get_course_by_id(self, course_id: int) -> Optional[dict]:
        sql = "SELECT * FROM courses WHERE id = :id"
        return await fetch_one(sql, {"id": course_id})

    async def create_course(self, course_data: dict) -> dict:
        sql = """
            INSERT INTO courses (title, description, thumbnail_url, price, level, instructor_id, created_at)
            VALUES (:title, :description, :thumbnail_url, :price, :level, :instructor_id, NOW())
            RETURNING *
        """
        return await insert_and_return(sql, course_data)
