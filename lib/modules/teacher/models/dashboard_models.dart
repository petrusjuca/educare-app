/// Modelo para estatísticas do dashboard do professor
class EstatisticasDashboard {
  final int numeroTotalEstudantes;
  final int numeroEstudantesAtivos;
  final double progressoMedioTurma;
  final Map<String, double> progressoPorTrilha;
  final List<Alerta> alertas;
  final List<Recomendacao> recomendacoes;

  const EstatisticasDashboard({
    required this.numeroTotalEstudantes,
    required this.numeroEstudantesAtivos,
    required this.progressoMedioTurma,
    required this.progressoPorTrilha,
    required this.alertas,
    required this.recomendacoes,
  });
}

/// Modelo para alertas no dashboard
class Alerta {
  final String id;
  final String titulo;
  final String descricao;
  final String tipo; // 'progresso', 'atividade', 'comportamento'
  final DateTime dataCriacao;
  final bool foiLido;

  const Alerta({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.tipo,
    required this.dataCriacao,
    this.foiLido = false,
  });
}

/// Modelo para recomendações pedagógicas
class Recomendacao {
  final String id;
  final String titulo;
  final String descricao;
  final String categoria; // 'individual', 'turma', 'trilha'
  final String? estudanteId; // pode ser null para recomendações de turma
  final DateTime dataCriacao;

  const Recomendacao({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    this.estudanteId,
    required this.dataCriacao,
  });
}