import 'package:flutter/material.dart';

class SearchTokenTile extends StatelessWidget {
  final String token;
  final bool isHistory;
  final VoidCallback onTap;

  const SearchTokenTile({
    super.key,
    required this.token,
    required this.onTap,
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      title: Text(token, maxLines: 1),
      leading: Icon(isHistory ? Icons.history : Icons.search),
    );
  }
}
