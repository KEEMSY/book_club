import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/app_theme.dart';
import '../application/video_session_notifier.dart';
import '../domain/video_session.dart';

/// Agora App ID. Supplied via `--dart-define=AGORA_APP_ID=...` in release/CI.
/// When empty the screen falls back to the static placeholder grid so dev/test
/// builds run without an Agora account (the backend mirrors this by issuing a
/// stub token — see `agora_real_adapter`/`AgoraStubAdapter`).
const String _agoraAppId = String.fromEnvironment(
  'AGORA_APP_ID',
  defaultValue: '',
);

/// Reading-club video call (M68; real Agora RTC rendering in M71).
///
/// The session lifecycle (start on enter, end on leave) is wired through
/// [VideoSessionNotifier]. When an App ID is configured and the backend returns
/// a join token, the call renders live [AgoraVideoView]s; otherwise it shows the
/// placeholder grid so the screen stays usable.
class VideoSessionScreen extends ConsumerStatefulWidget {
  const VideoSessionScreen({super.key, required this.clubId});

  final String clubId;

  @override
  ConsumerState<VideoSessionScreen> createState() => _VideoSessionScreenState();
}

class _VideoSessionScreenState extends ConsumerState<VideoSessionScreen> {
  bool _leaving = false;

  Future<void> _handleLeave() async {
    if (_leaving) return;
    setState(() => _leaving = true);
    await ref.read(videoSessionProvider(widget.clubId).notifier).leave();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(videoSessionProvider(widget.clubId));

    return PopScope(
      canPop: _leaving,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        _handleLeave();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text('화상 독서 모임'),
        ),
        body: sessionAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (_, __) =>
              _ErrorView(onClose: () => Navigator.of(context).pop()),
          data: (VideoSession session) {
            final bool live =
                _agoraAppId.isNotEmpty && session.agoraToken != null;
            if (live) {
              return _AgoraStage(
                session: session,
                appId: _agoraAppId,
                leaving: _leaving,
                onLeave: _handleLeave,
              );
            }
            return _PlaceholderStage(
              session: session,
              leaving: _leaving,
              onLeave: _handleLeave,
            );
          },
        ),
      ),
    );
  }
}

/// Live Agora call: owns the engine, joins on mount, releases on dispose, and
/// renders the host preview plus one tile per remote participant.
class _AgoraStage extends StatefulWidget {
  const _AgoraStage({
    required this.session,
    required this.appId,
    required this.leaving,
    required this.onLeave,
  });

  final VideoSession session;
  final String appId;
  final bool leaving;
  final VoidCallback onLeave;

  @override
  State<_AgoraStage> createState() => _AgoraStageState();
}

class _AgoraStageState extends State<_AgoraStage> {
  RtcEngine? _engine;
  final Set<int> _remoteUids = <int>{};
  bool _joined = false;
  bool _failed = false;
  bool _micOn = true;
  bool _camOn = true;

  @override
  void initState() {
    super.initState();
    _join();
  }

  Future<void> _join() async {
    try {
      await [Permission.camera, Permission.microphone].request();

      final RtcEngine engine = createAgoraRtcEngine();
      await engine.initialize(RtcEngineContext(appId: widget.appId));
      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            if (mounted) setState(() => _joined = true);
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            if (mounted) setState(() => _remoteUids.add(remoteUid));
          },
          onUserOffline: (
            RtcConnection connection,
            int remoteUid,
            UserOfflineReasonType reason,
          ) {
            if (mounted) setState(() => _remoteUids.remove(remoteUid));
          },
          onError: (ErrorCodeType err, String msg) {
            if (mounted) setState(() => _failed = true);
          },
        ),
      );

      await engine.enableVideo();
      await engine.startPreview();
      await engine.joinChannel(
        token: widget.session.agoraToken!,
        channelId: widget.session.agoraChannel,
        uid: widget.session.agoraUid ?? 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      _engine = engine;
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _toggleMic() async {
    setState(() => _micOn = !_micOn);
    await _engine?.muteLocalAudioStream(!_micOn);
  }

  Future<void> _toggleCam() async {
    setState(() => _camOn = !_camOn);
    await _engine?.muteLocalVideoStream(!_camOn);
  }

  @override
  void dispose() {
    _disposeEngine();
    super.dispose();
  }

  Future<void> _disposeEngine() async {
    final RtcEngine? engine = _engine;
    if (engine == null) return;
    await engine.leaveChannel();
    await engine.release();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final RtcEngine? engine = _engine;

    if (_failed) {
      return _ErrorView(onClose: widget.onLeave);
    }
    if (engine == null || !_joined) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    final List<Widget> tiles = <Widget>[
      _VideoTile(
        isSelf: true,
        camOn: _camOn,
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      ),
      for (final int uid in _remoteUids)
        _VideoTile(
          isSelf: false,
          camOn: true,
          child: AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: engine,
              canvas: VideoCanvas(uid: uid),
              connection:
                  RtcConnection(channelId: widget.session.agoraChannel),
            ),
          ),
        ),
    ];

    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: GridView.count(
              crossAxisCount: tiles.length <= 1 ? 1 : 2,
              childAspectRatio: 0.8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: tiles,
            ),
          ),
        ),
        _ControlsBar(
          micOn: _micOn,
          camOn: _camOn,
          leaving: widget.leaving,
          onToggleMic: _toggleMic,
          onToggleCam: _toggleCam,
          onLeave: widget.onLeave,
        ),
      ],
    );
  }
}

