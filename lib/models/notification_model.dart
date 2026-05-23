class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String? bidId;
  final String? artworksId;
  final bool isRead;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.bidId,
    this.artworksId,
    this.isRead = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory NotificationModel.fromApi(Map<String, dynamic> json) {
    final message = json['message']?.toString() ?? '';
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: _deriveTitle(message),
      message: message,
      bidId: json['bidId']?.toString(),
      artworksId: json['artworksId']?.toString(),
      isRead: false, // Notif dari API = belum dibaca
      timestamp: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static String _deriveTitle(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('outbid') || lower.contains('highest bid')) {
      return 'Penawaran Anda Disalip!';
    }
    return 'Notifikasi Lelang';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      bidId: json['bidId'],
      artworksId: json['artworksId'],
      isRead: json['isRead'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'bidId': bidId,
      'artworksId': artworksId,
      'isRead': isRead,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? bidId,
    String? artworksId,
    bool? isRead,
    DateTime? timestamp,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      bidId: bidId ?? this.bidId,
      artworksId: artworksId ?? this.artworksId,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
