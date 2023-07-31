import 'package:flutter/material.dart';
import 'package:groscross/constants/app_routes.dart';
import 'package:groscross/models/product.dart';
import 'package:groscross/models/vendor_type.dart';
import 'package:groscross/requests/product.request.dart';
import 'package:groscross/view_models/base.view_model.dart';

class ForYouProductsViewModel extends MyBaseViewModel {
  //
  ProductRequest _productRequest = ProductRequest();
  //
  List<Product> products = [];
  VendorType? vendorType;

  ForYouProductsViewModel(BuildContext context, this.vendorType) {
    this.viewContext = context;
  }

  //
  initialise() async {
    setBusy(true);
    try {
      products = await _productRequest.forYouProductsRequest(
        queryParams: {
          "vendor_type_id": vendorType?.id,
        },
      );
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  productSelected(Product product) async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );
  }
}
