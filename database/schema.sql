-- ============================================
-- AURA-PET: 完整数据库 Schema
-- PostgreSQL + Redis
-- ============================================

-- ========== 用户表 ==========
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- 基础信息
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    avatar_url TEXT,
    
    -- 用户画像
    height_cm DECIMAL(5,2),           -- 身高 (cm)
    weight_kg DECIMAL(5,2),           -- 体重 (kg)
    age INTEGER,                       -- 年龄
    gender VARCHAR(10),                -- male/female/other
    activity_level VARCHAR(20),        -- sedentary/light/moderate/active/very_active
    fitness_goal VARCHAR(20),          -- lose_fat/gain_muscle/maintain
    
    -- 计算字段 (自动更新)
    bmr DECIMAL(8,2),                 -- 基础代谢率 (Mifflin-St Jeor)
    tdee DECIMAL(8,2),                -- 每日总消耗
    
    -- 设置
    language VARCHAR(10) DEFAULT 'zh-CN',
    currency VARCHAR(10) DEFAULT 'CNY',
    timezone VARCHAR(50) DEFAULT 'Asia/Shanghai',
    
    -- 订阅
    subscription_tier VARCHAR(20) DEFAULT 'free',  -- free/premium/enterprise
    subscription_expires_at TIMESTAMP,
    
    -- 时间戳
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 状态
    is_verified BOOLEAN DEFAULT FALSE,
    is_premium BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- ========== 宠物表 ==========
CREATE TABLE IF NOT EXISTS pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 宠物基本信息
    name VARCHAR(50) NOT NULL DEFAULT '毛毛',
    species VARCHAR(50) DEFAULT 'raccoon',     -- raccoon/cat/dragon
    evolution_stage VARCHAR(20) DEFAULT 'baby',  -- baby/child/teen/adult
    
    -- 数值
    level INTEGER DEFAULT 1,
    xp INTEGER DEFAULT 0,
    xp_to_next INTEGER DEFAULT 100,
    coins INTEGER DEFAULT 100,
    joy INTEGER DEFAULT 80,
    fullness INTEGER DEFAULT 70,
    water_intake INTEGER DEFAULT 0,
    water_goal INTEGER DEFAULT 2000,
    streak_days INTEGER DEFAULT 0,
    meals_today INTEGER DEFAULT 0,
    
    -- 外观
    nutrition_balance DECIMAL(3,2) DEFAULT 0,  -- -1 到 1
    equipped_item_id VARCHAR(50),
    background_id VARCHAR(50),
    aura_color VARCHAR(20) DEFAULT 'pink',
    
    -- 状态
    mood VARCHAR(20) DEFAULT 'happy',
    last_fed_at TIMESTAMP,
    last_interaction_at TIMESTAMP,
    
    -- 时间戳
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id)
);

CREATE INDEX idx_pets_user_id ON pets(user_id);

-- ========== 餐食记录表 ==========
CREATE TABLE IF NOT EXISTS meal_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    pet_id UUID REFERENCES pets(id),
    
    -- 食物信息
    food_name VARCHAR(255) NOT NULL,
    food_emoji VARCHAR(50),
    food_category VARCHAR(50),              -- dessert/main/fast/healthy/drinks/snacks
    
    -- 营养数据
    calories INTEGER,
    protein_grams DECIMAL(6,2),
    carbs_grams DECIMAL(6,2),
    fat_grams DECIMAL(6,2),
    fiber_grams DECIMAL(6,2),
    sodium_mg DECIMAL(8,2),
    
    -- Aura-Pet 特色
    aura_score DECIMAL(4,1),               -- 综合评分 0-100
    anxiety_label VARCHAR(100),            -- 去焦虑标签
    phrases TEXT[],                        -- 小浣熊说的话
    
    -- 来源
    source VARCHAR(20) DEFAULT 'manual',   -- manual/barcode/ai
    barcode VARCHAR(100),
    image_url TEXT,
    
    -- 奖励
    coins_earned INTEGER DEFAULT 0,
    xp_earned INTEGER DEFAULT 0,
    
    -- 时间
    meal_type VARCHAR(20),                 -- breakfast/lunch/dinner/snack
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_meal_logs_user_id ON meal_logs(user_id);
CREATE INDEX idx_meal_logs_logged_at ON meal_logs(logged_at);
CREATE INDEX idx_meal_logs_meal_type ON meal_logs(meal_type);

