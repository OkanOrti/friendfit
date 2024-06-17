/*import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class MyFormPage extends StatefulWidget {
  @override
  MyFormPageState createState() => MyFormPageState();
}

class MyFormPageState extends State<MyFormPage> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Form Validation Sample"),
        ),
        body: FormBuilder(
            key: formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: "name",
                      validator: FormBuilderValidators.required(context),
                      decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: "Enter your name",
                          labelText: "Name"),
                    ),
                    SizedBox(height: 25),
                    FormBuilderTextField(
                      name: "email",
                      validator: FormBuilderValidators.email(context),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: "Enter your email",
                          labelText: "Email"),
                    ),
                    SizedBox(height: 25),
                    FormBuilderTextField(
                      name: "mobile",
                      validator: FormBuilderValidators.numeric(context),
                      decoration: InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: "Enter your mobile no",
                          labelText: "Mobile No"),
                    ),
                    SizedBox(height: 25),
                    FormBuilderDateTimePicker(
                      name: "date",
                      inputType: InputType.date,
                      format: DateFormat("dd-MM-yyyy"),
                      decoration: InputDecoration(labelText: "Date of Birth"),
                      validator: FormBuilderValidators.required(context),
                    ),
                    SizedBox(height: 25),
                    FormBuilderTextField(
                      name: "age",
                      decoration: InputDecoration(labelText: "Age"),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.numeric(context),
                        FormBuilderValidators.max(context, 70)
                      ]),
                    ),
                    SizedBox(height: 25),
                    FormBuilderRadioGroup(
                      name: "gender",
                      decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                      options: [
                        FormBuilderFieldOption(value: "Male"),
                        FormBuilderFieldOption(value: "Female"),
                        FormBuilderFieldOption(value: "Custom"),
                      ],
                    ),
                    SizedBox(height: 25),
                    FormBuilderCheckboxGroup(
                      name: "languages",
                      initialValue: ["English"],
                      decoration: InputDecoration(
                          labelText: "Languages You Speak",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                      options: [
                        FormBuilderFieldOption(value: "English"),
                        FormBuilderFieldOption(value: "Spanish"),
                        FormBuilderFieldOption(value: "French"),
                      ],
                    ),
                    SizedBox(height: 25),
                    FormBuilderTextField(
                      name: "password",
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                      maxLines: 1,
                      maxLength: 16,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(context, 8),
                        FormBuilderValidators.maxLength(context, 16)
                      ]),
                    ),
                    SizedBox(height: 40),
                    RaisedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        formKey.currentState!.save();
                        if (formKey.currentState!.validate()) {
                          print(formKey.currentState!.value);
                        }
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
*/