class CliquePostSchema{
  final String name;
  final List<String> members;
  final String? fund;
  final bool? isActive;
  CliquePostSchema({
    required this.name,
    required this.members,
    this.fund,
    required this.isActive
  });
}