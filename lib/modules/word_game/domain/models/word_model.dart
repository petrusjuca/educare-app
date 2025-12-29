class Word {
  final String original;
  final String category;
  final List<String> letters;
  final List<int> missingVowelIndices;
  final List<String?> currentState;

  static const List<String> vowels = ['A', 'E', 'I', 'O', 'U'];

  Word({
    required this.original,
    required this.category,
    required this.letters,
    required this.missingVowelIndices,
    required this.currentState,
  });

  factory Word.fromString(String word, String category) {
    try {
      final letters = word.toUpperCase().split('');

      final missingVowelIndices = <int>[];
      final currentState = List<String?>.from(letters);

      for (int i = 0; i < letters.length; i++) {
        if (vowels.contains(letters[i])) {
          missingVowelIndices.add(i);
          currentState[i] = null;
        }
      }


      return Word(
        original: word.toUpperCase(),
        category: category,
        letters: letters,
        missingVowelIndices: missingVowelIndices,
        currentState: currentState,
      );
    } catch (e) {
      rethrow;
    }
  }

  bool isComplete() {
    return !currentState.contains(null);
  }

  bool checkVowel(String vowel, int position) {
    if (position < 0 || position >= letters.length) return false;
    if (!missingVowelIndices.contains(position)) return false;

    return letters[position] == vowel.toUpperCase();
  }

  void fillVowel(String vowel, int position) {
    if (position < 0 || position >= currentState.length) return;
    if (!missingVowelIndices.contains(position)) return;

    currentState[position] = vowel.toUpperCase();
  }

  String getCurrentDisplay() {
    return currentState.map((letter) => letter ?? '_').join('');
  }

  List<int> getRemainingPositions() {
    final remaining = <int>[];
    for (int i = 0; i < currentState.length; i++) {
      if (currentState[i] == null) {
        remaining.add(i);
      }
    }
    return remaining;
  }

  Word copyWith({
    String? original,
    String? category,
    List<String>? letters,
    List<int>? missingVowelIndices,
    List<String?>? currentState,
  }) {
    return Word(
      original: original ?? this.original,
      category: category ?? this.category,
      letters: letters ?? this.letters,
      missingVowelIndices: missingVowelIndices ?? this.missingVowelIndices,
      currentState: currentState ?? List<String?>.from(this.currentState),
    );
  }
}
