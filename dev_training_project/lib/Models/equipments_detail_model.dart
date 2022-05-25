import 'equipments_user_model.dart';

class Equipments {
  String? id;
  String? model;
  String? serial;
  String? processor;
  String? processorId;
  String? memory;
  String? memoryId;
  String? storage;
  String? storageType;
  String? storageSize;
  String? purchaseDate;
  String? warranty;
  String? status;
  String? company;
  String? note;
  String? cost;
  String? billingNumber;

  Equipments(
      {this.id,
      this.model,
      this.serial,
      this.processor,
      this.processorId,
      this.memory,
      this.memoryId,
      this.storage,
      this.storageType,
      this.storageSize,
      this.purchaseDate,
      this.warranty,
      this.status,
      this.company,
      this.note,
      this.cost,
      this.billingNumber});
}

class EquipmentHistory {
  late Equipments equipmentInfo;
  late List<EquipmentsUserModel>? users;

  EquipmentHistory({required this.equipmentInfo, this.users});
}
