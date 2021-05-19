import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BusyButton extends StatefulWidget {
  bool busy;
  final String title;
  final void Function()? onPressed;
  final bool enabled;
  final double? height;
  final double? width;
  final Color? color;
  final BoxDecoration? decoration;
  BusyButton({
    Key? key,
    this.busy = false,
    required this.title,
    this.onPressed,
    this.enabled = true,
    this.width,
    this.height,
    this.color,
    this.decoration,
  }) : super(key: key);

  @override
  _BusyButtonState createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  @override
  Widget build(BuildContext context) {
    return !widget.busy
        ? Container(
            height: widget.height,
            width: widget.width,
            decoration: widget.decoration,
            child: MaterialButton(
              onPressed: widget.onPressed,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 19,
                  color: widget.color,
                ),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
