import 'dart:io';

import 'package:facebook/constants.dart';
import 'package:facebook/models/api_response.dart';
import 'package:facebook/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import "package:facebook/services/user_services.dart"; 
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController _comment = new TextEditingController();

  List<dynamic> _postsList = [];

  int currentIndex = 0;

  int numCom = 0;
  int num = 0;
  int userId = 0;

  int selectedTab = 0;

  List<Padding> tabs = [
    Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Icon(Icons.home_outlined, color: Colors.grey),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Icon(Icons.group_outlined, color: Colors.grey),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Icon(Icons.message_outlined, color: Colors.grey),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Icon(Icons.notifications_outlined, color: Colors.grey),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Icon(Icons.video_camera_back_outlined, color: Colors.grey),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Icon(Icons.shopping_cart_outlined, color: Colors.grey),
    ),
  ];

  Future _getPosts() async {
    int uid = await getUserId();
    setState(() {
      userId = uid;
    });
    ApiResponse response = await getPosts();

    if(response.error == null){
      setState(() {
        _postsList = response.data as List<dynamic>;
        print(_postsList);
      });
    }
    else if(response.error == unauthorized){
      Fluttertoast.showToast(msg: unauthorized);
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      Fluttertoast.showToast(msg: "An error occurred while processing");
    }
  }

  Future _likePost(int post_id) async {
    int uid = await getUserId();
    setState(() {
      userId = uid;
    });
    
    ApiResponse response = await likePost(post_id);
    if(response.error == null){
      Fluttertoast.showToast(msg: "Post liked");
    }
    else if(response.error == unauthorized){
      Fluttertoast.showToast(msg: unauthorized);
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      Fluttertoast.showToast(msg: "An error occurred while processing");
    }
  }

  void postComment(int com_id, String comment) async {
    ApiResponse response = await addComments(com_id, comment);

    if(response.error != null){
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("${response.error}"),
            icon: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.clear_all,
              ),
            ),
          );
        }
      );
    }
  }
  
  @override
  void initState() {
    super.initState();
    _getPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.search, 
                  color: Colors.black, 
                  size: 30,
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.menu, 
                  color: Colors.black, 
                  size: 30,
                ),
              ),
            ),
          ),
        ],
        title: Text(
          'facebook',
          style: GoogleFonts.firaSans(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.blue[900],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        child: tabs[index],
                      ),
                      SizedBox(height: 10),
                      selectedTab == index ?
                      Container(
                        height: MediaQuery.of(context).size.height * 0.005,
                        width: MediaQuery.of(context).size.width * 0.13,
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ) 
                      :
                      Container(),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(height: 5, color: Colors.grey, thickness: 0.5),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                    child: CircleAvatar(
                      radius: 25,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                    hintText: 'What\'s on your mind?',
                    hintStyle: GoogleFonts.firaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                child: GestureDetector(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/upload');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.photo_camera,
                          color: Colors.black,
                          size: 30,
                        ),
                        Text(
                          'Photo', 
                          style: GoogleFonts.firaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 0, color: Colors.grey[350], thickness: 0.5),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Row(
          //         children: [
          //           Icon(
          //             Icons.emoji_emotions_rounded,
          //             color: Colors.yellow,
          //           ),
          //           SizedBox(width: 5),
          //           Text(
          //             'Feeling',
          //             style: GoogleFonts.firaSans(
          //               fontSize: 15,
          //               fontWeight: FontWeight.w500,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           Icon(
          //             Icons.video_camera_back_rounded,
          //             color: Colors.red,
          //           ),
          //           SizedBox(width: 5),
          //           Text(
          //             'Live Video',
          //             style: GoogleFonts.firaSans(
          //               fontSize: 15,
          //               fontWeight: FontWeight.w500,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           Icon(
          //             Icons.location_on_rounded,
          //             color: Colors.red,
          //           ),
          //           SizedBox(width: 5),
          //           Text(
          //             'Location',
          //             style: GoogleFonts.firaSans(
          //               fontSize: 15,
          //               fontWeight: FontWeight.w500,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // Divider(height: 0, color: Colors.grey[350], thickness: 0.5),
          // Container(
          //   constraints: BoxConstraints(
          //     maxHeight: MediaQuery.of(context).size.height * 0.35,
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.grey,
          //   ),
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
          //     child: Container(
          //         constraints: BoxConstraints(
          //         maxHeight: MediaQuery.of(context).size.height * 0.30,
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //       ),
          //       child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: tabs.length,
          //         itemBuilder: (context, index){
          //           return Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10),
          //                 color: Colors.teal,
          //                 image: DecorationImage(
          //                   image: AssetImage(
          //                     'assets/$index.jpg',
          //                   ),
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //               height: MediaQuery.of(context).size.height * 0.25,
          //               width: MediaQuery.of(context).size.width * 0.27,
          //               child: Center(
          //                 child: Text(
          //                   'Karma $index',
          //                   style: GoogleFonts.firaSans(
          //                     color: Colors.white,
          //                     fontSize: 16,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: FutureBuilder(
              future: getPosts(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.red,
                    ),
                  );
                }
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.blue,
                    ),
                  );
                } else {
                    return ListView.builder(
                    itemCount: _postsList.length,
                    itemBuilder: (context, index){
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.yellow[700],
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${_postsList[index]["user"]["name"]}',
                                            style: GoogleFonts.playfairDisplay(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 18,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${_postsList[index]["created_at"]}',
                                                style: GoogleFonts.rancho(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.person_add_outlined,
                                                color: Colors.grey,
                                                size: 20,
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          child: Icon(
                                            Icons.menu,
                                            color: Colors.grey
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.grey
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 3),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _postsList[index]["image"] != null ? Text(
                                  '${_postsList[index]["caption"]}',
                                  style: GoogleFonts.rancho(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ):
                                null,
                              ),
                              SizedBox(height: 3),
                              Center(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.65,
                                    maxWidth: MediaQuery.of(context).size.width * 0.95,
                                  ),
                                  decoration: BoxDecoration(
                                    image: _postsList[index]["image"] != null ? DecorationImage(
                                      image: NetworkImage(_postsList[index]["image"]),
                                      fit: BoxFit.cover,
                                    ) : null,
                                  ),
                                  child: _postsList[index]["image"] != null ? 
                                    Image(image: NetworkImage(_postsList[index]["image"]), fit: BoxFit.cover)
                                  : Center(
                                    child: Text(
                                      '${_postsList[index]["caption"]}',
                                      style: GoogleFonts.firaSans(
                                        fontSize: 22,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.blue,
                                          child: Icon(
                                            Icons.thumb_up_alt,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                      _postsList[index]["likes_count"] != 0 ? Text(
                                        'User ${_postsList[index]["likes"][0]["user_id"]} and ${_postsList[index]["likes_count"] - 1.toInt()} others',
                                        style: GoogleFonts.rancho(
                                          fontSize: 20,
                                          color: Colors.grey
                                        ),
                                      )
                                      :
                                      Text(
                                        '0',
                                        style: GoogleFonts.rancho(
                                          fontSize: 20,
                                          color: Colors.grey
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          child: GestureDetector(
                                            onTap: () {
                                              _likePost(_postsList[index]["id"]);
                                            },
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width * 0.4,
                                                maxHeight: 40,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey[50],
                                                borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        _postsList[index]["likes"].length == 0 ? Icon(
                                                          Icons.thumb_up_outlined,
                                                          size: 25,
                                                          color: Colors.teal[900],
                                                        ):
                                                        Icon(
                                                          Icons.thumb_up_rounded,
                                                          size: 25,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          '${_postsList[index]["likes_count"]}',
                                                          style: GoogleFonts.rancho(
                                                            fontSize: 22,
                                                            color: Colors.teal[900],
                                                          )
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                                              maxHeight: 40,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey[50],
                                              borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.comment_bank_outlined,
                                                        size: 25,
                                                        color: Colors.teal[900],
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        _postsList[index]["comments_count"].toString(),
                                                        style: GoogleFonts.rancho(
                                                          fontSize: 22,
                                                          color: Colors.teal[900],
                                                        )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // ListView.builder(
                                  //   itemCount: _postsList.length,
                                  //   itemBuilder: (context, index) {
                                  //     return Row(
                                  //       children: [
                                  //         CircleAvatar(
                                  //           radius: 20,
                                  //           backgroundColor: Colors.white,
                                  //         ),
                                  //         SizedBox(width: 10),
                                  //         Container(
                                  //           width: MediaQuery.of(context).size.width * 0.8,
                                  //           decoration: BoxDecoration(
                                  //             color: Colors.blueGrey[50],
                                  //             borderRadius: BorderRadius.circular(10),
                                  //           ),
                                  //           child: Column(
                                  //             children: [
                                  //               Text(
                                  //                 _postsList[index]["user"]["name"],
                                  //                 style: GoogleFonts.rancho(
                                  //                   fontSize: 22,
                                  //                   color: Colors.black,
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.all(8.0),
                                  //                 child: Text(
                                  //                   _postsList[index]["comment"],
                                  //                   style: GoogleFonts.rancho(
                                  //                     fontSize: 20,
                                  //                     color: Colors.black,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   }
                                  // ),
                                ],
                              ),
                              Divider(height: 5, color: Colors.grey),
                              Padding(
                                padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: AssetImage(
                                        'assets/7.jpg',
                                      ),
                                    ),
                                    SizedBox(width: 7),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.70,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[50],
                                        borderRadius: BorderRadius.circular(25)
                                      ),
                                      child: TextFormField(
                                        controller: _comment,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                                          hintText: 'What\'s on your mind?',
                                          hintStyle: GoogleFonts.firaSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50),
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        postComment(_postsList[index]["id"], _comment.text);
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.send, 
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
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
        ],
      ),
    );
  }
}