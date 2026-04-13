import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true);

  final regex = RegExp(r'fontSize:\s*(\d+(?:\.\d+)?)(?!\.sp|\.w|\.h|[a-zA-Z])');
  const importStatement =
      "import 'package:flutter_screenutil/flutter_screenutil.dart';";

  int filesUpdated = 0;

  for (final entity in files) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = entity.readAsStringSync();

      bool matched = false;
      String newContent = content.replaceAllMapped(regex, (match) {
        matched = true;
        return 'fontSize: ${match.group(1)}.sp';
      });

      if (matched && newContent != content) {
        if (!newContent.contains(importStatement)) {
          final importRegex = RegExp(r"^import '.*';", multiLine: true);
          final matches = importRegex.allMatches(newContent);

          if (matches.isNotEmpty) {
            final lastMatch = matches.last;
            newContent =
                '${newContent.substring(0, lastMatch.end)}\n$importStatement${newContent.substring(lastMatch.end)}';
          } else {
            newContent = '$importStatement\n\n$newContent';
          }
        }

        entity.writeAsStringSync(newContent);
        filesUpdated++;
        print('Updated: ${entity.path}');
      }
    }
  }

  print('Total files updated: $filesUpdated');
}
