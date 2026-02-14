import 'package:flutter/material.dart';
import '../providers/user_provider.dart';

class SortMenuBottomSheet extends StatelessWidget {
  final UserProvider provider;

  const SortMenuBottomSheet({super.key, required this.provider});

  static void show(BuildContext context, UserProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => SortMenuBottomSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Sort Users",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),

          _tile(context, "All Users", UserSortType.all),
          _tile(context, "Age: Older (60+)", UserSortType.older),
          _tile(context, "Age: Younger (Below 60)", UserSortType.younger),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String title, UserSortType type) {
    return RadioListTile<UserSortType>(
      value: type,
      groupValue: provider.selectedSort,
      title: Text(title),
      activeColor: Colors.blue,
      contentPadding: EdgeInsets.zero,
      onChanged: (value) {
        provider.selectSort(value!);
        Navigator.pop(context);
      },
    );
  }
}
