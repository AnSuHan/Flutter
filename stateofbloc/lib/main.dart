import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///출처 : https://velog.io/@sunwonsw95/Flutter-Bloc-%EC%83%81%ED%83%9C%EA%B4%80%EB%A6%AC
void main() {
  runApp(const MyApp());
}

class User {
  final String name;
  final int age;

  User({this.name = '', this.age=0});
}

class UserBloc extends Bloc<UserEvent, User> {
  UserBloc() : super(User()) {
    //이벤트 리스너
    on<CreateUserEvent>(createUser);
  }

  // 이벤트 리스너 구현부
  FutureOr<void> createUser(CreateUserEvent event, Emitter<User> emit) {
    final User user = User(name: event.name, age: int.tryParse(event.age) ?? 0);
    emit(user);
  }
}

// 이벤트 정의
abstract class UserEvent {}

class CreateUserEvent extends UserEvent {
  final String name;
  final String age;

  CreateUserEvent({required this.name, required this.age});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => UserBloc(),
        child: Home(),
      ),
    );
  }
}


class Home extends StatelessWidget {
  Home({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Test')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                const SizedBox(height: 24.0),
                BlocBuilder<UserBloc, User>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text('Name : ${state.name}'),
                        Text('Age : ${state.age}'),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<UserBloc>(context).add(
                      CreateUserEvent(
                        name: nameController.text,
                        age: ageController.text,
                      ),
                    );
                  },
                  child: const Text('Generate User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}