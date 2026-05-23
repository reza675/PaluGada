import StatusBadge from '../common/StatusBadge';
import { formatCurrency, formatDate } from '../../utils/formatters';

export default function BidTable({ bids, artworks }) {
  const getArtworkTitle = (artworkId) => {
    const artwork = artworks.find((a) => a.id === artworkId);
    return artwork?.title || 'Unknown';
  };

  if (!bids.length) {
    return (
      <div className="flex flex-col items-center justify-center py-16 text-center">
        <div className="w-20 h-20 rounded-2xl bg-surface-800/50 flex items-center justify-center mb-4">
          <svg className="w-10 h-10 text-surface-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
          </svg>
        </div>
        <p className="text-surface-400 text-sm">Belum ada bid masuk.</p>
      </div>
    );
  }

  return (
    <>
      {/* Desktop table */}
      <div className="hidden sm:block overflow-x-auto rounded-xl border border-surface-600/30">
        <table className="w-full text-sm" id="bid-table">
          <thead>
            <tr className="bg-surface-800/50 border-b border-surface-600/30">
              <th className="text-left px-5 py-3.5 text-xs font-semibold text-surface-400 uppercase tracking-wider">Karya</th>
              <th className="text-left px-5 py-3.5 text-xs font-semibold text-surface-400 uppercase tracking-wider">Bidder</th>
              <th className="text-left px-5 py-3.5 text-xs font-semibold text-surface-400 uppercase tracking-wider">Jumlah Bid</th>
              <th className="text-left px-5 py-3.5 text-xs font-semibold text-surface-400 uppercase tracking-wider hidden md:table-cell">Waktu</th>
              <th className="text-left px-5 py-3.5 text-xs font-semibold text-surface-400 uppercase tracking-wider">Status</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-surface-600/20">
            {bids.map((bid, index) => (
              <tr key={bid.id} className="hover:bg-surface-800/30 transition-colors animate-fade-in" style={{ animationDelay: `${index * 0.05}s` }}>
                <td className="px-5 py-4">
                  <span className="text-surface-200 font-medium">{getArtworkTitle(bid.artwork_id)}</span>
                </td>
                <td className="px-5 py-4">
                  <div>
                    <p className="text-surface-200">{bid.bidder_name}</p>
                    <p className="text-xs text-surface-500 mt-0.5">{bid.bidder_email}</p>
                  </div>
                </td>
                <td className="px-5 py-4">
                  <span className="text-primary-400 font-semibold tabular-nums">{formatCurrency(bid.bid_amount)}</span>
                </td>
                <td className="px-5 py-4 hidden md:table-cell">
                  <span className="text-surface-400 text-xs">{formatDate(bid.bid_time)}</span>
                </td>
                <td className="px-5 py-4">
                  <StatusBadge status={bid.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Mobile card list */}
      <div className="sm:hidden space-y-3">
        {bids.map((bid, index) => (
          <div
            key={bid.id}
            className="glass rounded-xl p-4 space-y-3 animate-fade-in"
            style={{ animationDelay: `${index * 0.05}s` }}
          >
            <div className="flex items-start justify-between gap-2">
              <div className="min-w-0">
                <p className="text-sm font-medium text-surface-100 truncate">{getArtworkTitle(bid.artwork_id)}</p>
                <p className="text-xs text-surface-400 mt-0.5">{bid.bidder_name}</p>
              </div>
              <StatusBadge status={bid.status} />
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm font-semibold text-primary-400 tabular-nums">{formatCurrency(bid.bid_amount)}</span>
              <span className="text-xs text-surface-500">{formatDate(bid.bid_time)}</span>
            </div>
          </div>
        ))}
      </div>
    </>
  );
}
