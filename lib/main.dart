import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_cubit.dart';
import 'package:flutter_maps/feature/presentation/controllers/auth_cubit/auth_states.dart';
import 'package:flutter_maps/feature/presentation/controllers/bloc_observer.dart';
import 'package:flutter_maps/feature/presentation/controllers/maps_cubit/map_cubit.dart';
import 'package:flutter_maps/feature/presentation/screens/login_screen/login_screen.dart';
import 'feature/presentation/screens/map_screen/map_screen.dart';
import 'firebase_options.dart';
import 'core/helpers/cashe_helper/shared_prefernce.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
    MyApp({super.key});
   var login = CashHelper.getData(key: 'login',);

   @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => MapCubit()..getPosition(),)
        ],
        child: BlocConsumer<AuthCubit,AuthStates>(
          listener: (context,state){},
          builder: (context,state){
            return MaterialApp(
              theme: ThemeData(
                  primarySwatch: Colors.cyan
              ),
              debugShowCheckedModeBanner: false,
              home: login == false||login==null ? LoginScreen() : MapScreen(),

            );
          },
        )
    );
  }
}

