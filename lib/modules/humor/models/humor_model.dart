/// Modelo que representa o humor do estudante
enum Humor {
  muitoFeliz('Muito Feliz', '😄', 5),
  feliz('Feliz', '😊', 4),
  neutro('Neutro', '😐', 3),
  triste('Triste', '😢', 2),
  muitoTriste('Muito Triste', '😭', 1);

  const Humor(this.descricao, this.emoji, this.intensidade);

  final String descricao;
  final String emoji;
  final int intensidade;
}

/// Modelo que representa uma entrada de humor
class EntradaHumor {
  final String id;
  final String estudanteId;
  final Humor humor;
  final double? intensidade; // opcional, de 0.0 a 1.0
  final DateTime dataHora;
  final String? observacao; // opcional

  const EntradaHumor({
    required this.id,
    required this.estudanteId,
    required this.humor,
    this.intensidade,
    required this.dataHora,
    this.observacao,
  });

  // Retorna uma descrição completa do humor
  String get descricaoCompleta {
    final base = '${humor.descricao} ${humor.emoji}';
    if (intensidade != null) {
      return '$base (${(intensidade! * 100).round()}%)';
    }
    return base;
  }
}