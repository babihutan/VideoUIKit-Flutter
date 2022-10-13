import 'dart:developer';
import 'dart:typed_data';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/controllers/rtc_token_handler.dart';
import 'package:agora_uikit/controllers/rtm_controller.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_rtc_event_handlers.dart';
import 'package:agora_uikit/models/agora_rtm_channel_event_handler.dart';
import 'package:agora_uikit/models/agora_user.dart';
import 'package:agora_uikit/src/enums.dart';

Future<RtcEngineEventHandler> rtcEngineEventHandler(
  AgoraRtcEventHandlers agoraEventHandlers,
  AgoraRtmChannelEventHandler agoraRtmChannelEventHandler,
  SessionController sessionController,
) async {
  const String tag = "AgoraVideoUIKit";
  return RtcEngineEventHandler(
    // onWarning: (warning) {
    //   agoraEventHandlers.warning?.call(warning);
    // },
    onApiCallExecuted: (error, api, result) {
      agoraEventHandlers.apiCallExecuted?.call(error, api, result);
    },
    onRejoinChannelSuccess: (conn, elapsed) {
      agoraEventHandlers.rejoinChannelSuccess?.call(conn.channelId!, conn.localUid!, elapsed);
    },
    onLocalUserRegistered: (uid, userAccount) {
      agoraEventHandlers.localUserRegistered?.call(uid, userAccount);
    },
    onUserInfoUpdated: (uid, userInfo) {
      agoraEventHandlers.userInfoUpdated?.call(uid, userInfo);
    },
    onClientRoleChanged: (conn, oldRole, newRole) {
      agoraEventHandlers.clientRoleChanged?.call(oldRole, newRole);
    },
    onConnectionStateChanged: (conn, state, reason) {
      agoraEventHandlers.connectionStateChanged?.call(state, reason);
    },
    onNetworkTypeChanged: (conn, type) {
      agoraEventHandlers.networkTypeChanged?.call(type);
    },
    onConnectionLost: (conn) {
      agoraEventHandlers.connectionLost?.call();
    },
    onRequestToken: (conn) {
      agoraEventHandlers.requestToken?.call();
    },
    onAudioVolumeIndication: (conn, speakers, speakerNumber, totalVolume) {
      agoraEventHandlers.audioVolumeIndication?.call(speakers, totalVolume);
    },
    onFirstLocalAudioFramePublished: (conn, elapsed) {
      agoraEventHandlers.firstLocalAudioFrame?.call(elapsed);
    },
    // onFirstLocalVideoFramePublished: (conn, width, height, elapsed) {
    //   agoraEventHandlers.firstLocalVideoFrame?.call(width, height, elapsed);
    // },
    onUserMuteVideo: (conn, uid, muted) {
      agoraEventHandlers.userMuteVideo?.call(uid, muted);
    },
    onVideoSizeChanged: (conn, videoSrcType, uid, width, height, rotation) {
      agoraEventHandlers.videoSizeChanged?.call(uid, width, height, rotation);
    },
    onLocalPublishFallbackToAudioOnly: (isFallbackOrRecover) {
      agoraEventHandlers.localPublishFallbackToAudioOnly
          ?.call(isFallbackOrRecover);
    },
    onRemoteSubscribeFallbackToAudioOnly: (uid, isFallbackOrRecover) {
      agoraEventHandlers.remoteSubscribeFallbackToAudioOnly
          ?.call(uid, isFallbackOrRecover);
    },
    // onAudioRouteChanged: (routing) {
    //   agoraEventHandlers.audioRouteChanged?.call(routing);
    // },
    // onCameraFocusAreaChanged: (x,y,w,h) {
    //   //agoraEventHandlers.cameraFocusAreaChanged?.call(rect);
    // },
    // onCameraExposureAreaChanged: (x,y,w,h) {
    //   //agoraEventHandlers.cameraExposureAreaChanged?.call(rect);
    // },
    // onFacePositionChanged: (imageWidth, imageHeight, vecRectangle, vecDistance, numFaces) {
    //   agoraEventHandlers.facePositionChanged
    //       ?.call(imageWidth, imageHeight, numFaces);
    // },
    onRtcStats: (conn,stats) {
      agoraEventHandlers.rtcStats?.call(stats);
    },
    onLastmileQuality: (quality) {
      agoraEventHandlers.lastmileQuality?.call(quality);
    },
   onNetworkQuality: (conn, uid, txQuality, rxQuality) {
      agoraEventHandlers.networkQuality?.call(uid, txQuality, rxQuality);
    },
    onLastmileProbeResult: (result) {
      agoraEventHandlers.lastmileProbeResult?.call(result);
    },
    onLocalVideoStats: (conn, stats) {
      agoraEventHandlers.localVideoStats?.call(stats);
    },
    onLocalAudioStats: (conn,stats) {
      agoraEventHandlers.localAudioStats?.call(stats);
    },
    onRemoteVideoStats: (conn,stats) {
      agoraEventHandlers.remoteVideoStats?.call(stats);
    },
    onRemoteAudioStats: (conn,stats) {
      agoraEventHandlers.remoteAudioStats?.call(stats);
    },
    onAudioMixingFinished: () {
      agoraEventHandlers.audioMixingFinished?.call();
    },
    onAudioMixingStateChanged: (state, reason) {
      agoraEventHandlers.audioMixingStateChanged?.call(state, reason);
    },
    onAudioEffectFinished: (soundId) {
      agoraEventHandlers.audioEffectFinished?.call(soundId);
    },
    // onRtmpStreamingStateChanged: (url, state, errCode) {
    //   agoraEventHandlers.rtmpStreamingStateChanged?.call(url, state, errCode);
    // },
    onTranscodingUpdated: () {
      agoraEventHandlers.transcodingUpdated?.call();
    },
    // streamInjectedStatus: (url, uid, status) {
    //   agoraEventHandlers.streamInjectedStatus?.call(url, uid, status);
    // },
    onStreamMessage: (RtcConnection conn, int uid, int streamId, Uint8List data, len, sentTs) {
      agoraEventHandlers.streamMessage?.call(uid, streamId, data);
    },
    onStreamMessageError: (conn, uid, streamId, error, missed, cached) {
      agoraEventHandlers.streamMessageError
          ?.call(uid, streamId, error, missed, cached);
    },
    // mediaEngineLoadSuccess: () {
    //   agoraEventHandlers.mediaEngineLoadSuccess?.call();
    // },
    // mediaEngineStartCallSuccess: () {
    //   agoraEventHandlers.mediaEngineStartCallSuccess?.call();
    // },
    onChannelMediaRelayStateChanged: (state, code) {
      agoraEventHandlers.channelMediaRelayStateChanged?.call(state, code);
    },
    onChannelMediaRelayEvent: (code) {
      agoraEventHandlers.channelMediaRelayEvent?.call(code);
    },
    // metadataReceived: (metadata) {
    //   agoraEventHandlers.metadataReceived?.call(metadata);
    // },
    onFirstLocalVideoFramePublished: (conn, elapsed) {
      agoraEventHandlers.firstLocalVideoFramePublished?.call(elapsed);
    },
    // onFirstLocalAudioFramePublished: (elapsed) {
    //   agoraEventHandlers.firstLocalAudioFramePublished?.call(elapsed);
    // },
    onAudioPublishStateChanged:
        (channel, oldState, newState, elapseSinceLastState) {
      agoraEventHandlers.audioPublishStateChanged
          ?.call(channel, oldState, newState, elapseSinceLastState);
    },
    onVideoPublishStateChanged:
        (conn, channel, oldState, newState, elapseSinceLastState) {
      agoraEventHandlers.videoPublishStateChanged
          ?.call(channel, oldState, newState, elapseSinceLastState);
    },
    onAudioSubscribeStateChanged:
        (channel, uid, oldState, newState, elapseSinceLastState) {
      agoraEventHandlers.audioSubscribeStateChanged
          ?.call(channel, uid, oldState, newState, elapseSinceLastState);
    },
    onVideoSubscribeStateChanged:
        (channel, uid, oldState, newState, elapseSinceLastState) {
      agoraEventHandlers.videoSubscribeStateChanged
          ?.call(channel, uid, oldState, newState, elapseSinceLastState);
    },
    onRtmpStreamingEvent: (url, eventCode) {
      agoraEventHandlers.rtmpStreamingEvent?.call(url, eventCode);
    },
    // onUserSuperResolutionEnabled: (uid, enabled, reason) {
    //   agoraEventHandlers.userSuperResolutionEnabled?.call(uid, enabled, reason);
    // },
    onUploadLogResult: (conn, requestId, success, reason) {
      agoraEventHandlers.uploadLogResult?.call(requestId, success, reason);
    },
    onError: (errorCodeType, err) {
      final info = 'onError: $errorCodeType, $err';
      log(info, name: tag, level: Level.error.value);

      agoraEventHandlers.onError?.call(errorCodeType);
    },
    onJoinChannelSuccess: (conn, elapsed) {
      final info = 'onJoinChannel: ${conn.channelId}, uid: ${conn.localUid}';
      log(info, name: tag, level: Level.info.value);
      sessionController.value = sessionController.value.copyWith(localUid: conn.localUid);
      sessionController.value = sessionController.value.copyWith(
        mainAgoraUser: AgoraUser(
          uid: conn.localUid!,
          remote: false,
          muted: sessionController.value.isLocalUserMuted,
          videoDisabled: sessionController.value.isLocalVideoDisabled,
          clientRole: sessionController.value.clientRole,
        ),
      );
      if (sessionController.value.connectionData!.rtmEnabled) {
        rtmMethods(
          agoraRtmChannelEventHandler,
          sessionController,
        );
      }
      agoraEventHandlers.joinChannelSuccess?.call(conn.channelId!, conn.localUid!, elapsed);
    },
    onLeaveChannel: (conn, stats) {
      sessionController.clearUsers();
      agoraEventHandlers.leaveChannel?.call(stats);
    },
    onUserJoined: (conn, uid, elapsed) {
      final info = 'userJoined: $uid';
      log(info, name: tag, level: Level.info.value);
      sessionController.addUser(
        callUser: AgoraUser(
          uid: uid,
        ),
      );

      agoraEventHandlers.userJoined?.call(uid, elapsed);
    },
    onUserOffline: (conn, uid, reason) {
      final info = 'userOffline: $uid , reason: $reason';
      log(info, name: tag, level: Level.info.value);
      sessionController.checkForMaxUser(uid: uid);
      sessionController.removeUser(uid: uid);

      agoraEventHandlers.userOffline?.call(uid, reason);
    },
    onTokenPrivilegeWillExpire: (conn, token) async {
      await getToken(
        tokenUrl: sessionController.value.connectionData!.tokenUrl,
        channelName: sessionController.value.connectionData!.channelName,
        uid: sessionController.value.connectionData!.uid,
        sessionController: sessionController,
      );
      await sessionController.value.engine?.renewToken(token);

      agoraEventHandlers.tokenPrivilegeWillExpire?.call(token);
    },
    onRemoteVideoStateChanged: (conn, uid, state, reason, elapsed) {
      final String info =
          "Remote video state changed for $uid, state: $state and reason: $reason";
      log(info, name: tag, level: Level.info.value);
      if (uid != sessionController.value.localUid) {
        if (state == RemoteVideoState.remoteVideoStateStopped) {
          sessionController.updateUserVideo(uid: uid, videoDisabled: true);
        } else if (state == RemoteVideoState.remoteVideoStateDecoding &&
            reason == RemoteVideoState.remoteVideoStateStarting) {
          sessionController.updateUserVideo(uid: uid, videoDisabled: false);
        }
      }

      agoraEventHandlers.remoteVideoStateChanged
          ?.call(uid, state, reason, elapsed);
    },
    onRemoteAudioStateChanged: (conn, uid, state, reason, elapsed) {
      final String info =
          "Remote audio state changed for $uid, state: $state and reason: $reason";
      log(info, name: tag, level: Level.info.value);
      if (state == RemoteAudioState.remoteAudioStateStopped &&
          reason == RemoteAudioState.remoteAudioStateStopped &&
          uid != sessionController.value.localUid) {
        sessionController.updateUserAudio(uid: uid, muted: true);
      } else if (state == RemoteAudioState.remoteAudioStateDecoding &&
          reason == RemoteAudioStateReason.remoteAudioReasonRemoteMuted &&
          uid != sessionController.value.localUid) {
        sessionController.updateUserAudio(uid: uid, muted: false);
      }

      agoraEventHandlers.remoteAudioStateChanged
          ?.call(uid, state, reason, elapsed);
    },
    onLocalAudioStateChanged: (conn, state, error) {
      final String info =
          "Local audio state changed state: $state and error: $error";
      log(info, name: tag, level: Level.info.value);
      agoraEventHandlers.localAudioStateChanged?.call(state, error);
    },
    onLocalVideoStateChanged: (videoSrcType, localVideoState, error) {
      final String info =
          "Local video state changed state: $localVideoState and error: $error";
      log(info, name: tag, level: Level.info.value);

      agoraEventHandlers.localVideoStateChanged?.call(localVideoState, error);
    },
    onActiveSpeaker: (conn, uid) {
      final String info = "Active speaker: $uid";
      log(info, name: tag, level: Level.info.value);
      if (sessionController.value.isActiveSpeakerDisabled == false &&
          sessionController.value.layoutType == Layout.floating) {
        final int index = sessionController.value.users
            .indexWhere((element) => element.uid == uid);
        sessionController.swapUser(index: index);
      } else {
        log("Active speaker is disabled", level: Level.info.value, name: tag);
      }

      agoraEventHandlers.activeSpeaker?.call(uid);
    },
  );
}
