import 'package:flutter/material.dart';

import '../option.dart';

class OutdoorOptionList extends ChangeNotifier {
  final List<Option> _list = [
    Option(
      id: 1,
      name: '搭乘大眾運輸工具',
      point: 100,
      imagePath: "lib/pages/action/image/bus-school.png",
      description:
          'This option pertains to outdoor activities and their environmental impact.',
    ),
    Option(
      id: 2,
      name: '攜帶環保杯',
      point: 100,
      imagePath: "lib/pages/action/image/water.png",
      description:
          'This option pertains to outdoor activities and their environmental impact.',
    ),
    Option(
      id: 3,
      name: '選擇步行或自行車',
      point: 100,
      imagePath: "lib/pages/action/image/bicycle.png",
      description: '如果目的地不遠，考慮步行或騎自行車。這樣不僅可以減少碳排放，還能鍛鍊身體，享受戶外的自然風光。',
    ),
    Option(
      id: 4,
      name: '使用可重複購物袋',
      point: 100,
      imagePath: "lib/pages/action/image/reusebag.png",
      description:
          '外出購物時，記得攜帶自己的可重複使用的購物袋，避免使用一次性塑膠袋。這個簡單的舉動可以大大減少塑膠垃圾的產生，保護環境。',
    ),
    Option(
      id: 5,
      name: '選擇環保包裝的產品',
      point: 100,
      imagePath: "lib/pages/action/image/sustainable.png",
      description: '外出購物時，優先選擇那些使用可降解或可循環利用包裝的產品。減少塑膠和不可降解材料的使用，有助於減輕環境負擔。',
    ),
    Option(
      id: 6,
      name: '攜帶可重複使用餐具',
      point: 100,
      imagePath: "lib/pages/action/image/reuse.png",
      description:
          '外出用餐或購買外帶食物時，攜帶自己的可重複使用的餐具，如餐叉、湯匙、吸管等。這樣可以避免使用一次性塑膠製品，減少垃圾的產生。',
    ),
    Option(
      id: 7,
      name: '選擇低碳旅遊目的地',
      point: 100,
      imagePath: "lib/pages/action/image/tourism.png",
      description:
          '在計劃旅行時，優先考慮那些倡導環保和可持續旅遊的目的地。這些地方通常會提供綠色住宿、低碳交通選擇和環保活動，讓你的旅行對環境的影響降到最低。',
    ),
    Option(
      id: 8,
      name: '攜帶手帕代替紙巾',
      point: 100,
      imagePath: "lib/pages/action/image/handkerchief.png",
      description:
          '外出時攜帶手帕，代替一次性紙巾或濕巾使用。這樣可以減少紙巾的消耗，從而減少紙張生產過程中的碳排放和森林砍伐，同時也能降低垃圾產生量。',
    ),
  ];

  // user action
  List<Option> _userAction = [];

  // get user list
  List<Option> get outdoorOptionList => _list;

  // get user action
  List<Option> get userAction => _userAction;

  // add action to userAction
  void chooseAction(Option lists) {
    _userAction.add(lists);
    notifyListeners();
  }

  // remove action from userAction
  void removeChooseAction(Option lists) {
    _userAction.remove(lists);
    notifyListeners();
  }

  Option? getOptionById(int id) {
    try {
      return _list.firstWhere((option) => option.id == id);
    } catch (e) {
      return null; // 返回 null 如果找不到
    }
  }
}
