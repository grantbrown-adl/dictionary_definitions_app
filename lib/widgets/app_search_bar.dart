import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:dictionary_definitions_app/cubit/loading_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({super.key});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading =
        context.select<LoadingCubit, bool>((cubit) => cubit.state.loading);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        autofocus: false,
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Enter word',
          suffixIcon: loading
              ? Transform.scale(
                  scale: 0.5,
                  child: const CircularProgressIndicator.adaptive(),
                )
              : IconButton(
                  onPressed: () {
                    _searchRequest();
                  },
                  icon: const Icon(Icons.search),
                ),
        ),
        onEditingComplete: loading ? null : () => _searchRequest(),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  void _searchRequest() {
    final appCubit = context.read<ApplicationCubit>();
    setState(() {
      appCubit.getDefinition(searchController.text.toLowerCase());
      FocusScope.of(context).unfocus();
      searchController.clear();
    });
  }
}
