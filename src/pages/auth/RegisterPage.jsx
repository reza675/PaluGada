import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import Input from '../../components/common/Input';
import Button from '../../components/common/Button';
import { APP_NAME } from '../../utils/constants';

export default function RegisterPage() {
  const { register, isLoading } = useAuth();
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    full_name: '', username: '', email: '', password: '', confirmPassword: '', bio: '',
  });
  const [errors, setErrors] = useState({});
  const [serverError, setServerError] = useState('');

  const validate = () => {
    const e = {};
    if (!formData.full_name.trim()) e.full_name = 'Nama lengkap wajib diisi';
    if (!formData.username.trim()) e.username = 'Username wajib diisi';
    if (!formData.email.trim()) e.email = 'Email wajib diisi';
    if (!formData.password) e.password = 'Password wajib diisi';
    else if (formData.password.length < 6) e.password = 'Password minimal 6 karakter';
    if (formData.password !== formData.confirmPassword) e.confirmPassword = 'Password tidak cocok';
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setServerError('');
    if (!validate()) return;
    const result = await register(formData);
    if (result.success) {
      navigate('/artist/dashboard');
    } else {
      setServerError(result.error);
    }
  };

  const handleChange = (field) => (e) => {
    setFormData((p) => ({ ...p, [field]: e.target.value }));
    if (errors[field]) setErrors((p) => ({ ...p, [field]: '' }));
  };

  return (
    <div className="min-h-screen flex">
      {/* Left - Branding */}
      <div className="hidden lg:flex lg:w-1/2 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-primary-900 via-surface-900 to-primary-950" />
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-40 left-10 w-80 h-80 bg-primary-500 rounded-full blur-3xl" />
          <div className="absolute bottom-10 right-10 w-64 h-64 bg-primary-700 rounded-full blur-3xl" />
        </div>
        <div className="relative z-10 flex flex-col justify-center px-16">
          <h1 className="text-5xl font-bold font-serif text-surface-50 mb-4">{APP_NAME}</h1>
          <p className="text-xl text-surface-300 mb-8">Bergabung Sebagai Seniman</p>
          <div className="space-y-4 text-surface-400">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-primary-600/20 flex items-center justify-center">
                <svg className="w-4 h-4 text-primary-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" /></svg>
              </div>
              <span>Upload dan kelola karya seni Anda</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-primary-600/20 flex items-center justify-center">
                <svg className="w-4 h-4 text-primary-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" /></svg>
              </div>
              <span>Dapatkan verifikasi dari kurator</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-primary-600/20 flex items-center justify-center">
                <svg className="w-4 h-4 text-primary-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" /></svg>
              </div>
              <span>Monitor proses lelang secara real-time</span>
            </div>
          </div>
        </div>
      </div>

      {/* Right - Form */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-8 bg-surface-900">
        <div className="w-full max-w-md animate-fade-in">
          <h2 className="text-2xl font-bold text-surface-50 mb-2">Buat Akun Baru</h2>
          <p className="text-surface-400 mb-8">Daftar sebagai seniman di {APP_NAME}</p>

          {serverError && (
            <div className="mb-6 px-4 py-3 rounded-xl bg-red-500/10 border border-red-500/30 text-red-400 text-sm">{serverError}</div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <Input id="full_name" label="Nama Lengkap" placeholder="Nama lengkap Anda" value={formData.full_name} onChange={handleChange('full_name')} error={errors.full_name} required />
            <Input id="username" label="Username" placeholder="username_anda" value={formData.username} onChange={handleChange('username')} error={errors.username} required />
            <Input id="email" label="Email" type="email" placeholder="email@contoh.com" value={formData.email} onChange={handleChange('email')} error={errors.email} required />
            <Input id="password" label="Password" type="password" placeholder="Minimal 6 karakter" value={formData.password} onChange={handleChange('password')} error={errors.password} required />
            <Input id="confirmPassword" label="Konfirmasi Password" type="password" placeholder="Ulangi password" value={formData.confirmPassword} onChange={handleChange('confirmPassword')} error={errors.confirmPassword} required />
            <Input id="bio" label="Bio (opsional)" type="textarea" placeholder="Ceritakan sedikit tentang Anda..." value={formData.bio} onChange={handleChange('bio')} rows={3} />
            <Button type="submit" fullWidth loading={isLoading} size="lg">Daftar</Button>
          </form>

          <p className="text-center text-sm text-surface-400 mt-6">
            Sudah punya akun?{' '}
            <Link to="/login" className="text-primary-400 hover:text-primary-300 font-medium transition-colors">Masuk</Link>
          </p>
        </div>
      </div>
    </div>
  );
}
