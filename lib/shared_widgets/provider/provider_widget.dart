import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef Create<T> = T Function(BuildContext context);
typedef WidgetBuilder<T> = Widget Function(BuildContext buildContext, T _model, Widget? child);

class ProviderWidget<T extends ChangeNotifier?> extends StatelessWidget {
  final WidgetBuilder<T> builder;
  final Create<T>? create;
  final T? value;

  const ProviderWidget({
    Key? key,
    required this.create,
    required this.builder,
  })  : value = null,
        super(key: key);

  const ProviderWidget.value({
    Key? key,
    required this.value,
    required this.builder,
  })  : create = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (create != null) {
      return ChangeNotifierProvider<T>(
        create: (context) => create!(context),
        builder: (context, child) {
          return Consumer<T>(builder: builder);
        },
      );
    }
    return ChangeNotifierProvider<T?>.value(
      value: value,
      builder: (context, child) {
        return Consumer<T>(builder: builder);
      },
    );
  }
}
