import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/constants/home_screen.config.dart';
import 'package:groscross/models/search.dart';
import 'package:groscross/services/navigation.service.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/welcome.vm.dart';
import 'package:groscross/views/pages/vendor/widgets/banners.view.dart';
import 'package:groscross/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:groscross/views/pages/welcome/widgets/welcome_header.section.dart';
import 'package:groscross/widgets/cards/custom.visibility.dart';
import 'package:groscross/widgets/finance/wallet_management.view.dart';
import 'package:groscross/widgets/list_items/modern_vendor_type.vertical_list_item.dart';
import 'package:groscross/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:velocity_x/velocity_x.dart';

class ModernEmptyWelcome extends StatelessWidget {
  const ModernEmptyWelcome({
    required this.vm,
    Key? key,
  }) : super(key: key);

  final WelcomeViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        WelcomeHeaderSection(vm),
        VStack(
          [
            //finance section
            CustomVisibilty(
              visible: HomeScreenConfig.showWalletOnHomeScreen,
              child: WalletManagementView().px20().py16(),
            ),

            //top banner
            CustomVisibilty(
              visible: (HomeScreenConfig.showBannerOnHomeScreen &&
                  HomeScreenConfig.isBannerPositionTop),
              child: Banners(
                null,
                featured: true,
                padding: 6,
              ),
            ),
            //
            VStack(
              [
                //gridview
                CustomVisibilty(
                  visible: HomeScreenConfig.isVendorTypeListingGridView &&
                      vm.showGrid &&
                      vm.isBusy,
                  child: LoadingShimmer().px20().centered(),
                ),
                CustomVisibilty(
                  visible: HomeScreenConfig.isVendorTypeListingGridView &&
                      vm.showGrid &&
                      !vm.isBusy,
                  child: AnimationLimiter(
                    child: MasonryGrid(
                      column: HomeScreenConfig.vendorTypePerRow,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: List.generate(
                        vm.vendorTypes.length,
                        (index) {
                          final vendorType = vm.vendorTypes[index];
                          return ModernVendorTypeVerticalListItem(
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
        )
            .scrollVertical()
            .box
            .color(context.theme.colorScheme.background)
            .make()
            .expand(),
      ],
    );
  }
}
