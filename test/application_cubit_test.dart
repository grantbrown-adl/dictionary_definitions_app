import 'package:bloc_test/bloc_test.dart';
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

    final Map<String, List<Definition?>> baseSearches = {
      'test': [
        const Definition(
          definition: 'test_definition',
          example: 'this is a test example',
        ),
      ],
      'xkcd': [
        const Definition(
          definition: 'xkcd_definition',
          example: 'that xkcd comic is so phoney',
        ),
      ],
    };

    final ApplicationState baseState =
        ApplicationState(searchHistory: baseSearches);

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

    test('clear search history', () {
      final initialState =
          applicationCubit.state.copyWith(searchHistory: baseSearches);

      applicationCubit.clearSearchHistory();

      expect(
        applicationCubit.state,
        equals(initialState.copyWith(searchHistory: {})),
      );
    });

    test('ge definition with null word', () async {
      await applicationCubit.getDefinition(null);

      verifyNever(() => mockLoadingCubit.setLoadingState(true));
      verifyNever(() => mockLoadingCubit.setLoadingState(false));
      verify(
        () => mockNotificationProvider.info(
          message: 'Please enter a word to get a definition',
        ),
      );
    });

    test('get definition with empty word', () async {
      await applicationCubit.getDefinition('');

      verifyNever(() => mockLoadingCubit.setLoadingState(true));
      verifyNever(() => mockLoadingCubit.setLoadingState(false));
      verify(
        () => mockNotificationProvider.info(
          message: 'Please enter a word to get a definition',
        ),
      );
    });

    test('get definition with word', () async {
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

    blocTest<ApplicationCubit, ApplicationState>(
      'emits correct state when removeSearch is called',
      build: () => ApplicationCubit(
        notifications: mockNotificationProvider,
        loadingCubit: mockLoadingCubit,
        http: mockHttpClient,
      ),
      act: (bloc) => bloc.removeSearchItem('xkcd'),
      seed: () => baseState,
      expect: () => [
        baseState.copyWith(
          searchHistory: {
            'test': [
              const Definition(
                definition: 'test_definition',
                example: 'this is a test example',
              ),
            ],
          },
        ),
      ],
    );

    blocTest<ApplicationCubit, ApplicationState>(
      'emits empty state when clearSearchHistory is called',
      build: () => ApplicationCubit(
        notifications: mockNotificationProvider,
        loadingCubit: mockLoadingCubit,
        http: mockHttpClient,
      ),
      act: (bloc) => bloc.clearSearchHistory(),
      seed: () => baseState,
      expect: () => [
        const ApplicationState(),
      ],
    );
  });
}
