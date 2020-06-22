import 'sharedprefsutil.dart';
import '../components/view_models/main_view_model.dart';
import '../components/view_models/settings_view_model.dart';
import '../components/view_models/theme_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class ServiceLocator {
  static init() {
    getIt.registerSingleton<SettingsViewModel>(SettingsViewModel());
    getIt.registerSingleton<ThemeViewModel>(ThemeViewModel());
    getIt.registerSingleton<MainViewModel>(MainViewModel());
    getIt.registerSingleton<SharedPrefsUtil>(SharedPrefsUtil());
  }

  static T get<T>() {
    return getIt.get<T>();
  }
}
