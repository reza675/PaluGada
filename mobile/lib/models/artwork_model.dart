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
    return ArtworkModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'Painting',
      startingPrice: (json['startingPrice'] ?? 0).toDouble(),
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      highestBid: (json['highestBid'] ?? 0).toDouble(),
      lowestBid: (json['lowestBid'] ?? 0).toDouble(),
      status: json['status'] ?? 'verified',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      biddingEndTime: json['biddingEndTime'] != null
          ? DateTime.parse(json['biddingEndTime'])
          : null,
      totalBids: json['totalBids'] ?? 0,
      lastBidderName: json['lastBidderName'] ?? '',
      isInWatchlist: json['isInWatchlist'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'startingPrice': startingPrice,
      'currentPrice': currentPrice,
      'highestBid': highestBid,
      'lowestBid': lowestBid,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'biddingEndTime': biddingEndTime?.toIso8601String(),
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
