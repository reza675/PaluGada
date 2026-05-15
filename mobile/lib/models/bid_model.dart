class BidModel {
  final String id;
  final String artworkId;
  final String bidderId;
  final String bidderName;
  final double amount;
  final DateTime bidTime;

  BidModel({
    required this.id,
    required this.artworkId,
    required this.bidderId,
    required this.bidderName,
    required this.amount,
    DateTime? bidTime,
  }) : bidTime = bidTime ?? DateTime.now();

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] ?? '',
      artworkId: json['artworkId'] ?? '',
      bidderId: json['bidderId'] ?? '',
      bidderName: json['bidderName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      bidTime: json['bidTime'] != null
          ? DateTime.parse(json['bidTime'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artworkId': artworkId,
      'bidderId': bidderId,
      'bidderName': bidderName,
      'amount': amount,
      'bidTime': bidTime.toIso8601String(),
    };
  }
}
