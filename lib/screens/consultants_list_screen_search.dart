import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetalk/models/professional_model.dart';
import 'package:timetalk/screens/profile_screen.dart';

import '../constants/ApiConstants.dart';
import '../models/list_of_profile_model.dart';
import '../services/professional_service.dart';
import 'home_widget/custom_profile_card.dart';

class ConsultantsListSearch extends StatefulWidget {
  final String searchtext;
  ConsultantsListSearch({super.key, required this.searchtext});

  @override
  State<ConsultantsListSearch> createState() => _ConsultantsListSearchState();
}

class _ConsultantsListSearchState extends State<ConsultantsListSearch> {
  ProfessionalService professionalService = ProfessionalService();
  final _scrollController = ScrollController();
  int _currentPage = 1;
  int _totalPages = 1;
  List<ListProfessionalModel> _professionals = [];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_currentPage < _totalPages) {
        setState(() {
          _currentPage++;
        });
      }
    }
  }

  Future<List<ListProfessionalModel>> _getProfessionals(int page) async {
    final limit = 10; // number of items per page
    final offset = (page - 1) * limit;
    final professionals = await professionalService
        .getAllProfessionalBySearchText(widget.searchtext, limit, offset);
    _totalPages = (professionals.length / limit).ceil();
    if (page == 1) {
      _professionals = professionals;
    } else {
      _professionals.addAll(professionals);
    }
    return _professionals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search : ${widget.searchtext}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder<List<ListProfessionalModel>>(
          future: _getProfessionals(_currentPage),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      _scrollController.offset >=
                          _scrollController.position.maxScrollExtent) {
                    if (_currentPage < _totalPages) {
                      setState(() {
                        _currentPage++;
                      });
                      return true;
                    }
                  }
                  return false;
                },
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                  ),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index >= _professionals.length) {
                      // Return an empty container if the index is out of range
                      return Container();
                    }
                    return SizedBox(
                      width: 100,
                      height: 180,
                      child: CustomProfileCard(
                        homepage: false,
                        profileId: _professionals[index].userId,
                        costPerHour:
                            double.parse(_professionals[index].costperhour),
                        profileImageUrl:
                            "${ApiConstants.clouddomain}/image/${_professionals[index].profileImage}",
                        profileName:
                            "${_professionals[index].titleName}. ${_professionals[index].name}",
                        rating: _professionals[index].rating,
                        professionalType: _professionals[index].typeName,
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError &&
                ConnectionState.done == snapshot.connectionState) {
              return Text('Error retrieving data');
            } else {
              return CircularProgressIndicator();
            }
          },
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
