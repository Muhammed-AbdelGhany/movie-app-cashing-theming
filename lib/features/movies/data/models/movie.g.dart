// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieImpl _$$MovieImplFromJson(Map<String, dynamic> json) => _$MovieImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] as String,
      genreIds: (json['genre_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      popularity: (json['popularity'] as num).toDouble(),
      adult: json['adult'] as bool,
      originalLanguage: json['original_language'] as String,
      originalTitle: json['original_title'] as String,
      video: json['video'] as bool,
      voteCount: (json['vote_count'] as num).toInt(),
    );

Map<String, dynamic> _$$MovieImplToJson(_$MovieImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'overview': instance.overview,
      'vote_average': instance.voteAverage,
      'release_date': instance.releaseDate,
      'genre_ids': instance.genreIds,
      'popularity': instance.popularity,
      'adult': instance.adult,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'video': instance.video,
      'vote_count': instance.voteCount,
    };

_$MoviesResponseImpl _$$MoviesResponseImplFromJson(Map<String, dynamic> json) =>
    _$MoviesResponseImpl(
      page: (json['page'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$$MoviesResponseImplToJson(
        _$MoviesResponseImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
