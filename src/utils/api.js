import { API_BASE_URL } from './constants';

export function getTokens() {
  return {
    token: localStorage.getItem('token'),
    refreshToken: localStorage.getItem('refreshToken'),
  };
}

export function setTokens(token, refreshToken) {
  if (token) localStorage.setItem('token', token);
  if (refreshToken) localStorage.setItem('refreshToken', refreshToken);
}

export function clearTokens() {
  localStorage.removeItem('token');
  localStorage.removeItem('refreshToken');
}

/**
 * Try to refresh the access token using the stored refresh token
 * @returns {string|null} new access token, or null if refresh failed
 */
async function refreshAccessToken() {
  const { refreshToken } = getTokens();
  if (!refreshToken) return null;

  try {
    const res = await fetch(`${API_BASE_URL}/user/refresh`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken }),
    });

    if (!res.ok) {
      clearTokens();
      return null;
    }

    const data = await res.json();
    setTokens(data.token, data.refreshToken);
    return data.token;
  } catch {
    clearTokens();
    return null;
  }
}

/**
 * Core fetch wrapper with auth and auto-refresh
 * @param {string} endpoint - e.g. '/user/profile'
 * @param {object} options - fetch options (method, body, headers, etc.)
 * @param {boolean} isFormData - if true, don't set Content-Type (let browser handle multipart)
 * @returns {Promise<any>} parsed JSON response
 */
export async function apiFetch(endpoint, options = {}, isFormData = false) {
  const { token } = getTokens();
  const url = `${API_BASE_URL}${endpoint}`;

  const headers = { ...options.headers };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  if (!isFormData && !headers['Content-Type']) {
    headers['Content-Type'] = 'application/json';
  }

  let res = await fetch(url, { ...options, headers });

  // If 401, attempt token refresh and retry once
  if (res.status === 401 && token) {
    const newToken = await refreshAccessToken();
    if (newToken) {
      headers['Authorization'] = `Bearer ${newToken}`;
      res = await fetch(url, { ...options, headers });
    } else {
      // Refresh failed — clear tokens and redirect to login
      clearTokens();
      window.location.href = '/login';
      throw new Error('Session expired. Please login again.');
    }
  }

  // Parse response
  const contentType = res.headers.get('content-type') || '';
  let data;
  if (contentType.includes('application/json')) {
    data = await res.json();
  } else {
    data = await res.text();
  }

  if (!res.ok) {
    const message = typeof data === 'object' ? data.message || JSON.stringify(data) : data;
    throw new Error(message || `Request failed with status ${res.status}`);
  }

  return data;
}
