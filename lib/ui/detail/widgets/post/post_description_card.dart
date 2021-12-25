import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:readmore/readmore.dart';

class PostDescriptionCard extends StatefulWidget {
  PostModel post;

  PostDescriptionCard({this.post});

  @override
  State<PostDescriptionCard> createState() => _PostDescriptionCardState();
}

class _PostDescriptionCardState extends State<PostDescriptionCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Expanded(
      flex: 5,
      // fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ReadMoreText(
                    widget.post.postDescription,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    trimLines: 4,
                    colorClickableText: Colors.black,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Daha fazla detay',
                    trimExpandedText: 'Küçült',
                    lessStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    moreStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
            ),
            if (widget.post.postCategories.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14.0, left: 14.0, right: 14),
                    child: Text("Kategoriler",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                  ),
                  MultiSelectChipDisplay(
                    onTap: (context) {
                      openCategoriesDialog();
                    },
                    chipColor: Colors.grey[200],
                    textStyle: TextStyle(color: Colors.black),
                    items: buildCategoryChips(),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  buildCategoryChips() {
    List<MultiSelectItem> items = widget.post.postCategories.take(3).map((e) {
      return MultiSelectItem(e, e);
    }).toList();

    if (widget.post.postCategories.length > 3) {
      items.add(MultiSelectItem<String>(
          "+${widget.post.postCategories.length - 3}",
          "+${widget.post.postCategories.length - 3} Kategori"));
    }

    return items;
  }

  openCategoriesDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: MultiSelectChipDisplay(
                        chipColor: Colors.grey[200],
                        textStyle: TextStyle(color: Colors.black),
                        items: widget.post.postCategories
                            .map((e) => MultiSelectItem<String>(e, e))
                            .toList()),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
