/// Validators for KUIZINE — Benin-specific validation rules
class Validators {
  Validators._();

  /// Validate Benin phone number
  /// Valid formats: +22997123456, 22997123456, 97123456
  /// Benin numbers: 8 digits, starting with 4, 5, 6, 9
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre numéro de téléphone';
    }

    final clean = value.replaceAll(RegExp(r'[^\d]'), '');
    String number;

    if (clean.startsWith('229')) {
      number = clean.substring(3);
    } else {
      number = clean;
    }

    if (number.length != 8) {
      return 'Le numéro doit contenir 8 chiffres';
    }

    // Benin mobile prefixes: 4x, 5x, 6x, 9x
    final firstDigit = int.tryParse(number[0]);
    if (firstDigit == null || ![4, 5, 6, 9].contains(firstDigit)) {
      return 'Numéro de téléphone béninois invalide';
    }

    return null;
  }

  /// Validate OTP code (6 digits)
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir le code OTP';
    }

    if (value.length != 6) {
      return 'Le code doit contenir 6 chiffres';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Le code ne doit contenir que des chiffres';
    }

    return null;
  }

  /// Validate full name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre nom complet';
    }

    if (value.trim().length < 3) {
      return 'Le nom doit contenir au moins 3 caractères';
    }

    if (value.trim().length > 100) {
      return 'Le nom est trop long';
    }

    return null;
  }

  /// Validate delivery address
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre adresse de livraison';
    }

    if (value.trim().length < 10) {
      return 'Veuillez fournir une adresse plus détaillée';
    }

    return null;
  }

  /// Validate quantity
  static String? validateQuantity(String? value, {num? min, num? max}) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir une quantité';
    }

    final quantity = num.tryParse(value);
    if (quantity == null) {
      return 'Quantité invalide';
    }

    if (quantity <= 0) {
      return 'La quantité doit être supérieure à 0';
    }

    if (min != null && quantity < min) {
      return 'Quantité minimum: $min';
    }

    if (max != null && quantity > max) {
      return 'Quantité maximum: $max';
    }

    return null;
  }

  /// Check if phone is MTN Benin
  /// MTN prefixes: 96, 97, 90, 91, 66, 67, 46, 47
  static bool isMtnBenin(String phone) {
    final clean = phone.replaceAll(RegExp(r'[^\d]'), '');
    String number;
    if (clean.startsWith('229')) {
      number = clean.substring(3);
    } else {
      number = clean;
    }
    if (number.length != 8) return false;

    final prefix = number.substring(0, 2);
    return ['96', '97', '90', '91', '66', '67', '46', '47'].contains(prefix);
  }

  /// Check if phone is Moov Benin
  /// Moov prefixes: 94, 95, 98, 99, 64, 65, 68, 69
  static bool isMoovBenin(String phone) {
    final clean = phone.replaceAll(RegExp(r'[^\d]'), '');
    String number;
    if (clean.startsWith('229')) {
      number = clean.substring(3);
    } else {
      number = clean;
    }
    if (number.length != 8) return false;

    final prefix = number.substring(0, 2);
    return ['94', '95', '98', '99', '64', '65', '68', '69'].contains(prefix);
  }
}
