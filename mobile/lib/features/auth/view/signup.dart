import 'package:finder/core/style.dart';
import 'package:finder/features/auth/view/common.dart';
import 'package:finder/features/auth/view/password_validator.dart';
import 'package:finder/features/auth/view/sign_in.dart';
import 'package:finder/features/auth/view_model/sign_up_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});
  final TextStyle hintStyle = const TextStyle(
    fontSize: 14
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final formKey= GlobalKey<FormState>();

    bool isEmpty(String? value) => value == null || value.isEmpty;
    return Scaffold(
      body: ChangeNotifierProvider<SignUpVM>(
        create: (_) => SignUpVM(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 30),
          child:
          SingleChildScrollView(child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: CircleBadge(
                    height: 85,
                    width: 85,
                    color: mainColor,
                    child: Icon(Icons.person, size: 45, color: Colors.white,)),),
              Text("Create Account",style: TextStyle(fontSize: 18),),
              SizedBox(height: 5,),
              Text("Sign up to get started",style: TextStyle(fontSize: 12),),

              Form(child:Container(
                margin: EdgeInsets.only(top: 35),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel("Full name"),
                    Selector<SignUpVM, String>(
                      builder: (context, vm, __) {
                        return TextFormField(
                          validator: (String? value){
                            if(isEmpty(value)) return "Full name is required";

                            return null;
                          },
                          onChanged: context
                              .read<SignUpVM>()
                              .onFullName,
                          decoration: InputDecoration(
                              hintText: "Enter your full name",
                              hintStyle: hintStyle,
                              prefixIcon: Icon(Icons.person_outline)

                          ),
                        );
                      },
                      selector: (_, vm) => vm.fullName,
                    ),
                    SizedBox(height: 16,),
                    const FieldLabel("Email or Phone Number"),
                    Selector<SignUpVM, String>(
                      builder: (context, vm, __) {
                        return TextFormField(
                          validator: (String? value){
                            if(isEmpty(value)) return "Email is required";
                            return null;
                          },
                          onChanged: context
                              .read<SignUpVM>()
                              .onEmailChanged,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline),
                            hintText: "Enter your email or phone",
                            hintStyle: hintStyle,
                          ),
                        );
                      },
                      selector: (_, vm) => vm.email,
                    ),
                    SizedBox(height: 16,),
                    const FieldLabel("Password"),
                    Selector<SignUpVM, String>(
                      builder: (context, password, __) {
                        return PasswordFieldWithValidation(
                            password: password, field: TextFormField(
                          validator: (String? value){
                            if(isEmpty(value)) return "Password is required";
                            return null;
                          },
                          onChanged: context
                              .read<SignUpVM>()
                              .onPasswordChanged,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: "Create a password",
                            hintStyle: hintStyle,
                          ),
                        ));
                      },
                      selector: (_, vm) => vm.password,
                    ),
                    SizedBox(height: 16,),
                    const FieldLabel("Confirm Password"),
                    Selector<SignUpVM, String>(
                      builder: (context, confirmPassword, __) {
                        return TextFormField(
                          validator: (String? value){
                            if(isEmpty(value)) return "Confirm Password is required";
                            return null;
                          },
                          onChanged: context
                              .read<SignUpVM>()
                              .onConfirmPasswordChanged,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: "Confirm your password",
                            hintStyle: hintStyle,
                          ),
                        );
                      },
                      selector: (_, vm) => vm.confirmPassword,
                    ),
                    SizedBox(height: 16,),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: mainColor
                            ),
                            onPressed: () {}, child: Text("Sign Up"))),
                    SizedBox(height: 16,),
                    DividerWithText("OR CONTINUE WITH"),
                    const SizedBox(height: 16),

                    Consumer<SignUpVM>(
                      builder: (context, vm, _) => Row(
                        children: [
                          Expanded(
                            child: SocialButton(
                              label: 'Google',
                              onPressed:(){},
                              leading: Image.asset("assets/images/google_logo.png",height: 25,width: 25,),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SocialButton(
                              label: 'Facebook',
                              onPressed:(){},
                              leading: Image.asset("assets/images/fb_logo.png",height: 25,width: 25,),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],),),),
              SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to SignUp screen
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SignInScreen()));
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor, // same primary blue
                      ),
                    ),
                  ),
                ],
              ),



            ],
          ), )

        ),
      ),
    );
  }
}
