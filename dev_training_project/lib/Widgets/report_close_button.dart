import 'package:flutter/material.dart';

class CloseButtonWhite extends StatelessWidget {
  const CloseButtonWhite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(500),
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 20),
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
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}
