import 'package:flutter/material.dart';
import '../option.dart';

class DietOptionList with ChangeNotifier {
  final List<Option> _list = [
    Option(
      id: 1,
      name: '多吃菜，少吃肉',
      point: 100,
      imagePath: "lib/pages/action/image/vegetables.png",
      description:
          '畜牧業是溫室氣體排放的重要來源之一。通過減少紅肉和加工肉類的攝入，可以大幅減少碳足跡。多吃植物性食物，如蔬菜、水果、穀物和豆類，能有效降低環境影響。',
    ),
    Option(
      id: 2,
      name: '減少食物浪費',
      point: 100,
      imagePath: "lib/pages/action/image/stink.png",
      description:
          '每年大量食物因未食用而被浪費，這些食物在生產、運輸和處理過程中產生了大量的碳排放。通過購買適量的食材，妥善保存食物，並將剩菜轉化為新餐，可以減少浪費。',
    ),
    Option(
      id: 3,
      name: '自備餐具與水杯',
      point: 100,
      imagePath: "lib/pages/action/image/reuse.png",
      description: '使用一次性餐具和水杯會增加垃圾和碳排放。自備環保餐具和水杯，不僅有助於減少垃圾，還能減少對資源的消耗。',
    ),
    Option(
      id: 4,
      name: '不買過度包裝食物',
      point: 100,
      imagePath: "lib/pages/action/image/packaging.png",
      description: '大量食物包裝會導致資源浪費和碳排放，選擇散裝食材、使用可重複利用的購物袋、儲存容器，可以減少塑料和包裝的浪費。',
    ),
    Option(
      id: 5,
      name: '選擇本地和季節性食材',
      point: 100,
      imagePath: "lib/pages/action/image/ingredient.png",
      description:
          '本地生產的食物比進口食物需要更少的運輸能量，季節性食材則在自然環境下生長，不需要額外的能源來維持。因此，選擇本地和季節性食材能減少碳排放。',
    ),
    Option(
      id: 6,
      name: '選擇公平貿易和可持續來源的食材',
      point: 100,
      imagePath: "lib/pages/action/image/grocery-bag.png",
      description: '支持可持續的農業和漁業，選擇認證的公平貿易和可持續來源的產品，可以幫助保護環境和支持負責任的生產方式。',
    ),
  ];

  List<Option> _userAction = [];

  List<Option> get dietOptionList => _list;

  List<Option> get userAction => _userAction;

  void chooseAction(Option option) {
    if (!_userAction.contains(option)) {
      _userAction.add(option);
      notifyListeners();
    }
  }

  void removeChooseAction(Option option) {
    if (_userAction.contains(option)) {
      _userAction.remove(option);
      notifyListeners();
    }
  }

  Option? getOptionById(int id) {
    try {
      return _list.firstWhere((option) => option.id == id);
    } catch (e) {
      return null; // 返回 null 如果找不到
    }
  }
}
