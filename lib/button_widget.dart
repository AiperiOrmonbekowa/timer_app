import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onCliced;
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onCliced,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      onPressed: onCliced,
    );
  }
}
