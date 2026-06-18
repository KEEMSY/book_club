import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Renders a bundled legal document (privacy policy / terms of service) as
/// selectable text.
///
/// We deliberately avoid `webview_flutter`: the documents ship as Markdown
/// assets, so loading the raw string into a [SelectableText] keeps the binary
/// small and works identically on iOS, Android, and Web without a platform
/// view. Selectable so reviewers/users can copy clauses if needed.
class LegalScreen extends StatelessWidget {
  const LegalScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  /// AppBar title, e.g. "개인정보처리방침".
  final String title;

  /// Bundled asset path, e.g. `assets/legal/privacy_policy.md`.
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                '문서를 불러오지 못했습니다.',
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SelectableText(
              snapshot.data!,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          );
        },
      ),
    );
  }
}
