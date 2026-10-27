import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'educare_cores.dart';
import 'educare_textos.dart';

/// Tema único do app, montado com as cores e textos do Educare.
/// Botão primário e campo de formulário seguem os componentes 3 e 4 do DESIGN_TOKENS.md.
class EducareTema {
  EducareTema._();

  static ThemeData get tema {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: EducareCores.azulPrimario,
        primary: EducareCores.azulPrimario,
        surface: EducareCores.branco,
        error: EducareCores.ruim,
      ),
    );

    return base.copyWith(
      primaryColor: EducareCores.azulPrimario,
      scaffoldBackgroundColor: EducareCores.fundo,

      // Texto corrido em Poppins; títulos em Nunito
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        headlineLarge: EducareTextos.nomeAluno,
        headlineMedium: EducareTextos.secao,
        titleLarge: EducareTextos.rotulo,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: EducareCores.azulPrimario,
        foregroundColor: EducareCores.branco,
        elevation: 0,
        titleTextStyle: GoogleFonts.nunito(
            fontSize: 22, fontWeight: FontWeight.w900, color: EducareCores.branco),
      ),

      // Componente 4: botão primário (altura 48, raio 24, azul escuro, sombra)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EducareCores.azulEscuro,
          foregroundColor: EducareCores.branco,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          shape: const StadiumBorder(),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          textStyle: EducareTextos.botao,
        ),
      ),

      // Componente 3: campo de formulário (cinza, raio 24, borda azul de 3 px)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EducareCores.campo,
        hintStyle: GoogleFonts.poppins(color: EducareCores.textoCampo),
        prefixIconColor: EducareCores.iconeCampo,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        border: _bordaCampo,
        enabledBorder: _bordaCampo,
        focusedBorder: _bordaCampo.copyWith(
            borderSide: const BorderSide(color: EducareCores.azulEscuro, width: 3)),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: EducareCores.branco,
        selectedItemColor: EducareCores.azulMedio,
        unselectedItemColor: EducareCores.bloqueadaBorda,
      ),
    );
  }

  static const OutlineInputBorder _bordaCampo = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(24)),
    borderSide: BorderSide(color: EducareCores.azulPrimario, width: 3),
  );
}
