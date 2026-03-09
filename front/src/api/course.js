import api from './api';

export const courseApi = {
  // GET /api/courses/
  getAllCourses: () => api.get('/courses/'),
  
  // GET /api/courses/{id}/
  getCourseDetail: (id) => api.get(`/courses/${id}/`),
  
  // POST /api/courses/
  createCourse: (data) => api.post('/courses/', data),
};

export default courseApi;
