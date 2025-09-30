import 'package:flutter/material.dart';
import '../pages/company_regulations_page.dart';
import '../pages/document_detail_page.dart';
import '../../domain/entities/document_entity.dart';

/// Routes untuk fitur company regulations
class CompanyRegulationsRoutes {
  static const String regulationsList = '/company-regulations';
  static const String documentDetail = '/document-detail';

  /// Map semua routes untuk fitur ini
  static Map<String, WidgetBuilder> get routes => {
        regulationsList: (context) => const CompanyRegulationsPage(),
        documentDetail: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          
          if (args is DocumentEntity) {
            return DocumentDetailPage(document: args);
          } else if (args is Map<String, dynamic>) {
            return DocumentDetailPage(
              documentId: args['documentId'] as String?,
              document: args['document'] as DocumentEntity?,
            );
          }
          
          // Fallback: redirect ke list page
          Navigator.of(context).pushReplacementNamed(regulationsList);
          return const SizedBox.shrink();
        },
      };

  /// Generate route dengan custom animations
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case regulationsList:
        return _createSlideRoute(
          page: const CompanyRegulationsPage(),
          settings: settings,
        );
      
      case documentDetail:
        final args = settings.arguments;
        Widget page;
        
        if (args is DocumentEntity) {
          page = DocumentDetailPage(document: args);
        } else if (args is Map<String, dynamic>) {
          page = DocumentDetailPage(
            documentId: args['documentId'] as String?,
            document: args['document'] as DocumentEntity?,
          );
        } else {
          // Invalid arguments, fallback
          return _createSlideRoute(
            page: const CompanyRegulationsPage(),
            settings: settings,
          );
        }
        
        return _createSlideRoute(
          page: page,
          settings: settings,
          direction: SlideDirection.fromRight,
        );
      
      default:
        return null;
    }
  }
}

/// Enum untuk arah slide animation
enum SlideDirection {
  fromRight,
  fromLeft,
  fromTop,
  fromBottom,
}

/// Helper untuk membuat slide transition
Route<T> _createSlideRoute<T>({
  required Widget page,
  required RouteSettings settings,
  SlideDirection direction = SlideDirection.fromRight,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin;
      
      switch (direction) {
        case SlideDirection.fromRight:
          begin = const Offset(1.0, 0.0);
          break;
        case SlideDirection.fromLeft:
          begin = const Offset(-1.0, 0.0);
          break;
        case SlideDirection.fromTop:
          begin = const Offset(0.0, -1.0);
          break;
        case SlideDirection.fromBottom:
          begin = const Offset(0.0, 1.0);
          break;
      }
      
      const end = Offset.zero;
      final curve = Curves.easeInOutCubic;
      
      final slideTween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      
      // Fade animation untuk smooth transition
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
      final fadeAnimation = fadeTween.animate(curvedAnimation);
      
      return SlideTransition(
        position: slideTween.animate(curvedAnimation),
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}

/// Helper untuk membuat fade transition
Route<T> _createFadeRoute<T>({
  required Widget page,
  required RouteSettings settings,
  Duration duration = const Duration(milliseconds: 400),
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      
      return FadeTransition(
        opacity: curvedAnimation,
        child: child,
      );
    },
  );
}

/// Helper untuk membuat scale transition
Route<T> _createScaleRoute<T>({
  required Widget page,
  required RouteSettings settings,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOutCubic;
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      
      final scaleTween = Tween<double>(begin: 0.8, end: 1.0);
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
      
      return ScaleTransition(
        scale: scaleTween.animate(curvedAnimation),
        child: FadeTransition(
          opacity: fadeTween.animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

/// Extension methods untuk navigation yang mudah digunakan
extension CompanyRegulationsNavigation on NavigatorState {
  /// Navigate ke halaman peraturan perusahaan
  Future<T?> pushToCompanyRegulations<T extends Object?>() {
    return pushNamed<T>(CompanyRegulationsRoutes.regulationsList);
  }

  /// Navigate ke detail dokumen dengan entity
  Future<T?> pushToDocumentDetail<T extends Object?>(DocumentEntity document) {
    return pushNamed<T>(
      CompanyRegulationsRoutes.documentDetail,
      arguments: document,
    );
  }

  /// Navigate ke detail dokumen dengan ID
  Future<T?> pushToDocumentDetailById<T extends Object?>(String documentId) {
    return pushNamed<T>(
      CompanyRegulationsRoutes.documentDetail,
      arguments: {'documentId': documentId},
    );
  }
}

/// Extension methods untuk BuildContext navigation
extension CompanyRegulationsNavigationContext on BuildContext {
  /// Navigate ke halaman peraturan perusahaan
  Future<T?> pushToCompanyRegulations<T extends Object?>() {
    return Navigator.of(this).pushToCompanyRegulations<T>();
  }

  /// Navigate ke detail dokumen dengan entity
  Future<T?> pushToDocumentDetail<T extends Object?>(DocumentEntity document) {
    return Navigator.of(this).pushToDocumentDetail<T>(document);
  }

  /// Navigate ke detail dokumen dengan ID
  Future<T?> pushToDocumentDetailById<T extends Object?>(String documentId) {
    return Navigator.of(this).pushToDocumentDetailById<T>(documentId);
  }
}