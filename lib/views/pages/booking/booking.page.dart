import 'package:flutter/material.dart';
import 'package:groscross/constants/app_colors.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/view_models/service.vm.dart';
import 'package:groscross/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingPage extends StatefulWidget {
  const BookingPage(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with AutomaticKeepAliveClientMixin<BookingPage> {
  GlobalKey pageKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ViewModelBuilder<ServiceViewModel>.reactive(
      viewModelBuilder: () => ServiceViewModel(context, widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          showCart: true,
          key: pageKey,
          body: VStack(
            [],
          ).scrollVertical(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
