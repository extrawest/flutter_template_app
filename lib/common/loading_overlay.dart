import 'package:flutter/material.dart';

/// Widget showing overlay loading animation.
class LoadingOverlay extends StatefulWidget {
  final Color backgroundColor;

  const LoadingOverlay({Key? key, this.backgroundColor = Colors.black12}) : super(key: key);

  @override
  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: opacity,
      child: Container(
        color: widget.backgroundColor,
        alignment: Alignment.center,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
