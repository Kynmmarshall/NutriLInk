enum FoodCategory {
  vegetables,
  fruits,
  grains,
  dairy,
  meat,
  prepared,
  other,
}

enum FoodType {
  fresh,
  cooked,
  packaged,
}

enum FoodStatus {
  available,
  reserved,
  expired,
  completed,
}

class FoodListing {
  final String id;
  final String providerId;
  final String providerName;
  final String title;
  final String description;
  final FoodCategory category;
  final FoodType foodType;
  final int servings;
  final String? quantity;
  final DateTime expiryTime;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final FoodStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FoodListing({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.title,
    required this.description,
    required this.category,
    required this.foodType,
    required this.servings,
    this.quantity,
    required this.expiryTime,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.images = const [],
    this.status = FoodStatus.available,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodListing.fromJson(Map<String, dynamic> json) {
    return FoodListing(
      id: json['_id'] ?? json['id'] ?? '',
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'] ?? 'Unknown Provider',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: _parseCategory(json['category']),
      foodType: _parseFoodType(json['foodType']),
      servings: json['servings'] ?? 0,
      quantity: json['quantity'],
      expiryTime: json['expiryTime'] != null
          ? DateTime.parse(json['expiryTime'])
          : DateTime.now(),
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
      status: _parseStatus(json['status']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'providerName': providerName,
      'title': title,
      'description': description,
      'category': category.name,
      'foodType': foodType.name,
      'servings': servings,
      'quantity': quantity,
      'expiryTime': expiryTime.toIso8601String(),
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static FoodCategory _parseCategory(dynamic category) {
    if (category is String) {
      switch (category.toLowerCase()) {
        case 'vegetables':
          return FoodCategory.vegetables;
        case 'fruits':
          return FoodCategory.fruits;
        case 'grains':
          return FoodCategory.grains;
        case 'dairy':
          return FoodCategory.dairy;
        case 'meat':
          return FoodCategory.meat;
        case 'prepared':
          return FoodCategory.prepared;
        default:
          return FoodCategory.other;
      }
    }
    return FoodCategory.other;
  }

  static FoodType _parseFoodType(dynamic type) {
    if (type is String) {
      switch (type.toLowerCase()) {
        case 'fresh':
          return FoodType.fresh;
        case 'cooked':
          return FoodType.cooked;
        case 'packaged':
          return FoodType.packaged;
        default:
          return FoodType.fresh;
      }
    }
    return FoodType.fresh;
  }

  static FoodStatus _parseStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'available':
          return FoodStatus.available;
        case 'reserved':
          return FoodStatus.reserved;
        case 'expired':
          return FoodStatus.expired;
        case 'completed':
          return FoodStatus.completed;
        default:
          return FoodStatus.available;
      }
    }
    return FoodStatus.available;
  }

  bool get isExpired => DateTime.now().isAfter(expiryTime);

  Duration get timeUntilExpiry => expiryTime.difference(DateTime.now());

  FoodListing copyWith({
    String? id,
    String? providerId,
    String? providerName,
    String? title,
    String? description,
    FoodCategory? category,
    FoodType? foodType,
    int? servings,
    String? quantity,
    DateTime? expiryTime,
    String? address,
    double? latitude,
    double? longitude,
    List<String>? images,
    FoodStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FoodListing(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      foodType: foodType ?? this.foodType,
      servings: servings ?? this.servings,
      quantity: quantity ?? this.quantity,
      expiryTime: expiryTime ?? this.expiryTime,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
