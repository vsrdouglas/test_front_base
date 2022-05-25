// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ForecastSprints extends StatefulWidget {
  final String startDate;
  final int sprintLength;
  final String projectId;
  final int numberSprintsClosed;
  const ForecastSprints(this.startDate, this.sprintLength, this.projectId,
      this.numberSprintsClosed,
      {Key? key})
      : super(key: key);

  @override
  ForecastSprintsState createState() => ForecastSprintsState();
}

class ForecastSprintsState extends State<ForecastSprints> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _numberSprintController = TextEditingController();
  DateTime? endDate;
  late int futureSprints;

  @override
  void dispose() {
    _numberSprintController.dispose();
    super.dispose();
  }

  void sumSprints(int numberSprints) {
    DateTime startDate = DateTime.parse(widget.startDate);
    int weeks = (widget.sprintLength / 5).floor() *
        7 *
        (numberSprints + widget.numberSprintsClosed);
    endDate = DateTime(startDate.year, startDate.month, startDate.day + weeks);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150.0),
        child: const Text(
          'Select the Number of Sprints',
          maxLines: 2,
          style: TextStyle(
            fontFamily: 'montBold',
            fontSize: 22,
          ),
        ),
      ),
      content: Column(
        children: [
          Form(
            key: _form,
            child: Column(children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  key: const Key('sprints-quant'),
                  controller: _numberSprintController,
                  style: const TextStyle(fontFamily: "mont", fontSize: 14),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF6CCFF7), width: 2),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Number of (future) Sprints: ',
                    labelStyle: TextStyle(
                        color: Colors.grey, fontFamily: "mont", fontSize: 14),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number!';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        futureSprints = int.parse(value);
                        sumSprints(int.parse(value));
                      });
                    } else {
                      setState(() {
                        _numberSprintController.text = '';
                        endDate = null;
                      });
                    }
                  },
                ),
              ),
            ]),
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              const Flexible(
                child: Text(
                  'Project Start Date:',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                widget.startDate == '' ? '-' : widget.startDate,
                maxLines: 2,
                style: const TextStyle(
                  fontFamily: 'mont',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Flexible(
                child: Text(
                  'Forecast End Date:',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                endDate != null
                    ? DateFormat("yyyy-MM-dd").format(endDate!)
                    : '-',
                maxLines: 2,
                style: const TextStyle(
                  fontFamily: 'mont',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'mont',
              color: Color(0xFF213e4b),
              fontSize: 15,
            ),
          ),
        ),
        TextButton(
          onPressed: _numberSprintController.text == ''
              ? null
              : () async {
                  Navigator.of(context).pop(futureSprints);
                },
          child: Container(
            color: _numberSprintController.text == ''
                ? const Color(0x50CCCCCC)
                : const Color(0xFF6CCFF7),
            padding: const EdgeInsets.all(6),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontFamily: 'montBold',
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
