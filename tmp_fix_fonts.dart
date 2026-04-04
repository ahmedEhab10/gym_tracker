import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true);
  
  // Fix the .sp\d+.sp corruption
  // e.g., fontSize: 3.sp4.sp -> fontSize: 34.sp
  final regex1 = RegExp(r'(\d+)\.sp(\d+(?:\.\d+)?)\.sp');
  
  // Actually some might be just \.sp inside digits?
  // Let's just fix anything of the form \d+\.sp\d+\.sp to \d+\d+\.sp
  int filesUpdated = 0;
  
  for (final entity in files) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = entity.readAsStringSync();
      
      bool matched = false;
      String newContent = content.replaceAllMapped(regex1, (match) {
        matched = true;
        return '${match.group(1)}${match.group(2)}.sp';
      });
      
      if (matched && newContent != content) {
        entity.writeAsStringSync(newContent);
        filesUpdated++;
        print('Fixed corruption in: ${entity.path}');
      }
    }
  }
  print('Fixed files: $filesUpdated');
}
