import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:groscross/constants/app_colors.dart';
import 'package:groscross/constants/app_routes.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/models/search.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewAllVendorsView extends StatelessWidget {
  const ViewAllVendorsView({
    Key? key,
    required this.vendorType,
  }) : super(key: key);
  final VendorType vendorType;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        CustomVisibilty(
          visible: !AppStrings.enableSingleVendor,
          child: HStack(
            [
              UiSpacer.horizontalSpace(),
              "View all vendors".tr().text.white.center.sm.make().expand(),
              Icon(
                FlutterIcons.arrow_right_evi,
                color: Colors.white,
              )
            ],
          )
              .p8()
              .onInkTap(() {
                //open search with vendor type
                Navigator.pushNamed(
                  context,
                  AppRoutes.search,
                  arguments: Search(
                    vendorType: vendorType,
                    showType: vendorType.isService ? 5 : 4,
                  ),
                );
              })
              .box
              .rounded
              .color(AppColor.primaryColor)
              .make()
              .p12(),
        ),
        CustomVisibilty(
          visible: AppStrings.enableSingleVendor,
          child: HStack(
            [
              UiSpacer.horizontalSpace(),
              (!vendorType.isService
                      ? "View all products".tr()
                      : "View all services".tr())
                  .text
                  .white
                  .center
                  .sm
                  .make()
                  .expand(),
              Icon(
                FlutterIcons.arrow_right_evi,
                color: Colors.white,
              )
            ],
          )
              .p8()
              .onInkTap(() {
                //open search with vendor type
                Navigator.pushNamed(
                  context,
                  AppRoutes.search,
                  arguments: Search(
                    vendorType: vendorType,
                    showType: vendorType.isService ? 3 : 2,
                  ),
                );
              })
              .box
              .rounded
              .color(AppColor.primaryColor)
              .make()
              .p12(),
        )
      ],
    );
  }
}
