import 'package:flutter/material.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';

/// Mevcut teklifi şablon olarak kaydetmek için isim sorar.
/// `_NewCategoryDialog` (category_picker.dart) ile aynı desen.
Future<String?> showSaveAsTemplateDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const _SaveAsTemplateDialog(),
  );
}

class _SaveAsTemplateDialog extends StatefulWidget {
  const _SaveAsTemplateDialog();

  @override
  State<_SaveAsTemplateDialog> createState() => _SaveAsTemplateDialogState();
}

class _SaveAsTemplateDialogState extends State<_SaveAsTemplateDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.templateNew),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: l10n.templateNameLabel),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.actionAdd)),
      ],
    );
  }
}
