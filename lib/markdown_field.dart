import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MarkdownTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    var bold = RegExp(r'\*\*.*\*\*');
    final List<TextSpan> childrenSpan = [];

    text.splitMapJoin(bold,
      onMatch: (val) {
        String formatted;
        print(selection.baseOffset);
        if (selection.baseOffset >= val.start && selection.baseOffset <= val.end) {
          childrenSpan.add(const TextSpan(text: "**", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)));
          childrenSpan.add(TextSpan(text: text.substring(val.start+2, val.end-2), style: const TextStyle(fontWeight: FontWeight.bold)));
          childrenSpan.add(const TextSpan(text: "**", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)));
        } else {
          formatted = text.substring(val.start, val.end).replaceAll("**", "\u2063\u2063");
          childrenSpan.add(TextSpan(text: formatted, style: const TextStyle(fontWeight: FontWeight.bold)));
        }

        return "";
      },
      onNonMatch: (val) {
        childrenSpan.add(TextSpan(text: val));
        return "";
      }
    );

    return TextSpan(style: style, children: childrenSpan);
  }
}

class MarkdownField extends HookWidget {
  MarkdownField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = MarkdownTextEditingController();

    return TextField(
      expands: true,
      minLines: null,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(20.0),
      ),
      controller: controller,
    );
  }
}