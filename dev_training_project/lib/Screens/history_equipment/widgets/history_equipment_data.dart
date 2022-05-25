import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Models/equipments_detail_model.dart';

class HistoryEquipmentData extends StatelessWidget {
  final EquipmentHistory equipamentHistory;
  const HistoryEquipmentData({Key? key, required this.equipamentHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Serial Number',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.serial ?? '-',
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Billing Number',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.billingNumber ?? '-',
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Cost',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.cost != null
              ? 'R\$${equipamentHistory.equipmentInfo.cost}'
              : '-',
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Warranty',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.warranty ?? '-',
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Processor',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.processor ?? '-',
          maxLines: 3,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Memory',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.memory ?? '-',
          maxLines: 3,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Storage',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.storage ?? '-',
          maxLines: 3,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Purchase Date',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.purchaseDate ?? '-',
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Equipment Status',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.status ?? '-',
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Company',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.company ?? '-',
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Note',
          style: TextStyle(
            fontFamily: 'mont',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          equipamentHistory.equipmentInfo.note ?? '-',
          maxLines: 3,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'mont',
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class HistoryEquipmentDataApp extends StatelessWidget {
  final EquipmentHistory equipamentHistory;
  const HistoryEquipmentDataApp({Key? key, required this.equipamentHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Serial Number',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.serial?.toUpperCase() ?? '-',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Billing Number',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.billingNumber ?? '-',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Cost',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.cost != null
                  ? 'R\$${equipamentHistory.equipmentInfo.cost}'
                  : '-',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Warranty',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.warranty ?? '-',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Processor',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.processor ?? '-',
              maxLines: 3,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Memory',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.memory ?? '-',
              maxLines: 3,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Storage',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.storage ?? '-',
              maxLines: 3,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Purchase Date',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.purchaseDate ?? '-',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Equipment Status',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.status ?? '-',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Company',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.company ?? '-',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Note',
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              equipamentHistory.equipmentInfo.note ?? '-',
              maxLines: 3,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mont',
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
