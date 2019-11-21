import 'package:flutter/material.dart';
import 'package:tmdb/blocks/images.dart';
import 'package:tmdb/blocks/movies.dart';

class ApplicationStateProvider extends InheritedWidget{

  ImagesBloc _imagesBloc;
  MoviesBloc _moviesBloc;

  ApplicationStateProvider({Key key, Widget child})
      : super(key: key, child: child){

    _imagesBloc = ImagesBloc();
    _moviesBloc = MoviesBloc();

  }

  @override
  bool updateShouldNotify(_) => true;

  static ApplicationStateProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ApplicationStateProvider)
    as ApplicationStateProvider);
  }


  ImagesBloc get imagesBloc => _imagesBloc;
  MoviesBloc get moviesBloc => _moviesBloc;

}