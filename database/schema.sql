-- ============================================
-- Aura-Pet (BitePal Full-Stack Parity)
-- PostgreSQL Full Schema
-- Digital Impressionism Color Palette
-- ============================================

-- Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- ============================================
-- ENUMS
-- ============================================
CREATE TYPE pet_species AS ENUM ('raccoon', 'cat', 'dog', 'bunny', 'fox', 'owl');
CREATE TYPE pet_mood AS ENUM ('happy', 'neutral', 'sad', 'excited', 'sleepy', 'dizzy');
CREATE TYPE food_category AS ENUM ('protein', 'carb', 'vegetable', 'fruit', 'dessert', 'drink', 'snack');
CREATE TYPE subscription_tier AS ENUM ('free', 'premium', 'pro');
CREATE TYPE shop_item_type AS ENUM ('hat', 'glasses', 'scarf', 'background', 'pet_food', 'emotion');
CREATE TYPE transaction_type AS ENUM ('meal_reward', 'streak_bonus', 'purchase', 'refund', 'subscription');

-- ============================================
-- USERS
-- ============================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100),
    avatar_url TEXT,
    
    -- Subscription
    subscription_tier subscription_tier DEFAULT 'free',
    subscription_expires_at TIMESTAMP WITH TIME ZONE,
    stripe_customer_id VARCHAR(255),
    
    -- Virtual Currency
    bitecoins INTEGER DEFAULT 100,
    
    -- Stats
    total_meals_logged INTEGER DEFAULT 0,
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_meal_at TIMESTAMP WITH TIME ZONE,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_subscription ON users(subscription_tier);

-- ============================================
-- PETS (五维数值模型)
-- ============================================
CREATE TABLE pets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Identity
    name VARCHAR(50) NOT NULL,
    species pet_species NOT NULL,
    nickname VARCHAR(50),
    
    -- 五维数值 (0-100)
    hunger INTEGER DEFAULT 50 CHECK (hunger >= 0 AND hunger <= 100),
    joy INTEGER DEFAULT 50 CHECK (joy >= 0 AND joy <= 100),
    vigor INTEGER DEFAULT 50 CHECK (vigor >= 0 AND vigor <= 100),
    affinity INTEGER DEFAULT 0 CHECK (affinity >= 0 AND affinity <= 100),
    evolution_xp INTEGER DEFAULT 0 CHECK (evolution_xp >= 0),
    
    -- Evolution Level
    evolution_level INTEGER DEFAULT 1 CHECK (evolution_level >= 1 AND evolution_level <= 10),
    
    -- Current State
    current_mood pet_mood DEFAULT 'neutral',
    is_sleeping BOOLEAN DEFAULT FALSE,
    is_dizzy BOOLEAN DEFAULT FALSE,
    
    -- Position in pet list (for multi-pet)
    slot_index INTEGER DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, slot_index)
);

CREATE INDEX idx_pets_user ON pets(user_id);

-- ============================================
-- MEALS (餐食流水)
-- ============================================
CREATE TABLE meals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Food Info
    food_name VARCHAR(255) NOT NULL,
    food_category food_category,
    estimated_calories INTEGER,
    estimated_protein DECIMAL(6,2),
    estimated_carbs DECIMAL(6,2),
    estimated_fat DECIMAL(6,2),
    
    -- Vision AI Results (Multi-model validation)
    vision_gpt4o_result JSONB,
    vision_gemini_result JSONB,
    vision_confidence_score DECIMAL(3,2),
    vision_final_consensus JSONB,
    
    -- Image
    image_url TEXT,
    image_thumbnail_url TEXT,
    
    -- Tags & Mood
    tags TEXT[],
    anxiety_relief_label VARCHAR(100), -- "心情补给", "能量加油站"
    
    -- Rewards
    coins_earned INTEGER DEFAULT 0,
    xp_earned INTEGER DEFAULT 0,
    
    -- Timestamps
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_meals_user ON meals(user_id);
CREATE INDEX idx_meals_logged_at ON meals(logged_at);
CREATE INDEX idx_meals_category ON meals(food_category);

-- ============================================
-- WATER_TRACKING (水分追踪)
-- ============================================
CREATE TABLE water_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    amount_ml INTEGER NOT NULL CHECK (amount_ml > 0),
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_water_user_date ON water_logs(user_id, logged_at);

-- ============================================
-- FASTING_TRACKER (轻断食计时)
-- ============================================
CREATE TABLE fasting_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    started_at TIMESTAMP WITH TIME ZONE NOT NULL,
    ended_at TIMESTAMP WITH TIME ZONE,
    target_hours INTEGER DEFAULT 16,
    actual_hours DECIMAL(5,2),
    completed BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_fasting_user ON fasting_sessions(user_id);

