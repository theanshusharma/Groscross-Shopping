import 'package:flutter/material.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/extensions/string.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/product_details.vm.dart';
import 'package:groscross/widgets/cards/custom.visibility.dart';
import 'package:groscross/widgets/currency_hstack.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductPrice extends StatelessWidget {
  const CommerceProductPrice({
    required this.model,
    Key? key,
  }) : super(key: key);

  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
//price
    final currencySymbol = AppStrings.currencySymbol;
    return HStack(
      [
        "Price:".text.make().expand(flex: 2),
        UiSpacer.smHorizontalSpace(),
        //price
        HStack(
          [
            CurrencyHStack(
              [
                currencySymbol.text.sm.bold.color(context.primaryColor).make(),
                model.product.sellPrice
                    .currencyValueFormat()
                    .text
                    .xl
                    .bold
                    .color(context.primaryColor)
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.end,
            ),
            UiSpacer.smHorizontalSpace(),
            //discount
            CustomVisibilty(
              visible: model.product.showDiscount,
              child: CurrencyHStack(
                [
                  currencySymbol.text.lineThrough.xs
                      .color(context.primaryColor)
                      .make(),
                  model.product.price
                      .currencyValueFormat()
                      .text
                      .lineThrough
                      .lg
                      .thin
                      .color(context.primaryColor)
                      .make(),
                ],
              ),
            ),
          ],
        ).expand(flex: 4),
      ],
    ).py12().px20();
  }
}
