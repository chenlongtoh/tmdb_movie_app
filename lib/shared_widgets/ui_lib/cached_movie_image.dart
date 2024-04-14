import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/config/api_config.dart';

class CachedMovieImage extends StatelessWidget {
  final String _imageUrl;
  final double _aspectRatio;

  const CachedMovieImage.poster({required String imagePath, super.key})
      : _imageUrl = "${ApiConfig.posterBaseUrl}/$imagePath",
        _aspectRatio = 2 / 3;

  const CachedMovieImage.backdrop({required String imagePath, super.key})
      : _imageUrl = "${ApiConfig.backdropBaseUrl}/$imagePath",
        _aspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _imageUrl,
      placeholder: (_, __) => AspectRatio(
        aspectRatio: _aspectRatio,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => AspectRatio(
        aspectRatio: _aspectRatio,
        child: const Icon(Icons.error),
      ),
    );
  }
}
