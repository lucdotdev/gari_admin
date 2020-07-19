import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String cardName;
  final String subName;
  final Widget icon;
  final Color iconColor;
  final Widget data;

  const StatsCard(
      {Key key,
      this.cardName,
      @required this.subName,
      @required this.icon,
      @required this.iconColor,
      @required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double heigth = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.2,
      height: heigth * 0.15,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                blurRadius: 20,
                spreadRadius: 3,
                offset: Offset(0, 3))
          ]),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(width * 0.04)),
            child: Container(
              width: width * 0.04,
              height: width * 0.04,
              color: iconColor,
              child: Center(child: icon),
            )),
        SizedBox(
          width: width * 0.01,
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [data, Text(subName)])
      ]),
    );
  }
}
