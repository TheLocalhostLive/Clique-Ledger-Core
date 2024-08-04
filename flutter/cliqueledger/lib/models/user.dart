class User{
  final String name;
  final String id;
  final String phone;
  final String email;

  User({
    required this.name,
    required this.id,
    required this.phone,
    required this.email
  });

  factory User.fromJson(Map<String,dynamic> json){
    return User(    
      name: json['name'] ,
      id: json['id'] ,
      phone: json['phone'] ,
      email: json['email']
      );
  }

}