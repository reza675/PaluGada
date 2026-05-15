import { useLocation } from 'react-router-dom';

export default function Footer() {
  const location = useLocation();

  // Don't show footer on auth pages
  if (['/login', '/register'].includes(location.pathname)) return null;

  return (
    <footer className="border-t border-surface-600/30 bg-surface-900/80 mt-auto">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4">
          <p className="text-sm text-surface-500">
            © 2025 <span className="text-primary-400 font-medium">PaluGada</span>. 
            Platform Galeri Seni & Lelang Online.
          </p>
          <p className="text-xs text-surface-600">
            Tugas Akhir — Teknologi Cloud Computing
          </p>
        </div>
      </div>
    </footer>
  );
}
