-- ============================================================
-- Aura-Pet 数据库架构
-- 完整建表 SQL（覆盖 BitePal 功能清单 + 原创宠物系统）
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- 1. 用户表 (Users)
-- ============================================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- 基本信息
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nickname VARCHAR(100),
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 会员状态
    is_premium BOOLEAN DEFAULT FALSE,
    premium_expires_at TIMESTAMP WITH TIME ZONE,
    subscription_id VARCHAR(100),
    
    -- 身体数据 (BMI/BMR/代谢)
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    age INTEGER,
    height_cm DECIMAL(5,2),          -- 身高 (cm)
    weight_kg DECIMAL(5,2),          -- 当前体重 (kg)
    target_weight_kg DECIMAL(5,2),   -- 目标体重 (kg)
    
    -- BMI 相关
    bmi DECIMAL(4,2),                -- BMI = weight / (height/100)^2
    bmi_category VARCHAR(20),        -- Underweight/Normal/Overweight/Obese
    
    -- 基础代谢率 (Mifflin-St Jeor)
    bmr INTEGER,                      -- kcal/day
    
    -- 活动水平
    activity_level VARCHAR(20) DEFAULT 'lightly_active' 
        CHECK (activity_level IN ('not_active', 'lightly_active', 'moderately_active', 'highly_active')),
    
    -- 每日目标
    daily_calorie_goal INTEGER,      -- 每日卡路里目标
    daily_protein_goal_g INTEGER,     -- 蛋白质目标 (g)
    daily_carbs_goal_g INTEGER,       -- 碳水目标 (g)
    daily_fat_goal_g INTEGER,         -- 脂肪目标 (g)
    daily_water_goal_cups INTEGER DEFAULT 8,  -- 喝水目标 (杯)
    
    -- 健康目标
    goal_type VARCHAR(20) CHECK (goal_type IN ('lose', 'maintain', 'gain')),
    diet_type VARCHAR(30) DEFAULT 'balanced', -- Balanced/Keto/Vegan/etc.
    
    -- 饮食习惯
    meals_per_day INTEGER DEFAULT 3,
    eating_window_hours INTEGER,     -- 进食窗口时间 (间歇性禁食)
    food_restrictions TEXT[],        -- 食物限制/过敏
    diet_preferences TEXT[],          -- 饮食偏好
    
    -- 喝水追踪
    water_today_cups INTEGER DEFAULT 0,
    water_streak_days INTEGER DEFAULT 0,
    
    -- 统计
    total_meals_logged INTEGER DEFAULT 0,
    total_fasting_hours INTEGER DEFAULT 0,
    current_streak_days INTEGER DEFAULT 0,  -- 连续使用天数
    
    -- 最后活跃
    last_active_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 状态
    onboarding_complete BOOLEAN DEFAULT FALSE,
    onboarding_step INTEGER DEFAULT 0,
    
    CONSTRAINT valid_height CHECK (height_cm BETWEEN 100 AND 250),
    CONSTRAINT valid_weight CHECK (weight_kg BETWEEN 20 AND 500),
    CONSTRAINT valid_age CHECK (age BETWEEN 10 AND 120)
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_premium ON users(is_premium);

-- ============================================================
-- 2. 宠物表 (Pets)
-- ============================================================
CREATE TABLE pets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 宠物基本信息
    name VARCHAR(50) NOT NULL DEFAULT '小熊',
    species VARCHAR(30) DEFAULT 'bear',  -- bear/raccoon/fox/bunny
    color VARCHAR(30) DEFAULT 'honey',   -- honey/chocolate/white
    
    -- 等级与经验值 (XP)
    level INTEGER DEFAULT 1,
    current_xp INTEGER DEFAULT 0,
    xp_to_next_level INTEGER DEFAULT 100,
    total_xp_earned INTEGER DEFAULT 0,
    
    -- 进化阶段
    evolution_stage INTEGER DEFAULT 1 CHECK (evolution_stage BETWEEN 1 AND 5),
    evolution_name VARCHAR(50),         -- 幼年期/成长期/完全体/究极体/传奇
    
    -- 宠物外观属性
    size DECIMAL(4,1) DEFAULT 1.0,    -- 大小 (1.0 - 3.0)
    happiness INTEGER DEFAULT 100 CHECK (happiness BETWEEN 0 AND 100),
    hunger INTEGER DEFAULT 50 CHECK (hunger BETWEEN 0 AND 100),
    
    -- 心情状态
    mood VARCHAR(20) DEFAULT 'happy' 
        CHECK (mood IN ('sleeping', 'eating', 'happy', 'excited', 'sad', 'tired', 'swimming', 'diving')),
    
    -- 特殊状态
    is_sleeping BOOLEAN DEFAULT FALSE,
    is_fasting BOOLEAN DEFAULT FALSE, -- 主人禁食时宠物睡觉
    is_swimming BOOLEAN DEFAULT FALSE, -- 喝水达标时宠物游泳
    fasting_start_time TIMESTAMP WITH TIME ZONE,
    
    -- 装备的装饰品
    equipped_hat UUID,
    equipped_bow UUID,
    equipped_glasses UUID,
    equipped_scarf UUID,
    equipped_crown UUID,
    equipped_backpack UUID,
    
    -- 创建/更新时间
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id)
);

