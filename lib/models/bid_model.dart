class BidModel {
  final String id;
  final String artworksId;
  final int amount;
  final String bidById;
  final String bidderName;
  final String status;
  final DateTime timestamp;

  BidModel({
    required this.id,
    required this.artworksId,
    required this.amount,
    required this.bidById,
    this.bidderName = '',
    this.status = 'OPEN',
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] ?? '',
      artworksId: json['artworksId'] ?? '',
      amount: json['amount'] is int
          ? json['amount']
          : int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      bidById: json['bidById'] ?? '',
      bidderName: json['bidBy'] != null && json['bidBy'] is Map 
          ? (json['bidBy']['username'] ?? json['bidBy']['full_name'] ?? json['bidderName'] ?? json['bidById'] ?? '')
          : (json['bidderName'] ?? json['bidById'] ?? ''),
      status: json['status'] ?? 'OPEN',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artworksId': artworksId,
      'amount': amount,
      'bidById': bidById,
      'bidderName': bidderName,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
