// Mock API service for authentication
// This layer simulates REST API calls — replace with real fetch/axios calls later

import usersData from '../data/users';

let users = [...usersData];

export const authService = {
  /**
   * POST /api/auth/login
   */
  async login(email, role) {
    await new Promise((r) => setTimeout(r, 500));
    const user = users.find((u) => u.email === email && u.role === role);
    if (!user) throw new Error('User tidak ditemukan');
    return { ...user };
  },

  /**
   * POST /api/auth/register
   */
  async register(userData) {
    await new Promise((r) => setTimeout(r, 500));
    if (users.some((u) => u.email === userData.email)) {
      throw new Error('Email sudah terdaftar');
    }
    const newUser = {
      ...userData,
      id: Math.max(...users.map((u) => u.id)) + 1,
      role: 'artist',
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };
    users.push(newUser);
    return newUser;
  },

  /**
   * PUT /api/users/:id
   */
  async updateUser(id, data) {
    await new Promise((r) => setTimeout(r, 500));
    const idx = users.findIndex((u) => u.id === id);
    if (idx === -1) throw new Error('User tidak ditemukan');
    users[idx] = { ...users[idx], ...data, updated_at: new Date().toISOString() };
    return users[idx];
  },

  /**
   * DELETE /api/users/:id
   */
  async deleteUser(id) {
    await new Promise((r) => setTimeout(r, 500));
    users = users.filter((u) => u.id !== id);
    return { success: true };
  },
};
