import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<ShareResultStatus> shareText(String text, {String? title}) async {
    if (text.trim().isEmpty) return ShareResultStatus.dismissed;

    final result = await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: title?.isEmpty ?? true ? null : title,
      ),
    );

    return result.status;
  }
}
