"""
Aura-Pet 配置管理模块
===========================
商用级密钥管理方案：
- 所有 API Keys 从环境变量读取
- 绝不在代码中硬编码任何密钥
- 支持 .env 本地开发和 GitHub Secrets 部署
"""

import os
import json
from typing import Optional


# ========== 兼容模式：支持或不支持 pydantic-settings ==========
try:
    from pydantic_settings import BaseSettings
    
    class Settings(BaseSettings):
        """应用配置 - 从环境变量加载"""
        database_url: str = "postgresql://aura_pet:aura_pet@localhost:5432/aura_pet"
        redis_url: str = "redis://localhost:6379"
        secret_key: str = "change-me-in-production"
        access_token_expire_minutes: int = 60 * 24 * 7
        stripe_api_key: Optional[str] = None
        stripe_webhook_secret: Optional[str] = None
        openai_api_key: Optional[str] = None
        gemini_api_key: Optional[str] = None
        environment: str = "development"
        debug: bool = True
        
        class Config:
            env_file = ".env"
            case_sensitive = False
    
    def get_settings() -> Settings:
        return Settings()

except ImportError:
    # Fallback: 不使用 pydantic-settings
    def get_settings():
        class Settings:
            database_url = os.getenv("DATABASE_URL", "postgresql://aura_pet:aura_pet@localhost:5432/aura_pet")
            redis_url = os.getenv("REDIS_URL", "redis://localhost:6379")
            secret_key = os.getenv("SECRET_KEY", "change-me-in-production")
            access_token_expire_minutes = 60 * 24 * 7
            stripe_api_key = os.getenv("STRIPE_API_KEY")
            stripe_webhook_secret = os.getenv("STRIPE_WEBHOOK_SECRET")
            openai_api_key = os.getenv("OPENAI_API_KEY")
            gemini_api_key = os.getenv("GEMINI_API_KEY")
            environment = os.getenv("ENVIRONMENT", "development")
            debug = os.getenv("DEBUG", "true").lower() == "true"
        return Settings()


def require_gemini_key() -> str:
    """
    获取 Gemini API Key（必须存在）
    用于需要 AI 功能的场景
    """
    key = os.getenv("GEMINI_API_KEY")
    if not key:
        raise ValueError(
            "❌ GEMINI_API_KEY 未设置！\n"
            "请设置环境变量：\n"
            "  本地: export GEMINI_API_KEY=你的Key\n"
            "  或在 .env 文件中添加: GEMINI_API_KEY=你的Key"
        )
    return key


def get_optional_gemini_key() -> Optional[str]:
    """
    获取 Gemini API Key（可选）
    用于 AI 功能可选的场景
    """
    return os.getenv("GEMINI_API_KEY") or os.getenv("GEMINI_API_KEY")


# ========== 环境变量检查工具 ==========

def check_required_env_vars() -> dict:
    """
    检查所有必需的环境变量
    返回检查结果字典
    """
    required = ["DATABASE_URL", "SECRET_KEY"]
    optional = ["GEMINI_API_KEY", "OPENAI_API_KEY", "STRIPE_API_KEY"]
    
    results = {
        "required": {},
        "optional": {},
        "all_passed": True
    }
    
    for var in required:
        value = os.getenv(var)
        results["required"][var] = bool(value)
        if not value:
            results["all_passed"] = False
    
    for var in optional:
        value = os.getenv(var)
        results["optional"][var] = bool(value)
    
    return results


if __name__ == "__main__":
    # 快速检查配置
    print("🔍 Aura-Pet 环境变量检查")
    print("=" * 40)
    
    results = check_required_env_vars()
    
    print("\n📌 必需变量:")
    for var, exists in results["required"].items():
        status = "✅" if exists else "❌"
        print(f"  {status} {var}")
    
    print("\n📌 可选变量:")
    for var, exists in results["optional"].items():
        status = "✅" if exists else "⚪"
        print(f"  {status} {var}")
    
    if results["all_passed"]:
        print("\n✅ 所有必需变量已设置！")
    else:
        print("\n⚠️ 部分必需变量未设置，请先配置！")
