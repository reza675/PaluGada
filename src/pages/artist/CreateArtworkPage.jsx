import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { useArtworks } from '../../hooks/useArtworks';
import ArtworkForm from '../../components/artwork/ArtworkForm';
import Card, { CardBody, CardHeader } from '../../components/common/Card';

export default function CreateArtworkPage() {
  const { currentUser } = useAuth();
  const { createArtwork } = useArtworks(currentUser?.id);
  const navigate = useNavigate();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [successMsg, setSuccessMsg] = useState('');

  const handleSubmit = async (formData) => {
    setIsSubmitting(true);
    const result = await createArtwork({
      ...formData,
      artist_id: currentUser.id,
    });
    setIsSubmitting(false);
    if (result.success) {
      setSuccessMsg('Karya berhasil diupload! Menunggu verifikasi kurator.');
      setTimeout(() => navigate('/artist/artworks'), 1500);
    }
  };

  return (
    <div className="max-w-2xl mx-auto animate-fade-in">
      <div className="mb-6">
        <h1 className="text-2xl font-bold font-serif text-surface-50">Upload Karya Baru</h1>
        <p className="text-sm text-surface-400 mt-1">
          Isi detail karya seni Anda. Setelah diupload, kurator akan memverifikasi karya Anda.
        </p>
      </div>

      {successMsg && (
        <div className="mb-6 px-4 py-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-sm animate-fade-in">
          ✅ {successMsg}
        </div>
      )}

      <Card hover={false}>
        <CardHeader>
          <h2 className="text-lg font-semibold text-surface-100">Detail Karya</h2>
        </CardHeader>
        <CardBody>
          <ArtworkForm
            onSubmit={handleSubmit}
            onCancel={() => navigate('/artist/artworks')}
            isLoading={isSubmitting}
          />
        </CardBody>
      </Card>
    </div>
  );
}
