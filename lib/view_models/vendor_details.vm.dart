import 'package:flutter/material.dart';
import 'package:groscross/constants/app_routes.dart';
import 'package:groscross/models/vendor.dart';
import 'package:groscross/models/product.dart';
import 'package:groscross/requests/vendor.request.dart';
import 'package:groscross/constants/app_strings.dart';
import 'package:groscross/view_models/base.view_model.dart';
import 'package:groscross/views/pages/pharmacy/pharmacy_upload_prescription.page.dart';
import 'package:groscross/views/pages/vendor_search/vendor_search.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorDetailsViewModel extends MyBaseViewModel {
  //
  VendorDetailsViewModel(
    BuildContext context,
    this.vendor,
  ) {
    this.viewContext = context;
  }

  //
  VendorRequest _vendorRequest = VendorRequest();

  //
  Vendor? vendor;
  TabController? tabBarController;
  final currencySymbol = AppStrings.currencySymbol;

  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  //
  Map<int, List> menuProducts = {};
  Map<int, int> menuProductsQueryPages = {};

  //
  void getVendorDetails() async {
    //
    setBusy(true);

    try {
      vendor = await _vendorRequest.vendorDetails(
        vendor!.id,
        params: {
          "type": "small",
        },
      );

      clearErrors();
    } catch (error) {
      setError(error);
      print("error ==> ${error}");
    }
    setBusy(false);
  }

  void productSelected(Product product) async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );

    //
    notifyListeners();
  }

  //
  void uploadPrescription() {
    //
    viewContext.push(
      (context) => PharmacyUploadPrescription(vendor!),
    );
  }

  openVendorSearch() {
    viewContext.push(
      (context) => VendorSearchPage(vendor!),
    );
  }
}
