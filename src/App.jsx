import { useState, createContext, useContext } from 'react';
import { Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { useAuth } from './hooks/useAuth';
import { ROLES } from './utils/constants';

// Layout
import Navbar from './components/layout/Navbar';
import Sidebar from './components/layout/Sidebar';
import Footer from './components/layout/Footer';

// Auth Pages
import LoginPage from './pages/auth/LoginPage';
import RegisterPage from './pages/auth/RegisterPage';

// Artist Pages
import ArtistDashboard from './pages/artist/ArtistDashboard';
import MyArtworksPage from './pages/artist/MyArtworksPage';
import CreateArtworkPage from './pages/artist/CreateArtworkPage';
import EditArtworkPage from './pages/artist/EditArtworkPage';
import BiddingMonitorPage from './pages/artist/BiddingMonitorPage';
import AccountSettingsPage from './pages/artist/AccountSettingsPage';

// Curator Pages
import CuratorDashboard from './pages/curator/CuratorDashboard';

// Loading
import { PageLoader } from './components/common/LoadingSpinner';

// Sidebar context for mobile toggle
export const SidebarContext = createContext();
export const useSidebar = () => useContext(SidebarContext);

// Protected Route wrapper
function ProtectedRoute({ children, allowedRole }) {
  const { isAuthenticated, currentUser, isLoading } = useAuth();

  // Show loading while checking auth on initial mount
  if (isLoading) return <PageLoader />;

  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (allowedRole && currentUser?.role !== allowedRole) {
    return <Navigate to={currentUser?.role === ROLES.SENIMAN ? '/artist/dashboard' : '/curator/dashboard'} replace />;
  }
  return children;
}

// Layout wrapper for authenticated pages
function DashboardLayout({ children }) {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <SidebarContext.Provider value={{ sidebarOpen, setSidebarOpen }}>
      <div className="min-h-screen flex flex-col bg-surface-900">
        <Navbar />
        <div className="flex flex-1 pt-16">
          <Sidebar />
          <main className="flex-1 lg:ml-64 p-4 sm:p-6 lg:p-8 min-h-[calc(100vh-4rem)]">
            <div className="max-w-6xl mx-auto">
              {children}
            </div>
          </main>
        </div>
        <Footer />
      </div>
    </SidebarContext.Provider>
  );
}

export default function App() {
  return (
    <Routes>
      {/* Public Routes */}
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />

      {/* Artist Routes (SENIMAN) */}
      <Route
        path="/artist/dashboard"
        element={
          <ProtectedRoute allowedRole={ROLES.SENIMAN}>
            <DashboardLayout><ArtistDashboard /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/artworks"
        element={
          <ProtectedRoute allowedRole={ROLES.SENIMAN}>
            <DashboardLayout><MyArtworksPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/artworks/create"
        element={
          <ProtectedRoute allowedRole={ROLES.SENIMAN}>
            <DashboardLayout><CreateArtworkPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/artworks/:id/edit"
        element={
          <ProtectedRoute allowedRole={ROLES.SENIMAN}>
            <DashboardLayout><EditArtworkPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/bidding"
        element={
          <ProtectedRoute allowedRole={ROLES.SENIMAN}>
            <DashboardLayout><BiddingMonitorPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/account"
        element={
          <ProtectedRoute allowedRole={ROLES.SENIMAN}>
            <DashboardLayout><AccountSettingsPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />

      {/* Curator Routes (KURATOR) */}
      <Route
        path="/curator/dashboard"
        element={
          <ProtectedRoute allowedRole={ROLES.KURATOR}>
            <DashboardLayout><CuratorDashboard /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/curator/account"
        element={
          <ProtectedRoute allowedRole={ROLES.KURATOR}>
            <DashboardLayout><AccountSettingsPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />

      {/* Default redirect */}
      <Route path="/" element={<Navigate to="/login" replace />} />
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}
