class LoginUserModel{
  String uid;
  String name;
  String email;


  LoginUserModel({this.uid, this.name, this.email,});

  //receive  data from server

  factory LoginUserModel.fromMap(map){
    return LoginUserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
    );
  }
//sending data to the server
  Map<String, dynamic> toMap(){
    return{
      'uid':uid,
      'name':name,
      'email':email,
    };
  }

}