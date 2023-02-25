import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:blitz_hris/Config/Api.dart';

class News extends StatefulWidget {
  List? data = [];
  News({this.data});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  void initstate() {
    super.initState();
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: widget.data! == null
            ? Text('')
            : CarouselSlider.builder(
                options: CarouselOptions(
                  viewportFraction: 0.7,
                  initialPage: 0,
                  autoPlayInterval: Duration(seconds: 3),
                  scrollDirection: Axis.horizontal,
                  height: MediaQuery.of(context).size.width / 2,
                ),
                itemCount: widget.data! == null ? 0 : widget.data!.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = KEY.BASE_URL + widget.data![index]['image'];
                  return buildImage(
                      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                      index);
                },
              ),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   PageRouteBuilder(
        //     pageBuilder: (BuildContext context, Animation<double> animation,
        //         Animation<double> secondaryAnimation) {
        //       return DetailBlog(data: "${widget.data![index]['id']}");
        //     },
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => new Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.grey,
                        size: 30.0,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Flexible(
              child: Text(
                widget.data![index]['name'],
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12.w,
                    color: Colors.grey),
              ),
            ),
          ],
        ),
      ));
}
