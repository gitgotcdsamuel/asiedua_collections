import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onCartPressed;
  final bool showTitle;
  final String? title;

  const CustomAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onSearchPressed,
    required this.onCartPressed,
    this.showTitle = false,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        onPressed: onMenuPressed,
        icon: const Icon(
          Iconsax.menu_1,
          color: Colors.black,
          size: 24,
        ),
      ),
      title: showTitle && title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : Center(
              child: SvgPicture.asset(
                'assets/asiedua.svg',
                height: 110,
              ),
            ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onSearchPressed,
          icon: const Icon(
            Iconsax.search_normal_1,
            color: Colors.black,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: onCartPressed,
          icon: Badge(
            label: const Text('3'),
            child: const Icon(
              Iconsax.bag_2,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}