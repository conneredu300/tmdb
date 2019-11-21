import 'package:flutter/material.dart';
import 'package:tmdb/blocks/images.dart';
import 'package:tmdb/application_state_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieDetailBottomScreen extends StatelessWidget {
  final idMovie;

  MovieDetailBottomScreen(this.idMovie);

  @override
  Widget build(BuildContext context) {
    ImagesBloc bloc = ApplicationStateProvider.of(context).imagesBloc;

    Widget getImage(url){
      return CachedNetworkImage(
        imageUrl: url,
        height: 60.0,
      );
    }

    return StreamBuilder<List<String>>(
      stream: bloc.imagesStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data.map((url) => getImage(url)).toList());

        } else if (snapshot.hasError) {
          return new Center(child: Text('no images',style: TextStyle(color: Colors.brown[100]),));

        } else {
          return new Center(child: CircularProgressIndicator(),  );

        }
      },
    );
  }
}