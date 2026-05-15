// Mock API service for artworks
// Simulates REST API calls for artwork CRUD + verification

import artworksData from '../data/artworks';

let artworks = [...artworksData];
let nextId = Math.max(...artworks.map((a) => a.id)) + 1;

export const artworkService = {
  /**
   * GET /api/artworks
   */
  async getAll() {
    await new Promise((r) => setTimeout(r, 400));
    return [...artworks];
  },

  /**
   * GET /api/artworks/:id
   */
  async getById(id) {
    await new Promise((r) => setTimeout(r, 300));
    const artwork = artworks.find((a) => a.id === Number(id));
    if (!artwork) throw new Error('Karya tidak ditemukan');
    return { ...artwork };
  },

  /**
   * GET /api/artworks?artist_id=:artistId
   */
  async getByArtistId(artistId) {
    await new Promise((r) => setTimeout(r, 400));
    return artworks.filter((a) => a.artist_id === Number(artistId));
  },

  /**
   * GET /api/artworks?status=:status
   */
  async getByStatus(status) {
    await new Promise((r) => setTimeout(r, 400));
    return artworks.filter((a) => a.status === status);
  },

  /**
   * POST /api/artworks
   */
  async create(artworkData) {
    await new Promise((r) => setTimeout(r, 600));
    const newArtwork = {
      ...artworkData,
      id: nextId++,
      status: 'pending',
      verified_by: null,
      verified_at: null,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };
    artworks.push(newArtwork);
    return { ...newArtwork };
  },

  /**
   * PUT /api/artworks/:id
   */
  async update(id, data) {
    await new Promise((r) => setTimeout(r, 500));
    const idx = artworks.findIndex((a) => a.id === Number(id));
    if (idx === -1) throw new Error('Karya tidak ditemukan');
    artworks[idx] = {
      ...artworks[idx],
      ...data,
      updated_at: new Date().toISOString(),
    };
    return { ...artworks[idx] };
  },

  /**
   * DELETE /api/artworks/:id
   */
  async delete(id) {
    await new Promise((r) => setTimeout(r, 500));
    artworks = artworks.filter((a) => a.id !== Number(id));
    return { success: true };
  },

  /**
   * PUT /api/artworks/:id/verify
   * Curator verifies an artwork
   */
  async verify(id, curatorId) {
    await new Promise((r) => setTimeout(r, 500));
    const idx = artworks.findIndex((a) => a.id === Number(id));
    if (idx === -1) throw new Error('Karya tidak ditemukan');
    artworks[idx] = {
      ...artworks[idx],
      status: 'verified',
      verified_by: curatorId,
      verified_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };
    return { ...artworks[idx] };
  },

  /**
   * PUT /api/artworks/:id/unverify
   * Curator unverifies (rejects) an artwork
   */
  async unverify(id, curatorId) {
    await new Promise((r) => setTimeout(r, 500));
    const idx = artworks.findIndex((a) => a.id === Number(id));
    if (idx === -1) throw new Error('Karya tidak ditemukan');
    artworks[idx] = {
      ...artworks[idx],
      status: 'rejected',
      verified_by: curatorId,
      verified_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };
    return { ...artworks[idx] };
  },
};
