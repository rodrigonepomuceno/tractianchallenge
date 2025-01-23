import 'package:flutter/material.dart';
import 'package:tractianchallenge/core/theme/app_theme.dart';
import 'package:tractianchallenge/core/theme/app_typography.dart';

class SearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String value;

  const SearchField({
    super.key,
    required this.onChanged,
    required this.value,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.searchBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: AppTypography.bodyRegular.copyWith(
          color: AppTheme.textSecondary,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar Ativo ou Local',
          hintStyle: AppTypography.bodyRegular.copyWith(
            color: Colors.grey,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              Icons.search,
              color: Colors.grey.shade600,
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
