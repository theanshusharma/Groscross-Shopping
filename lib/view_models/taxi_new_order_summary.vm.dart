import 'package:flutter/material.dart';
import 'package:groscross/constants/app_ui_sizes.dart';
import 'package:groscross/requests/taxi.request.dart';
import 'package:groscross/services/geocoder.service.dart';
import 'package:groscross/view_models/base.view_model.dart';
import 'package:groscross/view_models/taxi.vm.dart';
import 'package:groscross/views/shared/payment_method_selection.page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import "package:velocity_x/velocity_x.dart";

class NewTaxiOrderSummaryViewModel extends MyBaseViewModel {
  //
  NewTaxiOrderSummaryViewModel(BuildContext context, this.taxiViewModel) {
    this.viewContext = context;
  }

  TaxiRequest taxiRequest = TaxiRequest();
  GeocoderService geocoderService = GeocoderService();
  final TaxiViewModel taxiViewModel;
  PanelController panelController = PanelController();
  double customViewHeight = AppUISizes.taxiNewOrderSummaryHeight;

  initialise() {}

  //
  updateLoadingheight() {
    customViewHeight = AppUISizes.taxiNewOrderHistoryHeight;
    notifyListeners();
  }

  resetStateViewheight([double height = 0]) {
    customViewHeight = AppUISizes.taxiNewOrderIdleHeight + height;
    notifyListeners();
  }

  closePanel() async {
    clearFocus();
    await panelController.close();
    notifyListeners();
  }

  clearFocus() {
    FocusScope.of(taxiViewModel.viewContext).requestFocus(new FocusNode());
  }

  openPanel() async {
    await panelController.open();
    notifyListeners();
  }

  void openPaymentMethodSelection() async {
    //
    if (taxiViewModel.paymentMethods.isEmpty) {
      await taxiViewModel.fetchTaxiPaymentOptions();
    }
    final mPaymentMethod = await viewContext.push(
      (context) => PaymentMethodSelectionPage(
        list: taxiViewModel.paymentMethods,
      ),
    );
    if (mPaymentMethod != null) {
      taxiViewModel.changeSelectedPaymentMethod(
        mPaymentMethod,
        callTotal: false,
      );
    }

    notifyListeners();
  }
}
