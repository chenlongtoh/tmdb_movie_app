import 'package:flutter/material.dart';
import 'package:movie_app/shared_widgets/ui_lib/spacer.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef FetchCallback<T> = Future<List<T>> Function();

class PagingScrollingList<T> extends StatefulWidget {
  final List<T> initialItem;
  final Axis scrollDirection;
  final ItemBuilder<T> itemBuilder;
  final FetchCallback<T> fetchCallback;
  final EdgeInsetsGeometry padding;

  const PagingScrollingList({
    super.key,
    this.scrollDirection = Axis.vertical,
    required this.initialItem,
    required this.itemBuilder,
    required this.fetchCallback,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  @override
  State<PagingScrollingList<T>> createState() => _PagingScrollingListState<T>();
}

class _PagingScrollingListState<T> extends State<PagingScrollingList<T>> {
  final ScrollController scrollController = ScrollController();
  final List<T> _items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _items.addAll(widget.initialItem);
    scrollController.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 10 && !isLoading) {
      setState(() => isLoading = true);
      final List<T> fetchedItem = await widget.fetchCallback();
      setState(() {
        _items.addAll(fetchedItem);
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: widget.padding,
      addAutomaticKeepAlives: true,
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      scrollDirection: widget.scrollDirection,
      itemCount: isLoading ? _items.length + 1 : _items.length,
      separatorBuilder: (_, __) => widget.scrollDirection == Axis.horizontal ? horizontalSpacer15 : verticalSpacer10,
      itemBuilder: (context, index) {
        if (index < _items.length) return widget.itemBuilder(context, _items[index]);
        return const Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
