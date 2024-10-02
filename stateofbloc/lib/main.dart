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

// 두 명의 User 상태를 관리하기 위한 State 클래스 추가
class UserState {
  final User user1;
  final User user2;

  UserState({required this.user1, required this.user2});

  // 기존 상태를 복사하면서 새로운 값을 적용하는 메소드
  UserState copyWith({User? user1, User? user2}) {
    return UserState(
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
    );
  }
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(user1: User(), user2: User())) {
    // 이벤트 리스너 등록
    on<CreateUserEvent>(createUser1);
    on<CreateUser2Event>(createUser2);
  }

  // 첫 번째 User 생성
  FutureOr<void> createUser1(CreateUserEvent event, Emitter<UserState> emit) {
    final User user = User(name: event.name, age: int.tryParse(event.age) ?? 0);
    emit(state.copyWith(user1: user));
  }

  // 두 번째 User 생성
  FutureOr<void> createUser2(CreateUser2Event event, Emitter<UserState> emit) {
    final User user = User(name: event.name, age: int.tryParse(event.age) ?? 0);
    emit(state.copyWith(user2: user));
  }
}

// 이벤트 정의
abstract class UserEvent {}

class CreateUserEvent extends UserEvent {
  final String name;
  final String age;

  CreateUserEvent({required this.name, required this.age});
}

class CreateUser2Event extends UserEvent {
  final String name;
  final String age;

  CreateUser2Event({required this.name, required this.age});
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
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text('User 1 Name : ${state.user1.name}'),
                        Text('User 1 Age : ${state.user1.age}'),
                        const SizedBox(height: 12.0),
                        Text('User 2 Name : ${state.user2.name}'),
                        Text('User 2 Age : ${state.user2.age}'),
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
                    BlocProvider.of<UserBloc>(context).add(
                      CreateUser2Event(
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