import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xcare/medical_home_page.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  late Future<List<dynamic>> _newsData;
  final Map<int, bool> _expandedPosts = {};
  final Map<int, TextEditingController> _commentControllers = {};
  final Map<int, bool> _showAllComments = {};
  final int profileId = 1; // Replace with actual profile ID

  @override
  void initState() {
    super.initState();
    _newsData = _fetchNewsData();
  }

  Future<List<dynamic>> _fetchNewsData() async {
    try {
      final response = await http.get(
        Uri.parse('https://ai-x-care.future-developers.cloud/posts/'),
        headers: {
          'X-API-KEY': 'zkzk_sonbol_2020', // Replace with your actual API key
        },
      );
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _newsData = _fetchNewsData();
    });
  }

  Future<void> _handleLikeDislike(int postId, bool isLike) async {
    final url = 'https://ai-x-care.future-developers.cloud/posts/${isLike ? 'like' : 'dislike'}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'X-API-KEY': 'zkzk_sonbol_2020', // Replace with your actual API key
        },
      );
      if (response.statusCode == 200) {
        _refreshData(); // Refresh data to update UI
      } else {
        throw Exception('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<List<dynamic>> _fetchComments(int postId) async {
    final url = 'https://ai-x-care.future-developers.cloud/post/comments/$postId';
    print('Fetching comments from: $url'); // Debug statement
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-API-KEY': 'zkzk_sonbol_2020', // Replace with your actual API key
        },
      );
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  Future<void> _addComment(int postId, String comment, int profileId) async {
    final url = 'https://ai-x-care.future-developers.cloud/post/comments/$postId';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'X-API-KEY': 'zkzk_sonbol_2020', // Replace with your actual API key
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'body': comment, 'blog_post': postId, 'profile': profileId}),
      );
      if (response.statusCode == 201) {
        _refreshData(); // Refresh data to update UI
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 169, 167, 167),
        title: const Text('BLOG'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 70, 167, 246)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MedicalHomePage()),
            );
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 195, 195, 195),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<dynamic>>(
          future: _newsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MedicalHomePage()),
                        );
                      },
                      child: const Text('BACK'),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var article = snapshot.data![index];
                  bool isExpanded = _expandedPosts[article['id']] ?? false;
                  bool showAllComments = _showAllComments[article['id']] ?? false;
                  _commentControllers[article['id']] ??= TextEditingController();

                  return InkWell(
                    onTap: () {
                      // Implement onTap functionality
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://ai-x-care.future-developers.cloud/${article['doctor']['photo']}',
                                  width: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['doctor']['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'posted on ${article['create_date']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['body'],
                                  maxLines: isExpanded ? null : 2,
                                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                  textDirection: TextDirection.rtl,
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _expandedPosts[article['id']] = !isExpanded;
                                    });
                                  },
                                  child: Text(isExpanded ? ' show less' : 'show more'),
                                ),
                              ],
                            ),
                          ),
                          if (article['media_file'] != null && article['media_file'].isNotEmpty)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.network(
                                'https://ai-x-care.future-developers.cloud/${article['media_file']}',
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Container(); // Return an empty container in case of error
                                },
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.thumb_up),
                                      onPressed: () {
                                        print('Liking post ${article['id']}'); // Debugging statement
                                        _handleLikeDislike(article['id'], true);
                                      },
                                    ),
                                    Text('${article['likes']}'),
                                    IconButton(
                                      icon: const Icon(Icons.thumb_down),
                                      onPressed: () {
                                        print('Disliking post ${article['id']}'); // Debugging statement
                                        _handleLikeDislike(article['id'], false);
                                      },
                                    ),
                                    Text('${article['dislikes']}'),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showAllComments[article['id']] = !showAllComments;
                                    });
                                  },
                                  child: Text(showAllComments ? 'hide comments' : 'show all comments'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: FutureBuilder<List<dynamic>>(
                              future: _fetchComments(article['id']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Failed to load comments: ${snapshot.error}');
                                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                                  return const Text('No comments yet.');
                                } else {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Comments:',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      ...snapshot.data!.take(showAllComments ? snapshot.data!.length : 2).map<Widget>((comment) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            comment['body'],
                                            textDirection: TextDirection.rtl,
                                          ),
                                        );
                                      }).toList(),
                                      TextField(
                                        controller: _commentControllers[article['id']],
                                        decoration: const InputDecoration(
                                          labelText: 'Add a comment',
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_commentControllers[article['id']]!.text.isNotEmpty) {
                                            _addComment(article['id'], _commentControllers[article['id']]!.text, profileId);
                                            _commentControllers[article['id']]!.clear();
                                          }
                                        },
                                        child: const Text('Post Comment'),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

