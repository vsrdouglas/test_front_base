// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:my_app/Models/parameters_model.dart';

class EquipmentFilterWidget extends StatefulWidget {
  final String name;
  final List<ParametersModel> listOfOptions;
  final List filteredOptions;
  final List selectedNames;

  const EquipmentFilterWidget(
      {required this.name,
      required this.filteredOptions,
      required this.listOfOptions,
      required this.selectedNames});

  @override
  State<EquipmentFilterWidget> createState() => _EquipmentFilterWidgetState();
}

class _EquipmentFilterWidgetState extends State<EquipmentFilterWidget> {
  @override
  Widget build(BuildContext context) {
    final List<FilterOptionWidget> listOfButtons = [];
    // ignore: avoid_function_literals_in_foreach_calls
    widget.listOfOptions.forEach(
      (parameters) => listOfButtons.add(FilterOptionWidget(
        name: parameters.value,
        isLast: widget.listOfOptions.indexOf(parameters) + 1 ==
            widget.listOfOptions.length,
        onTap: () => setState(() {
          filterHelper(parameters.id, parameters.value, widget.filteredOptions,
              widget.selectedNames);
        }),
        isSelected: widget.filteredOptions.contains(parameters.id),
      )),
    );

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: const Color(0xFF6CCFF7),
        width: 1,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF6CCFF7),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(widget.name,
                  style: const TextStyle(
                      fontFamily: "mont", fontSize: 18, color: Colors.white)),
            ),
          ),
          Wrap(
            children: [...listOfButtons],
          ),
        ],
      ),
    );
  }
}

class FilterOptionWidget extends StatelessWidget {
  final Function() onTap;
  final String name;
  final bool isLast;
  final bool isSelected;

  const FilterOptionWidget(
      {required this.onTap,
      required this.name,
      required this.isLast,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:
            EdgeInsets.only(left: 5, top: 5, bottom: 5, right: isLast ? 5 : 0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xFF6CCFF7),
          ),
          color: isSelected ? const Color(0xFF6CCFF7) : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: TextStyle(
              fontFamily: 'mont',
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

void filterHelper(
    String option, String name, List filteredOptions, List selectedNames) {
  if (filteredOptions.contains(option)) {
    filteredOptions.remove(option);
  } else {
    filteredOptions.add(option);
  }
  if (selectedNames.contains(name)) {
    selectedNames.remove(name);
  } else {
    selectedNames.add(name);
  }
}
