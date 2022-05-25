import 'package:flutter/material.dart';

Color checkPercent(porcentagem) {
  if (porcentagem > 0.5) {
    return Colors.red;
  } else if (porcentagem <= 0.5 && porcentagem > 0.25) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}

double checkAvailability(dynamic userInfo) {
  double sumAllocationUserDetail = 0.0;
  for (var i = 0; i < userInfo['projects'].length; i++) {
    for (var j = 0;
        j < userInfo['projects'][i]['projectHasUsers'].length;
        j++) {
      sumAllocationUserDetail += double.parse(
          userInfo['projects'][i]['projectHasUsers'][j]['allocation']);
    }
  }
  return (sumAllocationUserDetail);
}

double checkAllocation(dynamic projectInfo) {
  double totalAllocationProject = 0;
  for (var i = 0; i < projectInfo['projectHasUsers'].length; i++) {
    totalAllocationProject = totalAllocationProject +
        double.parse(projectInfo['projectHasUsers'][i]['allocation']);
  }
  return totalAllocationProject;
}

nameSpliter(String fullName) {
  List split = fullName.split(' ');
  if (split.length > 1) {
    return ('${split[0]} ${split.last}');
  } else {
    return ('${split[0]}');
  }
}

Widget statusColor(String status) {
  Color color;
  switch (status) {
    case "Working":
    case "Complete":
      color = Colors.green;
      break;
    case "Defective":
    case "Out of service":
      color = Colors.red;
      break;
    default:
      color = Colors.yellow;
      break;
  }

  return Container(
    height: 18,
    width: 18,
    margin: const EdgeInsets.only(left: 15, right: 10, top: 8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
  );
}

userComputer(String? name) {
  if (name == null) {
    return const Text('Available',
        style: TextStyle(
            fontFamily: 'montBold', fontSize: 15, color: Colors.black54));
  } else {
    return Text(name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontFamily: 'mont', fontSize: 15, color: Colors.black54));
  }
}
