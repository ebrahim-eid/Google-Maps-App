
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/constants.dart';

/// default button

Align defaultButton(context,{
   required String text,
  required VoidCallback onPressed,
}) =>
    Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            color: Colors.blue),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

/// ListTitle
ListTile buildListTitle({
  required IconData leadingIcon,
  required String title,
  required GestureTapCallback onTap,
  Color ?color,
  bool isTrailing=true,

})=>ListTile(
  onTap: onTap,
  leading: Icon(leadingIcon,color: color ?? AppColors.blueColor,),
  title:  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Text(title,style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18
    ),),
  ),
  trailing: Icon(isTrailing == false? null:Icons.arrow_right,color: AppColors.blueColor,size: 25,),
);


/// default form field

TextFormField defaultFormField({
  required String label,
  required String validate,
  required IconData prefix,
  required TextEditingController controller,
  required TextInputType type,
  VoidCallback ? suffixPress,
  bool secure=false,
  IconData ? suffix,
}){
  return TextFormField(
    controller: controller,
    obscureText: secure,
    validator: (value){
      if(value!.isEmpty){
        return '$validate must not be empty';
      }
      return null;
    },
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon:  Icon(prefix,color: Colors.blue,),
        labelText: label,
        suffixIcon: suffix != null ? IconButton(onPressed: suffixPress, icon: Icon(suffix),):null
    ),
  );
}


/// google facebook
Widget footer({
  required VoidCallback googlePress,
}) =>Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(100),
    border: Border.all(color: Colors.grey),
  ),
  child: IconButton(
    onPressed: googlePress,
    icon: const Image(
      image: AssetImage('assets/images/google.png'),
      width: 24,
      height: 24,
    ),
  ),
);

/// divider
Widget divider(context,String text)=>Row(
  children: [
    const Flexible(
      child: Divider(
        color: Colors.grey,
        thickness: 0.8,
        indent: 60,
        endIndent: 5,
      ),
    ),
    Text(
      text,
      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.blue),
    ),
    const Flexible(
      child: Divider(
        color: Colors.grey,
        thickness: 0.8,
        indent: 5,
        endIndent: 60,
      ),
    ),
  ],
);

 /// show dialog
  void showDialogReusable(context,String text){
    showDialog(context: context, builder: (context)=>AlertDialog(
      content:  Text(text),
    ));
  }