class ReportUserModel {
  final String? id;
  final String name;
  final String monthlyWage;
  final String imageThumb;
  double costAtSprint;

  ReportUserModel(
      {this.id,
      required this.name,
      required this.monthlyWage,
      required this.imageThumb,
      required this.costAtSprint});
}
