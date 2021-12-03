import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toot/constants.dart';

class SingleChoiceDelivery extends StatefulWidget {
  final Widget title;
  final int index;
  final Function selectionFunction;
  final Function function;
  final List<bool> choicesList;

  SingleChoiceDelivery(
      {required this.title,
      required this.index,
      required this.selectionFunction,
      required this.choicesList,
      required this.function});

  @override
  _SingleChoiceDeliveryState createState() => _SingleChoiceDeliveryState();
}

class _SingleChoiceDeliveryState extends State<SingleChoiceDelivery> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
          widget.function();
          widget.selectionFunction(widget.choicesList, selected, widget.index);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 0.08.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.title,
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: widget.choicesList[widget.index] == true
                    ? Icon(
                        FontAwesomeIcons.solidCheckCircle,
                        size: 20.0,
                        color: Color(Constants.mainColor),
                      )
                    : Icon(
                        FontAwesomeIcons.solidCircle,
                        size: 20.0,
                        color: Colors.grey.shade100,
                      ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
