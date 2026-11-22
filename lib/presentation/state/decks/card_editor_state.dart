import 'package:equatable/equatable.dart';

import '../../../data/repositories/card_repository.dart';
import '../../../data/repositories/dictionary_repository.dart';

class CardEditorState extends Equatable {
  const CardEditorState({
    this.draft = const CardDraft(),
    this.suggestions = const [],
    this.errors = const {},
    this.saved = false,
    this.isEdit = false,
  });

  final CardDraft draft;

  /// Dictionary words matching the typed hanzi.
  final List<DictEntry> suggestions;

  /// Field name ('hanzi' | 'meaning') -> Vietnamese message.
  final Map<String, String> errors;
  final bool saved;
  final bool isEdit;

  CardEditorState copyWith({
    CardDraft? draft,
    List<DictEntry>? suggestions,
    Map<String, String>? errors,
    bool? saved,
  }) =>
      CardEditorState(
        draft: draft ?? this.draft,
        suggestions: suggestions ?? this.suggestions,
        errors: errors ?? this.errors,
        saved: saved ?? this.saved,
        isEdit: isEdit,
      );

  @override
  List<Object?> get props => [draft, suggestions, errors, saved, isEdit];
}
