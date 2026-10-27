/// Modelo que representa um estudante no sistema Educare
class Estudante {
  final String id;
  final String nome;
  final String avatar; // URL ou path do avatar
  final int idade;
  final String turmaId;
  final DateTime dataEntrada;
  final Map<String, double> progressoTrilhas; // trilhaId -> progresso (0.0 a 1.0)
  final List<String> conquistas;
  final DateTime ultimaAtividade;

  const Estudante({
    required this.id,
    required this.nome,
    required this.avatar,
    required this.idade,
    required this.turmaId,
    required this.dataEntrada,
    required this.progressoTrilhas,
    required this.conquistas,
    required this.ultimaAtividade,
  });

  // Calcula o progresso geral do estudante
  double get progressoGeral {
    if (progressoTrilhas.isEmpty) return 0.0;
    final total = progressoTrilhas.values.reduce((a, b) => a + b);
    return total / progressoTrilhas.length;
  }

  // Retorna se o estudante está ativo (teve atividade recente)
  bool get estaAtivo {
    final diasDesdeUltimaAtividade = DateTime.now().difference(ultimaAtividade).inDays;
    return diasDesdeUltimaAtividade <= 7; // Considera ativo se teve atividade nos últimos 7 dias
  }
}