import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../option.dart';
import 'diet_option_list.dart';
import 'diet_option_tile.dart';

class DietOptionPage extends StatefulWidget {
  const DietOptionPage({super.key});

  @override
  State<DietOptionPage> createState() => _DietOptionPageState();
}

class _DietOptionPageState extends State<DietOptionPage> {
  // Add to user's actions
  void addToAction(Option option) {
    Provider.of<DietOptionList>(context, listen: false).chooseAction(option);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DietOptionList>(
      builder: (context, dietOptionList, child) => Scaffold(
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
                      "飲食",
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
                    "從飲食開始，打造更綠的地球！選擇本地食材，支持季節性蔬果，減少長途運輸的碳足跡。用心選擇食物，讓我們的每一餐都為地球帶來正面改變！",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (dietOptionList.dietOptionList.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        int firstIndex = index * 2;
                        int secondIndex = firstIndex + 1;

                        return Row(
                          children: [
                            Expanded(
                              child: DietOptionTile(
                                option: dietOptionList.dietOptionList[firstIndex],
                                dietOptionList: dietOptionList, // 传递 dietOptionList
                                onPressed: () => addToAction(dietOptionList.dietOptionList[firstIndex]),
                              ),
                            ),
                            if (secondIndex < dietOptionList.dietOptionList.length)
                              Expanded(
                                child: DietOptionTile(
                                  option: dietOptionList.dietOptionList[secondIndex],
                                  dietOptionList: dietOptionList, // 传递 dietOptionList
                                  onPressed: () => addToAction(dietOptionList.dietOptionList[secondIndex]),
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