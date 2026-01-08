// ignore_for_file: comment_references

import 'package:dynamo_data_table/dynamo/project/commons/system/entities/message_type.dart';
import 'package:dynamo_data_table/dynamo/project/commons/system/handlers/dynamo_commons.dart';
import 'package:flutter/material.dart';

import 'button_icon_position_type.dart';

typedef OnButtonTapped = void Function();
typedef OnButtonPressed = void Function();

class TableWidgetCommons {
  static String searchText = "";
  static String discussionMessage = "";
  static bool incognitoMode = false;
  //
  static late Widget? emojiDisplayPanel;

  static Widget debugPrint(String printText) {
    debugPrint(printText);
    return Container();
  }

  static Widget buildSlimDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String label,
    Color dropdownColor = Colors.white,
  }) {
    return Column(
      children: [
        Text(label),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100, // Background color
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<T>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.toString()),
                    ))
                .toList(),
            onChanged: onChanged,
            dropdownColor: dropdownColor,
          ),
        ),
      ],
    );
  }

  static List<Widget> buildSpacerDividerSet(
    BuildContext context, {
    Color? dividerColor = const Color(0xff006784),
  }) {
    return [
      const SizedBox(height: 20),
      Divider(
        height: 5,
        thickness: 0.25,
        indent: 20,
        endIndent: 0,
        color: dividerColor,
      ),
      const SizedBox(height: 10),
    ];
  }

  static Widget bottonControlsPanel(Widget bottomContainer, BuildContext context, {double widgetHeight = 70.0, double widgetWidth = 0.6}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (!DynamoCommons.isMobile(context))
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
          ),
        SizedBox(
          height: widgetHeight,
          width: MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 1.0 : widgetWidth),
          child: bottomContainer,
        ),
        if (!DynamoCommons.isMobile(context))
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
          ),
      ],
    );
  }

  static Widget getRoundedButton(
    String? buttonLabel,
    OnButtonTapped onButtonTapped,
    Icon icon, {
    ButtonIconPositionType iconPositionType = ButtonIconPositionType.left,
    bool hasRadiusFactor = true,
    Color buttonBodyColor = const Color(0xffeef2f7),
    Color buttonBorderColor = Colors.indigo,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: buttonBodyColor,
        borderRadius: hasRadiusFactor ? const BorderRadius.all(Radius.circular(10.0)) : const BorderRadius.all(Radius.circular(0)),
        border: Border.all(color: buttonBorderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: hasRadiusFactor ? const BorderRadius.all(Radius.circular(10.0)) : const BorderRadius.all(Radius.circular(0)),
          onTap: onButtonTapped,
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6, left: 18, right: 18),
            child: Center(
              child: getButtonTextSpan(buttonLabel, icon, iconPositionType),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getFineButtonShape(String? buttonLabel,
      {Icon? icon,
      ButtonIconPositionType iconPositionType = ButtonIconPositionType.left,
      bool hasRadiusFactor = true,
      Color buttonBodyColor = const Color(0xffeef2f7),
      Color buttonBorderColor = Colors.indigo,
      Color? textColor,
      bool showBorder = false,
      String tooltipText = ""}) {
    icon = icon != null ? Icon(icon.icon, color: buttonBorderColor) : null;

    return Container(
      decoration: BoxDecoration(
        color: buttonBodyColor,
        borderRadius: const BorderRadius.all(Radius.circular(7.0)),
        border: showBorder ? Border.all(color: buttonBorderColor) : Border.all(color: Colors.transparent),
      ),
      child: Material(
        color: Colors.transparent,
        child: Tooltip(
          message: tooltipText,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(7.0)),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 7, right: 7),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      letterSpacing: 0.27,
                      color: textColor ?? Colors.black,
                    ),
                    children: [
                      if (icon != null)
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: icon,
                          ),
                        ),
                      TextSpan(text: buttonLabel),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getFineRoundedButton(String? buttonLabel, OnButtonTapped onButtonTapped, Icon icon,
      {ButtonIconPositionType iconPositionType = ButtonIconPositionType.left,
      bool hasRadiusFactor = true,
      Color buttonBodyColor = const Color(0xffeef2f7),
      Color buttonBorderColor = Colors.indigo,
      Color? textColor,
      bool showBorder = false,
      String tooltipText = ""}) {
    icon = Icon(icon.icon, color: buttonBorderColor);

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: buttonBodyColor,
        borderRadius: const BorderRadius.all(Radius.circular(7.0)),
        border: showBorder ? Border.all(color: Colors.grey) : Border.all(color: Colors.transparent),
      ),
      child: Material(
        color: Colors.transparent,
        child: Tooltip(
          message: tooltipText,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(7.0)),
            onTap: onButtonTapped,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 7, right: 7),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      letterSpacing: 0.27,
                      color: textColor ?? Colors.black,
                    ),
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: icon,
                        ),
                      ),
                      TextSpan(text: buttonLabel),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getButtonTextSpan(String? buttonLabel, Icon icon, ButtonIconPositionType iconPositionType) {
    Widget widget = RichText(
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: 0.27,
          color: Colors.black,
        ),
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: icon,
            ),
          ),
          TextSpan(text: buttonLabel),
        ],
      ),
    );

    if (iconPositionType == ButtonIconPositionType.right) {
      widget = RichText(
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 0.27,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: buttonLabel),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: icon,
              ),
            ),
          ],
        ),
      );
    }

    return widget;
  }

  static showMessageAlert(
    BuildContext context,
    String? alertTitle,
    String? alertMessage, {
    MessageType messageType = MessageType.none,
    Function()? onApplyTapped,
    Color textColor = const Color(0xffffffff),
    Color buttonIconColor = Colors.indigo,
  }) {
    if (messageType == MessageType.success) {
      textColor = Colors.green;
    } else if (messageType == MessageType.info) {
      textColor = Colors.indigo;
    } else if (messageType == MessageType.warning) {
      textColor = Colors.yellow;
    } else if (messageType == MessageType.error) {
      textColor = Colors.red;
    }

    double dialongViewScale = 0.8;

    if (!DynamoCommons.isMobile(context)) {
      dialongViewScale = 0.40;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: SizedBox(
              width: MediaQuery.of(context).size.width * dialongViewScale,
              child: Text(
                alertTitle!,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * dialongViewScale,
              child: Text(
                alertMessage!,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0, color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: messageType == MessageType.yesNo ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                  children: <Widget>[
                    if (messageType == MessageType.yesNo)
                      getFineRoundedButton(
                        "Yes",
                        () {
                          if (onApplyTapped != null) {
                            onApplyTapped();
                          }

                          Navigator.of(context).pop();
                        },
                        Icon(
                          Icons.close,
                          color: buttonIconColor,
                        ),
                        tooltipText: "Yes, Proceed With Action",
                      ),
                    getFineRoundedButton(
                      messageType == MessageType.yesNo ? "No" : "Close",
                      () {
                        if (messageType != MessageType.yesNo) {
                          if (onApplyTapped != null) {
                            onApplyTapped();
                          }
                        }

                        Navigator.of(context).pop();
                      },
                      Icon(
                        Icons.close,
                        color: buttonIconColor,
                      ),
                      tooltipText: messageType == MessageType.yesNo ? "No, Do Not Proceed With This Action." : "Close Dialog",
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  static showConfirmationMessage(
    BuildContext context,
    String? alertTitle,
    String? alertMessage, {
    MessageType messageType = MessageType.none,
    Function()? onApplyTapped,
    Color buttonIconColor = Colors.indigo,
  }) {
    Color textColor = Colors.black;

    if (messageType == MessageType.success) {
      textColor = Colors.green;
    } else if (messageType == MessageType.info) {
      textColor = Colors.indigo;
    } else if (messageType == MessageType.warning) {
      textColor = Colors.yellow;
    } else if (messageType == MessageType.error) {
      textColor = Colors.red;
    }

    double dialongViewScale = 0.8;

    if (!DynamoCommons.isMobile(context)) {
      dialongViewScale = 0.40;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: SizedBox(
              width: MediaQuery.of(context).size.width * dialongViewScale,
              child: Text(
                alertTitle!,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * dialongViewScale,
              child: Text(
                alertMessage!,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  color: textColor,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getFineRoundedButton(
                      "Yes",
                      () {
                        if (onApplyTapped != null) {
                          onApplyTapped();
                        }
                        Navigator.of(context).pop();
                      },
                      Icon(
                        Icons.check,
                        color: buttonIconColor,
                      ),
                    ),
                    getFineRoundedButton(
                      "No",
                      () {
                        Navigator.of(context).pop();
                      },
                      Icon(
                        Icons.close,
                        color: buttonIconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

}
