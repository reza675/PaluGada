import { createContext, useContext, useState, useCallback } from 'react';
import usersData from '../data/users';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [currentUser, setCurrentUser] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [users, setUsers] = useState(usersData);

  const login = useCallback(async (email, password, role) => {
    setIsLoading(true);
    // Simulate API delay
    await new Promise((r) => setTimeout(r, 800));

    const user = users.find(
      (u) => u.email === email && u.role === role
    );

    if (user) {
      setCurrentUser(user);
      setIsLoading(false);
      return { success: true, user };
    }
    setIsLoading(false);
    return { success: false, error: 'Email atau role tidak ditemukan.' };
  }, [users]);

  const register = useCallback(async (userData) => {
    setIsLoading(true);
    await new Promise((r) => setTimeout(r, 800));

    // Check duplicate email
    if (users.some((u) => u.email === userData.email)) {
      setIsLoading(false);
      return { success: false, error: 'Email sudah terdaftar.' };
    }

    const newUser = {
      id: Math.max(...users.map((u) => u.id)) + 1,
      username: userData.username,
      email: userData.email,
      password_hash: 'hashed_' + userData.password,
      role: 'artist', // Registration is for artists only
      full_name: userData.full_name,
      bio: userData.bio || '',
      avatar_url: `https://picsum.photos/seed/${userData.username}/200/200`,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };

    setUsers((prev) => [...prev, newUser]);
    setCurrentUser(newUser);
    setIsLoading(false);
    return { success: true, user: newUser };
  }, [users]);

  const logout = useCallback(() => {
    setCurrentUser(null);
  }, []);

  const updateAccount = useCallback(async (updatedData) => {
    setIsLoading(true);
    await new Promise((r) => setTimeout(r, 600));

    setUsers((prev) =>
      prev.map((u) =>
        u.id === currentUser.id
          ? { ...u, ...updatedData, updated_at: new Date().toISOString() }
          : u
      )
    );
    setCurrentUser((prev) => ({
      ...prev,
      ...updatedData,
      updated_at: new Date().toISOString(),
    }));
    setIsLoading(false);
    return { success: true };
  }, [currentUser]);

  const deleteAccount = useCallback(async () => {
    setIsLoading(true);
    await new Promise((r) => setTimeout(r, 600));

    setUsers((prev) => prev.filter((u) => u.id !== currentUser.id));
    setCurrentUser(null);
    setIsLoading(false);
    return { success: true };
  }, [currentUser]);

  const value = {
    currentUser,
    isLoading,
    users,
    login,
    register,
    logout,
    updateAccount,
    deleteAccount,
    isAuthenticated: !!currentUser,
    isArtist: currentUser?.role === 'artist',
    isCurator: currentUser?.role === 'curator',
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
