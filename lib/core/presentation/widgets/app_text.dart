import 'package:flutter/material.dart';
import 'package:nashik/core/theme/app_textstyle.dart';

/// Reusable text widgets with consistent styling
class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final Color? color;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(color: color ?? style?.color) ?? style,
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}

/// H1 - Large Heading
class H1 extends AppText {
  H1(super.text, {super.key, super.textAlign, super.maxLines, Color? color})
    : super(
        style: AppTextStyle.h1(color: color),
        overflow: TextOverflow.ellipsis,
      );
}

/// H2 - Medium Heading
class H2 extends AppText {
  H2(super.text, {super.key, super.textAlign, super.maxLines, Color? color})
    : super(
        style: AppTextStyle.h2(color: color),
        overflow: TextOverflow.ellipsis,
      );
}

/// H3 - Small Heading
class H3 extends AppText {
  H3(super.text, {super.key, super.textAlign, super.maxLines, Color? color})
    : super(
        style: AppTextStyle.h3(color: color),
        overflow: TextOverflow.ellipsis,
      );
}

/// Body - Regular text
class BodyText extends AppText {
  BodyText(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    Color? color,
    FontWeight? fontWeight,
  }) : super(
         style: AppTextStyle.body(color: color, fontWeight: fontWeight),
       );
}

/// Body Large - Slightly larger body text
class BodyLarge extends AppText {
  BodyLarge(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    Color? color,
    FontWeight? fontWeight,
  }) : super(
         style: AppTextStyle.bodyLarge(color: color, fontWeight: fontWeight),
       );
}

/// Subtitle - Secondary text
class Subtitle extends AppText {
  Subtitle(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    Color? color,
  }) : super(style: AppTextStyle.subtitle(color: color));
}

/// Caption - Small text
class Caption extends AppText {
  Caption(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    Color? color,
    FontWeight? fontWeight,
  }) : super(
         style: AppTextStyle.caption(color: color, fontWeight: fontWeight),
       );
}

/// Button Text
class ButtonText extends AppText {
  ButtonText(super.text, {super.key, super.textAlign, Color? color})
    : super(
        style: AppTextStyle.button(color: color),
        overflow: TextOverflow.visible,
      );
}

/// Label - For form labels, etc.
class Label extends AppText {
  Label(super.text, {super.key, super.textAlign, super.maxLines, Color? color})
    : super(
        style: AppTextStyle.label(color: color),
        overflow: TextOverflow.ellipsis,
      );
}
