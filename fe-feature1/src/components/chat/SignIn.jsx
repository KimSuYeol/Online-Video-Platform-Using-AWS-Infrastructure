// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

import React, { useState, createRef, useEffect } from "react";
import Avatars from "./Avatars";

const SignIn = ({ handleSignIn }) => {
  const [username, setUsername] = useState("");
  const [moderator, setModerator] = useState(false);
  const [avatar, setAvatar] = useState({});
  const [loaded, setLoaded] = useState(false);
  const inputRef = createRef();

  useEffect(() => {
    setLoaded(true);
    inputRef.current.focus();
  }, [loaded]); // eslint-disable-line

  // Check if username is stored in localStorage
  useEffect(() => {
    const storedUsername = localStorage.getItem('username');
    if (storedUsername) {
      setUsername(storedUsername);
    }
  }, []);

  const handleModeratorChange = (e) => {
    if (!username) {
      alert('회원만 매니저로 입장을 선택할 수 있습니다');
      setModerator(false); // Reset the checkbox if user is not logged in
    } else {
      setModerator(e.target.checked);
    }
  };

  return (
    <div className="modal pos-absolute top-0 bottom-0">
      <div className="modal__el">
        <h1 className="mg-b-2">채팅방 입장</h1>
        <form onSubmit={(e) => { e.preventDefault(); }}>
          <fieldset>
            <label htmlFor="name" className="mg-b-05">
              Nickname
            </label>
            <input
              name="name"
              id="name"
              ref={inputRef}
              type="text"
              className="radius"
              placeholder="채팅에 사용할 닉네임"
              autoComplete="off"
              value={username}
              onChange={(e) => {
                e.preventDefault();
                setUsername(e.target.value);
                localStorage.setItem('username', e.target.value); // Save username to localStorage
              }}
            />
            <hr />
            <div className="mg-b-05 label">Select Avatar</div>
            <div className="item-select-container pd-1 mg-b-1">
              <div className="avatars pos-relative item-select-grid">
                <Avatars
                  currentAvatar={avatar?.name}
                  handleAvatarClick={(avatar) => {
                    setAvatar(avatar);
                  }}
                />
              </div>
            </div>
            <hr />
            <div className="fl fl-a-center fl-j-start full-width">
              <input
                type="checkbox"
                id="moderator"
                name="moderator"
                className="mg-l-0 mg-r-1"
                checked={moderator}
                onChange={handleModeratorChange} // Use the new handler
              />
              <label htmlFor="moderator">매니저로 입장</label>
            </div>
            <hr />
            <button
              onClick={(e) => {
                handleSignIn(username, moderator, avatar);
              }}
              className="btn btn--primary rounded mg-t-1"
              disabled={!username}
            >
              채팅 시작
            </button>
          </fieldset>
        </form>
      </div>
      <div className="modal__overlay"></div>
    </div>
  );
};

export default SignIn;