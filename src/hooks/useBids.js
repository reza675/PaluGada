import { useState, useEffect, useCallback } from 'react';
import { bidService } from '../services/bidService';

export function useBids(artworkIds = []) {
  const [bids, setBids] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchBids = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const allBids = await bidService.getAll();

      const highestPerArtwork = {};
      allBids.forEach((bid) => {
        if (bid.status !== 'FAILED') {
          if (!highestPerArtwork[bid.artworksId] || bid.amount > highestPerArtwork[bid.artworksId].amount) {
            highestPerArtwork[bid.artworksId] = bid;
          }
        }
      });

      allBids.forEach((bid) => {
        if (bid.status !== 'FAILED') {
          const isHighest = highestPerArtwork[bid.artworksId]?.id === bid.id;
          if (isHighest && (bid.status === 'OUTBID' || bid.status === 'OPEN')) {
            bid.status = 'TERTINGGI';
          } else if (!isHighest && bid.status === 'TERTINGGI') {
            bid.status = 'OUTBID';
          }
        }
      });

      if (artworkIds.length > 0) {
        const filtered = allBids.filter((b) => artworkIds.includes(b.artworksId));
        filtered.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));
        setBids(filtered);
      } else {
        setBids(allBids);
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }, [JSON.stringify(artworkIds)]); 

  useEffect(() => {
    if (artworkIds.length === 0) {
      setBids([]);
      setIsLoading(false);
      return;
    }
    fetchBids();
  }, [fetchBids, artworkIds.length]);

  // Get bids for a specific artwork
  const getBidsForArtwork = useCallback(
    (artworkId) => {
      return bids.filter((b) => b.artworksId === artworkId);
    },
    [bids]
  );

  // Get highest bid for an artwork
  const getHighestBid = useCallback(
    (artworkId) => {
      const artworkBids = bids.filter((b) => b.artworksId === artworkId);
      if (!artworkBids.length) return null;
      return artworkBids.reduce((max, b) => (b.amount > max.amount ? b : max));
    },
    [bids]
  );

  // Get total bid count
  const totalBids = bids.length;

  // Get active bids (OPEN or TERTINGGI)
  const activeBids = bids.filter(
    (b) => b.status === 'OPEN' || b.status === 'TERTINGGI'
  ).length;

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
