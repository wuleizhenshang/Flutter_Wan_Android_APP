///日期相关工具类
class DateUtils {
  ///获取下个0点的时间戳
  static int getNextMidnightTimestamp() {
    // 获取当前时间
    DateTime now = DateTime.now();

    // 获取今天0点的时间
    DateTime todayMidnight = DateTime(now.year, now.month, now.day);

    // 获取下一个0点的时间（今天0点的基础上加一天）
    DateTime nextMidnight = todayMidnight.add(const Duration(days: 1));

    // 返回下一个0点的时间戳（毫秒级）
    return nextMidnight.millisecondsSinceEpoch;
  }
}
