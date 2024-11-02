// config.js 

// Amazon IVS Playback URL
// Replace this with your own Amazon IVS Playback URL
export const PLAYBACK_URL = "https://437c9d8f2b60.ap-northeast-2.playback.live-video.net/api/video/v1/ap-northeast-2.339712823683.channel.Py1irGhhw0V3.m3u8";

// Chat websocket address
// The AWS region that your room is created in. For example, `us-west-2`.
export const CHAT_REGION = "ap-northeast-2";

// Chat API URL
// The Amazon IVS Chat backend endpoint. You must deploy the serverless backend to get this value.
export const API_URL = "https://mj6nsig1sc.execute-api.ap-northeast-2.amazonaws.com/Prod/";

// Chat room id (ARN)
export const CHAT_ROOM_ID = "arn:aws:ivschat:ap-northeast-2:339712823683:room/3HERsoRQbTK5";