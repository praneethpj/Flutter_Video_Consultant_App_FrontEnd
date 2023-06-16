import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/screens/profile_screen.dart';

import '../../constants/CustomColors.dart';
import '../common_widget/custom_stext.dart';

class CustomProfileCard extends StatelessWidget {
  final int profileId;
  final double costPerHour;
  final String profileImageUrl;
  final String profileName;
  final double rating;
  final bool homepage;
  final String professionalType;

  CustomProfileCard(
      {required this.profileId,
      required this.costPerHour,
      required this.profileImageUrl,
      required this.profileName,
      required this.rating,
      required this.homepage,
      required this.professionalType});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileScreen(
            profileId: profileId,
            costperhour: costPerHour,
          ),
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: CustomColors.whitebg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: CustomColors.shadowbg,
                blurRadius: 5,
              ),
            ],
          ),
          child: Flexible(
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: homepage
                          ? Image.network(
                              profileImageUrl,
                              height: 140,
                              width: 200,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                    ),
                    homepage
                        ? CustomTextWidgetTitle(
                            text: professionalType,
                            size: 17,
                          )
                        : CustomTextWidgetTitle(
                            text: professionalType,
                            size: 16,
                          ),
                  ],
                ),
                homepage
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          profileName,
                          style: GoogleFonts.lato(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              profileName,
                              style: GoogleFonts.lato(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                homepage
                    ? RatingBar.builder(
                        maxRating: 3,
                        initialRating: rating,
                        itemCount: 3,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemBuilder: (context, _) => SizedBox(
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        onRatingUpdate: (rating) {},
                      )
                    : Expanded(
                        child: RatingBar.builder(
                          maxRating: 3,
                          initialRating: rating,
                          itemCount: 3,
                          direction: Axis.horizontal,
                          itemBuilder: (context, _) => SizedBox(
                            child: Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
