import 'package:flutter/material.dart';
import '../../../core/models/estudante.dart';
import '../../../core/models/turma.dart';
import '../../../core/models/trilha.dart';
import '../models/dashboard_models.dart';

/// Provider responsável pela lógica do dashboard do professor
class TeacherDashboardProvider extends ChangeNotifier {
  // Dados mockados para desenvolvimento
  late Turma _turmaAtual;
  late List<Estudante> _estudantes;
  late List<Trilha> _trilhasDisponiveis;
  late EstatisticasDashboard _estatisticas;

  TeacherDashboardProvider() {
    _inicializarDadosMock();
  }

  // Getters
  Turma get turmaAtual => _turmaAtual;
  List<Estudante> get estudantes => _estudantes;
  List<Trilha> get trilhasDisponiveis => _trilhasDisponiveis;
  EstatisticasDashboard get estatisticas => _estatisticas;

  // Retorna estudantes ordenados por progresso
  List<Estudante> get estudantesPorProgresso {
    return [..._estudantes]..sort((a, b) => b.progressoGeral.compareTo(a.progressoGeral));
  }

  // Retorna estudantes ativos
  List<Estudante> get estudantesAtivos {
    return _estudantes.where((estudante) => estudante.estaAtivo).toList();
  }

  // Inicializa dados mockados realistas
  void _inicializarDadosMock() {
    // Criar trilhas
    _trilhasDisponiveis = [
      Trilha(
        id: 'vogais',
        titulo: 'Reconhecimento de Vogais',
        descricao: 'Aprender a identificar e pronunciar vogais',
        icone: 'assets/images/vogais_icon.png',
        cor: const Color(0xFF58CC02),
        estagios: [
          Estagio(
            id: 'vogais_basico',
            titulo: 'Vogais Básicas',
            descricao: 'Introdução às vogais A, E, I, O, U',
            ordem: 1,
            atividades: [
              Atividade(
                id: 'reconhecer_a',
                titulo: 'Reconhecer A',
                tipo: 'reconhecimento',
                duracaoEstimada: 5,
                requerDispositivo: true,
              ),
              Atividade(
                id: 'reconhecer_e',
                titulo: 'Reconhecer E',
                tipo: 'reconhecimento',
                duracaoEstimada: 5,
                requerDispositivo: true,
              ),
            ],
          ),
        ],
      ),
      Trilha(
        id: 'consoantes',
        titulo: 'Discriminação de Consoantes',
        descricao: 'Diferenciar sons consonantais',
        icone: 'assets/images/consoantes_icon.png',
        cor: const Color(0xFFCE82FF),
        estagios: [],
      ),
      Trilha(
        id: 'silabas',
        titulo: 'Sílabas Simples',
        descricao: 'Construir sílabas básicas',
        icone: 'assets/images/silabas_icon.png',
        cor: const Color(0xFFFF9600),
        estagios: [],
      ),
      Trilha(
        id: 'palavras',
        titulo: 'Construção de Palavras',
        descricao: 'Formar palavras simples',
        icone: 'assets/images/palavras_icon.png',
        cor: const Color(0xFF4ECDC4),
        estagios: [],
      ),
    ];

    // Criar estudantes mockados
    _estudantes = [
      Estudante(
        id: 'est1',
        nome: 'Ana Silva',
        avatar: 'assets/images/avatar_ana.png',
        idade: 7,
        turmaId: 'turma1',
        dataEntrada: DateTime(2023, 9, 1),
        progressoTrilhas: {
          'vogais': 0.8,
          'consoantes': 0.6,
          'silabas': 0.4,
          'palavras': 0.2,
        },
        conquistas: ['Primeira Vogal', 'Semana Ativa'],
        ultimaAtividade: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Estudante(
        id: 'est2',
        nome: 'Carlos Santos',
        avatar: 'assets/images/avatar_carlos.png',
        idade: 8,
        turmaId: 'turma1',
        dataEntrada: DateTime(2023, 9, 1),
        progressoTrilhas: {
          'vogais': 1.0,
          'consoantes': 0.9,
          'silabas': 0.7,
          'palavras': 0.5,
        },
        conquistas: ['Mestre das Vogais', 'Construtor de Palavras'],
        ultimaAtividade: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Estudante(
        id: 'est3',
        nome: 'Maria Oliveira',
        avatar: 'assets/images/avatar_maria.png',
        idade: 6,
        turmaId: 'turma1',
        dataEntrada: DateTime(2023, 10, 15),
        progressoTrilhas: {
          'vogais': 0.3,
          'consoantes': 0.1,
          'silabas': 0.0,
          'palavras': 0.0,
        },
        conquistas: [],
        ultimaAtividade: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    // Criar turma
    _turmaAtual = Turma(
      id: 'turma1',
      nome: 'Turma do Jardim I',
      professorId: 'prof1',
      estudanteIds: _estudantes.map((e) => e.id).toList(),
      dataCriacao: DateTime(2023, 9, 1),
      descricao: 'Turma de alfabetização inicial',
    );

    // Calcular estatísticas
    _calcularEstatisticas();
  }

  // Calcula estatísticas do dashboard
  void _calcularEstatisticas() {
    final totalEstudantes = _estudantes.length;
    final estudantesAtivos = _estudantes.where((e) => e.estaAtivo).toList();
    final progressoMedio = _estudantes.isEmpty
        ? 0.0
        : _estudantes.map((e) => e.progressoGeral).reduce((a, b) => a + b) / _estudantes.length;

    // Progresso por trilha
    final progressoPorTrilha = <String, double>{};
    for (final trilha in _trilhasDisponiveis) {
      final estudantesComTrilha = _estudantes.where((e) => e.progressoTrilhas.containsKey(trilha.id));
      if (estudantesComTrilha.isNotEmpty) {
        final mediaTrilha = estudantesComTrilha
            .map((e) => e.progressoTrilhas[trilha.id]!)
            .reduce((a, b) => a + b) / estudantesComTrilha.length;
        progressoPorTrilha[trilha.id] = mediaTrilha;
      } else {
        progressoPorTrilha[trilha.id] = 0.0;
      }
    }

    // Alertas mockados
    final alertas = <Alerta>[];
    final estudantesInativos = _estudantes.where((e) => !e.estaAtivo).toList();
    for (final estudante in estudantesInativos) {
      alertas.add(Alerta(
        id: 'alerta_${estudante.id}',
        titulo: 'Estudante inativo',
        descricao: '${estudante.nome} não teve atividade nos últimos 7 dias',
        tipo: 'atividade',
        dataCriacao: DateTime.now().subtract(const Duration(days: 1)),
      ));
    }

    // Recomendações mockadas
    final recomendacoes = <Recomendacao>[
      Recomendacao(
        id: 'rec1',
        titulo: 'Reforçar reconhecimento de vogais',
        descricao: '3 estudantes precisam de mais prática com vogais básicas',
        categoria: 'turma',
        dataCriacao: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Recomendacao(
        id: 'rec2',
        titulo: 'Introduzir consoantes',
        descricao: 'A turma está pronta para avançar para consoantes',
        categoria: 'turma',
        dataCriacao: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    _estatisticas = EstatisticasDashboard(
      numeroTotalEstudantes: totalEstudantes,
      numeroEstudantesAtivos: estudantesAtivos.length,
      progressoMedioTurma: progressoMedio,
      progressoPorTrilha: progressoPorTrilha,
      alertas: alertas,
      recomendacoes: recomendacoes,
    );

    notifyListeners();
  }

  // Método para marcar alerta como lido
  void marcarAlertaComoLido(String alertaId) {
    final alertasAtualizados = _estatisticas.alertas.map((alerta) {
      if (alerta.id == alertaId) {
        return Alerta(
          id: alerta.id,
          titulo: alerta.titulo,
          descricao: alerta.descricao,
          tipo: alerta.tipo,
          dataCriacao: alerta.dataCriacao,
          foiLido: true,
        );
      }
      return alerta;
    }).toList();

    _estatisticas = EstatisticasDashboard(
      numeroTotalEstudantes: _estatisticas.numeroTotalEstudantes,
      numeroEstudantesAtivos: _estatisticas.numeroEstudantesAtivos,
      progressoMedioTurma: _estatisticas.progressoMedioTurma,
      progressoPorTrilha: _estatisticas.progressoPorTrilha,
      alertas: alertasAtualizados,
      recomendacoes: _estatisticas.recomendacoes,
    );

    notifyListeners();
  }
}