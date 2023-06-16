import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/constants/CustomColors.dart';
import 'package:timetalk/models/professonal_type_model.dart';
import 'package:timetalk/screens/all_categories.dart';
import 'package:timetalk/screens/consultants_list_screen.dart';
import 'package:timetalk/services/feature_service.dart';

class CategoryType extends StatefulWidget {
  const CategoryType({super.key});

  @override
  State<CategoryType> createState() => _CategoryTypeState();
}

class _CategoryTypeState extends State<CategoryType> {
  FeaturelService featurelService = FeaturelService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            children: [
              FutureBuilder<List<ProfessionalType>>(
                future: featurelService.getAllProfessionalType(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      ConnectionState.done == snapshot.connectionState) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: snapshot.data!.map((professionalType) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ConsultantsList(
                                        typeid: professionalType.id,
                                        fetchalltype: false,
                                      )));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: CustomColors.whitebg,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: CustomColors.shadowbg,
                                              blurRadius:
                                                  5) //blur radius of shadow
                                        ]),
                                    child: Image.network(
                                      "${ApiConstants.clouddomain}/image/typeimages/${professionalType.imagepath}",
                                      color: CustomColors.googleBackground,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${professionalType.name}",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 91, 92, 92)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConsultantsList(
                              typeid: 0,
                              fetchalltype: true,
                            )));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              color: CustomColors.whitebg,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: CustomColors.shadowbg,
                                    blurRadius: 5) //blur radius of shadow
                              ]),
                          child: Icon(
                            Icons.all_inbox,
                            color: CustomColors.googleBackground,
                          ),
                        ),
                      ),
                      Text(
                        "All",
                        style:
                            TextStyle(color: Color.fromARGB(255, 91, 92, 92)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
