import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'discovery_api.g.dart';

@RestApi()
abstract class DiscoveryApi {
  factory DiscoveryApi(Dio dio) = _DiscoveryApi;

  @GET('/me/recommendations')
  Future<Map<String, dynamic>> getRecommendations();
}
