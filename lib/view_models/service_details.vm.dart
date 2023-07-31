import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:groscross/constants/app_routes.dart';
import 'package:groscross/models/service.dart';
import 'package:groscross/models/service_option.dart';
import 'package:groscross/models/service_option_group.dart';
import 'package:groscross/requests/service.request.dart';
import 'package:groscross/services/alert.service.dart';
import 'package:groscross/services/auth.service.dart';
import 'package:groscross/view_models/base.view_model.dart';
import 'package:groscross/views/pages/auth/login.page.dart';
import 'package:groscross/views/pages/service/service_booking_summary.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:groscross/constants/app_strings.dart';

class ServiceDetailsViewModel extends MyBaseViewModel {
  //
  ServiceDetailsViewModel(BuildContext context, this.service) {
    this.viewContext = context;
  }

  //
  ServiceRequest serviceRequest = ServiceRequest();
  Service service;
  List<ServiceOption> selectedOptions = [];
  List<int> selectedOptionsIDs = [];
  double subTotal = 0.0;
  double total = 0.0;
  final currencySymbol = AppStrings.currencySymbol;

  void getServiceDetails() async {
    //
    setBusyForObject(service, true);

    try {
      final oldProductHeroTag = service.heroTag;
      service = await serviceRequest.serviceDetails(service.id);
      service.heroTag = oldProductHeroTag;

      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(service, false);
  }

  //
  void openVendorPage() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: service.vendor,
    );
  }

  //
  isOptionSelected(ServiceOption option) {
    return selectedOptionsIDs.contains(option.id);
  }

  //
  toggleOptionSelection(ServiceOptionGroup optionGroup, ServiceOption option) {
    //
    if (selectedOptionsIDs.contains(option.id)) {
      selectedOptionsIDs.remove(option.id);
      selectedOptions.remove(option);
    } else {
      //if it allows only one selection
      if (optionGroup.multiple == 0) {
        //
        final foundOption = selectedOptions.firstOrNullWhere(
          (option) => option.serviceOptionGroupId == optionGroup.id,
        );
        selectedOptionsIDs.remove(foundOption?.id);
        selectedOptions.remove(foundOption);
      }

      selectedOptionsIDs.add(option.id);
      selectedOptions.add(option);
    }

    //
    notifyListeners();
  }

  bookService() async {
    //if has options, and no option is selected but there is option group with required option
    if (service.optionGroups != null &&
        service.optionGroups!.isNotEmpty &&
        selectedOptions.isEmpty &&
        service.optionGroups!.any((optionGroup) => optionGroup.required == 1)) {
      AlertService.warning(
        title: "Aditional Option".tr(),
        text: "Please select an additional option".tr(),
      );
      return;
    }

    if (!AuthServices.authenticated()) {
      final result = await viewContext.push(
        (context) => LoginPage(),
      );
      //
      if (result == null || !(result is bool)) {
        return;
      }
    }

    //
    service.selectedOptions = selectedOptions;
    viewContext.push(
      (context) => ServiceBookingSummaryPage(service),
    );
  }
}
