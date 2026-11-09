import 'package:supabase_flutter/supabase_flutter.dart';
import '../response/home_response.dart';

abstract class HomeApiServices {
  Future<HomeData> homeData();
}

class HomeApiServicesImpl implements HomeApiServices {
  final SupabaseClient sb;

  HomeApiServicesImpl([SupabaseClient? client])
      : sb = client ?? Supabase.instance.client;

  @override
  Future<HomeData> homeData() async {
    final response = (await sb.rpc("get_home_data")) as Map<String, dynamic>;
    return HomeData.fromJson(response);
  }
}
