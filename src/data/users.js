// Mock data: users table
// Simulates SQL table with id, username, email, password_hash, role, etc.

const users = [
  {
    id: 1,
    username: 'budi_artisan',
    email: 'budi@palugada.com',
    password_hash: 'hashed_password_1', // In production: bcrypt hash
    role: 'artist',
    full_name: 'Budi Santoso',
    bio: 'Seniman lukis kontemporer dari Yogyakarta. Mengeksplorasi tema alam dan budaya Jawa dalam setiap karya.',
    avatar_url: 'https://picsum.photos/seed/budi/200/200',
    created_at: '2025-01-15T08:00:00Z',
    updated_at: '2025-06-10T14:30:00Z',
  },
  {
    id: 2,
    username: 'sari_painter',
    email: 'sari@palugada.com',
    password_hash: 'hashed_password_2',
    role: 'artist',
    full_name: 'Sari Dewi',
    bio: 'Pelukis abstrak modern. Karya saya terinspirasi dari keindahan laut Indonesia.',
    avatar_url: 'https://picsum.photos/seed/sari/200/200',
    created_at: '2025-02-20T10:00:00Z',
    updated_at: '2025-07-05T09:15:00Z',
  },
  {
    id: 3,
    username: 'agus_sculptor',
    email: 'agus@palugada.com',
    password_hash: 'hashed_password_3',
    role: 'artist',
    full_name: 'Agus Pratama',
    bio: 'Pematung dan seniman mixed media dari Bali. Menggabungkan tradisi dan modernitas.',
    avatar_url: 'https://picsum.photos/seed/agus/200/200',
    created_at: '2025-03-10T12:00:00Z',
    updated_at: '2025-08-01T16:45:00Z',
  },
  {
    id: 4,
    username: 'kurator_utama',
    email: 'kurator@palugada.com',
    password_hash: 'hashed_password_4',
    role: 'curator',
    full_name: 'Dr. Rina Kusuma',
    bio: 'Kurator seni dengan pengalaman 15 tahun di galeri nasional.',
    avatar_url: 'https://picsum.photos/seed/rina/200/200',
    created_at: '2025-01-01T08:00:00Z',
    updated_at: '2025-01-01T08:00:00Z',
  },
  {
    id: 5,
    username: 'kurator_dua',
    email: 'maya@palugada.com',
    password_hash: 'hashed_password_5',
    role: 'curator',
    full_name: 'Maya Anggraeni',
    bio: 'Kurator junior, spesialisasi seni kontemporer Asia Tenggara.',
    avatar_url: 'https://picsum.photos/seed/maya/200/200',
    created_at: '2025-04-01T08:00:00Z',
    updated_at: '2025-04-01T08:00:00Z',
  },
];

export default users;
