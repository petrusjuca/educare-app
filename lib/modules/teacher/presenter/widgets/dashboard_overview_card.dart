import 'package:flutter/material.dart';

/// Card que mostra visão geral da turma
class DashboardOverviewCard extends StatelessWidget {
  final int numeroTotalEstudantes;
  final int numeroEstudantesAtivos;
  final double progressoMedioTurma;

  const DashboardOverviewCard({
    super.key,
    required this.numeroTotalEstudantes,
    required this.numeroEstudantesAtivos,
    required this.progressoMedioTurma,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visão Geral da Turma',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetricCard(
                  context,
                  'Total de Estudantes',
                  numeroTotalEstudantes.toString(),
                  Icons.people,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildMetricCard(
                  context,
                  'Estudantes Ativos',
                  numeroEstudantesAtivos.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildMetricCard(
                  context,
                  'Progresso Médio',
                  '${(progressoMedioTurma * 100).round()}%',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String titulo,
    String valor,
    IconData icone,
    Color cor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 32),
            const SizedBox(height: 8),
            Text(
              valor,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: cor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}