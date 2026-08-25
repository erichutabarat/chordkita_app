/// A single piece of a lyric line: an optional chord that sits above
/// the start of [text], followed by the lyric text itself.
///
/// Example: the line "[C]Amazing [G]grace" becomes:
///   ChordSegment(chord: 'C', text: 'Amazing ')
///   ChordSegment(chord: 'G', text: 'grace')
class ChordSegment {
  final String? chord;
  final String text;
  const ChordSegment({this.chord, required this.text});
}

/// The role a parsed line plays when rendering.
///
/// - [lyric]: a normal lyric line, possibly with chords above it.
/// - [section]: a structural note like "INTRO", "Reff 1", "Music:", "*)".
///   Still carries chord segments (e.g. "Intro: [C] [F] [G]") but should
///   be rendered with distinct styling, not as a lyric.
/// - [blank]: an empty spacer line, rendered as vertical whitespace only.
enum ChordLineType { lyric, section, blank }

/// A fully parsed line: its [type] plus the chord/lyric segments that
/// make it up. For [ChordLineType.blank], [segments] holds a single
/// empty segment and is not meant to be rendered as text.
class ChordLine {
  final ChordLineType type;
  final List<ChordSegment> segments;
  const ChordLine({required this.type, required this.segments});
}

final RegExp _chordTagRegex = RegExp(r'\[([^\]]+)\]');

/// Matches common section/annotation markers used in chord sheets, e.g.
/// "INTRO", "Intro:", "Reff 1", "Reff 2:", "Verse", "Chorus", "Bridge",
/// "Interlude", "Outro", "Coda", "Music:", and "*)".
///
/// Matched against the line with chord tags already stripped out, so
/// "Intro: [C] [F] [G]" is still recognized via its "Intro:" text.
final RegExp _sectionLineRegex = RegExp(
  r'^(intro|outro|interlude|coda|bridge|verse\s*\d*|chorus\s*\d*|reff\s*\d*|music\s*:|\*\))',
  caseSensitive: false,
);

/// Parses raw chord content (e.g. "[C]Amazing [G]grace\n[Am]How sweet")
/// into a list of [ChordLine]s, each carrying its [ChordLineType] and
/// chord/lyric segments.
///
/// Call this ONCE when the chord data loads. Do not re-parse on every
/// transpose - transpose only changes the `chord` value at render time.
List<ChordLine> parseChordContent(String content) {
  final rawLines = content.split('\n');
  return rawLines.map(_parseLine).toList();
}

ChordLine _parseLine(String line) {
  // Truly empty (or whitespace-only) lines are just spacers.
  if (line.trim().isEmpty) {
    return ChordLine(
      type: ChordLineType.blank,
      segments: [ChordSegment(chord: null, text: line)],
    );
  }

  final segments = _parseSegments(line);

  // Classify based on the lyric text with chord tags stripped out, so
  // e.g. "Intro: [C] [F] [G]" is still recognized as a section line.
  final plainText = line.replaceAll(_chordTagRegex, '').trim();
  final isSection =
      plainText.isNotEmpty && _sectionLineRegex.hasMatch(plainText);

  return ChordLine(
    type: isSection ? ChordLineType.section : ChordLineType.lyric,
    segments: segments,
  );
}

List<ChordSegment> _parseSegments(String line) {
  final matches = _chordTagRegex.allMatches(line).toList();

  // Plain lyric line with no chords at all (still needs to render).
  if (matches.isEmpty) {
    return [ChordSegment(chord: null, text: line)];
  }

  final segments = <ChordSegment>[];

  // Handle any lyric text that appears BEFORE the first chord tag.
  if (matches.first.start > 0) {
    segments.add(
      ChordSegment(chord: null, text: line.substring(0, matches.first.start)),
    );
  }

  for (var i = 0; i < matches.length; i++) {
    final chord = matches[i].group(1)!;
    final textStart = matches[i].end;
    final textEnd = (i + 1 < matches.length)
        ? matches[i + 1].start
        : line.length;
    segments.add(
      ChordSegment(chord: chord, text: line.substring(textStart, textEnd)),
    );
  }

  return segments;
}

// --- Transpose ---

const List<String> _sharpScale = [
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'A#',
  'B',
];

const List<String> _flatScale = [
  'C',
  'Db',
  'D',
  'Eb',
  'E',
  'F',
  'Gb',
  'G',
  'Ab',
  'A',
  'Bb',
  'B',
];

final RegExp _rootNoteRegex = RegExp(r'^([A-G])(#|b)?(.*)$');

/// Shifts a chord (e.g. "C", "Am7", "G#sus4") by [semitones].
/// Only the root note moves - the suffix (m, 7, sus4, etc.) is preserved as-is.
String transposeChord(String chord, int semitones) {
  if (semitones == 0) return chord;
  final match = _rootNoteRegex.firstMatch(chord);
  if (match == null) return chord; // not a recognizable chord, leave untouched
  final root = match.group(1)! + (match.group(2) ?? '');
  final suffix = match.group(3) ?? '';
  var index = _sharpScale.indexOf(root);
  if (index == -1) index = _flatScale.indexOf(root);
  if (index == -1) return chord;
  final newIndex =
      ((index + semitones) % 12 + 12) % 12; // safe for negative semitones
  return _sharpScale[newIndex] + suffix;
}
