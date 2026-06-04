import 'package:flutter/material.dart';
import '../option.dart';

class HouseOptionList with ChangeNotifier {
  final List<Option> _list = [
    Option(
      id: 1,
      name: '節約用水',
      point: 100,
      imagePath: "lib/pages/action/image/water-drop.png",
      description: '減少洗澡時間，使用節水洗衣機，修理漏水水龍頭等，減少水資源浪費。',
    ),
    Option(
      id: 2,
      name: '節能燈泡',
      point: 100,
      imagePath: "lib/pages/action/image/light-bulb.png",
      description: '使用LED燈泡替代傳統燈泡，能大幅降低電力消耗，延長燈泡使用壽命。',
    ),
    Option(
      id: 3,
      name: '關閉待機電器',
      point: 100,
      imagePath: "lib/pages/action/image/turn-off.png",
      description: '關閉不使用的電器，避免能源浪費，例如電視、電腦等設備的待機模式',
    ),
    Option(
      id: 4,
      name: '使用可重複使用的產品',
      point: 100,
      imagePath: "lib/pages/action/image/reuse1.png",
      description: '選擇可重複使用的餐具、購物袋和水瓶，減少一次性塑料的使用。',
    ),
    Option(
      id: 5,
      name: '回收分類',
      point: 100,
      imagePath: "lib/pages/action/image/recycling.png",
      description: '將可回收物品如紙張、塑料、玻璃瓶進行分類和回收，減少廢物填埋。',
    ),
    Option(
      id: 6,
      name: '調整暖氣和空調',
      point: 100,
      imagePath: "lib/pages/action/image/adjustment.png",
      description: '根據季節調整暖氣和空調設定溫度，適當穿著以減少能源消耗',
    ),
    Option(
      id: 7,
      name: '節能家電',
      point: 100,
      imagePath: "lib/pages/action/image/washing-machine.png",
      description: '選擇節能型家電產品，有節能環保標章認證的冰箱、洗衣機等，降低電力使用。',
    ),
    Option(
      id: 7,
      name: '綠色清潔產品',
      point: 100,
      imagePath: "lib/pages/action/image/cleaning-products.png",
      description: '使用環保清潔劑，避免含有有害化學物質的產品，保護家人健康和環境。',
    ),
    Option(
      id: 7,
      name: '植樹造林',
      point: 100,
      imagePath: "lib/pages/action/image/plant.png",
      description: '在家中或花園種植樹木和植物，吸收二氧化碳並提供氧氣。',
    ),
    Option(
      id: 7,
      name: '利用自然光',
      point: 100,
      imagePath: "lib/pages/action/image/sun.png",
      description: '白天盡量使用自然光，減少人工照明的需求，節省電力。',
    ),
  ];

  List<Option> _userAction = [];

  List<Option> get houseOptionList => _list;

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
