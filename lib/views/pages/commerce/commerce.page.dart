import 'package:flutter/material.dart';
import 'package:groscross/constants/app_colors.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/enums/product_fetch_data_type.enum.dart';
import 'package:groscross/models/search.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/services/navigation.service.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/views/pages/commerce/widgets/commerce_categories_products.view.dart';
import 'package:groscross/views/pages/commerce/widgets/products_section.view.dart';
import 'package:groscross/views/pages/flash_sale/widgets/flash_sale.view.dart';
import 'package:groscross/views/pages/vendor/widgets/banners.view.dart';
import 'package:groscross/widgets/base.page.dart';
import 'package:groscross/widgets/inputs/search_bar.input.dart';
import 'package:groscross/widgets/vendor_type_categories.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class CommercePage extends StatefulWidget {
  const CommercePage(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;
  @override
  _CommercePageState createState() => _CommercePageState();
}

class _CommercePageState extends State<CommercePage>
    with AutomaticKeepAliveClientMixin<CommercePage> {
  @override
  bool get wantKeepAlive => true;

  GlobalKey pageKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      showAppBar: true,
      showLeadingAction: !AppStrings.isSingleVendorMode,
      elevation: 0,
      title: AppStrings.isSingleVendorMode ? "" : "${widget.vendorType.name}",
      appBarColor: AppColor.faintBgColor,
      appBarItemColor: AppColor.primaryColor,
      showCart: true,
      backgroundColor: AppColor.faintBgColor,
      key: pageKey,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: new RefreshController(),
        onRefresh: () {
          setState(() {
            pageKey = GlobalKey<State>();
          });
        },
        child: VStack(
          [
            VStack(
              [
                //intro
                "Discover".tr().text.xl4.semiBold.make(),
                "Find anything that you want".tr().text.lg.thin.make(),
                UiSpacer.verticalSpace(),

                //search bar
                SearchBarInput(
                  showFilter: false,
                  onTap: () => showSearchPage(context),
                ),
                UiSpacer.verticalSpace(),

                //banners
                Banners(
                  widget.vendorType,
                  viewportFraction: 1.0,
                  itemRadius: 10,
                ),
                //categories
                VendorTypeCategories(
                  widget.vendorType,
                  showTitle: false,
                  description: "Categories".tr(),
                  childAspectRatio: 1.4,
                  crossAxisCount: AppStrings.categoryPerRow,
                ),
              ],
            ).p20(),
            //flash sales products
            FlashSaleView(widget.vendorType),

            VStack(
              [
                //new arrivals
                ProductsSectionView(
                  "New Arrivals".tr() + " 🛬",
                  vendorType: widget.vendorType,
                  type: ProductFetchDataType.NEW,
                ),
                UiSpacer.vSpace(10),
                //Best sellers
                ProductsSectionView(
                  "Best Selling".tr() + " 📊",
                  vendorType: widget.vendorType,
                  type: ProductFetchDataType.BEST,
                ),
                UiSpacer.vSpace(10),
                //top 7 categories products
                CommerceCategoryProducts(widget.vendorType, length: 5),
              ],
            ).px20(),
          ],
          // key: model.pageKey,
        ).scrollVertical(),
      ),
    );
  }

  //open search page
  showSearchPage(BuildContext context) {
    final search = Search(
      showType: 4,
      vendorType: widget.vendorType,
    );
    //
    final page = NavigationService().searchPageWidget(search);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
