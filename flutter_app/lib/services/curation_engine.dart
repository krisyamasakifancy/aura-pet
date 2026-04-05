import 'dart:math';

/// Curation Engine - 100+ 原创"去焦虑"语料库
/// 根据 Aura Score 随机抽取适合的鼓励语
class CurationEngine {
  static final Random _random = Random();

  // ===== 根据 Aura Score 分级 =====
  static String getEncouragement(int auraScore) {
    if (auraScore >= 90) return _excellent[(_random.nextDouble() * _excellent.length).floor()];
    if (auraScore >= 75) return _great[(_random.nextDouble() * _great.length).floor()];
    if (auraScore >= 60) return _good[(_random.nextDouble() * _good.length).floor()];
    if (auraScore >= 40) return _okay[(_random.nextDouble() * _okay.length).floor()];
    return _needsImprovement[(_random.nextDouble() * _needsImprovement.length).floor()];
  }

  // 根据心情获取语料
  static String getMoodMessage(String mood) {
    switch (mood) {
      case 'happy':
        return _happyMessages[(_random.nextDouble() * _happyMessages.length).floor()];
      case 'sad':
        return _sadMessages[(_random.nextDouble() * _sadMessages.length).floor()];
      case 'excited':
        return _excitedMessages[(_random.nextDouble() * _excitedMessages.length).floor()];
      case 'sleepy':
        return _sleepyMessages[(_random.nextDouble() * _sleepyMessages.length).floor()];
      case 'hungry':
        return _hungryMessages[(_random.nextDouble() * _hungryMessages.length).floor()];
      default:
        return _generalMessages[(_random.nextDouble() * _generalMessages.length).floor()];
    }
  }

  // 根据时间获取问候
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '夜深了，小熊陪你一起休息 🌙';
    if (hour < 9) return '早起的鸟儿有虫吃！☀️';
    if (hour < 12) return '上午好！新的一天充满活力 🌤️';
    if (hour < 14) return '中午好！记得按时吃饭哦 🍽️';
    if (hour < 18) return '下午好！保持专注 💪';
    if (hour < 21) return '傍晚好！适当休息一下 🌆';
    return '晚上好！准备迎接美好的夜晚 🌙';
  }

  // 成就解锁鼓励
  static String getAchievementMessage(String achievementName) {
    return '🎉 太棒了！解锁「$achievementName」！小熊为你骄傲！';
  }

  // 喝水提醒
  static String getWaterReminder(int glasses, int goal) {
    if (glasses == 0) return '💧 喝水的时刻到了！小熊陪你一起喝水~';
    if (glasses < goal / 2) return '🥤 才喝了${glasses}杯水，加油！还差${goal - glasses}杯~';
    if (glasses < goal) return '💧 快达标了！再喝${goal - glasses}杯就可以休息啦~';
    return '🎉 喝水目标达成！小熊很开心~';
  }

  // 禁食提醒
  static String getFastingMessage(int hours) {
    return '⏰ $hours小时轻断食开始！小熊陪你一起坚持~';
  }

  // 连续使用激励
  static String getStreakMessage(int days) {
    if (days == 1) return '✨ 第一天！好的开始是成功的一半~';
    if (days < 7) return '🔥 已经坚持$days天了！继续保持~';
    if (days < 30) return '🏆 $days天坚持！你太厉害了！';
    return '🌟 $days天坚持！你是真正的健康达人！';
  }

  // ===== 语料库 =====

  // 90+ 分 - 卓越
  static const _excellent = [
    '✨ 完美！你今天吃得超级健康，小熊都感动得流泪了！',
    '🌟 这就是营养满分的样子！你太棒了！',
    '💯 100分表现！小熊要给你颁发小红花！',
    '🏆 营养大师！继续保持这个状态！',
    '🌈 彩虹般的健康饮食！小熊向你学习！',
    '⭐ 闪闪发光的健康选择！你就是榜样！',
  ];

  // 75-89 分 - 优秀
  static const _great = [
    '😊 很棒！离完美只差一点点啦~',
    '👍 做得好！小熊觉得你很有潜力！',
    '🎉 不错不错！今天的饮食很健康！',
    '🌟 继续保持，你越来越厉害了！',
    '💪 优秀！小熊为你骄傲！',
    '🎈 健康小达人的表现！',
  ];

  // 60-74 分 - 良好
  static const _good = [
    '🙂 还不错！可以再优化一下~',
    '👍 还可以，下次争取更高分！',
    '✨ 有进步的空间，继续加油！',
    '💪 做得不错，小熊支持你！',
    '🌱 稳扎稳打，继续努力！',
    '🎯 再接再厉，你可以更好的！',
  ];

  // 40-59 分 - 一般
  static const _okay = [
    '🤔 有点小问题，不过没关系~',
    '💡 小熊建议减少点油脂哦',
    '🥗 下次多吃点蔬菜会更好~',
    '📊 营养配比可以再调整一下',
    '💪 别灰心，下次一定能更好！',
    '🎯 目标就在眼前，再努力一下！',
  ];

  // <40 分 - 需改进
  static const _needsImprovement = [
    '🤗 没关系的，小熊陪你一起改进~',
    '💪 失败是成功之母，下次会更好的！',
    '🌱 每天进步一点点，就是成功！',
    '🎈 小熊相信你，下次一定能做更好！',
    '💡 让我们一起找找更健康的选择~',
    '🤝 不用着急，我们慢慢来~',
  ];

  // 心情消息 - 开心
  static const _happyMessages = [
    '😊 看到你开心，小熊也很开心！',
    '🌈 快乐是会传染的~',
    '💖 小熊喜欢你微笑的样子！',
    '✨ 保持好心情，健康每一天！',
    '🌟 开心的你最美了！',
  ];

  // 心情消息 - 难过
  static const _sadMessages = [
    '🤗 小熊在这里陪你~',
    '💙 不开心的时候，小熊就是你的依靠',
    '🌸 一切都会好起来的',
    '🤝 小熊陪你一起度过~',
    '💪 困难只是暂时的，你很坚强！',
  ];

  // 心情消息 - 兴奋
  static const _excitedMessages = [
    '🎉 小熊也被你的热情感染了！',
    '⚡ 充满能量的你太酷了！',
    '🚀 冲鸭！小熊为你加油！',
    '💫 兴奋模式启动！',
    '🎊 让我们一起嗨起来！',
  ];

  // 心情消息 - 困倦
  static const _sleepyMessages = [
    '😴 困了就休息一下吧~',
    '🌙 晚安，小熊陪你入眠',
    '💤 好好休息，明天会更精神',
    '🌸 养好精神再出发~',
    '☁️ 休息是为了走更远的路',
  ];

  // 心情消息 - 饥饿
  static const _hungryMessages = [
    '🍽️ 肚子饿了？记得要健康饮食哦~',
    '🥗 小熊建议吃点蔬菜和蛋白~',
    '💧 饿的时候先喝杯水试试？',
    '🥗 均衡饮食才能保持健康~',
    '🍎 苹果是个好选择！',
  ];

  // 通用消息
  static const _generalMessages = [
    '🐻 小熊一直陪着你~',
    '💖 你今天做得很好！',
    '🌟 新的一天，新的开始！',
    '✨ 相信自己，你可以的！',
    '💪 加油，小熊为你打气！',
  ];
}

