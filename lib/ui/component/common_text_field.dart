// ignore_for_file: missing_golden_test
import 'package:flutter/material.dart';

import '../../index.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    required this.hintText,
    this.controller,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 56.rps,
      decoration: BoxDecoration(
        color: color.greyscale50,
        borderRadius: BorderRadius.circular(12.rps),
        border: Border.all(
          color: _isFocused ? color.primary : Colors.transparent,
          width: 1.5.rps,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: style(
          color: color.greyscale900,
          fontSize: 14.rps,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.rps, vertical: 18.rps),
          hintText: widget.hintText,
          hintStyle: style(
            color: color.greyscale500,
            fontSize: 14.rps,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: widget.prefixIcon,
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
