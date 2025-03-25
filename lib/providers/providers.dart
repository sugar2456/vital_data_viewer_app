import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vital_data_viewer_app/view_models/login_view_model.dart';
import 'package:vital_data_viewer_app/repositories/impls/login_repository_impl.dart';

List<SingleChildWidget> getProviders() {
  return [
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(LoginRepositoryImpl()),
    )
  ];
}