import 'package:bootcamp_app/controller/blog/blog_controller.dart';
import 'package:bootcamp_app/controller/blog/blogs_list_controller.dart';
import 'package:bootcamp_app/controller/blog/state/blog_state.dart';
import 'package:bootcamp_app/views/screens/components/blog_card.dart';
import 'package:bootcamp_app/views/screens/create_update_blog_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogsListScreen extends ConsumerStatefulWidget {
  const BlogsListScreen({Key? key}) : super(key: key);

  @override
  _BlogsListScreenState createState() => _BlogsListScreenState();
}

class _BlogsListScreenState extends ConsumerState<BlogsListScreen> {
  @override
  Widget build(BuildContext context) {
    final blogsListState = ref.watch(blogsListProvider);
    var blogsList =
        blogsListState is BlogsListSuccessState ? blogsListState.blogsList : [];

    ref.listen(
      blogProvider,
      (_, state) {
        if (state is BlogSuccessState) {
          setState(() {
            final blogsListState = ref.watch(blogsListProvider);
            blogsList = blogsListState is BlogsListSuccessState
                ? blogsListState.blogsList
                : [];
          });
        }
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const CreateUpdateBlogScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: blogsListState is BlogsListSuccessState
          ? ListView.builder(
              itemCount: blogsList.length,
              itemBuilder: (BuildContext context, int index) {
                return BlogCard(
                  blogModel: blogsList[index],
                  onFavoritePress: () async {
                    int value;
                    if (blogsList[index].isFavorite == 0) {
                      value = 1;
                    } else {
                      value = 0;
                    }
                    await ref.read(blogProvider.notifier).isFavoriteBlog(
                          blogId: blogsList[index].id,
                          is_favorite: value,
                        );
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
