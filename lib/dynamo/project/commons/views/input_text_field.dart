import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField {
  late TextEditingController inputTextFilter = TextEditingController();
  String? selectedTextValue;
  int? cursorPosition = -1;
  FocusNode? inputTextFocusNode = FocusNode();

  InputTextField({String initialText = ""}) {
    inputTextFilter.text = initialText;
    selectedTextValue = "";

    inputTextFilter.addListener(textItemListener);
    inputTextFocusNode = FocusNode(onKeyEvent: (node, event) {
      if (event is KeyDownEvent || event is KeyRepeatEvent) {
        final bool isDeleteKey = event.logicalKey == LogicalKeyboardKey.backspace || event.logicalKey == LogicalKeyboardKey.delete;

        if (isDeleteKey) {
          if (inputTextFilter.text.length <= 1) {
            inputTextFilter.text = "";
          } else {
            inputTextFilter.text = inputTextFilter.text.substring(0, inputTextFilter.text.length - 1);
          }
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    });
  }

  void textItemListener() {
    if (inputTextFilter.text.isEmpty) {
      selectedTextValue = "";
    } else {
      selectedTextValue = inputTextFilter.text;
    }

    cursorPosition = inputTextFilter.selection.base.offset;
  }
}
