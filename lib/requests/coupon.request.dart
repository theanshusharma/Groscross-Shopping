import 'package:groscross/constants/api.dart';
import 'package:groscross/models/api_response.dart';
import 'package:groscross/models/coupon.dart';
import 'package:groscross/services/http.service.dart';
import 'package:groscross/services/location.service.dart';

class CouponRequest extends HttpService {
  //
  Future<List<Coupon>> fetchCoupons({
    int page = 1,
    bool byLocation = false,
    Map? params,
  }) async {
    Map<String, dynamic> queryParameters = {
      ...(params != null ? params : {}),
      "page": "$page",
      "latitude": byLocation
          ? LocationService.currenctAddress?.coordinates?.latitude
          : null,
      "longitude": byLocation
          ? LocationService.currenctAddress?.coordinates?.longitude
          : null,
    };

    //
    final apiResult = await get(
      Api.coupons,
      queryParameters: queryParameters,
    );

    print("queryParameters ==> $queryParameters");

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Coupon.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message!;
  }

  Future<Coupon> fetchCoupon(int id) async {
    final apiResult = await get("${Api.coupons}/details/${id}");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Coupon.fromJson(apiResponse.body);
    }

    throw apiResponse.message!;
  }
}
