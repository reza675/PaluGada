import { apiFetch } from '../utils/api';

export const bidService = {
  async getAll() {
    return apiFetch('/bid');
  },

  async getById(id) {
    return apiFetch(`/bid/${id}/detail`);
  },

  async create({ artworks_id, ammount }) {
    return apiFetch('/bid/new', {
      method: 'POST',
      body: JSON.stringify({ artworks_id, ammount: Number(ammount) }),
    });
  },

  async cancel(id) {
    return apiFetch(`/bid/${id}/cancle`, { method: 'PUT' });
  },

  async getLowHigh() {
    return apiFetch('/bid/low-high');
  },
};
