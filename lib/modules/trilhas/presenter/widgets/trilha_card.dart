import 'package:flutter/material.dart';
import '../../../../core/models/trilha.dart';

/// Card que representa uma trilha de aprendizagem
class TrilhaCard extends StatelessWidget {
  final Trilha trilha;
  final double progresso;
  final bool estaDesbloqueada;
  final VoidCallback? onTap;

  const TrilhaCard({
    super.key,
    required this.trilha,
    required this.progresso,
    required this.estaDesbloqueada,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: estaDesbloqueada ? 4 : 2,
      color: estaDesbloqueada ? Colors.white : Colors.grey.shade100,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: estaDesbloqueada ? trilha.cor : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.book,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trilha.titulo,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: estaDesbloqueada ? Colors.black : Colors.grey,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trilha.descricao,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: estaDesbloqueada ? Colors.black87 : Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (!estaDesbloqueada)
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (estaDesbloqueada) ...[
                Text(
                  'Progresso: ${(progresso * 100).round()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progresso,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(trilha.cor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.play_circle_fill,
                      color: trilha.cor,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Continuar',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: trilha.cor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Bloqueada',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}