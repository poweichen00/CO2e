import 'dart:async';

import 'package:c_o2e/pesonalpage/shop/shop_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'achievement_model.dart';
export 'achievement_model.dart';

class AchievementWidget extends StatefulWidget {
  const AchievementWidget({super.key});

  @override
  State<AchievementWidget> createState() => _AchievementWidgetState();
}

class CarbonFootprintEntry {
  final int rank;
  final String userName;
  final double averageCarbonFootprint;

  CarbonFootprintEntry({
    required this.rank,
    required this.userName,
    required this.averageCarbonFootprint,
  });

  // Add copyWith method
  CarbonFootprintEntry copyWith({
    int? rank,
    String? userName,
    double? averageCarbonFootprint,
  }) {
    return CarbonFootprintEntry(
      rank: rank ?? this.rank,
      userName: userName ?? this.userName,
      averageCarbonFootprint: averageCarbonFootprint ?? this.averageCarbonFootprint,
    );
  }
}



class LeaderboardEntry {
  final int rank;
  final String userName;
  final int totalPoints;

  LeaderboardEntry({
    required this.rank,
    required this.userName,
    required this.totalPoints,
  });
}



class _AchievementWidgetState extends State<AchievementWidget>
    with TickerProviderStateMixin {
  late AchievementModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  
  int _pendingRequests = 0;
  bool _showPointsLeaderboard = true; // 控制顯示哪個排行榜
  StreamSubscription<DocumentSnapshot>? _pendingRequestsSubscription;

  double totalCarbonFootprint = 0.0; // 新增这个变量来储存总值
  bool _showFriendsOnly = false; // 控制顯示所有使用者還是僅好友

  void _toggleLeaderboard(bool isPointsLeaderboard) {
    setState(() {
      _showPointsLeaderboard = isPointsLeaderboard;
    });
  }

  void _toggleView() {
    setState(() {
      _showFriendsOnly = !_showFriendsOnly;
    });
  }
  @override
  void initState() {
    super.initState();
    _subscribeToPendingRequests();
    _model = createModel(context, () => AchievementModel());

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(-40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
    _pendingRequestsSubscription?.cancel();
  }

  void _subscribeToPendingRequests() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Subscribe to changes in the user's document in Firebase
      _pendingRequestsSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots()
          .listen((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null) {
            final pendingRequests =
                List<String>.from(data['pendingRequests'] ?? []);
            setState(() {
              _pendingRequests = pendingRequests.length;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      endDrawer: Drawer(
        elevation: 16.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: 160.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary,
              ),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 20.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: FlutterFlowTheme.of(context).alternate,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: AuthUserStreamWidget(
                          builder: (context) => ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              valueOrDefault<String>(
                                currentUserPhoto,
                                'https://static1.squarespace.com/static/5b19478afcf7fdf58822588e/5bbf1fdf104c7bc7af13d373/5f8053af45255f310b97f900/1602309565844/CO2e+thumbnail.jpg?format=1500w',
                              ),
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            8.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthUserStreamWidget(
                              builder: (context) => Text(
                                currentUserDisplayName,
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Text(
                                currentUserEmail,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0xB4FFFFFF),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed('ProfileEdit');
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        width: 0.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 4.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '編輯資料',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed('Changepassword');
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        width: 0.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 4.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '修改密碼',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShopWidget(),
                    ),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        width: 0.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 4.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '兌換商店',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed('Friend');
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        width: 0.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 4.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '朋友',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed('badge_home');
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        width: 0.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 4.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '徽章',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed('Help');
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        width: 0.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 4.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '常見問題',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 40.0),
              child: FFButtonWidget(
                onPressed: () async {
                  GoRouter.of(context).prepareAuthEvent();
                  await authManager.signOut();
                  GoRouter.of(context).clearRedirectLocation();

                  context.goNamedAuth('login', context.mounted);
                },
                text: '登出',
                options: FFButtonOptions(
                  width: 110.0,
                  height: 50.0,
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Plus Jakarta Sans',
                        letterSpacing: 0.0,
                      ),
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if ((Theme.of(context).brightness == Brightness.light) ==
                      true) {
                    setDarkModeSetting(context, ThemeMode.dark);
                    if (animationsMap['containerOnActionTriggerAnimation'] !=
                        null) {
                      animationsMap['containerOnActionTriggerAnimation']!
                          .controller
                          .forward(from: 0.0);
                    }
                  } else {
                    setDarkModeSetting(context, ThemeMode.light);
                    if (animationsMap['containerOnActionTriggerAnimation'] !=
                        null) {
                      animationsMap['containerOnActionTriggerAnimation']!
                          .controller
                          .reverse();
                    }
                  }
                },
                child: Container(
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: const Color(0xFFE0E3E7),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      children: [
                        const Align(
                          alignment: AlignmentDirectional(-0.9, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                6.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              Icons.wb_sunny_rounded,
                              color: Color(0xFF57636C),
                              size: 24.0,
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 6.0, 0.0),
                            child: Icon(
                              Icons.mode_night_rounded,
                              color: Color(0xFF57636C),
                              size: 24.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(1.0, 0.0),
                          child: Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x430B0D0F),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(30.0),
                              shape: BoxShape.rectangle,
                            ),
                          ).animateOnActionTrigger(
                            animationsMap['containerOnActionTriggerAnimation']!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: const AlignmentDirectional(-1.0, 0.0),
          child: Text(
            'CO2e',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Urbanist',
                  color: Colors.white,
                  fontSize: 28.0,
                  letterSpacing: 0.0,
                ),
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: Column(
        children: [
        // Buttons to switch between leaderboards and view mode
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showPointsLeaderboard = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: Text('碳排排行榜'),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showPointsLeaderboard = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: Text('點數排行榜'),
                      ),
                    ),
                    SizedBox(width: 8.0),
                  ],
                ),
                
                // Row for friends vs all users toggle button
                Row(
                  children: [
                    SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showFriendsOnly = !_showFriendsOnly;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(_showFriendsOnly ? '顯示所有使用者' : '顯示好友'),
                      ),
                    ),
                    SizedBox(width: 8.0),
                  ],
                ),
              ],
            ),
          ),
          // Content based on the selected leaderboard
          Expanded(
  child: _showPointsLeaderboard
      ? FutureBuilder<List<LeaderboardEntry>>(
          future: fetchLeaderboard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching leaderboard'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No leaderboard data available'));
            }

            final leaderboardEntries = snapshot.data!;

            return FutureBuilder<LeaderboardEntry?>( 
              future: getCurrentUserLeaderboardEntry(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error fetching current user entry'));
                } else if (!userSnapshot.hasData) {
                  return Center(child: Text('Current user not found in leaderboard'));
                }

                final currentUserEntry = userSnapshot.data!;

                return Column(
                  children: [
                    // Points Leaderboard Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          // 名次 - 放在最左邊
                          Expanded(
                            flex: 1,
                            child: Text(
                              '名次',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          // 名稱 - 放在中間
                          Expanded(
                            flex: 3,
                            child: Text(
                              '名稱',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          // 總點數 - 放在最右邊
                          Expanded(
                            flex: 2,
                            child: Text(
                              '總點數',
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Leaderboard List
                    Expanded(
                      child: ListView.builder(
                        itemCount: leaderboardEntries.length,
                        itemBuilder: (context, index) {
                          final entry = leaderboardEntries[index];
                          return ListTile(
                            leading: Text(entry.rank.toString()),
                            title: Text(entry.userName),
                            trailing: Text(entry.totalPoints.toString()),
                          );
                        },
                      ),
                    ),
                    // Current User Entry
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 5.0,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text('你的排名: ${currentUserEntry.rank == 0 ? '無排名' : currentUserEntry.rank}'),
                          subtitle: Text('總點數: ${currentUserEntry.totalPoints}'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        )
      : FutureBuilder<List<CarbonFootprintEntry>>(
                  future: fetchCarbonFootprintLeaderboard(friendsOnly: _showFriendsOnly),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error fetching carbon footprint leaderboard'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No carbon footprint data available'));
                    }

                    final carbonFootprintEntries = snapshot.data!;

                    return FutureBuilder<CarbonFootprintEntry?>(
                      future: getCurrentUserCarbonFootprintEntry(FirebaseAuth.instance.currentUser!.uid, friendsOnly: _showFriendsOnly),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (userSnapshot.hasError) {
                          return Center(child: Text('Error fetching current user carbon footprint entry'));
                        } else if (!userSnapshot.hasData) {
                          return Center(child: Text('Current user not found in carbon footprint leaderboard'));
                        }

                        final currentUserEntry = userSnapshot.data!;

                        return Column(
                          children: [
                            // 排行榜表頭
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  // 名次 - 放在最左邊
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '名次',
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                  // 名稱 - 放在中間
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '名稱',
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                  // 平均碳排量 - 放在最右邊
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      ' 平均碳排量\n（公斤/日）',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 碳排排行榜列表
                            Expanded(
                              child: ListView.builder(
                                itemCount: carbonFootprintEntries.length,
                                itemBuilder: (context, index) {
                                  final entry = carbonFootprintEntries[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                    leading: Text((index + 1).toString(), textAlign: TextAlign.left),
                                    title: Text(entry.userName, textAlign: TextAlign.left),
                                    trailing: Text(entry.averageCarbonFootprint.toStringAsFixed(2), textAlign: TextAlign.right),
                                  );
                                },
                              ),
                            ),
                            // 當前用戶條目
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Card(
                                elevation: 5.0,
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16.0),
                                  title: Text('你的排名: ${currentUserEntry.rank == 0 ? '無排名' : currentUserEntry.rank}'),
                                  subtitle: Text('每日平均碳排放量: ${currentUserEntry.averageCarbonFootprint.toStringAsFixed(2)}公斤\n'
                                    '聯合國建議每人每天的碳排放量為5公斤'),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
),

        ],
      ),
    );
  }



Future<List<LeaderboardEntry>> fetchLeaderboard() async {
  try {
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    // Fetch current user's friends if the filter is active
    List<String> friendEmails = [];
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null && _showFriendsOnly) {
      final currentUserDoc = await FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get();
      if (currentUserDoc.docs.isNotEmpty) {
        final currentUserData = currentUserDoc.docs.first.data();
        friendEmails = List<String>.from(currentUserData['friends'] ?? []);
      }
    }

    // Prepare leaderboard entries
    List<LeaderboardEntry> leaderboardEntries = [];
    for (var doc in usersSnapshot.docs) {
      final data = doc.data();
      final userEmail = data['email'] as String?;
      final totalPoints = data['totalPoint'] ?? 0;
      final userName = data['display_name'] ?? '';

      // Include the current user in the leaderboard
      if (userEmail == currentUserEmail || (totalPoints > 0 && (!_showFriendsOnly || (userEmail != null && friendEmails.contains(userEmail))))) {
        leaderboardEntries.add(
          LeaderboardEntry(
            rank: 0, // Placeholder, will be updated after sorting
            userName: userName,
            totalPoints: totalPoints,
          ),
        );
      }
    }

    // Sort by totalPoints in descending order
    leaderboardEntries.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

    // Update ranks after sorting
    for (int i = 0; i < leaderboardEntries.length; i++) {
      leaderboardEntries[i] = LeaderboardEntry(
        rank: i + 1,
        userName: leaderboardEntries[i].userName,
        totalPoints: leaderboardEntries[i].totalPoints,
      );
    }

    return leaderboardEntries;
  } catch (e) {
    print('Error fetching leaderboard: $e');
    return [];
  }
}






Future<LeaderboardEntry?> getCurrentUserLeaderboardEntry(String currentUserId) async {
  try {
    // Fetch current user data
    final currentUserDoc = await FirebaseFirestore.instance.collection('users')
      .doc(currentUserId)
      .get();

    if (!currentUserDoc.exists) {
      print('Current user document does not exist.');
      return null;
    }

    final currentUserData = currentUserDoc.data();
    final currentUserPoints = currentUserData?['totalPoint'] ?? 0;
    final currentUserName = currentUserData?['display_name'] ?? '';

    // Fetch the entire leaderboard
    final leaderboardEntries = await fetchLeaderboard();

    // Find the current user's entry
    final currentUserEntry = leaderboardEntries.firstWhere(
      (entry) => entry.userName == currentUserName,
      orElse: () => LeaderboardEntry(rank: 0, userName: currentUserName, totalPoints: currentUserPoints),
    );

    return currentUserEntry;
  } catch (e) {
    print('Error getting current user leaderboard entry: $e');
    return null;
  }
}


Future<List<CarbonFootprintEntry>> fetchCarbonFootprintLeaderboard({required bool friendsOnly}) async {
  try {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final query = FirebaseFirestore.instance.collection('events');

    QuerySnapshot querySnapshot;
    List<String> friends = [];

    if (friendsOnly) {
      // 获取当前用户的好友并确保当前用户包含在好友列表中
      final currentUserDoc = await FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get();

      if (currentUserDoc.docs.isEmpty) {
        throw Exception('当前用户未找到。');
      }

      // 获取好友列表
      friends = List<String>.from(currentUserDoc.docs.first.data()['friends'] ?? []);
      friends.add(currentUserEmail); // 确保当前用户在好友列表中
      print('好友列表（包括当前用户）：$friends');

      // 查询事件集合中的好友数据
      querySnapshot = await query.where('userEmail', whereIn: friends).get();
    } else {
      // 获取所有用户的事件数据
      querySnapshot = await query.get();
    }

    // 按用户收集和聚合碳排放数据
    final userFootprints = <String, List<double>>{};
    querySnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final userEmail = data['userEmail'] as String;
      final carbonFootprint = (data['carbonFootprint'] ?? 0.0) as double;

      if (userFootprints.containsKey(userEmail)) {
        userFootprints[userEmail]!.add(carbonFootprint);
      } else {
        userFootprints[userEmail] = [carbonFootprint];
      }
    });

    // 获取所有用户的 display_name，并排除没有 display_name 的用户
    final userEntries = <CarbonFootprintEntry>[];
    for (var entry in userFootprints.entries) {
      final userEmail = entry.key;
      final footprints = entry.value;
      final averageFootprint = footprints.isEmpty
          ? 0.0
          : footprints.reduce((a, b) => a + b) / footprints.length;

      // 获取用户的 display_name
      final userDoc = await FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();

      // 如果没有 display_name，则跳过此用户
      if (userDoc.docs.isEmpty || userDoc.docs.first.data()['display_name'] == null) {
        continue;
      }

      final userName = userDoc.docs.first.data()['display_name'] as String;

      userEntries.add(
        CarbonFootprintEntry(
          rank: 0, // 初始 rank
          userName: userName, // 使用 display_name
          averageCarbonFootprint: averageFootprint,
        ),
      );
    }

    // 根据平均碳排量排序，低的排名靠前
    userEntries.sort((a, b) => a.averageCarbonFootprint.compareTo(b.averageCarbonFootprint));

    // 计算排名
    for (int i = 0; i < userEntries.length; i++) {
      userEntries[i] = userEntries[i].copyWith(rank: i + 1);
    }
    
     // 查找当前用户的排名
    final currentUserEntry = userEntries.firstWhere(
      (entry) => entry.userName == currentUserEmail || entry.userName == FirebaseAuth.instance.currentUser!.displayName,
      orElse: () => CarbonFootprintEntry(rank: 0, userName: currentUserEmail, averageCarbonFootprint: 0),
    );

    // 如果当前用户不在好友列表中，将其添加到结果中
    if (friendsOnly && !friends.contains(currentUserEmail)) {
      userEntries.add(currentUserEntry);
    }
    // 返回处理后的排行榜
    return userEntries;
  } catch (e) {
    print('获取碳排排行榜时出错：$e');
    return [];
  }
}




Future<CarbonFootprintEntry?> getCurrentUserCarbonFootprintEntry(String currentUserId, {required bool friendsOnly}) async {
  try {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    // 获取当前用户的名称
    final userDoc = await FirebaseFirestore.instance.collection('users')
      .where('email', isEqualTo: currentUserEmail)
      .limit(1)
      .get();

    if (userDoc.docs.isEmpty) {
      print('用户未找到。');
      return null;
    }

    final userName = userDoc.docs.first.data()['display_name'] ?? '';

    if (userName.isEmpty) {
      print('用户名称为空。');
      return null;
    }

    // 获取用户的事件数据
    final userEventsSnapshot = await FirebaseFirestore.instance.collection('events')
      .where('userEmail', isEqualTo: currentUserEmail)
      .get();

    if (userEventsSnapshot.docs.isEmpty) {
      // 没有事件数据时返回默认的足迹条目
      return CarbonFootprintEntry(
        rank: 0,
        userName: userName,
        averageCarbonFootprint: 0.0,
      );
    }

    final carbonFootprints = userEventsSnapshot.docs.map((doc) => (doc.data()['carbonFootprint'] ?? 0.0) as double).toList();
    
    final totalDays = carbonFootprints.length;
    final totalFootprint = carbonFootprints.reduce((a, b) => a + b);
    final averageFootprint = totalDays == 0 ? 0.0 : totalFootprint / totalDays;
  
    // 获取排行榜数据
    final allEntries = await fetchCarbonFootprintLeaderboard(friendsOnly: friendsOnly);

    // 查找用户的排名，基于 display_name 而不是 email
    final userRank = allEntries.indexWhere((entry) => entry.userName == userName);

    // 如果找不到，userRank 将为 -1，这种情况下应返回 0 排名
    return CarbonFootprintEntry(
      rank: userRank == -1 ? 0 : userRank + 1,
      userName: userName,
      averageCarbonFootprint: averageFootprint,
    );
  } catch (e) {
    print('获取当前用户碳足迹条目时出错：$e');
    return null;
  }
}

}
