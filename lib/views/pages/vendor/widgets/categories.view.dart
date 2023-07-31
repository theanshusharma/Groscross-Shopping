import 'package:flutter/material.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/vendor/categories.vm.dart';
import 'package:groscross/views/pages/category/categories.page.dart';
import 'package:groscross/widgets/custom_horizontal_list_view.dart';
import 'package:groscross/widgets/list_items/category.list_item.dart';
import 'package:groscross/widgets/section.title.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class Categories extends StatelessWidget {
  const Categories(this.vendorType, {Key? key}) : super(key: key);
  final VendorType vendorType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () => CategoriesViewModel(
        context,
        vendorType: vendorType,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            HStack(
              [
                SectionTitle("Categories".tr()).expand(),
                UiSpacer.smHorizontalSpace(),
                "See all".tr().text.color(context.primaryColor).make().onInkTap(
                  () {
                    //
                    context.nextPage(
                      CategoriesPage(vendorType: vendorType),
                    );
                  },
                ),
              ],
            ).p12(),

            //categories list
            CustomHorizontalListView(
              isLoading: model.isBusy,
              itemsViews: model.categories.map(
                (category) {
                  return CategoryListItem(
                    category: category,
                    onPressed: model.categorySelected,
                    maxLine: false,
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}
