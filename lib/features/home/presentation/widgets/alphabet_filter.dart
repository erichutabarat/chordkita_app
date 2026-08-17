import 'package:flutter/material.dart';

class AlphabetFilterBar extends StatelessWidget {
  final String selectedCharacter;
  final ValueChanged<String> onSelected;

  const AlphabetFilterBar({
    super.key,
    required this.selectedCharacter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Generate characters: 'All', '0-9', then 'A' to 'Z'
    final List<String> characters = [
      'All',
      '0-9',
      ...List.generate(26, (index) => String.fromCharCode(65 + index)),
    ];

    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final char = characters[index];
          final isSelected = selectedCharacter == char;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(char),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(char);
                }
              },
              selectedColor: Colors.amber,
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withOpacity(0.5),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : theme.colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected
                      ? Colors.amber
                      : theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}
