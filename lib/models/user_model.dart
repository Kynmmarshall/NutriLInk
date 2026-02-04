enum UserRole {
  provider,
  beneficiary,
  deliveryAgent,
  admin,
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? address;
  final UserRole role;
  final String? profileImage;
  final DateTime createdAt;
  final bool isActive;
  final double? latitude;
  final double? longitude;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.address,
    required this.role,
    this.profileImage,
    required this.createdAt,
    this.isActive = true,
    this.latitude,
    this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'],
      role: _parseRole(json['role']),
      profileImage: json['profileImage'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'role': role.name,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static UserRole _parseRole(dynamic role) {
    if (role is String) {
      switch (role.toLowerCase()) {
        case 'provider':
          return UserRole.provider;
        case 'beneficiary':
          return UserRole.beneficiary;
        case 'deliveryagent':
        case 'delivery_agent':
          return UserRole.deliveryAgent;
        case 'admin':
          return UserRole.admin;
        default:
          return UserRole.beneficiary;
      }
    }
    return UserRole.beneficiary;
  }

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    UserRole? role,
    String? profileImage,
    DateTime? createdAt,
    bool? isActive,
    double? latitude,
    double? longitude,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
