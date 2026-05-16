class ArtworkModel {
  final String id;
  final String title;
  final String artist;
  final String description;
  final String imageUrl;
  final String category;
  final double startingPrice;
  final double currentPrice;
  final double highestBid;
  final double lowestBid;
  final String status; // 'verified', 'pending', 'bidding', 'sold'
  final DateTime createdAt;
  final DateTime? biddingEndTime;
  final int totalBids;
  final String lastBidderName;
  final bool isInWatchlist;

  ArtworkModel({
    required this.id,
    required this.title,
    required this.artist,
    this.description = '',
    this.imageUrl = '',
    this.category = 'Painting',
    this.startingPrice = 0,
    this.currentPrice = 0,
    this.highestBid = 0,
    this.lowestBid = 0,
    this.status = 'verified',
    DateTime? createdAt,
    this.biddingEndTime,
    this.totalBids = 0,
    this.lastBidderName = '',
    this.isInWatchlist = false,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ArtworkModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    String mapStatus(dynamic value) {
      final v = value?.toString();
      return v == 'VERIFIED' ? 'verified' : 'pending';
    }

    return ArtworkModel(
      id: json['id'] ?? '',
      title: json['nama_karya'] ?? '',
      artist: json['artist'] ?? '',
      description: json['deskripsi'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['katalog'] ?? 'Painting',
      startingPrice: toDouble(json['min_bid_ammount']),
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      highestBid: (json['highestBid'] ?? 0).toDouble(),
      lowestBid: (json['lowestBid'] ?? 0).toDouble(),
      status: mapStatus(json['verification_status']),
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
      biddingEndTime: parseDate(json['close_bid_time']),
      totalBids: json['totalBids'] ?? 0,
      lastBidderName: json['lastBidderName'] ?? '',
      isInWatchlist: json['isInWatchlist'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final verificationStatus = status == 'verified' ? 'VERIFIED' : 'UNVERIFIED';
    return {
      'id': id,
      'nama_karya': title,
      'artist': artist,
      'deskripsi': description,
      'imageUrl': imageUrl,
      'katalog': category,
      'min_bid_ammount': startingPrice,
      'currentPrice': currentPrice,
      'highestBid': highestBid,
      'lowestBid': lowestBid,
      'verification_status': verificationStatus,
      'createdAt': createdAt.toIso8601String(),
      'close_bid_time': biddingEndTime?.toIso8601String(),
      'totalBids': totalBids,
      'lastBidderName': lastBidderName,
      'isInWatchlist': isInWatchlist,
    };
  }

  ArtworkModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? description,
    String? imageUrl,
    String? category,
    double? startingPrice,
    double? currentPrice,
    double? highestBid,
    double? lowestBid,
    String? status,
    DateTime? createdAt,
    DateTime? biddingEndTime,
    int? totalBids,
    String? lastBidderName,
    bool? isInWatchlist,
  }) {
    return ArtworkModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      startingPrice: startingPrice ?? this.startingPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      highestBid: highestBid ?? this.highestBid,
      lowestBid: lowestBid ?? this.lowestBid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      biddingEndTime: biddingEndTime ?? this.biddingEndTime,
      totalBids: totalBids ?? this.totalBids,
      lastBidderName: lastBidderName ?? this.lastBidderName,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
    );
  }
}
