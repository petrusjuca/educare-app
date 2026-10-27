import 'package:flutter/material.dart';

/// Card de dupla camada (DESIGN_TOKENS.md, componente 1): a assinatura visual do Educare.
/// Uma camada escura atrás e uma clara na frente, deslocada para cima; dá profundidade sem sombra.
/// Ex.: card da vogal O = corDeTras #74C015 + corDaFrente #C4F28A.
class CartaoDuplaCamada extends StatelessWidget {
  final Color corDeTras;
  final Color corDaFrente;
  final Widget child;
  final double deslocamento;
  final double raio;
  final EdgeInsetsGeometry padding;

  const CartaoDuplaCamada({
    super.key,
    required this.corDeTras,
    required this.corDaFrente,
    required this.child,
    this.deslocamento = 3,
    this.raio = 15,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: corDeTras,
        borderRadius: BorderRadius.circular(raio),
      ),
      padding: EdgeInsets.only(bottom: deslocamento),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: corDaFrente,
          borderRadius: BorderRadius.circular(raio),
        ),
        child: child,
      ),
    );
  }
}
