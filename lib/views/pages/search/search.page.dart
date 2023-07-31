import 'package:flutter/material.dart';
import 'package:groscross/models/product.dart';
import 'package:groscross/models/search.dart';
import 'package:groscross/models/service.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/search.vm.dart';
import 'package:groscross/views/pages/search/widget/search.header.dart';
import 'package:groscross/views/pages/search/widget/vendor_search_header.view.dart';
import 'package:groscross/widgets/base.page.dart';
import 'package:groscross/widgets/cards/custom.visibility.dart';
import 'package:groscross/widgets/custom_dynamic_grid_view.dart';
import 'package:groscross/widgets/custom_list_view.dart';
import 'package:groscross/widgets/list_items/commerce_product.list_item.dart';
import 'package:groscross/widgets/list_items/grid_view_service.list_item.dart';
import 'package:groscross/widgets/list_items/grocery_product.list_item.dart';
import 'package:groscross/widgets/list_items/horizontal_product.list_item.dart';
import 'package:groscross/widgets/list_items/vendor.list_item.dart';
import 'package:groscross/widgets/states/search.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key, required this.search, this.showCancel = true})
      : super(key: key);

  //
  final Search search;
  final bool showCancel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(context, search),
      disposeViewModel: false,
      builder: (context, model, child) {
        return BasePage(
          showCartView: showCancel,
          body: SafeArea(
            bottom: false,
            child: VStack(
              [
                //header
                UiSpacer.verticalSpace(),
                SearchHeader(model, showCancel: showCancel),

                //tags
                VendorSearchHeaderview(model),

                //vendors listview
                CustomVisibilty(
                  visible: model.selectTagId == 1,
                  child: CustomListView(
                    refreshController: model.refreshController,
                    canRefresh: true,
                    canPullUp: true,
                    onRefresh: model.startSearch,
                    onLoading: () => model.startSearch(initialLoaoding: false),
                    isLoading: model.isBusy,
                    dataSet: model.searchResults,
                    itemBuilder: (context, index) {
                      //
                      final searchResult = model.searchResults[index];
                      if (searchResult is Product) {
                        //grocery product list item
                        if (searchResult.vendor.vendorType.isGrocery) {
                          return GroceryProductListItem(
                            product: searchResult,
                            onPressed: model.productSelected,
                            qtyUpdated: model.addToCartDirectly,
                          );
                        } else if (searchResult.vendor.vendorType.isCommerce) {
                          return CommerceProductListItem(
                            searchResult,
                            height: 80,
                          );
                        } else {
                          //regular views
                          return HorizontalProductListItem(
                            searchResult,
                            onPressed: model.productSelected,
                            qtyUpdated: model.addToCartDirectly,
                          );
                        }
                      } else if (searchResult is Service) {
                        return GridViewServiceListItem(
                          service: searchResult,
                          onPressed: model.servicePressed,
                        );
                      } else {
                        return VendorListItem(
                          vendor: searchResult,
                          onPressed: model.vendorSelected,
                        );
                      }
                    },
                    separatorBuilder: (context, index) =>
                        UiSpacer.verticalSpace(space: 10),
                    emptyWidget: EmptySearch(),
                  ).expand(),
                ),

                //product/services related view
                CustomVisibilty(
                  visible: model.selectTagId != 1,
                  child: VStack(
                    [
                      //result listview
                      CustomVisibilty(
                        visible: !model.showGrid,
                        child: CustomListView(
                          refreshController: model.refreshController,
                          canRefresh: true,
                          canPullUp: true,
                          onRefresh: model.startSearch,
                          onLoading: () =>
                              model.startSearch(initialLoaoding: false),
                          isLoading: model.isBusy,
                          dataSet: model.searchResults,
                          itemBuilder: (context, index) {
                            //
                            final searchResult = model.searchResults[index];
                            if (searchResult is Product) {
                              //grocery product list item
                              if (searchResult.vendor.vendorType.isGrocery) {
                                return GroceryProductListItem(
                                  product: searchResult,
                                  onPressed: model.productSelected,
                                  qtyUpdated: model.addToCartDirectly,
                                );
                              } else if (searchResult
                                  .vendor.vendorType.isCommerce) {
                                return CommerceProductListItem(
                                  searchResult,
                                  height: 80,
                                );
                              } else {
                                //regular views
                                return HorizontalProductListItem(
                                  searchResult,
                                  onPressed: model.productSelected,
                                  qtyUpdated: model.addToCartDirectly,
                                );
                              }
                            } else if (searchResult is Service) {
                              return GridViewServiceListItem(
                                service: searchResult,
                                onPressed: model.servicePressed,
                              );
                            } else {
                              return VendorListItem(
                                vendor: searchResult,
                                onPressed: model.vendorSelected,
                              );
                            }
                          },
                          separatorBuilder: (context, index) =>
                              UiSpacer.verticalSpace(space: 10),
                          emptyWidget: EmptySearch(),
                        ).expand(),
                      ),

                      //result gridview
                      CustomVisibilty(
                        visible: model.showGrid,
                        child: CustomDynamicHeightGridView(
                          noScrollPhysics: true,
                          refreshController: model.refreshController,
                          canRefresh: true,
                          canPullUp: true,
                          onRefresh: model.startSearch,
                          onLoading: () =>
                              model.startSearch(initialLoaoding: false),
                          isLoading: model.isBusy,
                          itemCount: model.searchResults.length,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          itemBuilder: (context, index) {
                            //
                            final searchResult = model.searchResults[index];
                            if (searchResult is Product) {
                              //regular views
                              return CommerceProductListItem(
                                searchResult,
                                height: 80,
                              );
                            } else if (searchResult is Service) {
                              return GridViewServiceListItem(
                                service: searchResult,
                                onPressed: model.servicePressed,
                              );
                            } else {
                              return VendorListItem(
                                vendor: searchResult,
                                onPressed: model.vendorSelected,
                              );
                            }
                          },
                          separatorBuilder: (context, index) =>
                              UiSpacer.verticalSpace(space: 10),
                          emptyWidget: EmptySearch(),
                        ).expand(),
                      ),
                    ],
                  ).expand(),
                ),
              ],
            ).pOnly(
              left: Vx.dp16,
              right: Vx.dp16,
            ),
          ),
        );
      },
    );
  }
}
