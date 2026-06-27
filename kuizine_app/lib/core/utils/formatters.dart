import 'package:intl/intl.dart';

/// Formatters for KUIZINE — XOF currency, Benin phone numbers, dates
class Formatters {
  Formatters._();

  // ─── Currency (XOF / FCFA) ───

  /// Format price as FCFA: "1 545 FCFA"
  static String formatPrice(num price) {
    final formatter = NumberFormat('#,##0', 'fr_FR');
    return '${formatter.format(price)} FCFA';
  }

  /// Format price short: "1.5K FCFA"
  static String formatPriceShort(num price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M FCFA';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K FCFA';
    }
    return '${price.toInt()} FCFA';
  }

  /// Format price with XOF symbol: "XOF 1,545"
  static String formatPriceXof(num price) {
    final formatter = NumberFormat('#,##0', 'fr_FR');
    return 'XOF ${formatter.format(price)}';
  }

  // ─── Phone Numbers ───

  /// Format Benin phone number: "+229 97 12 34 56"
  static String formatPhone(String phone) {
    final clean = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (clean.startsWith('+229') && clean.length == 12) {
      final number = clean.substring(4);
      return '+229 ${number.substring(0, 2)} ${number.substring(2, 4)} ${number.substring(4, 6)} ${number.substring(6)}';
    }
    return phone;
  }

  /// Remove formatting from phone: "97 12 34 56" → "+22997123456"
  static String cleanPhone(String phone) {
    var clean = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!clean.startsWith('+')) {
      if (clean.startsWith('229')) {
        clean = '+$clean';
      } else {
        clean = '+229$clean';
      }
    }
    return clean;
  }

  // ─── Dates ───

  /// Format date: "18 juin 2026"
  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'fr_FR').format(date);
  }

  /// Format date short: "18/06/2026"
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format time: "14:30"
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format date and time: "18 juin 2026 à 14:30"
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} à ${formatTime(date)}';
  }

  /// Format relative time: "il y a 5 min", "il y a 2h", "hier"
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'à l\'instant';
    } else if (diff.inMinutes < 60) {
      return 'il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'il y a ${diff.inHours}h';
    } else if (diff.inDays == 1) {
      return 'hier';
    } else if (diff.inDays < 7) {
      return 'il y a ${diff.inDays} jours';
    } else {
      return formatDateShort(date);
    }
  }

  // ─── Order Numbers ───

  /// Format order number: "KUZ-20260618-001"
  static String formatOrderNumber(int id) {
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    return 'KUZ-$date-${id.toString().padLeft(3, '0')}';
  }

  // ─── Quantity ───

  /// Format quantity with unit: "2.5 kg", "3 tas"
  static String formatQuantity(num quantity, String unit) {
    if (quantity == quantity.toInt()) {
      return '${quantity.toInt()} $unit';
    }
    return '${quantity.toStringAsFixed(1)} $unit';
  }

  // ─── Percentage ───

  /// Format margin: "+4.0%"
  static String formatMargin(num margin) {
    return '+${margin.toStringAsFixed(1)}%';
  }
}
