import 'package:finder/core/logging/logger.dart';
import 'package:finder/core/style.dart';
import 'package:finder/core/validation/user_input_validation.dart';
import 'package:finder/features/auth/model/country_code.dart';
import 'package:finder/features/auth/view/common.dart';
import 'package:finder/features/auth/view/password_validator.dart';
import 'package:finder/features/auth/view/sign_in.dart';
import 'package:finder/features/auth/view_model/sign_up_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextStyle hintStyle = const TextStyle(
    fontSize: 14
  );
  final formKey= GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    bool isEmpty(String? value) => value == null || value.trim().isEmpty;
    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider<SignUpVM>(
        create: (_) => SignUpVM()..readCountryCodes(),
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

              Form(
                key: formKey,
                child:Container(
                margin: EdgeInsets.only(top: 35),
                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel("Full name",isRequired: true,),
                    Selector<SignUpVM, String>(
                      builder: (context, vm, __) {
                        return TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    const FieldLabel("Sign up with",isRequired: true,),
                    Selector<SignUpVM, SignUpMethod>(
                        builder: (context, signUpMethod, __) {
                          final onChangeFun = context
                              .read<SignUpVM>()
                              .setSignupMethod;
                          return Column(children: [
                            Row(children: [

                              Expanded(
                                  flex: 1,
                                  child: _SwitchOption(
                                      onTap: () {
                                        onChangeFun(SignUpMethod.email);
                                      },
                                      title: "Email",
                                      iconData: Icons.email,
                                      isSelected:
                                      signUpMethod == SignUpMethod.email
                                  )),

                              SizedBox(width: 5,),
                              Expanded(
                                flex: 1,
                                child: _SwitchOption(
                                    onTap: () {
                                      onChangeFun(SignUpMethod.phone);
                                    },
                                    title: "Phone",
                                    iconData: Icons.phone,
                                    isSelected:
                                    signUpMethod == SignUpMethod.phone
                                ),),

                            ],),
                            SizedBox(height: 16,),
                            if(signUpMethod == SignUpMethod.email)
                              TextFormField(

                                validator: (String? value) {
                                  if (isEmpty(value)) {
                                    return "Email is required";
                                  }
                                  if(!isValidEmail(value!)){
                                    return "Invalid email";
                                  }
                                  return null;
                                },
                               autovalidateMode: AutovalidateMode.onUserInteraction,
                                onChanged: context
                                    .read<SignUpVM>()
                                    .onEmailChanged,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail_outline),
                                  hintText: "Enter your email",
                                  hintStyle: hintStyle,
                                ),
                              )
                            else
                              Selector<SignUpVM, CountryCode>(
                              builder: (_, countryCode, __) {
                               return Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                  Expanded(
                                    flex: 35,
                                    child:
                                         DropdownButtonFormField<CountryCode>(
                                          //padding: EdgeInsets.symmetric(horizontal: 10),
                                          initialValue: countryCode,
                                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 4,
                                              vertical: 14
                                          )),
                                          padding: EdgeInsets.zero,
                                          items: context
                                              .read<SignUpVM>()
                                              .countryCodes
                                              .map<DropdownMenuItem<CountryCode>>(
                                                  (countryCode) {
                                                return DropdownMenuItem(
                                                    value: countryCode,
                                                    child: Text("${countryCode
                                                        .iso2.name}  (${countryCode
                                                        .dialCode})",style: TextStyle(fontSize: 14),));
                                              }
                                          )
                                              .toList(),
                                          onChanged: context.read<SignUpVM>().onCountryCodeChanged,
                                        )

                                     ),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 65,
                                      child:   TextFormField(
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (String? value) {
                                          if (isEmpty(value)) {
                                            return "Phone is required";
                                          }
                                          return validatePhoneByCountry(value, countryCode);

                                        },
                                        onChanged: context
                                            .read<SignUpVM>()
                                            .onPhoneChanged,
                                        decoration: InputDecoration(
                                          //Icon(Icons.phone),
                                          hintText: "Enter your phone",
                                          hintStyle: hintStyle,
                                        ),
                                      ))



                                ],);
                              }
                              ,selector: (_,vm)=> vm.selectedCountryCode,
                              )




                          ],);
                        }, selector: (_, vm) => vm.selectedSignupMethod),

                    SizedBox(height: 16,),
                    const FieldLabel("Password",isRequired: true,),
                    Selector<SignUpVM, String>(
                      builder: (context, password, __) {
                        return PasswordFieldWithValidation(
                            password: password, field: TextFormField(
                          validator: (String? value){
                            if(isEmpty(value)) return "Password is required";

                            return isPasswordValid(value!);
                          },
                          onChanged: context
                              .read<SignUpVM>()
                              .onPasswordChanged,
                          obscureText: true,
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
                    const FieldLabel("Confirm Password",isRequired: true,),
                    Selector<SignUpVM, String>(
                      builder: (context, confirmPassword, __) {
                        return TextFormField(
                          validator: (String? value){
                            if(isEmpty(value)) return "Confirm Password is required";

                            return value == context.read<SignUpVM>().password ? null : "Password is not matched";
                          },
                          obscureText: true,
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
                        child:

                        Consumer<SignUpVM>(builder: (__,vm,_){
                          return    FilledButton(

                              style: FilledButton.styleFrom(
                                  backgroundColor: mainColor
                              ),
                              onPressed: vm.submittingForm? null : () {
                                if(formKey.currentState?.validate() != true){
                                  return;
                                }
                                vm.submitForm();
                              }, child: Text(vm.submittingForm?  "Signing Up":"Sign Up"));
                        })
                     ),
                    SizedBox(height: 16,),


                  ],),),),



            ],
          ), )

        ),
      ),
    );
  }
}

class _SwitchOption extends StatelessWidget {
  const _SwitchOption({required this.title,required this.iconData, required this.isSelected,required this.onTap});
  final String title;
  final IconData iconData;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OutlinedButton(
        onPressed: onTap,
        style: isSelected?OutlinedButton.styleFrom(
            backgroundColor: mainColor,
            side: const BorderSide(color: Color(0xFFE2E6EA)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))

        ) : OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.transparent),

        ),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData,color: isSelected ?Colors.white : fillText,),
        SizedBox(width: 5,),
        Text(title,style: TextStyle(color: isSelected ?Colors.white : fillText),)
      ],));


  }
}