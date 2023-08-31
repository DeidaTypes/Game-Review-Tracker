import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final ValueChanged<int> onRatingChanged;

  const StarRating({super.key, required this.onRatingChanged});

  @override
  // ignore: library_private_types_in_public_api
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
          ),
          onPressed: () {
            setState(() {
              currentRating = index + 1;
              widget.onRatingChanged(currentRating);
            });
          },
          color: Colors.amber,
          iconSize: 30.0,
        );
      }),
    );
  }
}
