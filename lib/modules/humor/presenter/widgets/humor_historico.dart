import 'package:flutter/material.dart';
import '../../models/humor_model.dart';

/// Widget que mostra o histórico de humores
class HumorHistorico extends StatelessWidget {
  final List<EntradaHumor> historico;

  const HumorHistorico({
    super.key,
    required this.historico,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: historico.length,
      itemBuilder: (context, index) {
        final entrada = historico[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  entrada.humor.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entrada.descricaoCompleta,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatarDataHora(entrada.dataHora),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      if (entrada.observacao != null && entrada.observacao!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          entrada.observacao!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatarDataHora(DateTime dataHora) {
    final agora = DateTime.now();
    final diferenca = agora.difference(dataHora);

    if (diferenca.inDays == 0) {
      return 'Hoje às ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}';
    } else if (diferenca.inDays == 1) {
      return 'Ontem às ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays} dias atrás';
    } else {
      return '${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year}';
    }
  }
}