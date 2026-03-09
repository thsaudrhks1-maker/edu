from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import HTTPException, status
from .repository import UserRepository
from utils.security import get_password_hash, verify_password, create_access_token

class UserService:
    def __init__(self, db: AsyncSession = None):
        self.repository = UserRepository()

    async def signup(self, user_data: dict):
        # 1. 중복 이메일 체크
        existing_user = await self.repository.get_by_email(user_data['email'])
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="이미 사용 중인 이메일입니다."
            )

        # 2. 비밀번호 암호화
        user_data['hashed_password'] = get_password_hash(user_data['password'])
        del user_data['password']  # 평문 비밀번호 삭제
        
        # 3. 기본값 설정
        user_data.setdefault('role', 'student')
        user_data.setdefault('is_active', True)

        # 4. 저장
        new_user = await self.repository.create_user(user_data)
        return new_user

    async def login(self, credentials: dict):
        # 1. 사용자 조회
        user = await self.repository.get_by_email(credentials['email'])
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="이메일 또는 비밀번호가 올바르지 않습니다."
            )

        # 2. 비밀번호 검증
        if not verify_password(credentials['password'], user['hashed_password']):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="이메일 또는 비밀번호가 올바르지 않습니다."
            )

        # 3. 토큰 발급
        access_token = create_access_token(data={"sub": user['email'], "id": user['id']})
        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user": {
                "id": user['id'],
                "email": user['email'],
                "name": user['name'],
                "role": user['role']
            }
        }
