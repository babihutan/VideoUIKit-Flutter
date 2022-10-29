import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/models/agora_user.dart';
import 'package:agora_uikit/src/layout/widgets/disabled_video_widget.dart';
import 'package:agora_uikit/src/layout/widgets/number_of_users.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class GridLayout extends StatefulWidget {
  final AgoraClient client;

  final Stream<Map<int, String>>? labelStream;

  /// Display the total number of users in a channel.
  final bool? showNumberOfUsers;

  /// Widget that will be displayed when the local or remote user has disabled it's video.
  final Widget? disabledVideoWidget;

  /// Render mode for local and remote video
  final RenderModeType videoRenderMode;

  const GridLayout({
    Key? key,
    required this.client,
    this.showNumberOfUsers,
    this.labelStream,
    this.disabledVideoWidget = const DisabledVideoWidget(),
    this.videoRenderMode = RenderModeType.renderModeHidden,
  }) : super(key: key);

  @override
  State<GridLayout> createState() => _GridLayoutState();
}

class _GridLayoutState extends State<GridLayout> {
  List<Widget> _getRenderViews() {
    final List<Widget> list = [];

    if (widget.client.agoraChannelData?.clientRole ==
            ClientRoleType.clientRoleBroadcaster ||
        widget.client.agoraChannelData?.clientRole == null) {
      widget.client.sessionController.value.isLocalVideoDisabled
          ? list.add(
              TileWrapper(
                  child: DisabledVideoStfWidget(
                    disabledVideoWidget: widget.disabledVideoWidget,
                  ),
                  uid: 0),
            )
          : list.add(
              TileWrapper(
                uid: 0,
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: widget.client.engine,
                    canvas:
                        VideoCanvas(uid: 0, renderMode: widget.videoRenderMode),
                  ),
                ),
              ),
              // rtc_local_view.SurfaceView(
              //   zOrderMediaOverlay: true,
              //   renderMode: widget.videoRenderMode,
              // ),
            );
    }

    for (AgoraUser user in widget.client.sessionController.value.users) {
      if (user.clientRole == ClientRoleType.clientRoleBroadcaster) {
        user.videoDisabled
            ? list.add(
                TileWrapper(
                  uid: user.uid,
                  child: DisabledVideoStfWidget(
                    disabledVideoWidget: widget.disabledVideoWidget,
                  ),
                ),
              )
            : list.add(TileWrapper(
                uid: user.uid,
                child: AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: widget.client.engine,
                    canvas: VideoCanvas(
                        uid: user.uid, renderMode: widget.videoRenderMode),
                    connection: RtcConnection(
                        channelId: widget.client.sessionController.value
                            .connectionData!.channelName),
                  ),
                ),
              )
                // rtc_remote_view.SurfaceView(
                //   channelId: widget.client.sessionController.value
                //       .connectionData!.channelName,
                //   uid: user.uid,
                //   renderMode: widget.videoRenderMode,
                // ),
                );
      }
    }

    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _viewGrid() {
    final views = _getRenderViews();
    if (views.isEmpty) {
      return Expanded(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              'Waiting for the host to join',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
    } else if (views.length == 1) {
      return Container(
        child: Column(
          children: <Widget>[_videoView(views[0])],
        ),
      );
    } else if (views.length == 2) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow([views[0]]),
          _expandedVideoRow([views[1]])
        ],
      ));
    } else if (views.length > 2 && views.length % 2 == 0) {
      return Container(
        child: Column(
          children: [
            for (int i = 0; i < views.length; i = i + 2)
              _expandedVideoRow(
                views.sublist(i, i + 2),
              ),
          ],
        ),
      );
    } else if (views.length > 2 && views.length % 2 != 0) {
      return Container(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < views.length; i = i + 2)
              i == (views.length - 1)
                  ? _expandedVideoRow(views.sublist(i, i + 1))
                  : _expandedVideoRow(views.sublist(i, i + 2)),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.client.sessionController,
      builder: (context, counter, widgetx) {
        return Center(
          child: Stack(
            children: [
              _viewGrid(),
              widget.showNumberOfUsers == null ||
                      widget.showNumberOfUsers == false
                  ? Container()
                  : Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: NumberOfUsers(
                          userCount: widget
                              .client.sessionController.value.users.length,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class DisabledVideoStfWidget extends StatefulWidget {
  final Widget? disabledVideoWidget;
  const DisabledVideoStfWidget({Key? key, this.disabledVideoWidget})
      : super(key: key);

  @override
  State<DisabledVideoStfWidget> createState() => _DisabledVideoStfWidgetState();
}

class _DisabledVideoStfWidgetState extends State<DisabledVideoStfWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.disabledVideoWidget!;
  }
}

class TileWrapper extends StatelessWidget {
  final Widget child;
  final int uid;
  final Stream<Map<int, String>>? labelStream;
  TileWrapper({required this.child, required this.uid, this.labelStream});
  @override
  Widget build(BuildContext context) {
    if (labelStream != null) {
      return StreamBuilder<Map<int, String>>(
        stream: labelStream,
        builder: (context, labelMapSnap) {
          if (!labelMapSnap.hasData || !labelMapSnap.data!.containsKey(uid)) {
            return _tile(context);
          }
          final name = labelMapSnap.data![uid];
          return _tile(context, name: name);
          ;
        },
      );
    } else {
      return _tile(context);
    }
  }

  String get simpleName {
    if (uid == 0) {
      return 'me';
    } else {
      return uid.toString();
    }
  }

  Widget _tile(BuildContext context, {String? name}) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(name ?? simpleName),
      ),
      child: child,
    );
  }
}
