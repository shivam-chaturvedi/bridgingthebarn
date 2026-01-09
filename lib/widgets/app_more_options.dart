import 'package:flutter/material.dart';

class MoreOption {
  const MoreOption({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

Future<void> showAppMoreOptions(
  BuildContext context,
  List<MoreOption> options,
) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF02121B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...options
                  .map(
                    (option) => _MoreOptionTile(option: option),
                  )
                  .toList(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}

class _MoreOptionTile extends StatelessWidget {
  const _MoreOptionTile({required this.option});

  final MoreOption option;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(option.icon, color: Colors.white70),
      title: Text(option.label, style: const TextStyle(color: Colors.white)),
      onTap: option.onTap,
    );
  }
}
