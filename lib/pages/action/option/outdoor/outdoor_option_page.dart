import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../option.dart';
import 'outdoor_option_list.dart';
import 'outdoor_option_tile.dart';

class OutdoorOptionPage extends StatefulWidget {
  const OutdoorOptionPage({super.key});

  @override
  State<OutdoorOptionPage> createState() => _OutdoorOptionPageState();
}

class _OutdoorOptionPageState extends State<OutdoorOptionPage> {
  // Add to user's actions
  void addToAction(Option option) {
    Provider.of<OutdoorOptionList>(context, listen: false).chooseAction(option);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OutdoorOptionList>(
      builder: (context, outdoorOptionList, child) => Scaffold(
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
                      "外出",
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
                    "少開車，多步行，讓我們的地球更健康！每一步都能減少碳排放，每個選擇都能保護我們的環境。讓綠色出行成為我們的日常習慣，一起為地球出一份力！。",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (outdoorOptionList.outdoorOptionList.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        int firstIndex = index * 2;
                        int secondIndex = firstIndex + 1;

                        return Row(
                          children: [
                            Expanded(
                              child: OutdoorOptionTile(
                                option: outdoorOptionList.outdoorOptionList[firstIndex],
                                outdoorOptionList: outdoorOptionList, // 传递 outdoorOptionList
                                onPressed: () => addToAction(outdoorOptionList.outdoorOptionList[firstIndex]),
                              ),
                            ),
                            if (secondIndex < outdoorOptionList.outdoorOptionList.length)
                              Expanded(
                                child: OutdoorOptionTile(
                                  option: outdoorOptionList.outdoorOptionList[secondIndex],
                                  outdoorOptionList: outdoorOptionList, // 传递 outdoorOptionList
                                  onPressed: () => addToAction(outdoorOptionList.outdoorOptionList[secondIndex]),
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