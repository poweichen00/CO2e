import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../option.dart';
import 'office_option_list.dart';
import 'office_option_tile.dart';

class OfficeOptionPage extends StatefulWidget {
  const OfficeOptionPage({super.key});

  @override
  State<OfficeOptionPage> createState() => _OfficeOptionPageState();
}

class _OfficeOptionPageState extends State<OfficeOptionPage> {
  // Add to user's actions
  void addToAction(Option option) {
    Provider.of<OfficeOptionList>(context, listen: false).chooseAction(option);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OfficeOptionList>(
      builder: (context, officeOptionList, child) => Scaffold(
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
                      "工作",
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
                    "從辦公桌開始，為地球減碳！關掉未使用的設備，使用環保用品。讓我們一起行動，為更綠的未來貢獻力量！",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (officeOptionList.officeOptionList.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        int firstIndex = index * 2;
                        int secondIndex = firstIndex + 1;

                        return Row(
                          children: [
                            Expanded(
                              child: OfficeOptionTile(
                                option: officeOptionList.officeOptionList[firstIndex],
                                officeOptionList: officeOptionList, // 传递 officeOptionList
                                onPressed: () => addToAction(officeOptionList.officeOptionList[firstIndex]),
                              ),
                            ),
                            if (secondIndex < officeOptionList.officeOptionList.length)
                              Expanded(
                                child: OfficeOptionTile(
                                  option: officeOptionList.officeOptionList[secondIndex],
                                  officeOptionList: officeOptionList, // 传递 officeOptionList
                                  onPressed: () => addToAction(officeOptionList.officeOptionList[secondIndex]),
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