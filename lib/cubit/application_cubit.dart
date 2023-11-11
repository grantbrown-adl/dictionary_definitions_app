import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_state.dart';
part 'application_cubit.freezed.dart';
part 'application_cubit.g.dart';

class ApplicationCubit extends Cubit<ApplicationState> with HydratedMixin {
  ApplicationCubit() : super(const ApplicationState());

  sendRequest(String? word) {
    if (word == null) {
      return;
    }

    emit(state);
  }

  @override
  ApplicationState? fromJson(Map<String, dynamic> json) =>
      ApplicationState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ApplicationState state) => state.toJson();
}
