import 'package:get/get.dart';
import '../models/artwork_model.dart';

class CatalogController extends GetxController {
  final artworks = <ArtworkModel>[].obs;
  final filteredArtworks = <ArtworkModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'Semua'.obs;
  final categories = ['Semua', 'Lukisan', 'Patung', 'Fotografi', 'Digital Art', 'Keramik'].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockArtworks();
  }

  void loadMockArtworks() {
    isLoading.value = true;
    artworks.value = [
      ArtworkModel(
        id: 'art_001', title: 'Sunset Over Rice Fields', artist: 'Bambang Suryadi',
        description: 'Lukisan pemandangan sawah saat matahari terbenam yang menangkap keindahan alam Indonesia dengan gradasi warna jingga dan emas yang memukau.',
        imageUrl: 'https://picsum.photos/seed/art1/400/500', category: 'Lukisan',
        startingPrice: 5000000, currentPrice: 7500000, highestBid: 7500000, lowestBid: 5200000,
        status: 'bidding', totalBids: 12, lastBidderName: 'Ahmad Fauzi',
        biddingEndTime: DateTime.now().add(const Duration(hours: 5)),
      ),
      ArtworkModel(
        id: 'art_002', title: 'Dewi Sri', artist: 'Made Wijaya',
        description: 'Patung perunggu Dewi Sri, dewi padi dan kesuburan dalam mitologi Jawa dan Bali, dengan detail ornamen tradisional yang sangat halus.',
        imageUrl: 'https://picsum.photos/seed/art2/400/500', category: 'Patung',
        startingPrice: 15000000, currentPrice: 22000000, highestBid: 22000000, lowestBid: 15500000,
        status: 'bidding', totalBids: 8, lastBidderName: 'Siti Rahayu',
        biddingEndTime: DateTime.now().add(const Duration(hours: 12)),
      ),
      ArtworkModel(
        id: 'art_003', title: 'Jakarta Malam', artist: 'Dian Permata',
        description: 'Fotografi malam hari kota Jakarta yang menampilkan gemerlap lampu gedung pencakar langit dan jalanan yang ramai.',
        imageUrl: 'https://picsum.photos/seed/art3/400/500', category: 'Fotografi',
        startingPrice: 3000000, currentPrice: 4200000, highestBid: 4200000, lowestBid: 3100000,
        status: 'bidding', totalBids: 6, lastBidderName: 'Budi Santoso',
        biddingEndTime: DateTime.now().add(const Duration(hours: 3)),
      ),
      ArtworkModel(
        id: 'art_004', title: 'Nusantara Dreams', artist: 'Rina Kusuma',
        description: 'Karya digital art yang menggabungkan elemen-elemen budaya nusantara dengan gaya futuristik cyberpunk.',
        imageUrl: 'https://picsum.photos/seed/art4/400/500', category: 'Digital Art',
        startingPrice: 2000000, currentPrice: 3800000, highestBid: 3800000, lowestBid: 2200000,
        status: 'bidding', totalBids: 15, lastBidderName: 'Dewi Lestari',
        biddingEndTime: DateTime.now().add(const Duration(hours: 8)),
      ),
      ArtworkModel(
        id: 'art_005', title: 'Guci Majapahit', artist: 'Agus Ceramic',
        description: 'Keramik bergaya kerajaan Majapahit dengan motif surya dan flora khas abad ke-14, dibuat dengan teknik tradisional.',
        imageUrl: 'https://picsum.photos/seed/art5/400/500', category: 'Keramik',
        startingPrice: 8000000, currentPrice: 12000000, highestBid: 12000000, lowestBid: 8500000,
        status: 'bidding', totalBids: 10, lastBidderName: 'Hasan Ibrahim',
        biddingEndTime: DateTime.now().add(const Duration(days: 1)),
      ),
      ArtworkModel(
        id: 'art_006', title: 'Tarian Legong', artist: 'Nyoman Artika',
        description: 'Lukisan penari Legong Bali dengan detail kostum emas dan ekspresi penari yang menawan dalam gaya semi-realis.',
        imageUrl: 'https://picsum.photos/seed/art6/400/500', category: 'Lukisan',
        startingPrice: 10000000, currentPrice: 10000000, status: 'verified',
      ),
      ArtworkModel(
        id: 'art_007', title: 'Wayang Kontemporer', artist: 'Bambang Suryadi',
        description: 'Interpretasi modern wayang kulit dalam bentuk digital art dengan sentuhan neon dan warna-warna berani.',
        imageUrl: 'https://picsum.photos/seed/art7/400/500', category: 'Digital Art',
        startingPrice: 4500000, currentPrice: 6700000, highestBid: 6700000, lowestBid: 4800000,
        status: 'bidding', totalBids: 9, lastBidderName: 'Linda Wijaya',
        biddingEndTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      ArtworkModel(
        id: 'art_008', title: 'Borobudur Sunrise', artist: 'Dian Permata',
        description: 'Fotografi matahari terbit di Candi Borobudur dengan kabut pagi yang menciptakan suasana mistis dan megah.',
        imageUrl: 'https://picsum.photos/seed/art8/400/500', category: 'Fotografi',
        startingPrice: 5500000, currentPrice: 5500000, status: 'verified',
      ),
    ];
    filteredArtworks.value = artworks;
    isLoading.value = false;
  }

  void searchArtworks(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void _applyFilters() {
    List<ArtworkModel> result = artworks;
    if (selectedCategory.value != 'Semua') {
      result = result.where((a) => a.category == selectedCategory.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((a) =>
        a.title.toLowerCase().contains(q) ||
        a.artist.toLowerCase().contains(q) ||
        a.category.toLowerCase().contains(q)
      ).toList();
    }
    filteredArtworks.value = result;
  }

  ArtworkModel? getArtworkById(String id) {
    try { return artworks.firstWhere((a) => a.id == id); }
    catch (_) { return null; }
  }

  void toggleWatchlist(String artworkId) {
    final index = artworks.indexWhere((a) => a.id == artworkId);
    if (index != -1) {
      final artwork = artworks[index];
      artworks[index] = artwork.copyWith(isInWatchlist: !artwork.isInWatchlist);
      _applyFilters();
    }
  }

  List<ArtworkModel> get watchlistItems =>
      artworks.where((a) => a.isInWatchlist).toList();
}
