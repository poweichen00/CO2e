import 'package:c_o2e/flutter_flow/flutter_flow_util.dart';
import 'package:c_o2e/pages/action/view/view_lists.dart';
import 'package:c_o2e/pages/action/view/view_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'action_view.dart';


class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  // add to user's actions
  void addToAction(ActionView actionview) {
    Provider.of<ViewLists>(context, listen: false).chooseAction(actionview);
  }
  String _getRouteForAction(int id) {
    String routeName;
    switch (id) {
      case 0:
        routeName = 'house_option_page';
        break;
      case 1:
        routeName = 'outdoor_option_page';
        break;
      case 2:
        routeName = 'diet_option_page';
        break;
      case 3:
        routeName = 'office_option_page';
        break;
      default:
        routeName = 'action_home';
    }
    print('Navigating to route: $routeName');  // 打印调试信息
    return routeName;
  }




  @override
  Widget build(BuildContext context) {
    return Consumer<ViewLists>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Text(
                "準備好接受挑戰了嗎，從以下的行動清單中，選擇最符合你的吧!",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: value.viewLists.length,
                  itemBuilder: (context, index) {
                    ActionView eachLists = value.viewLists[index];
                    return ViewTile(
                      actionview: eachLists,
                      onPressed: () async {
                        context.pushNamed(
                          _getRouteForAction(eachLists.id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
