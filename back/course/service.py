from sqlalchemy.ext.asyncio import AsyncSession
from .repository import CourseRepository

class CourseService:
    def __init__(self, db: AsyncSession):
        self.repository = CourseRepository()

    async def fetch_all_courses(self):
        return await self.repository.get_all_courses()

    async def fetch_course_details(self, course_id: int):
        return await self.repository.get_course_by_id(course_id)

    async def register_new_course(self, course_data: dict, instructor_id: str):
        course_data['instructor_id'] = instructor_id
        return await self.repository.create_course(course_data)
