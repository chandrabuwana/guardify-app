import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../../domain/entities/news.dart';
import '../../../../core/design/colors.dart';

class NewsDetailPage extends StatefulWidget {
  final News news;

  const NewsDetailPage({
    super.key,
    required this.news,
  });

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(NewsLoadNewsById(widget.news.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        final news = state.selectedNews ?? widget.news;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Detail Berita',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // News Image
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: neutral30,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                      ),
                      child: news.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.r),
                                bottomRight: Radius.circular(16.r),
                              ),
                              child: Image.network(
                                news.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: neutral30,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 48.sp,
                                      color: neutral50,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.image_not_supported,
                              size: 48.sp,
                              color: neutral50,
                            ),
                    ),

                    // News Content
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            news.title,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: neutral90,
                              height: 1.3,
                            ),
                          ),

                          8.verticalSpace,

                          // Category and Date
                          Text(
                            '${news.category} - ${DateFormat('dd/MM/yyyy').format(news.publishedAt)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: neutral70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          16.verticalSpace,

                          // Content
                          Text(
                            news.content,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: neutral90,
                              height: 1.6,
                            ),
                          ),

                          24.verticalSpace,

                          // Source
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: neutral10,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.link,
                                  size: 16.sp,
                                  color: neutral70,
                                ),
                                8.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    'Sumber: ${news.source}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: neutral70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          32.verticalSpace,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  ),
                ),
              if (!state.isLoading && state.errorMessage != null)
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  top: 16.h,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      state.errorMessage ?? '',
                      style: TextStyle(
                        color: errorColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
