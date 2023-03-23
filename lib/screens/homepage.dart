import 'package:cached_network_image/cached_network_image.dart';
import 'package:smartcafes/screens/categories/popular_offers.dart';
import 'package:smartcafes/screens/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcafes/models/product_model.dart';

import 'package:smartcafes/provider/product_categories.dart';
import 'package:smartcafes/screens/categories/popular_appliances.dart';
import 'package:smartcafes/screens/categories/popular_drinks.dart';
import 'package:smartcafes/screens/categories/popular_foods.dart';
import 'package:smartcafes/screens/product_description.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:smartcafes/widgets/list_cart_widget.dart';
import 'package:smartcafes/widgets/list_categories_widget.dart';
import 'package:smartcafes/widgets/list_orders_widget.dart';
import 'package:smartcafes/widgets/my_account_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:new_version/new_version.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  final String? name;
  const MyHomePage({
    Key? key,
    this.name,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;
  final _pageController = PageController();
  var formatter = NumberFormat();
  @override
  void initState() {
    super.initState();

    _checkVersion();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.dev.gen.smartcafes",
    );

    advancedStatusCheck(NewVersion newVersion) async {
      final status = await newVersion.getVersionStatus();

      if (status != null) {
        if (status.canUpdate == true) {
          newVersion.showUpdateDialog(
            context: context,
            dismissButtonText: "Close app",
            dismissAction: () {
              SystemNavigator.pop();
            },
            versionStatus: status,
            dialogTitle: 'New Update 😋',
            dialogText:
                'Hey, we just rolled out a new update that has bug fixes and new features for you. Sorry, you need to update so as you can use the app. Its less than 2MB but worth it 😍',
          );
        }
      }
    }

    advancedStatusCheck(newVersion);
  }

  @override
  Widget build(BuildContext context) {
    // String userName = context.read<AuthenticationService>().getCurrentUname();
    // String userProfile = Provider.of<AuthenticationService>(context).getDP();

    final size = MediaQuery.of(context).size;
    final categoryListProvider =
        Provider.of<CategoryListFirestoreModel>(context);

    return Scaffold(
      bottomNavigationBar: BottomBar(
        itemPadding: EdgeInsets.symmetric(
            vertical: size.height * 0.005, horizontal: size.width * 0.02),
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        backgroundColor: white.withOpacity(0.2),
        items: <BottomBarItem>[
          BottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: const Color(0xff2ec2f0),
            inactiveColor: white.withOpacity(0.6),
          ),
          BottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text('Search'),
            activeColor: const Color(0xff2ec2f0),
            inactiveColor: white.withOpacity(0.6),
          ),
          BottomBarItem(
            icon: const Icon(Icons.category_rounded),
            title: const Text('Categories'),
            activeColor: const Color(0xff2ec2f0),
            inactiveColor: white.withOpacity(0.6),
          ),
          BottomBarItem(
            icon: const Icon(Icons.shopping_basket_rounded),
            title: const Text('Cart'),
            activeColor: const Color(0xff2ec2f0),
            inactiveColor: white.withOpacity(0.6),
          ),
          BottomBarItem(
            icon: const Icon(FontAwesomeIcons.handHoldingUsd),
            title: const Text('My Orders'),
            activeColor: const Color(0xff2ec2f0),
            inactiveColor: white.withOpacity(0.6),
          ),
          BottomBarItem(
            icon: const Icon(Icons.account_circle_rounded),
            title: const Text('My Account'),
            activeColor: const Color(0xff2ec2f0),
            inactiveColor: white.withOpacity(0.6),
          ),
        ],
      ),
      backgroundColor: backColor,
      body: PageView(
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          controller: _pageController,
          children: [
            homepageMethod(size, "", context, categoryListProvider),
            MySearchPage(),
            const ListCategoriesWidget(),
            const MyListCartWidget(),
            ListOrdersWidget(),
            const MyAccountWidget()
          ]),
    );
  }

  SafeArea homepageMethod(Size size, String userName, BuildContext context,
      CategoryListFirestoreModel categoryListProvider) {
    return SafeArea(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MySearchPage()));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 2, top: 15),
                  width: size.width * 0.75,
                  height: size.height * 0.1,
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "Search here.....",
                      hintStyle: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(65),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 2, top: 15),
            child: Text(
              "Hello 😍",
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: grey6,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 2, top: 15),
            child: RichText(
              text: TextSpan(
                text: ' ',
                children: [
                  TextSpan(
                      text: 'Welcome to ',
                      style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: whiteopacity)),
                  TextSpan(
                      text: 'smartcafes',
                      style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: grey6)),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 20, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trending Offers",
                  style: GoogleFonts.ubuntu(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: grey6,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PopularOffers()));
                  },
                  child: Text(
                    "See All",
                    style: GoogleFonts.ubuntu(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: grey5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.3,
            child: StreamBuilder<QuerySnapshot>(
                stream: categoryListProvider.fetchPopularOffersCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final popularProduct = snapshot.data!.docs
                        .map((product) => ProductModel.fromMap(
                            product.data() as Map<String, dynamic>))
                        .toList();
                    if (snapshot.data!.size == 0) {
                      return const Center(child: Text("Sorry No Product"));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final docSnapshot = popularProduct[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDescription(
                                      productImage: docSnapshot.productImage,
                                      productName: docSnapshot.productName,
                                      productPrice: docSnapshot.productPrice,
                                      productDescription:
                                          docSnapshot.productDescription,
                                      estimatedDelivery:
                                          docSnapshot.estimatedDelivery,
                                    )));
                          },
                          child: Container(
                            height: size.height * 0.30,
                            decoration: BoxDecoration(
                              color: const Color(0xff1d273d),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.only(
                                left: 15, right: 2, top: 15),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: size.height / 6,
                                  width: size.width,
                                  child: CachedNetworkImage(
                                    imageUrl: docSnapshot.productImage,
                                    fadeInCurve: Curves.easeIn,
                                    fadeInDuration:
                                        const Duration(milliseconds: 250),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: size.height * 0.175,
                                  left: size.width * 0.01,
                                  child: Text(
                                    docSnapshot.productName,
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: size.height * 0.22,
                                  left: size.width * 0.01,
                                  child: Text(
                                    "${formatter.format(docSnapshot.productPrice)} Tsh",
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff2ec2f0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 20, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Foods",
                  style: GoogleFonts.ubuntu(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: grey6,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PopularFood()));
                  },
                  child: Text(
                    "See All",
                    style: GoogleFonts.ubuntu(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: grey5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.3,
            child: StreamBuilder<QuerySnapshot>(
                stream: categoryListProvider.fetchPopularFoodCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final popularProduct = snapshot.data!.docs
                        .map((product) => ProductModel.fromMap(
                            product.data() as Map<String, dynamic>))
                        .toList();
                    if (snapshot.data!.size == 0) {
                      return const Center(child: Text("Sorry No Product"));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final docSnapshot = popularProduct[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDescription(
                                      productImage: docSnapshot.productImage,
                                      productName: docSnapshot.productName,
                                      productPrice: docSnapshot.productPrice,
                                      productDescription:
                                          docSnapshot.productDescription,
                                      estimatedDelivery:
                                          docSnapshot.estimatedDelivery,
                                    )));
                          },
                          child: tourMethod(
                            size,
                            docSnapshot.productImage,
                            docSnapshot.productName,
                            docSnapshot.productPrice,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 20, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Drinks",
                  style: GoogleFonts.ubuntu(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: grey6,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PopularDrinks()));
                  },
                  child: Text(
                    "See All",
                    style: GoogleFonts.ubuntu(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: grey5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.3,
            child: StreamBuilder<QuerySnapshot>(
                stream: categoryListProvider.fetchPopularDrinksCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final popularProduct = snapshot.data!.docs
                        .map((product) => ProductModel.fromMap(
                            product.data() as Map<String, dynamic>))
                        .toList();
                    if (snapshot.data!.size == 0) {
                      return const Center(child: Text("Sorry No Product"));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final docSnapshot = popularProduct[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDescription(
                                      productImage: docSnapshot.productImage,
                                      productName: docSnapshot.productName,
                                      productPrice: docSnapshot.productPrice,
                                      productDescription:
                                          docSnapshot.productDescription,
                                      estimatedDelivery:
                                          docSnapshot.estimatedDelivery,
                                    )));
                          },
                          child: tourMethod(
                            size,
                            docSnapshot.productImage,
                            docSnapshot.productName,
                            docSnapshot.productPrice,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      )),
    );
  }

  Container tourMethod(Size size, String image, String name, int price) {
    return Container(
      width: size.width * 0.30,
      height: size.height * 0.30,
      decoration: BoxDecoration(
        color: const Color(0xff1d273d),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(left: 15, right: 2, top: 15),
      child: Stack(
        children: [
          SizedBox(
            height: size.height / 6,
            width: size.width,
            child: CachedNetworkImage(
              imageUrl: image,
              fadeInCurve: Curves.easeIn,
              fadeInDuration: const Duration(milliseconds: 250),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: size.height * 0.175,
            left: size.width * 0.01,
            child: Text(
              name,
              style: GoogleFonts.ubuntu(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: white,
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.22,
            left: size.width * 0.01,
            child: Text(
              "${formatter.format(price)} Tsh",
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xff2ec2f0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
