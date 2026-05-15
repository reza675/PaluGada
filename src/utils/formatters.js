// Utility: formatters for currency, date, etc.

/**
 * Format number to Indonesian Rupiah currency
 * @param {number} amount
 * @returns {string} e.g. "Rp 15.000.000"
 */
export function formatCurrency(amount) {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
}

/**
 * Format ISO date string to readable Indonesian format
 * @param {string} dateStr - ISO date string
 * @returns {string} e.g. "15 Juni 2025, 10:30"
 */
export function formatDate(dateStr) {
  if (!dateStr) return '-';
  return new Intl.DateTimeFormat('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(new Date(dateStr));
}

/**
 * Format ISO date string to short format
 * @param {string} dateStr
 * @returns {string} e.g. "15 Jun 2025"
 */
export function formatDateShort(dateStr) {
  if (!dateStr) return '-';
  return new Intl.DateTimeFormat('id-ID', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  }).format(new Date(dateStr));
}

/**
 * Get relative time from now
 * @param {string} dateStr
 * @returns {string} e.g. "2 hari yang lalu"
 */
export function timeAgo(dateStr) {
  if (!dateStr) return '-';
  const now = new Date();
  const date = new Date(dateStr);
  const diffMs = now - date;
  const diffSec = Math.floor(diffMs / 1000);
  const diffMin = Math.floor(diffSec / 60);
  const diffHour = Math.floor(diffMin / 60);
  const diffDay = Math.floor(diffHour / 24);

  if (diffDay > 30) return formatDateShort(dateStr);
  if (diffDay > 0) return `${diffDay} hari yang lalu`;
  if (diffHour > 0) return `${diffHour} jam yang lalu`;
  if (diffMin > 0) return `${diffMin} menit yang lalu`;
  return 'Baru saja';
}

/**
 * Truncate text to specified length
 * @param {string} text
 * @param {number} maxLength
 * @returns {string}
 */
export function truncateText(text, maxLength = 100) {
  if (!text) return '';
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}
