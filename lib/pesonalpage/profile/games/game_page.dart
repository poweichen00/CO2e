import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'shop_page.dart';
import 'catalog_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> plantStates = List.filled(9, 'empty'); // 每个花盆的状态
  late SharedPreferences _prefs;
  List<int> growthTimers = List.filled(9, 24); // 每个花盆的生长倒计时
  List<DateTime?> plantingTimes = List.filled(9, null); // 记录种植时间
  List<Timer?> timers = List.filled(9, null); // 每个花盆的计时器


  Artboard? _riveArtboard; // Rive Artboard for planting animation
  Artboard? _wateringArtboard; // Rive Artboard for watering animation
  Artboard? _fertilizingArtboard; // Rive Artboard for fertilizing animation
  SMITrigger? _shakeTrigger; // 控制 shake 动画的触发器

  @override
  void initState() {
    super.initState();
    _getCurrentUser();  // 获取用户
    _loadPlantCounts(); // 调用这个方法来加载植物相关的数量
    _loadPlantStates(); // 加载植物状态
    _startAllTimers();  // 确保所有植物状态可以实时更新
  }

  void _getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
    if (userEmail != null) {
      _loadPlantCounts();  // 在获取到 `userEmail` 后调用这个函数
    }
  }

  // 加载 plant 集合中的种子、水和肥料的数量
  Future<void> _loadPlantCounts() async {
    Map<String, int> plantCounts = await fetchPlantCounts(userEmail);

    setState(() {
      seedCount = plantCounts['seedCount']!;
      waterCount = plantCounts['waterCount']!;
      fertilizerCount = plantCounts['fertilizerCount']!;
    });
  }

  // 加载花盆状态和种植时间
  Future<void> _loadPlantStates() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < plantStates.length; i++) {
        plantStates[i] = _prefs.getString('plant_$i') ?? 'empty';
        String? plantingTimeStr = _prefs.getString('plantingTime_$i');
        if (plantingTimeStr != null) {
          plantingTimes[i] = DateTime.parse(plantingTimeStr);
          _calculateGrowthProgress(i); // 计算植物生长进度
        }
      }
    });
  }



  // 显示收成提示框
  void _showHarvestDialog(String treeName) {
    // 根据树名选择对应的图片路径
    String imagePath = '';
    switch (treeName) {
      case '橡树':
        imagePath = 'assets/images/tree_1.png';
        break;
      case '樱花树':
        imagePath = 'assets/images/tree_2.png';
        break;
      case '松树':
        imagePath = 'assets/images/tree_3.png';
        break;
      case '椰子树':
        imagePath = 'assets/images/tree_4.png';
        break;
      case '枫树':
        imagePath = 'assets/images/tree_5.png';
        break;
      case '苹果树':
        imagePath = 'assets/images/tree_6.png';
        break;
      case '柳树':
        imagePath = 'assets/images/tree_7.png';
        break;
      case '桦树':
        imagePath = 'assets/images/tree_8.png';
        break;
      case '香蕉树':
        imagePath = 'assets/images/tree_9.png';
        break;
      default:
        imagePath = 'assets/images/default_tree.png';
        break;
    }

    // 显示自定义的 AlertDialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 圆角
        ),
        backgroundColor: Colors.green[100], // 背景颜色
        title: Center(
          child: Text(
            '收成成功!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[800], // 自定义字体颜色
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 圆形图片
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green, // 边框颜色
                  width: 5, // 边框宽度
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            // 提示信息
            Text(
              '您获得了 $treeName！',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green[700], // 按钮背景色
                foregroundColor: Colors.white, // 按钮文字颜色
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // 按钮圆角
                ),
              ),
              child: Text(
                '确认',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // 处理植物收成逻辑
  void _harvestPlant(int index) {
    if (plantStates[index] == 'harvest') {
      // 调用随机植物收成逻辑
      String harvestedTree = _getRandomTree();

      // 增加树的数量
      CatalogPage.incrementTreeQuantity(harvestedTree);

      // 弹出收成提示框
      _showHarvestDialog(harvestedTree);

      // 重置植物状态
      _resetPlantState(index);
    }
  }

  // 随机选择植物，樱花树为4%，其他为8%
  String _getRandomTree() {
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    int rand = random.nextInt(100);
    if (rand < 4) {
      return '樱花树';
    } else if (rand < 16) {
      return '橡树';
    } else if (rand < 28) {
      return '松树';
    } else if (rand < 40) {
      return '椰子树';
    } else if (rand < 52) {
      return '枫树';
    } else if (rand < 64) {
      return '苹果树';
    } else if (rand < 76) {
      return '柳树';
    } else if (rand < 88) {
      return '桦树';
    } else {
      return '香蕉树';
    }
  }

  // 保存花盆状态和种植时间
  void _savePlantState(int index, String state) {
    setState(() {
      plantStates[index] = state;
      _prefs.setString('plant_$index', state);
    });
  }

  void _savePlantingTime(int index) {
    DateTime now = DateTime.now();
    plantingTimes[index] = now;
    _prefs.setString('plantingTime_$index', now.toIso8601String());
  }

  // 计算植物生长进度
  void _calculateGrowthProgress(int index) {
    if (plantingTimes[index] != null) {
      // 只有在植物状态为 'watered' 或 'fertilized' 时，才开始生长
      if (plantStates[index] != 'empty') {
        DateTime now = DateTime.now();
        int elapsedSeconds = now.difference(plantingTimes[index]!).inSeconds;

        if (elapsedSeconds >= 24||growthTimers[index]<1) {
          // 倒计时结束时，植物可收获
          _savePlantState(index, 'harvest');
          growthTimers[index] = 0;
        } else {
          // 启动倒计时
          growthTimers[index] = 24 - elapsedSeconds;
          _startGrowthTimer(index);
        }
      } else {
        // 植物未浇水，计时器不会启动

          growthTimers[index] = 24; // 保持为24小时直到浇水开始

      }
    }
  }

  // 启动所有花盆的倒计时
  void _startAllTimers() {
    for (int i = 0; i < plantStates.length; i++) {
      if (plantStates[i] == 'watered' ||
          plantStates[i] == 'fertilized') {
        _startGrowthTimer(i); // 如果处于生长状态，启动计时器
      }
    }
  }

  // 开始生长倒计时并实时更新植物状态
  void _startGrowthTimer(int index) {
    timers[index]?.cancel(); // 取消已有计时器

    timers[index] = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (growthTimers[index] > 0) {
          growthTimers[index]--;
        } else {
          _savePlantState(index, 'harvest'); // 倒计时结束变为可收成状态
          timer.cancel();
        }
      });
    });
  }

  // 重置所有花盆状态
  void _resetAllPlants() {
    setState(() {
      for (int i = 0; i < plantStates.length; i++) {
        plantStates[i] = 'empty';
        growthTimers[i] = 24;
        timers[i]?.cancel();
        _prefs.setString('plant_$i', 'empty');
        _prefs.remove('plantingTime_$i');
        plantingTimes[i] = null;
      }
    });
  }

  // 显示确认提示框
  void _showConfirmationDialog(
      String action, int itemCount, String itemName, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认 $action'),
          content: Text('您确定要 $action 吗？\n剩余 $itemName 数量: $itemCount'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: itemCount > 0 ? onConfirm : null,
              child: Text('确认'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: itemCount > 0 ? Colors.green : Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }

  // 初始化种植动画
  void _onRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      _shakeTrigger = controller.findInput<SMITrigger>('shake') as SMITrigger?;
    }
  }

  // 初始化浇水动画
  void _onWateringRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
    }
    setState(() {
      _wateringArtboard = artboard;
    });
  }

  void _onFertilizingRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
    }
    setState(() {
      _fertilizingArtboard = artboard;
    });
  }

  // 触发 shake 动画
  void _triggerShake() {
    if (_shakeTrigger != null) {
      _shakeTrigger!.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('种树小遊戲'),
        actions: [
          IconButton(
            icon: Icon(Icons.forest),
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CatalogPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShopPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 天空背景
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sky1.png'), // 天空背景图
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GridView.builder(
                  padding: EdgeInsets.all(0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _handlePlantTap(index);
                      },
                      child: Stack(
                        children: [
                          // 为花盆添加背景图
                          PlantPot(plantState: plantStates[index]),
                          // 阶段一：growthTimers > 16 时显示 tree.riv 动画
                          if (plantStates[index] != 'empty' &&
                              growthTimers[index] > 16&&plantStates[index] != 'harvest') ...[
                            Positioned.fill(
                              key: ValueKey('tree'), // 为动画添加唯一 key
                              child: RiveAnimation.asset(
                                'assets/rive_animations/tree.riv',
                                fit: BoxFit.cover,
                                onInit: _onRiveInit,
                              ),
                            ),
                          ]
                          // 阶段二：16 >= growthTimers > 8 时显示 tree1.riv 动画
                          else if (plantStates[index] != 'empty' &&
                              growthTimers[index] < 17 &&
                              growthTimers[index] > 0) ...[
                            Positioned.fill(
                              key: ValueKey('tree1'), // 为动画添加唯一 key
                              child: RiveAnimation.asset(
                                'assets/rive_animations/tree1.riv',
                                fit: BoxFit.cover,
                                onInit: _onRiveInit,
                              ),
                            ),
                          ]
                        ],
                      ),
                    );
                  },
                ),
                // 浇水动画不受花盆框的限制，覆盖在花盆上方
                ...List.generate(9, (index) {
                  if (growthTimers[index] < 1) {
                    return Positioned(
                      top: (index ~/ 3) *
                          MediaQuery.of(context).size.width /
                          3, // 计算行位置
                      left: (index % 3) *
                          MediaQuery.of(context).size.width /
                          3, // 计算列位置
                      child: GestureDetector(
                        onTap: () => _harvestPlant(index), // 允许点击 tree2.riv 来收获植物
                        child: Transform.scale(
                          scale: 5, // 调整动画大小
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 100, // 调整高度以适应花盆
                            child: RiveAnimation.asset(
                              'assets/rive_animations/tree2.riv',
                              fit: BoxFit.contain,
                              animations: ['State Machine 1'],
                              onInit: _onRiveInit,
                              controllers: [
                                SimpleAnimation('State Machine 1',
                                    autoplay: true)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  // 其他的动画逻辑，例如 watering 或 fertilizing
                  if (plantStates[index] == 'watering') {
                    return Positioned(
                      top: (index ~/ 3) *
                          MediaQuery.of(context).size.width /
                          3, // 计算行位置
                      left: (index % 3) *
                          MediaQuery.of(context).size.width /
                          3, // 计算列位置
                      child: Transform.scale(
                        scale: 3.5, // 调整动画大小
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 50, // 调整高度以适应花盆
                          child: RiveAnimation.asset(
                            'assets/rive_animations/watering.riv',
                            fit: BoxFit.contain,
                            animations: ['State Machine 1'],
                            onInit: _onWateringRiveInit,
                            controllers: [
                              SimpleAnimation('State Machine 1',
                                  autoplay: true)
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (plantStates[index] == 'fertilizing') {
                    return Positioned(
                      top: (index ~/ 3) *
                          MediaQuery.of(context).size.width /
                          3, // 计算行位置
                      left: (index % 3) *
                          MediaQuery.of(context).size.width /
                          3, // 计算列位置
                      child: Transform.scale(
                        scale: 2.8, // 调整动画大小
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 80, // 调整高度以适应花盆
                          child: RiveAnimation.asset(
                            'assets/rive_animations/fertilizing.riv',
                            fit: BoxFit.contain,
                            animations: ['State Machine 1'],
                            onInit: _onFertilizingRiveInit,
                            controllers: [
                              SimpleAnimation('State Machine 1',
                                  autoplay: true)
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(); // 返回一个空的容器作为默认
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 处理花盆点击事件
  void _handlePlantTap(int index) {
    if (plantStates[index] == 'empty') {
      _showConfirmationDialog('种植', seedCount, '种子', () async {
        _savePlantState(index, 'seeded');
        _savePlantingTime(index); // 保存种植时间
        seedCount--;
        await updatePlantCounts(userEmail, seedCount, waterCount, fertilizerCount);
        Navigator.of(context).pop();
      });
    } else if (plantStates[index] == 'seeded') {
      _showConfirmationDialog('浇水', waterCount, '水', () async {
        _savePlantState(index, 'watering');
        _triggerShake(); // 播放 shake 动画
        _startGrowthTimer(index); // 继续倒计时
        waterCount--;
        await updatePlantCounts(userEmail, seedCount, waterCount, fertilizerCount);
        Navigator.of(context).pop();

        // 播放 watering 动画，并在结束时切换状态
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            plantStates[index] = 'watered'; // 设置为 watered 状态，结束动画
            _savePlantState(index, 'watered');
          });
        });
      });
    } else if (plantStates[index] == 'watered') {
      _showConfirmationDialog('施肥', fertilizerCount, '肥料', () async {
        _savePlantState(index, 'fertilizing');
        fertilizerCount--;
        await updatePlantCounts(userEmail, seedCount, waterCount, fertilizerCount);
        growthTimers[index] -= 12; // 减少 12 秒生长时间
        _startGrowthTimer(index); // 更新倒计时
        Navigator.of(context).pop();

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            plantStates[index] = 'fertilized'; // 设置为 fertilized 状态，结束动画
            _savePlantState(index, 'fertilized');
            _startGrowthTimer(index);
          });
        });
      });
    } else if (plantStates[index] == 'fertilized') {

    } else if (plantStates[index] == 'harvest') {
      _harvestPlant(index);
      // 收成后重置植物状态
      _resetPlantState(index); // 收成后重置状态
    }
  }

  // 重置花盆状态
  void _resetPlantState(int index) {
    setState(() {
      plantStates[index] = 'empty';
      growthTimers[index] = 24;
      timers[index]?.cancel();
      plantingTimes[index] = null;
      _prefs.setString('plant_$index', 'empty');
      _prefs.remove('plantingTime_$index');
    });
  }
}

// 花盆的部分背景
class PlantPot extends StatelessWidget {
  final String plantState;

  PlantPot({required this.plantState});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0), // 增加边距以突出边框效果
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 0.5), // 蓝色边框
        image: DecorationImage(
          image: AssetImage('assets/images/farmland.png'), // 花盆背景图
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: plantState == 'empty'
            ? Icon(Icons.add, color: Colors.grey)
            : Text(''),
      ),
    );
  }
}