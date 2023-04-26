import 'package:flutter/material.dart';
import 'package:nalelu/constants.dart';
import 'package:nalelu/furi_text.dart';
import 'package:nalelu/na_helpers.dart';
import 'package:nalelu/widgets/doushi_exercise/doushi_exercise_1.dart';
import 'package:nalelu/widgets/manga_exercise/manga_exercise.dart';
import 'package:nalelu/widgets/menus/numbers_menu.dart';
import 'package:nalelu/widgets/shared/na_menu_button.dart';
import 'package:nrs_flutter_lib/constants.dart';
import 'package:nrs_flutter_lib/nrs_flutter_lib.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Nrs.getScreenHeight() / 3.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: Nrs.isDarkTheme(context) ? 0.7 : 0.9,
              image: AssetImage('assets/banners/gates.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: FONT_SIZE, left: FONT_SIZE),
            child: Row(
              children: [
                Text(
                  APP_NAME,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              NAMenuButton(
                destination: NumbersMenu(),
                label: NA.t('numbersExercise'),
                translabel: [FuriText('数字', 'すうじ')],
              ),
              NAMenuButton(
                destination: DoushiExerciseLevel1(),
                label: NA.t('verbs'),
                translabel: [FuriText('動詞', 'どうし')],
              ),
              NAMenuButton(
                destination: MangaExercise(),
                label: NA.t('manga'),
                translabel: [FuriText('漫画', 'まんが')],
              ),
            ],
          ),
        ),
      ],
    );
  }
}