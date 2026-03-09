import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:c_o2e/flutter_flow/shop_bar.dart';
import 'package:c_o2e/flutter_flow/shop_page.dart';
import 'package:c_o2e/flutter_flow/cart_page.dart';
import 'package:c_o2e/flutter_flow/model/cart.dart';
import 'shop_model.dart';
export 'shop_model.dart';
import 'package:provider/provider.dart';

// CouponPage should be created separately or imported if already exists
import 'package:c_o2e/flutter_flow/coupon_page.dart'; // Make sure you have this file

class ShopWidget extends StatefulWidget {
  const ShopWidget({super.key});

  @override
  State<ShopWidget> createState() => _ShopWidgetState();
}

class _ShopWidgetState extends State<ShopWidget> {
  late ShopModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ShopPage(),
    const CartPage(),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShopModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<int> _fetchUserVouchers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final totalVouchers = userDoc.data()?['totalVouchers'] ?? 0;
    return totalVouchers as int;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: Scaffold(
        bottomNavigationBar: ShopBar(
          onTabChange: (index) => navigateBottomBar(index),
        ),
        body: _pages[_selectedIndex],
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding:
              const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 30.0),
                onPressed: () async {
                  context.pop();
                },
              ),
            ),
            actions: [
              FutureBuilder<int>(
                future: _fetchUserVouchers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final totalVouchers = snapshot.data ?? 0;
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                    child: IconButton(
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.card_giftcard, color: Colors.black, size: 30.0),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 8.0,
                              backgroundColor: Colors.red,
                              child: Text(
                                '$totalVouchers',
                                style: const TextStyle(fontSize: 10.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CouponPage(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: const FlexibleSpaceBar(
              title: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add any additional title or widgets if needed
                  ],
                ),
              ),
              centerTitle: true,
              expandedTitleScale: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
