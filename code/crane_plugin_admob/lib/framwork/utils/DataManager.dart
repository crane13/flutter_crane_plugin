import 'CacheUtils.dart';

class DataManager {
  static const GAME_DATA = 'game_data';
  static const KEY_REVIEW = 'key_review';
  static const KEY_ANSWER_COUNT = 'answer_count';

  /// =================  Review ===================
  static Future<int> getReviewTimes() async {
    int? times = await CacheUtils.getIntByKey(KEY_REVIEW);
    if (times == null) {
      times = 0;
    }
    return times;
  }

  static Future<bool> shouldReview() async {
    int times = await getReviewTimes();
    return times == null || times < 3;
  }

  static Future setHasReview() async {
    int times = await getReviewTimes();
    times++;
    CacheUtils.setIntWithKey(KEY_REVIEW, times);
  }

  /// =================  Review end===================

  /// =================  answer count ===================
  static Future<int> getAnswerCount() async {
    int? answer_count = await CacheUtils.getIntByKey(KEY_ANSWER_COUNT);
    if (answer_count == null) {
      answer_count = 3;
    }
    return answer_count;
  }

  static void saveAnswerCount(int count) async {
    CacheUtils.setIntWithKey(KEY_ANSWER_COUNT, count);
  }

  /// =================  answer count end ===================

}
