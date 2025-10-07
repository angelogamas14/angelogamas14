class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String photoUrl;
  final DateTime birthDate;
  final String hospitalHistory; // free text
  final List<String> allergies; // e.g., seafoods, eggs, nuts, others
  final bool isAdmin;

  const UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.photoUrl,
    required this.birthDate,
    required this.hospitalHistory,
    required this.allergies,
    this.isAdmin = false,
  });

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? photoUrl,
    DateTime? birthDate,
    String? hospitalHistory,
    List<String>? allergies,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id,
      username: username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      birthDate: birthDate ?? this.birthDate,
      hospitalHistory: hospitalHistory ?? this.hospitalHistory,
      allergies: allergies ?? this.allergies,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'address': address,
        'photoUrl': photoUrl,
        'birthDate': birthDate.toIso8601String(),
        'hospitalHistory': hospitalHistory,
        'allergies': allergies,
        'isAdmin': isAdmin,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        username: json['username'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        address: json['address'] as String,
        photoUrl: json['photoUrl'] as String,
        birthDate: DateTime.parse(json['birthDate'] as String),
        hospitalHistory: json['hospitalHistory'] as String,
        allergies: (json['allergies'] as List<dynamic>).cast<String>(),
        isAdmin: json['isAdmin'] as bool? ?? false,
      );
}
