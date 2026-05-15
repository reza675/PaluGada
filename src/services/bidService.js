// Mock API service for bids
// Simulates REST API calls for reading bids

import bidsData from '../data/bids';

const bids = [...bidsData];

export const bidService = {
  /**
   * GET /api/bids
   */
  async getAll() {
    await new Promise((r) => setTimeout(r, 400));
    return [...bids];
  },

  /**
   * GET /api/bids?artwork_id=:artworkId
   */
  async getByArtworkId(artworkId) {
    await new Promise((r) => setTimeout(r, 300));
    return bids
      .filter((b) => b.artwork_id === Number(artworkId))
      .sort((a, b) => b.bid_amount - a.bid_amount);
  },

  /**
   * GET /api/bids/artist/:artistId
   * Get all bids for all artworks owned by an artist
   */
  async getByArtistArtworks(artworkIds) {
    await new Promise((r) => setTimeout(r, 400));
    return bids
      .filter((b) => artworkIds.includes(b.artwork_id))
      .sort((a, b) => new Date(b.bid_time) - new Date(a.bid_time));
  },
};