/// A single video cell — wraps an [AgoraVideoView] (or a "camera off" glyph)
/// with the self-tile accent border and "나" badge.
class _VideoTile extends StatelessWidget {
  const _VideoTile({
    required this.isSelf,
    required this.camOn,
    required this.child,
  });

  final bool isSelf;
  final bool camOn;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: isSelf
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (camOn)
              child
            else
              const Center(
                child: Icon(
                  Icons.videocam_off_rounded,
                  color: Colors.white24,
                  size: 36,
                ),
              ),
            if (isSelf)
              const Positioned(
                left: 6,
                bottom: 6,
                child: Text(
                  '나',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Static placeholder shown when no Agora App ID is configured or the backend
/// returned no join token (dev/test, or a half-configured environment).
class _PlaceholderStage extends StatefulWidget {
  const _PlaceholderStage({
    required this.session,
    required this.leaving,
    required this.onLeave,
  });

  final VideoSession session;
  final bool leaving;
  final VoidCallback onLeave;

  @override
  State<_PlaceholderStage> createState() => _PlaceholderStageState();
}

class _PlaceholderStageState extends State<_PlaceholderStage> {
  bool _micOn = true;
  bool _camOn = true;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final int tiles = widget.session.maxParticipants.clamp(1, 9);

    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            '영상 통화 설정 중…',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: tiles,
              itemBuilder: (_, int i) => _VideoTile(
                isSelf: i == 0,
                camOn: i == 0 && _camOn,
                child: const ColoredBox(color: Color(0xFF1E1E1E)),
              ),
            ),
          ),
        ),
        _ControlsBar(
          micOn: _micOn,
          camOn: _camOn,
          leaving: widget.leaving,
          onToggleMic: () => setState(() => _micOn = !_micOn),
          onToggleCam: () => setState(() => _camOn = !_camOn),
          onLeave: widget.onLeave,
        ),
      ],
    );
  }
}

class _ControlsBar extends StatelessWidget {
  const _ControlsBar({
    required this.micOn,
    required this.camOn,
    required this.leaving,
    required this.onToggleMic,
    required this.onToggleCam,
    required this.onLeave,
  });

  final bool micOn;
  final bool camOn;
  final bool leaving;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCam;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _CircleControl(
              icon: micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
              active: micOn,
              label: micOn ? '마이크' : '음소거',
              onTap: onToggleMic,
            ),
            _CircleControl(
              icon: camOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
              active: camOn,
              label: camOn ? '카메라' : '꺼짐',
              onTap: onToggleCam,
            ),
            _CircleControl(
              icon: Icons.call_end_rounded,
              active: false,
              danger: true,
              label: '나가기',
              onTap: leaving ? null : onLeave,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({
    required this.icon,
    required this.active,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final bool active;
  final String label;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final Color bg = danger
        ? Theme.of(context).colorScheme.error
        : active
            ? Colors.white24
            : Colors.white10;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          color: bg,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.white54,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            '화상 모임을 시작하지 못했어요',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            '권한을 확인한 뒤 다시 시도해 주세요.',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onClose,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('돌아가기'),
          ),
        ],
      ),
    );
  }
}
