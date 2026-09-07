import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_router.dart';
import '../../core/services/document_service.dart';
import '../../core/theme/ridex_colors.dart';
import '../../core/theme/ridex_text_styles.dart';
import '../../shared/widgets/ridex_drawer.dart';
import '../../shared/widgets/ridex_empty_state.dart';
import '../../shared/widgets/ridex_primary_button.dart';
import 'models/document_model.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});
  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  bool _isUploading = false;

  Future<void> _pickAndUpload(BuildContext context) async {
    final svc = context.read<DocumentService>();
    setState(() => _isUploading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final doc = RidexDocument(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: file.name,
          type: file.extension == 'pdf'
              ? DocumentType.pdf : DocumentType.image,
          uploadedAt: DateTime.now(),
          sizeBytes: file.size,
          localPath: file.path,
        );
        svc.addDocument(doc);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${file.name}" added to vault'),
              backgroundColor: RidexColors.emerald,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RidexColors.background,
      drawer: const RidexDrawer(activeRoute: AppRoutes.documentVault),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Consumer<DocumentService>(
                builder: (context, svc, _) {
                  final docs = svc.documents;
                  return docs.isEmpty
                      ? RidexEmptyState(
                          icon: Icons.folder_outlined,
                          title: 'No Documents',
                          subtitle:
                              'Upload your vehicle documents to keep them safe.',
                          actionLabel: 'Upload Document',
                          onAction: () => _pickAndUpload(context),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: docs.length + 1,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            if (i == 0) {
                              return RidexPrimaryButton(
                                label: 'Upload Document',
                                trailingIcon: Icons.upload_outlined,
                                isLoading: _isUploading,
                                onPressed: _isUploading
                                    ? null
                                    : () => _pickAndUpload(context),
                              );
                            }
                            return _DocumentCard(
                              doc: docs[i - 1],
                              onDelete: () =>
                                  svc.removeDocument(docs[i - 1].id),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          _backBtn(context),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Document Vault', style: RidexTextStyles.titleLarge),
              Text('Store & manage vehicle documents',
                  style: RidexTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _backBtn(BuildContext context) {
  return InkWell(
    onTap: () => Navigator.of(context).pop(),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RidexColors.border),
      ),
      child: const Icon(Icons.arrow_back_ios_new_rounded,
          size: 16, color: RidexColors.charcoal),
    ),
  );
}

class _DocumentCard extends StatelessWidget {
  final RidexDocument doc;
  final VoidCallback onDelete;

  const _DocumentCard({required this.doc, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isPdf = doc.type == DocumentType.pdf;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RidexColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RidexColors.border),
        boxShadow: [BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 8, offset: const Offset(0, 2),
        )],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isPdf
                  ? const Color(0xFFFFF1F2) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                doc.typeIcon,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  color: isPdf ? RidexColors.red : const Color(0xFF2563EB),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.name,
                    style: RidexTextStyles.titleSmall,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  '${doc.sizeLabel} â€¢ ${doc.uploadedAt.day}/${doc.uploadedAt.month}/${doc.uploadedAt.year}',
                  style: RidexTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline,
                  size: 16, color: RidexColors.red),
            ),
          ),
        ],
      ),
    );
  }
}

