class UserModel {
  final String name;
  final String email;
  final String uId;

  UserModel({required this.name, required this.email, required this.uId});
  factory UserModel.fromJsom(json){
    return UserModel(
        name: json['name'],
        email: json['email'],
        uId: json["uid"]
    );
  }


  Map<String,dynamic> toJson(){
    return {
      'name':name,
      'email':email,
      'uid':uId
    };
  }
}