-- ========== 每日统计表 ==========
CREATE TABLE IF NOT EXISTS daily_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    date DATE NOT NULL,
    
    -- 摄入统计
    total_calories INTEGER DEFAULT 0,
    total_protein DECIMAL(8,2) DEFAULT 0,
    total_carbs DECIMAL(8,2) DEFAULT 0,
    total_fat DECIMAL(8,2) DEFAULT 0,
    
    meals_count INTEGER DEFAULT 0,
    water_intake INTEGER DEFAULT 0,
    
    -- 宠物数据
    pet_joy_avg INTEGER DEFAULT 0,
    pet_fullness_avg INTEGER DEFAULT 0,
    streak_continued BOOLEAN DEFAULT FALSE,
    
    -- Aura Score
    avg_aura_score DECIMAL(4,1) DEFAULT 0,
    
    -- 时间戳
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, date),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_daily_stats_user_date ON daily_stats(user_id, date);

-- ========== 订阅表 ==========
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    tier VARCHAR(20) NOT NULL,             -- free/premium/enterprise
    status VARCHAR(20) NOT NULL,          -- active/cancelled/expired/past_due
    
    -- 支付信息
    payment_provider VARCHAR(20),          -- stripe/apple/google
    payment_id VARCHAR(255),
    price_cents INTEGER,
    currency VARCHAR(10) DEFAULT 'USD',
    
    -- 时间
    starts_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    current_period_start TIMESTAMP,
    current_period_end TIMESTAMP,
    cancelled_at TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========== 商品表 ==========
CREATE TABLE IF NOT EXISTS shop_items (
    id VARCHAR(50) PRIMARY KEY,
    
    name VARCHAR(100) NOT NULL,
    description TEXT,
    emoji VARCHAR(50),
    category VARCHAR(30) NOT NULL,          -- accessories/backgrounds/effects/frames
    
    price_cents INTEGER NOT NULL,
    price_coins INTEGER,                    -- 如果可以用游戏币购买
    currency VARCHAR(10) DEFAULT 'USD',
    
    -- 稀有度
    rarity VARCHAR(20) DEFAULT 'common',   -- common/rare/epic/legendary/limited
    available_from TIMESTAMP,
    available_until TIMESTAMP,
    
    -- 预览
    preview_url TEXT,
    thumbnail_url TEXT,
    
    -- 状态
    is_active BOOLEAN DEFAULT TRUE,
    is_limited BOOLEAN DEFAULT FALSE,
    total_stock INTEGER,
    sold_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== 用户背包 ==========
CREATE TABLE IF NOT EXISTS user_inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_id VARCHAR(50) NOT NULL REFERENCES shop_items(id),
    
    -- 装备状态
    is_owned BOOLEAN DEFAULT TRUE,
    is_equipped BOOLEAN DEFAULT FALSE,
    equipped_at TIMESTAMP,
    
    -- 来源
    acquired_through VARCHAR(30),          -- purchase/reward/gift/achievement
    acquired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, item_id),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_item FOREIGN KEY (item_id) REFERENCES shop_items(id)
);

CREATE INDEX idx_user_inventory_user_id ON user_inventory(user_id);
CREATE INDEX idx_user_inventory_equipped ON user_inventory(user_id, is_equipped);

-- ========== 成就表 ==========
CREATE TABLE IF NOT EXISTS achievements (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(30),                  -- streak/nutrition/social/shop
    
    icon VARCHAR(50),
    reward_coins INTEGER DEFAULT 0,
    reward_xp INTEGER DEFAULT 0,
    reward_item_id VARCHAR(50),
    
    condition_type VARCHAR(30),            -- streak_days/meals_count/aura_score
    condition_value INTEGER,
    
    is_secret BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== 用户成就 ==========
CREATE TABLE IF NOT EXISTS user_achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_id VARCHAR(50) NOT NULL REFERENCES achievements(id),
    
    is_unlocked BOOLEAN DEFAULT FALSE,
    unlocked_at TIMESTAMP,
    is_notified BOOLEAN DEFAULT FALSE,
    
    UNIQUE(user_id, achievement_id)
);

-- ========== 刷新视图 ==========
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_pets_updated_at BEFORE UPDATE ON pets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ========== 触发器：更新 BMR/TDEE ==========
CREATE OR REPLACE FUNCTION update_user_metabolism()
RETURNS TRIGGER AS $$
DECLARE
    bmr_val DECIMAL(8,2);
    activity_mult DECIMAL(4,2);
