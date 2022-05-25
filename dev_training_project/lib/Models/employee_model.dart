class EmployeeModel {
  String id;
  String name;
  String email;
  String wage;
  String imageUri;
  String imageTumb;
  String tecnologies;
  double allocation;

  EmployeeModel(this.id, this.name, this.email, this.wage, this.imageUri,
      this.imageTumb, this.tecnologies, this.allocation);
}

class EmployeeCreation {
  String? name;
  String? email;
  String? wage;
  String? imageUri;
  String? imageTumb;
  String? tecnologies;
  double? allocation;
  String? accessLevel;
  bool? hasAccess;

  EmployeeCreation(
      this.name,
      this.email,
      this.wage,
      this.imageUri,
      this.imageTumb,
      this.tecnologies,
      this.allocation,
      this.accessLevel,
      this.hasAccess);

  Map toJson() => {
        'name': name,
        'email': email,
        'monthlyWage': wage,
        'imageUri': imageUri,
        'imageTumb': imageTumb,
        'tecnologies': tecnologies,
        'allocation': allocation,
        'accessLevel': accessLevel,
        'hasAccess': hasAccess,
      };
}
