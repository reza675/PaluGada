import { apiFetch, setTokens, clearTokens, getTokens } from '../utils/api';

export const authService = {
  async login({ email, password }) {
    const data = await apiFetch('/user/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
    setTokens(data.token, data.refreshToken);
    return data;
  },

  async register({ username, full_name, email, phone_number, password, role, alt_name }) {
    const data = await apiFetch('/user/register', {
      method: 'POST',
      body: JSON.stringify({ username, full_name, email, phone_number, password, role, alt_name }),
    });
    return data;
  },

  async getProfile() {
    const data = await apiFetch('/user/profile');
    return data.user;
  },

  async updateProfile({ full_name, alt_name }) {
    return apiFetch('/user/update/profile', {
      method: 'PUT',
      body: JSON.stringify({ full_name, alt_name }),
    });
  },

  async updatePassword(password) {
    return apiFetch('/user/update/password', {
      method: 'PUT',
      body: JSON.stringify({ password }),
    });
  },

  async logout() {
    const { refreshToken } = getTokens();
    try {
      if (refreshToken) {
        await apiFetch('/user/logout', {
          method: 'POST',
          body: JSON.stringify({ refreshToken }),
        });
      }
    } catch {
    } finally {
      clearTokens();
    }
  },
  
  async deleteAccount() {
    const result = await apiFetch('/user/delete', { method: 'DELETE' });
    clearTokens();
    return result;
  },
};
