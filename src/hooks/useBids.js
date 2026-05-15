import { useState, useEffect, useCallback } from 'react';
import { bidService } from '../services/bidService';

/**
 * Custom hook for reading bids
 * Artists can monitor incoming bids on their artworks
 */
export function useBids(artworkIds = []) {
  const [bids, setBids] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchBids = useCallback(async () => {
    if (!artworkIds.length) {
      setBids([]);
      setIsLoading(false);
      return;
    }
    setIsLoading(true);
    setError(null);
    try {
      const data = await bidService.getByArtistArtworks(artworkIds);
      setBids(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }, [artworkIds]);

  useEffect(() => {
    fetchBids();
  }, [fetchBids]);

  // Get bids for a specific artwork
  const getBidsForArtwork = useCallback(
    (artworkId) => {
      return bids.filter((b) => b.artwork_id === Number(artworkId));
    },
    [bids]
  );

  // Get highest bid for an artwork
  const getHighestBid = useCallback(
    (artworkId) => {
      const artworkBids = bids.filter((b) => b.artwork_id === Number(artworkId));
      if (!artworkBids.length) return null;
      return artworkBids.reduce((max, b) => (b.bid_amount > max.bid_amount ? b : max));
    },
    [bids]
  );

  // Get total bid count
  const totalBids = bids.length;

  // Get total active bids
  const activeBids = bids.filter((b) => b.status === 'active').length;

  return {
    bids,
    isLoading,
    error,
    fetchBids,
    getBidsForArtwork,
    getHighestBid,
    totalBids,
    activeBids,
  };
}
