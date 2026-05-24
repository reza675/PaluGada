import { useState, useEffect, useCallback } from 'react';
import { artworkService } from '../services/artworkService';

export function useArtworks(artistId = null) {
  const [artworks, setArtworks] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchArtworks = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await artworkService.getAll();
      const filtered = artistId
        ? data.filter((a) => a.artistId === artistId)
        : data;
      setArtworks(filtered);
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
  const createArtwork = useCallback(async (artworkData, imageFile) => {
    setIsLoading(true);
    try {
      const newArtwork = await artworkService.create(artworkData);
      // If image file provided, upload it
      if (imageFile) {
        try {
          await artworkService.uploadImage(newArtwork.id, imageFile);
        } catch (imgErr) {
          console.error('Image upload failed:', imgErr);
        }
      }

      await fetchArtworks();
      setIsLoading(false);
      return { success: true, artwork: newArtwork };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, [fetchArtworks]);

  // Update artwork
  const updateArtwork = useCallback(async (id, data, imageFile) => {
    setIsLoading(true);
    try {
      const updated = await artworkService.update(id, data);
      // If new image file, upload it
      if (imageFile) {
        try {
          await artworkService.uploadImage(id, imageFile);
        } catch (imgErr) {
          console.error('Image upload failed:', imgErr);
        }
      }
      await fetchArtworks();
      setIsLoading(false);
      return { success: true, artwork: updated };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, [fetchArtworks]);

  // Delete artwork
  const deleteArtwork = useCallback(async (id) => {
    setIsLoading(true);
    try {
      await artworkService.delete(id);
      setArtworks((prev) => prev.filter((a) => a.id !== id));
      setIsLoading(false);
      return { success: true };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, []);

  // Verify artwork (curator)
  const verifyArtwork = useCallback(async (id) => {
    try {
      const updated = await artworkService.verify(id);
      setArtworks((prev) => prev.map((a) => (a.id === id ? { ...a, ...updated } : a)));
      return { success: true, artwork: updated };
    } catch (err) {
      return { success: false, error: err.message };
    }
  }, []);

  // Unverify artwork (curator)
  const unverifyArtwork = useCallback(async (id) => {
    try {
      const updated = await artworkService.unverify(id);
      setArtworks((prev) => prev.map((a) => (a.id === id ? { ...a, ...updated } : a)));
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
