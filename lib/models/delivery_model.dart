enum DeliveryStatus {
  pending,
  accepted,
  pickupInProgress,
  pickedUp,
  deliveryInProgress,
  delivered,
  cancelled,
}

class Delivery {
  final String id;
  final String requestId;
  final String listingId;
  final String providerId;
  final String providerName;
  final String beneficiaryId;
  final String beneficiaryName;
  final String? deliveryAgentId;
  final String? deliveryAgentName;
  final String foodTitle;
  final int servings;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String dropoffAddress;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final DeliveryStatus status;
  final DateTime? pickupTime;
  final DateTime? deliveryTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final String? deliveryProof;
  final double? distance;

  Delivery({
    required this.id,
    required this.requestId,
    required this.listingId,
    required this.providerId,
    required this.providerName,
    required this.beneficiaryId,
    required this.beneficiaryName,
    this.deliveryAgentId,
    this.deliveryAgentName,
    required this.foodTitle,
    required this.servings,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    this.status = DeliveryStatus.pending,
    this.pickupTime,
    this.deliveryTime,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.deliveryProof,
    this.distance,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['_id'] ?? json['id'] ?? '',
      requestId: json['requestId'] ?? '',
      listingId: json['listingId'] ?? '',
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'] ?? 'Unknown',
      beneficiaryId: json['beneficiaryId'] ?? '',
      beneficiaryName: json['beneficiaryName'] ?? 'Unknown',
      deliveryAgentId: json['deliveryAgentId'],
      deliveryAgentName: json['deliveryAgentName'],
      foodTitle: json['foodTitle'] ?? '',
      servings: json['servings'] ?? 0,
      pickupAddress: json['pickupAddress'] ?? '',
      pickupLatitude: (json['pickupLatitude'] ?? 0.0).toDouble(),
      pickupLongitude: (json['pickupLongitude'] ?? 0.0).toDouble(),
      dropoffAddress: json['dropoffAddress'] ?? '',
      dropoffLatitude: (json['dropoffLatitude'] ?? 0.0).toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] ?? 0.0).toDouble(),
      status: _parseStatus(json['status']),
      pickupTime: json['pickupTime'] != null
          ? DateTime.parse(json['pickupTime'])
          : null,
      deliveryTime: json['deliveryTime'] != null
          ? DateTime.parse(json['deliveryTime'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      notes: json['notes'],
      deliveryProof: json['deliveryProof'],
      distance: json['distance']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'listingId': listingId,
      'providerId': providerId,
      'providerName': providerName,
      'beneficiaryId': beneficiaryId,
      'beneficiaryName': beneficiaryName,
      'deliveryAgentId': deliveryAgentId,
      'deliveryAgentName': deliveryAgentName,
      'foodTitle': foodTitle,
      'servings': servings,
      'pickupAddress': pickupAddress,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'dropoffAddress': dropoffAddress,
      'dropoffLatitude': dropoffLatitude,
      'dropoffLongitude': dropoffLongitude,
      'status': status.name,
      'pickupTime': pickupTime?.toIso8601String(),
      'deliveryTime': deliveryTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
      'deliveryProof': deliveryProof,
      'distance': distance,
    };
  }

  static DeliveryStatus _parseStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return DeliveryStatus.pending;
        case 'accepted':
          return DeliveryStatus.accepted;
        case 'pickupinprogress':
        case 'pickup_in_progress':
          return DeliveryStatus.pickupInProgress;
        case 'pickedup':
        case 'picked_up':
          return DeliveryStatus.pickedUp;
        case 'deliveryinprogress':
        case 'delivery_in_progress':
          return DeliveryStatus.deliveryInProgress;
        case 'delivered':
          return DeliveryStatus.delivered;
        case 'cancelled':
          return DeliveryStatus.cancelled;
        default:
          return DeliveryStatus.pending;
      }
    }
    return DeliveryStatus.pending;
  }

  Delivery copyWith({
    String? id,
    String? requestId,
    String? listingId,
    String? providerId,
    String? providerName,
    String? beneficiaryId,
    String? beneficiaryName,
    String? deliveryAgentId,
    String? deliveryAgentName,
    String? foodTitle,
    int? servings,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? dropoffAddress,
    double? dropoffLatitude,
    double? dropoffLongitude,
    DeliveryStatus? status,
    DateTime? pickupTime,
    DateTime? deliveryTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    String? deliveryProof,
    double? distance,
  }) {
    return Delivery(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      listingId: listingId ?? this.listingId,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      deliveryAgentId: deliveryAgentId ?? this.deliveryAgentId,
      deliveryAgentName: deliveryAgentName ?? this.deliveryAgentName,
      foodTitle: foodTitle ?? this.foodTitle,
      servings: servings ?? this.servings,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      dropoffLatitude: dropoffLatitude ?? this.dropoffLatitude,
      dropoffLongitude: dropoffLongitude ?? this.dropoffLongitude,
      status: status ?? this.status,
      pickupTime: pickupTime ?? this.pickupTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      deliveryProof: deliveryProof ?? this.deliveryProof,
      distance: distance ?? this.distance,
    );
  }
}
