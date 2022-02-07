import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'answer.dart';

class Result extends StatefulWidget {
  List<Answer> userAnswerList = [];
  Result({Key? key, required this.userAnswerList}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}


class _ResultState extends State<Result> {

  List<Answer> answerList = [];
  int correctNumber = 0;

  submitQuestions() async {
    var jsonText = await rootBundle.loadString('json/AnswerList.json');
    List dataList = json.decode(jsonText);

    setState(() {
      for (int i = 0; i < dataList.length; i++) {
        Map answerMap = dataList[i];
        Answer answer = Answer(id: answerMap['id'], answer: answerMap['answer'], difficulty: answerMap['difficulty']);
        answerList.add(answer);

        String userAnswerStr = '';
        userAnswerStr = widget.userAnswerList[i].answer;
        String answerStr = '';
        answerStr = answerList[i].answer;

        if (userAnswerStr == answerStr) {
          correctNumber++;
        }
      }
    });

    print('answerList:');
    print(answerList);
  }

  @override
  void initState() {
    super.initState();
    submitQuestions();
  }

  void _retry() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Column (
        children: [
          Expanded (
            child: ListView.builder(
              itemCount: widget.userAnswerList.length,
              itemBuilder: (context, index) {

                String userAnswer = '';
                if (widget.userAnswerList.length > index) {
                  userAnswer = widget.userAnswerList[index].answer;
                }
                String answer = '';
                String id = '';
                int difficulty = 0;
                if (answerList.length > index) {
                  answer = answerList[index].answer;
                  id = answerList[index].id;
                  difficulty = answerList[index].difficulty;
                }


                return ListTile(
                  leading: Icon(userAnswer == answer ? Icons.check : Icons.error, color: userAnswer == answer ? Colors.green : Colors.red,),
                  title: Text(userAnswer),
                  subtitle: Text('正確答案：'+answer),
                  trailing: Text('第 ${index+1} 題，難度： $difficulty'),

                );
              },
            ),
          ),
          MaterialBanner(
            content: Text(
                '全部 ${answerList.length} 題，答對 $correctNumber 題'),
            actions: <Widget>[
              TextButton(
                child: Text('Retry'),
                onPressed: _retry,
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _retry,
      //   tooltip: 'Retry',
      //   child: Text('Retry'),
      // ),
    );
  }
}