BEGIN
    -- Mifflin-St Jeor 公式
    IF NEW.gender = 'male' THEN
        bmr_val := (10 * NEW.weight_kg) + (6.25 * NEW.height_cm) - (5 * NEW.age) + 5;
    ELSE
        bmr_val := (10 * NEW.weight_kg) + (6.25 * NEW.height_cm) - (5 * NEW.age) - 161;
    END IF;
    
    -- 活动系数
    activity_mult := CASE NEW.activity_level
        WHEN 'sedentary' THEN 1.2
        WHEN 'light' THEN 1.375
        WHEN 'moderate' THEN 1.55
        WHEN 'active' THEN 1.725
        WHEN 'very_active' THEN 1.9
        ELSE 1.2
    END;
    
    -- 目标调整
    IF NEW.fitness_goal = 'lose_fat' THEN
        NEW.tdee := ROUND(bmr_val * activity_mult * 0.8, 2);
    ELSIF NEW.fitness_goal = 'gain_muscle' THEN
        NEW.tdee := ROUND(bmr_val * activity_mult * 1.15, 2);
    ELSE
        NEW.tdee := ROUND(bmr_val * activity_mult, 2);
    END IF;
    
    NEW.bmr := ROUND(bmr_val, 2);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_metabolism_trigger
    BEFORE INSERT OR UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_user_metabolism();

-- ========== 预置数据 ==========

-- 预置商店物品
INSERT INTO shop_items (id, name, description, emoji, category, price_cents, rarity) VALUES
('glasses_round', '圆框眼镜', '文艺小清新', '👓', 'accessories', 299, 'common'),
('glasses_sun', '复古墨镜', '酷酷的出街必备', '🕶️', 'accessories', 499, 'rare'),
('glasses_star', '星星眼镜', '闪亮亮的', '⭐', 'accessories', 399, 'rare'),
('bow_pink', '粉色蝴蝶结', '可爱满分', '🎀', 'accessories', 299, 'common'),
('bow_blue', '蓝色蝴蝶结', '清新优雅', '🎀', 'accessories', 299, 'common'),
('hat_wizard', '魔法帽', '神秘感满满', '🎩', 'accessories', 699, 'epic'),
('hat_crown', '小皇冠', '尊贵象征', '👑', 'accessories', 999, 'epic'),
('scarf_plaid', '格子围巾', '英伦风格', '🧣', 'accessories', 249, 'common'),
('bg_monet', '莫奈花园', '睡莲池畔', '🌸', 'backgrounds', 699, 'rare'),
('bg_starry', '星空', '银河璀璨', '✨', 'backgrounds', 599, 'rare'),
('bg_ocean', '海洋', '波光粼粼', '🌊', 'backgrounds', 599, 'rare'),
('bg_sunset', '日落', '橘色浪漫', '🌅', 'backgrounds', 499, 'common'),
('bg_forest', '森林', '绿野仙踪', '🌲', 'backgrounds', 499, 'common'),
('bg_aurora', '极光', '神秘极光', '🌌', 'backgrounds', 999, 'legendary'),
('frame_gold', '金色画框', '华丽感', '🖼️', 'frames', 399, 'rare'),
('frame_minimal', '简约边框', '极简风格', '⬜', 'frames', 199, 'common');

-- 预置成就
INSERT INTO achievements (id, name, description, category, icon, reward_coins, reward_xp, condition_type, condition_value) VALUES
('first_meal', '第一餐', '记录你的第一餐', 'streak', '🍽️', 50, 20, 'meals_count', 1),
('week_streak', '一周坚持', '连续记录 7 天', 'streak', '🔥', 200, 100, 'streak_days', 7),
('month_streak', '月度达人', '连续记录 30 天', 'streak', '🏆', 1000, 500, 'streak_days', 30),
('healthy_eater', '健康达人', '摄入 10 次健康餐', 'nutrition', '🥗', 150, 80, 'category_count', 10),
('dessert_lover', '甜食爱好者', '记录 10 次甜点', 'nutrition', '🍰', 150, 80, 'category_count', 10),
('aura_master', '能量大师', 'Aura Score 达到 90', 'nutrition', '💫', 300, 150, 'aura_score', 90),
('collector_10', '收集达人', '拥有 10 件装扮', 'shop', '🛍️', 100, 50, 'inventory_count', 10),
('collector_50', '收藏家', '拥有 50 件装扮', 'shop', '💎', 500, 200, 'inventory_count', 50);

-- ========== 结束 ==========
