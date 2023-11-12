part of 'application_cubit.dart';

@freezed
class ApplicationState with _$ApplicationState {
  const ApplicationState._();

  const factory ApplicationState({
    @Default({}) Map<String, List<Definition?>> searchHistory,
    @Default(false) bool singleDefinitionDisplay,
  }) = _ApplicationState;

  List<MapEntry<String, List<Definition?>>> get culledList =>
      searchHistory.entries
          .where((element) => element.value.isNotEmpty)
          .where(
            (element) => element.value.any(
              (definition) =>
                  definition != null && definition.definition!.isNotEmpty,
            ),
          )
          .toList()
          .take(10)
          .toList();

  factory ApplicationState.fromJson(Map<String, dynamic> json) =>
      _$ApplicationStateFromJson(json);
}
