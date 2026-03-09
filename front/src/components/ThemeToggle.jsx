import React from 'react';
import { useTheme } from '../context/ThemeContext';

const ThemeToggle = () => {
  const { theme, toggleTheme } = useTheme();

  return (
    <button className="theme-toggle" onClick={toggleTheme}>
      <div className={`icon-container ${theme}`}>
        <div className="icon-main"></div>
        <div className="stars"></div>
      </div>
      <style>{`
        .theme-toggle {
          background: var(--glass);
          border: 1px solid var(--border-glass);
          width: 60px;
          height: 30px;
          border-radius: 20px;
          cursor: pointer;
          position: relative;
          overflow: hidden;
          transition: 0.4s;
          display: flex;
          align-items: center;
          padding: 3px;
        }

        .icon-container {
          width: 24px;
          height: 24px;
          border-radius: 50%;
          transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
          display: flex;
          align-items: center;
          justify-content: center;
          position: relative;
        }

        .icon-container.dark {
          transform: translateX(30px);
          background: white;
          box-shadow: 0 0 10px white;
        }

        .icon-container.light {
          transform: translateX(0px);
          background: #ffcc33;
          box-shadow: 0 0 10px #ffcc33;
        }

        .icon-main {
          width: 100%;
          height: 100%;
          border-radius: 50%;
          position: absolute;
        }

        .icon-container.dark::after {
          content: '';
          position: absolute;
          width: 18px;
          height: 18px;
          border-radius: 50%;
          background: var(--bg-main);
          top: -2px;
          right: -4px;
          transition: 0.4s;
        }

        .theme-toggle:hover {
          background: rgba(192, 161, 114, 0.1);
          border-color: var(--primary);
        }
      `}</style>
    </button>
  );
};

export default ThemeToggle;
