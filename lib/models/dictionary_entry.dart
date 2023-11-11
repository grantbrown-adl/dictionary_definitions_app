import 'dart:convert';

import 'package:equatable/equatable.dart';

List<DictionaryEntry?> dictionaryEntryFromJson(String? str) =>
    (json.decode(str ?? "") as List<dynamic>?)
        ?.map((x) => DictionaryEntry?.fromJson(x as Map<String, dynamic>?))
        .toList() ??
    <DictionaryEntry>[];

String? dictionaryEntryToJson(List<DictionaryEntry?>? data) =>
    json.encode(List<dynamic>.from(data?.map((x) => x?.toJson()) ?? []));

class DictionaryEntry {
  String word;
  List<Meaning?> meanings;

  DictionaryEntry({
    required this.word,
    required this.meanings,
  });

  String get firstDefinition =>
      meanings.first?.definitions?.first?.definition ?? '';

  bool get meaningsExist => meanings.isNotEmpty && meanings.first != null;

  bool get definitionsExist =>
      meanings.first!.definitions != null &&
      meanings.first!.definitions != null;

  bool get isDefined => meaningsExist && definitionsExist;

  factory DictionaryEntry.fromJson(Map<String, dynamic>? json) =>
      DictionaryEntry(
        word: json?["word"] ?? '',
        meanings: (json?["meanings"] as List<dynamic>?)
                ?.map((x) => Meaning?.fromJson(x as Map<String, dynamic>?))
                .toList() ??
            [],
      );

  Map<String, dynamic>? toJson() => {
        "word": word,
        "meanings": List<dynamic>.from(meanings.map((x) => x?.toJson())),
      };
}

class Meaning {
  String? partOfSpeech;
  List<Definition?>? definitions;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory Meaning.fromJson(Map<String, dynamic>? json) => Meaning(
        partOfSpeech: json?["partOfSpeech"],
        definitions: (json?["definitions"] as List<dynamic>?)
            ?.map((x) => Definition?.fromJson(x as Map<String, dynamic>?))
            .toList(),
      );

  Map<String, dynamic>? toJson() => {
        "partOfSpeech": partOfSpeech ?? '',
        "definitions":
            List<dynamic>.from(definitions?.map((def) => def?.toJson()) ?? []),
      };
}

class Definition extends Equatable {
  final String? definition;
  final String? example;

  const Definition({
    required this.definition,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic>? json) => Definition(
        definition: json?["definition"] ?? '',
        example: json?["example"] ?? '',
      );

  Map<String, dynamic>? toJson() => {
        "definition": definition ?? '',
        "example": example ?? '',
      };

  @override
  List<Object?> get props => [definition, example];
}
