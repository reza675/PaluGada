# 📖 Dokumentasi PaluGada — Sistem Galeri Seni & Bidding (Lelang)

> Tugas Akhir — Teknologi Cloud Computing  
> Tema: Pasar Lelang Barang Seni  
> Tech Stack: React.js + Vite + Tailwind CSS v4

---

## 📁 Struktur Folder Project

```
PaluGada/
├── index.html                      # Entry HTML + Google Fonts
├── vite.config.js                  # Vite + Tailwind CSS v4 config
├── package.json                    # Dependencies
│
└── src/
    ├── main.jsx                    # Entry point (BrowserRouter + AuthProvider)
    ├── App.jsx                     # Route definitions + Protected Routes
    ├── index.css                   # Tailwind imports + custom theme + animations
    │
    ├── data/                       # 📦 Mock Data (simulasi database SQL)
    │   ├── users.js                # Tabel users (seniman & kurator)
    │   ├── artworks.js             # Tabel artworks (FK: artist_id, category_id)
    │   ├── bids.js                 # Tabel bids (FK: artwork_id)
    │   └── categories.js           # Tabel categories
    │
    ├── context/                    # 🔐 React Context
    │   └── AuthContext.jsx         # State management auth (login/register/logout)
    │
    ├── hooks/                      # 🎣 Custom Hooks (business logic)
    │   ├── useAuth.js              # Auth operations
    │   ├── useArtworks.js          # CRUD + verify artworks
    │   └── useBids.js              # Read & filter bids
    │
    ├── services/                   # 🌐 API Service Layer (mock)
    │   ├── authService.js          # POST /auth/login, /auth/register, dll.
    │   ├── artworkService.js       # CRUD /artworks + /artworks/:id/verify
    │   └── bidService.js           # GET /bids
    │
    ├── components/                 # 🧩 Reusable Components
    │   ├── common/                 # UI primitives
    │   │   ├── Button.jsx
    │   │   ├── Input.jsx
    │   │   ├── Modal.jsx
    │   │   ├── Card.jsx
    │   │   ├── StatusBadge.jsx
    │   │   └── LoadingSpinner.jsx
    │   ├── layout/                 # Layout components
    │   │   ├── Navbar.jsx
    │   │   ├── Sidebar.jsx
    │   │   └── Footer.jsx
    │   ├── artwork/                # Artwork-specific components
    │   │   ├── ArtworkCard.jsx
    │   │   ├── ArtworkForm.jsx
    │   │   └── ArtworkGrid.jsx
    │   └── bid/                    # Bid-specific components
    │       └── BidTable.jsx
    │
    ├── pages/                      # 📄 Page Components
    │   ├── auth/
    │   │   ├── LoginPage.jsx       # Halaman login
    │   │   └── RegisterPage.jsx    # Halaman register
    │   ├── artist/
    │   │   ├── ArtistDashboard.jsx     # Dashboard seniman
    │   │   ├── MyArtworksPage.jsx      # Daftar karya sendiri
    │   │   ├── CreateArtworkPage.jsx   # Upload karya baru
    │   │   ├── EditArtworkPage.jsx     # Edit karya
    │   │   ├── BiddingMonitorPage.jsx  # Monitor bidding
    │   │   └── AccountSettingsPage.jsx # Pengaturan akun
    │   └── curator/
    │       └── CuratorDashboard.jsx    # Dashboard kurator (verify/unverify)
    │
    └── utils/                      # 🛠️ Utilities
        ├── formatters.js           # Format currency (Rp), date, dll.
        └── constants.js            # App constants, status labels, colors
```

---

## 🚀 Langkah-langkah Setup & Menjalankan Project

### Step 1: Pastikan Prerequisites Terpasang
```bash
# Cek Node.js (butuh v18+ atau v20+)
node --version

# Cek npm
npm --version
```

### Step 2: Install Dependencies
```bash
cd PaluGada
npm install
```

