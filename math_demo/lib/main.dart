import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'question.dart';
import 'answer.dart';
import 'result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Math Question'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Question> questionList = [];
  List<Answer> userAnswerList = [];

  final itemController = TextEditingController();

  getQuestions() async {
    var jsonText = await rootBundle.loadString('json/QuestionList.json');
    List dataList = json.decode(jsonText);

    setState(() {
      for (int i = 0; i < dataList.length; i++) {
        Map questionMap = dataList[i];
        Question question = Question(id: questionMap['id'], question: questionMap['question'], difficulty: questionMap['difficulty']);
        questionList.add(question);
      }
    });

    print('questionList:');
    print(questionList);
  }

  void _incrementCounter() {

    if (itemController.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('不能空白喔～'),
        ),
      );
      return;
    }
    else {
      Answer answer = Answer(id: questionList[_counter].id, answer: itemController.text, difficulty: questionList[_counter].difficulty);
      userAnswerList.add(answer);
      itemController.text = '';
    }

    setState(() {
      _counter++;
      if (_counter >= 10) {
        _counter = 9;
        print('userAnswerList:');
        print(userAnswerList);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Result(userAnswerList: userAnswerList,),
                fullscreenDialog: true)).then((value) {
          print(value);
          setState(() {
            _counter = 0;
            userAnswerList = [];
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    itemController.text = '';
    getQuestions();
  }
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String questionStr = 'None';
    int number = _counter + 1;
    String id = '';
    int difficulty = 0;
    if (questionList.length > _counter) {
      questionStr = questionList.length > _counter ? questionList[_counter].question : 'None';
      id = questionList[_counter].id;
      difficulty = questionList[_counter].difficulty;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column (
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('第 $number 題，難度：'),
                Icon(difficulty >= 1 ? Icons.star : Icons.star_outline),
                Icon(difficulty >= 2 ? Icons.star : Icons.star_outline),
                Icon(difficulty >= 3 ? Icons.star : Icons.star_outline),
                Icon(difficulty >= 4 ? Icons.star : Icons.star_outline),
                Icon(difficulty >= 5 ? Icons.star : Icons.star_outline),
                Text('，序號：$id'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(questionStr),
                Container(
                  width: 200,
                  padding: const EdgeInsets.only(left:30.0, top:30.0, right:30.0, bottom: 0.0),
                  child: TextField(
                    controller: itemController,
                    obscureText: false,
                    decoration:
                    InputDecoration(labelText: '你的答案', hintText: '請輸入答案'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Text(_counter >= 9 ? 'Submit' : 'Next'),
      ),
    );
  }
}
