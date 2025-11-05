import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/news.dart';
import '../../../../core/design/colors.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;

  const NewsDetailPage({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
    );
  }
}
