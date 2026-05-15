import { useAuthContext } from '../context/AuthContext';

// Re-export the auth context hook as useAuth for cleaner imports
export function useAuth() {
  return useAuthContext();
}
