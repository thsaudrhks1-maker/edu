from fastapi import HTTPException, status

class P6IXException(Exception):
    """기본 예외 클래스"""
    def __init__(self, message: str, code: int = 500):
        self.message = message
        self.code = code

class PaymentException(P6IXException):
    """결제 관련 예외"""
    pass

class AuthException(P6IXException):
    """인증 관련 예외"""
    pass

def raise_http_exception(message: str, status_code: int = status.HTTP_400_BAD_REQUEST):
    raise HTTPException(status_code=status_code, detail=message)
