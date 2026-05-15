# 📋 Dokumentasi Step-by-Step — Pasar Lelang Barang Seni

## Struktur Folder Final

```
lib/
├── main.dart                       # Entry point aplikasi
├── bindings/
│   └── app_bindings.dart           # Dependency injection semua controller
├── controllers/
│   ├── auth_controller.dart        # Login, Register, Update, Delete akun
│   ├── bidding_controller.dart     # Place bid, riwayat bid, harga max/min
│   ├── catalog_controller.dart     # Katalog, search, filter, watchlist
│   ├── home_controller.dart        # Bottom navigation tab
│   └── payment_controller.dart     # Riwayat pembayaran
├── models/
│   ├── artwork_model.dart          # Model karya seni
│   ├── bid_model.dart              # Model penawaran/bid
│   ├── payment_model.dart          # Model pembayaran
│   └── user_model.dart             # Model user
├── routes/
│   ├── app_pages.dart              # Konfigurasi routing GetX
│   └── app_routes.dart             # Konstanta nama route
├── services/
│   └── api_service.dart            # 🔜 Placeholder untuk API (diisi nanti)
├── theme/
│   ├── app_colors.dart             # Palet warna earthy/brown
│   └── app_theme.dart              # Konfigurasi Material 3 theme
└── view/
    ├── artwork_card.dart           # Widget card karya seni (reusable)
    ├── bidding_page.dart           # Halaman riwayat bidding
    ├── catalog_page.dart           # Halaman katalog + search + filter
    ├── detail_page.dart            # Halaman detail karya seni + pasang bid
    ├── edit_profile_page.dart      # Halaman edit profil
    ├── home_page.dart              # Halaman utama + bottom navigation
    ├── login_page.dart             # Halaman login
    ├── payment_page.dart           # Halaman riwayat pembayaran
    ├── profile_page.dart           # Halaman profil + logout/hapus akun
    ├── register_page.dart          # Halaman registrasi
    ├── splash_page.dart            # Splash screen animasi
    └── watchlist_page.dart         # Halaman watchlist
```

---

## Step-by-Step: Apa yang Sudah Dilakukan

### ✅ Step 1 — Inisialisasi Project Flutter
```bash
flutter create mobile
cd mobile
```

### ✅ Step 2 — Install Dependencies
Tambahkan di `pubspec.yaml` → `dependencies:`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  google_fonts: ^6.1.0
  intl: ^0.19.0
