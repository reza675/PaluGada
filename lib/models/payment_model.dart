class PaymentModel {
  final String id;
  final int amount;
  final double fee;
  final String bidId;
  final String paidById;
  final DateTime timestamp;
  final String artworkId;
  final String artworkTitle;
  final String artworkImageUrl;
  final String paymentMethod;
  final String artistName;

  PaymentModel({
    required this.id,
    required this.amount,
    this.fee = 0,
    required this.bidId,
    this.paidById = '',
    DateTime? timestamp,
    this.artworkId = '',
    this.artworkTitle = '',
    this.artworkImageUrl = '',
    this.paymentMethod = 'Bank Transfer',
    this.artistName = '',
  }) : timestamp = timestamp ?? DateTime.now();

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      amount: json['amount'] is int
          ? json['amount']
          : int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      fee: (json['fee'] ?? 0).toDouble(),
      bidId: json['bidId'] ?? '',
      paidById: json['paidById'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      artworkId: json['artworkId'] ?? '',
      artworkTitle: json['artworkTitle'] ?? '',
      artworkImageUrl: json['artworkImageUrl'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'Bank Transfer',
      artistName: json['artistName'] ?? '',
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
      'artistName': artistName,
    };
  }

  PaymentModel copyWith({
    String? artistName,
    String? artworkTitle,
    String? artworkImageUrl,
  }) {
    return PaymentModel(
      id: id,
      amount: amount,
      fee: fee,
      bidId: bidId,
      paidById: paidById,
      timestamp: timestamp,
      artworkId: artworkId,
      artworkTitle: artworkTitle ?? this.artworkTitle,
      artworkImageUrl: artworkImageUrl ?? this.artworkImageUrl,
      paymentMethod: paymentMethod,
      artistName: artistName ?? this.artistName,
    );
  }
}