CREATE INDEX idx_pets_user ON pets(user_id);
CREATE INDEX idx_pets_level ON pets(level DESC);

-- ============================================================
-- 3. 宠物心情日志 (Pet_Mood_Logs)
-- ============================================================
CREATE TABLE pet_mood_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    
    -- 触发事件
    trigger_type VARCHAR(30) NOT NULL,  -- meal_logged/water_achieved/fasting_complete/xp_gained/item_purchased
    trigger_description TEXT,
    
    -- 心情变化
    mood_before VARCHAR(20),
    mood_after VARCHAR(20),
    happiness_delta INTEGER,
    
    -- 经验值变化
    xp_gained INTEGER DEFAULT 0,
    
    -- 时间戳
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_pet_mood_logs_pet ON pet_mood_logs(pet_id);
CREATE INDEX idx_pet_mood_logs_trigger ON pet_mood_logs(trigger_type);

-- ============================================================
-- 4. 餐次记录表 (Meals)
-- ============================================================
CREATE TABLE meals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 餐次信息
    meal_type VARCHAR(20) CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
    meal_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 食物来源
    source_type VARCHAR(20) DEFAULT 'photo' CHECK (source_type IN ('photo', 'manual', 'barcode', 'search')),
    image_url TEXT,
    food_name VARCHAR(200) NOT NULL,
    food_emoji VARCHAR(10),
    portion_size VARCHAR(50),
    portion_grams DECIMAL(6,2),
    
    -- 卡路里与营养素
    calories INTEGER NOT NULL DEFAULT 0,
    protein_g DECIMAL(6,2) DEFAULT 0,
    carbs_g DECIMAL(6,2) DEFAULT 0,
    fat_g DECIMAL(6,2) DEFAULT 0,
    fiber_g DECIMAL(6,2) DEFAULT 0,
    sugar_g DECIMAL(6,2) DEFAULT 0,
    sodium_mg DECIMAL(8,2) DEFAULT 0,
    
    -- AI 识别置信度
    confidence_score DECIMAL(3,2) DEFAULT 1.00,
    
    -- Aura 评分 (0-100)
    aura_score INTEGER CHECK (aura_score BETWEEN 0 AND 100),
    aura_feedback TEXT,               -- "很棒！营养均衡" / "蛋白质偏低"
    
    -- 黄金分割判断
    meets_protein_ratio BOOLEAN,      -- 蛋白质是否达标
    meets_carbs_ratio BOOLEAN,        -- 碳水是否达标
    meets_fat_ratio BOOLEAN,         -- 脂肪是否达标
    
    -- 时间戳
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_meals_user ON meals(user_id);
CREATE INDEX idx_meals_time ON meals(meal_time);
CREATE INDEX idx_meals_type ON meals(meal_type);

