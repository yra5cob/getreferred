import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String errorText;
  final List<Widget> actions;

  CustomDialog({this.errorText, this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            height: 150,
            width: 400,
            child: Column(
              children: <Widget>[
                Spacer(),
                Text(
                  errorText,
                  style: TextStyle(),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: actions,
                  ),
                )
              ],
            ),
          ),
          Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.blueGrey[100]),
                  child: Icon(Icons.close),
                ),
              ))
        ],
      ),
    );
  }
}
