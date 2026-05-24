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
  const [errorMsg, setErrorMsg] = useState('');

  const handleSubmit = async (formData, imageFile) => {
    setIsSubmitting(true);
    setErrorMsg('');
    const result = await createArtwork(formData, imageFile);
    setIsSubmitting(false);
    if (result.success) {
      setSuccessMsg('Karya berhasil diupload! Menunggu verifikasi kurator.');
      setTimeout(() => navigate('/artist/artworks'), 1500);
    } else {
      setErrorMsg(result.error || 'Gagal membuat karya.');
    }
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6 animate-fade-in">
      {/* Page Header */}
      <div>
        <h1 className="text-2xl sm:text-3xl font-bold font-serif text-surface-50">Upload Karya Baru</h1>
        <p className="text-sm text-surface-400 mt-1.5">
          Isi detail karya seni Anda. Setelah diupload, kurator akan memverifikasi karya Anda.
        </p>
      </div>

      {successMsg && (
        <div className="px-4 py-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-sm animate-fade-in flex items-center gap-2">
          <svg className="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
          </svg>
          {successMsg}
        </div>
      )}

      {errorMsg && (
        <div className="px-4 py-3 rounded-xl bg-red-500/10 border border-red-500/30 text-red-400 text-sm animate-fade-in flex items-center gap-2">
          <svg className="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
          {errorMsg}
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
