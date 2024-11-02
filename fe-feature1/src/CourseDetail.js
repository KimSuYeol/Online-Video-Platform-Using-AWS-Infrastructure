import React, { useEffect, useRef, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import axios from 'axios';
import videojs from 'video.js';
import 'video.js/dist/video-js.css'; // video.js 기본 스타일
import 'videojs-hls-quality-selector'; // HLS Quality Selector 플러그인
import './CourseDetail.css';

const CourseDetail = () => {
  const { id } = useParams(); // URL에서 강의 ID를 가져옴
  const [course, setCourse] = useState(null);
  const navigate = useNavigate();
  const videoRef = useRef(null); // 비디오 요소를 참조하는 변수
  const playerRef = useRef(null); // video.js 플레이어 참조

  useEffect(() => {
    const fetchCourseDetails = async () => {
      try {
        const response = await axios.get(`https://api.chuno.store/videos/${id}`, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem('accessToken')}`,
          },
        });
        setCourse(response.data);
      } catch (error) {
        console.error('Error fetching course details:', error);
        navigate('/'); // 오류 발생 시 강의 목록으로 이동
      }
    };

    fetchCourseDetails();

    return () => {
      if (playerRef.current) {
        playerRef.current.dispose(); // 컴포넌트 언마운트 시 플레이어 제거
      }
    };
  }, [id, navigate]);

  useEffect(() => {
    if (course && videoRef.current) {
      // video.js 플레이어 초기화
      playerRef.current = videojs(videoRef.current, {
        controls: true,
        autoplay: false,
        preload: 'auto',
        sources: [
          {
            src: course.file_url, // m3u8 파일 URL
            type: 'application/x-mpegURL',
          },
        ],
      });

      // HLS Quality Selector 초기화
      playerRef.current.hlsQualitySelector({
        displayCurrentQuality: true,
      });
    }
  }, [course]);

  if (!course) {
    return <div>Loading...</div>; // 데이터가 로드되지 않았을 때 로딩 메시지 표시
  }

  return (
    <div className="course-detail-container">
      <h2 className="course-detail-title">{course.title}</h2>
      {/* <img src={course.thumbnail_path} alt={`${course.title} thumbnail`} className="course-detail-thumbnail" /> */}
      
      <p className="course-detail-description">description: {course.description}</p>
      
      <div className="course-detail-info">
        <span>Uploader: {course.uploader}</span>
        <br></br>
        <span>Date: {new Date(course.timestamp).toLocaleDateString()}</span>
      </div>

      

      {/* 비디오.js 플레이어 */}
      <div className="video-player-container">
        <video
          ref={videoRef} // video.js 플레이어 초기화를 위한 참조
          className="video-js vjs-default-skin"
          controls
          preload="auto"
          width="544"
          height="306"
          id="my-video" // 플레이어 ID 추가
        />
      </div>


      {/* 파일 URL 링크 표시 */}
      <div className="course-detail-file">
        <a href={course.file_url} target="_blank" rel="noopener noreferrer" className="download-link">
          Download File
        </a>
      </div>
    </div>
  );
};

export default CourseDetail;