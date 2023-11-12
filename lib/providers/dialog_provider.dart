import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogProvider {
  final GlobalKey<NavigatorState> navigatorKey;

  DialogProvider({required this.navigatorKey});

  Future<bool> showConfirmation({
    required String title,
    required String content,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    Widget Function(BuildContext)? builder,
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: builder ??
          (context) => AlertDialog(
                title: Text(title),
                content: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Text(content),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(cancelLabel),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(confirmLabel),
                  ),
                ],
              ),
    ).then((result) => result ?? false);
  }

  showAlert({
    required String title,
    required Widget content,
    String confirmLabel = 'OK',
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: content,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  showSettingsDialog({
    String confirmLabel = 'OK',
    required BuildContext context,
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (innerContext) => BlocProvider.value(
        value: context.watch<ApplicationCubit>(),
        child: BlocBuilder<ApplicationCubit, ApplicationState>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Display only a single definition?'),
                  Switch.adaptive(
                    value: state.singleDefinitionDisplay,
                    onChanged: (_) {
                      context
                          .read<ApplicationCubit>()
                          .toggleSingleDefinitionDisplay();
                    },
                  ),
                  Text(state.singleDefinitionDisplay ? 'Yes' : 'No'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
