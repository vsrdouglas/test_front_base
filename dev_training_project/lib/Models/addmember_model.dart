class MemberModel {
  String id;
  String name;
  double? allocation;
  String imageTumb;

  MemberModel(this.id, this.name, this.allocation, this.imageTumb);
}

class MemberCreation {
  String? teamRole;
  double? allocation;
  String startDate;
  String? imageTumb;

  MemberCreation(
      this.teamRole, this.allocation, this.startDate, this.imageTumb);
  Map toJson() => {
        'teamRole': teamRole,
        'allocation': allocation,
        'startDate': startDate,
        'imageTumb': imageTumb
      };
}
