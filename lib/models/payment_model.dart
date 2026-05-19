/// PaymentModel — matched to Prisma Payment schema
class PaymentModel {
  final String id;
  final int amount;
  final double fee;
  final String bidId;
  final String paidById;
  final DateTime timestamp;
  final String artworkTitle;
  final String artworkImageUrl;
  final String paymentMethod;

  PaymentModel({
    required this.id,
    required this.amount,
    this.fee = 0.035,
    required this.bidId,
    this.paidById = '',
    DateTime? timestamp,
    this.artworkTitle = '',
    this.artworkImageUrl = '',
    this.paymentMethod = 'Bank Transfer',
  }) : timestamp = timestamp ?? DateTime.now();

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      amount: json['amount'] is int
          ? json['amount']
          : int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      fee: (json['fee'] ?? 0.035).toDouble(),
      bidId: json['bidId'] ?? '',
      paidById: json['paidById'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      artworkTitle: json['artworkTitle'] ?? '',
      artworkImageUrl: json['artworkImageUrl'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'Bank Transfer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'fee': fee,
      'bidId': bidId,
      'paidById': paidById,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
