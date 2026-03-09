import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { courseApi } from '../api/course';

const Home = () => {
   const [courses, setCourses] = useState([]);
   const [loading, setLoading] = useState(true);

   useEffect(() => {
      const getCourses = async () => {
         try {
            const data = await courseApi.getAllCourses();
            setCourses(data);
         } catch (err) {
            console.error("Failed to load courses:", err);
         } finally {
            setLoading(false);
         }
      };
      getCourses();
   }, []);

  return (
    <div className="home-page">
      <section className="hero">
        <div className="hero-overlay"></div>
        <motion.div 
          className="container hero-content"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
        >
          <span className="badge">Premium Construction Education</span>
          <h1 className="hero-title">
            Master Primavera <br />
            <span>Project Management</span>
          </h1>
          <p className="hero-desc">
            Experience the standard of P6IX. Specialized high-level 
            curriculum for construction industry experts.
          </p>
          <div className="hero-actions">
            <button className="primary-btn">Start Learning</button>
            <button className="secondary-btn">Curriculum</button>
          </div>
        </motion.div>
      </section>

      <section className="featured-section container">
         <h2 className="section-title">Latest Lectures</h2>
         {loading ? (
            <div className="loading-state">Loading premium contents...</div>
         ) : (
            <div className="course-grid">
               {courses.map(course => (
                  <motion.div 
                     className="course-card" 
                     key={course.id}
                     initial={{ opacity: 0, scale: 0.9 }}
                     whileInView={{ opacity: 1, scale: 1 }}
                     viewport={{ once: true }}
                   >
                     <div 
                        className="card-thumb" 
                        style={{ 
                           backgroundImage: `url(${course.thumbnail_url})`,
                           backgroundSize: 'cover',
                           backgroundPosition: 'center'
                        }}
                     ></div>
                     <div className="card-info">
                        <h3>{course.title}</h3>
                        <p>{course.level} Level Professional Course</p>
                        <div className="card-meta">
                           <span className="price">{course.price === 0 ? 'FREE' : `₩${course.price.toLocaleString()}`}</span>
                           <span className="instructor">{course.instructor_id}</span>
                        </div>
                     </div>
                  </motion.div>
               ))}
            </div>
         )}
      </section>

      <style>{`
        .hero {
          height: 90vh;
          position: relative;
          display: flex;
          align-items: center;
          justify-content: center;
          background: linear-gradient(135deg, var(--bg-main) 0%, var(--bg-secondary) 100%);
          overflow: hidden;
        }
        .hero-overlay {
          position: absolute;
          width: 50%; height: 50%;
          background: radial-gradient(circle, rgba(192, 161, 114, 0.1) 0%, transparent 70%);
          top: -10%; left: -10%;
          filter: blur(80px);
        }
        .hero-content {
          position: relative;
          z-index: 2;
          text-align: center;
        }
        .badge {
          display: inline-block;
          padding: 0.4rem 1rem;
          background: rgba(192, 161, 114, 0.1);
          color: var(--primary);
          border-radius: 50px;
          font-weight: 600;
          font-size: 0.85rem;
          margin-bottom: 1.5rem;
          border: 1px solid rgba(192, 161, 114, 0.2);
        }
        .hero-title {
          font-size: clamp(2.5rem, 6vw, 4.5rem);
          font-weight: 700;
          line-height: 1.1;
          margin-bottom: 1.5rem;
          color: var(--text-main);
        }
        .hero-title span {
          background: linear-gradient(90deg, #c0a172, #e0c8a1);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
        }
        .hero-desc {
          max-width: 600px;
          margin: 0 auto 2.5rem;
          color: var(--text-muted);
          font-size: 1.1rem;
          line-height: 1.6;
        }
        .hero-actions {
          display: flex;
          gap: 1.2rem;
          justify-content: center;
        }
        .primary-btn {
          padding: 1rem 2.5rem;
          background: var(--primary);
          color: white; /* Contrast for both themes might vary, but gold/white is premium */
          border: none;
          border-radius: 50px;
          font-weight: 700;
          font-size: 1rem;
          cursor: pointer;
          transition: 0.3s;
        }
        [data-theme='light'] .primary-btn { color: #ffffff; }

        .primary-btn:hover {
          transform: translateY(-3px);
          box-shadow: 0 10px 25px rgba(192, 161, 114, 0.4);
        }
        .secondary-btn {
          padding: 1rem 2.5rem;
          background: var(--glass);
          color: var(--text-main);
          border: 1px solid var(--border-glass);
          border-radius: 50px;
          cursor: pointer;
          transition: 0.3s;
        }
        .section-title {
          margin-top: 5rem;
          font-size: 2rem;
          margin-bottom: 2rem;
          border-left: 4px solid var(--primary);
          padding-left: 1rem;
          color: var(--text-main);
        }
        .course-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
          gap: 2rem;
          padding-bottom: 8rem;
        }
        .course-card {
          background: var(--bg-secondary);
          border-radius: 12px;
          overflow: hidden;
          transition: 0.3s;
          cursor: pointer;
          box-shadow: 0 4px 20px var(--shadow);
        }
        .course-card:hover {
          transform: translateY(-8px);
          border-color: var(--primary);
        }
        .card-thumb {
          height: 180px;
          background: var(--bg-secondary);
          filter: brightness(1.2);
        }
        .card-info {
          padding: 1.5rem;
        }
        .card-info h3 { margin-bottom: 0.5rem; color: var(--text-main); }
        .card-info p { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem; }
        .card-meta {
           display: flex;
           justify-content: space-between;
           color: var(--primary);
           font-weight: 600;
        }
      `}</style>
    </div>
  );
};

export default Home;
