# 🎨 Pasar Lelang Barang Seni — Flutter Mobile App

## Arsitektur: MVC + GetX

```
lib/
├── main.dart                          # Entry point (GetMaterialApp)
├── app/
│   ├── bindings/
│   │   └── app_bindings.dart          # Dependency injection (semua controller)
│   ├── controllers/                   # Controller (C dalam MVC)
│   │   ├── auth_controller.dart       # Login, Register, Update, Delete account
│   │   ├── bidding_controller.dart    # Place bid, riwayat bid, harga tertinggi/terendah
│   │   ├── catalog_controller.dart    # Katalog karya seni, search, filter, watchlist
│   │   ├── home_controller.dart       # Bottom nav tab management
│   │   └── payment_controller.dart    # Riwayat pembayaran
│   ├── models/                        # Model (M dalam MVC)
│   │   ├── artwork_model.dart         # Karya seni
│   │   ├── bid_model.dart             # Bid/penawaran
│   │   ├── payment_model.dart         # Pembayaran
│   │   └── user_model.dart            # User/kolektor
│   ├── routes/
│   │   ├── app_pages.dart             # GetPage routing + transitions
│   │   └── app_routes.dart            # Route name constants
│   ├── theme/
│   │   ├── app_colors.dart            # Palet warna earthy/brown
│   │   └── app_theme.dart             # Material 3 theme + Google Fonts
│   └── views/                         # View (V dalam MVC)
│       ├── auth/
│       │   ├── login_view.dart        # Halaman login
│       │   └── register_view.dart     # Halaman registrasi
│       ├── bidding/
│       │   └── bidding_view.dart      # Riwayat bidding + harga tertinggi/terendah
│       ├── catalog/
│       │   ├── art_detail_view.dart   # Detail karya seni + pasang bid
│       │   ├── catalog_view.dart      # Katalog dengan search & filter
│       │   └── widgets/
│       │       └── artwork_card.dart  # Card karya seni (compact & full mode)
│       ├── home/
│       │   ├── home_view.dart         # Bottom nav container (5 tab)
│       │   └── widgets/
│       │       └── home_dashboard.dart # Dashboard beranda
│       ├── payment/
│       │   └── payment_history_view.dart # Riwayat pembayaran
│       ├── profile/
│       │   ├── edit_profile_view.dart    # Edit profil
│       │   └── profile_view.dart         # Halaman profil + logout/hapus akun
│       ├── splash/
│       │   └── splash_view.dart          # Splash screen animasi
│       └── watchlist/
│           └── watchlist_view.dart       # Daftar watchlist
```

## Fitur yang Diimplementasi

| Fitur | Screen | Status |
|-------|--------|--------|
| Register / Login | `LoginView`, `RegisterView` | ✅ UI + Mock |
| Create Account | `RegisterView` | ✅ UI + Mock |
| Update Account | `EditProfileView` | ✅ UI + Mock |
| Delete Account | `ProfileView` (dialog) | ✅ UI + Mock |
| Lihat Katalog | `CatalogView` + search & filter | ✅ UI + Mock |
| Open Bidding (create bid) | `ArtDetailView` (bottom sheet) | ✅ UI + Mock |
| Lihat bidder terakhir | `ArtDetailView` + `BiddingView` | ✅ UI + Mock |
| Harga terendah & tertinggi | `ArtDetailView` + `BiddingView` | ✅ UI + Mock |
| Riwayat Payment | `PaymentHistoryView` | ✅ UI + Mock |
| Watchlist (save) | Toggle di `ArtworkCard` + `WatchlistView` | ✅ UI + Mock |

## Palet Warna

Semua warna menggunakan **earthy/brown tones** sesuai referensi:

| Warna | Hex | Penggunaan |
|-------|-----|------------|
| Primary | `#6D4C2E` | Tombol, header, aksen utama |
| Primary Dark | `#4A3320` | Gradient gelap |
| Primary Light | `#8B6B4A` | Icon prefix input |
| Accent (Golden Tan) | `#C9A96E` | Highlight, badge kategori |
| Background | `#F5EDE3` | Scaffold background |
| Card | `#FAF5EF` | Card background |

## Langkah Selanjutnya

> [!IMPORTANT]
> Semua data saat ini menggunakan **mock data** di controller. Setelah API endpoint siap, tinggal ganti bagian mock di controller dengan HTTP call ke API.

1. **Integrasi Firestore** — Tambahkan `cloud_firestore` dan `firebase_auth` di `pubspec.yaml`
2. **Ganti Mock → API** — Update method di controller (login, register, loadArtworks, dll)
3. **Tambahkan Firebase Auth** — Ganti mock login/register di `AuthController`
4. **Real-time Bidding** — Gunakan Firestore `snapshots()` untuk live update bid

## Cara Menjalankan

```bash
cd mobile
flutter pub get
flutter run
```
