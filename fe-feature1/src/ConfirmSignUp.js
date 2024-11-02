import React, { useState } from 'react';
import { CognitoUser } from 'amazon-cognito-identity-js';
import { userPool } from './SignUp'; // Import the same userPool used in signup
import { useNavigate } from 'react-router-dom'; // Import useNavigate

import './ConfirmSignUp.css'; // Import the confirm signup CSS

const ConfirmSignUp = () => {
  const navigate = useNavigate(); // Initialize useNavigate
  const [email, setEmail] = useState('');
  const [confirmationCode, setConfirmationCode] = useState('');
  const [errorMessage, setErrorMessage] = useState('');

  const handleConfirm = (e) => {
    e.preventDefault(); // Prevent default form submission
    setErrorMessage(''); // Reset any previous error messages

    const userData = {
      Username: email,
      Pool: userPool,
    };
    const cognitoUser = new CognitoUser(userData);

    cognitoUser.confirmRegistration(confirmationCode, true, function(err, result) {
      if (err) {
        setErrorMessage('확인 실패: ' + err.message); // Display error message
        return;
      }
      alert('이메일 확인 완료!'); // Successful confirmation alert
      navigate('/login'); // Redirect to the login page

    });
  };

  return (
    <div className="confirm-container">
      <form className="confirm-form" onSubmit={handleConfirm}>
        <h2>Confirm Your Signup</h2>
        {errorMessage && <div className="error-message">{errorMessage}</div>} {/* Error message display */}
        <div className="form-group">
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Email"
            required
          />
        </div>
        <div className="form-group">
          <input
            type="text"
            value={confirmationCode}
            onChange={(e) => setConfirmationCode(e.target.value)}
            placeholder="Confirmation Code"
            required
          />
        </div>
        <button type="submit" className="confirm-btn">Confirm</button>
      </form>
    </div>
  );
};

export default ConfirmSignUp;