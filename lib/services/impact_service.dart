import '../model/impact_models.dart';
import 'api_client.dart';

class ImpactService {
  ImpactService._();

  static Stream<List<ImpactProjectModel>> activeProjects() {
    return Stream.fromFuture(_fetchProjects());
  }

  static Stream<List<DonationRecordModel>> userDonations() {
    return Stream.fromFuture(_fetchUserDonations());
  }

  static Future<List<ImpactProjectModel>> _fetchProjects() async {
    final response = await ApiClient.dio.get('/impact/projects');
    final rawItems = response.data is List
        ? response.data as List
        : (response.data['items'] as List? ?? const []);
    return rawItems
        .map((item) => ImpactProjectModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }

  static Future<List<DonationRecordModel>> _fetchUserDonations() async {
    final response = await ApiClient.dio.get('/donations/me', queryParameters: {
      'limit': 20,
    });
    final rawItems = response.data is List
        ? response.data as List
        : (response.data['items'] as List? ?? const []);
    return rawItems
        .map((item) => DonationRecordModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }
}
