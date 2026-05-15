import { useState, useMemo } from 'react';
import { useArtworks } from '../../hooks/useArtworks';
import { useAuth } from '../../hooks/useAuth';
import Card, { CardBody } from '../../components/common/Card';
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
    <div className="space-y-6 animate-fade-in">
      {/* Header */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-primary-900/50 via-surface-800/50 to-primary-950/50 border border-primary-700/20 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary-500/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="relative z-10">
          <h1 className="text-3xl font-bold font-serif text-surface-50 mb-2">
            Dashboard Kurator 🔍
          </h1>
          <p className="text-surface-400">
            Verifikasi karya seni yang masuk dari para seniman.
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 stagger-children">
        {[
          { label: 'Total Karya', value: stats.total, icon: '🖼️' },
          { label: 'Menunggu', value: stats.pending, icon: '⏳' },
          { label: 'Terverifikasi', value: stats.verified, icon: '✅' },
          { label: 'Ditolak', value: stats.rejected, icon: '❌' },
        ].map((s) => (
          <Card key={s.label} hover={false}>
            <CardBody className="text-center py-5">
              <p className="text-2xl mb-1">{s.icon}</p>
              <p className="text-2xl font-bold text-surface-50">{s.value}</p>
              <p className="text-xs text-surface-400">{s.label}</p>
            </CardBody>
          </Card>
        ))}
      </div>

      {successMsg && (
        <div className="px-4 py-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-sm animate-fade-in">
          ✅ {successMsg}
        </div>
      )}

      {/* Filter */}
      <div className="flex gap-2 flex-wrap">
        {filters.map((f) => (
          <button
            key={f.key}
            onClick={() => setFilter(f.key)}
            className={`px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 ${
              filter === f.key
                ? 'bg-primary-600/20 text-primary-400 border border-primary-600/30'
                : 'text-surface-400 hover:bg-surface-700/50 border border-transparent'
            }`}
          >
            {f.label} ({f.count})
          </button>
        ))}
      </div>

      {/* Artwork List */}
      <div className="space-y-3 stagger-children">
        {filtered.length === 0 ? (
          <div className="text-center py-16 text-surface-500">Tidak ada karya untuk ditampilkan.</div>
        ) : (
          filtered.map((artwork) => (
            <Card key={artwork.id} className="cursor-pointer" onClick={() => setSelectedArtwork(artwork)}>
              <CardBody className="flex flex-col sm:flex-row items-start sm:items-center gap-4">
                <img
                  src={artwork.image_url}
                  alt={artwork.title}
                  className="w-full sm:w-24 h-32 sm:h-20 rounded-xl object-cover flex-shrink-0"
                />
                <div className="flex-1 min-w-0">
                  <h3 className="text-base font-semibold text-surface-100 truncate">{artwork.title}</h3>
                  <p className="text-sm text-surface-400 mt-0.5">
                    oleh <span className="text-primary-400">{getArtistName(artwork.artist_id)}</span>
                    <span className="mx-2">·</span>
                    {getCategoryName(artwork.category_id)}
                  </p>
                  <p className="text-sm text-surface-500 mt-1">{formatCurrency(artwork.starting_price)}</p>
                </div>
                <div className="flex items-center gap-3 flex-shrink-0">
                  <StatusBadge status={artwork.status} />
                  <svg className="w-5 h-5 text-surface-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
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
              className="w-full h-64 object-cover rounded-xl"
            />
            <div>
              <div className="flex items-start justify-between gap-3">
                <h3 className="text-xl font-bold text-surface-50">{selectedArtwork.title}</h3>
                <StatusBadge status={selectedArtwork.status} />
              </div>
              <p className="text-sm text-primary-400 mt-1">oleh {getArtistName(selectedArtwork.artist_id)}</p>
            </div>
            <p className="text-surface-300 text-sm leading-relaxed">{selectedArtwork.description}</p>

            <div className="grid grid-cols-2 gap-4 text-sm">
              <div><span className="text-surface-500">Kategori:</span> <span className="text-surface-200 ml-1">{getCategoryName(selectedArtwork.category_id)}</span></div>
              <div><span className="text-surface-500">Medium:</span> <span className="text-surface-200 ml-1">{selectedArtwork.medium}</span></div>
              <div><span className="text-surface-500">Dimensi:</span> <span className="text-surface-200 ml-1">{selectedArtwork.dimensions || '-'}</span></div>
              <div><span className="text-surface-500">Tahun:</span> <span className="text-surface-200 ml-1">{selectedArtwork.year_created}</span></div>
              <div><span className="text-surface-500">Harga Awal:</span> <span className="text-primary-400 font-semibold ml-1">{formatCurrency(selectedArtwork.starting_price)}</span></div>
              <div><span className="text-surface-500">Diupload:</span> <span className="text-surface-200 ml-1">{formatDate(selectedArtwork.created_at)}</span></div>
            </div>

            <div className="flex gap-3 pt-4 border-t border-surface-600/30">
              {selectedArtwork.status !== 'verified' && (
                <Button
                  variant="success"
                  fullWidth
                  loading={actionLoading}
                  onClick={() => handleVerify(selectedArtwork)}
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
