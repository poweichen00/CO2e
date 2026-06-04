import 'package:flutter/material.dart';
import '../option.dart';

class OfficeOptionList with ChangeNotifier {
  final List<Option> _list = [
    Option(
      id: 1,
      name: '去紙化',
      point: 100,
      imagePath: "lib/pages/action/image/no-paper.png",
      description: '執行無紙化辦公，使用電子文件代替紙張，盡可能採用數位簽署和電子工作流程，減少紙張消耗，並提升工作效率。',
    ),
    Option(
      id: 2,
      name: '減少不必要的電子設備',
      point: 100,
      imagePath: "lib/pages/action/image/no-plug.png",
      description: '移除辦工作周圍不常使用的電子設備，如個人風扇或加濕器，減少不必要的能源消耗。',
    ),
    Option(
      id: 3,
      name: '綠化辦公環境',
      point: 100,
      imagePath: "lib/pages/action/image/1plant.png",
      description: '在辦公室內擺放綠色植物，不僅能美化環境，還能淨化空氣，提升身心健康。',
    ),
    Option(
      id: 4,
      name: '使用節能電器',
      point: 100,
      imagePath: "lib/pages/action/image/green-energy.png",
      description: '購買並使用通過節能認證的電器設備，減少在辦公室的電力消耗和碳排放。',
    ),
    Option(
      id: 5,
      name: '遠距工作',
      point: 100,
      imagePath: "lib/pages/action/image/work-from-home.png",
      description: '部分時間遠距工作，減少通勤需求並降低辦公室運營的能源消耗。',
    ),
    Option(
      id: 6,
      name: '設定休眠模式',
      point: 100,
      imagePath: "lib/pages/action/image/time.png",
      description: '將電腦和打印機等設備設定為在閒置一段時間後自動進入休眠模式，這樣可以在不使用時節省電力。',
    ),
    Option(
      id: 7,
      name: '隨手關燈',
      point: 100,
      imagePath: "lib/pages/action/image/switch-off.png",
      description: '當離開工作區域或會議室時，養成隨手關燈的習慣，避免燈光長時間開啟。',
    ),
    Option(
      id: 8,
      name: '多走樓梯',
      point: 100,
      imagePath: "lib/pages/action/image/promotion.png",
      description: '在辦公樓內多使用樓梯，減少電梯的使用頻率，既能減少能源消耗，還能促進健康。',
    ),
  ];

  List<Option> _userAction = [];

  List<Option> get officeOptionList => _list;

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
