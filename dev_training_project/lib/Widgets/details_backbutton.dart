import 'package:flutter/material.dart';

class BackButtonWhite extends StatelessWidget {
  const BackButtonWhite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('back-button'),
      borderRadius: BorderRadius.circular(500),
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        height: double.infinity,
        width: double.infinity,
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(2, 2),
              )
            ],
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}
