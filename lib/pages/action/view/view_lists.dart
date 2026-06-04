import 'package:c_o2e/pages/action/option/outdoor/outdoor_option_page.dart';
import 'package:c_o2e/pages/action/view/view_page.dart';
import 'package:flutter/material.dart';

import '../option/house/house_option_page.dart';
import 'action_view.dart';

class ViewLists extends ChangeNotifier {
  //action lists
  final List<ActionView> _list = [
    ActionView(
      id: 0,
      name: '居家',
      imagePath: "lib/pages/action/image/house.png",
    ),
    ActionView(
      id: 1,
      name: '外出',
      imagePath: "lib/pages/action/image/car.png",
    ),
    ActionView(
      id: 2,
      name: '飲食',
      imagePath: "lib/pages/action/image/diet.png",
    ),
    ActionView(
      id: 3,
      name: '辦公',
      imagePath: "lib/pages/action/image/location-pin.png",
    ),
  ];

  // user action
  List<ActionView> _userAction = [];

  // get user list
  List<ActionView> get viewLists => _list;

  // get user action
  List<ActionView> get userAction => _userAction;

  // add action to userAction
  void chooseAction(ActionView lists) {
    _userAction.add(lists);
    notifyListeners();
  }

  // remove action from userAction
  void removeChooseAction(ActionView lists) {
    _userAction.remove(lists);
    notifyListeners();
  }
}
