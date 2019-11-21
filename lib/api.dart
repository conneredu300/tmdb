import 'dart:async';
import 'package:tmdb/models/movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class API {

  static const API_KEY = 'c5850ed73901b8d268d0898a8a9d8bff';
  static const API_URL =  "https://api.themoviedb.org/3/";
  var urlQuery = "https://api.themoviedb.org/3/search/movie?api_key=$API_KEY";

  Future<List<Movie>> get(String query, int page) async{

    List<Movie> list = [];

    await http.get("$urlQuery&query=$query&page=$page")
        .then( (res){

      Map result = json.decode(res.body);

      if(result.containsKey('results') && result['results'].length > 0)
        (result['results']).forEach( (movie) => list.add(Movie.fromJSON(movie)) );
    }).catchError( (print));

    return list;
  }



  Future<List<String>> listImages(int idMovie) async{

    var url = "${API_URL}movie/$idMovie/images?api_key=$API_KEY";

    return await http.get(url).then( (res){
      Map map = json.decode(res.body);

      if(map.containsKey('backdrops')){
        return map['backdrops'].map( (entrada)=> entrada['file_path']).toList().cast<String>();
      }else{
        return [];
      }
    });

  }



}