import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/teacher_dashboard_provider.dart';
import '../widgets/dashboard_overview_card.dart';
import '../widgets/students_list_card.dart';
import '../widgets/progress_chart_card.dart';
import '../widgets/alerts_recommendations_card.dart';

/// Página principal do dashboard do professor
class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Educare'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<TeacherDashboardProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Visão geral da turma
                DashboardOverviewCard(
                  numeroTotalEstudantes: provider.estatisticas.numeroTotalEstudantes,
                  numeroEstudantesAtivos: provider.estatisticas.numeroEstudantesAtivos,
                  progressoMedioTurma: provider.estatisticas.progressoMedioTurma,
                ),
                const SizedBox(height: 24),

                // Lista de estudantes
                StudentsListCard(
                  estudantes: provider.estudantesPorProgresso,
                ),
                const SizedBox(height: 24),

                // Gráfico de progresso por trilha
                ProgressChartCard(
                  progressoPorTrilha: provider.estatisticas.progressoPorTrilha,
                  trilhasDisponiveis: provider.trilhasDisponiveis,
                ),
                const SizedBox(height: 24),

                // Alertas e recomendações
                AlertsRecommendationsCard(
                  alertas: provider.estatisticas.alertas,
                  recomendacoes: provider.estatisticas.recomendacoes,
                  onMarcarAlertaComoLido: provider.marcarAlertaComoLido,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}