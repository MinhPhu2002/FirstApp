import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testapp/module/review/add_review_screen.dart';
import 'package:testapp/core/constants/icon_path.dart';
import 'package:testapp/core/constants/product_path.dart';
import 'package:testapp/core/theme/app_text_style.dart';
import 'package:testapp/module/review/bloc/comment_cubit.dart';
import 'package:testapp/module/review/bloc/comment_state.dart';
import 'package:testapp/widget/circle_icon.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:testapp/widget/comment.dart';
import 'package:testapp/widget/rating.dart';

class ReviewScreen extends StatefulWidget {
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final CommentCubit commentCubit;
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    commentCubit = context.read<CommentCubit>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter < 226) {
      commentCubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            child: CircleIcon(
              iconname: IconPath.back,
              colorCircle: const Color.fromRGBO(245, 246, 250, 1),
              sizeIcon: const Size(25, 25),
              sizeCircle: const Size(45, 45),
              colorBorder: Colors.transparent,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          "Reviews",
          style: AppTextStyle.s17_w6.copyWith(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            children: [
              NumberReviews(),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<CommentCubit, CommentState>(
                  builder: (context, state) {
                    if (state.isLoading && state.comment == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.errorMessage != null && state.comment == null) {
                      return Center(
                        child: Text(state.errorMessage!),
                      );
                    }
                    final data = state.comment!;
                    return ListView.builder(
                        controller: controller,
                        itemCount: data.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == data.length) {
                            if (state.errorMessage != null) {
                              return Text(state.errorMessage!);
                            }
                            return Center(child: CircularProgressIndicator());
                          }

                          var item = data[index];
                          return CommentProduct(
                              avatar: ProductPath.avatar2,
                              name: item.user,
                              time: '13 Sep, 2020',
                              ratingScore: 4,
                              comment: item.comment);
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Column(
          children: [
            const Text("245 Reviews", style: AppTextStyle.s15_w5),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text("4.8", style: AppTextStyle.s13_w4),
                const SizedBox(width: 1),
                rating(),
              ],
            )
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddReviewScreen(),
                ));
          },
          child: Image.asset(
            ProductPath.addReview,
            width: 114,
            height: 35,
          ),
        )
      ],
    );
  }
}
