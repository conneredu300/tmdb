import 'package:flutter/material.dart';
import 'package:tmdb/models/movie.dart';
import 'package:tmdb/screens/movie_bottom.dart';
import 'dart:async';
import 'package:tmdb/application_state_provider.dart';
import 'package:tmdb/blocks/images.dart';

class MovieDetailScreen extends StatelessWidget{

  final Movie movie;
  MovieDetailScreen(this.movie);

  @override
  Widget build( BuildContext context){

    ImagesBloc bloc = ApplicationStateProvider.of(context).imagesBloc;
    bloc.loadData(movie.id);

    var backgroundImg = movie.backdrop_path!=null?Image.network(movie.backdrop_path):Container();

    var closeButton = IconButton(
        icon: Icon(Icons.clear,color: Colors.white,),
        onPressed: ()=>Navigator.of(context).pop()
    );


    var year =  movie.release_date;
    if(year.isNotEmpty)  year = "(${movie.release_date.substring(0,4)})";

    var title = Text("${movie.title} $year",
      style: TextStyle(color: Colors.white, fontSize: 30.0),
    );

    var card = Card(child: new Padding(
      padding: const EdgeInsets.all(12.0),
      child: new Column(
        children: [
          new Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("${movie.vote_average}",style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold ),),
              movie.poster_path == null ? Icon(Icons.movie) : Image.network('https://image.tmdb.org/t/p/w92'+movie.poster_path),
            ],
          ),
          SizedBox(height: 10.0,),
          Text(movie.overview),
        ],
      ),
    ),);


    Future<Null> onrefresh() async{

      ImagesBloc bloc = ApplicationStateProvider.of(context).imagesBloc;
      await bloc.loadData(movie.id);
    }

    return new Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          backgroundImg,
          Opacity(opacity:0.5,child: Container(color: Theme.of(context).primaryColor, padding: const EdgeInsets.all(10.0))),


          new RefreshIndicator(
            onRefresh: onrefresh,
            child: new SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: new Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 150.0,10.0,8.0),
                child: Column(
                  children:[
                    title,
                    SizedBox(height: 10.0,),
                    card,
                    SizedBox(height: 10.0,),
                    new SizedBox(child: MovieDetailBottomScreen(movie.id), height: 100.0,),
                    SizedBox(height: 10.0,),
                  ],
                ),
              ),
            ),
          ),
          Positioned(child: closeButton ,top: 20.0,),

        ],
      ),

    );

  }


}