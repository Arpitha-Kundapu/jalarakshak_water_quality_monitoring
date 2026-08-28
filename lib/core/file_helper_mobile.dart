import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadAndShareReport({
  required String csvContent,
  required String fileName,
  required String shareSubject,
  required String shareText,
}) async {
  final directory = await getTemporaryDirectory();
  final String path = '${directory.path}/$fileName';
  final File file = File(path);
  await file.writeAsString(csvContent);

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(path)],
      subject: shareSubject,
      text: shareText,
    ),
  );
}
