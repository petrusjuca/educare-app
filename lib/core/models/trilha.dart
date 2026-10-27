import 'dart:ui' show Color;

/// Modelo que representa uma trilha de aprendizagem no Educare
class Trilha {
  final String id;
  final String titulo;
  final String descricao;
  final String icone; // Path do ícone
  final Color cor; // Cor da trilha
  final List<Estagio> estagios;
  final bool estaDisponivel;

  const Trilha({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.cor,
    required this.estagios,
    this.estaDisponivel = true,
  });

  // Retorna o número total de estágios
  int get numeroEstagios => estagios.length;

  // Calcula o progresso baseado nos estágios concluídos
  double calcularProgresso(List<String> estagiosConcluidos) {
    if (estagios.isEmpty) return 0.0;
    final concluidos = estagios.where((estagio) => estagiosConcluidos.contains(estagio.id)).length;
    return concluidos / estagios.length;
  }
}

/// Modelo que representa um estágio dentro de uma trilha
class Estagio {
  final String id;
  final String titulo;
  final String descricao;
  final int ordem;
  final List<Atividade> atividades;
  final bool estaBloqueado;

  const Estagio({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ordem,
    required this.atividades,
    this.estaBloqueado = false,
  });

  // Retorna se o estágio está disponível (não bloqueado)
  bool get estaDisponivel => !estaBloqueado;

  // Retorna o número de atividades no estágio
  int get numeroAtividades => atividades.length;
}

/// Modelo que representa uma atividade dentro de um estágio
class Atividade {
  final String id;
  final String titulo;
  final String tipo; // 'reconhecimento', 'discriminacao', 'construcao', etc.
  final int duracaoEstimada; // em minutos
  final bool requerDispositivo; // se precisa do dispositivo físico

  const Atividade({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.duracaoEstimada,
    this.requerDispositivo = false,
  });
}