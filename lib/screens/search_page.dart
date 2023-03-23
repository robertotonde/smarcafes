import 'package:smartcafes/models/product_model.dart';
import 'package:smartcafes/provider/product_categories.dart';
import 'package:smartcafes/screens/product_description.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:same_type_streams_builder/same_type_streams_builder.dart';

class MySearchPage extends StatefulWidget {
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  String keyword = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final categoryListProvider =
        Provider.of<CategoryListFirestoreModel>(context);
    final appliances =
        categoryListProvider.fetchSearchedApplianccesCategory(keyword);
    final food = categoryListProvider.fetchSearchedFoodCategory(keyword);
    final drinks = categoryListProvider.fetchSearchedDrinksCategory(keyword);
    final offers = categoryListProvider.fetchSearchedOfferCategory(keyword);
    final stationery =
        categoryListProvider.fetchSearchedStaioneryCategory(keyword);

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: white.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                keyword = val;
              });
            },
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 17, right: 10, left: 10),
        child: SameTypeStreamsBuilder<QuerySnapshot>(
            streams: [
              appliances,
              food,
              drinks,
              offers,
              stationery,
            ],
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    if (snapshot[index].hasData) {
                      if (snapshot[index].data != null) {
                        final searchResult = snapshot[index].data?.docs;
                        final nn = searchResult!
                            .map((product) => ProductModel.fromMap(
                                product.data() as Map<String, dynamic>))
                            .toList();
                        List<ProductModel> docSnapshot = [];
                        for (var item in nn) {
                          docSnapshot.add(item);
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot[index].data?.docs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProductDescription(
                                            productImage:
                                                docSnapshot[index].productImage,
                                            productName:
                                                docSnapshot[index].productName,
                                            productPrice:
                                                docSnapshot[index].productPrice,
                                            productDescription:
                                                docSnapshot[index]
                                                    .productDescription,
                                            estimatedDelivery:
                                                docSnapshot[index]
                                                    .estimatedDelivery,
                                          )));
                                },
                                child: Card(
                                  child: Row(
                                    children: <Widget>[
                                      Image.network(
                                        docSnapshot[index].productImage,
                                        width: size.width * 0.19,
                                        height: size.height * 0.1,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.05,
                                      ),
                                      Text(
                                        docSnapshot[index].productName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  });
            }),
      ),
    );
  }
}
