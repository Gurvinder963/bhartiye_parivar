import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import'../ApiResponses/BookListResponse.dart';
import '../ApiResponses/BookData.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
class FullScreenGalleryPage extends StatefulWidget {

  final BookData content;
  final int mIndex;


  FullScreenGalleryPage({Key key,@required this.content,@required this.mIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FullScreenGalleryPageState(content,mIndex);
  }
}

class FullScreenGalleryPageState extends State<FullScreenGalleryPage> {

  int currentPos = 0;
   BookData mContent;
  List listPaths=new List();


  FullScreenGalleryPageState(BookData content,int index){
    currentPos=index;
    mContent=content;
    listPaths.addAll(content.images);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color(AppColors.BaseColor),
        title: Text(mContent.title, style: GoogleFonts.roboto(fontSize: 23,color: Color(0xFFFFFFFF).withOpacity(1),fontWeight: FontWeight.w600)),

      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                  itemCount: listPaths.length,

                  options: CarouselOptions(
                      initialPage: currentPos,
                      autoPlay: true,
                      height: 400,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentPos = index;
                        });
                      }
                  ),
                  itemBuilder: (context,index){
                    return MyImageView(listPaths[index]);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: listPaths.map((url) {
                    int index = listPaths.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPos == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ]
          )
      ),
    );
  }
}

class MyImageView extends StatelessWidget{

  String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

        margin: EdgeInsets.symmetric(horizontal: 5),
        child: FittedBox(
          fit: BoxFit.fill,
          child:Image.network(imgPath, fit: BoxFit.fill, width: 1000),
        )
    );
  }

}