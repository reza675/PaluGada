import 'package:get/get.dart';
import '../models/artwork_model.dart';
import '../services/api_service.dart';

class CatalogController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final artworks = <ArtworkModel>[].obs;
  final filteredArtworks = <ArtworkModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'Semua'.obs;
  final categories = [
    'Semua',
    'Lukisan',
    'Patung',
    'Fotografi',
    'Digital Art',
    'Keramik',
    'Modern',
    'Classic',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadArtworks();
  }

  Future<void> loadArtworks() async {
    isLoading.value = true;
    try {
      final response = await _api.get('/karya-seni/all');
      final dataList = _extractList(response);
      final mapped = dataList
          .map((json) => ArtworkModel.fromJson(json))
          .toList();
      artworks.assignAll(mapped);
      filteredArtworks.assignAll(mapped);
    } catch (error) {
      Get.snackbar('Gagal memuat', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }
    if (response is Map && response['data'] is List) {
      return (response['data'] as List).cast<Map<String, dynamic>>();
    }
    return <Map<String, dynamic>>[];
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
      result = result
          .where((a) => a.katalog == selectedCategory.value)
          .toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result
          .where(
            (a) =>
                a.nama_karya.toLowerCase().contains(q) ||
                a.artistId.toLowerCase().contains(q) ||
                a.katalog.toLowerCase().contains(q),
          )
          .toList();
    }
    filteredArtworks.value = result;
  }

  ArtworkModel? getArtworkById(String id) {
    try {
      return artworks.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
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
