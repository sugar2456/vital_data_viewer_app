import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vital_data_viewer_app/repositories/impls/activity_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/body_goal_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/calories_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/heart_rate_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/sleep_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/step_repository_impl.dart';
import 'package:vital_data_viewer_app/repositories/impls/swimming_repository_impl.dart';
import 'package:vital_data_viewer_app/services/csv/csv_service.dart';
import 'package:vital_data_viewer_app/util/header_util.dart';
import 'package:vital_data_viewer_app/view_models/calories_view_model.dart';
import 'package:vital_data_viewer_app/view_models/csv_view_model.dart';
import 'package:vital_data_viewer_app/view_models/heart_rate_view_model.dart';
import 'package:vital_data_viewer_app/view_models/login_view_model.dart';
import 'package:vital_data_viewer_app/repositories/impls/login_repository_impl.dart';
import 'package:vital_data_viewer_app/view_models/home_view_model.dart';
import 'package:vital_data_viewer_app/view_models/steps_view_model.dart';
import 'package:vital_data_viewer_app/view_models/swimming_view_model.dart';
import 'package:http/http.dart' as http;

List<SingleChildWidget> getProviders() {
  final httpClient = http.Client();
  final headerUtil = HeaderUtil();

  return [
    ChangeNotifierProvider(
      create: (_) => headerUtil,
    ),
    // リポジトリのプロバイダ登録
    Provider<StepResponseImpl>(
      create: (context) => StepResponseImpl(
        headers: context.read<HeaderUtil>().headers,
        client: httpClient,
      ),
    ),
    Provider<HeartRateRepositoryImpl>(
      create: (context) => HeartRateRepositoryImpl(
        headers: context.read<HeaderUtil>().headers,
        client: httpClient,
      ),
    ),
    Provider<SwimmingRepositoryImpl>(
      create: (context) => SwimmingRepositoryImpl(
        headers: context.read<HeaderUtil>().headers,
        client: httpClient,
      ),
    ),
    Provider<SleepRepositoryImpl>(
      create: (context) => SleepRepositoryImpl(
        headers: context.read<HeaderUtil>().headers,
        client: httpClient,
      ),
    ),
    Provider<CaloriesRepositoryImpl>(
      create: (context) => CaloriesRepositoryImpl(
        headers: context.read<HeaderUtil>().headers,
        client: httpClient,
      ),
    ),
    Provider<LoginRepositoryImpl>(
      create: (_) => LoginRepositoryImpl(),
    ),
    Provider<ActivityRepositoryImpl>(
      create: (context) => ActivityRepositoryImpl(
        headers: context.read<HeaderUtil>().headers,
        client: httpClient,
      ),
    ),
    Provider<BodyGoalRepositoryImpl>(
      create: (context) => BodyGoalRepositoryImpl(
        headers: context.read<HeaderUtil>().headers,
        client: httpClient,
      ),
    ),
    // サービスのプロバイダ登録
    Provider<CsvService>(
      create: (context) => CsvService(
        stepRepository: context.read<StepResponseImpl>(),
        heartRateRepository: context.read<HeartRateRepositoryImpl>(),
        swimmingRepository: context.read<SwimmingRepositoryImpl>(),
        sleepRepository: context.read<SleepRepositoryImpl>(),
        caloriesRepository: context.read<CaloriesRepositoryImpl>(),
      ),
    ),
    // ViewModelのプロバイダ登録
    ChangeNotifierProvider(
      create: (context) => LoginViewModel(context.read<LoginRepositoryImpl>()),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        context.read<ActivityRepositoryImpl>(),
        context.read<BodyGoalRepositoryImpl>(),
        context.read<SleepRepositoryImpl>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => StepsViewModel(
        context.read<StepResponseImpl>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => HeartRateViewModel(
        context.read<HeartRateRepositoryImpl>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => CaloriesViewModel(
        context.read<CaloriesRepositoryImpl>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => SwimmingViewModel(
        context.read<SwimmingRepositoryImpl>(),
      ),
    ),
    // Service を使う ViewModel を登録
    ChangeNotifierProvider(
      create: (context) => CsvViewModel(
        csvService: context.read<CsvService>(),
      ),
    ),
  ];
}
