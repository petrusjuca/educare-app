import 'package:flutter/material.dart';
import '../../../../core/models/trilha.dart';

/// Card que mostra gráfico de progresso por trilha
class ProgressChartCard extends StatelessWidget {
  final Map<String, double> progressoPorTrilha;
  final List<Trilha> trilhasDisponiveis;

  const ProgressChartCard({
    super.key,
    required this.progressoPorTrilha,
    required this.trilhasDisponiveis,
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
              'Progresso por Trilha',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ...trilhasDisponiveis.map((trilha) {
              final progresso = progressoPorTrilha[trilha.id] ?? 0.0;
              return _buildTrilhaProgresso(context, trilha, progresso);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTrilhaProgresso(BuildContext context, Trilha trilha, double progresso) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: trilha.cor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  trilha.titulo,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${(progresso * 100).round()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progresso,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(trilha.cor),
          ),
          const SizedBox(height: 4),
          Text(
            trilha.descricao,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}