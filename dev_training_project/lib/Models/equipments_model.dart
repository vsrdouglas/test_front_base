import 'equipments_user_model.dart';

class EquipmentsModel {
  final EquipmentsUserModel? equipmentsUserModel;
  final String? equipmentStatus;
  final String? id;
  final String? memory;
  final String? model;
  final String? processor;
  final String? serial;
  final String? storage;

  EquipmentsModel(
      {this.id,
      this.model,
      this.serial,
      this.equipmentStatus,
      this.equipmentsUserModel,
      this.memory,
      this.storage,
      this.processor});
}
