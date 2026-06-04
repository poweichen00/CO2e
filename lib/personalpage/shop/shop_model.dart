import '/flutter_flow/flutter_flow_util.dart';
import 'shop_widget.dart' show ShopWidget;
import 'package:flutter/material.dart';

class ShopModel extends FlutterFlowModel<ShopWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading1 = false;
  FFUploadedFile uploadedLocalFile1 = FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl1 = '';

  bool isDataUploading2 = false;
  FFUploadedFile uploadedLocalFile2 = FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl2 = '';

  // State field(s) for search functionality.
  FocusNode? searchFocusNode;
  TextEditingController? searchController;

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameTextController;
  String? Function(BuildContext, String?)? yourNameTextControllerValidator;

  // State field(s) for phone widget.
  FocusNode? phoneFocusNode;
  TextEditingController? phoneTextController;
  String? Function(BuildContext, String?)? phoneTextControllerValidator;

  @override
  void initState(BuildContext context) {
    // Initialize search-related controllers and focus nodes.
    searchController ??= TextEditingController();
    searchFocusNode ??= FocusNode();

    // Initialize other controllers and focus nodes if needed.
    yourNameTextController ??= TextEditingController();
    phoneTextController ??= TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of search-related controllers and focus nodes.
    searchController?.dispose();
    searchFocusNode?.dispose();

    // Dispose of other controllers and focus nodes.
    yourNameTextController?.dispose();
    yourNameFocusNode?.dispose();
    phoneTextController?.dispose();
    phoneFocusNode?.dispose();
  }
}
