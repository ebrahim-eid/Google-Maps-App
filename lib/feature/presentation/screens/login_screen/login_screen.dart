import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/core/helpers/helper_fuctions/helper_functions.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_cubit.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_states.dart';
import 'package:flutter_maps/feature/presentation/screens/register_screen/register_screen.dart';

import '../../../../core/helpers/cashe_helper/shared_prefernce.dart';
import '../../../../core/helpers/reusable_widgets.dart';
import '../forget_password/forget_password_screen.dart';
import '../map_screen/map_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
  var formKey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
        listener: (context,state){
          if(state is LoginErrorState){
            showDialogReusable(context, state.error.toString());
          }else if(state is LoginSuccessState || state is GoogleSignSuccessState){
            CashHelper.setData(key: 'login', value: true).then((value) {
              if(value) {
                HelperFunctions.navigateAndReplace(context, MapScreen());
              }
            });
          }
        },
        builder: (context,state){
          var cubit=AuthCubit.get(context);
          return Scaffold(
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height*0.15,
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.89,
                    height: MediaQuery.of(context).size.height*0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                defaultFormField(type: TextInputType.emailAddress,label: 'Email', validate: 'Email', prefix: Icons.email, controller: cubit.loginEmailController
                                ),
                                const SizedBox(height: 30,),
                                defaultFormField(
                                    type: TextInputType.visiblePassword,
                                    label: 'Password', validate: 'Password', prefix: Icons.lock,
                                    controller: cubit.loginPasswordController,
                                    suffix: cubit.suffixIcon,
                                    secure: cubit.secure,

                                    suffixPress: (){
                                      cubit.changePasswordIcon();
                                    }
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(onPressed: (){
                                      HelperFunctions.navigateTo(context,  ForgetPasswordScreen());
                                    }, child: const Text('Forget Password?',style: TextStyle(color: Colors.blue),)),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                              if(state is LoginLoadingState)
                                CircularProgressIndicator()
                              else
                              defaultButton(context,
                                  onPressed: ()
                                 async {
                                    if(formKey.currentState!.validate()){
                                      await cubit.loginUser(
                                          email: cubit.loginEmailController.text,
                                          password: cubit.loginPasswordController.text
                                      );

                                    }
                                  },
                                  text: 'Sign in'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Don\'t have an account ?',style: TextStyle(
                                        color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 13
                                      ),),
                                      OutlinedButton(onPressed: (){
                                        HelperFunctions.navigateTo(context, RegisterScreen());
                                      }, child: const Text("Sign up",style: TextStyle(
                                          color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15
                                      ),))
                                    ],
                                  ),
                                ),
                                divider(context,'Or Sign in with'),
                                const SizedBox(height: 30,),
                                if(state is GoogleSignLoadingState)
                                  const CircularProgressIndicator()
                                else
                                footer(googlePress: () async{
                                  await cubit.signInWithGoogle();
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*0.08,
                    child: Image.asset('assets/images/location.png',
                      width: 100,height: 100,color: Colors.blue,)),
              ],
            ),
          );
        },
    );
  }
}

