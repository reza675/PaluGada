import { useState, useEffect, useRef } from 'react';
import Input from '../common/Input';
import Button from '../common/Button';

export default function ArtworkForm({ initialData, onSubmit, onCancel, isLoading }) {
  const [formData, setFormData] = useState({
    nama_karya: '',
    deskripsi: '',
    katalog: '',
    tags: '',
    min_bid_ammount: '',
    open_bid_time: '',
    close_bid_time: '',
  });

  const [imageFile, setImageFile] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [errors, setErrors] = useState({});
  const fileInputRef = useRef(null);

  useEffect(() => {
    if (initialData) {
      setFormData({
        nama_karya: initialData.nama_karya || '',
        deskripsi: initialData.deskripsi || '',
        katalog: initialData.katalog || '',
        tags: initialData.tags || '',
        min_bid_ammount: initialData.min_bid_ammount?.toString() || '',
        open_bid_time: initialData.open_bid_time ? initialData.open_bid_time.slice(0, 16) : '',
        close_bid_time: initialData.close_bid_time ? initialData.close_bid_time.slice(0, 16) : '',
      });
      if (initialData.image_url) {
        setImagePreview(initialData.image_url);
      }
    }
  }, [initialData]);

  const handleChange = (field) => (e) => {
    setFormData((prev) => ({ ...prev, [field]: e.target.value }));
    if (errors[field]) {
      setErrors((prev) => ({ ...prev, [field]: '' }));
    }
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setImageFile(file);
      setImagePreview(URL.createObjectURL(file));
    }
  };

  const validate = () => {
    const newErrors = {};
    if (!formData.nama_karya.trim()) newErrors.nama_karya = 'Nama karya wajib diisi';
    if (!formData.min_bid_ammount || Number(formData.min_bid_ammount) <= 0)
      newErrors.min_bid_ammount = 'Minimum bid harus lebih dari 0';
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!validate()) return;

    onSubmit(
      {
        nama_karya: formData.nama_karya,
        deskripsi: formData.deskripsi || null,
        katalog: formData.katalog || null,
        tags: formData.tags || null,
        min_bid_ammount: Number(formData.min_bid_ammount),
        open_bid_time: formData.open_bid_time ? formData.open_bid_time + ":00.000Z" : null,
        close_bid_time: formData.close_bid_time ? formData.close_bid_time + ":00.000Z" : null,
      },
      imageFile
    );
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-5" id="artwork-form">
      <Input
        id="nama_karya"
        label="Nama Karya"
        placeholder="Masukkan nama karya seni"
        value={formData.nama_karya}
        onChange={handleChange('nama_karya')}
        error={errors.nama_karya}
        required
      />

      <Input
        id="deskripsi"
        label="Deskripsi"
        type="textarea"
        placeholder="Ceritakan tentang karya seni ini..."
        value={formData.deskripsi}
        onChange={handleChange('deskripsi')}
        rows={4}
      />

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-5">
        <Input
          id="katalog"
          label="Katalog"
          placeholder="Contoh: Modern, Klasik"
          value={formData.katalog}
          onChange={handleChange('katalog')}
        />

        <Input
          id="tags"
          label="Tags (pisahkan dengan koma)"
          placeholder="Contoh: oil,canvas,sunset"
          value={formData.tags}
          onChange={handleChange('tags')}
        />
      </div>

      <Input
        id="min_bid_ammount"
        label="Minimum Bid (Rp)"
        type="number"
        placeholder="1000000"
        value={formData.min_bid_ammount}
        onChange={handleChange('min_bid_ammount')}
        error={errors.min_bid_ammount}
        required
      />

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-5">
        <Input
          id="open_bid_time"
          label="Waktu Buka Bid"
          type="datetime-local"
          value={formData.open_bid_time}
          onChange={handleChange('open_bid_time')}
        />

        <Input
          id="close_bid_time"
          label="Waktu Tutup Bid"
          type="datetime-local"
          value={formData.close_bid_time}
          onChange={handleChange('close_bid_time')}
        />
      </div>

      {/* Image Upload */}
      <div>
        <label className="block text-sm font-medium text-surface-300 mb-2">
          Gambar Karya
        </label>
        <div
          onClick={() => fileInputRef.current?.click()}
          className="relative cursor-pointer rounded-xl border-2 border-dashed border-surface-600/50 hover:border-primary-500/50 transition-colors duration-200 p-6 text-center"
        >
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            onChange={handleImageChange}
            className="hidden"
            id="image-upload"
          />
          {imagePreview ? (
            <div className="space-y-3">
              <img
                src={imagePreview}
                alt="Preview"
                className="w-full h-40 sm:h-48 object-cover rounded-lg"
              />
              <p className="text-xs text-surface-400">Klik untuk mengganti gambar</p>
            </div>
          ) : (
            <div className="space-y-2">
              <svg className="w-10 h-10 mx-auto text-surface-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <p className="text-sm text-surface-400">Klik untuk upload gambar</p>
              <p className="text-xs text-surface-500">JPG, PNG, WebP — Maks 10MB</p>
            </div>
          )}
        </div>
      </div>

      {/* Actions */}
      <div className="flex flex-col-reverse sm:flex-row gap-3 pt-4 border-t border-surface-600/30">
        {onCancel && (
          <Button type="button" variant="secondary" onClick={onCancel} fullWidth>
            Batal
          </Button>
        )}
        <Button type="submit" loading={isLoading} fullWidth id="submit-artwork">
          {initialData ? 'Simpan Perubahan' : 'Upload Karya'}
        </Button>
      </div>
    </form>
  );
}
