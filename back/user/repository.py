from core.database import fetch_all, fetch_one, insert_and_return
from typing import Optional, List

class UserRepository:
    async def get_by_email(self, email: str) -> Optional[dict]:
        sql = "SELECT * FROM users WHERE email = :email"
        return await fetch_one(sql, {"email": email})

    async def get_by_id(self, user_id: int) -> Optional[dict]:
        sql = "SELECT * FROM users WHERE id = :id"
        return await fetch_one(sql, {"id": user_id})

    async def create_user(self, user_data: dict) -> dict:
        sql = """
            INSERT INTO users (email, hashed_password, name, role, is_active, created_at, updated_at)
            VALUES (:email, :hashed_password, :name, :role, :is_active, NOW(), NOW())
            RETURNING *
        """
        return await insert_and_return(sql, user_data)
    
    async def get_all_users(self) -> List[dict]:
        sql = "SELECT * FROM users ORDER BY created_at DESC"
        return await fetch_all(sql)
