// App constants

export const APP_NAME = 'PaluGada';
export const APP_TAGLINE = 'Galeri Seni & Lelang Online';

export const ROLES = {
  ARTIST: 'artist',
  CURATOR: 'curator',
};

export const ARTWORK_STATUS = {
  PENDING: 'pending',
  VERIFIED: 'verified',
  REJECTED: 'rejected',
  SOLD: 'sold',
};

export const BID_STATUS = {
  ACTIVE: 'active',
  OUTBID: 'outbid',
  WON: 'won',
};

export const STATUS_LABELS = {
  pending: 'Menunggu Verifikasi',
  verified: 'Terverifikasi',
  rejected: 'Ditolak',
  sold: 'Terjual',
  active: 'Aktif',
  outbid: 'Terlampaui',
  won: 'Menang',
};

export const STATUS_COLORS = {
  pending: 'warning',
  verified: 'success',
  rejected: 'danger',
  sold: 'info',
  active: 'success',
  outbid: 'danger',
  won: 'info',
};
