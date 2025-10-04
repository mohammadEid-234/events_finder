import 'package:finder/core/style.dart';
import 'package:finder/features/auth/model/auth_repo.dart';
import 'package:finder/features/auth/view/common.dart';
import 'package:finder/features/auth/view/signup.dart';
import 'package:finder/features/auth/view_model/sign_in_vm.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:provider/provider.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    // Local theme without MaterialApp
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return Scaffold( // gives default text styles & ink effects
      body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child:
            Center(child: SingleChildScrollView(

              child:      Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child:CircleBadge(color:mainColor,
                      height: 85,
                      width: 85,
                      child: const Icon(Icons.lock_outline,size: 50,color: Colors.white,),),
                  ),
                  Text('Sign In',style: TextStyle(fontSize: 18,),),

                  SizedBox(height: 30,),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    //height: screenHeight * 0.6,
                    child: Column(
                      //shrinkWrap: true,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const FieldLabel('Email or Phone number'),
                        Selector<SignInVM, String>(
                          selector: (_, vm) => vm.email,
                          builder: (_, value, __) => TextField(
                            onChanged: context.read<SignInVM>().setEmail,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Enter your email or phone',
                              prefixIcon: const Icon(Icons.mail_outline),
                              filled: true,
                              fillColor: fillColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: inputBorder,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const FieldLabel('Password'),
                        Consumer<SignInVM>(
                          builder: (context, vm, _) => TextField(
                            onChanged: vm.setPassword,
                            obscureText: vm.obscure,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: vm.toggleObscure,
                                icon: Icon(vm.obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                tooltip: vm.obscure ? 'Show password' : 'Hide password',
                              ),
                              filled: true,
                              fillColor: fillColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: inputBorder,
                            ),
                          ),
                        ),

                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () {
                              // TODO: forgot password flow
                            },
                            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
                            child: const Text('Forgot password?',style: TextStyle(fontSize: 15),),
                          ),
                        ),



                        const SizedBox(height: 4),

                        Consumer<SignInVM>(
                          builder: (context, vm, _) => SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: vm.loading ? null : vm.submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: mainColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                disabledBackgroundColor: mainColor.withOpacity(0.4),
                              ),
                              child: vm.loading
                                  ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                                  : const Text('Sign In'),
                            ),
                          ),
                        ),

                        // Error area
                        Consumer<SignInVM>(
                          builder: (context, vm, _) => vm.error == null
                              ? const SizedBox(height: 16)
                              : Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              vm.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),



                        SizedBox(height: 24,),
                        const DividerWithText('OR CONTINUE WITH'),
                        const SizedBox(height: 16),

                        Consumer<SignInVM>(
                          builder: (context, vm, _) => Row(
                            children: [
                              Expanded(
                                child: SocialButton(
                                  label: 'Google',
                                  onPressed: vm.loading ? null : vm.signInWithGoogle,
                                  leading: Image.asset("assets/images/google_logo.png",height: 45,width: 45,),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SocialButton(
                                  label: 'Facebook',
                                  onPressed: vm.loading ? null : vm.signInWithFacebook,
                                  leading: Image.asset("assets/images/fb_logo.png",height: 45,width: 45,),
                                ),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to SignUp screen
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignUp()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mainColor, // same primary blue
                          ),
                        ),
                      ),
                    ],
                  ),
                ],),),)





          ),


    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInVM(),
      child: const SignInView(),
    );
  }
}