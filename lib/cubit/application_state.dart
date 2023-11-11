part of 'application_cubit.dart';

@freezed
class ApplicationState with _$ApplicationState {
  const ApplicationState._();

  const factory ApplicationState({
    @Default(false) bool loading,
  }) = _ApplicationState;

  factory ApplicationState.fromJson(Map<String, dynamic> json) =>
      _$ApplicationStateFromJson(json);
}
