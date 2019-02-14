import 'package:flutter/material.dart';

class ShowFadeText extends StatefulWidget {
  final Widget child;
  final int delay;

  ShowFadeText({Key key, @required this.child, this.delay}) : super(key: key);

  @override
  _ShowFadeTextState createState() => _ShowFadeTextState();
}

class _ShowFadeTextState extends State<ShowFadeText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _fadeOffset;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _controller);

    _fadeOffset = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
        .animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _fadeOffset,
        child: widget.child,
      ),
    );
  }
}
