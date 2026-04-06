#!/usr/bin/env python3
"""
Aura-Pet 安全配置验证脚本
===========================
检查所有必需的环境变量是否正确配置

使用方法:
    python scripts/check_config.py
"""

import os
import sys

def print_status(var_name: str, is_set: bool, hint: str = ""):
    """打印变量状态"""
    status = "✅" if is_set else "❌"
    value_display = "***已设置***" if is_set else "❌ 未设置"
    print(f"  {status} {var_name}: {value_display}")
    if hint and not is_set:
        print(f"     💡 {hint}")

def main():
    print("""
╔══════════════════════════════════════════════════════════════╗
║           🔐 Aura-Pet 安全配置验证                          ║
╚══════════════════════════════════════════════════════════════╝
""")
    
    # 检查必需变量
    print("📌 必需的环境变量:")
    print("-" * 50)
    
    required = {
        "DATABASE_URL": "postgresql://user:pass@host:5432/db",
        "SECRET_KEY": "随机密钥: python -c \"import secrets; print(secrets.token_urlsafe(32))\"",
    }
    
    all_required_set = True
    for var, hint in required.items():
        is_set = bool(os.getenv(var))
        print_status(var, is_set, hint)
        if not is_set:
            all_required_set = False
    
    # 检查 AI 服务（可选但推荐）
    print("\n📌 AI 服务密钥:")
    print("-" * 50)
    
    gemini_key = os.getenv("GEMINI_API_KEY")
    openai_key = os.getenv("OPENAI_API_KEY")
    
    print_status("GEMINI_API_KEY", bool(gemini_key), 
                 "获取地址: https://makersuite.google.com/app/apikey")
    print_status("OPENAI_API_KEY", bool(openai_key),
                 "获取地址: https://platform.openai.com/api-keys")
    
    # 检查可选变量
    print("\n📌 可选变量:")
    print("-" * 50)
    print_status("REDIS_URL", bool(os.getenv("REDIS_URL")), 
                 "默认: redis://localhost:6379")
    print_status("STRIPE_API_KEY", bool(os.getenv("STRIPE_API_KEY")),
                 "如需支付功能")
    
    # 总结
    print("\n" + "=" * 50)
    
    if all_required_set and gemini_key:
        print("✅ 所有关键配置已完成！可以启动服务了。")
        print("\n启动命令:")
        print("  cd backend")
        print("  uvicorn main:app --reload --port 8000")
    elif all_required_set:
        print("⚠️ 必需配置已完成，但缺少 Gemini API Key")
        print("   AI 识别功能将使用模拟数据。")
        print("\n   如需启用真实 AI 功能:")
        print("   1. 访问 https://makersuite.google.com/app/apikey")
        print("   2. 创建 API Key")
        print("   3. 执行: export GEMINI_API_KEY=你的Key")
    else:
        print("❌ 缺少必需配置！")
        print("\n请先创建 .env 文件:")
        print("  cp backend/.env.example backend/.env")
        print("  # 编辑 .env 填入你的配置")
    
    print("\n" + "=" * 50)

if __name__ == "__main__":
    main()
