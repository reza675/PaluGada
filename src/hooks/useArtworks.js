import { useState, useEffect, useCallback } from 'react';
import { artworkService } from '../services/artworkService';

/**
 * Custom hook for artwork CRUD operations
 * Separates business logic from UI components
 */
export function useArtworks(artistId = null) {
  const [artworks, setArtworks] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch artworks (all or by artist)
  const fetchArtworks = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = artistId
        ? await artworkService.getByArtistId(artistId)
        : await artworkService.getAll();
      setArtworks(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }, [artistId]);

  useEffect(() => {
    fetchArtworks();
  }, [fetchArtworks]);

  // Create artwork
  const createArtwork = useCallback(async (artworkData) => {
    setIsLoading(true);
    try {
      const newArtwork = await artworkService.create(artworkData);
      setArtworks((prev) => [...prev, newArtwork]);
      setIsLoading(false);
      return { success: true, artwork: newArtwork };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, []);

  // Update artwork
  const updateArtwork = useCallback(async (id, data) => {
    setIsLoading(true);
    try {
      const updated = await artworkService.update(id, data);
      setArtworks((prev) => prev.map((a) => (a.id === Number(id) ? updated : a)));
      setIsLoading(false);
      return { success: true, artwork: updated };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, []);

  // Delete artwork
  const deleteArtwork = useCallback(async (id) => {
    setIsLoading(true);
    try {
      await artworkService.delete(id);
      setArtworks((prev) => prev.filter((a) => a.id !== Number(id)));
      setIsLoading(false);
      return { success: true };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, []);

  // Verify artwork (curator)
  const verifyArtwork = useCallback(async (id, curatorId) => {
    try {
      const updated = await artworkService.verify(id, curatorId);
      setArtworks((prev) => prev.map((a) => (a.id === Number(id) ? updated : a)));
      return { success: true, artwork: updated };
    } catch (err) {
      return { success: false, error: err.message };
    }
  }, []);

  // Unverify (reject) artwork (curator)
  const unverifyArtwork = useCallback(async (id, curatorId) => {
    try {
      const updated = await artworkService.unverify(id, curatorId);
      setArtworks((prev) => prev.map((a) => (a.id === Number(id) ? updated : a)));
      return { success: true, artwork: updated };
    } catch (err) {
      return { success: false, error: err.message };
    }
  }, []);

  return {
    artworks,
    isLoading,
    error,
    fetchArtworks,
    createArtwork,
    updateArtwork,
    deleteArtwork,
    verifyArtwork,
    unverifyArtwork,
  };
}
