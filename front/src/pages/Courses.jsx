import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { courseApi } from '../api/course';

const Courses = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCourses = async () => {
      try {
        const data = await courseApi.getAllCourses();
        setCourses(data);
      } catch (err) {
        console.error("Failed to fetch courses:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchCourses();
  }, []);

  return (
    <div className="courses-page container">
      <header className="page-header">
        <h1 className="page-title">All Premium Courses</h1>
        <p className="page-subtitle">Master your skills with P6IX professional curriculum</p>
      </header>

      {loading ? (
        <div className="loading">Loading premium lectures...</div>
      ) : (
        <div className="course-grid">
          {courses.map((course, index) => (
            <motion.div
              key={course.id}
              className="course-card card glass"
              whileHover={{ y: -10 }}
            >
              <Link to={`/course/${course.id}`} className="card-link-wrapper">
                <div className="card-header">
                  <img src={course.thumbnail_url} alt={course.title} />
                  <div className="card-overlay">
                    <span className="play-icon">▶</span>
                  </div>
                </div>
              </Link>
              <div className="card-info">
                <span className="badge-small">{course.level}</span>
                <h3>{course.title}</h3>
                <div className="card-footer">
                  <span className="price">{course.price === 0 ? 'FREE' : `$${course.price}`}</span>
                  <Link to={`/course/${course.id}`} className="view-link">View More</Link>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      <style>{`
        .courses-page {
          padding-top: 120px;
          min-height: 100vh;
        }
        .page-header {
          margin-bottom: 4rem;
          text-align: center;
        }
        .page-title {
          font-size: 3rem;
          margin-bottom: 1rem;
          background: linear-gradient(90deg, var(--primary), #ffffff);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
        }
        .page-subtitle {
          color: var(--text-muted);
          font-size: 1.1rem;
        }
        .course-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
          gap: 2.5rem;
          padding-bottom: 5rem;
        }
        .course-card {
          background: var(--bg-secondary);
          border-radius: 16px;
          overflow: hidden;
          transition: 0.3s;
          border: 1px solid var(--border-glass);
          box-shadow: 0 10px 30px var(--shadow);
        }
        .course-card:hover {
          transform: translateY(-10px);
          border-color: var(--primary);
        }
        .card-thumb {
          height: 180px;
          background-size: cover;
          background-position: center;
        }
        .card-info {
          padding: 1.5rem;
        }
        .badge-small {
          font-size: 0.75rem;
          color: var(--primary);
          text-transform: uppercase;
          letter-spacing: 1px;
          font-weight: 700;
          margin-bottom: 0.5rem;
          display: block;
        }
        .card-info h3 {
          font-size: 1.3rem;
          margin-bottom: 1.5rem;
          line-height: 1.4;
          height: 3.6rem;
          overflow: hidden;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          color: var(--text-main);
        }
        .card-meta {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .price {
          font-size: 1.2rem;
          font-weight: 700;
          color: var(--primary);
        }
        .view-btn {
          background: var(--glass);
          border: 1px solid var(--border-glass);
          color: var(--text-main);
          padding: 0.5rem 1.2rem;
          border-radius: 50px;
          cursor: pointer;
          transition: 0.3s;
        }
        .view-btn:hover {
          background: var(--primary);
          color: black;
          border-color: var(--primary);
        }
        .loading {
          text-align: center;
          font-size: 1.5rem;
          color: var(--text-muted);
          padding: 5rem;
        }
      `}</style>
    </div>
  );
};

export default Courses;
