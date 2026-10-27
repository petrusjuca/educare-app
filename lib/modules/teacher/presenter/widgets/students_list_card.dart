import 'package:flutter/material.dart';
import '../../../../core/models/estudante.dart';

/// Card que mostra lista de estudantes
class StudentsListCard extends StatelessWidget {
  final List<Estudante> estudantes;

  const StudentsListCard({
    super.key,
    required this.estudantes,
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
              'Estudantes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: estudantes.length,
              itemBuilder: (context, index) {
                final estudante = estudantes[index];
                return _buildEstudanteItem(context, estudante);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstudanteItem(BuildContext context, Estudante estudante) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar (placeholder por enquanto)
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Text(
              estudante.nome.substring(0, 1),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estudante.nome,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${estudante.idade} anos • Última atividade: ${_formatarUltimaAtividade(estudante.ultimaAtividade)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: estudante.progressoGeral,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    estudante.estaAtivo ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Progresso geral: ${(estudante.progressoGeral * 100).round()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: estudante.estaAtivo ? Colors.green : Colors.orange,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            estudante.estaAtivo ? Icons.check_circle : Icons.warning,
            color: estudante.estaAtivo ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }

  String _formatarUltimaAtividade(DateTime ultimaAtividade) {
    final diferenca = DateTime.now().difference(ultimaAtividade);
    if (diferenca.inDays == 0) {
      return 'hoje';
    } else if (diferenca.inDays == 1) {
      return 'ontem';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays} dias atrás';
    } else {
      return '${(diferenca.inDays / 7).round()} semanas atrás';
    }
  }
}