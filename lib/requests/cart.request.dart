import 'package:groscross/constants/api.dart';
import 'package:groscross/models/api_response.dart';
import 'package:groscross/models/coupon.dart';
import 'package:groscross/services/http.service.dart';

class CartRequest extends HttpService {
  //
  Future<Coupon> fetchCoupon(String code, {int? vendorTypeId}) async {
    Map<String, dynamic> params = {};
    if (vendorTypeId != null) {
      params = {
        "vendor_type_id": vendorTypeId,
      };
    }

    final apiResult = await get(
      "${Api.coupons}/$code",
      queryParameters: params,
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Coupon.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message!;
    }
  }
}
