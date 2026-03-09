import '/flutter_flow/flutter_flow_util.dart';
import 'friend_widget.dart' show FriendWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class FriendModel extends FlutterFlowModel<FriendWidget> {
  /// State fields for stateful widgets in this page.

  // State fields for Expandable widget.
  late ExpandableController expandableExpandableController1;
  late ExpandableController expandableExpandableController2;
  late ExpandableController expandableExpandableController3;
  late ExpandableController expandableExpandableController4;
  late ExpandableController expandableExpandableController5;

  // Initialize the ExpandableControllers
  @override
  void initState(BuildContext context) {
    // Initialize ExpandableControllers
    expandableExpandableController1 = ExpandableController();
    expandableExpandableController2 = ExpandableController();
    expandableExpandableController3 = ExpandableController();
    expandableExpandableController4 = ExpandableController();
    expandableExpandableController5 = ExpandableController();
  }

  // Dispose of the ExpandableControllers
  @override
  void dispose() {
    // Dispose of ExpandableControllers
    expandableExpandableController1.dispose();
    expandableExpandableController2.dispose();
    expandableExpandableController3.dispose();
    expandableExpandableController4.dispose();
    expandableExpandableController5.dispose();
  }
}