```
Lalu jalankan:
```bash
flutter pub get
```

### ✅ Step 3 — Buat Tema & Palet Warna
- [app_colors.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/theme/app_colors.dart) — warna earthy/brown
- [app_theme.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/theme/app_theme.dart) — Material 3 + Google Fonts

### ✅ Step 4 — Buat Model Data
Semua model sudah siap Firestore (`fromJson` / `toJson` / `copyWith`):
- [user_model.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/models/user_model.dart)
- [artwork_model.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/models/artwork_model.dart)
- [bid_model.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/models/bid_model.dart)
- [payment_model.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/models/payment_model.dart)

### ✅ Step 5 — Buat Controllers (Logika Bisnis)
Semua menggunakan **GetX** dengan `.obs` dan `Obx()`:
- [auth_controller.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/controllers/auth_controller.dart) — login, register, update, delete, logout
- [catalog_controller.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/controllers/catalog_controller.dart) — mock artwork data, search, filter, watchlist toggle
- [bidding_controller.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/controllers/bidding_controller.dart) — bid history, highest/lowest price, place bid
- [payment_controller.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/controllers/payment_controller.dart) — payment history, total spent
- [home_controller.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/controllers/home_controller.dart) — bottom nav index

### ✅ Step 6 — Buat Routes & Bindings
- [app_routes.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/routes/app_routes.dart) — nama-nama route
- [app_pages.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/routes/app_pages.dart) — mapping route ke halaman
- [app_bindings.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/bindings/app_bindings.dart) — dependency injection

### ✅ Step 7 — Buat Semua Halaman UI
| Halaman | File | Fitur |
|---------|------|-------|
| Splash Screen | `splash_page.dart` | Animasi fade + scale, auto navigate |
| Login | `login_page.dart` | Form validasi, toggle password |
| Register | `register_page.dart` | Form 5 field + validasi |
| Home | `home_page.dart` | Bottom nav 5 tab + dashboard |
| Katalog | `catalog_page.dart` | Search bar, filter kategori, list card |
| Detail Karya | `detail_page.dart` | Gambar hero, harga, bid range, bidder terakhir, bottom sheet bid |
| Bidding History | `bidding_page.dart` | Stats bar, last bidder highlight, ordered list |
| Watchlist | `watchlist_page.dart` | List saved artworks + remove |
| Payment History | `payment_page.dart` | Summary card + list dengan status badge |
| Profil | `profile_page.dart` | User info, menu, logout, hapus akun |
| Edit Profil | `edit_profile_page.dart` | Form edit nama, email, telepon |

### ✅ Step 8 — Buat Placeholder Services
- [api_service.dart](file:///d:/REZA/SEMESTER%206/Prak%20TCC/projek_akhir/mobile/lib/services/api_service.dart) — template GET/POST/PUT/DELETE (diisi nanti)

---

## 🔜 Step Selanjutnya (Belum Dilakukan)

### Step 9 — Integrasi API (Setelah Endpoint Siap)

1. **Install HTTP package** di `pubspec.yaml`:
   ```yaml
   dependencies:
     http: ^1.2.0
   ```

2. **Isi `api_service.dart`** dengan base URL dari teman:
   ```dart
   static const String baseUrl = 'https://api-teman-kamu.com/api';
   ```

3. **Register ApiService di bindings**:
   ```dart
   // Di app_bindings.dart
   Get.put(ApiService(), permanent: true);
   ```

4. **Update Controller** — ganti mock data dengan call API:
   ```dart
   // Contoh di auth_controller.dart
   final ApiService _api = Get.find<ApiService>();

   Future<void> login(String email, String password) async {
     isLoading.value = true;
     final response = await _api.post('/auth/login', body: {
       'email': email,
       'password': password,
     });
     currentUser.value = UserModel.fromJson(response['data']);
     isLoading.value = false;
     Get.offAllNamed(AppRoutes.home);
   }
   ```

### Step 10 — Firebase Setup (Opsional, untuk NoSQL)

1. **Buat project Firebase** di [console.firebase.google.com](https://console.firebase.google.com)
2. **Install FlutterFire CLI**:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
3. **Tambahkan dependency**:
   ```yaml
   dependencies:
     firebase_core: ^3.0.0
     cloud_firestore: ^5.0.0
     firebase_auth: ^5.0.0
   ```
4. **Inisialisasi di `main.dart`**:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     runApp(const PasarLelangApp());
   }
   ```

---

## 🎨 Mapping Fitur → File

| Fitur dari Tugas | Controller | View | Model |
|-------------------|-----------|------|-------|
| Register / Login | `auth_controller` | `login_page`, `register_page` | `UserModel` |
| Create account | `auth_controller` | `register_page` | `UserModel` |
| Update account | `auth_controller` | `edit_profile_page` | `UserModel` |
| Delete account | `auth_controller` | `profile_page` (dialog) | `UserModel` |
| Lihat katalog | `catalog_controller` | `catalog_page` | `ArtworkModel` |
| Open bidding / create bid | `bidding_controller` | `detail_page` (bottom sheet) | `BidModel` |
| Lihat bidder terakhir | `bidding_controller` | `detail_page`, `bidding_page` | `BidModel` |
| Harga terendah & tertinggi | `bidding_controller` | `detail_page`, `bidding_page` | `BidModel` |
| Riwayat payment | `payment_controller` | `payment_page` | `PaymentModel` |
| Watchlist / save | `catalog_controller` | `watchlist_page`, `artwork_card` | `ArtworkModel` |

---

## Cara Menjalankan

```bash
cd "d:\REZA\SEMESTER 6\Prak TCC\projek_akhir\mobile"
flutter pub get
flutter run
```

> [!TIP]
> Semua data saat ini masih **mock data**. Untuk presentasi, aplikasi sudah bisa berjalan penuh tanpa API. Tinggal ganti mock di controller ketika API sudah siap.
