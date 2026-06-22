import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/video_session_notifier.dart';
import '../domain/video_session.dart';

/// Reading-club video call (M68).
///
/// The `agora_rtc_engine` package is not yet in `pubspec.yaml`, so this renders
/// a stub: static participant placeholders and non-functional mic/camera
/// toggles. The session lifecycle (start on enter, end on leave) is real and
/// wired through [VideoSessionNotifier].
///
/// TODO(video): replace the placeholder grid with live Agora video views once
/// `agora_rtc_engine` is added and the real token endpoint ships. — owner: mobile
class VideoSessionScreen extends ConsumerStatefulWidget {
  const VideoSessionScreen({super.key, required this.clubId});

  final String clubId;

  @override
  ConsumerState<VideoSessionScreen> createState() => _VideoSessionScreenState();
}

class _VideoSessionScreenState extends ConsumerState<VideoSessionScreen> {
  bool _micOn = true;
  bool _camOn = true;
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
          data: (VideoSession session) => _SessionBody(
            session: session,
            micOn: _micOn,
            camOn: _camOn,
            leaving: _leaving,
            onToggleMic: () => setState(() => _micOn = !_micOn),
            onToggleCam: () => setState(() => _camOn = !_camOn),
            onLeave: _handleLeave,
          ),
        ),
      ),
    );
  }
}

class _SessionBody extends StatelessWidget {
  const _SessionBody({
    required this.session,
    required this.micOn,
    required this.camOn,
    required this.leaving,
    required this.onToggleMic,
    required this.onToggleCam,
    required this.onLeave,
  });

  final VideoSession session;
  final bool micOn;
  final bool camOn;
  final bool leaving;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCam;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    // Up to a 3x3 grid; the host occupies the first tile.
    final int tiles = session.maxParticipants.clamp(1, 9);

    return Column(
      children: <Widget>[
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
              itemBuilder: (_, int i) => _ParticipantTile(
                isSelf: i == 0,
                camOn: camOn,
              ),
            ),
          ),
        ),
        _ControlsBar(
          micOn: micOn,
          camOn: camOn,
          leaving: leaving,
          onToggleMic: onToggleMic,
          onToggleCam: onToggleCam,
          onLeave: onLeave,
        ),
      ],
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({required this.isSelf, required this.camOn});

  final bool isSelf;
  final bool camOn;

  @override
  Widget build(BuildContext context) {
    final bool showVideoOff = isSelf && !camOn;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: isSelf
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Icon(
              showVideoOff ? Icons.videocam_off_rounded : Icons.person_rounded,
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
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),),
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
          const Icon(Icons.error_outline_rounded,
              color: Colors.white54, size: 48,),
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