-- ============================================================
-- 5. 每日营养汇总表 (Daily_Nutrition_Summary)
-- ============================================================
CREATE TABLE daily_nutrition_summary (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    summary_date DATE NOT NULL,
    
    -- 总计
    total_calories INTEGER DEFAULT 0,
    total_protein_g DECIMAL(6,2) DEFAULT 0,
    total_carbs_g DECIMAL(6,2) DEFAULT 0,
    total_fat_g DECIMAL(6,2) DEFAULT 0,
    total_fiber_g DECIMAL(6,2) DEFAULT 0,
    
    -- 餐次计数
    meals_count INTEGER DEFAULT 0,
    breakfast_count INTEGER DEFAULT 0,
    lunch_count INTEGER DEFAULT 0,
    dinner_count INTEGER DEFAULT 0,
    snack_count INTEGER DEFAULT 0,
    
    -- 目标完成度
    calorie_goal_percentage DECIMAL(5,2),
    protein_goal_percentage DECIMAL(5,2),
    carbs_goal_percentage DECIMAL(5,2),
    fat_goal_percentage DECIMAL(5,2),
    
    -- 黄金分割达成
    balanced_meals_count INTEGER DEFAULT 0,  -- 达标的餐次
    aura_average_score DECIMAL(5,2),         -- 平均 Aura 分数
    
    -- 喝水
    water_cups INTEGER DEFAULT 0,
    water_goal_percentage DECIMAL(5,2),
    
    -- 奖励
    bonus_coins_earned INTEGER DEFAULT 0,
    bonus_xp_earned INTEGER DEFAULT 0,
    
    UNIQUE(user_id, summary_date)
);

CREATE INDEX idx_daily_summary_user_date ON daily_nutrition_summary(user_id, summary_date);

-- ============================================================
-- 6. 禁食记录表 (Fasting_Records)
-- ============================================================
CREATE TABLE fasting_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 禁食方案
    plan_type VARCHAR(10) NOT NULL,  -- 16:8 / 18:6 / 20:4 / custom
    target_hours INTEGER NOT NULL,
    eating_window_hours INTEGER,
    
    -- 时间记录
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE,
    actual_hours DECIMAL(5,2),
    
    -- 完成状态
    status VARCHAR(20) DEFAULT 'in_progress' 
        CHECK (status IN ('in_progress', 'completed', 'cancelled', 'paused')),
    completed BOOLEAN DEFAULT FALSE,
    
    -- 宠物状态同步
    pet_sleeping DURING_fast BOOLEAN DEFAULT FALSE,
    
    -- 奖励
    coins_earned INTEGER DEFAULT 0,
    xp_earned INTEGER DEFAULT 0,
    
    -- 备注
    notes TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_fasting_user ON fasting_records(user_id);
CREATE INDEX idx_fasting_status ON fasting_records(status);

-- ============================================================
-- 7. 喝水记录表 (Water_Logs)
-- ============================================================
CREATE TABLE water_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 喝水量
    cups DECIMAL(3,1) NOT NULL,      -- 支持 0.5 杯
    amount_ml INTEGER,                -- 毫升
    
    -- 来源
    source VARCHAR(20) DEFAULT 'manual' CHECK (source IN ('manual', 'reminder', 'auto')),
    
    -- 时间
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 是否触发宠物游泳动画
    triggered_swimming BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_water_user ON water_logs(user_id);
CREATE INDEX idx_water_time ON water_logs(logged_at);

-- ============================================================
-- 8. 体重记录表 (Weight_Logs)
-- ============================================================
CREATE TABLE weight_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    weight_kg DECIMAL(5,2) NOT NULL,
    bmi DECIMAL(4,2),
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 变化
    weight_change_kg DECIMAL(5,2),
    trend VARCHAR(10) CHECK (trend IN ('up', 'down', 'stable'))
);

CREATE INDEX idx_weight_user ON weight_logs(user_id);
CREATE INDEX idx_weight_time ON weight_logs(logged_at DESC);

-- ============================================================
-- 9. 硬币交易表 (Coin_Transactions)
-- ============================================================
CREATE TABLE coin_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 交易类型
    transaction_type VARCHAR(30) NOT NULL,
    
    -- 金额
    amount INTEGER NOT NULL,         -- 正数=收入，负数=支出
    balance_after INTEGER NOT NULL,   -- 交易后余额
    
    -- 来源/用途
    source VARCHAR(30),              -- earned/spent/refund/promo/gift
    source_description TEXT,         -- "完成禁食奖励" / "购买绅士帽子"
    
    -- 关联
    related_meal_id UUID REFERENCES meals(id),
    related_fasting_id UUID REFERENCES fasting_records(id),
    related_item_id UUID,
    
    -- 时间
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_coin_user ON coin_transactions(user_id);
CREATE INDEX idx_coin_type ON coin_transactions(transaction_type);
CREATE INDEX idx_coin_time ON coin_transactions(created_at DESC);

