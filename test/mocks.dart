import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:dictionary_definitions_app/cubit/loading_cubit.dart';
import 'package:dictionary_definitions_app/providers/notification_provider.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockNotificationProvider extends Mock implements NotificationProvider {}

class MockApplicationCubit extends Mock implements ApplicationCubit {}

class MockLoadingCubit extends Mock implements LoadingCubit {}

class MockHydratedStorage extends Mock implements HydratedStorage {}

class MockHttpClient extends Mock implements http.Client {}

class MockLogger extends Mock implements Logger {}

class FakeUri extends Fake implements Uri {}

mockHydratedStorage() {
  final hydratedStorage = MockHydratedStorage();
  when(
    () => hydratedStorage.write(any(), any<dynamic>()),
  ).thenAnswer((_) async {});
  HydratedBloc.storage = hydratedStorage;
}
