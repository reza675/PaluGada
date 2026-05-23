import { Link, useLocation, useNavigate } from 'react-router-dom';
import { useContext } from 'react';
import { useAuth } from '../../hooks/useAuth';
import { APP_NAME } from '../../utils/constants';
import { SidebarContext } from '../../App';
import Button from '../common/Button';

export default function Navbar() {
  const { currentUser, isAuthenticated, logout, isArtist, isCurator } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();
  const sidebarCtx = useContext(SidebarContext);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  // Don't show navbar on auth pages
  if (['/login', '/register'].includes(location.pathname)) return null;

  return (
    <nav className="fixed top-0 left-0 right-0 z-40 glass border-b border-surface-600/30" id="main-navbar">
      <div className="px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Left: Hamburger + Logo */}
          <div className="flex items-center gap-3">
            {/* Mobile hamburger */}
            {sidebarCtx && (
              <button
                onClick={() => sidebarCtx.setSidebarOpen((prev) => !prev)}
                className="lg:hidden p-2 -ml-1 rounded-xl text-surface-400 hover:text-surface-100 hover:bg-surface-700/50 transition-all duration-200 active:scale-95"
                aria-label="Toggle navigation menu"
                id="sidebar-toggle"
              >
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  {sidebarCtx.sidebarOpen ? (
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  ) : (
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                  )}
                </svg>
              </button>
            )}

            {/* Logo */}
            <Link to={isArtist ? '/artist/dashboard' : '/curator/dashboard'} className="flex items-center gap-3 group">
              <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-primary-500 to-primary-700 flex items-center justify-center shadow-lg shadow-primary-900/30 group-hover:shadow-primary-800/50 transition-shadow">
                <svg className="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <span className="text-xl font-bold text-gradient">{APP_NAME}</span>
            </Link>
          </div>

          {/* Right side */}
          {isAuthenticated && (
            <div className="flex items-center gap-3 sm:gap-4">
              <div className="hidden sm:flex items-center gap-2.5 px-3.5 py-2 rounded-xl bg-surface-800/50 border border-surface-600/30">
                <img
                  src={currentUser.avatar_url}
                  alt={currentUser.full_name}
                  className="w-7 h-7 rounded-lg object-cover ring-1 ring-surface-600/50"
                />
                <div className="text-sm">
                  <span className="text-surface-200 font-medium">{currentUser.full_name}</span>
                  <span className="text-surface-600 mx-1.5">·</span>
                  <span className="text-primary-400 text-xs font-semibold uppercase tracking-wide">
                    {currentUser.role}
                  </span>
                </div>
              </div>
              <Button variant="ghost" size="sm" onClick={handleLogout} id="logout-btn">
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