### Step 3: Jalankan Dev Server
```bash
npm run dev
```
Buka browser di `http://localhost:5173`

### Step 4: Build untuk Production
```bash
npm run build
```
Output di folder `dist/`

---

## 🔑 Akun Demo (Quick Login)

Di halaman login terdapat tombol **Demo Quick Login** untuk mempermudah testing:

| Nama | Email | Role | Password |
|------|-------|------|----------|
| Budi Santoso | budi@palugada.com | artist | (any) |
| Sari Dewi | sari@palugada.com | artist | (any) |
| Agus Pratama | agus@palugada.com | artist | (any) |
| Dr. Rina Kusuma | kurator@palugada.com | curator | (any) |
| Maya Anggraeni | maya@palugada.com | curator | (any) |

> **Catatan**: Di mock mode, password tidak divalidasi. Yang penting email dan role cocok.

---

## 📋 Fitur yang Sudah Diimplementasi

### 1. Auth & Account (Seniman)
- ✅ Halaman Register (untuk seniman baru)
- ✅ Halaman Login (dengan role selector: Seniman/Kurator)
- ✅ Update Profil (nama, username, email, bio)
- ✅ Delete Account (dengan konfirmasi modal)
- ✅ Protected Routes (hanya bisa akses halaman sesuai role)

### 2. Manajemen Karya Seni (Sisi Seniman)
- ✅ Form Upload Karya (judul, deskripsi, kategori, medium, dimensi, harga, gambar)
- ✅ List/Katalog Karya Milik Sendiri (dengan filter status)
- ✅ Update Detail Karya
- ✅ Delete Karya (dengan konfirmasi modal)

### 3. Verifikasi Karya (Sisi Kurator)
- ✅ Dashboard Kurator dengan daftar semua karya masuk
- ✅ Filter karya berdasarkan status (Semua/Pending/Verified/Rejected)
- ✅ Detail karya dalam modal
- ✅ Fungsi Verify karya
- ✅ Fungsi Unverify (Reject) karya

### 4. Monitoring Bidding (Sisi Seniman)
- ✅ Halaman monitor bidding dengan statistik (total bid, bid aktif, bid tertinggi)
- ✅ Tabel bid lengkap (nama bidder, email, jumlah, waktu, status)
- ✅ Bid terbaru di dashboard seniman

---

## 🗄️ Skema Database (Mock Data)

Mock data terstruktur relasional agar mudah dimigrasi ke SQL:

### Tabel `users`
| Column | Type | Keterangan |
|--------|------|------------|
| id | INT (PK) | Auto increment |
| username | VARCHAR | Unique |
| email | VARCHAR | Unique |
| password_hash | VARCHAR | Bcrypt hash |
| role | ENUM | 'artist' \| 'curator' |
| full_name | VARCHAR | |
| bio | TEXT | |
| avatar_url | VARCHAR | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### Tabel `categories`
| Column | Type | Keterangan |
|--------|------|------------|
| id | INT (PK) | Auto increment |
| name | VARCHAR | Nama kategori |
| description | TEXT | |

### Tabel `artworks`
| Column | Type | Keterangan |
|--------|------|------------|
| id | INT (PK) | Auto increment |
| artist_id | INT (FK) | → users.id |
| category_id | INT (FK) | → categories.id |
| title | VARCHAR | |
| description | TEXT | |
| medium | VARCHAR | Teknik/bahan |
| dimensions | VARCHAR | |
| year_created | INT | |
| image_url | VARCHAR | |
| starting_price | DECIMAL | Harga awal lelang |
| status | ENUM | 'pending' \| 'verified' \| 'rejected' \| 'sold' |
| verified_by | INT (FK) | → users.id (kurator) |
| verified_at | TIMESTAMP | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### Tabel `bids`
| Column | Type | Keterangan |
|--------|------|------------|
| id | INT (PK) | Auto increment |
| artwork_id | INT (FK) | → artworks.id |
| bidder_name | VARCHAR | Nama kolektor (dari mobile) |
| bidder_email | VARCHAR | |
| bid_amount | DECIMAL | |
| bid_time | TIMESTAMP | |
| status | ENUM | 'active' \| 'outbid' \| 'won' |

