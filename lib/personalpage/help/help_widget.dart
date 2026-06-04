import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'help_model.dart';
export 'help_model.dart';

class HelpWidget extends StatefulWidget {
  const HelpWidget({super.key});

  @override
  State<HelpWidget> createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  late HelpModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpModel());

    _model.expandableExpandableController1 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController2 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController3 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController4 =
        ExpandableController(initialExpanded: false);
    _model.expandableExpandableController5 =
        ExpandableController(initialExpanded: false);
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
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          actions: const [],
          flexibleSpace: FlexibleSpaceBar(
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 14.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 0.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 30.0,
                            ),
                            onPressed: () async {
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Help',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Urbanist',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
          ),
          elevation: 0.0,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    height: 80.0,
                    decoration: const BoxDecoration(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: ExpandableNotifier(
                        controller: _model.expandableExpandableController1,
                        child: ExpandablePanel(
                          header: Text(
                            'Q1. Is the CO2e app free?',
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  fontFamily: 'Urbanist',
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          collapsed: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                'CO2e is free and has to be free, we’re on a mission to...',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          expanded: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'CO2e is free and has to be free, we’re on a mission to making sustainability easy and removing all barriers to help reduce humankind’s impact to the environment.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          theme: const ExpandableThemeData(
                            tapHeaderToExpand: true,
                            tapBodyToExpand: false,
                            tapBodyToCollapse: false,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            hasIcon: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80.0,
                    decoration: const BoxDecoration(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: ExpandableNotifier(
                        controller: _model.expandableExpandableController2,
                        child: ExpandablePanel(
                          header: Text(
                            'Q1. Is the CO2e app free?',
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  fontFamily: 'Urbanist',
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          collapsed: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                'CO2e is free and has to be free, we’re on a mission to...',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          expanded: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'CO2e is free and has to be free, we’re on a mission to making sustainability easy and removing all barriers to help reduce humankind’s impact to the environment.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          theme: const ExpandableThemeData(
                            tapHeaderToExpand: true,
                            tapBodyToExpand: false,
                            tapBodyToCollapse: false,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            hasIcon: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80.0,
                    decoration: const BoxDecoration(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: ExpandableNotifier(
                        controller: _model.expandableExpandableController3,
                        child: ExpandablePanel(
                          header: Text(
                            'Q1. Is the CO2e app free?',
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  fontFamily: 'Urbanist',
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          collapsed: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                'CO2e is free and has to be free, we’re on a mission to...',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          expanded: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'CO2e is free and has to be free, we’re on a mission to making sustainability easy and removing all barriers to help reduce humankind’s impact to the environment.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          theme: const ExpandableThemeData(
                            tapHeaderToExpand: true,
                            tapBodyToExpand: false,
                            tapBodyToCollapse: false,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            hasIcon: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80.0,
                    decoration: const BoxDecoration(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: ExpandableNotifier(
                        controller: _model.expandableExpandableController4,
                        child: ExpandablePanel(
                          header: Text(
                            'Q1. Is the CO2e app free?',
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  fontFamily: 'Urbanist',
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          collapsed: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                'CO2e is free and has to be free, we’re on a mission to...',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          expanded: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'CO2e is free and has to be free, we’re on a mission to making sustainability easy and removing all barriers to help reduce humankind’s impact to the environment.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          theme: const ExpandableThemeData(
                            tapHeaderToExpand: true,
                            tapBodyToExpand: false,
                            tapBodyToCollapse: false,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            hasIcon: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80.0,
                    decoration: const BoxDecoration(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: ExpandableNotifier(
                        controller: _model.expandableExpandableController5,
                        child: ExpandablePanel(
                          header: Text(
                            'Q1. Is the CO2e app free?',
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  fontFamily: 'Urbanist',
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          collapsed: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                'CO2e is free and has to be free, we’re on a mission to...',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          expanded: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'CO2e is free and has to be free, we’re on a mission to making sustainability easy and removing all barriers to help reduce humankind’s impact to the environment.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0x8A000000),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          theme: const ExpandableThemeData(
                            tapHeaderToExpand: true,
                            tapBodyToExpand: false,
                            tapBodyToCollapse: false,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            hasIcon: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
