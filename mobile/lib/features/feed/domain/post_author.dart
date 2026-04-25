import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_author.freezed.dart';

/// Embedded user payload returned inside `Post.user` and `Comment.user`.
///
/// We intentionally keep this slimmer than [AuthUser] — the feed only needs
/// id / nickname / avatar to render the row header. Other auth-state details
/// (provider, createdAt) stay out so feed widgets don't depend on the auth
/// domain.
@freezed
class PostAuthor with _$PostAuthor {
  const factory PostAuthor({
    required String id,
    required String nickname,
    String? profileImageUrl,
  }) = _PostAuthor;
}
