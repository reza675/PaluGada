import { apiFetch } from '../utils/api';

export const artworkService = {
  async getAll(katalogFilter = null) {
    const query = katalogFilter ? `?katalog=${encodeURIComponent(katalogFilter)}` : '';
    return apiFetch(`/karya-seni/all${query}`);
  },

  async getById(id) {
    return apiFetch(`/karya-seni/${id}`);
  },

  async create(artworkData) {
    return apiFetch('/karya-seni/create', {
      method: 'POST',
      body: JSON.stringify({
        nama_karya: artworkData.nama_karya,
        deskripsi: artworkData.deskripsi || null,
        katalog: artworkData.katalog || null,
        tags: artworkData.tags || null,
        min_bid_ammount: Number(artworkData.min_bid_ammount),
        open_bid_time: artworkData.open_bid_time || null,
        close_bid_time: artworkData.close_bid_time || null,
      }),
    });
  },

  async update(id, artworkData) {
    return apiFetch(`/karya-seni/${id}/detail`, {
      method: 'PUT',
      body: JSON.stringify({
        nama_karya: artworkData.nama_karya,
        deskripsi: artworkData.deskripsi || null,
        katalog: artworkData.katalog || null,
        tags: artworkData.tags || null,
        min_bid_ammount: Number(artworkData.min_bid_ammount),
        open_bid_time: artworkData.open_bid_time || null,
        close_bid_time: artworkData.close_bid_time || null,
      }),
    });
  },

  async delete(id) {
    return apiFetch(`/karya-seni/${id}/delete`, { method: 'DELETE' });
  },

  async verify(id) {
    return apiFetch(`/karya-seni/${id}/verify`, { method: 'PUT' });
  },

  async unverify(id) {
    return apiFetch(`/karya-seni/${id}/unverify`, { method: 'PUT' });
  },

  async uploadImage(id, imageFile) {
    const formData = new FormData();
    formData.append('image', imageFile);
    return apiFetch(`/karya-seni/${id}/image`, {
      method: 'POST',
      body: formData,
    }, true); 
  },
};
