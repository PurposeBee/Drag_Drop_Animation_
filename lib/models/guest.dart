class Guest {
  final String name;
  int? index;
  final bool updateable;

  Guest({required this.name, this.index, this.updateable = false});
}

class Person extends Guest {
  Pets? pets;
  final String phone;

  Person(
      {required super.name,
      required this.phone,
      this.pets,
      super.index,
      super.updateable});
}

class Pets extends Guest {
  final Person owner;
  final List<Pet> pets;

  Pets(
      {super.name = '',
      super.index,
      super.updateable,
      required this.owner,
      this.pets = const []});
}

class Pet {
  final String name;
  final String type;
  final String breed;

  Pet({required this.name, required this.type, required this.breed});
}
