import 'package:flutter/material.dart';
import 'package:nalelu/na_helpers.dart';
import 'package:nalelu/state/enums.dart';
import 'package:nalelu/state/exercise_nav_notifier.dart';
import 'package:nalelu/state/suuji/jikan/jikan_notifier.dart';
import 'package:nalelu/widgets/shared/ad_card.dart';
import 'package:nalelu/widgets/shared/hint_button.dart';
import 'package:nalelu/widgets/shared/home_button_wrapper.dart';
import 'package:nalelu/widgets/shared/na_free_form_entry_wrapper.dart';
import 'package:nalelu/widgets/shared/nav_header_wrapper.dart';
import 'package:nalelu/widgets/suuji_exercise/jikan_exercise/clock.dart';
import 'package:nalelu/widgets/suuji_exercise/number_chart.dart';
import 'package:nrs_flutter_lib/enums.dart';
import 'package:nrs_flutter_lib/nrs_flutter_lib.dart';
import 'package:nrs_flutter_lib/widgets/n_answer_status_icon.dart';
import 'package:nrs_flutter_lib/widgets/n_footer_button.dart';
import 'package:nrs_flutter_lib/widgets/n_footer_menu.dart';
import 'package:nrs_flutter_lib/widgets/n_free_form_entry.dart';
import 'package:nrs_flutter_lib/widgets/n_info_button.dart';
import 'package:provider/provider.dart';

class JikanExercise extends StatelessWidget {
  final double textFieldWidth = 70;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Nrs.NrsAppBar(title: NA.t('numbers'), context: context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getContent(context),
              AdCard(),
            ],
          ),
        ),
        persistentFooterButtons: [
          NFooterMenu(buttons: [
            HomeButtonWrapper(),
            NFooterButton(
              text: NA.t('numberChart'),
              icon: Icons.list,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NumberChart()),
                );
              },
            ),
          ])
        ],
      ),
    );
  }

  getContent(BuildContext context) {
    return ChangeNotifierProvider<ExerciseNavNotifier>(
      create: (context) => ExerciseNavNotifier(ExerciseType.Jikan),
      child: Consumer<ExerciseNavNotifier>(
        builder: (context, navNotifier, child) {
          var s = navNotifier.getActive();
          bool isHintActive = false;
          return Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [
                NavHeaderWrapper(navNotifier: navNotifier),
                Clock(time: '${s.hour}:${s.min}:${s.sec}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(NA.t('typeTheTime')),
                    NInfoButton(
                      text: NA.t('timeDesc'),
                    ),
                  ],
                ),
                ChangeNotifierProvider<JikanNotifier>(
                  create: (context) => JikanNotifier(navNotifier.getActive),
                  child: Consumer<JikanNotifier>(
                    builder: (context, jikanNotifier, child) {
                      var s = jikanNotifier.getStateItem();
                      var isHourCorrect = s.correctHours.contains(s.userHour)
                          ? CorrectStatus.correct
                          : CorrectStatus.unstarted;
                      var isMinCorrect = s.correctMins.contains(s.userMin)
                          ? CorrectStatus.correct
                          : CorrectStatus.unstarted;
                      var isSecCorrect = s.correctSecs.contains(s.userSec)
                          ? CorrectStatus.correct
                          : CorrectStatus.unstarted;

                      return Wrap(
                        spacing: 20,
                        children: [
                          Column(
                            children: [
                              NAnswerStatusIcon(status: isHourCorrect),
                              !s.correctHours.contains(s.userHour)
                                  ? HintButton(
                                      onHintActive: (bool onHintActive) =>
                                          isHintActive = onHintActive,
                                      userInput: s.userHour,
                                      correctAnswer: s.correctHours[0],
                                      onHintUpdate: (String hint) => {
                                            jikanNotifier.updateHour(hint),
                                          })
                                  : Container(),
                              !s.correctHours.contains(s.userHour)
                                  ? Container(
                                      width: textFieldWidth,
                                      child: NaFreeFormEntryWrapper(
                                        widthType: NFreeFormWidths.half,
                                        hintValue: '',
                                        onChanged: (String newValue) =>
                                            jikanNotifier.updateHour(newValue),
                                        initialValue: s.userHour,
                                        correctValues: s.correctHours,
                                      ),
                                    )
                                  : Text(s.userHour,
                                      style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Column(
                            children: [
                              NAnswerStatusIcon(status: isMinCorrect),
                              !s.correctMins.contains(s.userMin)
                                  ? HintButton(
                                      onHintActive: (bool onHintActive) =>
                                          isHintActive = onHintActive,
                                      userInput: s.userMin,
                                      correctAnswer: s.correctMins[0],
                                      onHintUpdate: (String hint) => {
                                            jikanNotifier.updateMin(hint),
                                          })
                                  : Container(),
                              !s.correctMins.contains(s.userMin)
                                  ? Container(
                                      width: textFieldWidth,
                                      child: NaFreeFormEntryWrapper(
                                        widthType: NFreeFormWidths.half,
                                        hintValue: '',
                                        onChanged: (String newValue) =>
                                            jikanNotifier.updateMin(newValue),
                                        initialValue: s.userMin,
                                        correctValues: s.correctMins,
                                      ),
                                    )
                                  : Text(s.userMin,
                                      style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Column(
                            children: [
                              NAnswerStatusIcon(status: isSecCorrect),
                              !s.correctSecs.contains(s.userSec)
                                  ? HintButton(
                                      onHintActive: (bool onHintActive) =>
                                          isHintActive = onHintActive,
                                      userInput: s.userSec,
                                      correctAnswer: s.correctSecs[0],
                                      onHintUpdate: (String hint) => {
                                            jikanNotifier.updateSec(hint),
                                          })
                                  : Container(),
                              !s.correctSecs.contains(s.userSec)
                                  ? Container(
                                      width: textFieldWidth,
                                      child: NaFreeFormEntryWrapper(
                                        widthType: NFreeFormWidths.half,
                                        hintValue: '',
                                        onChanged: (String newValue) =>
                                            jikanNotifier.updateSec(newValue),
                                        initialValue: s.userSec,
                                        correctValues: s.correctSecs,
                                      ),
                                    )
                                  : Text(s.userSec,
                                      style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
