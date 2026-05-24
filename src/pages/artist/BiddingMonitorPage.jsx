import { useMemo } from 'react';
import { useAuth } from '../../hooks/useAuth';
import { useArtworks } from '../../hooks/useArtworks';
import { useBids } from '../../hooks/useBids';
import BidTable from '../../components/bid/BidTable';
import Card, { CardBody, CardHeader } from '../../components/common/Card';
import { PageLoader } from '../../components/common/LoadingSpinner';
import { formatCurrency } from '../../utils/formatters';

export default function BiddingMonitorPage() {
  const { currentUser } = useAuth();
  const { artworks, isLoading: artLoading } = useArtworks(currentUser?.id);

  const artworkIds = useMemo(() => artworks.map((a) => a.id), [artworks]);
  const { bids, isLoading: bidLoading, totalBids, activeBids } = useBids(artworkIds);

  const isLoading = artLoading || bidLoading;

  const totalBidValue = useMemo(
    () => bids.reduce((sum, b) => sum + b.amount, 0),
    [bids]
  );
  const highestBid = useMemo(
    () => (bids.length ? Math.max(...bids.map((b) => b.amount)) : 0),
    [bids]
  );

  if (isLoading) return <PageLoader />;

  return (
    <div className="space-y-6 lg:space-y-8 animate-fade-in">
      {/* Page Header */}
      <div>
        <h1 className="text-2xl sm:text-3xl font-bold font-serif text-surface-50">Monitor Bidding</h1>
        <p className="text-sm text-surface-400 mt-1.5">
          Pantau semua bid yang masuk pada karya seni Anda
        </p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 sm:gap-4">
        <Card hover={false}>
          <CardBody className="text-center py-5 sm:py-6">
            <p className="text-3xl sm:text-4xl font-bold text-surface-50">{totalBids}</p>
            <p className="text-xs sm:text-sm text-surface-400 mt-1.5 font-medium">Total Bid</p>
          </CardBody>
        </Card>
        <Card hover={false}>
          <CardBody className="text-center py-5 sm:py-6">
            <p className="text-3xl sm:text-4xl font-bold text-emerald-400">{activeBids}</p>
            <p className="text-xs sm:text-sm text-surface-400 mt-1.5 font-medium">Bid Aktif</p>
          </CardBody>
        </Card>
        <Card hover={false}>
          <CardBody className="text-center py-5 sm:py-6">
            <p className="text-2xl sm:text-3xl font-bold text-primary-400 tabular-nums">{formatCurrency(highestBid)}</p>
            <p className="text-xs sm:text-sm text-surface-400 mt-1.5 font-medium">Bid Tertinggi</p>
          </CardBody>
        </Card>
      </div>

      {/* Bid Table */}
      <Card hover={false}>
        <CardHeader>
          <h2 className="text-lg font-semibold text-surface-100">Daftar Bid</h2>
        </CardHeader>
        <CardBody className="p-0 sm:p-0">
          <div className="px-1 sm:px-2 pb-4 sm:pb-5">
            <BidTable bids={bids} artworks={artworks} />
          </div>
        </CardBody>
      </Card>
    </div>
  );
}
