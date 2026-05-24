import { createContext, useContext, useState, useCallback, useEffect } from 'react';
import { authService } from '../services/authService';
import { getTokens, clearTokens } from '../utils/api';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [currentUser, setCurrentUser] = useState(null);
  const [isLoading, setIsLoading] = useState(true); 
  const [error, setError] = useState(null);

  useEffect(() => {
    const initAuth = async () => {
      const { token } = getTokens();
      if (!token) {
        setIsLoading(false);
        return;
      }
      try {
        const user = await authService.getProfile();
        setCurrentUser(user);
      } catch {
        clearTokens();
      } finally {
        setIsLoading(false);
      }
    };
    initAuth();
  }, []);

  const login = useCallback(async (email, password) => {
    setIsLoading(true);
    setError(null);
    try {
      await authService.login({ email, password });
      const user = await authService.getProfile();
      setCurrentUser(user);
      setIsLoading(false);
      return { success: true, user };
    } catch (err) {
      setIsLoading(false);
      const msg = err.message || 'Login gagal.';
      setError(msg);
      return { success: false, error: msg };
    }
  }, []);

  const register = useCallback(async (userData) => {
    setIsLoading(true);
    setError(null);
    try {
      await authService.register(userData);
      await authService.login({ email: userData.email, password: userData.password });
      const user = await authService.getProfile();
      setCurrentUser(user);
      setIsLoading(false);
      return { success: true, user };
    } catch (err) {
      setIsLoading(false);
      const msg = err.message || 'Registrasi gagal.';
      setError(msg);
      return { success: false, error: msg };
    }
  }, []);

  const logout = useCallback(async () => {
    setIsLoading(true);
    try {
      await authService.logout();
    } catch {
      // Ignore errors
    }
    setCurrentUser(null);
    setIsLoading(false);
  }, []);

  const updateAccount = useCallback(async ({ full_name, alt_name }) => {
    setIsLoading(true);
    setError(null);
    try {
      await authService.updateProfile({ full_name, alt_name });
      // Refresh profile data
      const user = await authService.getProfile();
      setCurrentUser(user);
      setIsLoading(false);
      return { success: true };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, []);

  const changePassword = useCallback(async (password) => {
    setIsLoading(true);
    setError(null);
    try {
      await authService.updatePassword(password);
      setIsLoading(false);
      return { success: true };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, []);

  const deleteAccount = useCallback(async () => {
    setIsLoading(true);
    try {
      await authService.deleteAccount();
      setCurrentUser(null);
      setIsLoading(false);
      return { success: true };
    } catch (err) {
      setIsLoading(false);
      return { success: false, error: err.message };
    }
  }, []);

  const value = {
    currentUser,
    isLoading,
    error,
    login,
    register,
    logout,
    updateAccount,
    changePassword,
    deleteAccount,
    isAuthenticated: !!currentUser,
    isSeniman: currentUser?.role === 'SENIMAN',
    isKurator: currentUser?.role === 'KURATOR',
    isKolektor: currentUser?.role === 'KOLEKTOR',
    isArtist: currentUser?.role === 'SENIMAN',
    isCurator: currentUser?.role === 'KURATOR',
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuthContext() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuthContext must be used within an AuthProvider');
  }
  return context;
}

export default AuthContext;
