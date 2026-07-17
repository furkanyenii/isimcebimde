import 'package:flutter/material.dart';
import 'package:isimcebimde/core/constants/app_paging.dart';
import 'package:isimcebimde/core/utils/pagination.dart';
import 'package:isimcebimde/core/widgets/app_pagination_bar.dart';

/// Bir listeyi [pageSize]'lık sayfalara böler ve altına numaralı sayfalama
/// çubuğu ([AppPaginationBar]) ekler. Kayıt sayısı [pageSize]'ı aşmazsa çubuk
/// hiç görünmez; liste tek sayfa gibi davranır.
///
/// Sayfa dilimini nasıl çizeceğine karışmaz: [pageBuilder]'a o sayfanın
/// kayıtlarını verir, kaydırılabilir içeriği (ör. `ListView`) çağıran taraf
/// kurar. Böylece düz listeler de, kategoriye göre gruplu ürün listesi de aynı
/// bileşeni kullanır (CLAUDE.md: kod tekrarından kaçın).
///
/// Sayfa indeksi tamamen bu widget'a ait geçici UI state'idir; iş state'i
/// değildir, bu yüzden `setState` ile tutulur. Liste küçülüp geçerli sayfa
/// aralık dışına düşerse son sayfaya sıkıştırılır.
class AppPaginatedListView<T> extends StatefulWidget {
  const AppPaginatedListView({
    required this.items,
    required this.pageBuilder,
    this.pageSize = AppPaging.pageSize,
    super.key,
  });

  final List<T> items;
  final int pageSize;

  /// Geçerli sayfanın kayıtlarını alıp kaydırılabilir içeriği üretir.
  final Widget Function(BuildContext context, List<T> pageItems) pageBuilder;

  @override
  State<AppPaginatedListView<T>> createState() =>
      _AppPaginatedListViewState<T>();
}

class _AppPaginatedListViewState<T> extends State<AppPaginatedListView<T>> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final pageCount = pageCountFor(widget.items.length, widget.pageSize);
    // Liste değişmiş ve geçerli sayfa artık yoksa son sayfaya sıkıştır.
    final page = _page.clamp(0, pageCount - 1);
    _page = page;

    final pageItems = pageSlice(widget.items, page, widget.pageSize);

    return Column(
      children: [
        Expanded(child: widget.pageBuilder(context, pageItems)),
        if (pageCount > 1)
          AppPaginationBar(
            currentPage: page,
            pageCount: pageCount,
            onSelected: (next) => setState(() => _page = next),
          ),
      ],
    );
  }
}
