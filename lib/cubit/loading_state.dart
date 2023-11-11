part of 'loading_cubit.dart';

@freezed
class LoadingState with _$LoadingState {
  const factory LoadingState({
    @Default(false) bool loading,
  }) = _Initial;
}