/// 宠物对话系统
class PetDialogue {
  static final Random _random = Random();

  // 记录饮食后的对话
  static String getMealReaction(int auraScore) {
    if (auraScore >= 80) {
      return _positiveReactions[(_random.nextDouble() * _positiveReactions.length).floor()];
    } else if (auraScore >= 50) {
      return _neutralReactions[(_random.nextDouble() * _neutralReactions.length).floor()];
    } else {
      return _negativeReactions[(_random.nextDouble() * _negativeReactions.length).floor()];
    }
  }

  // 宠物饿了时的对话
  static String getHungryDialogue() {
    return _hungryDialogues[(_random.nextDouble() * _hungryDialogues.length).floor()];
  }

  // 宠物开心时的对话
  static String getHappyDialogue() {
    return _happyDialogues[(_random.nextDouble() * _happyDialogues.length).floor()];
  }

  // 宠物睡觉时的对话
  static String getSleepDialogue() {
    return _sleepDialogues[(_random.nextDouble() * _sleepDialogues.length).floor()];
  }

  // 宠物口渴时的对话
  static String getThirstyDialogue() {
    return _thirstyDialogues[(_random.nextDouble() * _thirstyDialogues.length).floor()];
  }

  static const _positiveReactions = [
    '哇！这顿饭好健康！我爱吃！',
    '太棒了！这个选择我给满分！',
    '营养均衡，超级喜欢！再来！',
    '这就是我要的健康生活！',
    '好吃又健康，我的小肚子很开心！',
  ];

  static const _neutralReactions = [
    '嗯...还可以，下次试试更健康的？',
    '还行吧，不过可以更好的~',
    '有进步空间哦！小熊相信你！',
    '这个嘛...嗯...可以接受的！',
    '下次记得加点蔬菜哦~',
  ];

  static const _negativeReactions = [
    '这个...有点油腻呢...',
    '小熊觉得可以更健康一点~',
    '不要太难过，下次会更好的！',
    '油脂有点多了...注意一下哦',
    '小熊想吃更健康的食物~',
  ];

  static const _hungryDialogues = [
    '咕噜咕噜...小熊的肚子在叫了~',
    '主人，我饿了...可以吃点东西吗？',
    '闻到食物的香味了！好饿啊~',
    '小熊想要吃东西...',
  ];

  static const _happyDialogues = [
    '今天的天气真好！我好开心！',
    '谢谢主人陪我玩~我很幸福！',
    '心情超好！想跳舞！',
    '有你在，小熊每天都开心！',
  ];

  static const _sleepDialogues = [
    'zzZ...zzZ...小熊在做梦呢...',
    '好困...但是不想睡，想多陪你一会...',
    '晚安...做个好梦...',
    '呼呼~小熊在充电中...',
  ];

  static const _thirstyDialogues = [
    '嗯...有点渴...',
    '小熊想喝水...可以吗？',
    '喉咙干干的...来点水吧~',
  ];
}
