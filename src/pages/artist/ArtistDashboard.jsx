import { useMemo } from 'react';
import { useAuth } from '../../hooks/useAuth';
import { useArtworks } from '../../hooks/useArtworks';
import { useBids } from '../../hooks/useBids';
import Card, { CardBody, CardHeader } from '../../components/common/Card';
import { PageLoader } from '../../components/common/LoadingSpinner';
import { formatCurrency } from '../../utils/formatters';

export default function ArtistDashboard() {
  const { currentUser } = useAuth();
  const { artworks, isLoading } = useArtworks(currentUser?.id);

  const artworkIds = useMemo(() => artworks.map((a) => a.id), [artworks]);
  const { bids, totalBids } = useBids(artworkIds);

  const stats = useMemo(() => {
    const verified = artworks.filter((a) => a.verification_status === 'VERIFIED').length;
    const unverified = artworks.filter((a) => a.verification_status === 'UNVERIFIED').length;
    const totalValue = artworks.reduce((sum, a) => sum + (a.min_bid_ammount || 0), 0);
    const highestBid = bids.length ? Math.max(...bids.map((b) => b.amount)) : 0;
    return { total: artworks.length, verified, unverified, totalValue, highestBid };
  }, [artworks, bids]);

  if (isLoading) return <PageLoader />;

  const statCards = [
    { label: 'Total Karya', value: stats.total, icon: '🎨', color: 'from-primary-600 to-primary-800' },
    { label: 'Terverifikasi', value: stats.verified, icon: '✅', color: 'from-emerald-600 to-emerald-800' },
    { label: 'Menunggu Review', value: stats.unverified, icon: '⏳', color: 'from-amber-600 to-amber-800' },
    { label: 'Total Bid Masuk', value: totalBids, icon: '📊', color: 'from-blue-600 to-blue-800' },
  ];

  return (
    <div className="space-y-6 lg:space-y-8 animate-fade-in">
      {/* Welcome Section */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-primary-900/50 via-surface-800/50 to-primary-950/50 border border-primary-700/20 p-6 sm:p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary-500/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2 pointer-events-none" />
        <div className="relative z-10">
          <h1 className="text-2xl sm:text-3xl font-bold font-serif text-surface-50 mb-2">
            Selamat Datang, {currentUser?.full_name || currentUser?.username} 
          </h1>
          <p className="text-surface-400 max-w-lg text-sm sm:text-base">
            Kelola karya seni Anda, pantau proses verifikasi, dan monitor bidding dari kolektor.
          </p>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4 stagger-children">
        {statCards.map((stat) => (
          <Card key={stat.label} hover={false}>
            <CardBody className="flex items-center gap-3 sm:gap-4">
              <div className={`w-11 h-11 sm:w-12 sm:h-12 rounded-xl bg-gradient-to-br ${stat.color} flex items-center justify-center text-lg sm:text-xl shadow-lg flex-shrink-0`}>
                {stat.icon}
              </div>
              <div className="min-w-0">
                <p className="text-xl sm:text-2xl font-bold text-surface-50 leading-tight">{stat.value}</p>
                <p className="text-xs text-surface-400 mt-0.5 truncate">{stat.label}</p>
              </div>
            </CardBody>
          </Card>
        ))}
      </div>

      {/* Value Summary */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 sm:gap-4">
        <Card hover={false}>
          <CardBody>
            <p className="text-sm text-surface-400 mb-1.5">Total Nilai Karya</p>
            <p className="text-xl sm:text-2xl font-bold text-gradient">{formatCurrency(stats.totalValue)}</p>
          </CardBody>
        </Card>
        <Card hover={false}>
          <CardBody>
            <p className="text-sm text-surface-400 mb-1.5">Bid Tertinggi</p>
            <p className="text-xl sm:text-2xl font-bold text-emerald-400">
              {stats.highestBid ? formatCurrency(stats.highestBid) : '-'}
            </p>
          </CardBody>
        </Card>
      </div>

      {/* Recent Activity */}
      <Card hover={false}>
        <CardHeader>
          <h2 className="text-lg font-semibold text-surface-100">Bid Terbaru</h2>
        </CardHeader>
        <CardBody>
          {bids.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-8 text-center">
              <div className="w-14 h-14 rounded-2xl bg-surface-800/50 flex items-center justify-center mb-3">
                <svg className="w-7 h-7 text-surface-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <p className="text-surface-500 text-sm">Belum ada bid masuk.</p>
            </div>
          ) : (
            <div className="divide-y divide-surface-700/30">
              {bids.slice(0, 5).map((bid) => {
                const artwork = artworks.find((a) => a.id === bid.artworksId);
                return (
                  <div key={bid.id} className="flex items-center justify-between py-3.5 first:pt-0 last:pb-0">
                    <div className="min-w-0 mr-4">
                      <p className="text-sm font-medium text-surface-100">
                        {bid.bidBy?.username || `Kolektor #${(bid.bidById || bid.id).slice(-6)}`}
                      </p>
                      <p className="text-xs text-surface-500 mt-0.5 truncate">
                        pada &quot;{artwork?.nama_karya || 'Unknown'}&quot;
                      </p>
                    </div>
                    <p className="text-sm font-semibold text-primary-400 flex-shrink-0 tabular-nums">
                      {formatCurrency(bid.amount)}
                    </p>
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
