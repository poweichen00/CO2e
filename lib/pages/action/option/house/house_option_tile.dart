import 'package:flutter/material.dart';
import '../option.dart';
import 'house_option_detail.dart'; // 确保你导入了详细页面
import 'house_option_list.dart'; // 导入 HouseOptionList

class HouseOptionTile extends StatelessWidget {
  final Option option;
  final HouseOptionList houseOptionList; // 添加 houseOptionList 参数
  final void Function()? onPressed;

  HouseOptionTile({
    super.key,
    required this.option,
    required this.houseOptionList, // 必须传递 HouseOptionList 实例
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
            style: const TextStyle(
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
                      builder: (context) => HouseOptionDetail(
                        optionId: option.id, // 传递 optionId 而不是整个 Option
                        houseOptionList:
                            houseOptionList, // 传递 houseOptionList 实例
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.control_point, color: Colors.green),
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
