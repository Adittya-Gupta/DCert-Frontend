import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'box.dart';
import 'main.dart';
class ProfileOverview extends StatefulWidget {
  final Widget? image;
  const ProfileOverview({super.key, this.image});
  @override
  State<ProfileOverview> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Mybox(
            color: const Color(0xFF191d36),
            width: 125,
            height: 125,
            child: widget.image,
          ),
          const SizedBox(width: 25),
          Mybox(
            color: Theme.of(context).colorScheme.primary,
            width: 200,
            height: 125,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    Text(' ${data['givenName']}'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.numbers,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    Text(' ${data['surname']}'),
                  ],
                ),
              ],
            )

          ),
        ],
      ),
    );
  }
}
