import { useNavigate } from 'react-router-dom';
import Card from '../common/Card';
import StatusBadge from '../common/StatusBadge';
import { formatCurrency, truncateText } from '../../utils/formatters';

export default function ArtworkCard({ artwork, showActions = false, onEdit, onDelete }) {
  const navigate = useNavigate();

  return (
    <Card className="group">
      {/* Image */}
      <div className="relative overflow-hidden aspect-[4/3]">
        <img
          src={artwork.image_url}
          alt={artwork.title}
          className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
          loading="lazy"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-surface-950/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        
        {/* Status badge overlay */}
        <div className="absolute top-3 right-3">
          <StatusBadge status={artwork.status} />
        </div>

        {/* Price overlay on hover */}
        <div className="absolute bottom-3 left-3 right-3 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-300">
          <p className="text-lg font-bold text-white">
            {formatCurrency(artwork.starting_price)}
          </p>
        </div>
      </div>

      {/* Content */}
      <div className="p-4 space-y-2">
        <h3 className="text-base font-semibold text-surface-100 line-clamp-1 group-hover:text-primary-400 transition-colors">
          {artwork.title}
        </h3>
        <p className="text-sm text-surface-400 line-clamp-2">
          {truncateText(artwork.description, 80)}
        </p>
        <div className="flex items-center justify-between pt-2">
          <span className="text-xs text-surface-500">{artwork.medium}</span>
          <span className="text-xs text-surface-500">{artwork.year_created}</span>
        </div>

        {/* Actions */}
        {showActions && (
          <div className="flex gap-2 pt-3 border-t border-surface-600/30">
            <button
              onClick={(e) => {
                e.stopPropagation();
                onEdit?.(artwork);
              }}
              className="flex-1 px-3 py-2 text-xs font-medium text-primary-400 bg-primary-600/10 hover:bg-primary-600/20 rounded-lg transition-colors"
            >
              Edit
            </button>
            <button
              onClick={(e) => {
                e.stopPropagation();
                onDelete?.(artwork);
              }}
              className="flex-1 px-3 py-2 text-xs font-medium text-red-400 bg-red-600/10 hover:bg-red-600/20 rounded-lg transition-colors"
            >
              Hapus
            </button>
          </div>
        )}
      </div>
    </Card>
  );
}
