import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({super.key});

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 3, // Spread radius
            blurRadius: 3, // Blur radius
          ),
        ],
        // border: Border.all(
        //     color: Colors.greenAccent, width: 2), // Border color and width
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              height: 100,
              width: 150,
              fit: BoxFit.cover,
              imageUrl:
                  "https://w0.peakpx.com/wallpaper/908/670/HD-wallpaper-dhoni-sports-uniform-cricket-ms-dhoni-mahendra-singh-dhoni-thumbnail.jpg",
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "titlehfilrewhiluhreilguilrgviureivhiorehviorehvioeh",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "descriptionefhuirefvhreihvioreiovheohvodhfvh dhoc",
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "categoryfbjrefknrekgnvkreeikelkrnbvlkresklvnlkrfonfdelv",
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "pricejbfreuilfheilhfoirehgo;reo;gvho;eirhvoi;erajv",
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    // color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

  }
}