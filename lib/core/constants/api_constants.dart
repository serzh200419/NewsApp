class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String topHeadlines = '/top-headlines';
  
  // Register at https://newsapi.org to get your API key
  // Note: Get your own free key at newsapi.org for production use
  static const String apiKey = 'demo';
  
  static const String defaultCountry = 'us';
}

class CategoryConstants {
  static const String business = 'business';
  static const String entertainment = 'entertainment';
  static const String general = 'general';
  static const String health = 'health';
  
  static const List<String> categories = [
    business,
    entertainment,
    general,
    health,
  ];
  
  static String capitalize(String category) {
    return category[0].toUpperCase() + category.substring(1);
  }
}

