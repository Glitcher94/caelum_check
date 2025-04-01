import 'package:flutter/material.dart';

class LocationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LocationButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isLoading ? null : onPressed,
      backgroundColor: Theme.of(context).primaryColor,
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.my_location),
    );
  }
}

