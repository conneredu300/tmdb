import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:tmdb/api.dart';
import 'package:tmdb/models/movie.dart';

class MoviesBloc
{
  API _api = API();

  final _moviesController = BehaviorSubject<List<Movie>>(seedValue: []);
  final _searchController = BehaviorSubject<String>(seedValue: '');
  final _loadingController = BehaviorSubject<bool>(seedValue: false);

  bool _endLoading = false;

  int _page = 0;

  Stream<List<Movie>> get moviesStream => _moviesController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  set subject(String subject) => _searchController.sink.add(subject);

  MoviesBloc(){

    _searchController.stream.listen( (subject){

      _moviesController.sink.add([]);
      _endLoading = false;
      _page = 0;

      loadMore();


    });
  }

  Future<Null> loadMore() async{

    String subject = _searchController.value;

    if(subject.length == 0)
      _moviesController.addError("no results");

    else
    if(!_loadingController.value  && !_endLoading ) {

      _loadingController.sink.add(true);

      _page++;


      var list = await _api.get(subject, _page);


      _loadingController.sink.add(false);

      if (list.isEmpty) {
        _endLoading = true;
        _moviesController.addError("no results");
      }


      if(subject.length >0) {

        List<Movie> movies = _moviesController.value;
        movies.addAll( list );
        _moviesController.sink.add(movies);
      }

    }

  }

  void dispose(){
    _moviesController.close();
    _searchController.close();
    _loadingController.close();
  }
}