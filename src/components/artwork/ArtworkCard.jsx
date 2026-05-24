import Card from '../common/Card';
import StatusBadge from '../common/StatusBadge';
import { formatCurrency, truncateText } from '../../utils/formatters';

export default function ArtworkCard({ artwork, showActions = false, onEdit, onDelete }) {
  return (
    <Card className="group" id={`artwork-card-${artwork.id}`}>
      {/* Image */}
      <div className="relative overflow-hidden aspect-[4/3]">
        <img
          src={artwork.image_url || 'https://picsum.photos/seed/placeholder/800/600'}
          alt={artwork.nama_karya}
          className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
          loading="lazy"
          onError={(e) => {
            if (!e.target.src.includes('picsum.photos')) {
              e.target.src = 'https://picsum.photos/seed/placeholder/800/600';
            }
          }}
        />
        <div className="absolute inset-0 bg-gradient-to-t from-surface-950/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />

        {/* Status badge overlay */}
        <div className="absolute top-3 right-3">
          <StatusBadge status={artwork.verification_status} />
        </div>

        {/* Price overlay on hover */}
        <div className="absolute bottom-3 left-3 right-3 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-300">
          <p className="text-lg font-bold text-white drop-shadow-lg">
            {formatCurrency(artwork.min_bid_ammount)}
          </p>
        </div>
      </div>

      {/* Content */}
      <div className="p-4 sm:p-5 space-y-2.5">
        <h3 className="text-base font-semibold text-surface-100 line-clamp-1 group-hover:text-primary-400 transition-colors duration-200">
          {artwork.nama_karya}
        </h3>
        <p className="text-sm text-surface-400 line-clamp-2 leading-relaxed">
          {truncateText(artwork.deskripsi, 80)}
        </p>
        <div className="flex items-center justify-between pt-1">
          <span className="text-xs text-surface-500 font-medium">{artwork.katalog || '-'}</span>
          {artwork.tags && (
            <span className="text-xs text-surface-500 truncate max-w-[120px]">{artwork.tags}</span>
          )}
        </div>

        {/* Mobile price (always visible) */}
        <p className="text-sm font-semibold text-primary-400 sm:hidden pt-1">
          {formatCurrency(artwork.min_bid_ammount)}
        </p>

        {/* Actions */}
        {showActions && (
          <div className="flex gap-2 pt-3 border-t border-surface-600/30">
            <button
              onClick={(e) => {
                e.stopPropagation();
                onEdit?.(artwork);
              }}
              className="flex-1 px-3 py-2.5 text-xs font-medium text-primary-400 bg-primary-600/10 hover:bg-primary-600/20 rounded-lg transition-all duration-200 active:scale-[0.97]"
              id={`edit-artwork-${artwork.id}`}
            >
              ✏️ Edit
            </button>
            <button
              onClick={(e) => {
                e.stopPropagation();
                onDelete?.(artwork);
              }}
              className="flex-1 px-3 py-2.5 text-xs font-medium text-red-400 bg-red-600/10 hover:bg-red-600/20 rounded-lg transition-all duration-200 active:scale-[0.97]"
              id={`delete-artwork-${artwork.id}`}
            >
              🗑️ Hapus
            </button>
          </div>
        )}
      </div>
    </Card>
  );
}
