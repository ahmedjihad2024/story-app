import 'package:image_picker/image_picker.dart';

extension XFileImageExtensions on XFile {
  String get imageExtension {
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < name.length - 1) {
      return name.substring(dotIndex + 1).toLowerCase();
    }
    final mime = mimeType?.toLowerCase();
    if (mime != null && mime.contains('/')) {
      final subtype = mime.split('/').last;
      return subtype == 'jpeg' ? 'jpg' : subtype;
    }
    return 'jpg';
  }

  String get imageContentType {
    final mime = mimeType;
    if (mime != null && mime.isNotEmpty) return mime;
    return switch (imageExtension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'heic' => 'image/heic',
      _ => 'image/jpeg',
    };
  }
}