-- ============================================
-- SHOP_ITEMS (商店库存)
-- ============================================
CREATE TABLE shop_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Item Info
    item_key VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    item_type shop_item_type NOT NULL,
    
    -- Compatibility
    applicable_species pet_species[],
    evolution_level_required INTEGER DEFAULT 1,
    
    -- Economy
    price_bitecoins INTEGER NOT NULL,
    is_limited BOOLEAN DEFAULT FALSE,
    limited_quantity INTEGER,
    limited_remaining INTEGER,
    
    -- Visual
    preview_image_url TEXT,
    layers JSONB, -- For layered rendering
    
    -- Timestamps
    available_from TIMESTAMP WITH TIME ZONE,
    available_until TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_shop_items_type ON shop_items(item_type);
CREATE INDEX idx_shop_items_price ON shop_items(price_bitecoins);

-- ============================================
-- USER_INVENTORY (用户背包)
-- ============================================
CREATE TABLE user_inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES shop_items(id),
    quantity INTEGER DEFAULT 1,
    purchased_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, item_id)
);

CREATE INDEX idx_inventory_user ON user_inventory(user_id);

-- ============================================
-- USER_PET_APPEARANCE (宠物外观)
-- ============================================
CREATE TABLE pet_appearances (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    
    -- Equipped Items (Layered)
    equipped_hat UUID REFERENCES shop_items(id),
    equipped_glasses UUID REFERENCES shop_items(id),
    equipped_scarf UUID REFERENCES shop_items(id),
    equipped_background UUID REFERENCES shop_items(id),
    
    -- Color customization
    primary_color VARCHAR(7), -- Hex
    secondary_color VARCHAR(7),
    
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_appearance_pet ON pet_appearances(pet_id);

-- ============================================
-- TRANSACTIONS (金币流水)
-- ============================================
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    transaction_type transaction_type NOT NULL,
    amount INTEGER NOT NULL, -- Positive for income, negative for expense
    balance_after INTEGER NOT NULL,
    
    -- Reference
    meal_id UUID REFERENCES meals(id),
    shop_item_id UUID REFERENCES shop_items(id),
    
    description VARCHAR(255),
    metadata JSONB,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);

-- ============================================
-- DAILY_STATS (每日统计)
-- ============================================
CREATE TABLE daily_stats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    stat_date DATE NOT NULL,
    
    -- Meals
    meals_count INTEGER DEFAULT 0,
    total_calories INTEGER DEFAULT 0,
    nutrition_balance_score DECIMAL(5,2), -- 0-100
    
    -- Water
    water_ml INTEGER DEFAULT 0,
    water_goal_achieved BOOLEAN DEFAULT FALSE,
    
    -- Streak
    streak_continued BOOLEAN DEFAULT FALSE,
    
    -- Pet Stats Snapshot
    pet_hunger_avg INTEGER,
    pet_joy_avg INTEGER,
    pet_vigor_avg INTEGER,
    
    UNIQUE(user_id, stat_date)
);

CREATE INDEX idx_daily_stats_user ON daily_stats(user_id);
CREATE INDEX idx_daily_stats_date ON daily_stats(stat_date);

-- ============================================
-- ANXIETY_RELIEF_LABELS (去焦虑标签库)
-- ============================================
CREATE TABLE anxiety_relief_labels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    food_category food_category NOT NULL,
    calorie_range VARCHAR(20), -- "0-200", "200-400", "400-800", "800+"
    
    -- Labels (rotating)
    label_key VARCHAR(100) NOT NULL,
    label_text VARCHAR(255) NOT NULL,
    label_emoji VARCHAR(50),
    label_color VARCHAR(7),
    
    frequency_weight INTEGER DEFAULT 1 -- Higher = more likely to appear
);

-- Pre-populate label library
INSERT INTO anxiety_relief_labels (food_category, calorie_range, label_key, label_text, label_emoji, label_color, frequency_weight) VALUES
-- Dessert
('dessert', '400-800', 'soul_charge', '灵魂充电时间', '⚡', '#FFD700', 3),
('dessert', '400-800', 'happiness_injection', '快乐因子注入中', '💫', '#FF69B4', 3),
('dessert', '800+', 'luxury_reward', '尊享犒劳时刻', '👑', '#FF1493', 2),
('dessert', '200-400', 'sweet_blessing', '甜蜜小确幸', '🌸', '#FFB6C1', 4),
('dessert', '0-200', 'guilt_free_treat', '无罪恶感小确幸', '✨', '#98FB98', 5),

