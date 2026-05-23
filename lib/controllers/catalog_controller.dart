import 'package:flutter/material.dart';
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
    'Clasic',
    'Modern',
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

      Map<String, int> bidCounts = {};
      try {
        final bidResponse = await _api.get('/bid');
        final bidList = _extractList(bidResponse);
        for (var b in bidList) {
          final artworkId = b['artworksId']?.toString();
          if (artworkId != null) {
            bidCounts[artworkId] = (bidCounts[artworkId] ?? 0) + 1;
          }
        }
      } catch (_) {
        // Abaikan jika gagal memuat history
      }

      final mapped = dataList.map((json) {
        final data = Map<String, dynamic>.from(json);
        final id = data['id']?.toString();
        data['totalBids'] = id != null ? (bidCounts[id] ?? 0) : 0;
        return ArtworkModel.fromJson(data);
      }).toList();

      artworks.assignAll(mapped);
      filteredArtworks.assignAll(mapped);
      await fetchUserWishlist();

      _fetchArtistNamesBackground();
    } catch (error) {
      Get.snackbar('Gagal memuat', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchArtistNamesBackground() async {
    for (int i = 0; i < artworks.length; i++) {
      if (artworks[i].artistName.isEmpty) {
        try {
          final detail = await fetchArtworkDetail(artworks[i].id);
          _applyFilters();
        } catch (_) {}
      }
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

Future<void> toggleWatchlist(String id) async {
    final index = artworks.indexWhere((a) => a.id == id);
    if (index == -1) return;

    final artwork = artworks[index];
    final currentStatus = artwork.isInWatchlist;
    final newStatus = !currentStatus;
    artworks[index] = artwork.copyWith(isInWatchlist: newStatus);

    // Kirim perubahan ke Backend
    try {
      if (newStatus) {
        await _api.addToWishlist(id);
        Get.snackbar(
          'Sukses', 
          'Ditambahkan ke Watchlist', 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        await _api.removeFromWishlist(id);
        Get.snackbar(
          'Dihapus', 
          'Dihapus dari Watchlist', 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      artworks[index] = artwork.copyWith(isInWatchlist: currentStatus);
      Get.snackbar(
        'Gagal', 
        'Terjadi kesalahan saat menyimpan wishlist',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchUserWishlist() async {
    try {
      final wishlistData = await _api.getWishlist();
      
      final wishlistIds = wishlistData.map((e) => e['id'].toString()).toList();

      for (int i = 0; i < artworks.length; i++) {
        if (wishlistIds.contains(artworks[i].id)) {
          artworks[i] = artworks[i].copyWith(isInWatchlist: true);
        } else {
          artworks[i] = artworks[i].copyWith(isInWatchlist: false);
        }
      }
    } catch (e) {
      print("Error memuat wishlist: $e");
    }
  }

  List<ArtworkModel> get watchlistItems =>
      artworks.where((a) => a.isInWatchlist).toList();

  Future<ArtworkModel?> fetchArtworkDetail(String id) async {
    try {
      final response = await _api.get('/karya-seni/$id');
      if (response is Map<String, dynamic>) {
        final detail = ArtworkModel.fromJson(response);
        final idx = artworks.indexWhere((a) => a.id == id);
        if (idx != -1) {
          artworks[idx] = detail.copyWith(
            isInWatchlist: artworks[idx].isInWatchlist,
            totalBids: artworks[idx].totalBids,
          );
        }
        return detail;
      }
    } catch (e) {
      print('fetchArtworkDetail error: $e');
    }
    return null;
  }
}

