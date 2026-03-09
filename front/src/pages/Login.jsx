import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Link, useNavigate } from 'react-router-dom';
import { userApi } from '../api/user';

const Login = () => {
  const [formData, setFormData] = useState({ email: '', password: '' });
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      const response = await userApi.login(formData);
      localStorage.setItem('token', response.access_token);
      localStorage.setItem('user', JSON.stringify(response.user));
      navigate('/');
      window.location.reload();
    } catch (err) {
      if (!err.response) {
        // 서버가 꺼져 있거나 인터넷 연결이 안 된 경우
        setError('서버와 연결할 수 없습니다. 백엔드 서버가 켜져 있는지 확인해 주세요.');
      } else if (err.response.status === 401) {
        setError('이메일 또는 비밀번호가 일치하지 않습니다.');
      } else if (err.response.status === 404) {
        setError('존재하지 않는 사용자 계정입니다.');
      } else if (err.response.status >= 500) {
        setError('서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
      } else {
        setError(err.response.data?.detail || '로그인 중 알 수 없는 오류가 발생했습니다.');
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="auth-page container">
      <motion.div 
        className="auth-card glass"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <div className="auth-header">
          <h1 className="auth-title">Welcome Back</h1>
          <p className="auth-subtitle">Continue your professional journey with P6IX</p>
        </div>

        <form onSubmit={handleSubmit} className="auth-form">
          {error && <div className="error-message">{error}</div>}
          
          <div className="form-group">
            <label>Email Address</label>
            <input 
              type="email" 
              name="email"
              placeholder="name@company.com" 
              value={formData.email}
              onChange={handleChange}
              required 
            />
          </div>

          <div className="form-group">
            <label>Password</label>
            <input 
              type="password" 
              name="password"
              placeholder="••••••••" 
              value={formData.password}
              onChange={handleChange}
              required 
            />
          </div>

          <button type="submit" className="primary-btn auth-btn" disabled={isLoading}>
            {isLoading ? 'Signing In...' : 'Sign In'}
          </button>
        </form>

        <div className="auth-footer">
          <p>Don't have an account? <Link to="/signup">Create Account</Link></p>
        </div>
      </motion.div>

      <style>{`
        .auth-page {
          height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          padding-top: 80px;
        }
        .auth-card {
          width: 100%;
          max-width: 450px;
          padding: 3rem;
          border-radius: 24px;
          border: 1px solid var(--border-glass);
          background: var(--bg-secondary);
        }
        .auth-header {
          text-align: center;
          margin-bottom: 2.5rem;
        }
        .auth-title {
          font-size: 2.2rem;
          margin-bottom: 0.5rem;
          background: linear-gradient(90deg, var(--primary), #ffffff);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
        }
        .auth-subtitle {
          color: var(--text-muted);
          font-size: 0.95rem;
        }
        .auth-form .form-group {
          margin-bottom: 1.5rem;
        }
        .auth-form label {
          display: block;
          margin-bottom: 0.5rem;
          font-size: 0.9rem;
          color: var(--text-main);
          font-weight: 500;
        }
        .auth-form input {
          width: 100%;
          padding: 0.8rem 1rem;
          border-radius: 12px;
          border: 1px solid var(--border-glass);
          background: var(--bg-main);
          color: var(--text-main);
          font-size: 1rem;
          transition: 0.3s;
        }
        .auth-form input:focus {
          border-color: var(--primary);
          outline: none;
          box-shadow: 0 0 0 2px rgba(212, 175, 55, 0.2);
        }
        .auth-actions {
          display: flex;
          gap: 1rem;
          margin-top: 1.5rem;
        }
        .auth-btn {
          flex: 2;
          padding: 0.9rem;
          font-size: 1rem;
        }
        .test-btn {
          flex: 1;
          padding: 0.9rem;
          border-radius: 50px;
          border: 1px solid var(--primary);
          background: transparent;
          color: var(--primary);
          font-weight: 600;
          cursor: pointer;
          transition: 0.3s;
          font-size: 0.9rem;
        }
        .test-btn:hover {
          background: rgba(212, 175, 55, 0.1);
          transform: translateY(-2px);
        }
        .error-message {
          background: rgba(255, 71, 71, 0.1);
          color: #ff4747;
          padding: 0.8rem;
          border-radius: 12px;
          margin-bottom: 1.5rem;
          font-size: 0.85rem;
          text-align: center;
          border: 1px solid rgba(255, 71, 71, 0.2);
        }
        .auth-footer {
          margin-top: 2rem;
          text-align: center;
          font-size: 0.9rem;
          color: var(--text-muted);
        }
        .auth-footer a {
          color: var(--primary);
          text-decoration: none;
          font-weight: 600;
        }
        .auth-footer a:hover {
          text-decoration: underline;
        }
      `}</style>
    </div>
  );
};

export default Login;
