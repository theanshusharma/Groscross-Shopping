import 'package:flutter/material.dart';
import 'package:groscross/constants/app_colors.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/extensions/dynamic.dart';
import 'package:groscross/extensions/string.dart';
import 'package:groscross/models/service.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/utils/utils.dart';
import 'package:groscross/widgets/cards/vendor_info.view.dart';
import 'package:groscross/widgets/custom_image.view.dart';
import 'package:groscross/widgets/states/alternative.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceGridViewItem extends StatelessWidget {
  const ServiceGridViewItem({
    required this.service,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function(Service) onPressed;
  final Service service;

  //
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Stack(
          children: [
            AlternativeView(
              ismain: (service.photos != null && service.photos!.isNotEmpty),
              main: CustomImage(
                imageUrl: (service.photos != null && service.photos!.isNotEmpty)
                    ? service.photos!.first
                    : "",
                width: double.infinity,
                height: 160,
              ),
              alt: Container(
                color: Vx.randomOpaqueColor.withAlpha(50),
                width: double.infinity,
                height: 60,
                child: "${service.name}"
                    .text
                    .color(Vx.randomOpaqueColor.withOpacity(0.1))
                    .center
                    .make()
                    .centered()
                    .p12(),
              ),
            ).pOnly(bottom: 10),

            //price
            Positioned(
              bottom: 0,
              right: !Utils.isArabic ? 20 : null,
              left: Utils.isArabic ? 20 : null,
              child: ((service.hasOptions ? "From".tr() : "") +
                      " " +
                      "${AppStrings.currencySymbol} ${service.sellPrice}"
                          .currencyFormat() +
                      " ${service.durationText}")
                  .text
                  .sm
                  .color(Utils.textColorByTheme())
                  .make()
                  .px8()
                  .py2()
                  .box
                  .roundedLg
                  .border(
                    width: 1.6,
                    color: Utils.textColorByTheme(),
                  )
                  .color(AppColor.primaryColor)
                  .make(),
            ),

            //discount
            Visibility(
              visible: service.showDiscount,
              child: "%s Off"
                  .tr()
                  .fill(["${service.discountPercentage}%"])
                  .text
                  .sm
                  .white
                  .semiBold
                  .make()
                  .p2()
                  .px4()
                  .box
                  .red500
                  .withRounded(value: 7)
                  .make(),
            ),
          ],
        ),

        //
        VStack(
          [
            "${service.name}".text.sm.semiBold.maxLines(2).ellipsis.make(),
            UiSpacer.divider(thickness: 0.50, height: 0.3).py8().px4(),
            //provider info
            VendorInfoView(service.vendor),
            UiSpacer.vSpace(10),
          ],
        ).px12().py4(),
      ],
    )
        .wFull(context)
        .box
        .withRounded(value: 7)
        .color(context.cardColor)
        .outerShadowSm
        .clip(Clip.antiAlias)
        .makeCentered()
        .onInkTap(
          () => this.onPressed(this.service),
        );
  }
}
