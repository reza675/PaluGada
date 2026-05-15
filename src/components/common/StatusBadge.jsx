import { STATUS_LABELS, STATUS_COLORS } from '../../utils/constants';

export default function StatusBadge({ status, className = '' }) {
  const colorMap = {
    success: 'bg-emerald-500/15 text-emerald-400 border-emerald-500/30',
    warning: 'bg-amber-500/15 text-amber-400 border-amber-500/30',
    danger: 'bg-red-500/15 text-red-400 border-red-500/30',
    info: 'bg-blue-500/15 text-blue-400 border-blue-500/30',
  };

  const colorType = STATUS_COLORS[status] || 'info';
  const label = STATUS_LABELS[status] || status;

  return (
    <span
      className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold border ${colorMap[colorType]} ${className}`}
    >
      <span className={`w-1.5 h-1.5 rounded-full mr-1.5 ${
        colorType === 'success' ? 'bg-emerald-400' :
        colorType === 'warning' ? 'bg-amber-400' :
        colorType === 'danger' ? 'bg-red-400' : 'bg-blue-400'
      }`} />
      {label}
    </span>
  );
}