-- ============================================================
-- 10. 物品清单表 (Items / Inventory)
-- ============================================================
CREATE TABLE items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- 物品信息
    name VARCHAR(100) NOT NULL,
    name_key VARCHAR(50) NOT NULL UNIQUE,  -- hat/bow/glasses/crown/scarf/backpack
    category VARCHAR(30) NOT NULL,          -- hat/accessory/pet/background
    
    -- 价格与稀有度
    price INTEGER NOT NULL DEFAULT 0,
    rarity VARCHAR(20) DEFAULT 'common' CHECK (rarity IN ('common', 'rare', 'epic', 'legendary')),
    
    -- 物品属性
    emoji VARCHAR(10) NOT NULL,
    description TEXT,
    effect_bonus INTEGER DEFAULT 0,        -- 装备加成
    
    -- 显示
    is_visible BOOLEAN DEFAULT TRUE,
    is_limited BOOLEAN DEFAULT FALSE,
    limited_until TIMESTAMP WITH TIME ZONE,
    
    -- Premium 专属
    is_premium_only BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 预置物品数据
INSERT INTO items (name, name_key, category, price, rarity, emoji, description) VALUES
('绅士帽子', 'hat', 'hat', 50, 'common', '🎩', '一顶优雅的礼帽'),
('可爱蝴蝶结', 'bow', 'accessory', 40, 'common', '🎀', '精致的红色蝴蝶结'),
('酷炫墨镜', 'glasses', 'accessory', 60, 'rare', '🕶️', '帅气的太阳镜'),
('小熊皇冠', 'crown', 'accessory', 100, 'epic', '👑', '专属皇冠'),
('温暖围巾', 'scarf', 'accessory', 0, 'common', '🧣', '暖暖的红色围巾（初始装备）'),
('背包', 'backpack', 'accessory', 80, 'rare', '🎒', '户外探险背包'),
('魔法披风', 'cape', 'accessory', 150, 'legendary', '🦸', '传说中的魔法披风'),
('星星魔杖', 'wand', 'accessory', 120, 'epic', '✨', '许愿魔杖');

-- ============================================================
-- 11. 用户背包表 (User_Inventory)
-- ============================================================
CREATE TABLE user_inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    
    -- 获得方式
    acquired_type VARCHAR(20) DEFAULT 'purchased' CHECK (acquired_type IN ('purchased', 'earned', 'reward', 'gift', 'starter')),
    acquired_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 使用状态
    is_equipped BOOLEAN DEFAULT FALSE,
    equipped_at TIMESTAMP WITH TIME ZONE,
    
    -- 来源追踪
    purchase_price INTEGER,         -- 如果是购买的，记录当时价格
    coin_transaction_id UUID REFERENCES coin_transactions(id),
    
    UNIQUE(user_id, item_id)
);

CREATE INDEX idx_inventory_user ON user_inventory(user_id);
CREATE INDEX idx_inventory_equipped ON user_inventory(user_id, is_equipped);

-- ============================================================
-- 12. 提醒设置表 (Reminders)
-- ============================================================
CREATE TABLE reminders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 提醒类型
    reminder_type VARCHAR(30) NOT NULL,  -- meal/water/fasting/exercise
    title VARCHAR(100),
    
    -- 时间设置
    time_of_day TIME,
    repeat_days INTEGER[],             -- [0,1,2,3,4,5,6] 0=周日
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 推送设置
    push_enabled BOOLEAN DEFAULT TRUE,
    push_offset_minutes INTEGER,       -- 提前多少分钟
    
    -- 宠物动作触发
    trigger_pet_action VARCHAR(30),   -- wave/jump/bounce
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_reminders_user ON reminders(user_id);

-- ============================================================
-- 13. 宠物动作动画表 (Pet_Animations)
-- ============================================================
CREATE TABLE pet_animations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    
    -- 动画类型
    animation_type VARCHAR(30) NOT NULL,  -- wave/jump/spin/bounce/hug/heart_eyes/eating/sleeping/swimming
    
    -- 触发来源
    trigger_source VARCHAR(30),         -- user_tap/meal_logged/water_achieved/fasting_complete/reward
    
    -- 动画参数
    duration_ms INTEGER DEFAULT 2000,
    repeat_count INTEGER DEFAULT 1,
    
    -- 执行时间
    executed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_pet_animations_pet ON pet_animations(pet_id);

