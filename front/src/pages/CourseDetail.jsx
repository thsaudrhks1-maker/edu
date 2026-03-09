import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { courseApi } from '../api/course';

const CourseDetail = () => {
  const { id } = useParams();
  const [course, setCourse] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchDetail = async () => {
      try {
        const response = await courseApi.getCourseDetail(id);
        console.log('Course Detail received:', response);
        setCourse(response);
      } catch (err) {
        console.error('Failed to fetch course detail', err);
      } finally {
        setIsLoading(false);
      }
    };
    fetchDetail();
  }, [id]);

  if (isLoading) return <div className="container py-20 text-center">Loading Course...</div>;
  if (!course) return <div className="container py-20 text-center">Course not found.</div>;

  // 비디오 소스 분석 (유튜브 ID vs 전체 URL)
  const videoSource = course.video_url; 
  const isYouTube = videoSource && !videoSource.startsWith('http');

  return (
    <div className="course-detail-page container py-20">
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="detail-grid"
      >
        {/* 비디오 구역 */}
        <div className="video-section">
          <div className="card glass video-container">
            <div className="aspect-ratio">
              {isYouTube ? (
                <iframe
                  src={`https://www.youtube.com/embed/${videoSource}?rel=0&modestbranding=1&autoplay=1`}
                  title={course.title}
                  frameBorder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowFullScreen
                ></iframe>
              ) : (
                <video 
                  src={videoSource} 
                  controls 
                  autoPlay 
                  className="raw-video"
                ></video>
              )}
            </div>
          </div>
          {isYouTube && (
            <div className="video-actions">
              <a 
                href={`https://www.youtube.com/watch?v=${videoSource}`} 
                target="_blank" 
                rel="noopener noreferrer"
                className="yt-link-btn"
              >
                <span className="yt-icon">▶</span> Watch on YouTube
              </a>
            </div>
          )}
        </div>

        {/* 정보 구역 */}
        <div className="info-section">
          <div className="info-header">
            <span className="badge">{course.level.toUpperCase()}</span>
            <span className="course-id">#{course.id}</span>
          </div>
          <h1 className="course-title">{course.title}</h1>
          <div className="meta-info">
            <span className="instructor">Instructor: <strong>{course.instructor_id || 'P6IX Team'}</strong></span>
            <span className="price-tag">{course.price === 0 ? 'FREE' : `₩${course.price.toLocaleString()}`}</span>
          </div>
          
          <div className="description-card card glass">
            <h3>Lesson Description</h3>
            <p>{course.description || '강의 설명이 준비 중입니다.'}</p>
          </div>
          
          <Link to="/courses" className="back-link">← Back to Course List</Link>
        </div>
      </motion.div>

      <style>{`
        .detail-grid {
          display: grid;
          grid-template-columns: 2fr 1fr;
          gap: 2rem;
          margin-top: 2rem;
        }
        .video-container {
          margin-bottom: 0;
          border-radius: 16px;
          overflow: hidden;
          border: 1px solid var(--border-glass);
        }
        .aspect-ratio {
          position: relative;
          padding-top: 56.25%; /* 16:9 */
          background: #000;
        }
        .aspect-ratio iframe, .aspect-ratio video {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          border: none;
        }
        .video-actions {
          margin-top: 1rem;
          display: flex;
          justify-content: flex-end;
        }
        .yt-link-btn {
          display: flex;
          align-items: center;
          gap: 0.6rem;
          background: #CC0000;
          color: white;
          padding: 0.6rem 1.2rem;
          border-radius: 10px;
          text-decoration: none;
          font-weight: 600;
          font-size: 0.85rem;
          transition: 0.3s;
          box-shadow: 0 4px 15px rgba(204, 0, 0, 0.2);
        }
        .yt-link-btn:hover {
          background: #FF0000;
          transform: translateY(-2px);
          box-shadow: 0 6px 20px rgba(255, 0, 0, 0.3);
        }
        .yt-icon {
          font-size: 1rem;
        }
        .info-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 0.5rem;
        }
        .course-id {
          color: var(--text-muted);
          font-size: 0.8rem;
          font-family: 'Courier New', Courier, monospace;
          opacity: 0.5;
        }
        .badge {
          display: inline-block;
          background: rgba(212, 175, 55, 0.2);
          color: var(--primary);
          padding: 0.3rem 0.8rem;
          border-radius: 6px;
          font-weight: 700;
          font-size: 0.75rem;
        }
        .course-title {
          font-size: 2.2rem;
          margin-bottom: 1.5rem;
          line-height: 1.2;
          color: var(--text-main);
        }
        .meta-info {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding-bottom: 1.5rem;
          border-bottom: 1px solid var(--border-glass);
          margin-bottom: 2rem;
        }
        .instructor {
          color: var(--text-main);
          font-size: 0.95rem;
        }
        .instructor strong {
          color: var(--primary);
        }
        .price-tag {
          color: var(--primary);
          font-weight: 800;
          font-size: 1.3rem;
        }
        .description-card {
          padding: 2rem;
          margin-bottom: 2rem;
        }
        .description-card h3 {
          margin-bottom: 1rem;
          color: var(--primary);
        }
        .description-card p {
          line-height: 1.6;
          opacity: 0.8;
        }
        .back-link {
          color: var(--primary);
          text-decoration: none;
          font-weight: 600;
          transition: 0.3s;
        }
        .back-link:hover {
          text-decoration: underline;
        }

        @media (max-width: 1024px) {
          .detail-grid {
            grid-template-columns: 1fr;
          }
        }
      `}</style>
    </div>
  );
};

export default CourseDetail;
