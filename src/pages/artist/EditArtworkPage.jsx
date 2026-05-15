import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { artworkService } from '../../services/artworkService';
import ArtworkForm from '../../components/artwork/ArtworkForm';
import Card, { CardBody, CardHeader } from '../../components/common/Card';
import { PageLoader } from '../../components/common/LoadingSpinner';

export default function EditArtworkPage() {
  const { id } = useParams();
  const { currentUser } = useAuth();
  const navigate = useNavigate();
  const [artwork, setArtwork] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [successMsg, setSuccessMsg] = useState('');

  useEffect(() => {
    const fetchArtwork = async () => {
      try {
        const data = await artworkService.getById(id);
        if (data.artist_id !== currentUser?.id) {
          navigate('/artist/artworks');
          return;
        }
        setArtwork(data);
      } catch {
        navigate('/artist/artworks');
      } finally {
        setIsLoading(false);
      }
    };
    fetchArtwork();
  }, [id, currentUser, navigate]);

  const handleSubmit = async (formData) => {
    setIsSubmitting(true);
    try {
      await artworkService.update(id, formData);
      setSuccessMsg('Karya berhasil diperbarui!');
      setTimeout(() => navigate('/artist/artworks'), 1500);
    } catch (err) {
      console.error(err);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading) return <PageLoader />;

  return (
    <div className="max-w-2xl mx-auto animate-fade-in">
      <div className="mb-6">
        <h1 className="text-2xl font-bold font-serif text-surface-50">Edit Karya</h1>
        <p className="text-sm text-surface-400 mt-1">Perbarui detail karya seni Anda</p>
      </div>

      {successMsg && (
        <div className="mb-6 px-4 py-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-sm animate-fade-in">
          ✅ {successMsg}
        </div>
      )}

      <Card hover={false}>
        <CardHeader>
          <h2 className="text-lg font-semibold text-surface-100">Edit Detail Karya</h2>
        </CardHeader>
        <CardBody>
          <ArtworkForm
            initialData={artwork}
            onSubmit={handleSubmit}
            onCancel={() => navigate('/artist/artworks')}
            isLoading={isSubmitting}
          />
        </CardBody>
      </Card>
    </div>
  );
}
