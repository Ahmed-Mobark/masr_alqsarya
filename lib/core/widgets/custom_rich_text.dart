import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    this.startSubTextStyle,
    this.centerSubTextStyle,
    this.endSubTextStyle,
    this.startSubText,
    this.centerSubText,
    this.endSubText,
    this.textAlign
  });

  final TextStyle? startSubTextStyle;
  final TextStyle? centerSubTextStyle;
  final TextStyle? endSubTextStyle;
  final String? startSubText;
  final String? centerSubText;
  final String? endSubText;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        style: TextStyles.textViewRegular14.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
        children: [
          TextSpan(
            text: startSubText,
            style: startSubTextStyle,
          ),
          TextSpan(
            text: centerSubText,
            style: centerSubTextStyle,
          ),
          TextSpan(
            text: endSubText,
            style: endSubTextStyle,
          )
        ]
      ) 
    );
  }
}