-- ============================================================
-- 14. 成就表 (Achievements)
-- ============================================================
CREATE TABLE achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    name VARCHAR(100) NOT NULL,
    name_key VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    category VARCHAR(30),              -- meal/water/fasting/weight/streak
    
    -- 解锁条件
    condition_type VARCHAR(30),        -- meals_count/streak_days/weight_change
    condition_value INTEGER,
    
    -- 奖励
    reward_coins INTEGER DEFAULT 0,
    reward_xp INTEGER DEFAULT 0,
    
    -- 显示
    emoji VARCHAR(10),
    is_secret BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 预置成就
INSERT INTO achievements (name, name_key, description, category, condition_type, condition_value, reward_coins, reward_xp, emoji) VALUES
('初次记录', 'first_meal', '记录第一餐', 'meal', 'meals_count', 1, 10, 20, '🍽️'),
('连续3天', 'streak_3', '连续使用3天', 'streak', 'streak_days', 3, 30, 50, '🔥'),
('连续7天', 'streak_7', '连续使用一周', 'streak', 'streak_days', 7, 100, 150, '⭐'),
('喝水达人', 'water_master', '单日喝满8杯水', 'water', 'water_cups', 8, 20, 30, '💧'),
('首次禁食', 'first_fast', '完成第一次禁食', 'fasting', 'fasting_count', 1, 50, 80, '⏰'),
('减重1kg', 'lose_1kg', '成功减重1公斤', 'weight', 'weight_change', 1, 80, 100, '📉'),
('营养均衡', 'balanced_7', '7天营养均衡', 'meal', 'balanced_days', 7, 150, 200, '⚖️');

-- ============================================================
-- 15. 用户成就表 (User_Achievements)
-- ============================================================
CREATE TABLE user_achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_id UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
    
    unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    reward_claimed BOOLEAN DEFAULT TRUE,
    
    UNIQUE(user_id, achievement_id)
);

CREATE INDEX idx_user_achievements_user ON user_achievements(user_id);

-- ============================================================
-- 16. 反馈消息表 (Pet_Messages)
-- ============================================================
CREATE TABLE pet_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    
    -- 消息内容
    message_text TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'encouragement',  -- encouragement/warning/celebration/tip
    
    -- 触发条件
    trigger_type VARCHAR(30),         -- meal_logged/goal_achieved/low_nutrition
    trigger_data JSONB,
    
    -- 发送时间
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 用户是否看过
    is_read BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_pet_messages_pet ON pet_messages(pet_id);

-- ============================================================
-- 17. 健康风险提示表 (Health_Alerts)
-- ============================================================
CREATE TABLE health_alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 警告类型
    alert_type VARCHAR(30),           -- bmi_high/bmi_low/nutrition_imbalance
    severity VARCHAR(10) DEFAULT 'info' CHECK (severity IN ('info', 'warning', 'alert')),
    
    -- 内容
    title VARCHAR(100),
    message TEXT,
    source_reference VARCHAR(50),     -- CDC/WHO/etc.
    
    -- 状态
    is_dismissed BOOLEAN DEFAULT FALSE,
    dismissed_at TIMESTAMP WITH TIME ZONE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_health_alerts_user ON health_alerts(user_id);

-- ============================================================
-- 18. 订阅表 (Subscriptions)
-- ============================================================
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 订阅信息
    plan_type VARCHAR(20) NOT NULL,   -- monthly/yearly/lifetime
    price_decimal DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'CNY',
    
    -- 时间
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    
    -- 状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'cancelled', 'expired', 'refunded')),
    
    -- 支付
    payment_method VARCHAR(20),       -- apple_pay/google_pay/stripe
    payment_id VARCHAR(100),
    
    -- 自动续费
    auto_renew BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);

-- ============================================================
-- 触发器：更新用户统计
-- ============================================================

-- 记录餐次后更新用户统计
CREATE OR REPLACE FUNCTION update_user_meal_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users SET
        total_meals_logged = total_meals_logged + 1,
        last_active_at = NOW()
    WHERE id = NEW.user_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_meal_logged
    AFTER INSERT ON meals
    FOR EACH ROW
    EXECUTE FUNCTION update_user_meal_stats();

