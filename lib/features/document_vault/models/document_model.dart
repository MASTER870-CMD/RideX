enum DocumentType { pdf, image, other }

class RidexDocument {
  final String id;
  final String name;
  final DocumentType type;
  final DateTime uploadedAt;
  final int sizeBytes;
  final String? localPath; // null = mock / not yet saved locally

  const RidexDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.uploadedAt,
    required this.sizeBytes,
    this.localPath,
  });

  String get sizeLabel {
    if (sizeBytes < 1024) return '${sizeBytes}B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get typeIcon {
    switch (type) {
      case DocumentType.pdf: return 'PDF';
      case DocumentType.image: return 'IMG';
      case DocumentType.other: return 'DOC';
    }
  }
}
