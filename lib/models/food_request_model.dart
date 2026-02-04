enum RequestStatus {
  pending,
  approved,
  rejected,
  inProgress,
  completed,
  cancelled,
}

class FoodRequest {
  final String id;
  final String listingId;
  final String beneficiaryId;
  final String beneficiaryName;
  final String providerId;
  final String providerName;
  final String foodTitle;
  final int requestedServings;
  final RequestStatus status;
  final String? notes;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deliveryAgentId;
  final String? deliveryAgentName;

  FoodRequest({
    required this.id,
    required this.listingId,
    required this.beneficiaryId,
    required this.beneficiaryName,
    required this.providerId,
    required this.providerName,
    required this.foodTitle,
    required this.requestedServings,
    this.status = RequestStatus.pending,
    this.notes,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryAgentId,
    this.deliveryAgentName,
  });

  factory FoodRequest.fromJson(Map<String, dynamic> json) {
    return FoodRequest(
      id: json['_id'] ?? json['id'] ?? '',
      listingId: json['listingId'] ?? '',
      beneficiaryId: json['beneficiaryId'] ?? '',
      beneficiaryName: json['beneficiaryName'] ?? 'Unknown',
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'] ?? 'Unknown',
      foodTitle: json['foodTitle'] ?? '',
      requestedServings: json['requestedServings'] ?? 0,
      status: _parseStatus(json['status']),
      notes: json['notes'],
      rejectionReason: json['rejectionReason'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deliveryAgentId: json['deliveryAgentId'],
      deliveryAgentName: json['deliveryAgentName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'beneficiaryId': beneficiaryId,
      'beneficiaryName': beneficiaryName,
      'providerId': providerId,
      'providerName': providerName,
      'foodTitle': foodTitle,
      'requestedServings': requestedServings,
      'status': status.name,
      'notes': notes,
      'rejectionReason': rejectionReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deliveryAgentId': deliveryAgentId,
      'deliveryAgentName': deliveryAgentName,
    };
  }

  static RequestStatus _parseStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return RequestStatus.pending;
        case 'approved':
          return RequestStatus.approved;
        case 'rejected':
          return RequestStatus.rejected;
        case 'inprogress':
        case 'in_progress':
          return RequestStatus.inProgress;
        case 'completed':
          return RequestStatus.completed;
        case 'cancelled':
          return RequestStatus.cancelled;
        default:
          return RequestStatus.pending;
      }
    }
    return RequestStatus.pending;
  }

  FoodRequest copyWith({
    String? id,
    String? listingId,
    String? beneficiaryId,
    String? beneficiaryName,
    String? providerId,
    String? providerName,
    String? foodTitle,
    int? requestedServings,
    RequestStatus? status,
    String? notes,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deliveryAgentId,
    String? deliveryAgentName,
  }) {
    return FoodRequest(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      foodTitle: foodTitle ?? this.foodTitle,
      requestedServings: requestedServings ?? this.requestedServings,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryAgentId: deliveryAgentId ?? this.deliveryAgentId,
      deliveryAgentName: deliveryAgentName ?? this.deliveryAgentName,
    );
  }
}
