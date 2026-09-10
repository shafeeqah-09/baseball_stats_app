class Player{
  final String id;
  final String name;
  final String position;
  final double battingAverage;

  const Player({
    required this.id,
    required this.name;
    required this.position;
    required this.battingAverage
});
//   const - compile time constant never changes
//   final - runtime constant set once
//   Constructor which I already know makes an instance of a class
//   const Constructor new to me a constructor that produces compile time constant instances
//   in Flutter, mark widgets const whenever possible
//   const MyWidget({super.key}); boilerplate - copy when i see this i can create a compile time constant and constructor taking a key param

  @override
  String toString() =>'$name($position) - AVG: ${battingAverage.toStringAsFixed(3)}';


}
