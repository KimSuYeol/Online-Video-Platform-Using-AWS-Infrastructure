import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Header.css';
import logoImage from './assets/images/logo.png';
import userImage from './assets/images/image.webp'; // Replace with your image path

const Header = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const [username, setUsername] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('accessToken');
    if (token) {
      setIsAuthenticated(true);
      setUsername(localStorage.getItem('username') || 'User');
    } else {
      setIsAuthenticated(false);
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('username');
    setIsAuthenticated(false);
    navigate('/login');
  };

  const toggleDropdown = () => {
    setIsDropdownOpen(!isDropdownOpen);
  };

  return (
    <header className="header">
      <div className="logo">
        <a href="/">
          <img src={userImage} alt="Logo" style={{ width: '50px', height: 'auto', marginLeft: '20px', borderRadius: '80%' }} />
        </a>
      </div>
      <nav className="nav-links">
        <ul>
          {/* <li><a href="/">Home</a></li> */}
          {!isAuthenticated && (
            <>
              <li><a href="/chat">방송실</a></li>
              <li><a href="/login">Login</a></li>
              <li><a href="/signup">Sign Up</a></li>
            </>
          )}
          {isAuthenticated && (
            <>
              <li><a href="/chat">방송실</a></li>
              <li><a href="/courseList">CourseList</a></li>
              <li>
                <button onClick={toggleDropdown} className="user-dropdown-button">
                <i className="material-icons" style={{ fontSize: '24px', cursor: 'pointer' }}>menu</i>
                </button>
                {isDropdownOpen && (
                  <div className="dropdown-menu">
                    <p style={{

                      fontSize: '1.2rem',
                      fontWeight: '500',
                      color: '#111111',
                      display: 'inline-flex',
                      alignItems: 'center',
                      fontFamily: '"Roboto", sans-serif'}}>
                        <span style={{ fontSize: '1.5rem', marginRight: '5px' }}>✏️</span> {username}님
                        </p>
                        <br></br>
                    <button onClick={handleLogout} className="logout-button">Logout</button>
                  </div>
                )}
              </li>
            </>
          )}
        </ul>
      </nav>
    </header>
  );
};

export default Header;