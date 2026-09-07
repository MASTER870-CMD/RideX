import 'package:flutter/foundation.dart';
import '../../features/document_vault/models/document_model.dart';

/// Document storage abstraction.
/// Currently uses in-memory mock. Replace with cloud storage later.
class DocumentService extends ChangeNotifier {
  final List<RidexDocument> _documents = [
    RidexDocument(
      id: '1',
      name: 'Emission_Test_2026.pdf',
      type: DocumentType.pdf,
      uploadedAt: DateTime(2026, 1, 15),
      sizeBytes: 342000,
    ),
    RidexDocument(
      id: '2',
      name: 'Insurance_Policy.jpg',
      type: DocumentType.image,
      uploadedAt: DateTime(2026, 3, 22),
      sizeBytes: 186000,
    ),
  ];

  List<RidexDocument> get documents => List.unmodifiable(_documents);

  void addDocument(RidexDocument doc) {
    _documents.add(doc);
    notifyListeners();
  }

  void removeDocument(String id) {
    _documents.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  void replaceDocument(String id, RidexDocument newDoc) {
    final idx = _documents.indexWhere((d) => d.id == id);
    if (idx != -1) {
      _documents[idx] = newDoc;
      notifyListeners();
    }
  }
}
