import 'package:flutter/material.dart';
import '../../models/dashboard_models.dart';

/// Card que mostra alertas e recomendações
class AlertsRecommendationsCard extends StatelessWidget {
  final List<Alerta> alertas;
  final List<Recomendacao> recomendacoes;
  final Function(String) onMarcarAlertaComoLido;

  const AlertsRecommendationsCard({
    super.key,
    required this.alertas,
    required this.recomendacoes,
    required this.onMarcarAlertaComoLido,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Alertas
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Alertas',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (alertas.isEmpty)
                    Text(
                      'Nenhum alerta no momento',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
                    ...alertas.map((alerta) => _buildAlertaItem(context, alerta)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Recomendações
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Recomendações',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (recomendacoes.isEmpty)
                    Text(
                      'Nenhuma recomendação disponível',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
                    ...recomendacoes.map((rec) => _buildRecomendacaoItem(context, rec)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertaItem(BuildContext context, Alerta alerta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  alerta.titulo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                ),
              ),
              if (!alerta.foiLido)
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => onMarcarAlertaComoLido(alerta.id),
                  tooltip: 'Marcar como lido',
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            alerta.descricao,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Há ${_formatarTempoDecorrido(alerta.dataCriacao)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecomendacaoItem(BuildContext context, Recomendacao recomendacao) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recomendacao.titulo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            recomendacao.descricao,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Categoria: ${recomendacao.categoria}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  String _formatarTempoDecorrido(DateTime data) {
    final diferenca = DateTime.now().difference(data);
    if (diferenca.inHours < 1) {
      return '${diferenca.inMinutes} minutos';
    } else if (diferenca.inHours < 24) {
      return '${diferenca.inHours} horas';
    } else {
      return '${diferenca.inDays} dias';
    }
  }
}