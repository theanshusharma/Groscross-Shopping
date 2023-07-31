import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:groscross/services/validator.service.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/login.view_model.dart';
import 'package:groscross/widgets/buttons/custom_button.dart';
import 'package:groscross/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OTPLoginView extends StatelessWidget {
  const OTPLoginView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.formKey,
      child: VStack(
        [
          //
          HStack(
            [
              CustomTextFormField(
                prefixIcon: HStack(
                  [
                    //icon/flag
                    Flag.fromString(
                      model.selectedCountry?.countryCode ?? "us",
                      width: 20,
                      height: 20,
                    ),
                    UiSpacer.horizontalSpace(space: 5),
                    //text
                    ("+" + (model.selectedCountry?.phoneCode ?? "1"))
                        .text
                        .make(),
                  ],
                ).px8().onInkTap(model.showCountryDialPicker),
                labelText: "Phone".tr(),
                hintText: "",
                keyboardType: TextInputType.phone,
                textEditingController: model.phoneTEC,
                validator: FormValidator.validatePhone,
              ).expand(),
            ],
          ).py12(),
          //

          CustomButton(
            title: "Login".tr(),
            loading: model.busy(model.otpLogin),
            onPressed: model.processOTPLogin,
          ).centered().py12(),
        ],
        crossAlignment: CrossAxisAlignment.end,
      ),
    ).py20();
  }
}
