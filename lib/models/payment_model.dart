class PaymentModel {
  final String id;
  final String artworkId;
  final String artworkTitle;
  final String artworkImageUrl;
  final double amount;
  final String status; // 'pending', 'completed', 'failed'
  final String paymentMethod;
  final DateTime paymentDate;

  PaymentModel({
    required this.id,
    required this.artworkId,
    required this.artworkTitle,
    this.artworkImageUrl = '',
    required this.amount,
    this.status = 'completed',
    this.paymentMethod = 'Bank Transfer',
    DateTime? paymentDate,
  }) : paymentDate = paymentDate ?? DateTime.now();

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      artworkId: json['artworkId'] ?? '',
      artworkTitle: json['artworkTitle'] ?? '',
      artworkImageUrl: json['artworkImageUrl'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'completed',
      paymentMethod: json['paymentMethod'] ?? 'Bank Transfer',
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artworkId': artworkId,
      'artworkTitle': artworkTitle,
      'artworkImageUrl': artworkImageUrl,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate.toIso8601String(),
    };
  }
}
