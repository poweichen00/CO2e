import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../option.dart';
import 'house_option_list.dart';
import 'house_option_tile.dart';

class HouseOptionPage extends StatefulWidget {
  const HouseOptionPage({super.key});

  @override
  State<HouseOptionPage> createState() => _HouseOptionPageState();
}

class _HouseOptionPageState extends State<HouseOptionPage> {
  // Add to user's actions
  void addToAction(Option option) {
    Provider.of<HouseOptionList>(context, listen: false).chooseAction(option);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HouseOptionList>(
      builder: (context, houseOptionList, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          elevation: 0,
        ),
        body: Container(
          color: Colors.grey[100],
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "住家",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "家是我們最熟悉的地方，也是環保的起點。讓我們從日常生活中的每一個小步驟做起，為地球的可持續發展貢獻我們的力量。",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (houseOptionList.houseOptionList.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        int firstIndex = index * 2;
                        int secondIndex = firstIndex + 1;

                        return Row(
                          children: [
                            Expanded(
                              child: HouseOptionTile(
                                option: houseOptionList.houseOptionList[firstIndex],
                                houseOptionList: houseOptionList, // 传递 houseOptionList
                                onPressed: () => addToAction(houseOptionList.houseOptionList[firstIndex]),
                              ),
                            ),
                            if (secondIndex < houseOptionList.houseOptionList.length)
                              Expanded(
                                child: HouseOptionTile(
                                  option: houseOptionList.houseOptionList[secondIndex],
                                  houseOptionList: houseOptionList, // 传递 houseOptionList
                                  onPressed: () => addToAction(houseOptionList.houseOptionList[secondIndex]),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}