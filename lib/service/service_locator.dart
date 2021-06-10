import 'package:get_it/get_it.dart';
import 'package:flutter_template_app/service/purchase_service.dart';
import 'package:flutter_template_app/service/validation_service.dart';

/// [serviceLocator] used to access services from different part of the apps
/// DON'T use it from UI.
GetIt serviceLocator = GetIt.instance;

/// Set up services
void setUpServiceLocator() {
  serviceLocator.registerLazySingleton(() => ValidationService());
  serviceLocator.registerLazySingleton(() => PurchaseService());
}
