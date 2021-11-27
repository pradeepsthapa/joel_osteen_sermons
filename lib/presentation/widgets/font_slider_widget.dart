import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joel_osteen_sermons/logics/providers.dart';

class FontSliderWidget extends StatelessWidget {
  const FontSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context,ref,child) {
          return Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 1.5,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),),
                  child: Slider(
                    min: 12.0,
                    max: 24.0,
                    value: ref.watch(fontSizeProvider),
                    inactiveColor: Colors.grey[500],
                    onChanged: (value) {
                      ref.watch(fontSizeProvider.notifier).state = value;
                    },
                    onChangeEnd: (value) {
                      ref.watch(boxStorageProvider).saveFontSize(value);
                    },
                  ),
                ),
              ),
              Text(ref.watch(fontSizeProvider).toStringAsFixed(1)),
            ],
          );
        }
    );
  }
}