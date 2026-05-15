import { useMemo } from 'react';
import { useAuth } from '../../hooks/useAuth';
import { useArtworks } from '../../hooks/useArtworks';
import { useBids } from '../../hooks/useBids';
import BidTable from '../../components/bid/BidTable';
import Card, { CardBody } from '../../components/common/Card';
import { PageLoader } from '../../components/common/LoadingSpinner';
import { formatCurrency } from '../../utils/formatters';

export default function BiddingMonitorPage() {
  const { currentUser } = useAuth();
  const { artworks, isLoading: artLoading } = useArtworks(currentUser?.id);

  const artworkIds = useMemo(() => artworks.map((a) => a.id), [artworks]);
  const { bids, isLoading: bidLoading, totalBids, activeBids } = useBids(artworkIds);

  const isLoading = artLoading || bidLoading;

  const totalBidValue = useMemo(
    () => bids.reduce((sum, b) => sum + b.bid_amount, 0),
    [bids]
  );
  const highestBid = useMemo(
    () => (bids.length ? Math.max(...bids.map((b) => b.bid_amount)) : 0),
    [bids]
  );

  if (isLoading) return <PageLoader />;

  return (
    <div className="space-y-6 animate-fade-in">
      <div>
        <h1 className="text-2xl font-bold font-serif text-surface-50">Monitor Bidding</h1>
        <p className="text-sm text-surface-400 mt-1">
          Pantau semua bid yang masuk pada karya seni Anda
        </p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <Card hover={false}>
          <CardBody className="text-center">
            <p className="text-3xl font-bold text-surface-50">{totalBids}</p>
            <p className="text-xs text-surface-400 mt-1">Total Bid</p>
          </CardBody>
        </Card>
        <Card hover={false}>
          <CardBody className="text-center">
            <p className="text-3xl font-bold text-emerald-400">{activeBids}</p>
            <p className="text-xs text-surface-400 mt-1">Bid Aktif</p>
          </CardBody>
        </Card>
        <Card hover={false}>
          <CardBody className="text-center">
            <p className="text-3xl font-bold text-primary-400">{formatCurrency(highestBid)}</p>
            <p className="text-xs text-surface-400 mt-1">Bid Tertinggi</p>
          </CardBody>
        </Card>
      </div>

      {/* Bid Table */}
      <Card hover={false}>
        <CardBody>
          <h2 className="text-lg font-semibold text-surface-100 mb-4">Daftar Bid</h2>
          <BidTable bids={bids} artworks={artworks} />
        </CardBody>
      </Card>
    </div>
  );
}