-- Protein
('protein', '400-800', 'power_building', '力量积攒中', '💪', '#FF6B6B', 3),
('protein', '200-400', 'muscle_fuel', '肌肉燃料补给', '🏋️', '#FFA07A', 4),

-- Carb
('carb', '400-800', 'comfort_hug', '碳水安慰拥抱', '🤗', '#DEB887', 3),
('carb', '200-400', 'energy_reserve', '能量储备充足', '🔋', '#F0E68C', 4),

-- Vegetable
('vegetable', '0-200', 'green_power', '绿色能量满格', '🌿', '#90EE90', 5),
('vegetable', '200-400', 'nutrition_fortress', '营养堡垒建设', '🏰', '#32CD32', 4),

-- Fruit
('fruit', '0-200', 'nature_candy', '大自然糖果', '🍬', '#FFA500', 5),
('fruit', '200-400', 'vitamin_bomb', '维C炸弹来袭', '💣', '#FF4500', 3),

-- Drink
('drink', '0-100', 'hydration_blessing', '水分祝福达成', '💧', '#87CEEB', 5),
('drink', '100-300', 'caffeine_companion', '咖啡因伙伴上线', '☕', '#8B4513', 3),

-- Snack
('snack', '0-200', 'mini_adventure', '小小冒险奖励', '🎒', '#DDA0DD', 4),
('snack', '200-400', 'mood_booster', '心情助推器启动', '🚀', '#FF6347', 3),
('snack', '400+', 'celebration_mode', '庆典模式开启', '🎉', '#FF1493', 2);

-- ============================================
-- CONVERSATION_CORPUS (去焦虑对话语料库)
-- ============================================
CREATE TABLE conversation_corpus (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Trigger conditions
    food_category food_category,
    anxiety_level VARCHAR(20), -- 'low', 'medium', 'high'
    pet_mood pet_mood,
    time_of_day VARCHAR(20), -- 'morning', 'noon', 'afternoon', 'evening', 'night'
    
    -- Persona & Response
    persona_action VARCHAR(255), -- "小浣熊开心地转圈"
    dialogue_text TEXT NOT NULL,
    dialogue_emoji VARCHAR(50),
    
    -- Animation hint
    animation_trigger VARCHAR(100), -- "spin", "jump", "bounce", "sleepy"
    
    frequency_weight INTEGER DEFAULT 1
);

-- Pre-populate conversation corpus
INSERT INTO conversation_corpus (food_category, anxiety_level, pet_mood, time_of_day, persona_action, dialogue_text, dialogue_emoji, animation_trigger, frequency_weight) VALUES
-- Dessert responses (most important for anxiety relief)
('dessert', 'high', 'happy', 'any', '小浣熊兴奋地转圈圈', '哇！是你最爱的甜点！生活已经这么苦了当然要对自己好一点呀～', '😍', 'spin', 5),
('dessert', 'medium', 'happy', 'any', '小浣熊眼睛亮晶晶', '嘿嘿，这个看起来超好吃的！吃甜食会释放快乐多巴胺哦～科学认证的！', '🤤', 'bounce', 4),
('dessert', 'low', 'neutral', 'any', '小浣熊优雅地品尝', '精致的甜点时光～懂得品味生活的人才最懂幸福呢！', '😌', 'idle', 3),

-- Healthy food responses
('vegetable', 'any', 'happy', 'any', '小浣熊竖起大拇指', '蔬菜侠出击！今天的你又在为身体加油啦～', '👍', 'jump', 4),
('vegetable', 'any', 'neutral', 'any', '小浣熊认真点头', '均衡饮食，智慧选择！你的身体会感谢你的～', '💚', 'idle', 3),
('fruit', 'any', 'happy', 'any', '小浣熊开心蹦跳', '水果派对！天然的甜蜜才是真正的快乐源泉呀！', '🍎', 'bounce', 4),
('protein', 'any', 'neutral', 'any', '小浣熊展示肌肉', '蛋白质补给完成！你正在变得更强壮呢～', '💪', 'jump', 3),

-- Carb responses
('carb', 'any', 'happy', 'morning', '小浣熊元气满满', '早安！碳水是起床的第一能量～今天也要元气满满哦！', '🌅', 'jump', 4),
('carb', 'any', 'neutral', 'evening', '小浣熊温柔地说', '晚餐的碳水是温暖的陪伴～好好享受这份满足感吧！', '🌙', 'idle', 3),
('carb', 'any', 'sad', 'any', '小浣熊递上纸巾', '想吃就吃呀～情绪低落的时候更需要给自己一些慰藉呢。', '🤗', 'hug', 4),

