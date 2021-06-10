class UserModel {
  String? email;
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? dateOfBirth;
  String? placeOfBirth;

  UserModel(
      {this.email,
      this.firstName,
      this.middleName,
      this.lastName,
      this.dateOfBirth,
      this.placeOfBirth});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    middleName = json['middle_name'] ?? '';
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'] != null ? DateTime.tryParse(json['date_of_birth']) : null;
    placeOfBirth = json['place_of_birth'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['date_of_birth'] = dateOfBirth;
    data['place_of_birth'] = placeOfBirth;
    return data;
  }
}
