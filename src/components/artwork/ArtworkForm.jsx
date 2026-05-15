import { useState, useEffect } from 'react';
import Input from '../common/Input';
import Button from '../common/Button';
import categories from '../../data/categories';

export default function ArtworkForm({ initialData, onSubmit, onCancel, isLoading }) {
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    category_id: '',
    medium: '',
    dimensions: '',
    year_created: new Date().getFullYear(),
    image_url: '',
    starting_price: '',
  });

  const [errors, setErrors] = useState({});

  useEffect(() => {
    if (initialData) {
      setFormData({
        title: initialData.title || '',
        description: initialData.description || '',
        category_id: initialData.category_id?.toString() || '',
        medium: initialData.medium || '',
        dimensions: initialData.dimensions || '',
        year_created: initialData.year_created || new Date().getFullYear(),
        image_url: initialData.image_url || '',
        starting_price: initialData.starting_price?.toString() || '',
      });
    }
  }, [initialData]);

  const handleChange = (field) => (e) => {
    setFormData((prev) => ({ ...prev, [field]: e.target.value }));
    // Clear error on change
    if (errors[field]) {
      setErrors((prev) => ({ ...prev, [field]: '' }));
    }
  };

  const validate = () => {
    const newErrors = {};
    if (!formData.title.trim()) newErrors.title = 'Judul wajib diisi';
    if (!formData.description.trim()) newErrors.description = 'Deskripsi wajib diisi';
    if (!formData.category_id) newErrors.category_id = 'Kategori wajib dipilih';
    if (!formData.medium.trim()) newErrors.medium = 'Medium wajib diisi';
    if (!formData.starting_price || Number(formData.starting_price) <= 0)
      newErrors.starting_price = 'Harga awal harus lebih dari 0';
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!validate()) return;

    onSubmit({
      ...formData,
      category_id: Number(formData.category_id),
      year_created: Number(formData.year_created),
      starting_price: Number(formData.starting_price),
      image_url: formData.image_url || `https://picsum.photos/seed/${Date.now()}/800/600`,
    });
  };

  const categoryOptions = categories.map((c) => ({
    value: c.id.toString(),
    label: c.name,
  }));

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <Input
        id="title"
        label="Judul Karya"
        placeholder="Masukkan judul karya seni"
        value={formData.title}
        onChange={handleChange('title')}
        error={errors.title}
        required
      />

      <Input
        id="description"
        label="Deskripsi"
        type="textarea"
        placeholder="Ceritakan tentang karya seni ini..."
        value={formData.description}
        onChange={handleChange('description')}
        error={errors.description}
        rows={4}
        required
      />

      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        <Input
          id="category_id"
          label="Kategori"
          type="select"
          value={formData.category_id}
          onChange={handleChange('category_id')}
          error={errors.category_id}
          options={categoryOptions}
          placeholder="Pilih kategori"
          required
        />

        <Input
          id="medium"
          label="Medium / Teknik"
          placeholder="Contoh: Cat Minyak di Kanvas"
          value={formData.medium}
          onChange={handleChange('medium')}
          error={errors.medium}
          required
        />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        <Input
          id="dimensions"
          label="Dimensi"
          placeholder="Contoh: 120 x 80 cm"
          value={formData.dimensions}
          onChange={handleChange('dimensions')}
        />

        <Input
          id="year_created"
          label="Tahun Pembuatan"
          type="number"
          placeholder="2025"
          value={formData.year_created}
          onChange={handleChange('year_created')}
        />
      </div>

      <Input
        id="starting_price"
        label="Harga Awal Lelang (Rp)"
        type="number"
        placeholder="15000000"
        value={formData.starting_price}
        onChange={handleChange('starting_price')}
        error={errors.starting_price}
        required
      />

      <Input
        id="image_url"
        label="URL Gambar"
        placeholder="https://... (kosongkan untuk placeholder)"
        value={formData.image_url}
        onChange={handleChange('image_url')}
      />

      {/* Image preview */}
      {(formData.image_url || initialData?.image_url) && (
        <div className="rounded-xl overflow-hidden border border-surface-600/30">
          <img
            src={formData.image_url || initialData?.image_url}
            alt="Preview"
            className="w-full h-48 object-cover"
            onError={(e) => {
              e.target.src = 'https://picsum.photos/seed/placeholder/800/600';
            }}
          />
        </div>
      )}

      {/* Actions */}
      <div className="flex gap-3 pt-4">
        <Button type="submit" loading={isLoading} fullWidth>
          {initialData ? 'Simpan Perubahan' : 'Upload Karya'}
        </Button>
        {onCancel && (
          <Button type="button" variant="secondary" onClick={onCancel} fullWidth>
            Batal
          </Button>
        )}
      </div>
    </form>
  );
}