-- 记录禁食后更新统计
CREATE OR REPLACE FUNCTION update_user_fasting_stats()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'completed' THEN
        UPDATE users SET
            total_fasting_hours = total_fasting_hours + COALESCE(NEW.actual_hours, 0)::INTEGER,
            last_active_at = NOW()
        WHERE id = NEW.user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_fasting_completed
    AFTER UPDATE ON fasting_records
    FOR EACH ROW
    EXECUTE FUNCTION update_user_fasting_stats();

-- 更新每日汇总（记录餐次后）
CREATE OR REPLACE FUNCTION update_daily_nutrition_summary()
RETURNS TRIGGER AS $$
DECLARE
    v_date DATE := DATE(NEW.meal_time);
BEGIN
    INSERT INTO daily_nutrition_summary (user_id, summary_date, total_calories, total_protein_g, total_carbs_g, total_fat_g, meals_count)
    VALUES (NEW.user_id, v_date, NEW.calories, NEW.protein_g, NEW.carbs_g, NEW.fat_g, 1)
    ON CONFLICT (user_id, summary_date)
    DO UPDATE SET
        total_calories = daily_nutrition_summary.total_calories + NEW.calories,
        total_protein_g = daily_nutrition_summary.total_protein_g + NEW.protein_g,
        total_carbs_g = daily_nutrition_summary.total_carbs_g + NEW.carbs_g,
        total_fat_g = daily_nutrition_summary.total_fat_g + NEW.fat_g,
        meals_count = daily_nutrition_summary.meals_count + 1,
        breakfast_count = CASE WHEN NEW.meal_type = 'breakfast' THEN daily_nutrition_summary.breakfast_count + 1 ELSE daily_nutrition_summary.breakfast_count END,
        lunch_count = CASE WHEN NEW.meal_type = 'lunch' THEN daily_nutrition_summary.lunch_count + 1 ELSE daily_nutrition_summary.lunch_count END,
        dinner_count = CASE WHEN NEW.meal_type = 'dinner' THEN daily_nutrition_summary.dinner_count + 1 ELSE daily_nutrition_summary.dinner_count END,
        snack_count = CASE WHEN NEW.meal_type = 'snack' THEN daily_nutrition_summary.snack_count + 1 ELSE daily_nutrition_summary.snack_count END;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_meal_summary
    AFTER INSERT ON meals
    FOR EACH ROW
    EXECUTE FUNCTION update_daily_nutrition_summary();

-- ============================================================
-- 视图：用户完整数据
-- ============================================================
CREATE OR REPLACE VIEW v_user_full_profile AS
SELECT 
    u.id,
    u.nickname,
    u.email,
    u.avatar_url,
    u.is_premium,
    u.height_cm,
    u.weight_kg,
    u.target_weight_kg,
    u.bmi,
    u.bmi_category,
    u.bmr,
    u.activity_level,
    u.daily_calorie_goal,
    u.daily_protein_goal_g,
    u.daily_carbs_goal_g,
    u.daily_fat_goal_g,
    u.daily_water_goal_cups,
    u.goal_type,
    u.current_streak_days,
    u.total_meals_logged,
    u.total_fasting_hours,
    p.id AS pet_id,
    p.name AS pet_name,
    p.species AS pet_species,
    p.level AS pet_level,
    p.evolution_stage,
    p.mood AS pet_mood,
    p.happiness AS pet_happiness,
    (SELECT COALESCE(SUM(amount), 0) FROM coin_transactions WHERE user_id = u.id) AS total_coins
FROM users u
LEFT JOIN pets p ON p.user_id = u.id;

-- ============================================================
-- 初始化默认宠物
-- ============================================================
CREATE OR REPLACE FUNCTION create_default_pet_for_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO pets (user_id, name, species, color)
    VALUES (NEW.id, '小熊', 'bear', 'honey');
    
    -- 给初始装备
    INSERT INTO user_inventory (user_id, item_id, acquired_type)
    SELECT NEW.id, id, 'starter' FROM items WHERE name_key = 'scarf';
    
    -- 初始金币
    INSERT INTO coin_transactions (user_id, transaction_type, amount, balance_after, source, source_description)
    VALUES (NEW.id, 'earned', 100, 100, 'starter', '新用户欢迎奖励');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_default_pet
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION create_default_pet_for_user();

-- ============================================================
-- 权限说明
-- ============================================================
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO aura_pet_app;
-- GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO aura_pet_app;
