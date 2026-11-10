import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storey_app/core/network/supabase_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/dependency_injection.dart';
import 'core/app/app.dart';
import 'core/config/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.load();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
    httpClient: kDebugMode ? SupabaseLogger() : null,
  );

  await DI.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    UncontrolledProviderScope(
      container: DI.container,
      child: const StoreyApp(),
    ),
  );
}

// npx supabase gen types --lang dart --remote | Out-File -FilePath lib/core/network/supabase_schema.g.dart -Encoding utf8
// npx supabase@2 gen types --lang dart --project-id bjqpzxhmunhkixpcirda > lib\core\network\supabase_schema.g.dart -Encoding utf8
// npx -y supabase@2.122.1 gen types --lang dart --project-id bjqpzxhmunhkixpcirda --schema public | Out-File -FilePath lib\core\network\supabase_schema.g.dart -Encoding utf8
