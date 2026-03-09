import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Link, useNavigate } from 'react-router-dom';
import { userApi } from '../api/user';

const Signup = () => {
  const [formData, setFormData] = useState({ 
    email: '', 
    password: '', 
    confirmPassword: '', 
    name: '' 
  });
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    // 비밀번호 확인 로직
    if (formData.password !== formData.confirmPassword) {
      setError('비밀번호가 일치하지 않습니다.');
      return;
    }

    setIsLoading(true);

    try {
      const response = await userApi.signup({
        email: formData.email,
        password: formData.password,
        name: formData.name
      });
      navigate('/login');
      alert('P6IX에 오신 것을 환영합니다! 로그인을 진행해 주세요.');
    } catch (err) {
      if (!err.response) {
        setError('서버와 연결할 수 없습니다. 백엔드 서버가 구동 중인지 확인해 주세요.');
      } else if (err.response.status === 400) {
        setError(err.response.data?.detail || '이미 등록된 이메일이거나 입력 형식이 올바르지 않습니다.');
      } else if (err.response.status >= 500) {
        setError('서버 내부 오류가 발생했습니다. 잠시 후 상의해 주세요.');
      } else {
        setError(err.response.data?.detail || '회원가입 중 알 수 없는 오류가 발생했습니다.');
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
          <h1 className="auth-title">Create Account</h1>
          <p className="auth-subtitle">Join the P6IX construction professional community</p>
        </div>

        <form onSubmit={handleSubmit} className="auth-form">
          {error && <div className="error-message">{error}</div>}
          
          <div className="form-group">
            <label>Full Name</label>
            <input 
              type="text" 
              name="name"
              placeholder="Your Name" 
              value={formData.name}
              onChange={handleChange}
              required 
            />
          </div>

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
              placeholder="At least 8 characters" 
              value={formData.password}
              onChange={handleChange}
              required 
              minLength={4}
              maxLength={100}
            />
          </div>

          <div className="form-group">
            <label>Confirm Password</label>
            <input 
              type="password" 
              name="confirmPassword"
              placeholder="Repeat your password" 
              value={formData.confirmPassword}
              onChange={handleChange}
              required 
              maxLength={100}
            />
          </div>

          <button type="submit" className="primary-btn auth-btn" disabled={isLoading}>
            {isLoading ? 'Creating Account...' : 'Sign Up Free'}
          </button>
        </form>

        <div className="auth-footer">
          <p>Already have an account? <Link to="/login">Sign In Instead</Link></p>
        </div>
      </motion.div>

      <style>{`
        /* 스타일은 Login.jsx와 공유하거나 동일한 디자인 시스템을 사용합니다. */
        /* auth-page, auth-card 등 상단 스타일은 로그인과 동일하므로 생략하거나 필요한 부분만 직접 명시 가능 */
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
          margin-bottom: 1.2rem;
        }
        .auth-form label {
          display: block;
          margin-bottom: 0.4rem;
          font-size: 0.85rem;
          color: var(--text-main);
          font-weight: 500;
        }
        .auth-form input {
          width: 100%;
          padding: 0.75rem 1rem;
          border-radius: 12px;
          border: 1px solid var(--border-glass);
          background: var(--bg-main);
          color: var(--text-main);
          font-size: 0.95rem;
          transition: 0.3s;
        }
        .auth-form input:focus {
          border-color: var(--primary);
          outline: none;
        }
        .auth-btn {
          width: 100%;
          margin-top: 1rem;
          padding: 0.9rem;
          font-size: 1rem;
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
          margin-top: 1.5rem;
          text-align: center;
          font-size: 0.9rem;
          color: var(--text-muted);
        }
        .auth-footer a {
          color: var(--primary);
          text-decoration: none;
          font-weight: 600;
        }
      `}</style>
    </div>
  );
};

export default Signup;
