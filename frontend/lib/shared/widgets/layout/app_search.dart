import 'dart:async';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/widgets/elements/input/app_text_input.dart';
import 'package:flutter/material.dart';

class AppSearch extends StatefulWidget {
  final void Function(String query)? onChanged;
  final String hint;

  const AppSearch({super.key, this.onChanged, this.hint = 'Search...'});

  @override
  State<AppSearch> createState() => _AppSearchState();
}

class _AppSearchState extends State<AppSearch> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _controller.text = value);
    
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      widget.onChanged?.call(value);
    });
  }

  Widget _clearSearch(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      color: context.onSurface,
      onPressed: () {
        _controller.clear();
        widget.onChanged?.call('');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.only(top: AppSize.normal),
      child: AppTextInput(
        controller: _controller,
        hintText: widget.hint,
        onChanged: _onChanged,
        suffixIcon: _controller.text.isNotEmpty ? _clearSearch(context) : null,
      ),
    );
  }
}
