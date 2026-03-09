import 'package:c_o2e/pages/badge/unlock_badge.dart';

import '../../flutter_flow/calendar.dart';
import '../../pesonalpage/shop/shop_widget.dart';
import '../action/action_home.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

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
                  await checkAndUnlockBadges(context);
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
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Carbon emissions calculator',
          //   textAlign: TextAlign.center,
          //   style: FlutterFlowTheme.of(context).bodyLarge.override(
          //         fontFamily: 'Plus Jakarta Sans',
          //         color: FlutterFlowTheme.of(context).primaryText,
          //         fontSize: 20.0,
          //         letterSpacing: 0.0,
          //         fontWeight: FontWeight.w800,
          //       ),
          // ),
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Expanded(
          //       child: Container(
          //         width: 200.0,
          //         height: 100.0,
          //         decoration: BoxDecoration(
          //           color: FlutterFlowTheme.of(context).secondaryBackground,
          //         ),
          //         child: FFButtonWidget(
          //           onPressed: () async {
          //             context.pushNamed('chat_ai_Screen');
          //           },
          //           text: 'AI Calculator',
          //           options: FFButtonOptions(
          //             height: 40.0,
          //             padding: const EdgeInsetsDirectional.fromSTEB(
          //                 24.0, 0.0, 24.0, 0.0),
          //             iconPadding: const EdgeInsetsDirectional.fromSTEB(
          //                 0.0, 0.0, 0.0, 0.0),
          //             color: FlutterFlowTheme.of(context).primary,
          //             textStyle:
          //                 FlutterFlowTheme.of(context).titleSmall.override(
          //                       fontFamily: 'Plus Jakarta Sans',
          //                       color: Colors.white,
          //                       letterSpacing: 0.0,
          //                     ),
          //             elevation: 3.0,
          //             borderSide: const BorderSide(
          //               color: Colors.transparent,
          //               width: 1.0,
          //             ),
          //             borderRadius: BorderRadius.circular(8.0),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         width: 200.0,
          //         height: 100.0,
          //         decoration: BoxDecoration(
          //           color: FlutterFlowTheme.of(context).secondaryBackground,
          //         ),
          //         child: FFButtonWidget(
          //           onPressed: () async {
          //             context.pushNamed('simple_calculator_Screen');
          //           },
          //           text: 'Simple calculator',
          //           options: FFButtonOptions(
          //             height: 40.0,
          //             padding: const EdgeInsetsDirectional.fromSTEB(
          //                 24.0, 0.0, 24.0, 0.0),
          //             iconPadding: const EdgeInsetsDirectional.fromSTEB(
          //                 0.0, 0.0, 0.0, 0.0),
          //             color: FlutterFlowTheme.of(context).primary,
          //             textStyle:
          //                 FlutterFlowTheme.of(context).titleSmall.override(
          //                       fontFamily: 'Plus Jakarta Sans',
          //                       color: Colors.white,
          //                       letterSpacing: 0.0,
          //                     ),
          //             elevation: 3.0,
          //             borderSide: const BorderSide(
          //               color: Colors.transparent,
          //               width: 1.0,
          //             ),
          //             borderRadius: BorderRadius.circular(8.0),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          // Row(mainAxisSize: MainAxisSize.max, children: [
          //   Expanded(
          //     child: Container(
          //       width: 200.0,
          //       height: 100.0,
          //       decoration: BoxDecoration(
          //         color: FlutterFlowTheme.of(context).secondaryBackground,
          //       ),
          //       child: FFButtonWidget(
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => Calendar()),
          //           );
          //         },
          //         text: 'calendar',
          //         options: FFButtonOptions(
          //           height: 40.0,
          //           padding: const EdgeInsetsDirectional.fromSTEB(
          //               24.0, 0.0, 24.0, 0.0),
          //           iconPadding: const EdgeInsetsDirectional.fromSTEB(
          //               0.0, 0.0, 0.0, 0.0),
          //           color: FlutterFlowTheme.of(context).primary,
          //           textStyle: FlutterFlowTheme.of(context).titleSmall.override(
          //                 fontFamily: 'Plus Jakarta Sans',
          //                 color: Colors.white,
          //                 letterSpacing: 0.0,
          //               ),
          //           elevation: 3.0,
          //           borderSide: const BorderSide(
          //             color: Colors.transparent,
          //             width: 1.0,
          //           ),
          //           borderRadius: BorderRadius.circular(8.0),
          //         ),
          //       ),
          //     ),
          //   ),
          //   Expanded(
          //     child: Container(
          //       width: 200.0,
          //       height: 100.0,
          //       decoration: BoxDecoration(
          //         color: FlutterFlowTheme.of(context).secondaryBackground,
          //       ),
          //       child: FFButtonWidget(
          //         onPressed: () async {
          //           context.pushNamed('action_home');
          //         },
          //         text: 'action',
          //         options: FFButtonOptions(
          //           height: 40.0,
          //           padding: const EdgeInsetsDirectional.fromSTEB(
          //               24.0, 0.0, 24.0, 0.0),
          //           iconPadding: const EdgeInsetsDirectional.fromSTEB(
          //               0.0, 0.0, 0.0, 0.0),
          //           color: FlutterFlowTheme.of(context).primary,
          //           textStyle: FlutterFlowTheme.of(context).titleSmall.override(
          //                 fontFamily: 'Plus Jakarta Sans',
          //                 color: Colors.white,
          //                 letterSpacing: 0.0,
          //               ),
          //           elevation: 3.0,
          //           borderSide: const BorderSide(
          //             color: Colors.transparent,
          //             width: 1.0,
          //           ),
          //           borderRadius: BorderRadius.circular(8.0),
          //         ),
          //       ),
          //     ),
          //   ),
          // ]),
          // FFButtonWidget(
          //   onPressed: () {
          //     print('Button pressed ...');
          //   },
          //   text: 'AI calculator',
          //   options: FFButtonOptions(
          //     height: 0.0,
          //     padding:
          //         const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          //     iconPadding:
          //         const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          //     color: FlutterFlowTheme.of(context).primary,
          //     textStyle: FlutterFlowTheme.of(context).titleMedium.override(
          //           fontFamily: 'Plus Jakarta Sans',
          //           letterSpacing: 0.0,
          //         ),
          //     elevation: 3.0,
          //     borderSide: const BorderSide(
          //       color: Colors.transparent,
          //       width: 1.0,
          //     ),
          //     borderRadius: BorderRadius.circular(8.0),
          //   ),
          // ),
          // Integrate the Calendar widget here
          Expanded(
            child: Calendar(),
          ),
        ],
      ),
    );
  }
}
