import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:my_app/app_constants.dart';

class HistoryUserEquipmentCard extends StatelessWidget {
  final String name, startDate, employeeImageThumb;
  final String? endDate;
  const HistoryUserEquipmentCard(
      {Key? key,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.employeeImageThumb})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: endDate == null ? 7.0 : 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: endDate == null ? const Color(0xFF6CCFF7) : null,
        child: Row(children: [
          const SizedBox(width: 20.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CachedNetworkImage(
              width: 50,
              imageUrl: employeeImageThumb,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.network(defaultImageThumb),
            ),
          ),
          const SizedBox(width: 40.0),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(name,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'mont',
                    )),
                AutoSizeText(
                  endDate != null
                      ? '$startDate - $endDate'
                      : '$startDate - Active',
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'mont',
                  ),
                ),
              ]),
        ]),
      ),
    );
  }
}
