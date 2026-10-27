import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'educare_cores.dart';

/// Estilos de texto do Educare (DESIGN_TOKENS.md, seção Tipografia).
/// Nunito = tudo que é da criança e os títulos. Poppins = textos de apoio e painel do professor.
/// Os tamanhos são os do Figma (celular 390 px); no tablet eles ficam iguais por enquanto.
class EducareTextos {
  EducareTextos._();

  // --- Nunito ---
  static TextStyle get tituloHeader => GoogleFonts.nunito(
      fontSize: 40, fontWeight: FontWeight.w900, color: EducareCores.branco);

  static TextStyle get pergunta => GoogleFonts.nunito(
      fontSize: 30, fontWeight: FontWeight.w900, color: EducareCores.textoPergunta);

  static TextStyle get nomeAluno => GoogleFonts.nunito(
      fontSize: 28, fontWeight: FontWeight.w900, color: EducareCores.textoTitulo);

  static TextStyle get secao => GoogleFonts.nunito(
      fontSize: 24, fontWeight: FontWeight.w900, color: EducareCores.textoTitulo);

  static TextStyle get vogalCard => GoogleFonts.nunito(fontSize: 64, fontWeight: FontWeight.w900);

  static TextStyle get letraJogo => GoogleFonts.nunito(fontSize: 100, fontWeight: FontWeight.w600);

  static TextStyle get rotulo => GoogleFonts.nunito(
      fontSize: 18, fontWeight: FontWeight.w800, color: EducareCores.textoTitulo);

  static TextStyle get botao => GoogleFonts.nunito(
      fontSize: 20, fontWeight: FontWeight.w700, color: EducareCores.branco);

  /// Nome da emoção na tela de humor (a cor vem de cada emoção)
  static TextStyle get rotuloHumor => GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700);

  // --- Poppins ---
  static TextStyle get subtituloHeader => GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.w700, color: EducareCores.branco.withValues(alpha: 0.7));

  static TextStyle get tituloPainel => GoogleFonts.poppins(
      fontSize: 32, fontWeight: FontWeight.w700, color: EducareCores.textoTitulo);

  static TextStyle get rotuloBotaoPainel => GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get percentual => GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600);
}
