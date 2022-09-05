import 'package:bootcamp_app/controller/base/base_state.dart';
import 'package:bootcamp_app/controller/blog/state/blog_state.dart';
import 'package:bootcamp_app/model/blog_model.dart';
import 'package:bootcamp_app/network/endpoints.dart';
import 'package:bootcamp_app/network/network_utils.dart';
import 'package:riverpod/riverpod.dart';

final favoriteBlogsListProvider =
    StateNotifierProvider<FavoriteBlogsListController, BaseState>(
  (ref) => FavoriteBlogsListController(ref: ref),
);

class FavoriteBlogsListController extends StateNotifier<BaseState> {
  final Ref? ref;
  FavoriteBlogsListController({this.ref}) : super(const InitialState());

  List<BlogModel> favoriteBlogsList = [];

  Future fetchFavoriteBlogsList() async {
    state = const LoadingState();
    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.getAllFavoriteBlogs),
      );
      if (responseBody != null) {
        favoriteBlogsList = (responseBody['data'] as List<dynamic>)
            .map((x) => BlogModel.fromJson(x))
            .toList();

        state = FavoriteBlogsListSuccessState(favoriteBlogsList);
      } else {
        state = const ErrorState();
      }
    } catch (error, stackTrace) {
      print('fetchBlogsList() error = $error');
      print(stackTrace);
      state = const ErrorState();
    }
  }
}
