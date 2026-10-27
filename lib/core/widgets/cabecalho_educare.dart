import 'package:flutter/material.dart';
import '../theme/educare_cores.dart';
import '../theme/educare_textos.dart';

/// Header azul em duas camadas (DESIGN_TOKENS.md, componente 2 "header sangrado").
/// Camada de trás azul-claro aparecendo embaixo; camada da frente azul com o título.
class CabecalhoEducare extends StatelessWidget {
  final String titulo;
  final String? subtitulo;

  /// Largura máxima do texto, para alinhar com o conteúdo da tela no tablet.
  final double larguraMaxima;

  const CabecalhoEducare({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.larguraMaxima = 592,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: EducareCores.azulClaro,
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        color: EducareCores.azulPrimario,
        padding: EdgeInsets.fromLTRB(
            24, MediaQuery.of(context).padding.top + 48, 24, 40),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: larguraMaxima),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: EducareTextos.tituloHeader),
                  if (subtitulo != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitulo!, style: EducareTextos.subtituloHeader),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
