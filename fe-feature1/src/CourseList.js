import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import UploadModal from './UploadModal';
import './CourseList.css';

const CourseList = () => {
  const navigate = useNavigate();
  const [courses, setCourses] = useState([]);
  const [filteredCourses, setFilteredCourses] = useState([]); 
  const [isModalOpen, setIsModalOpen] = useState(false); 
  const [viewMode, setViewMode] = useState('all');
  
  const [currentPage, setCurrentPage] = useState(1); // 현재 페이지
  const itemsPerPage = 8; // 페이지당 강의 개수

  useEffect(() => {
    const token = localStorage.getItem('accessToken');
    if (!token) {
      navigate('/login');
    } else {
      fetchCourses();
    }
  }, []);

  const fetchCourses = async () => {
    try {
      const response = await axios.get('https://api.chuno.store/videos/', {
        headers: {
          Authorization: `Bearer ${localStorage.getItem('accessToken')}`,
        },
      });
      const sortedCourses = response.data.items.sort((a, b) => 
        new Date(b.timestamp) - new Date(a.timestamp)
      ); // 최신순 정렬
      setCourses(sortedCourses);
      setFilteredCourses(sortedCourses); // 초기에는 전체 목록을 보여줌
    } catch (error) {
      console.error('Error fetching courses:', error);
    }
  };

  const handleDelete = async (videoId) => {
    const confirmDelete = window.confirm('정말로 이 비디오를 삭제하시겠습니까?');
    if (!confirmDelete) return;

    try {
      await axios.delete(`https://api.chuno.store/videos/${videoId}`, {
        headers: {
          Authorization: `Bearer ${localStorage.getItem('accessToken')}`,
        },
      });
      alert('삭제가 완료되었습니다.');
      fetchCourses();
    } catch (error) {
      console.error('Error deleting video:', error);
      alert('본인의 비디오만 삭제할 수 있습니다.');
    }
  };

  const toggleModal = () => {
    setIsModalOpen((prev) => !prev);
  };

  const handleViewAllCourses = () => {
    setViewMode('all');
    setFilteredCourses(courses);
    setCurrentPage(1); // 페이지를 첫 페이지로 초기화
  };

  const handleViewMyCourses = () => {
    const username = localStorage.getItem('username');
    const myCourses = courses.filter(course => course.uploader === username);
    setViewMode('mine');
    setFilteredCourses(myCourses);
    setCurrentPage(1); // 페이지를 첫 페이지로 초기화
  };

  // 페이지네이션: 현재 페이지에 맞는 강의 목록 반환
  const getPaginatedCourses = () => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    return filteredCourses.slice(startIndex, endIndex);
  };

  const totalPages = Math.ceil(filteredCourses.length / itemsPerPage); // 전체 페이지 수 계산

  return (
    <div className="course-container">
      <h2 className="course-title">🔎 강의 목록</h2>

      <button className="upload-button" onClick={toggleModal}>강의 업로드</button>
      <div className="button-container">
        <button className="view-all-button" onClick={handleViewAllCourses}>전체 강의 목록</button>
        <button className="view-my-button" onClick={handleViewMyCourses}>내 강의 목록</button>
      </div>

      <UploadModal isOpen={isModalOpen} onClose={toggleModal} fetchCourses={fetchCourses} />

      <div className="course-list">
        {getPaginatedCourses().map(course => (
          <div key={course.id} className="course-item" onClick={() => navigate(`/courses/${course.id}`)}> {/* 박스를 클릭했을 때 상세 페이지로 이동 */}
            <img src={course.thumbnail_path} alt={`${course.title} thumbnail`} className="course-thumbnail" />            
            
            <div className="course-info">
              {course.title} {/* Link 태그 제거, 제목을 클릭했을 때 이동하게 수정 */}
              {viewMode === 'mine' && (
                <button onClick={(e) => {e.stopPropagation(); handleDelete(course.id);}}>삭제</button> 
              )}
            </div>
          </div>
        ))}
      </div>

      {/* 페이지네이션 버튼 */}
      <div className="pagination">
        <button 
          onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))} 
          disabled={currentPage === 1}
        >
          이전
        </button>
        <span>{currentPage} / {totalPages}</span>
        <button 
          onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))} 
          disabled={currentPage === totalPages}
        >
          다음
        </button>
      </div>
    </div>
  );
};

export default CourseList;