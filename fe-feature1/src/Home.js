import React, { useEffect, useState } from 'react';
import './Home.css';

const Home = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const name = localStorage.getItem('username');

  useEffect(() => {
    // JWT 토큰 확인
    const token = localStorage.getItem('accessToken');
    if (token) {
      setIsAuthenticated(true);
    } else {
      setIsAuthenticated(false);
    }
  }, []);

  return (
    <div className="home-container">
      <section className="hero">
        <div className="hero-text">
          {/* <h1>추노</h1> */}
          
          {!isAuthenticated && ( // 로그인 안된 상태에서만 표시
            <>
              {/* <a href="/login" className="cta-btn">로그인</a>
              <a href="/signup" className="cta-btn">회원가입</a> */}
            </>
          )}

          {isAuthenticated && ( // 로그인 된 상태에서만 표시
            <>
              {/* {name} */}
            </>
          )}



        </div>
      </section>

      <section className="features">
        <h2>기능</h2>
        <div className="feature-cards">
          <div className="feature-card">
            <h3>강의</h3>
            <p>강의 목록 및 상세 일정 정리</p>
          </div>
          <div className="feature-card">
            <h3>스트리밍</h3>
            <p>실시간 스트리밍 및 녹화</p>
            <p>강의 내용 녹화</p>
          </div>
          <div className="feature-card">
            <h3>추가</h3>
            <p>퀴즈 및 평가</p>
          </div>
        </div>
      </section>

      {/* <section className="footer">
        <p>© 2024 My Website. All rights reserved.</p>
      </section> */}
    </div>
  );
};

export default Home;