import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { CognitoUser, AuthenticationDetails, CognitoIdToken } from 'amazon-cognito-identity-js';
import { userPool } from './SignUp'; // Import the Cognito user pool from SignUp.js
import './Login.css';

const Login = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errorMessage, setErrorMessage] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
  
    const authenticationData = {
      Username: email,
      Password: password,
    };
    const authenticationDetails = new AuthenticationDetails(authenticationData);
  
    const userData = {
      Username: email,
      Pool: userPool,
    };
    const cognitoUser = new CognitoUser(userData);
  
    cognitoUser.authenticateUser(authenticationDetails, {
      onSuccess: (result) => {

  
        const accessToken = result.getAccessToken().getJwtToken();
        localStorage.setItem('accessToken', accessToken);
        
        // Fetch user attributes
        cognitoUser.getUserAttributes((err, attributes) => {
          if (err) {
            console.error('Failed to get user attributes:', err);
            return;
          }
  
          // Find the 'name' attribute
          const nameAttribute = attributes.find(attr => attr.getName() === 'name');
          if (nameAttribute) {
            const name = nameAttribute.getValue();
            localStorage.setItem('username', name); // Store name in localStorage
          }
  
          // Redirect to CourseList
          navigate('/');
          window.location.reload();
        });
      },
      onFailure: (err) => {
        console.error('Login failed:', err);
        setErrorMessage('로그인 실패: ' + err.message);
      },
    });
  };

  return (
    <div className="login-container">
      <form className="login-form" onSubmit={handleSubmit}>
        <h2>Login</h2>
        {errorMessage && <p className="error-message">{errorMessage}</p>} {/* Error message */}
        <div className="form-group">
          <label htmlFor="email">Email</label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="password">Password</label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <button type="submit" className="login-btn">Login</button>
        <p className="signup-link">
          Don't have an account? <a href="/signup">Sign up</a>
        </p>
      </form>
    </div>
  );
};

export default Login;