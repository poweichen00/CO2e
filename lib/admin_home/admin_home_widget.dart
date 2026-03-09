import 'package:c_o2e/admin_home/dashboard_screen.dart';
import 'package:c_o2e/admin_home/members_screen.dart';
import 'package:c_o2e/admin_home/posts_screen.dart';
import 'package:c_o2e/admin_home/shop_screen.dart';
import 'package:c_o2e/index.dart';
import 'package:c_o2e/login/login/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'admin_home_model.dart';
export 'admin_home_model.dart';

class AdminHomeWidget extends StatefulWidget {
  const AdminHomeWidget({super.key});

  static const String id = "webmain";

  @override
  State<AdminHomeWidget> createState() => _AdminHomeWidgetState();
}

class _AdminHomeWidgetState extends State<AdminHomeWidget> {
  late AdminHomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget selectedScreen = MembersScreen();

  void chooseScreen(String route) {
    switch (route) {
      case DashBoardScreen.id:
        setState(() {
          selectedScreen = const DashBoardScreen();
        });
        break;
      case MembersScreen.id:
        setState(() {
          selectedScreen = const MembersScreen();
        });
        break;
      case PostsScreen.id:
        setState(() {
          selectedScreen = PostsScreen();
        });
        break;
      case AdminShopPage.id:
        setState(() {
          selectedScreen = const AdminShopPage();
        });
        break;
      case LoginWidget.id:
        setState(() {
          selectedScreen = const LoginWidget();
        });
        break;
      default:
    }
  }

  void logout(BuildContext context) async {
    // Show confirmation dialog
    bool confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('確認登出'),
        content: Text('您確定要登出嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('確定'),
          ),
        ],
      ),
    );

    // If user confirms logout, proceed with sign out
    if (confirmLogout == true) {
      try {
        await FirebaseAuth.instance.signOut();
        // Navigate to the initial screen after logout
        context.goNamedAuth('_initialize', mounted);
      } catch (e) {
        print('Error signing out: $e');
        // Handle sign out error, e.g., show an error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('登出時發生錯誤'),
            content: Text('無法完成登出操作。請稍後重試。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('確定'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminHomeModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: AdminScaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("ADMIN"),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  logout(context);
                  // Navigate to login screen or home screen after logout.
                  // Example: Navigator.of(context).pushReplacementNamed(LoginScreen.id);
                },
              ),
            ],
          ),
          sideBar: SideBar(
              onSelected: (item) {
                chooseScreen(item.route as String);
              },
              items: const [
                //  之後可以再加看要不要
                // AdminMenuItem(
                //     title: "DACHBOARD",
                //     icon: Icons.dashboard,
                //     route: DashBoardScreen.id
                // ),
                AdminMenuItem(
                    title: "會員管理", icon: Icons.person, route: MembersScreen.id),
                AdminMenuItem(
                    title: "貼文管理", icon: Icons.post_add, route: PostsScreen.id),
                AdminMenuItem(
                    title: "商店管理", icon: Icons.shop, route: AdminShopPage.id),
              ],
              selectedRoute: AdminHomeWidget.id),
          body: selectedScreen),
    );
  }
}
