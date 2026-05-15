import { useMemo } from 'react';
import { useAuth } from '../../hooks/useAuth';
import { useArtworks } from '../../hooks/useArtworks';
import { useBids } from '../../hooks/useBids';
import Card, { CardBody } from '../../components/common/Card';
import { PageLoader } from '../../components/common/LoadingSpinner';
import { formatCurrency } from '../../utils/formatters';

export default function ArtistDashboard() {
  const { currentUser } = useAuth();
  const { artworks, isLoading } = useArtworks(currentUser?.id);

  const artworkIds = useMemo(() => artworks.map((a) => a.id), [artworks]);
  const { bids, totalBids } = useBids(artworkIds);

  const stats = useMemo(() => {
    const verified = artworks.filter((a) => a.status === 'verified').length;
    const pending = artworks.filter((a) => a.status === 'pending').length;
    const totalValue = artworks.reduce((sum, a) => sum + (a.starting_price || 0), 0);
    const highestBid = bids.length ? Math.max(...bids.map((b) => b.bid_amount)) : 0;
    return { total: artworks.length, verified, pending, totalValue, highestBid };
  }, [artworks, bids]);

  if (isLoading) return <PageLoader />;

  const statCards = [
    { label: 'Total Karya', value: stats.total, icon: '🎨', color: 'from-primary-600 to-primary-800' },
    { label: 'Terverifikasi', value: stats.verified, icon: '✅', color: 'from-emerald-600 to-emerald-800' },
    { label: 'Menunggu Review', value: stats.pending, icon: '⏳', color: 'from-amber-600 to-amber-800' },
    { label: 'Total Bid Masuk', value: totalBids, icon: '📊', color: 'from-blue-600 to-blue-800' },
  ];

  return (
    <div className="space-y-8 animate-fade-in">
      {/* Welcome Section */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-primary-900/50 via-surface-800/50 to-primary-950/50 border border-primary-700/20 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary-500/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="relative z-10">
          <h1 className="text-3xl font-bold font-serif text-surface-50 mb-2">
            Selamat Datang, {currentUser?.full_name} 👋
          </h1>
          <p className="text-surface-400 max-w-lg">
            Kelola karya seni Anda, pantau proses verifikasi, dan monitor bidding dari kolektor.
          </p>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 stagger-children">
        {statCards.map((stat) => (
          <Card key={stat.label} hover={false}>
            <CardBody className="flex items-center gap-4">
              <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${stat.color} flex items-center justify-center text-xl shadow-lg`}>
                {stat.icon}
              </div>
              <div>
                <p className="text-2xl font-bold text-surface-50">{stat.value}</p>
                <p className="text-xs text-surface-400">{stat.label}</p>
              </div>
            </CardBody>
          </Card>
        ))}
      </div>

      {/* Value Summary */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card hover={false}>
          <CardBody>
            <p className="text-sm text-surface-400 mb-1">Total Nilai Karya</p>
            <p className="text-2xl font-bold text-gradient">{formatCurrency(stats.totalValue)}</p>
          </CardBody>
        </Card>
        <Card hover={false}>
          <CardBody>
            <p className="text-sm text-surface-400 mb-1">Bid Tertinggi</p>
            <p className="text-2xl font-bold text-emerald-400">
              {stats.highestBid ? formatCurrency(stats.highestBid) : '-'}
            </p>
          </CardBody>
        </Card>
      </div>

      {/* Recent Activity */}
      <Card hover={false}>
        <CardBody>
          <h2 className="text-lg font-semibold text-surface-100 mb-4">Bid Terbaru</h2>
          {bids.length === 0 ? (
            <p className="text-surface-500 text-sm">Belum ada bid masuk.</p>
          ) : (
            <div className="space-y-3">
              {bids.slice(0, 5).map((bid) => {
                const artwork = artworks.find((a) => a.id === bid.artwork_id);
                return (
                  <div key={bid.id} className="flex items-center justify-between py-2 border-b border-surface-700/30 last:border-0">
                    <div>
                      <p className="text-sm text-surface-200">{bid.bidder_name}</p>
                      <p className="text-xs text-surface-500">pada &quot;{artwork?.title}&quot;</p>
                    </div>
                    <p className="text-sm font-semibold text-primary-400">{formatCurrency(bid.bid_amount)}</p>
                  </div>
                );
              })}
            </div>
          )}
        </CardBody>
      </Card>
    </div>
  );
}
