import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/core/helpers/helper_fuctions/helper_functions.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_cubit.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_states.dart';

import '../../../../core/helpers/cashe_helper/shared_prefernce.dart';
import '../../../../core/helpers/reusable_widgets.dart';
import '../map_screen/map_screen.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  var formKey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context,state){
        if(state is RegisterErrorState){
          showDialogReusable(context, state.error.toString());
        }else if (state is CreateUserSuccessState || state is GoogleSignSuccessState){
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
          body: Column(
            children: [
              Expanded(child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height*0.15,
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.89,
                      height: MediaQuery.of(context).size.height*0.78,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                defaultFormField(
                                    type: TextInputType.text,
                                    label: 'Username',
                                    validate: 'Username',
                                    prefix: Icons.person,
                                    controller: cubit.registerUsernameController
                                ),
                                const SizedBox(height: 30,),
                                defaultFormField(type: TextInputType.emailAddress,label: 'Email', validate: 'Email', prefix: Icons.email, controller: cubit.registerEmailController),
                                const SizedBox(height: 30,),
                                defaultFormField(
                                    type: TextInputType.visiblePassword,
                                    label: 'Password', validate: 'Password', prefix: Icons.lock,
                                    controller: cubit.registerPasswordController,
                                    suffix: cubit.suffixIcon,
                                    secure: cubit.secure,

                                    suffixPress: (){
                                      cubit.changePasswordIcon();
                                    }
                                ),
                                const SizedBox(height: 30,),
                                if(state is RegisterLoadingState)
                                  const CircularProgressIndicator()
                                else
                                  defaultButton(context,
                                      onPressed: ()
                                      async{
                                        if(formKey.currentState!.validate()){
                                          await cubit.registerUser(email: cubit.registerEmailController.text,
                                            password: cubit.registerPasswordController.text, name: cubit.registerUsernameController.text,
                                          );
                                        }
                                      },
                                      text: 'Sign up'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 20
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Already have an account ?',style: TextStyle(
                                          color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 13
                                      ),),
                                      OutlinedButton(onPressed: (){
                                        Navigator.pop(context);
                                      }
                                          , child: const Text("Sign in",style: TextStyle(
                                              color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15
                                          ),))
                                    ],
                                  ),
                                ),
                                divider(context,'Or Sign un with'),
                                const SizedBox(height: 30,),
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
                  Positioned(
                      top: MediaQuery.of(context).size.height*0.08,
                      child: Image.asset('assets/images/location.png',
                        width: 100,height: 100,color: Colors.blue,)),
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}

