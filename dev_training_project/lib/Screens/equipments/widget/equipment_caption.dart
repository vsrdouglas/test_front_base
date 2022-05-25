import 'package:flutter/material.dart';

class EquipmentCaption extends StatelessWidget {
  final String greenCaption;
  final String yellowCaption;
  final String redCaption;

  const EquipmentCaption({
    required this.greenCaption,
    required this.yellowCaption,
    required this.redCaption,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        // runSpacing: 7.0,
        // alignment: WrapAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 16.0,
                width: 16.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 15.0),
              Text(
                greenCaption,
                style: const TextStyle(
                  fontFamily: 'mont',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          const SizedBox(width: 19.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 16.0,
                width: 16.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow,
                ),
              ),
              const SizedBox(width: 15.0),
              Text(
                yellowCaption,
                style: const TextStyle(
                  fontFamily: 'mont',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          const SizedBox(width: 19.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 16.0,
                width: 16.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 15.0),
              Text(
                redCaption,
                style: const TextStyle(
                  fontFamily: 'mont',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
