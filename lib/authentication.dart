import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser _appUser;

Future<FirebaseUser> handleCreateUser(email, password) async {
  FirebaseUser user = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  print("User created " + user.displayName);
  return user;
}

Future<FirebaseUser> handleSignIn(email, password) async {
  FirebaseUser user = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
  print("Signed in " + user.displayName);
  return user;
}


void setUser(FirebaseUser user){
  _appUser = user;
}

FirebaseUser getUser(){
  return _appUser;
}