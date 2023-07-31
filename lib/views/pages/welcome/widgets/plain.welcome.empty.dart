import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/constants/home_screen.config.dart';
import 'package:groscross/models/search.dart';
import 'package:groscross/services/navigation.service.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/utils/utils.dart';
import 'package:groscross/view_models/welcome.vm.dart';
import 'package:groscross/views/pages/vendor/widgets/banners.view.dart';
import 'package:groscross/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:groscross/views/shared/widgets/section_coupons.view.dart';
import 'package:groscross/widgets/cards/custom.visibility.dart';
import 'package:groscross/widgets/list_items/plain_vendor_type.vertical_list_item.dart';
import 'package:groscross/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

import 'plain_welcome_header.section.dart';

class PlainEmptyWelcome extends StatefulWidget {
  const PlainEmptyWelcome({
    required this.vm,
    Key? key,
  }) : super(key: key);

  final WelcomeViewModel vm;

  @override
  State<PlainEmptyWelcome> createState() => _PlainEmptyWelcomeState();
}

class _PlainEmptyWelcomeState extends State<PlainEmptyWelcome> {
  double headerHeight = 200;
  //
  @override
  Widget build(BuildContext context) {
    //
    return Stack(
      children: [
        //
        MeasureSize(
          onChange: (size) {
            setState(() {
              headerHeight = size.height;
              if (headerHeight > 100) {
                headerHeight -= 130;
              }
            });
          },
          child: PlainWelcomeHeaderSection(widget.vm),
        ),
        UiSpacer.vSpace(),
        VStack(
          [
            //
            VStack(
              [
                UiSpacer.vSpace(),
                "Our services"
                    .tr()
                    .text
                    .bold
                    .xl2
                    .color(Utils.textColorByTheme())
                    .make(),
                UiSpacer.vSpace(),
                //gridview
                CustomVisibilty(
                  visible: HomeScreenConfig.isVendorTypeListingGridView &&
                      widget.vm.showGrid &&
                      widget.vm.isBusy,
                  child: LoadingShimmer().px20().centered(),
                ),
                CustomVisibilty(
                  visible: HomeScreenConfig.isVendorTypeListingGridView &&
                      widget.vm.showGrid &&
                      !widget.vm.isBusy,
                  child: AnimationLimiter(
                    child: MasonryGrid(
                      column: HomeScreenConfig.vendorTypePerRow,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: List.generate(
                        widget.vm.vendorTypes.length,
                        (index) {
                          final vendorType = widget.vm.vendorTypes[index];
                          return PlainVendorTypeVerticalListItem(
                            vendorType,
                            onPressed: () {
                              NavigationService.pageSelected(
                                vendorType,
                                context: context,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ).p20(),

            //botton banner
            CustomVisibilty(
              visible: HomeScreenConfig.showBannerOnHomeScreen &&
                  !HomeScreenConfig.isBannerPositionTop,
              child: Banners(
                null,
                featured: true,
              ).py12().pOnly(bottom: context.percentHeight * 10),
            ),

            //coupons
            SectionCouponsView(
              null,
              title: "Promo".tr(),
              scrollDirection: Axis.horizontal,
              itemWidth: context.percentWidth * 70,
              height: 100,
              itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              bPadding: 10,
            ),
            //featured vendors
            SectionVendorsView(
              null,
              title: "Featured Vendors".tr(),
              scrollDirection: Axis.horizontal,
              type: SearchFilterType.featured,
              itemWidth: context.percentWidth * 48,
              byLocation: AppStrings.enableFatchByLocation,
            ),
            //spacing
            UiSpacer.vSpace(100),
          ],
        ).pOnly(top: headerHeight),
      ],
    ).scrollVertical();
  }
}
