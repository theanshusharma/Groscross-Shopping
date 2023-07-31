import 'package:flutter/material.dart';
import 'package:groscross/models/delivery_address.dart';
import 'package:groscross/services/validator.service.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/view_models/delivery_address/edit_delivery_addresses.vm.dart';
import 'package:groscross/views/pages/delivery_address/widgets/what3words.view.dart';
import 'package:groscross/widgets/base.page.dart';
import 'package:groscross/widgets/buttons/custom_button.dart';
import 'package:groscross/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EditDeliveryAddressesPage extends StatelessWidget {
  const EditDeliveryAddressesPage({
    this.deliveryAddress,
    Key? key,
  }) : super(key: key);

  final DeliveryAddress? deliveryAddress;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditDeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () =>
          EditDeliveryAddressesViewModel(context, deliveryAddress),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Update Delivery Address".tr(),
          body: Form(
            key: vm.formKey,
            child: VStack(
              [
                //
                CustomTextFormField(
                  labelText: "Name".tr(),
                  textEditingController: vm.nameTEC,
                  validator: FormValidator.validateName,
                ),
                //what3words
                What3wordsView(vm),
                CustomTextFormField(
                  labelText: "Address".tr(),
                  isReadOnly: true,
                  textEditingController: vm.addressTEC,
                  validator: (value) => FormValidator.validateEmpty(
                    value,
                    errorTitle: "Address".tr(),
                  ),
                  onTap: vm.openLocationPicker,
                ).py2(),
                // description
                UiSpacer.verticalSpace(),
                CustomTextFormField(
                  labelText: "Description".tr(),
                  textEditingController: vm.descriptionTEC,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
                ).py2(),
                //
                HStack(
                  [
                    Checkbox(
                      value: vm.isDefault,
                      onChanged: vm.toggleDefault,
                    ),
                    //
                    "Default".tr().text.make(),
                  ],
                )
                    .onInkTap(
                      () => vm.toggleDefault(!vm.isDefault),
                    )
                    .wFull(context)
                    .py12(),

                CustomButton(
                  isFixedHeight: true,
                  height: Vx.dp48,
                  title: "Save".tr(),
                  onPressed: vm.updateDeliveryAddress,
                  loading: vm.isBusy,
                ).centered(),
              ],
            ).p20().scrollVertical(),
          ),
        );
      },
    );
  }
}
