import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';
import 'package:flutter/material.dart';

class ChordListComponent extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final List<ChordSongItemData> items;

  const ChordListComponent({
    super.key,
    required this.title,
    this.onSeeAllPressed,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header (Title & See All)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onSeeAllPressed != null)
                TextButton(
                  onPressed: onSeeAllPressed,
                  child: const Text('See All'),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Horizontal Scrollable Cards List
        SizedBox(
          height: 130, // Adjusted height to accommodate genre tags
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 210, // Wider card to fit song & artist neatly
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                    0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top Row: Song Name & Chord Key Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.songName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Chord Key Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.chordKey,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Artist Name
                          Text(
                            item.artistName,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Genre List (Chips)
                          SizedBox(
                            height: 22,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics:
                                  const NeverScrollableScrollPhysics(), // Keeps layout clean inside card
                              children: item.genres.map((genre) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    genre,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
