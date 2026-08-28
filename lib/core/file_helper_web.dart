import 'dart:convert';
import 'dart:html' as html;

Future<void> downloadAndShareReport({
  required String csvContent,
  required String fileName,
  required String shareSubject,
  required String shareText,
}) async {
  final bytes = utf8.encode(csvContent);
  final blob = html.Blob([bytes], 'text/csv');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();

  html.Url.revokeObjectUrl(url);
}
