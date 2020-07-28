import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Widget for building an adaptive FlatButton based on the
/// Platform that is currently running on.
///
/// For web and Android, return a Material Design FlatButton.
/// For iOS, return the CupertinoButton.
/// Both styles of button display [text] as the button text, and
/// call [onPressedHandler] when pressed by user.
class AdaptiveFlatButton extends StatelessWidget {
  /// The text to display in the button.
  final String text;

  /// The function to call when the button is pressed.
  final Function onPressedHandler;

  AdaptiveFlatButton(this.text, this.onPressedHandler);

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressedHandler,
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressedHandler,
          );
  }
}
