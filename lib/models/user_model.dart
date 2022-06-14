class UserModel {
  String userName;
  String userEmail;
  String userImage;
  String userUid;
  UserModel({
    this.userEmail,
    this.userImage,
    this.userName,
    this.userUid,
  });
//taking data from server
  factory UserModel.fromMap(map){
    return UserModel(
      userUid: map['uid'],
      userName: map['name'],
      userEmail: map['email'],
      userImage: map['image'],

    );
  }
//sending data to the server
  Map<String, dynamic> toMap(){
    return{
      'uid':userUid,
      'name':userName,
      'email':userEmail,
      'image':userImage,

    };
  }
}
