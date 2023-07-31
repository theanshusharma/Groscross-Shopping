import 'package:flutter/material.dart';
import 'package:groscross/constants/app_colors.dart';
import 'package:groscross/extensions/string.dart';
import 'package:groscross/models/coupon.dart';
import 'package:groscross/utils/ui_spacer.dart';
import 'package:groscross/utils/utils.dart';
import 'package:groscross/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CouponListItem extends StatelessWidget {
  const CouponListItem(
    this.coupon, {
    this.onPressed,
    this.radius = 4,
    Key? key,
  }) : super(key: key);

  final Coupon coupon;
  final double radius;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    Color fromColor = coupon.color != null
        ? Vx.hexToColor(coupon.color!)
        : AppColor.primaryColor;
    if (fromColor == Colors.black) {
      fromColor = AppColor.primaryColor;
    }
    Color toColor = fromColor.withAlpha(150);
    return HStack(
      [
        //
        Visibility(
          visible: coupon.photo.isNotDefaultImage,
          child: HStack(
            [
              CustomImage(imageUrl: coupon.photo).wh(60, 60),
              UiSpacer.hSpace(),
            ],
          ),
        ),

        //
        VStack(
          [
            coupon.code.text.xl2.extraBold
                .color(Utils.textColorByColor(fromColor))
                .make(),
            "${coupon.description}"
                .text
                .sm
                .medium
                .maxLines(2)
                .ellipsis
                .color(Utils.textColorByColor(fromColor))
                .make(),
          ],
        ).expand(),
      ],
    )
        .px(20)
        .py(12)
        .box
        .roundedSM
        .outerShadowXl
        .gradientFromTo(from: fromColor, to: toColor)
        .make()
        .onTap(onPressed != null ? () => onPressed!(coupon) : null);
  }
}
