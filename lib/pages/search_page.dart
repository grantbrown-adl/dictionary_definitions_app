import 'package:dictionary_definitions_app/cubit/application_cubit.dart';
import 'package:dictionary_definitions_app/cubit/loading_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          autofocus: true,
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
        ),
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
