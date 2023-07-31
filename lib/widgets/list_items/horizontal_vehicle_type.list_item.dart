import 'package:flutter/material.dart';
import 'package:groscross/constants/app_colors.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/extensions/string.dart';
import 'package:groscross/models/vehicle_type.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/taxi.vm.dart';
import 'package:groscross/widgets/currency_hstack.dart';
import 'package:groscross/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';

class HorizontalVehicleTypeListItem extends StatelessWidget {
  const HorizontalVehicleTypeListItem(
    this.vm,
    this.vehicleType, {
    Key? key,
  }) : super(key: key);
  final VehicleType vehicleType;
  final TaxiViewModel vm;
  @override
  Widget build(BuildContext context) {
    //
    final selected = vm.selectedVehicleType?.id == vehicleType.id;
    final currencySymbol = vehicleType.currency != null
        ? vehicleType.currency?.symbol
        : AppStrings.currencySymbol;
    //
    return HStack(
      [
        //
        CustomImage(
          imageUrl: vehicleType.photo,
          width: 55,
          height: 40,
          boxFit: BoxFit.contain,
        ),
        VStack(
          [
            "${vehicleType.name}".text.bold.maxLines(1).ellipsis.make(),
            UiSpacer.vSpace(3),
            HStack(
              [
                CurrencyHStack(
                  [
                    "min".tr(),
                    " ",
                    "$currencySymbol",
                    vehicleType.minFare.currencyValueFormat()
                  ],
                  textSize: 12,
                  textColor: Colors.grey.shade600,
                ),
                DotIndicator(size: 5, color: Colors.grey.shade600).px8(),
                CurrencyHStack(
                  [
                    "base".tr(),
                    " ",
                    "$currencySymbol",
                    vehicleType.baseFare.currencyValueFormat()
                  ],
                  textSize: 12,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ],
        ).px8().expand(),
        //prices
        VStack(
          [
            CurrencyHStack([
              " $currencySymbol ".text.extraBold.make(),
              " ${vehicleType.total} "
                  .currencyValueFormat()
                  .text
                  .extraBold
                  .make(),
            ]),
          ],
        ),
      ],
      alignment: MainAxisAlignment.center,
      // crossAlignment: CrossAxisAlignment.center,
    )
        .box
        .p12
        // .px12
        .color(selected
            ? AppColor.primaryColor.withOpacity(0.15)
            : AppColor.primaryColor.withOpacity(0.01))
        .roundedSM
        .make()
        .onTap(
          () => vm.changeSelectedVehicleType(vehicleType),
        );
  }
}
