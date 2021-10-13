
import 'package:flutter/widgets.dart';

extension StateExtensions on State {

  @protected
  void safeSetState(Function() stateChange){
    if (mounted){
      // ignore: invalid_use_of_protected_member
      setState(stateChange);
    } else {
      stateChange();
    }

  }

}

