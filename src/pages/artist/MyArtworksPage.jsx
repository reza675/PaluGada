import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { useArtworks } from '../../hooks/useArtworks';
import ArtworkGrid from '../../components/artwork/ArtworkGrid';
import Button from '../../components/common/Button';
import Modal from '../../components/common/Modal';
import { PageLoader } from '../../components/common/LoadingSpinner';
import { ARTWORK_STATUS } from '../../utils/constants';

export default function MyArtworksPage() {
  const { currentUser } = useAuth();
  const { artworks, isLoading, deleteArtwork } = useArtworks(currentUser?.id);
  const navigate = useNavigate();
  const [filter, setFilter] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ open: false, artwork: null });
  const [deleting, setDeleting] = useState(false);

  const filtered = useMemo(() => {
    if (filter === 'all') return artworks;
    return artworks.filter((a) => a.status === filter);
  }, [artworks, filter]);

  const handleEdit = (artwork) => {
    navigate(`/artist/artworks/${artwork.id}/edit`);
  };

  const handleDeleteConfirm = async () => {
    setDeleting(true);
    await deleteArtwork(deleteModal.artwork.id);
    setDeleting(false);
    setDeleteModal({ open: false, artwork: null });
  };

  if (isLoading) return <PageLoader />;

  const filters = [
    { key: 'all', label: 'Semua' },
    { key: ARTWORK_STATUS.PENDING, label: 'Pending' },
    { key: ARTWORK_STATUS.VERIFIED, label: 'Verified' },
    { key: ARTWORK_STATUS.REJECTED, label: 'Rejected' },
  ];

  return (
    <div className="space-y-6 lg:space-y-8 animate-fade-in">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-bold font-serif text-surface-50">Karya Saya</h1>
          <p className="text-sm text-surface-400 mt-1.5">Kelola semua karya seni yang telah Anda upload</p>
        </div>
        <Button onClick={() => navigate('/artist/artworks/create')} id="upload-new-artwork">
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
          </svg>
          Upload Karya Baru
        </Button>
      </div>

      {/* Filter */}
      <div className="flex gap-2 flex-wrap" id="artwork-filters">
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
            {f.label}
            {f.key === 'all' && ` (${artworks.length})`}
          </button>
        ))}
      </div>

      {/* Grid */}
      <ArtworkGrid
        artworks={filtered}
        showActions
        onEdit={handleEdit}
        onDelete={(artwork) => setDeleteModal({ open: true, artwork })}
        emptyMessage="Belum ada karya. Mulai upload karya pertama Anda!"
      />

      {/* Delete Modal */}
      <Modal
        isOpen={deleteModal.open}
        onClose={() => setDeleteModal({ open: false, artwork: null })}
        title="Hapus Karya"
        size="sm"
      >
        <div className="space-y-5">
          <p className="text-surface-300 leading-relaxed">
            Apakah Anda yakin ingin menghapus <strong className="text-surface-100">&quot;{deleteModal.artwork?.title}&quot;</strong>? 
            Tindakan ini tidak dapat dibatalkan.
          </p>
          <div className="flex gap-3">
            <Button variant="danger" fullWidth loading={deleting} onClick={handleDeleteConfirm} id="confirm-delete">
              Ya, Hapus
            </Button>
            <Button variant="secondary" fullWidth onClick={() => setDeleteModal({ open: false, artwork: null })}>
              Batal
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
