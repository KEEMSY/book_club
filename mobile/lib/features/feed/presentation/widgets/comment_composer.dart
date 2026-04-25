import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Inline composer that hosts the comment text field + 등록 pill.
///
/// When [replyTargetNickname] is non-null, a "to nickname" chip with a
/// dismiss × renders inside the composer to remind the user the next post
/// will be threaded under that root comment.
class CommentComposer extends StatefulWidget {
  const CommentComposer({
    super.key,
    required this.onSubmit,
    this.replyTargetNickname,
    this.onClearReply,
    this.errorText,
    this.busy = false,
    this.autoFocus = false,
  });

  /// Called when the user taps "등록". Returns a future the composer awaits
  /// before resetting the text field — the caller can mark the success path
  /// and clear the field by completing normally.
  final Future<bool> Function(String content) onSubmit;
  final String? replyTargetNickname;
  final VoidCallback? onClearReply;
  final String? errorText;
  final bool busy;
  final bool autoFocus;

  @override
  State<CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.sm,
        spacing.md,
        spacing.sm + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.replyTargetNickname != null)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.xs),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius:
                          BorderRadius.all(Radius.circular(radii.pill)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'to ${widget.replyTargetNickname}',
                          style: theme.textTheme.labelMedium,
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: widget.onClearReply,
                          customBorder: const CircleBorder(),
                          child: const Icon(Icons.close_rounded, size: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (widget.errorText != null)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.xs),
              child: Text(
                widget.errorText!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: 1000,
                  minLines: 1,
                  maxLines: 4,
                  autofocus: widget.autoFocus,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: '댓글을 남겨주세요',
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(width: spacing.sm),
              FilledButton(
                onPressed: widget.busy || _controller.text.trim().isEmpty
                    ? null
                    : () async {
                        final ok = await widget.onSubmit(_controller.text);
                        if (ok && mounted) {
                          _controller.clear();
                          setState(() {});
                        }
                      },
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                child: widget.busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('등록'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
