import 'package:flutter/material.dart';
import 'package:karaba/core/utils/app_dimensions.dart';
import 'app_palette.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPalette.border]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      );

  static ThemeData getTheme(BuildContext context) {
    AppDimensions.init(context);
    return ThemeData(
      fontFamily: 'SpaceGrotesk',
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppPalette.background,

      colorScheme: const ColorScheme.dark(
        primary: AppPalette.primary,
        onPrimary: AppPalette.onPrimary,
        primaryContainer: AppPalette.primaryContainer,
        surface: AppPalette.surface,
        onSurface: AppPalette.primaryText,
        onSurfaceVariant: AppPalette.secondaryText,
        surfaceContainer: AppPalette.card,
        error: AppPalette.error,
        outline: AppPalette.border,
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        tileColor: AppPalette.card,
        titleTextStyle: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppPalette.primaryText,
        ),
        subtitleTextStyle: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 14,
          color: AppPalette.secondaryText,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: AppPalette.primary,
      ),

      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (BuildContext context) =>
            const Icon(Icons.keyboard_arrow_left, size: 30),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : AppPalette.secondaryText,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppPalette.primary
              : AppPalette.border,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppPalette.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppPalette.surfaceDim,
        indicatorColor: AppPalette.primary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppPalette.primary
                : AppPalette.secondaryText,
          ),
        ),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: AppPalette.card,
        contentTextStyle: const TextStyle(color: AppPalette.primaryText),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: AppDimensions.sp(32),
          fontWeight: FontWeight.w700,
          color: AppPalette.primaryText,
        ),
        headlineMedium: TextStyle(
          fontSize: AppDimensions.sp(24),
          fontWeight: FontWeight.w600,
          color: AppPalette.primaryText,
        ),
        titleMedium: TextStyle(
          fontSize: AppDimensions.sp(18),
          fontWeight: FontWeight.w500,
          color: AppPalette.primaryText,
        ),
        bodyLarge: TextStyle(
          fontSize: AppDimensions.sp(16),
          fontWeight: FontWeight.w400,
          color: AppPalette.primaryText,
        ),
        bodySmall: TextStyle(
          fontSize: AppDimensions.sp(12),
          fontWeight: FontWeight.w300,
          color: AppPalette.secondaryText,
        ),
        labelLarge: TextStyle(
          fontSize: AppDimensions.sp(14),
          fontWeight: FontWeight.w600,
          color: AppPalette.primaryText,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SpaceGrotesk',
          color: AppPalette.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppPalette.primaryText),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: CircleBorder(),
        foregroundColor: AppPalette.primaryText,
      ),

      dividerTheme: DividerThemeData(color: AppPalette.border, thickness: 0.5),

      sliderTheme: SliderThemeData(
        activeTrackColor: AppPalette.primary,
        inactiveTrackColor: AppPalette.border,
        trackHeight: 6,

        thumbColor: Colors.white,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
          elevation: 4,
        ),
        overlayColor: AppPalette.primary.withValues(alpha: 0.2),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),

        valueIndicatorColor: AppPalette.primary,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
          fontSize: AppDimensions.sp(14),
          fontWeight: FontWeight.w600,
        ),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        showValueIndicator: ShowValueIndicator.onDrag,

        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 8,
          elevation: 4,
        ),

        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppPalette.primary,
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: AppPalette.secondaryText),
        floatingLabelStyle: const TextStyle(color: AppPalette.primary),
        errorMaxLines: 5,
        filled: true,
        fillColor: AppPalette.card,
        contentPadding: const EdgeInsets.all(18),
        enabledBorder: _border(),
        focusedBorder: _border(AppPalette.primary),
        errorBorder: _border(AppPalette.error),
        focusedErrorBorder: _border(AppPalette.error),
        hintStyle: TextStyle(
          fontFamily: 'SpaceGrotesk',
          color: AppPalette.secondaryText,
          fontSize: AppDimensions.sp(12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primary,
          foregroundColor: AppPalette.primaryText,
          textStyle: TextStyle(
            fontFamily: 'SpaceGrotesk',
            color: AppPalette.secondaryText,
            fontWeight: FontWeight.w700,
            fontSize: AppDimensions.sp(14),
          ),
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      chipTheme: const ChipThemeData(
        backgroundColor: AppPalette.card,
        side: BorderSide(color: AppPalette.border),
        labelStyle: TextStyle(color: AppPalette.primaryText),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: StadiumBorder(),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppPalette.background,
        selectedItemColor: AppPalette.primary,
        unselectedItemColor: AppPalette.secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppPalette.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppPalette.card,
        modalBackgroundColor: AppPalette.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppPalette.card,
        elevation: 0,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppPalette.border),
        ),
      ),
    );
  }
}
