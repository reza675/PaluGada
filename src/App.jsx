import { Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { useAuth } from './hooks/useAuth';

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

// Protected Route wrapper
function ProtectedRoute({ children, allowedRole }) {
  const { isAuthenticated, currentUser } = useAuth();

  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (allowedRole && currentUser?.role !== allowedRole) {
    return <Navigate to={currentUser?.role === 'artist' ? '/artist/dashboard' : '/curator/dashboard'} replace />;
  }
  return children;
}

// Layout wrapper for authenticated pages
function DashboardLayout({ children }) {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <div className="flex flex-1 pt-16">
        <Sidebar />
        <main className="flex-1 lg:ml-64 p-6 lg:p-8">
          {children}
        </main>
      </div>
      <Footer />
    </div>
  );
}

export default function App() {
  return (
    <Routes>
      {/* Public Routes */}
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />

      {/* Artist Routes */}
      <Route
        path="/artist/dashboard"
        element={
          <ProtectedRoute allowedRole="artist">
            <DashboardLayout><ArtistDashboard /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/artworks"
        element={
          <ProtectedRoute allowedRole="artist">
            <DashboardLayout><MyArtworksPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/artworks/create"
        element={
          <ProtectedRoute allowedRole="artist">
            <DashboardLayout><CreateArtworkPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/artworks/:id/edit"
        element={
          <ProtectedRoute allowedRole="artist">
            <DashboardLayout><EditArtworkPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/bidding"
        element={
          <ProtectedRoute allowedRole="artist">
            <DashboardLayout><BiddingMonitorPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/artist/account"
        element={
          <ProtectedRoute allowedRole="artist">
            <DashboardLayout><AccountSettingsPage /></DashboardLayout>
          </ProtectedRoute>
        }
      />

      {/* Curator Routes */}
      <Route
        path="/curator/dashboard"
        element={
          <ProtectedRoute allowedRole="curator">
            <DashboardLayout><CuratorDashboard /></DashboardLayout>
          </ProtectedRoute>
        }
      />

      {/* Default redirect */}
      <Route path="/" element={<Navigate to="/login" replace />} />
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}
