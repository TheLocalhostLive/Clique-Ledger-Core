class Admin{
  final String user_id;
  final String member_id;

  Admin({
    required this.user_id,
    required this.member_id,
  });
  factory Admin.fromJson(Map<String,dynamic> json){
    return Admin(
      
    user_id: json['user_id'],
    member_id: json['member_id'],
    );
  }
}