import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllCategories extends StatefulWidget {
  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List menuList = [
    _MenuItem(Icons.verified_user, 'Doctors'),
    _MenuItem(Icons.autorenew, 'Consultation'),
    _MenuItem(Icons.ac_unit, 'Teachers'),
    _MenuItem(Icons.center_focus_strong, 'Lawyers'),
    _MenuItem(Icons.question_answer, 'Astrologies'),
    _MenuItem(Icons.phone, 'Actors'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultants Types'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, position) {
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Column(
                        children: [
                          Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0,
                                              0.57), //shadow for button
                                          blurRadius: 5) //blur radius of shadow
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    menuList[position].icon,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                menuList[position].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                            ),
                          )
                        ],
                      ),
                    )));
          },
          itemCount: menuList.length,
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;

  _MenuItem(this.icon, this.title);
}
