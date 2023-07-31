import 'package:flutter/material.dart';
import 'package:groscross/services/auth.service.dart';
import 'package:groscross/view_models/payment.view_model.dart';
import 'package:groscross/models/user.dart';
import 'package:groscross/requests/auth.request.dart';
import 'package:groscross/views/pages/splash.page.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountDeleteViewModel extends PaymentViewModel {
  //
  User? currentUser;
  AuthRequest _authRequest = AuthRequest();
  bool otherReason = false;
  String? reason;

  AccountDeleteViewModel(BuildContext context) {
    this.viewContext = context;
  }

  List<String> get reasons {
    return ["customer support", "other"];
  }

  onReasonChange(String reason) {
    otherReason = reason.toLowerCase() == "other";
    if (!otherReason) {
      reason = reason;
    }
    notifyListeners();
  }

  processAccountDeletion() async {
    _authRequest.delete("");
    if (formBuilderKey.currentState!.saveAndValidate()) {
      //
      setBusy(true);
      try {
        final formValue = formBuilderKey.currentState?.value;
        final apiResponse = await _authRequest.deleteProfile(
          password: formValue!["password"],
        );
        if (apiResponse.allGood) {
          toastSuccessful("${apiResponse.message}");
          await AuthServices.logout();
          viewContext.nextAndRemoveUntilPage(
            SplashPage(),
          );
        } else {
          toastError("${apiResponse.message}");
        }
      } catch (error) {
        toastError("$error");
      }
      setBusy(false);
    }
  }
}
