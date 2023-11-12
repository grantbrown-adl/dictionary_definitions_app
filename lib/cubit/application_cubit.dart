import 'package:dictionary_definitions_app/constants/app_constants.dart';
import 'package:dictionary_definitions_app/cubit/loading_cubit.dart';
import 'package:dictionary_definitions_app/models/dictionary_entry.dart';
import 'package:dictionary_definitions_app/models/undefined_model.dart';
import 'package:dictionary_definitions_app/providers/logger.dart';
import 'package:dictionary_definitions_app/providers/notification_provider.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;

part 'application_state.dart';
part 'application_cubit.freezed.dart';
part 'application_cubit.g.dart';

class ApplicationCubit extends Cubit<ApplicationState> with HydratedMixin {
  final NotificationProvider _notifications;
  final LoadingCubit _loadingCubit;
  final http.Client _http;

  ApplicationCubit({
    required NotificationProvider notifications,
    required LoadingCubit loadingCubit,
    required http.Client http,
  })  : _notifications = notifications,
        _loadingCubit = loadingCubit,
        _http = http,
        super(const ApplicationState());

  clearSearchHistory() {
    emit(state.copyWith(searchHistory: {}));
  }

  removeSearchItem(String searchedWord) {
    final history = {...state.searchHistory};
    history.remove(searchedWord);

    emit(state.copyWith(searchHistory: history));
  }

  toggleSingleDefinitionDisplay() {
    emit(
      state.copyWith(
        singleDefinitionDisplay: !state.singleDefinitionDisplay,
      ),
    );
  }

  getDefinition(String? word) async {
    if (word == null || word.isEmpty) {
      logger().i('Empty or null text field');
      _notifications.info(
        message: 'Please enter a word to get a definition',
      );
      return;
    }

    final apiUrl = '${AppConstants.apiUrl}$word';

    _loadingCubit.setLoadingState(true);

    try {
      var response = await _http.get(
        Uri.parse(apiUrl),
      );

      final statusCode = response.statusCode;

      if (statusCode ~/ 100 != 2) {
        logger().i('Unsuccessful request');
        final undefinedWord = undefinedModelFromJson(response.body);

        _notifications.info(message: undefinedWord.message);
      } else {
        logger().i('Successful request');
        final definedWord = dictionaryEntryFromJson(response.body).first;

        if (definedWord == null || definedWord.word.isEmpty) {
          logger().i('define word null or word is empty');
          _notifications.info(
            message:
                'Something went wrong. Please try again later, or try with a different word',
          );
          return;
        }

        if (!definedWord.isDefined) {
          logger().i('definitions empty');
          _notifications.info(
            message: 'There are no definitions for that word',
          );
          return;
        }

        emit(
          state.copyWith(
            searchHistory: {
              ...state.searchHistory,
              definedWord.word: definedWord.meanings.first!.definitions!,
            },
          ),
        );
      }
    } catch (error) {
      _notifications.error(message: error.toString());
      logger().e('Error: ', error: error);
    }

    _loadingCubit.setLoadingState(false);
  }

  @override
  ApplicationState? fromJson(Map<String, dynamic> json) =>
      ApplicationState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ApplicationState state) => state.toJson();
}