---

## 📌 Langkah Selanjutnya (Integrasi Backend)

### Step 1: Siapkan Endpoint API Backend
Pastikan backend menyediakan endpoint berikut:

```
POST   /api/auth/register       → Register seniman baru
POST   /api/auth/login          → Login
GET    /api/users/:id           → Get user detail
PUT    /api/users/:id           → Update user
DELETE /api/users/:id           → Delete user

GET    /api/artworks            → Get semua karya (+ query params)
GET    /api/artworks/:id        → Get detail karya
POST   /api/artworks            → Upload karya baru
PUT    /api/artworks/:id        → Update karya
DELETE /api/artworks/:id        → Delete karya
PUT    /api/artworks/:id/verify → Verify karya (kurator)
PUT    /api/artworks/:id/reject → Reject karya (kurator)

GET    /api/bids                → Get semua bid (+ query params)
GET    /api/bids?artwork_id=:id → Get bid per karya
```

Total: **15 endpoint** (sesuai requirement minimal)

### Step 2: Install Axios
```bash
npm install axios
```

### Step 3: Buat API Client
Buat file `src/services/apiClient.js`:
```javascript
import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'http://YOUR_BACKEND_URL/api',
  headers: { 'Content-Type': 'application/json' },
});

// Tambahkan interceptor untuk auth token
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

export default apiClient;
```

### Step 4: Update Service Layer
Ganti mock service dengan real API call. Contoh untuk `artworkService.js`:
```javascript
import apiClient from './apiClient';

export const artworkService = {
  async getAll() {
    const { data } = await apiClient.get('/artworks');
    return data;
  },
  async create(artworkData) {
    const { data } = await apiClient.post('/artworks', artworkData);
    return data;
  },
  // ... dst
};
```

> **Penting**: Anda hanya perlu mengubah file di folder `services/`. Hooks dan komponen UI **tidak perlu diubah** karena sudah terpisah (modular).

### Step 5: Deploy ke Cloud
1. **Frontend**: Deploy ke Google Cloud Storage (static hosting) atau Cloud Run
2. **Backend**: Deploy ke Google App Engine atau Google Compute Engine
3. **Database**: Deploy MySQL ke Google Cloud SQL

### Step 6: Environment Variables
Buat file `.env` untuk URL backend:
```
VITE_API_BASE_URL=https://your-backend-url.com/api
```

Update `apiClient.js`:
```javascript
baseURL: import.meta.env.VITE_API_BASE_URL
```

---

## 🎨 Design System

- **Color Palette**: Warm earth tones (brown/gold dark theme)
- **Typography**: Inter (sans-serif) + Playfair Display (serif untuk heading)
- **Styling**: Tailwind CSS v4 dengan custom theme tokens
- **Effects**: Glassmorphism, micro-animations, hover effects
- **Layout**: Sidebar + Navbar responsive layout

---

## 📝 Route Map

| Route | Halaman | Role |
|-------|---------|------|
| `/login` | Login | Public |
| `/register` | Register | Public |
| `/artist/dashboard` | Dashboard Seniman | Artist |
| `/artist/artworks` | Karya Saya | Artist |
| `/artist/artworks/create` | Upload Karya | Artist |
| `/artist/artworks/:id/edit` | Edit Karya | Artist |
| `/artist/bidding` | Monitor Bidding | Artist |
| `/artist/account` | Pengaturan Akun | Artist |
| `/curator/dashboard` | Dashboard Kurator | Curator |

---

*Dibuat untuk Tugas Akhir Praktikum Teknologi Cloud Computing 2025*
