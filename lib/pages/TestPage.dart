import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/empty_list.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {

  }

  List<String> _items = [];
  int i = 0;

  Future<Null> _onRefresh() async {

    i++;
    _items.add("${i}. Romina");
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _items.isEmpty
            ? EmptyList(
                body:
                    "No Farm.\n\nYou have no farms registered in our system. Please contact us to add your farm into the system.")
            :

            Text("Romina"),

       /* ListView(
          children: [
            Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text('Header 1'),
            ),
            ListView.builder( // inner ListView
              shrinkWrap: true, // 1st add
              physics: ClampingScrollPhysics(), // 2nd add
              itemCount: 2,
              itemBuilder: (_, index) => ListTile(title: Text('Item $index')),
            ), Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text('Header 1'),
            ),

            ListView.builder(
              shrinkWrap: true,

              itemBuilder: (context, position) {
                return Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 0.0, right: 16.0, bottom: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Text(_items[position]),
                    ));
              },
              itemCount: _items.length,
            ),

            ListView.builder( // inner ListView
              shrinkWrap: true, // 1st add
              physics: ClampingScrollPhysics(), // 2nd add
              itemCount: 2,
              itemBuilder: (_, index) => ListTile(title: Text('Item $index')),
            ),
          ],
        ),
*/

        /*ListView(
              children: [
                ListView.builder(
                    itemBuilder: (context, position) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 0.0, right: 16.0, bottom: 0.0),
                          child: Container(
                            margin: EdgeInsets.only(top: 16),
                            child: Text(_items[position]),
                          ));
                    },
                    itemCount: _items.length,
                  ),
              ],
            ),*/
      ),

      /* ListView(
        children: [
          Image.asset(
            "assets/project/slide_1.jpeg",
            height: 180,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_1.webp", title: "Tops"),
              singleGridItem(image: "circle_2.webp", title: "Bottom"),
              singleGridItem(image: "circle_3.webp", title: "Dresses"),
              singleGridItem(image: "circle_4.webp", title: "Outwear"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              singleGridItem(image: "circle_5.webp", title: "Shoes"),
              singleGridItem(image: "circle_6.webp", title: "Bags"),
              singleGridItem(image: "circle_7.webp", title: "Beauty"),
              singleGridItem(image: "circle_8.webp", title: "Home"),
            ],
          ),
        ],
      ),*/
    );
  }

  Widget singleGridItem({
    String image: "circle_1.webp",
    String title: "Tops",
  }) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset(
            "assets/project/${image}",
            height: 70,
            fit: BoxFit.cover,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
