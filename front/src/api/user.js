import api from './api';

export const userApi = {
  // POST /api/user/signup/
  signup: (userData) => api.post('/user/signup/', userData),
  
  // POST /api/user/login/
  login: (credentials) => api.post('/user/login/', credentials),
  
  // GET /api/user/profile/
  getProfile: () => api.get('/user/profile/'),
};

export default userApi;
