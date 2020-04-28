import 'package:flutter/material.dart';
import 'package:getreferred/ReferralStatusItem.dart';

class RequestMoreInfo extends StatefulWidget {
  @override
  _RequestMoreInfoState createState() => _RequestMoreInfoState();
}

class _RequestMoreInfoState extends State<RequestMoreInfo>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          child: Hero(
            child: FittedBox(
              fit: BoxFit.contain,
              child: ReferralStatusItem(
                messageBox: true,
                spcial: true,
              ),
            ),
            tag: "wid",
          ),
        ),
      ),
    );
  }
}
