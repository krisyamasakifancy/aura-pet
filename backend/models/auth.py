"""
Aura-Pet Backend - Authentication & Authorization
JWT-based authentication with bcrypt password hashing
"""

from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel, EmailStr
from sqlalchemy.orm import Session

from .models.database import get_db, UserRepository
from .models.models import User

# ============================================
# SECURITY CONFIGURATION
# ============================================

SECRET_KEY = "aura-pet-secret-key-change-in-production-2024"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7  # 7 days

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()

# ============================================
# PYDANTIC MODELS
# ============================================

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    user_id: Optional[str] = None
    email: Optional[str] = None

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    display_name: Optional[str] = None

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: str
    email: str
    display_name: Optional[str]
    bitecoins: int
    subscription_tier: str
    current_streak: int
    total_meals_logged: int
    
    class Config:
        from_attributes = True

class PasswordReset(BaseModel):
    email: EmailStr

class PasswordChange(BaseModel):
    old_password: str
    new_password: str

# ============================================
# PASSWORD UTILITIES
# ============================================

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against its hash."""
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    """Hash a password."""
    return pwd_context.hash(password)

# ============================================
# JWT UTILITIES
# ============================================

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """Create a JWT access token."""
    to_encode = data.copy()
    
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def decode_token(token: str) -> Optional[TokenData]:
    """Decode and validate a JWT token."""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        email: str = payload.get("email")
        
        if user_id is None:
            return None
        
        return TokenData(user_id=user_id, email=email)
    except JWTError:
        return None

# ============================================
# AUTHENTICATION DEPENDENCY
# ============================================

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    """
    FastAPI dependency to get the current authenticated user.
    Raises 401 if not authenticated.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    token = credentials.credentials
    token_data = decode_token(token)
    
    if token_data is None:
        raise credentials_exception
    
    user_repo = UserRepository(db)
    user = user_repo.get_by_id(User, token_data.user_id)
    
    if user is None:
        raise credentials_exception
    
    return user

async def get_current_user_optional(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(HTTPBearer(auto_error=False)),
    db: Session = Depends(get_db)
) -> Optional[User]:
    """
    FastAPI dependency to get the current user if authenticated.
    Returns None if not authenticated (doesn't raise error).
    """
    if credentials is None:
        return None
    
    token = credentials.credentials
    token_data = decode_token(token)
    
    if token_data is None:
        return None
    
    user_repo = UserRepository(db)
    return user_repo.get_by_id(User, token_data.user_id)

# ============================================
# PREMIUM FEATURE CHECK
# ============================================

async def require_premium(user: User = Depends(get_current_user)) -> User:
    """Require user to have premium subscription."""
    if not user.is_premium:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This feature requires a premium subscription"
        )
    return user

# ============================================
# AUTH SERVICE
# ============================================

class AuthService:
    """Authentication service for user registration and login."""
    
    def __init__(self, db: Session):
        self.db = db
        self.user_repo = UserRepository(db)
    
    def register(self, user_data: UserCreate) -> tuple[User, str]:
        """
        Register a new user.
        Returns (user, access_token)
        Raises HTTPException if email already exists.
        """
        # Check if email exists
        existing = self.user_repo.get_by_email(user_data.email)
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
        
        # Create user
        hashed_password = get_password_hash(user_data.password)
        user = User(
            email=user_data.email,
            password_hash=hashed_password,
            display_name=user_data.display_name or user_data.email.split("@")[0]
        )
        
        # Create default pet
        from .models.models import Pet, PetSpecies, PetAppearance
        from .models.models import get_db as get_db_func
        
        user = self.user_repo.create(user)
        
        # Create default pet
        pet = Pet(
            user_id=user.id,
            name="小浣熊",
            species=PetSpecies.RACCOON
        )
        pet = db.merge(pet)  # Add to session
        db.commit()
        
        # Create default appearance
        appearance = PetAppearance(pet_id=pet.id)
        db.add(appearance)
        db.commit()
        
        # Generate token
        access_token = create_access_token(
            data={"sub": str(user.id), "email": user.email}
        )
        
        return user, access_token
    
    def login(self, login_data: UserLogin) -> tuple[User, str]:
        """
        Authenticate user and return token.
        Returns (user, access_token)
        Raises HTTPException if credentials invalid.
        """
        user = self.user_repo.get_by_email(login_data.email)
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password"
            )
        
        if not verify_password(login_data.password, user.password_hash):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password"
            )
        
        access_token = create_access_token(
            data={"sub": str(user.id), "email": user.email}
        )
        
        return user, access_token
    
    def change_password(self, user: User, password_data: PasswordChange) -> bool:
        """Change user's password."""
        if not verify_password(password_data.old_password, user.password_hash):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Incorrect old password"
            )
        
        user.password_hash = get_password_hash(password_data.new_password)
        self.user_repo.update(user)
        return True

# ============================================
# DEMO USER HELPERS (for testing)
# ============================================

DEMO_USERS = {
    "demo@aura-pet.com": {
        "id": "demo-user-001",
        "email": "demo@aura-pet.com",
        "password": "demo123",
        "display_name": "Demo User",
        "bitecoins": 150,
        "subscription_tier": "free",
        "current_streak": 5,
        "total_meals_logged": 23
    }
}

async def get_demo_user() -> dict:
    """Get demo user for testing without database."""
    return DEMO_USERS["demo@aura-pet.com"].copy()

def create_demo_token() -> str:
    """Create a demo token for testing."""
    return create_access_token(
        data={"sub": "demo-user-001", "email": "demo@aura-pet.com"}
    )
