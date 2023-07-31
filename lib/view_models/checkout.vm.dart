import 'package:flutter/material.dart';
import 'package:groscross/models/checkout.dart';
import 'package:groscross/view_models/checkout_base.vm.dart';

class CheckoutViewModel extends CheckoutBaseViewModel {
  //

  //
  CheckoutViewModel(
    BuildContext context,
    CheckOut checkout,
  ) {
    this.viewContext = context;
    this.checkout = checkout;
  }
}
