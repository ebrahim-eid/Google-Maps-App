import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/feature/data/models/user_model.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_states.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/helpers/cashe_helper/shared_prefernce.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);


  /// change password icon visibility
  bool secure = true;
  IconData suffixIcon= Icons.visibility_outlined;
  void changePasswordIcon(){
    secure = !secure;
    suffixIcon = secure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordState());
  }
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController loginEmailController=TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();
  final TextEditingController registerEmailController=TextEditingController();
  final TextEditingController registerUsernameController=TextEditingController();
  @override
  Future<void> close() {
    loginPasswordController.dispose();
    registerPasswordController.dispose();
    loginEmailController.clear();
    registerEmailController.clear();
    registerUsernameController.clear();
    return super.close();
  }


  /// register
  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
})async{
    emit(RegisterLoadingState());
    await FirebaseAuth.instance.
    createUserWithEmailAndPassword
      (email: email, password: password)
        .then((value) async{
          await createUser(email: email, name: name, uId: value.user!.uid);
    }).catchError((error){
      emit(RegisterErrorState(error.toString()));
    });
  }

  /// login
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    try {
      // Attempt to sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (error) {
      // Handle specific FirebaseAuthException
      if (error.code == 'wrong-password') {
        emit(LoginErrorState('The password is incorrect.'));
      } else if (error.code == 'user-not-found') {
        emit(LoginErrorState('No user found for this email.'));
      } else {
        emit(LoginErrorState(error.message ?? 'An unknown error occurred.'));
      }
    } catch (error) {
      // Handle any other errors
      emit(LoginErrorState(error.toString()));
    }
  }


  /// google sign in
  Future signInWithGoogle()async{
    emit(GoogleSignLoadingState());

    /// begin sign in process
    final GoogleSignInAccount ? user= await GoogleSignIn().signIn();
    /// get auth details
    final GoogleSignInAuthentication auth= await user!.authentication;
    /// create credential for user
    final credential =GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken
    );
    ///sign in
    return await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      emit(GoogleSignSuccessState());
    }).catchError((error){
      emit(GoogleSignErrorState(error.toString()));
    });
  }

  /// reset password
  Future<void>resetPassword(String email)async{
    emit(ResetPasswordLoadingState());
    try{
      final userSnapshot= await FirebaseFirestore.instance.collection('users').
      where('email', isEqualTo: email)
          .get();
      if (userSnapshot.docs.isEmpty){
        emit(ResetPasswordErrorState('No user found with this Email'));
      }else{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        emit(ResetPasswordSuccessState());
      }
    }on FirebaseAuthException catch(error){
      emit(ResetPasswordErrorState(error.toString()));

    }

  }

  /// create user 
  Future<void>createUser({
    required String email,
    required String name,
    required String uId,
})async{
    UserModel userModel =UserModel(name: name, email: email, uId: uId);
    await FirebaseFirestore.instance.collection('users').doc().set(userModel.toJson()).then((value){
      emit(CreateUserSuccessState());

    }).catchError((error){
      emit(CreateUserErrorState(error.toString()));

    });
  }
  
  // User getLoggedInUser() {
  //   User firebaseUser = FirebaseAuth.instance.currentUser!;
  //   return firebaseUser;
  // }



}
