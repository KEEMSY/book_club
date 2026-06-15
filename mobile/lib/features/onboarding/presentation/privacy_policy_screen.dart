import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-screen stub that immediately opens the privacy policy URL in the
/// system browser, then pops back. A fallback button is shown if the
/// automatic launch fails (e.g. no network or unsupported scheme).
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  static const privacyUrl = 'https://bookclub.app/privacy';

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _launching = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    // Defer the launch so the widget tree is fully mounted first.
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    final uri = Uri.parse(PrivacyPolicyScreen.privacyUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (launched) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _launching = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('개인정보처리방침')),
      body: Center(
        child: _launching
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_failed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        '브라우저를 열 수 없습니다.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _open,
                    child: const Text('개인정보처리방침 열기'),
                  ),
                ],
              ),
      ),
    );
  }
}
