class LostAndFoundManager {
  // Singleton pattern
  static final LostAndFoundManager _instance = LostAndFoundManager._internal();

  factory LostAndFoundManager() {
    return _instance;
  }

  LostAndFoundManager._internal();

  // This will hold the posts globally
  List<Map<String, dynamic>> lostAndFoundPosts = [];

  // Method to add a new post
  void addPost(Map<String, dynamic> post) {
    lostAndFoundPosts.add(post);
  }

  // Method to get all posts
  List<Map<String, dynamic>> getPosts() {
    return lostAndFoundPosts;
  }
}
