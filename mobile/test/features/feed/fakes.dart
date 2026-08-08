import 'dart:typed_data';

import 'package:book_club/features/feed/data/feed_models.dart';
import 'package:book_club/features/feed/data/feed_repository.dart';
import 'package:book_club/features/feed/data/image_uploader.dart';
import 'package:book_club/features/feed/domain/book_highlight_group.dart';
import 'package:book_club/features/feed/domain/comment.dart';
import 'package:book_club/features/feed/domain/feed_comment.dart';
import 'package:book_club/features/feed/domain/feed_event.dart';
import 'package:book_club/features/feed/domain/highlight.dart';
import 'package:book_club/features/feed/domain/post.dart';
import 'package:book_club/features/feed/domain/post_author.dart';
import 'package:book_club/features/feed/domain/post_type.dart';
import 'package:book_club/features/feed/domain/reaction_type.dart';

/// Fake repository that lets feed-feature tests queue deterministic responses
/// per endpoint. Mirrors the shape used by the book/reading fakes.
class FakeFeedRepository implements FeedRepository {
  FakeFeedRepository();

  // -- listPosts --
  final List<PostPage> postPagesQueue = <PostPage>[];
  final List<Object> postPagesErrors = <Object>[];
  PostPage defaultPostPage = const PostPage(items: <Post>[], nextCursor: null);
  final List<({String bookId, String? cursor, int limit})> listPostsCalls =
      <({String bookId, String? cursor, int limit})>[];

  // -- createPost --
  Post? createPostResult;
  Object? createPostError;
  final List<
      ({
        String bookId,
        PostType type,
        String content,
        List<String> imageKeys,
      })> createPostCalls = <({
    String bookId,
    PostType type,
    String content,
    List<String> imageKeys
  })>[];

  // -- toggleReaction --
  ReactionToggleResult? toggleReactionResult;
  Object? toggleReactionError;
  final List<({String postId, ReactionType type})> toggleCalls =
      <({String postId, ReactionType type})>[];

  // -- listComments --
  final List<CommentPage> commentPagesQueue = <CommentPage>[];
  final List<Object> commentErrors = <Object>[];
  CommentPage defaultCommentPage =
      const CommentPage(items: <Comment>[], nextCursor: null);
  final List<({String postId, String? cursor, int limit})> listCommentsCalls =
      <({String postId, String? cursor, int limit})>[];

  // -- createComment --
  Comment? createCommentResult;
  Object? createCommentError;
  final List<({String postId, String? parentId, String content})>
      createCommentCalls =
      <({String postId, String? parentId, String content})>[];

  // -- deleteComment --
  Object? deleteCommentError;
  final List<String> deleteCommentCalls = <String>[];

  // -- deletePost --
  Object? deletePostError;
  final List<String> deletePostCalls = <String>[];

  // -- highlight --
  Highlight? createHighlightResult;
  HighlightPage defaultHighlightPage =
      const HighlightPage(items: <Highlight>[], nextCursor: null);

  // -- uploadImage --
  final List<String> uploadKeyQueue = <String>[];
  final List<Object> uploadErrors = <Object>[];
  final List<PickedImage> uploadCalls = <PickedImage>[];

  @override
  Future<PostPage> listPosts({
    required String bookId,
    String? cursor,
    int limit = 20,
  }) async {
    listPostsCalls.add((bookId: bookId, cursor: cursor, limit: limit));
    if (postPagesErrors.isNotEmpty) throw postPagesErrors.removeAt(0);
    if (postPagesQueue.isNotEmpty) return postPagesQueue.removeAt(0);
    return defaultPostPage;
  }

  @override
  Future<Post> createPost({
    required String bookId,
    required PostType postType,
    required String content,
    required List<String> imageKeys,
  }) async {
    createPostCalls.add(
      (
        bookId: bookId,
        type: postType,
        content: content,
        imageKeys: imageKeys,
      ),
    );
    if (createPostError != null) throw createPostError!;
    return createPostResult!;
  }

  @override
  Future<void> deletePost(String postId) async {
    deletePostCalls.add(postId);
    if (deletePostError != null) throw deletePostError!;
  }

  @override
  Future<ReactionToggleResult> toggleReaction({
    required String postId,
    required ReactionType reactionType,
  }) async {
    toggleCalls.add((postId: postId, type: reactionType));
    if (toggleReactionError != null) throw toggleReactionError!;
    return toggleReactionResult!;
  }

  @override
  Future<CommentPage> listComments({
    required String postId,
    String? cursor,
    int limit = 50,
  }) async {
    listCommentsCalls.add((postId: postId, cursor: cursor, limit: limit));
    if (commentErrors.isNotEmpty) throw commentErrors.removeAt(0);
    if (commentPagesQueue.isNotEmpty) return commentPagesQueue.removeAt(0);
    return defaultCommentPage;
  }

