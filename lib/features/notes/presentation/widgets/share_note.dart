import 'package:share_plus/share_plus.dart';

Future<void> shareNote({required String title, required String content}) async {
  final text = 'title: $title\ncontent:\n$content';

  await SharePlus.instance.share(ShareParams(text: text));
}
