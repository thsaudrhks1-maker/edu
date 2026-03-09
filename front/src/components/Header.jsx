import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Link, useNavigate } from 'react-router-dom';
import ThemeToggle from './ThemeToggle';
import { userApi } from '../api/user';

const Header = () => {
  const [user, setUser] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const savedUser = localStorage.getItem('user');
    if (savedUser) {
      setUser(JSON.parse(savedUser));
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setUser(null);
    navigate('/');
    window.location.reload();
  };

  const handleTestLogin = async () => {
    try {
      const response = await userApi.login({ email: 'w@w.w', password: '00000000' });
      localStorage.setItem('token', response.access_token);
      localStorage.setItem('user', JSON.stringify(response.user));
      window.location.reload();
    } catch (err) {
      alert('테스트 계정(w@w.w)이 없습니다. 먼저 가입해주세요.');
    }
  };
  return (
    <header className="header glass">
      <div className="container header-content">
        <Link to="/" className="logo">
          P6<span>IX</span>
        </Link>
        <nav className="nav">
          <Link to="/" className="nav-link active">Home</Link>
          <Link to="/courses" className="nav-link">Courses</Link>
          <Link to="/about" className="nav-link">About</Link>
          {!user && (
            <button className="test-sign-btn" onClick={handleTestLogin}>
              Quick Test
            </button>
          )}
          <ThemeToggle />
          {user ? (
            <div className="auth-status">
              <span className="user-name">{user.name}</span>
              <button 
                className="signin-btn logout-btn" 
                onClick={handleLogout}
              >
                Logout
              </button>
            </div>
          ) : (
            <Link to="/login" className="signin-btn">Sign In</Link>
          )}
        </nav>
      </div>

      <style>{`
        .header {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          z-index: 1000;
          padding: 1rem 0;
          backdrop-filter: blur(10px);
          border-bottom: 1px solid var(--border-glass);
        }
        .header-content {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .logo {
          font-size: 1.8rem;
          font-weight: 800;
          color: var(--primary);
          text-decoration: none;
          letter-spacing: -1px;
        }
        .nav {
          display: flex;
          align-items: center;
          gap: 2rem;
        }
        .nav-link {
          text-decoration: none;
          color: var(--text-main);
          font-weight: 500;
          font-size: 0.95rem;
          transition: 0.3s;
          opacity: 0.8;
        }
        .nav-link:hover {
          color: var(--primary);
          opacity: 1;
        }
        .test-sign-btn {
          background: transparent;
          color: var(--primary);
          border: 1px dashed var(--primary);
          padding: 0.5rem 0.8rem;
          border-radius: 8px;
          cursor: pointer;
          font-size: 0.75rem;
          font-weight: 600;
          transition: 0.3s;
          white-space: nowrap;
        }
        .test-sign-btn:hover {
          background: rgba(212, 175, 55, 0.1);
          transform: translateY(-1px);
        }
        .signin-btn {
          background: var(--primary);
          color: black;
          border: none;
          padding: 0.6rem 1.8rem;
          border-radius: 50px;
          font-weight: 700;
          cursor: pointer;
          transition: 0.3s;
          text-decoration: none;
          font-size: 0.9rem;
        }
        .signin-btn:hover {
          transform: scale(1.05);
          box-shadow: 0 0 20px rgba(212, 175, 55, 0.4);
        }
        .auth-status {
          display: flex;
          align-items: center;
          gap: 1.2rem;
        }
        .user-name {
          color: var(--text-main);
          font-size: 0.95rem;
          font-weight: 600;
          border-right: 1px solid var(--border-glass);
          padding-right: 1.2rem;
        }
        .logout-btn {
          background: var(--glass);
          color: var(--text-main);
          border: 1px solid var(--border-glass);
        }
        .logout-btn:hover {
          background: #ff4747;
          color: white;
          border-color: #ff4747;
          box-shadow: 0 0 20px rgba(255, 71, 71, 0.3);
        }
      `}</style>
    </header>
  );
};

export default Header;
