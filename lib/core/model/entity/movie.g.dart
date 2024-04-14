// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 1;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      backdropPath: fields[0] as String?,
      genreIds: (fields[1] as List?)?.cast<int>(),
      id: fields[2] as int?,
      overview: fields[3] as String?,
      popularity: fields[4] as double?,
      posterPath: fields[5] as String?,
      releaseDate: fields[6] as String?,
      title: fields[7] as String?,
      video: fields[8] as bool?,
      voteAverage: fields[9] as double?,
      voteCount: fields[10] as int?,
    )
      ..trailers = (fields[11] as List?)?.cast<Video>()
      ..teasers = (fields[12] as List?)?.cast<Video>();
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.backdropPath)
      ..writeByte(1)
      ..write(obj.genreIds)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.popularity)
      ..writeByte(5)
      ..write(obj.posterPath)
      ..writeByte(6)
      ..write(obj.releaseDate)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.video)
      ..writeByte(9)
      ..write(obj.voteAverage)
      ..writeByte(10)
      ..write(obj.voteCount)
      ..writeByte(11)
      ..write(obj.trailers)
      ..writeByte(12)
      ..write(obj.teasers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