-- High calorie comfort
('dessert', 'high', 'excited', 'any', '小浣熊欢呼雀跃', '热量炸弹来袭！！炸裂的快乐因子正在充盈你的灵魂！！', '🎉', 'spin', 3),
('snack', 'high', 'happy', 'any', '小浣熊疯狂摇摆', '放纵一下吧！偶尔的放肆是为了更长久的坚持呀～', '🔥', 'shake', 3),

-- Drink responses
('drink', 'any', 'neutral', 'morning', '小浣熊精神抖擞', '早安咖啡时间到！咖啡因正在唤醒你的每一个细胞～', '☕', 'jump', 4),
('drink', 'any', 'sad', 'afternoon', '小浣熊轻轻拍肩', '下午的低谷很正常呀～来一杯给自己充充电吧！', '🤚', 'comfort', 3),

-- General comfort
(NULL, 'high', 'sad', 'any', '小浣熊拥抱你', '别担心呀～吃东西是为了让自己开心，不是为了愧疚呢。', '🫂', 'hug', 5),
(NULL, 'medium', 'neutral', 'any', '小浣熊微笑点头', '每一餐都是爱自己的表现～你在好好照顾自己呢！', '💝', 'idle', 4),
(NULL, 'any', 'happy', 'any', '小浣熊开心拍手', '记录本身就是一种自律呀！你已经很棒了！', '👏', 'clap', 4);

-- ============================================
-- SUBSCRIPTION_FEATURES (订阅功能表)
-- ============================================
CREATE TABLE subscription_features (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tier subscription_tier NOT NULL,
    feature_key VARCHAR(100) NOT NULL,
    feature_name VARCHAR(255) NOT NULL,
    description TEXT,
    
    UNIQUE(tier, feature_key)
);

INSERT INTO subscription_features (tier, feature_key, feature_name, description) VALUES
-- Premium ($35.99/year)
('premium', 'micro_nutrients', '微量元素指纹', 'AI分析食物中微量元素的详细组成'),
('premium', 'weekly_pet_report', '宠物进化周报', '每周生成宠物的成长报告和建议'),
('premium', 'advanced_analytics', '高级数据分析', '查看30天/90天的营养趋势深度分析'),
('premium', 'unlimited_photos', '无限照片存储', '无限制保存餐食照片和历史'),
('premium', 'exclusive_items', '限定商店物品', '访问Premium专属装扮物品'),

-- Pro
('pro', 'micro_nutrients', '微量元素指纹', 'AI分析食物中微量元素的详细组成'),
('pro', 'weekly_pet_report', '宠物进化周报', '每周生成宠物的成长报告和建议'),
('pro', 'advanced_analytics', '高级数据分析', '查看30天/90天的营养趋势深度分析'),
('pro', 'unlimited_photos', '无限照片存储', '无限制保存餐食照片和历史'),
('pro', 'exclusive_items', '限定商店物品', '访问Pro专属装扮物品'),
('pro', 'personal_coach', '私人营养教练', 'AI营养师1对1定制饮食建议'),
('pro', 'family_sharing', '家庭共享', '最多5个账户共享Premium功能');

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_pets_updated_at BEFORE UPDATE ON pets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Calculate nutrition balance score
CREATE OR REPLACE FUNCTION calculate_nutrition_balance(meal_calories INTEGER, protein DECIMAL, carbs DECIMAL, fat DECIMAL)
RETURNS DECIMAL AS $$
DECLARE
    score DECIMAL;
    protein_ratio DECIMAL;
    fat_ratio DECIMAL;
BEGIN
    IF meal_calories = 0 THEN
        RETURN 0;
    END IF;
    
    protein_ratio := (protein * 4) / meal_calories;
    fat_ratio := (fat * 9) / meal_calories;
    
    -- Balanced: 20-30% protein, <30% fat
    IF protein_ratio BETWEEN 0.20 AND 0.35 AND fat_ratio < 0.35 THEN
        score := 90 + (RANDOM() * 10);
    ELSIF protein_ratio BETWEEN 0.15 AND 0.40 AND fat_ratio < 0.45 THEN
        score := 70 + (RANDOM() * 20);
    ELSE
        score := 50 + (RANDOM() * 30);
    END IF;
    
    RETURN ROUND(score, 2);
END;
$$ LANGUAGE plpgsql;

