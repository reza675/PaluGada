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
    <div className="max-w-2xl mx-auto space-y-6 animate-fade-in">
      <div>
        <h1 className="text-2xl font-bold font-serif text-surface-50">Pengaturan Akun</h1>
        <p className="text-sm text-surface-400 mt-1">Kelola informasi profil Anda</p>
      </div>

      {successMsg && (
        <div className="px-4 py-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-sm animate-fade-in">
          ✅ {successMsg}
        </div>
      )}

      {/* Profile Info */}
      <Card hover={false}>
        <CardHeader>
          <div className="flex items-center gap-4">
            <img
              src={currentUser?.avatar_url}
              alt={currentUser?.full_name}
              className="w-16 h-16 rounded-xl object-cover border-2 border-primary-600/30"
            />
            <div>
              <h2 className="text-lg font-semibold text-surface-100">{currentUser?.full_name}</h2>
              <p className="text-sm text-primary-400">@{currentUser?.username}</p>
            </div>
          </div>
        </CardHeader>
        <CardBody>
          <form onSubmit={handleSubmit} className="space-y-4">
            <Input id="full_name" label="Nama Lengkap" value={formData.full_name} onChange={handleChange('full_name')} required />
            <Input id="username" label="Username" value={formData.username} onChange={handleChange('username')} required />
            <Input id="email" label="Email" type="email" value={formData.email} onChange={handleChange('email')} required />
            <Input id="bio" label="Bio" type="textarea" value={formData.bio} onChange={handleChange('bio')} rows={3} />
            <Button type="submit" loading={isLoading}>Simpan Perubahan</Button>
          </form>
        </CardBody>
      </Card>

      {/* Danger Zone */}
      <Card hover={false} className="border-red-500/20">
        <CardHeader>
          <h2 className="text-lg font-semibold text-red-400">Zona Berbahaya</h2>
        </CardHeader>
        <CardBody>
          <p className="text-sm text-surface-400 mb-4">
            Menghapus akun akan menghapus semua data Anda secara permanen. Tindakan ini tidak dapat dibatalkan.
          </p>
          <Button variant="danger" onClick={() => setDeleteModalOpen(true)}>
            Hapus Akun
          </Button>
        </CardBody>
      </Card>

      {/* Delete Confirmation */}
      <Modal isOpen={deleteModalOpen} onClose={() => setDeleteModalOpen(false)} title="Hapus Akun" size="sm">
        <div className="space-y-4">
          <p className="text-surface-300">
            Apakah Anda yakin ingin menghapus akun <strong className="text-surface-100">{currentUser?.full_name}</strong>? 
            Semua karya dan data Anda akan dihapus secara permanen.
          </p>
          <div className="flex gap-3">
            <Button variant="danger" fullWidth loading={isLoading} onClick={handleDeleteAccount}>
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
