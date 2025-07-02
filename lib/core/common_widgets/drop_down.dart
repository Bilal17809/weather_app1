import 'package:ad_english_dictionary/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_flags/country_flags.dart';
import '../../presentations/ai_translator/bloc/translator_cubit.dart';
import '../../presentations/ai_translator/bloc/translator_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class LanguageDropdown extends StatelessWidget {
  final Map<String, String> languageCodes;
  final Map<String, String> languageFlags;
  final bool isFirst;

  const LanguageDropdown({
    required this.languageCodes,
    required this.languageFlags,
    required this.isFirst,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final selectedLanguage = isFirst ? state.selectedLanguage1 : state.selectedLanguage2;

        return  Container(
          decoration: roundedDecoration.copyWith(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: kWhiteEF),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  isFirst
                      ? context.read<LanguageCubit>().updateLanguage1(newValue)
                      : context.read<LanguageCubit>().updateLanguage2(newValue);
                }
              },
              items: languageCodes.keys.map<DropdownMenuItem<String>>((String lang) {
                final countryCode = languageFlags[lang] ?? 'US';
                return DropdownMenuItem<String>(
                  value: lang,
                  child: Row(
                    children: [
                      CountryFlag.fromCountryCode(
                        countryCode,
                        height: 15,
                        width: 20,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lang,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
