import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_logic.dart';

QuizLogic quizLogic = QuizLogic();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = generateEmptyScoreKeeper();
  int correctAnswers = 0;

//  List<Icon> scoreKeeper = () {
//    List<Icon> result = [];
//
//    for (int i = 0; i < quizLogic.numQuestions(); i++) {
//      result.add(placeholderIcon);
//    }
//
//    return result;
//  }();

  static Icon correctIcon = Icon(
    Icons.check,
    color: Colors.green,
  );

  static Icon incorrectIcon = Icon(
    Icons.close,
    color: Colors.red,
  );

  static Icon placeholderIcon = Icon(
    Icons.help_outline,
    color: Colors.blue,
  );

  Alert createResultAlert() {
    return Alert(
      context: context,
      title: 'Results',
      desc:
          'You answered $correctAnswers out of ${quizLogic.numQuestions()} questions correctly.',
      type: AlertType.success,
      buttons: [
        DialogButton(
          child: Text(
            'RESET',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      closeFunction: () => {},
    );
  }

  static List<Icon> generateEmptyScoreKeeper() {
    List<Icon> result = [];

    for (int i = 0; i < quizLogic.numQuestions(); i++) {
      result.add(placeholderIcon);
    }

    return result;
  }

  void initializeScoreKeeper() {
    scoreKeeper = generateEmptyScoreKeeper();
  }

  // Records answer and advances to next question. To be called after each answer is given
  void answerQuestion(bool answer) {
    recordScore(answer == quizLogic.getAnswer());
    nextQuestion();
  }

  void recordScore(bool correct) {
    setState(() {
      scoreKeeper[quizLogic.currentQuestion()] =
          correct ? correctIcon : incorrectIcon;

      if (correct) {
        correctAnswers++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (quizLogic.isFinished()) {
        createResultAlert().show();
        resetQuiz();
      } else {
        quizLogic.nextQuestion();
      }
    });
  }

  void resetQuiz() {
    setState(() {
      quizLogic.reset();
      scoreKeeper = [];
      initializeScoreKeeper();
      correctAnswers = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizLogic.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                answerQuestion(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                answerQuestion(false);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: scoreKeeper,
        ),
      ],
    );
  }
}
