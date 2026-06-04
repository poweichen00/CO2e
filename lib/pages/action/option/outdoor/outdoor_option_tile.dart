import 'package:flutter/material.dart';

import '../option.dart';
import 'outdoor_option_detail.dart';
import 'outdoor_option_list.dart';

class OutdoorOptionTile extends StatelessWidget {
  final Option option;
  final OutdoorOptionList outdoorOptionList; // 添加 houseOptionList 参数
  final void Function()? onPressed;

  OutdoorOptionTile({
    super.key,
    required this.option,
    required this.outdoorOptionList, // 必须传递 HouseOptionList 实例
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade400,
            blurRadius: 5,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Image.asset(option.imagePath, height: 100, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(
            option.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OutdoorOptionDetail(
                        optionId: option.id, // 传递 optionId 而不是整个 Option
                        outdoorOptionList:
                            outdoorOptionList, // 传递 houseOptionList 实例
                      ),
                    ),
                  );
                },
                child: Icon(Icons.control_point, color: Colors.green),
              ),
              const SizedBox(width: 5),
              Text('${option.point} '),
            ],
          ),
        ],
      ),
    );
  }
}
