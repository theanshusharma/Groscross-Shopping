import 'package:flutter/material.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/vendor_details.vm.dart';
import 'package:groscross/views/pages/vendor_details/service_vendor_details.page.dart';
import 'package:groscross/views/pages/vendor_details/widgets/upload_prescription.btn.dart';
import 'package:groscross/views/pages/vendor_details/widgets/vendor_with_subcategory.view.dart';
import 'package:groscross/widgets/base.page.dart';
import 'package:groscross/widgets/buttons/custom_leading.dart';
import 'package:groscross/widgets/buttons/share.btn.dart';
import 'package:groscross/widgets/cards/custom.visibility.dart';
import 'package:groscross/widgets/cart_page_action.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorPlainDetailsView extends StatelessWidget {
  const VendorPlainDetailsView(this.model, {Key? key}) : super(key: key);
  final VendorDetailsViewModel model;
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      showCart: true,
      elevation: 0,
      extendBodyBehindAppBar: true,
      appBarColor: Colors.transparent,
      backgroundColor: context.theme.colorScheme.background,
      leading: CustomLeading(),
      fab: UploadPrescriptionFab(model),
      actions: [
        SizedBox(
          width: 50,
          height: 50,
          child: FittedBox(
            child: ShareButton(
              model: model,
            ),
          ),
        ),
        UiSpacer.hSpace(10),
        PageCartAction(),
      ],
      body: VStack(
        [
          //subcategories && hide for service vendor type
          CustomVisibilty(
            visible: (model.vendor!.hasSubcategories &&
                !model.vendor!.isServiceType),
            child: VendorDetailsWithSubcategoryPage(
              vendor: model.vendor!,
            ),
          ),

          //show for service vendor type
          CustomVisibilty(
            visible: model.vendor!.isServiceType,
            child: ServiceVendorDetailsPage(
              model,
              vendor: model.vendor!,
            ),
          ),
        ],
      ),
    );
  }
}
