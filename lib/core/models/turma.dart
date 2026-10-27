/// Modelo que representa uma turma no sistema Educare
class Turma {
  final String id;
  final String nome;
  final String professorId;
  final List<String> estudanteIds;
  final DateTime dataCriacao;
  final String descricao;

  const Turma({
    required this.id,
    required this.nome,
    required this.professorId,
    required this.estudanteIds,
    required this.dataCriacao,
    required this.descricao,
  });

  // Retorna o número de estudantes na turma
  int get numeroEstudantes => estudanteIds.length;

  // Calcula estatísticas básicas da turma
  Map<String, dynamic> get estatisticasBasicas => {
    'numeroEstudantes': numeroEstudantes,
    'dataCriacao': dataCriacao,
    'descricao': descricao,
  };
}