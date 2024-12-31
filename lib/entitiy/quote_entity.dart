class Quote {
  final String id;
  final String text;
  final String category;
  bool liked; // New property to track if the quote is liked

  Quote({
    required this.id,
    required this.text,
    required this.category,
    this.liked = false, // Initialize liked to false by default
  });

  // Factory constructor to create a Quote from JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      text: json['text'] as String,
      category: json['category'] as String,
      liked: json['liked'] ?? false, // Load liked status from JSON, default to false if not present
    );
  }

  // Method to convert a Quote object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'liked': liked, // Include liked status in the JSON representation
    };
  }

  // Method to toggle the liked status
  void toggleLiked() {
    liked = !liked;
    
  }
}
