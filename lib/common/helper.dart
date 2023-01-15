import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<File> getFile(String fileName) async {
  return File((await _getDocumentPath()) + fileName);
}

Future<String> _getDocumentPath() async {
  final directory = await getApplicationDocumentsDirectory();
  final directoryPath = directory.path;
  if (directoryPath.contains('/') &&
      directoryPath[directoryPath.length - 1] != '/') {
    return directoryPath + '/';
  } else if (directoryPath.contains('\\') &&
      directoryPath[directoryPath.length - 1] != '\\') {
    return directoryPath + '\\';
  }
  return directoryPath;
}
