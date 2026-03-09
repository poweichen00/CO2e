import 'package:flutter/material.dart';
import '../option.dart';
import 'diet_option_detail.dart';
import 'diet_option_list.dart';

class DietOptionTile extends StatelessWidget {
  final Option option;
  final DietOptionList dietOptionList; // 添加 dietOptionList 参数
  final void Function()? onPressed;

  DietOptionTile({
    super.key,
    required this.option,
    required this.dietOptionList, // 必须传递 dietOptionList 实例
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
                      builder: (context) => DietOptionDetail(
                        optionId: option.id, // 传递 optionId 而不是整个 Option
                        dietOptionList: dietOptionList, // 传递 dietOptionList 实例
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
