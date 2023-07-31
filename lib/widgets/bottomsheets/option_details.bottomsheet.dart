import 'package:flutter/material.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/extensions/string.dart';
import 'package:groscross/models/option.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/widgets/currency_hstack.dart';
import 'package:groscross/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class OptionDetailsBottomSheet extends StatelessWidget {
  const OptionDetailsBottomSheet(this.option, {Key? key}) : super(key: key);

  final Option option;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Visibility(
          visible: option.photo.isNotDefaultImage,
          child: CustomImage(
            imageUrl: option.photo,
            width: context.percentWidth * 100,
            height: context.percentWidth * 60,
            canZoom: true,
          ),
        ),
        UiSpacer.vSpace(),
        //name
        option.name.text.xl.semiBold.make(),
        UiSpacer.vSpace(10),
        //price
        Visibility(
          visible: option.price > 0,
          child: CurrencyHStack(
            [
              AppStrings.currencySymbol.text.sm.bold
                  .color(context.primaryColor)
                  .make(),
              option.price
                  .currencyValueFormat()
                  .text
                  .xl
                  .bold
                  .color(context.primaryColor)
                  .make(),
            ],
            crossAlignment: CrossAxisAlignment.end,
          ),
        ),
        UiSpacer.vSpace(15),
        //description
        Visibility(
          visible: "${option.description}".isNotEmpty,
          child: "${option.description}".text.sm.make(),
        ),
      ],
    ).p20();
  }
}
