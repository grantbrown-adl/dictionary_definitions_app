import 'package:dictionary_definitions_app/models/dictionary_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'api_response.dart';
import 'mocks.dart';

void main() {
  group('ApplicationCubit', () {
    late ApplicationCubit applicationCubit;
    late MockNotificationProvider mockNotificationProvider;
    late MockLoadingCubit mockLoadingCubit;
    late MockHttpClient mockHttpClient;

    setUpAll(() {
      mockHydratedStorage();
      registerFallbackValue(FakeUri());
    });

    final Map<String, List<Definition?>> baseState = {
      'test': [Definition(definition: 'test_definition')],
      'xcd': [Definition(definition: 'xcd_definition')],
    };

    setUp(() {
      mockNotificationProvider = MockNotificationProvider();
      mockLoadingCubit = MockLoadingCubit();
      mockHttpClient = MockHttpClient();

      applicationCubit = ApplicationCubit(
        notifications: mockNotificationProvider,
        loadingCubit: mockLoadingCubit,
        http: mockHttpClient,
      );
    });

    tearDown(() {
      applicationCubit.close();
    });

    test('clearSearchHistory', () {
      final initialState =
          applicationCubit.state.copyWith(searchHistory: baseState);

      applicationCubit.clearSearchHistory();

      expect(
        applicationCubit.state,
        equals(initialState.copyWith(searchHistory: {})),
      );
    });

    test('getDefinition with null word', () async {
      await applicationCubit.getDefinition(null);

      verifyNever(() => mockLoadingCubit.setLoadingState(true));
      verifyNever(() => mockLoadingCubit.setLoadingState(false));
      verify(
        () => mockNotificationProvider.info(
          message: 'Please enter a word to get a definition',
        ),
      );
    });

    test('getDefinition with empty word', () async {
      await applicationCubit.getDefinition('');

      verifyNever(() => mockLoadingCubit.setLoadingState(true));
      verifyNever(() => mockLoadingCubit.setLoadingState(false));
      verify(
        () => mockNotificationProvider.info(
          message: 'Please enter a word to get a definition',
        ),
      );
    });

    test('tests http send', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        ((_) async {
          return Response(
            testResponseString,
            200,
          );
        }),
      );

      await applicationCubit.getDefinition('test');

      verify(() => mockLoadingCubit.setLoadingState(true)).called(1);
      verify(() => mockLoadingCubit.setLoadingState(false)).called(1);
      verify(() => mockHttpClient.get(any())).called(1);
    });
  });
}
