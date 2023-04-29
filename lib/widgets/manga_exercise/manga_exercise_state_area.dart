import 'package:flutter/material.dart';
import 'package:nalelu/state/exercise_nav_notifier.dart';
import 'package:nalelu/state/manga/manga_exercise_state.dart';
import 'package:nalelu/state/manga/models.dart';
import 'package:nalelu/widgets/manga_exercise/speech_bubble.dart';
import 'package:nalelu/widgets/shared/na_free_form_entry_wrapper.dart';
import 'package:nrs_flutter_lib/nrs_flutter_lib.dart';
import 'package:nrs_flutter_lib/widgets/n_free_form_entry.dart';
import 'package:nrs_flutter_lib/widgets/n_hint_button.dart';

class MangaExerciseStateArea extends StatefulWidget {
  final MangaExerciseState state;
  final ExerciseNavNotifier navNotifier;

  const MangaExerciseStateArea({
    required this.state,
    Key? key,
    required this.navNotifier,
  }) : super(key: key);

  @override
  State<MangaExerciseStateArea> createState() => _MangaExerciseStateAreaState();
}

class _MangaExerciseStateAreaState extends State<MangaExerciseStateArea> {
  bool isTextfieldActive = false;
  final mangaWidth = Nrs.getScreenWidth();
  PhrasePart? activePhrasePart;

  Widget build(BuildContext context) {
    widget.navNotifier.onNextOrPrevious = () => activePhrasePart = null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: mangaWidth,
                height: mangaWidth,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image(
                      fit: BoxFit.cover,
                      image:
                          AssetImage(widget.state.mangaExerciseModel.imageUrl),
                    ),
                    ...widget.state.mangaExerciseModel.phrases.map(
                      (e) => SpeechBubble(
                        getIsCorrect: widget.state.isPhrasePartCorrect,
                        phrase: e,
                        onButtonTap: (PhrasePart phrasePart) => {
                          setState(() {
                            activePhrasePart = phrasePart;
                            isTextfieldActive = true;
                          })
                        },
                        mangaWidth: mangaWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        isTextfieldActive &&
                activePhrasePart != null &&
                !widget.state.isPhrasePartCorrect(activePhrasePart)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NHintButton(
                      userInput: widget.state.getUserInput(activePhrasePart),
                      correctAnswer: widget.state
                          .getCorrectAnswers(activePhrasePart)
                          .first,
                      onHintUpdate: (String hint) => {
                            setState(() {
                              widget.state
                                  .updateUserInput(activePhrasePart, hint);

                              if (widget.state
                                  .isPhrasePartCorrect(activePhrasePart)) {
                                activePhrasePart = null;
                              }
                            }),
                          }),
                  Container(
                    width: 200,
                    child: NaFreeFormEntryWrapper(
                      widthType: NFreeFormWidths.half,
                      hintValue: '',
                      onChanged: (String newValue) {
                        setState(() {
                          widget.state
                              .updateUserInput(activePhrasePart, newValue);

                          if (widget.state
                              .isPhrasePartCorrect(activePhrasePart)) {
                            activePhrasePart = null;
                          }
                        });
                      },
                      initialValue: widget.state.getUserInput(activePhrasePart),
                      correctValues:
                          widget.state.getCorrectAnswers(activePhrasePart),
                    ),
                  )
                ],
              )
            : Container(),
      ],
    );
  }
}
