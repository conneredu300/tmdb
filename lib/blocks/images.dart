import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:tmdb/api.dart';

class ImagesBloc
{
  API _api = API();

  final _imagesController = BehaviorSubject<List<String>>();

  final _idController = BehaviorSubject<int>();

  ImagesBloc(){

    _idController.stream.listen( (id){

      loadData(id);

    });

  }

  Stream<List<String>> get imagesStream => _imagesController.stream;

  void setMovieId(int id){
    _idController.sink.add(id);
  }

  Future<void> loadData(id) async {

    try {
      _imagesController.sink.add(null);
      List<String> result = await _api.listImages(id);

      if(result != null && result.length > 0){

        result = result.map( (url)=>'https://image.tmdb.org/t/p/w200$url').toList();
        _imagesController.sink.add(result);
      }else{
        _imagesController.sink.addError('no results');
      }
    }catch (error){
      _imagesController.sink.addError('error $error');

    }
  }

  void close(){

    _imagesController.close();
    _idController.close();


  }
}