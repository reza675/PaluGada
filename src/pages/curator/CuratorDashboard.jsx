import { useState, useMemo } from 'react';
import { useArtworks } from '../../hooks/useArtworks';
import { useAuth } from '../../hooks/useAuth';
import Card, { CardBody, CardHeader } from '../../components/common/Card';
import StatusBadge from '../../components/common/StatusBadge';
import Button from '../../components/common/Button';
import Modal from '../../components/common/Modal';
import { PageLoader } from '../../components/common/LoadingSpinner';
import { formatCurrency, formatDate } from '../../utils/formatters';
import usersData from '../../data/users';
import categories from '../../data/categories';

export default function CuratorDashboard() {
  const { currentUser } = useAuth();
  const { artworks, isLoading, verifyArtwork, unverifyArtwork } = useArtworks();
  const [filter, setFilter] = useState('all');
  const [selectedArtwork, setSelectedArtwork] = useState(null);
  const [actionLoading, setActionLoading] = useState(false);
  const [successMsg, setSuccessMsg] = useState('');

  const filtered = useMemo(() => {
    if (filter === 'all') return artworks;
    return artworks.filter((a) => a.status === filter);
  }, [artworks, filter]);

  const stats = useMemo(() => ({
    total: artworks.length,
    pending: artworks.filter((a) => a.status === 'pending').length,
    verified: artworks.filter((a) => a.status === 'verified').length,
    rejected: artworks.filter((a) => a.status === 'rejected').length,
  }), [artworks]);

  const getArtistName = (artistId) => {
    const user = usersData.find((u) => u.id === artistId);
    return user?.full_name || 'Unknown';
  };

  const getCategoryName = (catId) => {
    const cat = categories.find((c) => c.id === catId);
    return cat?.name || '-';
  };

  const handleVerify = async (artwork) => {
    setActionLoading(true);
    await verifyArtwork(artwork.id, currentUser.id);
    setActionLoading(false);
    setSelectedArtwork(null);
    setSuccessMsg(`"${artwork.title}" berhasil diverifikasi!`);
    setTimeout(() => setSuccessMsg(''), 3000);
  };

  const handleUnverify = async (artwork) => {
    setActionLoading(true);
    await unverifyArtwork(artwork.id, currentUser.id);
    setActionLoading(false);
    setSelectedArtwork(null);
    setSuccessMsg(`"${artwork.title}" ditolak.`);
    setTimeout(() => setSuccessMsg(''), 3000);
  };

  if (isLoading) return <PageLoader />;

  const filters = [
    { key: 'all', label: 'Semua', count: stats.total },
    { key: 'pending', label: 'Pending', count: stats.pending },
    { key: 'verified', label: 'Verified', count: stats.verified },
    { key: 'rejected', label: 'Rejected', count: stats.rejected },
  ];

  return (
    <div className="space-y-6 lg:space-y-8 animate-fade-in">
      {/* Header */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-primary-900/50 via-surface-800/50 to-primary-950/50 border border-primary-700/20 p-6 sm:p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary-500/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2 pointer-events-none" />
        <div className="relative z-10">
          <h1 className="text-2xl sm:text-3xl font-bold font-serif text-surface-50 mb-2">
            Dashboard Kurator 🔍
          </h1>
          <p className="text-surface-400 text-sm sm:text-base">
            Verifikasi karya seni yang masuk dari para seniman.
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 sm:gap-4 stagger-children">
        {[
          { label: 'Total Karya', value: stats.total, icon: '🖼️' },
          { label: 'Menunggu', value: stats.pending, icon: '⏳' },
          { label: 'Terverifikasi', value: stats.verified, icon: '✅' },
          { label: 'Ditolak', value: stats.rejected, icon: '❌' },
        ].map((s) => (
          <Card key={s.label} hover={false}>
            <CardBody className="text-center py-4 sm:py-5">
              <p className="text-xl sm:text-2xl mb-1">{s.icon}</p>
              <p className="text-xl sm:text-2xl font-bold text-surface-50">{s.value}</p>
              <p className="text-xs text-surface-400 mt-0.5">{s.label}</p>
            </CardBody>
          </Card>
        ))}
      </div>

      {/* Success Message */}
      {successMsg && (
        <div className="px-4 py-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-sm animate-fade-in flex items-center gap-2">
          <svg className="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
          </svg>
          {successMsg}
        </div>
      )}

      {/* Filter */}
      <div className="flex gap-2 flex-wrap" id="curator-filters">
        {filters.map((f) => (
          <button
            key={f.key}
            onClick={() => setFilter(f.key)}
            className={`px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 active:scale-95 ${
              filter === f.key
                ? 'bg-primary-600/20 text-primary-400 border border-primary-600/30 shadow-sm'
                : 'text-surface-400 hover:bg-surface-700/50 hover:text-surface-200 border border-transparent'
            }`}
          >
            {f.label} ({f.count})
          </button>
        ))}
      </div>

      {/* Artwork List */}
      <div className="space-y-3 sm:space-y-4 stagger-children">
        {filtered.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20 text-center">
            <div className="w-16 h-16 rounded-2xl bg-surface-800/50 flex items-center justify-center mb-4">
              <svg className="w-8 h-8 text-surface-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <p className="text-surface-400 text-sm">Tidak ada karya untuk ditampilkan.</p>
          </div>
        ) : (
          filtered.map((artwork) => (
            <Card key={artwork.id} className="cursor-pointer" onClick={() => setSelectedArtwork(artwork)} id={`curator-artwork-${artwork.id}`}>
              <CardBody className="flex flex-col sm:flex-row items-start sm:items-center gap-4">
                <img
                  src={artwork.image_url}
                  alt={artwork.title}
                  className="w-full sm:w-24 h-36 sm:h-20 rounded-xl object-cover flex-shrink-0"
                />
                <div className="flex-1 min-w-0">
                  <h3 className="text-base font-semibold text-surface-100 truncate">{artwork.title}</h3>
                  <p className="text-sm text-surface-400 mt-1">
                    oleh <span className="text-primary-400 font-medium">{getArtistName(artwork.artist_id)}</span>
                    <span className="mx-2 text-surface-600">·</span>
                    <span className="text-surface-500">{getCategoryName(artwork.category_id)}</span>
                  </p>
                  <p className="text-sm font-semibold text-primary-400 mt-1 tabular-nums">{formatCurrency(artwork.starting_price)}</p>
                </div>
                <div className="flex items-center gap-3 flex-shrink-0 sm:self-center">
                  <StatusBadge status={artwork.status} />
                  <svg className="w-5 h-5 text-surface-600 hidden sm:block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                  </svg>
                </div>
              </CardBody>
            </Card>
          ))
        )}
      </div>

      {/* Detail Modal */}
      <Modal
        isOpen={!!selectedArtwork}
        onClose={() => setSelectedArtwork(null)}
        title="Detail Karya Seni"
        size="lg"
      >
        {selectedArtwork && (
          <div className="space-y-5">
            <img
              src={selectedArtwork.image_url}
              alt={selectedArtwork.title}
              className="w-full h-48 sm:h-64 object-cover rounded-xl"
            />
            <div>
              <div className="flex items-start justify-between gap-3 flex-wrap">
                <h3 className="text-xl font-bold text-surface-50">{selectedArtwork.title}</h3>
                <StatusBadge status={selectedArtwork.status} />
              </div>
              <p className="text-sm text-primary-400 mt-1.5 font-medium">oleh {getArtistName(selectedArtwork.artist_id)}</p>
            </div>
            <p className="text-surface-300 text-sm leading-relaxed">{selectedArtwork.description}</p>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-sm">
              <div className="flex justify-between sm:block py-2 sm:py-0 border-b sm:border-0 border-surface-700/30">
                <span className="text-surface-500">Kategori</span>
                <span className="text-surface-200 sm:ml-2 font-medium">{getCategoryName(selectedArtwork.category_id)}</span>
              </div>
              <div className="flex justify-between sm:block py-2 sm:py-0 border-b sm:border-0 border-surface-700/30">
                <span className="text-surface-500">Medium</span>
                <span className="text-surface-200 sm:ml-2 font-medium">{selectedArtwork.medium}</span>
              </div>
              <div className="flex justify-between sm:block py-2 sm:py-0 border-b sm:border-0 border-surface-700/30">
                <span className="text-surface-500">Dimensi</span>
                <span className="text-surface-200 sm:ml-2 font-medium">{selectedArtwork.dimensions || '-'}</span>
              </div>
              <div className="flex justify-between sm:block py-2 sm:py-0 border-b sm:border-0 border-surface-700/30">
                <span className="text-surface-500">Tahun</span>
                <span className="text-surface-200 sm:ml-2 font-medium">{selectedArtwork.year_created}</span>
              </div>
              <div className="flex justify-between sm:block py-2 sm:py-0 border-b sm:border-0 border-surface-700/30">
                <span className="text-surface-500">Harga Awal</span>
                <span className="text-primary-400 font-semibold sm:ml-2">{formatCurrency(selectedArtwork.starting_price)}</span>
              </div>
              <div className="flex justify-between sm:block py-2 sm:py-0">
                <span className="text-surface-500">Diupload</span>
                <span className="text-surface-200 sm:ml-2 font-medium">{formatDate(selectedArtwork.created_at)}</span>
              </div>
            </div>

            <div className="flex gap-3 pt-4 border-t border-surface-600/30">
              {selectedArtwork.status !== 'verified' && (
                <Button
                  variant="success"
                  fullWidth
                  loading={actionLoading}
                  onClick={() => handleVerify(selectedArtwork)}
                  id="verify-artwork"
                >
                  ✅ Verifikasi Karya
                </Button>
              )}
              {selectedArtwork.status !== 'rejected' && (
                <Button
                  variant="danger"
                  fullWidth
                  loading={actionLoading}
                  onClick={() => handleUnverify(selectedArtwork)}
                  id="reject-artwork"
                >
                  ❌ Tolak Karya
                </Button>
              )}
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}
