import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import Input from '../../components/common/Input';
import Button from '../../components/common/Button';
import Card, { CardBody, CardHeader } from '../../components/common/Card';
import Modal from '../../components/common/Modal';

export default function AccountSettingsPage() {
  const { currentUser, updateAccount, deleteAccount, isLoading } = useAuth();
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    full_name: currentUser?.full_name || '',
    username: currentUser?.username || '',
    email: currentUser?.email || '',
    bio: currentUser?.bio || '',
  });
  const [successMsg, setSuccessMsg] = useState('');
  const [deleteModalOpen, setDeleteModalOpen] = useState(false);

  const handleChange = (field) => (e) => {
    setFormData((p) => ({ ...p, [field]: e.target.value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const result = await updateAccount(formData);
    if (result.success) {
      setSuccessMsg('Profil berhasil diperbarui!');
      setTimeout(() => setSuccessMsg(''), 3000);
    }
  };

  const handleDeleteAccount = async () => {
    await deleteAccount();
    navigate('/login');
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6 lg:space-y-8 animate-fade-in">
      {/* Page Header */}
      <div>
        <h1 className="text-2xl sm:text-3xl font-bold font-serif text-surface-50">Pengaturan Akun</h1>
        <p className="text-sm text-surface-400 mt-1.5">Kelola informasi profil Anda</p>
      </div>

      {successMsg && (
        <div className="px-4 py-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-sm animate-fade-in flex items-center gap-2">
          <svg className="w-4 h-4 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
          </svg>
          {successMsg}
        </div>
      )}

      {/* Profile Info */}
      <Card hover={false}>
        <CardHeader>
          <div className="flex items-center gap-4">
            <img
              src={currentUser?.avatar_url}
              alt={currentUser?.full_name}
              className="w-14 h-14 sm:w-16 sm:h-16 rounded-xl object-cover border-2 border-primary-600/30 shadow-lg"
            />
            <div className="min-w-0">
              <h2 className="text-lg font-semibold text-surface-100 truncate">{currentUser?.full_name}</h2>
              <p className="text-sm text-primary-400 mt-0.5">@{currentUser?.username}</p>
            </div>
          </div>
        </CardHeader>
        <CardBody>
          <form onSubmit={handleSubmit} className="space-y-5">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
              <Input id="full_name" label="Nama Lengkap" value={formData.full_name} onChange={handleChange('full_name')} required />
              <Input id="username" label="Username" value={formData.username} onChange={handleChange('username')} required />
            </div>
            <Input id="email" label="Email" type="email" value={formData.email} onChange={handleChange('email')} required />
            <Input id="bio" label="Bio" type="textarea" value={formData.bio} onChange={handleChange('bio')} rows={3} />
            <div className="pt-2">
              <Button type="submit" loading={isLoading} id="save-profile">Simpan Perubahan</Button>
            </div>
          </form>
        </CardBody>
      </Card>

      {/* Danger Zone */}
      <Card hover={false} className="border-red-500/20">
        <CardHeader>
          <h2 className="text-lg font-semibold text-red-400">Zona Berbahaya</h2>
        </CardHeader>
        <CardBody>
          <p className="text-sm text-surface-400 mb-4 leading-relaxed">
            Menghapus akun akan menghapus semua data Anda secara permanen. Tindakan ini tidak dapat dibatalkan.
          </p>
          <Button variant="danger" onClick={() => setDeleteModalOpen(true)} id="delete-account-btn">
            Hapus Akun
          </Button>
        </CardBody>
      </Card>

      {/* Delete Confirmation */}
      <Modal isOpen={deleteModalOpen} onClose={() => setDeleteModalOpen(false)} title="Hapus Akun" size="sm">
        <div className="space-y-5">
          <p className="text-surface-300 leading-relaxed">
            Apakah Anda yakin ingin menghapus akun <strong className="text-surface-100">{currentUser?.full_name}</strong>? 
            Semua karya dan data Anda akan dihapus secara permanen.
          </p>
          <div className="flex gap-3">
            <Button variant="danger" fullWidth loading={isLoading} onClick={handleDeleteAccount} id="confirm-delete-account">
              Ya, Hapus Akun
            </Button>
            <Button variant="secondary" fullWidth onClick={() => setDeleteModalOpen(false)}>
              Batal
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
