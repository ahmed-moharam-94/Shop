import 'package:flutter/material.dart';

class CheckWidget extends StatelessWidget {
  final Widget widget;

  CheckWidget(this.widget);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes, exit'),
                  )
                ],
              );
            });
        return value == true;
      },
      child: widget,
    );
  }
}