-- Award coins for meal logging
CREATE OR REPLACE FUNCTION award_meal_coins()
RETURNS TRIGGER AS $$
DECLARE
    coin_amount INTEGER;
    xp_amount INTEGER;
    current_balance INTEGER;
BEGIN
    -- Base reward
    coin_amount := 5 + (RANDOM() * 10)::INTEGER;
    xp_amount := 10 + (RANDOM() * 5)::INTEGER;
    
    -- Streak bonus
    IF NEW.logged_at - (SELECT last_meal_at FROM users WHERE id = NEW.user_id) < INTERVAL '1 day' THEN
        coin_amount := coin_amount + 5;
        xp_amount := xp_amount + 5;
    END IF;
    
    -- Get current balance
    SELECT bitecoins INTO current_balance FROM users WHERE id = NEW.user_id;
    
    -- Update user coins
    UPDATE users 
    SET bitecoins = bitecoins + coin_amount,
        total_meals_logged = total_meals_logged + 1,
        last_meal_at = NEW.logged_at
    WHERE id = NEW.user_id;
    
    -- Record transaction
    INSERT INTO transactions (user_id, transaction_type, amount, balance_after, meal_id, description)
    VALUES (
        NEW.user_id, 
        'meal_reward', 
        coin_amount, 
        current_balance + coin_amount, 
        NEW.id,
        'Meal logging reward'
    );
    
    -- Update pet XP
    UPDATE pets SET evolution_xp = evolution_xp + xp_amount WHERE user_id = NEW.user_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_meals_after_insert
    AFTER INSERT ON meals
    FOR EACH ROW EXECUTE FUNCTION award_meal_coins();

-- ============================================
-- VIEWS
-- ============================================

-- User dashboard view
CREATE VIEW v_user_dashboard AS
SELECT 
    u.id as user_id,
    u.display_name,
    u.bitecoins,
    u.subscription_tier,
    u.current_streak,
    u.total_meals_logged,
    
    p.id as pet_id,
    p.name as pet_name,
    p.species,
    p.hunger,
    p.joy,
    p.vigor,
    p.affinity,
    p.evolution_xp,
    p.evolution_level,
    p.current_mood,
    
    COALESCE(today_meals.meals_today, 0) as meals_today,
    COALESCE(today_meals.calories_today, 0) as calories_today,
    COALESCE(today_water.water_ml, 0) as water_today

FROM users u
LEFT JOIN pets p ON p.user_id = u.id AND p.slot_index = 0
LEFT JOIN LATERAL (
    SELECT COUNT(*) as meals_today, COALESCE(SUM(estimated_calories), 0) as calories_today
    FROM meals
    WHERE user_id = u.id AND DATE(logged_at) = CURRENT_DATE
) today_meals ON true
LEFT JOIN LATERAL (
    SELECT COALESCE(SUM(amount_ml), 0) as water_ml
    FROM water_logs
    WHERE user_id = u.id AND DATE(logged_at) = CURRENT_DATE
) today_water ON true;

-- ============================================
-- SEED DATA
-- ============================================

-- Sample shop items
INSERT INTO shop_items (item_key, name, description, item_type, price_bitecoins, layers) VALUES
('raccoon_basic_hat', '小浣熊经典帽', '经典款小浣熊棒球帽', 'hat', 50, '{"z_index": 1, "position": "top"}'),
('raccoon_sunglasses', '墨镜酷哥', '超酷的太阳镜', 'glasses', 80, '{"z_index": 2, "position": "eyes"}'),
('rainbow_scarf', '彩虹围巾', '七色彩虹围巾', 'scarf', 100, '{"z_index": 3, "position": "neck"}'),
('night_sky_bg', '夜空背景', '璀璨星空背景', 'background', 150, '{"z_index": 0, "position": "back"}'),
('golden_crown', '金色皇冠', '尊贵的金色皇冠', 'hat', 500, '{"z_index": 1, "position": "top"}'),
('heart_glasses', '爱心眼镜', '粉红爱心眼镜', 'glasses', 120, '{"z_index": 2, "position": "eyes"}'),
('flower_scarf', '花朵围巾', '春天花朵图案围巾', 'scarf', 130, '{"z_index": 3, "position": "neck"}'),
('sunset_bg', '日落背景', '温暖日落背景', 'background', 180, '{"z_index": 0, "position": "back"}');

-- Analytics & Permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO aura_pet_reader;
GRANT ALL ON ALL TABLES IN SCHEMA public TO aura_pet_writer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO aura_pet_writer;
