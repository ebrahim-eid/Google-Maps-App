import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/core/helpers/reusable_widgets.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_cubit.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_states.dart';

// ignore: must_be_immutable
class ForgetPasswordScreen extends StatelessWidget {
   ForgetPasswordScreen({super.key});
  var emailController=TextEditingController();
  var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context,state){
        if(state is ResetPasswordSuccessState ){
          showDialogReusable(context, 'Password reset link sent! Check your email');
        }else if (state is ResetPasswordErrorState){
          showDialogReusable(context, state.error);
        }
      },
      builder: (context,state){
        var cubit=AuthCubit.get(context);

        return Scaffold(
          appBar: AppBar(),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/reset-password.png',color: Colors.blue,width: 200,height: 200,),
                          const SizedBox(height: 30,),
                          const Text('Enter your Email and we will send you a password reset link',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),),
                          const SizedBox(height: 30,),

                          defaultFormField(
                              label: 'Email',
                              validate: 'Email',
                              prefix: Icons.email,
                              controller: emailController,
                              type: TextInputType.emailAddress
                          ),
                          const SizedBox(height: 30,),
                          if(state is ResetPasswordLoadingState)
                            const CircularProgressIndicator()
                          else
                          defaultButton(context, text: 'Send Email',
                              onPressed: ()async{
                                    if(formKey.currentState!.validate()){
                                      await cubit.resetPassword(emailController.text);
                                    }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}
