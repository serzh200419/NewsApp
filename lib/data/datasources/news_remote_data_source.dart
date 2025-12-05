import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    String? category,
    String? query,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl({required this.dio});

  // Mock data for demonstration - replace with real API call when you have an API key
  static final List<Map<String, dynamic>> _mockArticles = [
    {
      'source': {'id': 'variety', 'name': 'Variety'},
      'author': 'Ellise Shafer',
      'title': 'Tom Sizemore, \'Saving Private Ryan\' Actor, Dies at 61 - Variety',
      'description': 'Tom Sizemore, the character actor known for his roles in films like "Saving Private Ryan" and "Black Hawk Down," has died. He was 61.',
      'url': 'https://variety.com/2023/film/news/tom-sizemore-dead-saving-private-ryan-1235545091/',
      'urlToImage': 'https://variety.com/wp-content/uploads/2023/03/GettyImages-74aborr261.jpg',
      'publishedAt': '2024-03-03T18:30:00Z',
      'content': 'Tom Sizemore, the character actor known for his intense performances in films like "Saving Private Ryan," "Black Hawk Down," and "Heat," has died. He was 61. The actor had been hospitalized since February 18 after suffering a brain aneurysm.',
    },
    {
      'source': {'id': 'life', 'name': 'Life'},
      'author': 'Rosemary',
      'title': 'Secondary school places: When do parents find out?',
      'description': 'Parents across the country are waiting to find out which secondary school their child has been allocated.',
      'url': 'https://example.com/secondary-school',
      'urlToImage': 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=400',
      'publishedAt': '2024-03-02T10:00:00Z',
      'content': 'National Offer Day for secondary school places is approaching, and parents are eagerly awaiting news about their children\'s school allocations.',
    },
    {
      'source': {'id': 'abc-news', 'name': 'ABC News'},
      'author': 'Patricio Chile',
      'title': 'Gordon Moore, co-founder and former chairman of Intel, dies at 94',
      'description': 'Gordon Moore, the co-founder and former chairman of tech giant Intel, died Friday at the age of 94.',
      'url': 'https://abcnews.go.com/Technology/gordon-moore-founder-intel-dies-94/story',
      'urlToImage': 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
      'publishedAt': '2024-03-01T14:20:00Z',
      'content': 'Gordon Moore, the co-founder and former chairman of tech giant Intel, died Friday at the age of 94, the company and the Gordon and Betty Moore Foundation announced. A press release stated Moore died at his home in Hawaii surrounded by family.',
    },
    {
      'source': {'id': 'business-insider', 'name': 'Business Insider'},
      'author': 'Sarah Johnson',
      'title': 'Tech stocks surge amid AI optimism',
      'description': 'Major technology companies see significant gains as investors bet on artificial intelligence growth.',
      'url': 'https://example.com/tech-stocks',
      'urlToImage': 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400',
      'publishedAt': '2024-03-03T09:15:00Z',
      'content': 'Technology stocks rallied on Monday as investors showed renewed optimism about the growth potential of artificial intelligence applications across various industries.',
    },
    {
      'source': {'id': 'health-news', 'name': 'Health News'},
      'author': 'Dr. Emily Watson',
      'title': 'New study reveals benefits of Mediterranean diet',
      'description': 'Research shows following a Mediterranean diet can significantly reduce the risk of heart disease.',
      'url': 'https://example.com/mediterranean-diet',
      'urlToImage': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400',
      'publishedAt': '2024-03-02T16:45:00Z',
      'content': 'A comprehensive study published in a leading medical journal has confirmed that adherence to a Mediterranean diet rich in olive oil, fish, and vegetables can reduce cardiovascular disease risk by up to 30%.',
    },
    {
      'source': {'id': 'entertainment-weekly', 'name': 'Entertainment Weekly'},
      'author': 'Mike Reynolds',
      'title': 'Upcoming blockbuster breaks pre-sale records',
      'description': 'The highly anticipated summer movie has already broken box office pre-sale records.',
      'url': 'https://example.com/blockbuster-records',
      'urlToImage': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400',
      'publishedAt': '2024-03-03T11:30:00Z',
      'content': 'The upcoming superhero film has shattered pre-sale ticket records, suggesting it could become one of the highest-grossing movies of the year.',
    },
  ];

  static const Map<String, List<int>> _categoryIndices = {
    'business': [3],
    'entertainment': [0, 5],
    'general': [1, 2],
    'health': [4],
  };

  @override
  Future<List<ArticleModel>> getTopHeadlines({
    String? category,
    String? query,
  }) async {
    // Try real API first if API key is configured
    if (ApiConstants.apiKey != 'demo' && ApiConstants.apiKey != 'YOUR_API_KEY_HERE') {
      try {
        final queryParams = <String, dynamic>{};
        
        if (category != null && category.isNotEmpty) {
          queryParams['category'] = category;
        }
        
        if (query != null && query.isNotEmpty) {
          queryParams['q'] = query;
        }

        final response = await dio.get(
          ApiConstants.topHeadlines,
          queryParameters: queryParams,
        );

        if (response.statusCode == 200) {
          final newsResponse = NewsResponseModel.fromJson(response.data);
          return newsResponse.articles;
        }
      } catch (e) {
        // Fall through to mock data
      }
    }

    // Use mock data for demonstration
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    List<Map<String, dynamic>> filteredArticles = List.from(_mockArticles);
    
    // Filter by category
    if (category != null && category.isNotEmpty) {
      final indices = _categoryIndices[category] ?? [];
      filteredArticles = indices.map((i) => _mockArticles[i]).toList();
    }
    
    // Filter by search query
    if (query != null && query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      filteredArticles = filteredArticles.where((article) {
        final title = (article['title'] as String? ?? '').toLowerCase();
        final description = (article['description'] as String? ?? '').toLowerCase();
        final author = (article['author'] as String? ?? '').toLowerCase();
        return title.contains(queryLower) || 
               description.contains(queryLower) || 
               author.contains(queryLower);
      }).toList();
    }
    
    return filteredArticles.map((json) => ArticleModel.fromJson(json)).toList();
  }
}

