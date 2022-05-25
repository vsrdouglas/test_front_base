class EquipmentsUserModel {
  final String name;
  final String? userId;
  final String? equipmentId;
  final String? endDate;
  final String? startDate;
  final String? imageThumb;
  final String? idAssign;

  EquipmentsUserModel({
    required this.name,
    this.endDate,
    this.startDate,
    this.imageThumb,
    this.equipmentId,
    this.userId,
    this.idAssign,
  });
}
