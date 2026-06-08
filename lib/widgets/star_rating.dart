import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final double rating;
  final double size;
  final bool interactive;
  final Function(double)? onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 24,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _current;

  @override
  void initState() {
    super.initState();
    _current = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < _current;
        final half = !filled && i < _current + 0.5;
        return GestureDetector(
          onTap: widget.interactive
              ? () {
                  setState(() => _current = i + 1.0);
                  widget.onRatingChanged?.call(_current);
                }
              : null,
          child: Icon(
            filled
                ? Icons.star_rounded
                : half
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            color: const Color(0xFFFFC107),
            size: widget.size,
          ),
        );
      }),
    );
  }
}