import 'package:flutter/material.dart';

const _activeColor = Colors.white30;
const _inactiveColor = Colors.black45;
const _activeBorder = BorderSide.none;
const _inactiveBorder = BorderSide(color: Colors.white54);

class SelectionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const SelectionChip({
    super.key,
    required this.label,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 50, maxWidth: 100),
        padding: EdgeInsets.symmetric(horizontal: isActive ? 10 : 9, vertical: isActive ? 3 : 2),
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: isActive ? _activeBorder : _inactiveBorder,
          ),
          color: isActive ? _activeColor : _inactiveColor,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
