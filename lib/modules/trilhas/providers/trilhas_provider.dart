import 'package:flutter/material.dart';
import '../../../core/models/trilha.dart';

/// Provider responsável pela lógica das trilhas de aprendizagem
class TrilhasProvider extends ChangeNotifier {
  // ID do estudante atual (simulado)
  final String estudanteId = 'est1'; // Ana Silva

  // Dados mockados das trilhas
  late List<Trilha> _trilhasDisponiveis;
  late Map<String, double> _progressoTrilhas; // trilhaId -> progresso

  TrilhasProvider() {
    _inicializarDados();
  }

  // Getters
  List<Trilha> get trilhasDisponiveis => _trilhasDisponiveis;
  Map<String, double> get progressoTrilhas => _progressoTrilhas;

  // Retorna o progresso de uma trilha específica
  double getProgressoTrilha(String trilhaId) {
    return _progressoTrilhas[trilhaId] ?? 0.0;
  }

  // Verifica se uma trilha está desbloqueada
  bool trilhaEstaDesbloqueada(String trilhaId) {
    // Lógica simples: primeira trilha sempre desbloqueada, outras precisam de progresso mínimo na anterior
    final index = _trilhasDisponiveis.indexWhere((t) => t.id == trilhaId);
    if (index == 0) return true;

    final trilhaAnterior = _trilhasDisponiveis[index - 1];
    final progressoAnterior = getProgressoTrilha(trilhaAnterior.id);
    return progressoAnterior >= 0.5; // 50% da anterior para desbloquear
  }

  // Atualiza o progresso de uma trilha
  void atualizarProgressoTrilha(String trilhaId, double novoProgresso) {
    _progressoTrilhas[trilhaId] = novoProgresso.clamp(0.0, 1.0);
    notifyListeners();
  }

  // Inicializa dados mockados
  void _inicializarDados() {
    _trilhasDisponiveis = [
      Trilha(
        id: 'vogais',
        titulo: 'Reconhecimento de Vogais',
        descricao: 'Aprenda a identificar e pronunciar as vogais A, E, I, O, U',
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
          Estagio(
            id: 'vogais_pratica',
            titulo: 'Prática com Vogais',
            descricao: 'Reforce o aprendizado das vogais',
            ordem: 2,
            atividades: [
              Atividade(
                id: 'praticar_vogais',
                titulo: 'Prática Interativa',
                tipo: 'reconhecimento',
                duracaoEstimada: 10,
                requerDispositivo: true,
              ),
            ],
          ),
        ],
      ),
      Trilha(
        id: 'consoantes',
        titulo: 'Discriminação de Consoantes',
        descricao: 'Diferencie os sons consonantais',
        icone: 'assets/images/consoantes_icon.png',
        cor: const Color(0xFFCE82FF),
        estagios: [
          Estagio(
            id: 'consoantes_basico',
            titulo: 'Consoantes Iniciais',
            descricao: 'Introdução às consoantes B, C, D',
            ordem: 1,
            atividades: [
              Atividade(
                id: 'reconhecer_b',
                titulo: 'Reconhecer B',
                tipo: 'discriminacao',
                duracaoEstimada: 5,
                requerDispositivo: true,
              ),
            ],
          ),
        ],
      ),
      Trilha(
        id: 'silabas',
        titulo: 'Sílabas Simples',
        descricao: 'Construa sílabas básicas',
        icone: 'assets/images/silabas_icon.png',
        cor: const Color(0xFFFF9600),
        estagios: [],
      ),
      Trilha(
        id: 'palavras',
        titulo: 'Construção de Palavras',
        descricao: 'Forme palavras simples',
        icone: 'assets/images/palavras_icon.png',
        cor: const Color(0xFF4ECDC4),
        estagios: [],
      ),
    ];

    // Progresso mockado para o estudante
    _progressoTrilhas = {
      'vogais': 0.8,
      'consoantes': 0.6,
      'silabas': 0.4,
      'palavras': 0.2,
    };
  }
}