class ArtworkModel {
  final String id;
  final String nama_karya;
  final String artistId;
  final String artistName;
  final String? ownerId;
  final String deskripsi;
  final String imageUrl;
  final String katalog;
  final String? tags;
  final int min_bid_ammount;
  final double currentPrice;
  final double highestBid;
  final double lowestBid;
  final String verification_status; // 'VERIFIED', 'UNVERIFIED'
  final DateTime? open_bid_time;
  final DateTime? close_bid_time;
  final int totalBids;
  final String lastBidderName;
  final bool isInWatchlist;

  ArtworkModel({
    required this.id,
    required this.nama_karya,
    this.artistId = '',
    this.artistName = '',
    this.ownerId,
    this.deskripsi = '',
    this.imageUrl = '',
    this.katalog = 'Lukisan',
    this.tags,
    this.min_bid_ammount = 0,
    this.currentPrice = 0,
    this.highestBid = 0,
    this.lowestBid = 0,
    this.verification_status = 'UNVERIFIED',
    this.open_bid_time,
    this.close_bid_time,
    this.totalBids = 0,
    this.lastBidderName = '',
    this.isInWatchlist = false,
  });

  factory ArtworkModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try { return DateTime.parse(value.toString()); }
      catch (_) { return null; }
    }

    String parseArtistName(Map<String, dynamic> j) {
      final artistObj = j['artist'];
      if (artistObj is Map<String, dynamic>) {
        final altName = artistObj['alt_name']?.toString() ?? '';
        final fullName = artistObj['full_name']?.toString() ?? '';
        if (altName.isNotEmpty) return altName;
        if (fullName.isNotEmpty) return fullName;
      }
      return '';
    }

    return ArtworkModel(
      id: json['id'] ?? '',
      nama_karya: json['nama_karya'] ?? '',
      artistId: json['artistId'] ?? '',
      artistName: (json['artistName']?.toString() ?? '').isNotEmpty
          ? json['artistName'].toString()
          : parseArtistName(json),
      ownerId: json['ownerId'],
      deskripsi: json['deskripsi'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      katalog: json['katalog'] ?? 'Lukisan',
      tags: json['tags'],
      min_bid_ammount: json['min_bid_ammount'] is int
          ? json['min_bid_ammount']
          : int.tryParse(json['min_bid_ammount']?.toString() ?? '0') ?? 0,
      currentPrice: toDouble(json['currentPrice']),
      highestBid: toDouble(json['highestBid']),
      lowestBid: toDouble(json['lowestBid']),
      verification_status: json['verification_status'] ?? 'UNVERIFIED',
      open_bid_time: parseDate(json['open_bid_time']),
      close_bid_time: parseDate(json['close_bid_time']),
      totalBids: json['totalBids'] ?? 0,
      lastBidderName: json['lastBidderName'] ?? '',
      isInWatchlist: json['isInWatchlist'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_karya': nama_karya,
      'artistId': artistId,
      'artistName': artistName,
      'ownerId': ownerId,
      'deskripsi': deskripsi,
      'imageUrl': imageUrl,
      'katalog': katalog,
      'tags': tags,
      'min_bid_ammount': min_bid_ammount,
      'currentPrice': currentPrice,
      'highestBid': highestBid,
      'lowestBid': lowestBid,
      'verification_status': verification_status,
      'open_bid_time': open_bid_time?.toIso8601String(),
      'close_bid_time': close_bid_time?.toIso8601String(),
      'totalBids': totalBids,
      'lastBidderName': lastBidderName,
      'isInWatchlist': isInWatchlist,
    };
  }

  ArtworkModel copyWith({
    String? id,
    String? nama_karya,
    String? artistId,
    String? artistName,
    String? ownerId,
    String? deskripsi,
    String? imageUrl,
    String? katalog,
    String? tags,
    int? min_bid_ammount,
    double? currentPrice,
    double? highestBid,
    double? lowestBid,
    String? verification_status,
    DateTime? open_bid_time,
    DateTime? close_bid_time,
    int? totalBids,
    String? lastBidderName,
    bool? isInWatchlist,
  }) {
    return ArtworkModel(
      id: id ?? this.id,
      nama_karya: nama_karya ?? this.nama_karya,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      ownerId: ownerId ?? this.ownerId,
      deskripsi: deskripsi ?? this.deskripsi,
      imageUrl: imageUrl ?? this.imageUrl,
      katalog: katalog ?? this.katalog,
      tags: tags ?? this.tags,
      min_bid_ammount: min_bid_ammount ?? this.min_bid_ammount,
      currentPrice: currentPrice ?? this.currentPrice,
      highestBid: highestBid ?? this.highestBid,
      lowestBid: lowestBid ?? this.lowestBid,
      verification_status: verification_status ?? this.verification_status,
      open_bid_time: open_bid_time ?? this.open_bid_time,
      close_bid_time: close_bid_time ?? this.close_bid_time,
      totalBids: totalBids ?? this.totalBids,
      lastBidderName: lastBidderName ?? this.lastBidderName,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
    );
  }

// Cek lelang masih berlangsung
  bool get isBiddingOpen {
    if (open_bid_time == null || close_bid_time == null) return false;
    
    final now = DateTime.now().toUtc(); 
    
    return now.isAfter(open_bid_time!) && now.isBefore(close_bid_time!);
  }

// Cek lelang sudah ditutup
  bool get isBiddingClosed {
    if (close_bid_time == null) return false;
    final now = DateTime.now().toUtc();
    return now.isAfter(close_bid_time!);
  }
}
