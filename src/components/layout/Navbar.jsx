import { Link, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { APP_NAME } from '../../utils/constants';
import Button from '../common/Button';

export default function Navbar() {
  const { currentUser, isAuthenticated, logout, isArtist, isCurator } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  // Don't show navbar on auth pages
  if (['/login', '/register'].includes(location.pathname)) return null;

  return (
    <nav className="fixed top-0 left-0 right-0 z-40 glass border-b border-surface-600/30">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link to={isArtist ? '/artist/dashboard' : '/curator/dashboard'} className="flex items-center gap-3 group">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-primary-500 to-primary-700 flex items-center justify-center shadow-lg shadow-primary-900/30 group-hover:shadow-primary-800/50 transition-shadow">
              <svg className="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <span className="text-xl font-bold text-gradient">{APP_NAME}</span>
          </Link>

          {/* Right side */}
          {isAuthenticated && (
            <div className="flex items-center gap-4">
              <div className="hidden sm:flex items-center gap-2 px-3 py-1.5 rounded-xl bg-surface-800/50 border border-surface-600/30">
                <img
                  src={currentUser.avatar_url}
                  alt={currentUser.full_name}
                  className="w-7 h-7 rounded-lg object-cover"
                />
                <div className="text-sm">
                  <span className="text-surface-200 font-medium">{currentUser.full_name}</span>
                  <span className="text-surface-500 mx-1.5">·</span>
                  <span className="text-primary-400 text-xs font-semibold uppercase">
                    {currentUser.role}
                  </span>
                </div>
              </div>
              <Button variant="ghost" size="sm" onClick={handleLogout}>
                <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                </svg>
                <span className="hidden sm:inline">Keluar</span>
              </Button>
            </div>
          )}
        </div>
      </div>
    </nav>
  );
}