  @override
  Future<Comment> createComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    createCommentCalls.add(
      (postId: postId, parentId: parentId, content: content),
    );
    if (createCommentError != null) throw createCommentError!;
    return createCommentResult!;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    deleteCommentCalls.add(commentId);
    if (deleteCommentError != null) throw deleteCommentError!;
  }

  @override
  Future<Highlight> createHighlight({
    required String userBookId,
    required String quoteText,
    int? pageNumber,
    String? noteText,
  }) async {
    return createHighlightResult ??
        Highlight(
          id: 'highlight-1',
          userBookId: userBookId,
          quoteText: quoteText,
          pageNumber: pageNumber,
          createdAt: DateTime.utc(2026, 4, 30, 12),
        );
  }

  @override
  Future<HighlightPage> listHighlights({
    required String userBookId,
    String? cursor,
    int limit = 20,
  }) async {
    return defaultHighlightPage;
  }

  @override
  Future<void> deleteHighlight({
    required String userBookId,
    required String highlightId,
  }) async {}

  @override
  Future<List<BookHighlightGroup>> listAllHighlights() async {
    return const <BookHighlightGroup>[];
  }

  // -- listMyRecentHighlights (BC-83) --
  MyHighlightListResponseDto myRecentHighlightsResult =
      const MyHighlightListResponseDto();
  Object? myRecentHighlightsError;
  final List<({int limit, int offset})> listMyRecentHighlightsCalls =
      <({int limit, int offset})>[];

  @override
  Future<MyHighlightListResponseDto> listMyRecentHighlights({
    int limit = 20,
    int offset = 0,
  }) async {
    listMyRecentHighlightsCalls.add((limit: limit, offset: offset));
    if (myRecentHighlightsError != null) throw myRecentHighlightsError!;
    return myRecentHighlightsResult;
  }

  @override
  Future<String> uploadImage(PickedImage image) async {
    uploadCalls.add(image);
    if (uploadErrors.isNotEmpty) throw uploadErrors.removeAt(0);
    if (uploadKeyQueue.isNotEmpty) return uploadKeyQueue.removeAt(0);
    return 'uploaded-${uploadCalls.length}';
  }

  @override
  Future<Highlight> updateHighlight({
    required String userBookId,
    required String highlightId,
    required String quoteText,
    int? pageNumber,
    String? noteText,
  }) async {
    return Highlight(
      id: highlightId,
      userBookId: userBookId,
      quoteText: quoteText,
      pageNumber: pageNumber,
      createdAt: DateTime.utc(2026, 4, 30, 12),
    );
  }

  // -- event feed / feed comments --
  // Not exercised by current tests; queue-based fakes can be added when a test
  // needs them. Implemented to satisfy the FeedRepository interface.
  @override
  Future<FeedEventPage> getGlobalFeed({String? cursor, int limit = 20}) =>
      throw UnimplementedError();

  @override
  Future<FeedEventPage> getFollowingEventFeed({
    String? cursor,
    int limit = 20,
  }) =>
      throw UnimplementedError();

  @override
  Future<FeedReactionToggleResult> toggleFeedReaction({
    required String eventId,
    required String emoji,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<FeedComment>> getFeedComments(String eventId) =>
      throw UnimplementedError();

  @override
  Future<FeedComment> createFeedComment({
    required String eventId,
    required String body,
    String? parentId,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> deleteFeedComment(String commentId) =>
      throw UnimplementedError();
}

PostAuthor buildAuthor({
  String id = 'user-1',
  String nickname = '희재',
  String? profileImageUrl,
}) {
  return PostAuthor(
    id: id,
    nickname: nickname,
    profileImageUrl: profileImageUrl,
  );
}

Post buildPost({
  String id = 'post-1',
  String bookId = 'book-1',
  PostAuthor? author,
  PostType type = PostType.thought,
  String content = '오늘 읽은 부분이 정말 좋았어요',
  List<String> imageUrls = const <String>[],
  Map<ReactionType, int>? reactions,
  Set<ReactionType>? myReactions,
  int commentCount = 0,
  DateTime? createdAt,
}) {
  return Post(
    id: id,
    bookId: bookId,
    user: author ?? buildAuthor(),
    postType: type,
    content: content,
    imageUrls: imageUrls,
    reactions: reactions ?? <ReactionType, int>{},
    myReactions: myReactions ?? <ReactionType>{},
    commentCount: commentCount,
    createdAt: createdAt ?? DateTime.utc(2026, 4, 25, 12),
  );
}

Comment buildComment({
  String id = 'comment-1',
  PostAuthor? author,
  String content = '저도 그렇게 느꼈어요',
  String? parentId,
  DateTime? createdAt,
}) {
  return Comment(
    id: id,
    user: author ?? buildAuthor(),
    content: content,
    parentId: parentId,
    createdAt: createdAt ?? DateTime.utc(2026, 4, 25, 12),
  );
}

PickedImage buildPickedImage({String contentType = 'image/jpeg'}) {
  return PickedImage(
    bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
    contentType: contentType,
    filename: 'photo.jpg',
  );
}
