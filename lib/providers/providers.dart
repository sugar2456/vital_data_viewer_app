import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vital_data_viewer_app/repositories/impls/activity_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/body_goal_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/calories_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/heart_rate_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/sleep_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/step_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/swimming_repository_impl.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/view_models/calories_view_model.dart';
import 'package:vital_data_viewer_app/view_models/heart_rate_view_model.dart';
import 'package:vital_data_viewer_app/view_models/login_view_model.dart';
import 'package:vital_data_viewer_app/repositories/impls/login_repository_impl.dart';
import 'package:vital_data_viewer_app/view_models/home_view_model.dart';
import 'package:vital_data_viewer_app/view_models/steps_view_model.dart';
import 'package:vital_data_viewer_app/view_models/swimming_view_model.dart';
import 'package:http/http.dart' as http;

List<SingleChildWidget> getProviders() {
  final httpClient = http.Client();
  final headers = HeaderUtil.createAuthHeaders();
  return [
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(LoginRepositoryImpl()),
    ),
    ChangeNotifierProvider(
      create: (_) => HomeViewModel(
        ActivityRepositoryImpl(
          headers: headers,
          client: httpClient,
        ),
        BodyGoalRepositoryImpl(
          headers: headers,
          client: httpClient,
        ),
        SleepRepositoryImpl(
          headers: headers,
          client: httpClient,
        )
      )
    ),
    ChangeNotifierProvider(
      create: (_) => StepsViewModel(
        StepResponseImpl(
          headers: headers,
          client: httpClient,
        )
      )
    ),
    ChangeNotifierProvider(
      create: (_) => HeartRateViewModel(
        HeartRateRepositoryImpl(
          headers: headers,
          client: httpClient,
        )
      )
    ),
    ChangeNotifierProvider(
      create: (_) => CaloriesViewModel(
        CaloriesRepositoryImpl(
          headers: headers,
          client: httpClient,
        )
      )
    ),
    ChangeNotifierProvider(
      create: (_) => SwimmingViewModel(
        SwimmingRepositoryImpl(
          headers: headers,
          client: httpClient,
        )
      )
    ),
  ];
}
