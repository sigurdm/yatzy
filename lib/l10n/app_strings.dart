import '../models/yatzy_models.dart';

enum AppLocale {
  da('DA', '🇩🇰', 'Dansk'),
  en('EN', '🇬🇧', 'English'),
  sv('SV', '🇸🇪', 'Svenska'),
  no('NO', '🇳🇴', 'Norsk'),
  fi('FI', '🇫🇮', 'Suomi'),
  is_('IS', '🇮🇸', 'Íslenska'),
  de('DE', '🇩🇪', 'Deutsch'),
  nl('NL', '🇳🇱', 'Nederlands'),
  fr('FR', '🇫🇷', 'Français'),
  es('ES', '🇪🇸', 'Español'),
  it('IT', '🇮🇹', 'Italiano'),
  pl('PL', '🇵🇱', 'Polski');

  final String code;
  final String flag;
  final String nativeName;

  const AppLocale(this.code, this.flag, this.nativeName);
}

class RulesSectionData {
  final String title;
  final List<String> bullets;

  const RulesSectionData({required this.title, required this.bullets});
}

class AppStrings {
  final AppLocale locale;

  const AppStrings(this.locale);

  bool get isDa => locale == AppLocale.da;

  String _pick({
    required String da,
    required String en,
    String? sv,
    String? no,
    String? fi,
    String? is_,
    String? de,
    String? nl,
    String? fr,
    String? es,
    String? it,
    String? pl,
  }) {
    switch (locale) {
      case AppLocale.da:
        return da;
      case AppLocale.en:
        return en;
      case AppLocale.sv:
        return sv ?? en;
      case AppLocale.no:
        return no ?? da;
      case AppLocale.fi:
        return fi ?? en;
      case AppLocale.is_:
        return is_ ?? en;
      case AppLocale.de:
        return de ?? en;
      case AppLocale.nl:
        return nl ?? en;
      case AppLocale.fr:
        return fr ?? en;
      case AppLocale.es:
        return es ?? en;
      case AppLocale.it:
        return it ?? en;
      case AppLocale.pl:
        return pl ?? en;
    }
  }

  // Language Picker
  String get languageDialogTitle => _pick(
        da: 'Vælg sprog',
        en: 'Select Language',
        sv: 'Välj språk',
        no: 'Velg språk',
        fi: 'Valitse kieli',
        is_: 'Veldu tungumál',
        de: 'Sprache wählen',
        nl: 'Kies taal',
        fr: 'Choisir la langue',
        es: 'Seleccionar idioma',
        it: 'Seleziona lingua',
        pl: 'Wybierz język',
      );

  // Header & General
  String diceModeChipLabel(YatzyGameRules rules) {
    final dStr = rules.dieSides == 8 ? 'd8' : 'd6';
    final rStr = rules.maxRolls != 3 ? ' • ${rules.maxRolls}r' : '';
    return '${rules.diceCount}×$dStr$rStr';
  }

  String diceCountChip(int count) => _pick(
        da: '$count terninger',
        en: '$count dice',
        sv: '$count tärningar',
        no: '$count terninger',
        fi: '$count noppaa',
        is_: '$count teningar',
        de: '$count Würfel',
        nl: '$count dobbelstenen',
        fr: '$count dés',
        es: '$count dados',
        it: '$count dadi',
        pl: '$count kości',
      );

  String get switchDiceTooltip => _pick(
        da: 'Vælg spilvariant og se forklaring (Mini 4d6 / Klassisk 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        en: 'Select game variant & view explanation (Mini 4d6 / Classic 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        sv: 'Välj spelvariant och se förklaring (Mini 4d6 / Klassisk 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        no: 'Velg spillvariant og se forklaring (Mini 4d6 / Klassisk 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        fi: 'Valitse pelivariantti ja katso kuvaus (Mini 4d6 / Klassinen 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        is_: 'Veldu leikgerð og sjáðu lýsingu (Míní 4d6 / Klassískt 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        de: 'Spielvariante wählen & Erklärung ansehen (Mini 4d6 / Klassisch 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        nl: 'Kies spelvariant & bekijk uitleg (Mini 4d6 / Klassiek 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        fr: 'Choisir une variante et voir les règles (Mini 4d6 / Classique 5d6 / Maxi 6d6 / Méga 7d6 / d8 / Turbo)',
        es: 'Seleccionar variante y ver explicación (Mini 4d6 / Clásico 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        it: 'Seleziona variante e vedi spiegazione (Mini 4d6 / Classico 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
        pl: 'Wybierz wariant gry i zobacz opis (Mini 4d6 / Klasyczne 5d6 / Maxi 6d6 / Mega 7d6 / d8 / Turbo)',
      );

  String get undoTurn => _pick(
        da: 'Fortryd',
        en: 'Undo',
        sv: 'Ångra',
        no: 'Angre',
        fi: 'Kumoa',
        is_: 'Afturkalla',
        de: 'Rückgängig',
        nl: 'Ongedaan',
        fr: 'Annuler',
        es: 'Deshacer',
        it: 'Annulla',
        pl: 'Cofnij',
      );

  String undoTurnWithCount(int count) =>
      count > 0 ? '$undoTurn ($count)' : undoTurn;

  String get nothingToUndoMessage => _pick(
        da: 'Ingen træk at fortryde endnu! Notér et point på blokken først.',
        en: 'No turns to undo yet! Assign a score on the scorecard first.',
        sv: 'Inga drag att ångra ännu! Skriv in en poäng i protokollet först.',
        no: 'Ingen trekk å angre ennå! Før opp et poeng på blokken først.',
        fi: 'Ei kumottavia vuoroja! Merkitse ensin tulos korttiin.',
        is_: 'Engin umferð til að afturkalla! Skráðu stig á blaðið fyrst.',
        de: 'Noch kein Zug zum Rückgängigmachen! Trage zuerst Punkte ein.',
        nl: 'Nog geen beurt om ongedaan te maken! Vul eerst een score in.',
        fr: 'Aucun tour à annuler ! Inscrivez d\'abord un score sur la feuille.',
        es: '¡Aún no hay jugadas para deshacer! Anota una puntuación primero.',
        it: 'Nessun turno da annullare! Assegna prima un punteggio.',
        pl: 'Brak ruchów do cofnięcia! Najpierw zapisz wynik w tabeli.',
      );

  String undoTooltip(int count) => count > 0
      ? _pick(
          da: 'Fortryd seneste noterede point ($count i historik)',
          en: 'Undo last scored turn ($count in history)',
          sv: 'Ångra senaste poäng ($count i historik)',
          no: 'Angre siste poeng ($count i historikk)',
          fi: 'Kumoa viimeisin tulos ($count muistissa)',
          is_: 'Afturkalla síðasta stig ($count í sögu)',
          de: 'Letzten Eintrag rückgängig machen ($count im Verlauf)',
          nl: 'Laatste score ongedaan maken ($count in geschiedenis)',
          fr: 'Annuler le dernier score ($count en historique)',
          es: 'Deshacer última puntuación ($count en historial)',
          it: 'Annulla ultimo punteggio ($count in cronologia)',
          pl: 'Cofnij ostatni zapisany wynik ($count w historii)',
        )
      : nothingToUndoMessage;

  String playersButton(int count) => _pick(
        da: 'Spillere ($count) / Indstillinger',
        en: 'Players ($count) / Settings',
        sv: 'Spelare ($count) / Inställningar',
        no: 'Spillere ($count) / Innstillinger',
        fi: 'Pelaajat ($count) / Asetukset',
        is_: 'Leikmenn ($count) / Stillingar',
        de: 'Spieler ($count) / Einstellungen',
        nl: 'Spelers ($count) / Instellingen',
        fr: 'Joueurs ($count) / Options',
        es: 'Jugadores ($count) / Ajustes',
        it: 'Giocatori ($count) / Opzioni',
        pl: 'Gracze ($count) / Ustawienia',
      );

  String get playersButtonMobile => _pick(
        da: 'Spiltype & Spillere',
        en: 'Mode & Players',
        sv: 'Variant & Spelare',
        no: 'Variant & Spillere',
        fi: 'Muoto & Pelaajat',
        is_: 'Leikgerð & Leikmenn',
        de: 'Modus & Spieler',
        nl: 'Modus & Spelers',
        fr: 'Mode & Joueurs',
        es: 'Modo y Jugadores',
        it: 'Modalità e Giocatori',
        pl: 'Tryb i Gracze',
      );

  String get rulesButton => _pick(
        da: 'Regler',
        en: 'Rules',
        sv: 'Regler',
        no: 'Regler',
        fi: 'Säännöt',
        is_: 'Reglur',
        de: 'Regeln',
        nl: 'Regels',
        fr: 'Règles',
        es: 'Reglas',
        it: 'Regole',
        pl: 'Zasady',
      );

  String get standingsButton => _pick(
        da: 'Stilling',
        en: 'Standings',
        sv: 'Ställning',
        no: 'Stilling',
        fi: 'Tulokset',
        is_: 'Staða',
        de: 'Tabelle',
        nl: 'Stand',
        fr: 'Classement',
        es: 'Clasificación',
        it: 'Classifica',
        pl: 'Wyniki',
      );

  String defaultPlayerName(int index) {
    final num = index + 1;
    return _pick(
      da: 'Spiller $num',
      en: 'Player $num',
      sv: 'Spelare $num',
      no: 'Spiller $num',
      fi: 'Pelaaja $num',
      is_: 'Leikmaður $num',
      de: 'Spieler $num',
      nl: 'Speler $num',
      fr: 'Joueur $num',
      es: 'Jugador $num',
      it: 'Giocatore $num',
      pl: 'Gracz $num',
    );
  }

  /// Checks if a given player name matches any default localized player name for `index`.
  bool isDefaultPlayerName(String name, int index) {
    for (final loc in AppLocale.values) {
      if (AppStrings(loc).defaultPlayerName(index) == name) {
        return true;
      }
    }
    return false;
  }

  // Undo snackbar
  String undidCategoryForPlayer(String catLabel, String playerName) => _pick(
        da: 'Fortrød $catLabel for $playerName',
        en: 'Undid $catLabel for $playerName',
        sv: 'Ångrade $catLabel för $playerName',
        no: 'Angret $catLabel for $playerName',
        fi: 'Kumottiin $catLabel pelaajalle $playerName',
        is_: 'Afturkallaði $catLabel fyrir $playerName',
        de: '$catLabel für $playerName rückgängig gemacht',
        nl: '$catLabel ongedaan gemaakt voor $playerName',
        fr: '$catLabel annulé pour $playerName',
        es: 'Se deshizo $catLabel para $playerName',
        it: 'Annullato $catLabel per $playerName',
        pl: 'Cofnięto $catLabel dla gracza $playerName',
      );

  // Dice Tray
  String playersTurn(String name) => _pick(
        da: '${name}s tur',
        en: "$name's Turn",
        sv: '${name}s tur',
        no: '${name}s tur',
        fi: 'Vuorossa: $name',
        is_: '$name á leik',
        de: '$name ist am Zug',
        nl: 'Beurt van $name',
        fr: 'Tour de $name',
        es: 'Turno de $name',
        it: 'Turno di $name',
        pl: 'Tura gracza $name',
      );

  String rollCount(int used, int max) {
    if (used == 0) {
      return _pick(
        da: 'Klar til Kast 1/$max',
        en: 'Ready: Roll 1/$max',
        sv: 'Redo för Kast 1/$max',
        no: 'Klar til Kast 1/$max',
        fi: 'Valmis: Heitto 1/$max',
        is_: 'Tilbúin: Kast 1/$max',
        de: 'Bereit: Wurf 1/$max',
        nl: 'Klaar: Worp 1/$max',
        fr: 'Prêt : Lancer 1/$max',
        es: 'Listo: Tirada 1/$max',
        it: 'Pronto: Lancio 1/$max',
        pl: 'Gotowy: Rzut 1/$max',
      );
    }
    return _pick(
      da: 'Kast $used/$max',
      en: 'Roll $used/$max',
      sv: 'Kast $used/$max',
      no: 'Kast $used/$max',
      fi: 'Heitto $used/$max',
      is_: 'Kast $used/$max',
      de: 'Wurf $used/$max',
      nl: 'Worp $used/$max',
      fr: 'Lancer $used/$max',
      es: 'Tirada $used/$max',
      it: 'Lancio $used/$max',
      pl: 'Rzut $used/$max',
    );
  }

  String get releaseAllDice => _pick(
        da: 'Frigiv alle',
        en: 'Release all',
        sv: 'Släpp alla',
        no: 'Frigi alle',
        fi: 'Vapauta kaikki',
        is_: 'Losa alla',
        de: 'Alle freigeben',
        nl: 'Alles vrijgeven',
        fr: 'Tout libérer',
        es: 'Soltar todos',
        it: 'Rilascia tutti',
        pl: 'Zwolnij wszystkie',
      );

  String get holdAllDice => _pick(
        da: 'Hold alle',
        en: 'Hold all',
        sv: 'Spara alla',
        no: 'Hold alle',
        fi: 'Lukitse kaikki',
        is_: 'Geyma alla',
        de: 'Alle halten',
        nl: 'Alles vasthouden',
        fr: 'Tout garder',
        es: 'Guardar todos',
        it: 'Tieni tutti',
        pl: 'Zatrzymaj wszystkie',
      );

  String get dieHeldBadge => _pick(
        da: 'HOLDT',
        en: 'HELD',
        sv: 'SPARAD',
        no: 'HOLDT',
        fi: 'LUKITTU',
        is_: 'GEYMDUR',
        de: 'GEHALTEN',
        nl: 'VAST',
        fr: 'GARDÉ',
        es: 'GUARDADO',
        it: 'TENUTO',
        pl: 'ZATRZYMANA',
      );

  String get dieHoldHint => _pick(
        da: 'hold',
        en: 'hold',
        sv: 'spara',
        no: 'hold',
        fi: 'lukitse',
        is_: 'geyma',
        de: 'halten',
        nl: 'vast',
        fr: 'garder',
        es: 'guardar',
        it: 'tieni',
        pl: 'zatrzymaj',
      );

  String rollButtonLabel({
    required int rollsUsed,
    required int rollsLeft,
    required bool allHeld,
    required int unheldCount,
    required int totalDiceCount,
  }) {
    if (rollsUsed == 0) {
      return _pick(
        da: 'Start tur — Kast alle $totalDiceCount',
        en: 'Start Turn — Roll All $totalDiceCount',
        sv: 'Starta tur — Kasta alla $totalDiceCount',
        no: 'Start tur — Kast alle $totalDiceCount',
        fi: 'Aloita vuoro — Heitä $totalDiceCount',
        is_: 'Hefja umferð — Kasta $totalDiceCount',
        de: 'Zug starten — Alle $totalDiceCount würfeln',
        nl: 'Start beurt — Gooi alle $totalDiceCount',
        fr: 'Démarrer — Lancer les $totalDiceCount dés',
        es: 'Empezar turno — Tirar $totalDiceCount dados',
        it: 'Inizia turno — Lancia $totalDiceCount dadi',
        pl: 'Rozpocznij turę — Rzuć ($totalDiceCount)',
      );
    }
    if (rollsLeft <= 0) {
      return _pick(
        da: 'Ingen kast tilbage',
        en: 'No Rolls Left',
        sv: 'Inga kast kvar',
        no: 'Ingen kast igjen',
        fi: 'Ei heittoja jäljellä',
        is_: 'Engin köst eftir',
        de: 'Keine Würfe übrig',
        nl: 'Geen worpen over',
        fr: 'Plus de lancers',
        es: 'Sin tiradas',
        it: 'Nessun lancio rimasto',
        pl: 'Brak rzutów',
      );
    }
    if (allHeld) {
      return _pick(
        da: 'Alle holdt',
        en: 'All Dice Held',
        sv: 'Alla sparade',
        no: 'Alle holdt',
        fi: 'Kaikki lukittu',
        is_: 'Allir geymdir',
        de: 'Alle gehalten',
        nl: 'Alles vastgehouden',
        fr: 'Tous les dés gardés',
        es: 'Todos guardados',
        it: 'Tutti i dadi tenuti',
        pl: 'Wszystkie zatrzymane',
      );
    }
    if (unheldCount == totalDiceCount) {
      return _pick(
        da: 'Kast alle $totalDiceCount',
        en: 'Roll All $totalDiceCount',
        sv: 'Kasta alla $totalDiceCount',
        no: 'Kast alle $totalDiceCount',
        fi: 'Heitä kaikki $totalDiceCount',
        is_: 'Kasta öllum $totalDiceCount',
        de: 'Alle $totalDiceCount würfeln',
        nl: 'Gooi alle $totalDiceCount',
        fr: 'Lancer les $totalDiceCount dés',
        es: 'Tirar los $totalDiceCount dados',
        it: 'Lancia tutti i $totalDiceCount dadi',
        pl: 'Rzuć wszystkimi ($totalDiceCount)',
      );
    }
    return _pick(
      da: 'Kast $unheldCount terninger',
      en: 'Roll $unheldCount Dice',
      sv: 'Kasta $unheldCount tärningar',
      no: 'Kast $unheldCount terninger',
      fi: 'Heitä $unheldCount noppaa',
      is_: 'Kasta $unheldCount teningum',
      de: '$unheldCount Würfel werfen',
      nl: 'Gooi $unheldCount dobbelstenen',
      fr: 'Lancer $unheldCount dés',
      es: 'Tirar $unheldCount dados',
      it: 'Lancia $unheldCount dadi',
      pl: 'Rzuć kośćmi ($unheldCount)',
    );
  }

  String rollButtonSubtext({
    required int rollsUsed,
    required int rollsLeft,
    required int maxRolls,
    required bool allHeld,
  }) {
    if (rollsUsed == 0) {
      return _pick(
        da: 'Kast 1 af $maxRolls (forrige score er markeret)',
        en: 'Roll 1 of $maxRolls (previous score highlighted)',
        sv: 'Kast 1 av $maxRolls (föregående poäng markerad)',
        no: 'Kast 1 av $maxRolls (forrige poeng markert)',
        fi: 'Heitto 1/$maxRolls (edellinen tulos korostettu)',
        is_: 'Kast 1 af $maxRolls (síðasta stig merkt)',
        de: 'Wurf 1 von $maxRolls (letzter Eintrag markiert)',
        nl: 'Worp 1 van $maxRolls (vorige score gemarkeerd)',
        fr: 'Lancer 1 sur $maxRolls (score précédent surligné)',
        es: 'Tirada 1 de $maxRolls (puntuación anterior resaltada)',
        it: 'Lancio 1 di $maxRolls (punteggio precedente evidenziato)',
        pl: 'Rzut 1 z $maxRolls (poprzedni wynik podświetlony)',
      );
    }
    if (rollsLeft <= 0) {
      return _pick(
        da: 'Vælg en række',
        en: 'Pick a score row',
        sv: 'Välj en rad i protokollet',
        no: 'Velg en rad på blokken',
        fi: 'Valitse tulosrivi',
        is_: 'Veldu reit á blaðinu',
        de: 'Wähle eine Zeile im Block',
        nl: 'Kies een scorevak',
        fr: 'Choisissez une ligne',
        es: 'Elige una casilla',
        it: 'Scegli una riga',
        pl: 'Wybierz kategorię w tabeli',
      );
    }
    if (allHeld) {
      return _pick(
        da: 'Frigiv for at kaste ($rollsLeft tilbage)',
        en: 'Unhold to roll ($rollsLeft left)',
        sv: 'Släpp tärning för att kasta ($rollsLeft kvar)',
        no: 'Frigi for å kaste ($rollsLeft igjen)',
        fi: 'Vapauta heittääksesi ($rollsLeft jäljellä)',
        is_: 'Losaðu tening til að kasta ($rollsLeft eftir)',
        de: 'Freigeben zum Würfeln ($rollsLeft übrig)',
        nl: 'Geef vrij om te gooien ($rollsLeft over)',
        fr: 'Libérez pour relancer ($rollsLeft rest.)',
        es: 'Suelta para tirar ($rollsLeft rest.)',
        it: 'Rilascia per lanciare ($rollsLeft rim.)',
        pl: 'Odblokuj, aby rzucić (zostało: $rollsLeft)',
      );
    }
    return _pick(
      da: '$rollsLeft kast tilbage',
      en: '$rollsLeft ${rollsLeft == 1 ? "roll" : "rolls"} left',
      sv: '$rollsLeft kast kvar',
      no: '$rollsLeft kast igjen',
      fi: '$rollsLeft heittoa jäljellä',
      is_: '$rollsLeft köst eftir',
      de: 'Noch $rollsLeft ${rollsLeft == 1 ? "Wurf" : "Würfe"}',
      nl: 'Nog $rollsLeft ${rollsLeft == 1 ? "worp" : "worpen"}',
      fr: '$rollsLeft ${rollsLeft == 1 ? "lancer restant" : "lancers restants"}',
      es: '$rollsLeft ${rollsLeft == 1 ? "tirada restante" : "tiradas restantes"}',
      it: '$rollsLeft ${rollsLeft == 1 ? "lancio rimasto" : "lanci rimasti"}',
      pl: 'Pozostało rzutów: $rollsLeft',
    );
  }

  String trayHelperNote(int rollsUsed, int rollsLeft, int maxRolls) {
    if (rollsUsed == 0) {
      return _pick(
        da: '✎ Seneste score er markeret med grønt på blokken • Tryk Kast for at rulle terningerne til din tur!',
        en: '✎ Latest score is highlighted in green below • Press Roll to roll the dice for your turn!',
        sv: '✎ Senaste poäng är grönmarkerad nedan • Tryck Kasta för att slå tärningarna för din tur!',
        no: '✎ Siste poeng er markert med grønt nedenfor • Trykk Kast for å trille terningene for din tur!',
        fi: '✎ Viimeisin tulos on korostettu vihreällä alla • Aloita vuorosi painamalla Heitä!',
        is_: '✎ Síðasta stig er merkt með grænu að neðan • Ýttu á Kasta til að hefja þína umferð!',
        de: '✎ Letzter Eintrag ist unten grün markiert • Drücke Würfeln, um deinen Zug zu starten!',
        nl: '✎ Laatste score is hieronder groen gemarkeerd • Druk op Gooi om je beurt te starten!',
        fr: '✎ Le dernier score est surligné en vert ci-dessous • Appuyez sur Lancer pour votre tour !',
        es: '✎ La última puntuación está resaltada en verde abajo • ¡Pulsa Tirar para iniciar tu turno!',
        it: '✎ L\'ultimo punteggio è evidenziato in verde qui sotto • Premi Lancia per iniziare il tuo turno!',
        pl: '✎ Ostatni wynik jest podświetlony na zielono poniżej • Naciśnij Rzuć, aby rozpocząć swoją turę!',
      );
    }
    if (rollsLeft > 0) {
      return _pick(
        da: '✎ Klik terninger for at HOLDE • Tryk Kast for at rulle resten • Klik på en ledig række for at notere point!',
        en: '✎ Tap dice to HOLD • Press Roll to reroll unheld dice • Click any open row below to score!',
        sv: '✎ Klicka på tärningar för att SPARA • Tryck Kasta för att slå om resten • Klicka på en ledig rad för att poängsätta!',
        no: '✎ Klikk terninger for å HOLDE • Trykk Kast for å trille resten • Klikk på en ledig rad for å notere poeng!',
        fi: '✎ Lukitse noppia napauttamalla • Heitä loput painamalla Heitä • Merkitse tulos napauttamalla vapaata riviä!',
        is_: '✎ Smelltu á teninga til að GEYMA • Ýttu á Kasta til að kasta hinum • Smelltu á lausa línu til að skrá stig!',
        de: '✎ Würfel antippen zum HALTEN • Würfeln drücken für den Rest • Beliebige freie Zeile unten antippen zum Eintragen!',
        nl: '✎ Tik op dobbelstenen om VAST te houden • Druk op Gooi voor de rest • Klik op een open vak om te scoren!',
        fr: '✎ Touchez les dés pour les GARDER • Appuyez sur Lancer • Cliquez sur une ligne libre ci-dessous pour marquer !',
        es: '✎ Toca los dados para GUARDAR • Pulsa Tirar para el resto • ¡Haz clic en cualquier fila libre para anotar!',
        it: '✎ Tocca i dadi per TENERE • Premi Lancia per il resto • Clicca su una riga libera in basso per segnare i punti!',
        pl: '✎ Kliknij kości, aby ZATRZYMAĆ • Naciśnij Rzuć, aby przerzucić resztę • Kliknij wolny wiersz, aby zapisać punkty!',
      );
    }
    return _pick(
      da: '✎ Alle $maxRolls kast er brugt! Klik på en ledig række i din kolonne for at notere dine point.',
      en: '✎ All $maxRolls rolls used! Click any open row in your column below to assign your score.',
      sv: '✎ Alla $maxRolls kast är använda! Klicka på en ledig rad i din kolumn för att skriva in dina poäng.',
      no: '✎ Alle $maxRolls kast er brukt! Klikk på en ledig rad i kolonnen din for å føre opp poeng.',
      fi: '✎ Kaikki $maxRolls heittoa käytetty! Valitse vapaa rivi omasta sarakkeestasi merkitäksesi tuloksen.',
      is_: '✎ Öll $maxRolls köstin búin! Smelltu á lausa línu í dálkinum þínum til að skrá stigin.',
      de: '✎ Alle $maxRolls Würfe verbraucht! Tippe unten in deiner Spalte auf eine freie Zeile, um die Punkte einzutragen.',
      nl: '✎ Alle $maxRolls worpen gebruikt! Klik op een open vak in je kolom om je score in te vullen.',
      fr: '✎ Les $maxRolls lancers sont utilisés ! Cliquez sur une case libre de votre colonne pour inscrire votre score.',
      es: '✎ ¡Has usado las $maxRolls tiradas! Haz clic en una fila libre de tu columna para anotar tu puntuación.',
      it: '✎ Tutti i $maxRolls lanci usati! Clicca su una riga libera nella tua colonna per assegnare il punteggio.',
      pl: '✎ Wykorzystano wszystkie $maxRolls rzuty! Kliknij wolny wiersz w swojej kolumnie, aby przypisać wynik.',
    );
  }

  // Scorecard
  String get scorecardTitle => _pick(
        da: 'POINTBLOK',
        en: 'SCORECARD',
        sv: 'PROTOKOLL',
        no: 'POENGBLOKK',
        fi: 'TULOSKORTTI',
        is_: 'STIGABLAÐ',
        de: 'SPIELBLOCK',
        nl: 'SCOREBLOK',
        fr: 'FEUILLE DE SCORE',
        es: 'TABLA DE PUNTOS',
        it: 'SEGNAPUNTI',
        pl: 'KARTA WYNIKÓW',
      );

  String filledCount(int filled, int total) => '$filled/$total';

  String upperSectionBanner(int parCount) => _pick(
        da: 'ØVERSTE SEKTION (± omkring $parCount ens • Samlet ≥ 0 giver +50p Bonus)',
        en: 'UPPER SECTION (± around $parCount of a kind • Total ≥ 0 gives +50p Bonus)',
        sv: 'ÖVRE SEKTION (± runt $parCount lika • Totalt ≥ 0 ger +50p Bonus)',
        no: 'ØVRE DEL (± rundt $parCount like • Totalt ≥ 0 gir +50p Bonus)',
        fi: 'YLÄOSA (± $parCount samanlaista • Yhteensä ≥ 0 antaa +50p Bonuksen)',
        is_: 'EFRI HLUTI (± miðað við $parCount eins • Samtals ≥ 0 gefur +50p Bónus)',
        de: 'OBERER TEIL (± um $parCount Gleiche • Summe ≥ 0 gibt +50p Bonus)',
        nl: 'BOVENSTE HELFT (± rond $parCount dezelfde • Totaal ≥ 0 geeft +50p Bonus)',
        fr: 'SECTION SUPÉRIEURE (± autour de $parCount identiques • Total ≥ 0 donne +50p Bonus)',
        es: 'SECCIÓN SUPERIOR (± sobre $parCount iguales • Total ≥ 0 da +50p Bono)',
        it: 'SEZIONE SUPERIORE (± rispetto a $parCount uguali • Totale ≥ 0 dà +50p Bonus)',
        pl: 'GÓRNA SEKCJA (± wokół $parCount jednakowych • Suma ≥ 0 daje +50p Bonusu)',
      );

  String get upperSectionBannerMobile => _pick(
        da: 'ØVERSTE (± par)',
        en: 'UPPER (± par)',
        sv: 'ÖVRE (± par)',
        no: 'ØVRE (± par)',
        fi: 'YLÄOSA (± par)',
        is_: 'EFRI (± par)',
        de: 'OBEN (± Par)',
        nl: 'BOVEN (± par)',
        fr: 'SUPÉRIEUR (± par)',
        es: 'SUPERIOR (± par)',
        it: 'SUPERIORE (± par)',
        pl: 'GÓRNA (± par)',
      );

  String lowerSectionBanner(int diceCount, int dieSides) {
    final dieTag = dieSides == 8 ? '$diceCount×d8' : '$diceCount';
    return _pick(
      da: 'NEDERSTE SEKTION ($dieTag-terningers Yatzy & Spezial-kombinationer)',
      en: 'LOWER SECTION ($dieTag-Dice Yatzy & Special Combinations)',
      sv: 'NEDRE SEKTION ($dieTag tärningar Yatzy & Specialkombinationer)',
      no: 'NEDRE DEL ($dieTag terninger Yatzy & Spesialkombinasjoner)',
      fi: 'ALAOSA ($dieTag nopan Yatzy & Erikoisyhdistelmät)',
      is_: 'NEÐRI HLUTI ($dieTag teninga Yatzy & Sérsamsetningar)',
      de: 'UNTERER TEIL ($dieTag-Würfel Yatzy & Spezialkombinationen)',
      nl: 'ONDERSTE HELFT ($dieTag-dobbelstenen Yatzy & Speciale combinaties)',
      fr: 'SECTION INFÉRIEURE (Yatzy à $dieTag dés & Combinaisons spéciales)',
      es: 'SECCIÓN INFERIOR (Yatzy de $dieTag dados y Combinaciones especiales)',
      it: 'SEZIONE INFERIORE (Yatzy a $dieTag dadi e Combinazioni speciali)',
      pl: 'DOLNA SEKCJA (Yatzy na $dieTag kości i Układy specjalne)',
    );
  }

  String get lowerSectionBannerMobile => _pick(
        da: 'NEDERSTE SEKTION',
        en: 'LOWER SECTION',
        sv: 'NEDRE SEKTION',
        no: 'NEDRE DEL',
        fi: 'ALAOSA',
        is_: 'NEÐRI HLUTI',
        de: 'UNTERER TEIL',
        nl: 'ONDERSTE HELFT',
        fr: 'SECTION INF.',
        es: 'SECCIÓN INF.',
        it: 'SEZIONE INF.',
        pl: 'DOLNA SEKCJA',
      );

  String get pointsAboveBonusTitle => _pick(
        da: 'Point over bonus (±)',
        en: 'Points above bonus (±)',
        sv: 'Poäng över bonus (±)',
        no: 'Poeng over bonus (±)',
        fi: 'Pisteet yli bonuksen (±)',
        is_: 'Stig yfir bónus (±)',
        de: 'Punkte über Bonus (±)',
        nl: 'Punten boven bonus (±)',
        fr: 'Points sur bonus (±)',
        es: 'Puntos sobre bono (±)',
        it: 'Punti sopra bonus (±)',
        pl: 'Punkty nad bonusem (±)',
      );

  String get pointsAboveBonusSub => _pick(
        da: 'Sum af ± ovenfor (≥ 0 giver Bonus)',
        en: 'Sum of ± above (≥ 0 gives Bonus)',
        sv: 'Summa ± ovan (≥ 0 ger Bonus)',
        no: 'Sum av ± ovenfor (≥ 0 gir Bonus)',
        fi: 'Yllä olevien ± summa (≥ 0 antaa Bonuksen)',
        is_: 'Summa ± að ofan (≥ 0 gefur Bónus)',
        de: 'Summe der ± oben (≥ 0 gibt Bonus)',
        nl: 'Som van ± hierboven (≥ 0 geeft Bonus)',
        fr: 'Somme des ± ci-dessus (≥ 0 donne Bonus)',
        es: 'Suma de ± arriba (≥ 0 da Bono)',
        it: 'Somma dei ± sopra (≥ 0 dà Bonus)',
        pl: 'Suma ± powyżej (≥ 0 daje Bonus)',
      );

  String upperBonusTitle(int bonus) => _pick(
        da: 'Bonus (${bonus}p)',
        en: 'Upper Bonus (${bonus}p)',
        sv: 'Bonus (${bonus}p)',
        no: 'Bonus (${bonus}p)',
        fi: 'Bonus (${bonus}p)',
        is_: 'Bónus (${bonus}p)',
        de: 'Bonus (${bonus}p)',
        nl: 'Bonus (${bonus}p)',
        fr: 'Bonus (${bonus}p)',
        es: 'Bono (${bonus}p)',
        it: 'Bonus (${bonus}p)',
        pl: 'Bonus (${bonus}p)',
      );

  String upperBonusSub(int bonus) => _pick(
        da: '$bonus point ved ± sum på 0 eller mere',
        en: '$bonus points if ± sum is 0 or more',
        sv: '$bonus poäng vid ± summa 0 eller mer',
        no: '$bonus poeng ved ± sum på 0 eller mer',
        fi: '$bonus pistettä jos ± summa on vähintään 0',
        is_: '$bonus stig ef ± summa er 0 eða hærri',
        de: '$bonus Punkte bei ± Summe von 0 oder mehr',
        nl: '$bonus punten bij ± som van 0 of meer',
        fr: '$bonus points si la somme ± est 0 ou plus',
        es: '$bonus puntos si la suma ± es 0 o más',
        it: '$bonus punti se la somma ± è 0 o più',
        pl: '$bonus punktów przy sumie ± równej 0 lub więcej',
      );

  String bonusStatusText({
    required bool earned,
    required bool allUpperFilled,
    required bool canStillEarn,
    required int upperDiffSum,
    int bonusPoints = 50,
  }) {
    if (earned) return '+$bonusPoints';
    if (allUpperFilled || !canStillEarn) return '0';
    if (upperDiffSum >= 0) {
      return _pick(
        da: 'på vej ($bonusPoints)',
        en: 'on track ($bonusPoints)',
        sv: 'på väg ($bonusPoints)',
        no: 'på vei ($bonusPoints)',
        fi: 'tulossa ($bonusPoints)',
        is_: 'á réttri leið ($bonusPoints)',
        de: 'auf Kurs ($bonusPoints)',
        nl: 'op koers ($bonusPoints)',
        fr: 'en bonne voie ($bonusPoints)',
        es: 'en camino ($bonusPoints)',
        it: 'in linea ($bonusPoints)',
        pl: 'na dobrej drodze ($bonusPoints)',
      );
    }
    final need = -upperDiffSum;
    return _pick(
      da: 'mangler +$need',
      en: 'need +$need',
      sv: 'saknar +$need',
      no: 'mangler +$need',
      fi: 'tarvitaan +$need',
      is_: 'vantar +$need',
      de: 'noch +$need',
      nl: 'nog +$need',
      fr: 'manque +$need',
      es: 'faltan +$need',
      it: 'mancano +$need',
      pl: 'brakuje +$need',
    );
  }

  String get grandTotalTitle => _pick(
        da: 'SAMLET SUM',
        en: 'GRAND TOTAL',
        sv: 'TOTALSUMMA',
        no: 'TOTALSUM',
        fi: 'LOPPUTULOS',
        is_: 'HEILDARTALA',
        de: 'GESAMTSUMME',
        nl: 'TOTAALSCORE',
        fr: 'TOTAL GÉNÉRAL',
        es: 'TOTAL GENERAL',
        it: 'TOTALE GENERALE',
        pl: 'SUMA CAŁKOWITA',
      );

  String grandTotalSub(int parTotal) => _pick(
        da: '$parTotal + Øverste(±) + Bonus + Nederste',
        en: '$parTotal + Upper(±) + Bonus + Lower',
        sv: '$parTotal + Övre(±) + Bonus + Nedre',
        no: '$parTotal + Øvre(±) + Bonus + Nedre',
        fi: '$parTotal + Yläosa(±) + Bonus + Alaosa',
        is_: '$parTotal + Efri(±) + Bónus + Neðri',
        de: '$parTotal + Oben(±) + Bonus + Unten',
        nl: '$parTotal + Boven(±) + Bonus + Onder',
        fr: '$parTotal + Sup(±) + Bonus + Inf',
        es: '$parTotal + Sup(±) + Bono + Inf',
        it: '$parTotal + Sup(±) + Bonus + Inf',
        pl: '$parTotal + Góra(±) + Bonus + Dół',
      );

  String grandTotalTooltip({
    required int parTotal,
    required bool allUpperFilled,
    required String diffStr,
    required int rawUpperPoints,
    required int bonusPoints,
    required int lowerSum,
    required int grandTotal,
  }) {
    if (allUpperFilled) {
      return '$parTotal (par) $diffStr + $bonusPoints (bonus) + $lowerSum = $grandTotal';
    }
    return _pick(
      da: 'Øverste: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Nederste: $lowerSum = $grandTotal',
      en: 'Upper: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Lower: $lowerSum = $grandTotal',
      sv: 'Övre: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Nedre: $lowerSum = $grandTotal',
      no: 'Øvre: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Nedre: $lowerSum = $grandTotal',
      fi: 'Yläosa: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Alaosa: $lowerSum = $grandTotal',
      is_: 'Efri: $rawUpperPoints (par $parTotal $diffStr) + Bónus: $bonusPoints + Neðri: $lowerSum = $grandTotal',
      de: 'Oben: $rawUpperPoints (Par $parTotal $diffStr) + Bonus: $bonusPoints + Unten: $lowerSum = $grandTotal',
      nl: 'Boven: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Onder: $lowerSum = $grandTotal',
      fr: 'Sup.: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Inf.: $lowerSum = $grandTotal',
      es: 'Sup.: $rawUpperPoints (par $parTotal $diffStr) + Bono: $bonusPoints + Inf.: $lowerSum = $grandTotal',
      it: 'Sup.: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Inf.: $lowerSum = $grandTotal',
      pl: 'Góra: $rawUpperPoints (par $parTotal $diffStr) + Bonus: $bonusPoints + Dół: $lowerSum = $grandTotal',
    );
  }

  // Category names
  String categoryLabel(YatzyCategory cat, {YatzyGameRules? rules}) {
    switch (cat) {
      case YatzyCategory.ones:
        return _pick(
          da: "1'ere",
          en: 'Ones',
          sv: 'Ettor',
          no: 'Enere',
          fi: 'Ykköset',
          is_: 'Ásar',
          de: 'Einser',
          nl: 'Enen',
          fr: 'As (1)',
          es: 'Unos',
          it: 'Uno',
          pl: 'Jedynki',
        );
      case YatzyCategory.twos:
        return _pick(
          da: "2'ere",
          en: 'Twos',
          sv: 'Tvåor',
          no: 'Toere',
          fi: 'Kakkoset',
          is_: 'Tvistar',
          de: 'Zweier',
          nl: 'Tweeën',
          fr: 'Deux (2)',
          es: 'Doses',
          it: 'Due',
          pl: 'Dwójki',
        );
      case YatzyCategory.threes:
        return _pick(
          da: "3'ere",
          en: 'Threes',
          sv: 'Treor',
          no: 'Treere',
          fi: 'Kolmoset',
          is_: 'Þristar',
          de: 'Dreier',
          nl: 'Drieën',
          fr: 'Trois (3)',
          es: 'Treses',
          it: 'Tre',
          pl: 'Trójki',
        );
      case YatzyCategory.fours:
        return _pick(
          da: "4'ere",
          en: 'Fours',
          sv: 'Fyror',
          no: 'Firere',
          fi: 'Neloset',
          is_: 'Fjarkar',
          de: 'Vierer',
          nl: 'Vieren',
          fr: 'Quatre (4)',
          es: 'Cuatros',
          it: 'Quattro',
          pl: 'Czwórki',
        );
      case YatzyCategory.fives:
        return _pick(
          da: "5'ere",
          en: 'Fives',
          sv: 'Femmor',
          no: 'Femmere',
          fi: 'Viitoset',
          is_: 'Fimmur',
          de: 'Fünfer',
          nl: 'Vijven',
          fr: 'Cinq (5)',
          es: 'Cincos',
          it: 'Cinque',
          pl: 'Piątki',
        );
      case YatzyCategory.sixes:
        return _pick(
          da: "6'ere",
          en: 'Sixes',
          sv: 'Sexor',
          no: 'Seksere',
          fi: 'Kuutoset',
          is_: 'Sexur',
          de: 'Sechser',
          nl: 'Zessen',
          fr: 'Six (6)',
          es: 'Seises',
          it: 'Sei',
          pl: 'Szóstki',
        );
      case YatzyCategory.sevens:
        return _pick(
          da: "7'ere",
          en: 'Sevens',
          sv: 'Sjuor',
          no: 'Syvere',
          fi: 'Seiskat',
          is_: 'Sjöur',
          de: 'Siebener',
          nl: 'Zevens',
          fr: 'Sept (7)',
          es: 'Sietes',
          it: 'Sette',
          pl: 'Siódemki',
        );
      case YatzyCategory.eights:
        return _pick(
          da: "8'ere",
          en: 'Eights',
          sv: 'Åttor',
          no: 'Åttere',
          fi: 'Kasit',
          is_: 'Áttur',
          de: 'Achter',
          nl: 'Achten',
          fr: 'Huit (8)',
          es: 'Ochos',
          it: 'Otto',
          pl: 'Ósemki',
        );
      case YatzyCategory.nines:
        return _pick(
          da: "9'ere",
          en: 'Nines',
          sv: 'Nior',
          no: 'Niere',
          fi: 'Ysit',
          is_: 'Níur',
          de: 'Neuner',
          nl: 'Negens',
          fr: 'Neuf (9)',
          es: 'Nueves',
          it: 'Nove',
          pl: 'Dziewiątki',
        );
      case YatzyCategory.tens:
        return _pick(
          da: "10'ere",
          en: 'Tens',
          sv: 'Tior',
          no: 'Tiere',
          fi: 'Kympit',
          is_: 'Tíur',
          de: 'Zehner',
          nl: 'Tienen',
          fr: 'Dix (10)',
          es: 'Dieces',
          it: 'Dieci',
          pl: 'Dziesiątki',
        );
      case YatzyCategory.elevens:
        return _pick(
          da: "11'ere",
          en: 'Elevens',
          sv: 'Elvor',
          no: 'Ellevere',
          fi: 'Yksitoistaset',
          is_: 'Ellefur',
          de: 'Elfer',
          nl: 'Elven',
          fr: 'Onze (11)',
          es: 'Onces',
          it: 'Undici',
          pl: 'Jedenastki',
        );
      case YatzyCategory.twelves:
        return _pick(
          da: "12'ere",
          en: 'Twelves',
          sv: 'Tolvor',
          no: 'Tolvere',
          fi: 'Kaksitoistaset',
          is_: 'Tólfur',
          de: 'Zwölfer',
          nl: 'Twaalven',
          fr: 'Douze (12)',
          es: 'Doces',
          it: 'Dodici',
          pl: 'Dwunastki',
        );
      case YatzyCategory.twenties:
        return _pick(
          da: "20'ere (Nat 20)",
          en: 'Twenties (Nat 20)',
          sv: 'Tjugor (Nat 20)',
          no: 'Tyvere (Nat 20)',
          fi: 'Kaksikymppiset (20)',
          is_: 'Tuttugur (Nat 20)',
          de: 'Zwanziger (Nat 20)',
          nl: 'Twintigen (Nat 20)',
          fr: 'Vingt (Nat 20)',
          es: 'Veintes (Nat 20)',
          it: 'Venti (Nat 20)',
          pl: 'Dwudziestki (Nat 20)',
        );
      case YatzyCategory.onePair:
        return _pick(
          da: '1 par',
          en: 'One Pair',
          sv: 'Ett par',
          no: '1 par',
          fi: 'Yksi pari',
          is_: 'Eitt par',
          de: 'Ein Paar',
          nl: 'Één paar',
          fr: 'Une paire',
          es: 'Una pareja',
          it: 'Una coppia',
          pl: 'Jedna para',
        );
      case YatzyCategory.twoPairs:
        return _pick(
          da: '2 par',
          en: 'Two Pairs',
          sv: 'Två par',
          no: '2 par',
          fi: 'Kaksi paria',
          is_: 'Tvö pör',
          de: 'Zwei Paare',
          nl: 'Twee paar',
          fr: 'Deux paires',
          es: 'Dos parejas',
          it: 'Doppia coppia',
          pl: 'Dwie pary',
        );
      case YatzyCategory.threePairs:
        return _pick(
          da: '3 par',
          en: 'Three Pairs',
          sv: 'Tre par',
          no: '3 par',
          fi: 'Kolme paria',
          is_: 'Þrjú pör',
          de: 'Drei Paare',
          nl: 'Drie paar',
          fr: 'Trois paires',
          es: 'Tres parejas',
          it: 'Tre coppie',
          pl: 'Trzy pary',
        );
      case YatzyCategory.threeOfAKind:
        return _pick(
          da: '3 ens',
          en: 'Three of a Kind',
          sv: 'Tretal',
          no: '3 like',
          fi: 'Kolme samaa',
          is_: 'Þrenna',
          de: 'Drilling',
          nl: 'Three of a Kind',
          fr: 'Brelan',
          es: 'Trío',
          it: 'Tris',
          pl: 'Trójka',
        );
      case YatzyCategory.fourOfAKind:
        return _pick(
          da: '4 ens',
          en: 'Four of a Kind',
          sv: 'Fyrtal',
          no: '4 like',
          fi: 'Neljä samaa',
          is_: 'Ferna',
          de: 'Vierling',
          nl: 'Carré (4 dezelfde)',
          fr: 'Carré',
          es: 'Póker (4 iguales)',
          it: 'Poker (4 uguali)',
          pl: 'Kareta (4 jednakowe)',
        );
      case YatzyCategory.fiveOfAKind:
        return _pick(
          da: '5 ens',
          en: 'Five of a Kind',
          sv: 'Femtal',
          no: '5 like',
          fi: 'Viisi samaa',
          is_: 'Fimma',
          de: 'Fünfling',
          nl: 'Vijf dezelfde',
          fr: 'Cinq identiques',
          es: 'Cinco iguales',
          it: 'Cinque uguali',
          pl: 'Pięć jednakowych',
        );
      case YatzyCategory.sixOfAKind:
        return _pick(
          da: '6 ens',
          en: 'Six of a Kind',
          sv: 'Sextal',
          no: '6 like',
          fi: 'Kuusi samaa',
          is_: 'Sex eins',
          de: 'Sechsling',
          nl: 'Zes dezelfde',
          fr: 'Six identiques',
          es: 'Seis iguales',
          it: 'Sei uguali',
          pl: 'Sześć jednakowych',
        );
      case YatzyCategory.smallStraight:
        return _pick(
          da: 'Lille straight',
          en: 'Small Straight',
          sv: 'Liten stege',
          no: 'Liten straight',
          fi: 'Pieni suora',
          is_: 'Lítil röð',
          de: 'Kleine Straße',
          nl: 'Kleine straat',
          fr: 'Petite suite',
          es: 'Escalera menor',
          it: 'Scala piccola',
          pl: 'Mały strit',
        );
      case YatzyCategory.largeStraight:
        return _pick(
          da: 'Stor straight',
          en: 'Large Straight',
          sv: 'Stor stege',
          no: 'Stor straight',
          fi: 'Suuri suora',
          is_: 'Stór röð',
          de: 'Große Straße',
          nl: 'Grote straat',
          fr: 'Grande suite',
          es: 'Escalera mayor',
          it: 'Scala grande',
          pl: 'Duży strit',
        );
      case YatzyCategory.fullStraight:
        return _pick(
          da: 'Fuld straight',
          en: 'Full Straight',
          sv: 'Full stege',
          no: 'Full straight',
          fi: 'Täysi suora',
          is_: 'Full röð',
          de: 'Volle Straße',
          nl: 'Volle straat',
          fr: 'Suite complète',
          es: 'Escalera completa',
          it: 'Scala completa',
          pl: 'Pełny strit',
        );
      case YatzyCategory.royalStraight:
        return _pick(
          da: 'Royal straight (6 i træk)',
          en: 'Royal Straight (6 in row)',
          sv: 'Kunglig stege (6 i rad)',
          no: 'Royal straight (6 på rad)',
          fi: 'Kuningassuora (6 peräkkäin)',
          is_: 'Konungsröð (6 í röð)',
          de: 'Königsstraße (6 in Folge)',
          nl: 'Koningsstraat (6 op rij)',
          fr: 'Suite Royale (6 de suite)',
          es: 'Escalera Real (6 seguidos)',
          it: 'Scala Reale (6 di fila)',
          pl: 'Królewski strit (6 z rzędu)',
        );
      case YatzyCategory.fullHouse:
        return _pick(
          da: 'Fuldt hus',
          en: 'Full House',
          sv: 'Kåk',
          no: 'Hus',
          fi: 'Täyskäsi',
          is_: 'Fullt hús',
          de: 'Full House',
          nl: 'Full House',
          fr: 'Full',
          es: 'Full House',
          it: 'Full',
          pl: 'Ful (3+2)',
        );
      case YatzyCategory.villa:
        return _pick(
          da: 'Villa (2×3 ens)',
          en: 'Villa (2×3 of a Kind)',
          sv: 'Villa (2×tretal)',
          no: 'Hytta (2×3 like)',
          fi: 'Huvila (2×3 samaa)',
          is_: 'Villa (2×þrenna)',
          de: 'Villa (2×Drilling)',
          nl: 'Villa (2×3 dezelfde)',
          fr: 'Villa (2×brelan)',
          es: 'Villa (2×trío)',
          it: 'Villa (2×tris)',
          pl: 'Willa (2×trójka)',
        );
      case YatzyCategory.tower:
        return _pick(
          da: 'Tårn (4+2 ens)',
          en: 'Tower (4+2 of a Kind)',
          sv: 'Torn (fyrtal+par)',
          no: 'Tårn (4+2 like)',
          fi: 'Torni (4+2 samaa)',
          is_: 'Turn (4+2 eins)',
          de: 'Turm (Vierling+Paar)',
          nl: 'Toren (4+2 dezelfde)',
          fr: 'Tour (carré+paire)',
          es: 'Torre (póker+pareja)',
          it: 'Torre (poker+coppia)',
          pl: 'Wieża (4+2)',
        );
      case YatzyCategory.pyramid:
        return _pick(
          da: 'Pyramide (3+2+1 ens)',
          en: 'Pyramid (3+2+1 Kind)',
          sv: 'Pyramid (3+2+1 lika)',
          no: 'Pyramide (3+2+1 like)',
          fi: 'Pyramidi (3+2+1 samaa)',
          is_: 'Píramídi (3+2+1 eins)',
          de: 'Pyramide (3+2+1 Gleiche)',
          nl: 'Piramide (3+2+1 dezelfde)',
          fr: 'Pyramide (3+2+1 ident.)',
          es: 'Pirámide (3+2+1 iguales)',
          it: 'Piramide (3+2+1 uguali)',
          pl: 'Piramida (3+2+1)',
        );
      case YatzyCategory.evenOnly:
        return _pick(
          da: 'Kun lige tal',
          en: 'Even Only',
          sv: 'Endast jämna',
          no: 'Kun partall',
          fi: 'Vain parilliset',
          is_: 'Aðeins sléttar',
          de: 'Nur Gerade',
          nl: 'Alleen even',
          fr: 'Pairs uniquement',
          es: 'Solo pares',
          it: 'Solo pari',
          pl: 'Tylko parzyste',
        );
      case YatzyCategory.oddOnly:
        return _pick(
          da: 'Kun ulige tal',
          en: 'Odd Only',
          sv: 'Endast udda',
          no: 'Kun oddetall',
          fi: 'Vain parittomat',
          is_: 'Aðeins oddatölur',
          de: 'Nur Ungerade',
          nl: 'Alleen oneven',
          fr: 'Impairs uniquement',
          es: 'Solo impares',
          it: 'Solo dispari',
          pl: 'Tylko nieparzyste',
        );
      case YatzyCategory.chance:
        return _pick(
          da: 'Chance',
          en: 'Chance',
          sv: 'Chans',
          no: 'Sjanse',
          fi: 'Sattuma',
          is_: 'Áhætta',
          de: 'Chance',
          nl: 'Kans',
          fr: 'Chance',
          es: 'Libre / Chance',
          it: 'Chance',
          pl: 'Szansa',
        );
      case YatzyCategory.yatzy:
        final pts = rules?.yatzyBasePoints ?? 50;
        return 'Yatzy (${pts}p)';
      case YatzyCategory.superYatzy:
        final pts = rules?.superYatzyBasePoints ?? 75;
        return _pick(
          da: 'Super Yatzy (${pts}p)',
          en: 'Super Yatzy (${pts}p)',
          sv: 'Super Yatzy (${pts}p)',
          no: 'Super Yatzy (${pts}p)',
          fi: 'Super Yatzy (${pts}p)',
          is_: 'Ofur Yatzy (${pts}p)',
          de: 'Super Yatzy (${pts}p)',
          nl: 'Super Yatzy (${pts}p)',
          fr: 'Super Yatzy (${pts}p)',
          es: 'Súper Yatzy (${pts}p)',
          it: 'Super Yatzy (${pts}p)',
          pl: 'Super Yatzy ($pts pkt)',
        );
    }
  }

  String categoryDescription(
    YatzyCategory cat, {
    int upperParCount = 3,
    int diceCount = 5,
    YatzyGameRules? rules,
  }) {
    if (cat.isUpper) {
      final face = cat.upperFace!;
      final parPts = upperParCount * face;
      return _pick(
        da: '± ift. $upperParCount×$face = ${parPts}p',
        en: '± vs $upperParCount×$face = ${parPts}p',
        sv: '± mot $upperParCount×$face = ${parPts}p',
        no: '± mot $upperParCount×$face = ${parPts}p',
        fi: '± vrt. $upperParCount×$face = ${parPts}p',
        is_: '± m.v. $upperParCount×$face = ${parPts}p',
        de: '± ggü. $upperParCount×$face = ${parPts}p',
        nl: '± t.o.v. $upperParCount×$face = ${parPts}p',
        fr: '± vs $upperParCount×$face = ${parPts}p',
        es: '± vs $upperParCount×$face = ${parPts}p',
        it: '± vs $upperParCount×$face = ${parPts}p',
        pl: '± względem $upperParCount×$face = ${parPts}p',
      );
    }
    switch (cat) {
      case YatzyCategory.onePair:
        return _pick(
          da: '2 ens terninger (sum af de 2)',
          en: '2 matching dice (sum of the 2)',
          sv: '2 lika tärningar (summan av de 2)',
          no: '2 like terninger (summen av de 2)',
          fi: '2 samaa noppaa (2 nopan summa)',
          is_: '2 eins teningar (summa 2)',
          de: '2 gleiche Würfel (Summe der 2)',
          nl: '2 dezelfde dobbelstenen (som van 2)',
          fr: '2 dés identiques (somme des 2)',
          es: '2 dados iguales (suma de los 2)',
          it: '2 dadi uguali (somma dei 2)',
          pl: '2 jednakowe kości (suma 2)',
        );
      case YatzyCategory.twoPairs:
        return _pick(
          da: '2 forskellige par (sum af de 4)',
          en: '2 distinct pairs (sum of those 4)',
          sv: '2 olika par (summan av de 4)',
          no: '2 ulike par (summen av de 4)',
          fi: '2 eri paria (4 nopan summa)',
          is_: '2 ólík pör (summa 4)',
          de: '2 verschiedene Paare (Summe der 4)',
          nl: '2 verschillende paren (som van 4)',
          fr: '2 paires distinctes (somme des 4)',
          es: '2 parejas distintas (suma de los 4)',
          it: '2 coppie diverse (somma dei 4)',
          pl: '2 różne pary (suma 4)',
        );
      case YatzyCategory.threePairs:
        return _pick(
          da: '3 forskellige par (sum af de 6)',
          en: '3 distinct pairs (sum of those 6)',
          sv: '3 olika par (summan av de 6)',
          no: '3 ulike par (summen av de 6)',
          fi: '3 eri paria (6 nopan summa)',
          is_: '3 ólík pör (summa 6)',
          de: '3 verschiedene Paare (Summe der 6)',
          nl: '3 verschillende paren (som van 6)',
          fr: '3 paires distinctes (somme des 6)',
          es: '3 parejas distintas (suma de los 6)',
          it: '3 coppie diverse (somma dei 6)',
          pl: '3 różne pary (suma 6)',
        );
      case YatzyCategory.threeOfAKind:
        return _pick(
          da: '3 ens terninger (sum af de 3)',
          en: '3 matching dice (sum of the 3)',
          sv: '3 lika tärningar (summan av de 3)',
          no: '3 like terninger (summen av de 3)',
          fi: '3 samaa noppaa (3 nopan summa)',
          is_: '3 eins teningar (summa 3)',
          de: '3 gleiche Würfel (Summe der 3)',
          nl: '3 dezelfde dobbelstenen (som van 3)',
          fr: '3 dés identiques (somme des 3)',
          es: '3 dados iguales (suma de los 3)',
          it: '3 dadi uguali (somma dei 3)',
          pl: '3 jednakowe kości (suma 3)',
        );
      case YatzyCategory.fourOfAKind:
        return _pick(
          da: '4 ens terninger (sum af de 4)',
          en: '4 matching dice (sum of the 4)',
          sv: '4 lika tärningar (summan av de 4)',
          no: '4 like terninger (summen av de 4)',
          fi: '4 samaa noppaa (4 nopan summa)',
          is_: '4 eins teningar (summa 4)',
          de: '4 gleiche Würfel (Summe der 4)',
          nl: '4 dezelfde dobbelstenen (som van 4)',
          fr: '4 dés identiques (somme des 4)',
          es: '4 dados iguales (suma de los 4)',
          it: '4 dadi uguali (somma dei 4)',
          pl: '4 jednakowe kości (suma 4)',
        );
      case YatzyCategory.fiveOfAKind:
        return _pick(
          da: '5 ens terninger (sum af de 5)',
          en: '5 matching dice (sum of the 5)',
          sv: '5 lika tärningar (summan av de 5)',
          no: '5 like terninger (summen av de 5)',
          fi: '5 samaa noppaa (5 nopan summa)',
          is_: '5 eins teningar (summa 5)',
          de: '5 gleiche Würfel (Summe der 5)',
          nl: '5 dezelfde dobbelstenen (som van 5)',
          fr: '5 dés identiques (somme des 5)',
          es: '5 dados iguales (suma de los 5)',
          it: '5 dadi uguali (somma dei 5)',
          pl: '5 jednakowych kości (suma 5)',
        );
      case YatzyCategory.sixOfAKind:
        return _pick(
          da: '6 ens terninger (sum af de 6)',
          en: '6 matching dice (sum of the 6)',
          sv: '6 lika tärningar (summan av de 6)',
          no: '6 like terninger (summen av de 6)',
          fi: '6 samaa noppaa (6 nopan summa)',
          is_: '6 eins teningar (summa 6)',
          de: '6 gleiche Würfel (Summe der 6)',
          nl: '6 dezelfde dobbelstenen (som van 6)',
          fr: '6 dés identiques (somme des 6)',
          es: '6 dados iguales (suma de los 6)',
          it: '6 dadi uguali (somma dei 6)',
          pl: '6 jednakowych kości (suma 6)',
        );
      case YatzyCategory.smallStraight:
        if (diceCount == 4) return '1-2-3-4 (10 p) / 2-3-4-5 (14 p)';
        return '1-2-3-4-5 (15 p)';
      case YatzyCategory.largeStraight:
        if (diceCount == 4) return '3-4-5-6 (18 p) / 2-3-4-5 (14 p)';
        return '2-3-4-5-6 (20 p)';
      case YatzyCategory.fullStraight:
        return '1-2-3-4-5-6 (21 p)';
      case YatzyCategory.royalStraight:
        return _pick(
          da: '6 fortløbende øjne f.eks. 3-4-5-6-7-8 (30 p)',
          en: '6 consecutive faces e.g. 3-4-5-6-7-8 (30 p)',
          sv: '6 i följd t.ex. 3-4-5-6-7-8 (30 p)',
          no: '6 på rad f.eks. 3-4-5-6-7-8 (30 p)',
          fi: '6 peräkkäistä esim. 3-4-5-6-7-8 (30 p)',
          is_: '6 í röð t.d. 3-4-5-6-7-8 (30 p)',
          de: '6 aufeinanderfolgende Zahlen z.B. 3-8 (30 Pkt)',
          nl: '6 opeenvolgende waarden bijv. 3-8 (30 pnt)',
          fr: '6 faces consécutives ex. 3-4-5-6-7-8 (30 pts)',
          es: '6 números seguidos ej. 3-4-5-6-7-8 (30 pts)',
          it: '6 valori consecutivi es. 3-4-5-6-7-8 (30 pt)',
          pl: '6 kolejnych oczek np. 3-4-5-6-7-8 (30 pkt)',
        );
      case YatzyCategory.fullHouse:
        return _pick(
          da: '3 ens + 2 andre ens (sum af de 5)',
          en: '3 of a kind + distinct pair (sum of 5)',
          sv: 'Tretal + annat par (summan av 5)',
          no: '3 like + annet par (summen av 5)',
          fi: '3 samaa + eri pari (5 nopan summa)',
          is_: 'Þrenna + annað par (summa 5)',
          de: 'Drilling + anderes Paar (Summe der 5)',
          nl: '3 dezelfde + ander paar (som van 5)',
          fr: 'Brelan + autre paire (somme des 5)',
          es: 'Trío + otra pareja (suma de los 5)',
          it: 'Tris + altra coppia (somma dei 5)',
          pl: 'Trójka + inna para (suma 5)',
        );
      case YatzyCategory.villa:
        return _pick(
          da: '2 × 3 ens (sum af de 6)',
          en: '2 distinct 3-of-a-kinds (sum of 6)',
          sv: '2 olika tretal (summan av de 6)',
          no: '2 ulike tre like (summen av de 6)',
          fi: '2 eri kolmoislukua (6 nopan summa)',
          is_: '2 ólíkar þrennur (summa 6)',
          de: '2 verschiedene Drillinge (Summe der 6)',
          nl: '2 verschillende three-of-a-kinds (som van 6)',
          fr: '2 brelans distincts (somme des 6)',
          es: '2 tríos distintos (suma de los 6)',
          it: '2 tris diversi (somma dei 6)',
          pl: '2 różne trójki (suma 6)',
        );
      case YatzyCategory.tower:
        return _pick(
          da: '4 ens + 2 andre ens (sum af de 6)',
          en: '4 of a kind + distinct pair (sum of 6)',
          sv: 'Fyrtal + annat par (summan av de 6)',
          no: '4 like + annet par (summen av de 6)',
          fi: '4 samaa + eri pari (6 nopan summa)',
          is_: 'Ferna + annað par (summa 6)',
          de: 'Vierling + anderes Paar (Summe der 6)',
          nl: '4 dezelfde + ander paar (som van 6)',
          fr: 'Carré + autre paire (somme des 6)',
          es: 'Póker + otra pareja (suma de los 6)',
          it: 'Poker + altra coppia (somma dei 6)',
          pl: 'Kareta + inna para (suma 6)',
        );
      case YatzyCategory.pyramid:
        return _pick(
          da: '3 ens + 2 ens + 1 anden (sum af de 6)',
          en: '3 of a kind + pair + 1 distinct (sum of 6)',
          sv: 'Tretal + par + 1 annan (summan av 6)',
          no: '3 like + par + 1 annen (summen av 6)',
          fi: '3 samaa + pari + 1 eri (6 nopan summa)',
          is_: 'Þrenna + par + 1 önnur (summa 6)',
          de: 'Drilling + Paar + 1 einzelner (Summe der 6)',
          nl: '3 dezelfde + paar + 1 andere (som van 6)',
          fr: 'Brelan + paire + 1 autre (somme des 6)',
          es: 'Trío + pareja + 1 distinto (suma de 6)',
          it: 'Tris + coppia + 1 diverso (somma dei 6)',
          pl: 'Trójka + para + 1 inna (suma 6)',
        );
      case YatzyCategory.evenOnly:
        return _pick(
          da: 'Alle terninger viser lige tal (sum af alle)',
          en: 'All dice show even numbers (sum of all dice)',
          sv: 'Alla tärningar visar jämna tal (summan av alla)',
          no: 'Alle terninger viser partall (summen av alle)',
          fi: 'Kaikki nopat ovat parillisia (kaikkien summa)',
          is_: 'Allir teningar sýna sléttar tölur (summa allra)',
          de: 'Alle Würfel zeigen gerade Zahlen (Summe aller)',
          nl: 'Alle dobbelstenen zijn even (som van alle)',
          fr: 'Tous les dés sont pairs (somme de tous)',
          es: 'Todos los dados muestran pares (suma de todos)',
          it: 'Tutti i dadi mostrano numeri pari (somma totale)',
          pl: 'Wszystkie kości pokazują liczby parzyste (suma)',
        );
      case YatzyCategory.oddOnly:
        return _pick(
          da: 'Alle terninger viser ulige tal (sum af alle)',
          en: 'All dice show odd numbers (sum of all dice)',
          sv: 'Alla tärningar visar udda tal (summan av alla)',
          no: 'Alle terninger viser oddetall (summen av alle)',
          fi: 'Kaikki nopat ovat parittomia (kaikkien summa)',
          is_: 'Allir teningar sýna oddatölur (summa allra)',
          de: 'Alle Würfel zeigen ungerade Zahlen (Summe aller)',
          nl: 'Alle dobbelstenen zijn oneven (som van alle)',
          fr: 'Tous les dés sont impairs (somme de tous)',
          es: 'Todos los dados muestran impares (suma de todos)',
          it: 'Tutti i dadi mostrano numeri dispari (somma totale)',
          pl: 'Wszystkie kości pokazują liczby nieparzyste (suma)',
        );
      case YatzyCategory.chance:
        return _pick(
          da: 'Vilkårlig kombination (sum af alle)',
          en: 'Any combination (sum of all dice)',
          sv: 'Valfri kombination (summan av alla)',
          no: 'Valgfri kombinasjon (summen av alle)',
          fi: 'Mikä tahansa yhdistelmä (kaikkien summa)',
          is_: 'Hvaða samsetning sem er (summa allra)',
          de: 'Beliebige Kombination (Summe aller Würfel)',
          nl: 'Elke combinatie (som van alle dobbelstenen)',
          fr: 'Toute combinaison (somme de tous les dés)',
          es: 'Cualquier combinación (suma de todos)',
          it: 'Qualsiasi combinazione (somma di tutti)',
          pl: 'Dowolny układ (suma wszystkich kości)',
        );
      case YatzyCategory.yatzy:
        final pts = rules?.yatzyBasePoints ?? 50;
        return _pick(
          da: 'Alle terninger ens ($pts point uanset øjne)',
          en: 'All dice identical ($pts points regardless of face)',
          sv: 'Alla tärningar lika (alltid $pts poäng)',
          no: 'Alle terninger like (alltid $pts poeng)',
          fi: 'Kaikki nopat samat (aina $pts pistettä)',
          is_: 'Allir teningar eins (alltaf $pts stig)',
          de: 'Alle Würfel gleich (immer $pts Punkte)',
          nl: 'Alle dobbelstenen gelijk (altijd $pts punten)',
          fr: 'Tous les dés identiques (toujours $pts points)',
          es: 'Todos los dados iguales (siempre $pts puntos)',
          it: 'Tutti i dadi uguali (sempre $pts punti)',
          pl: 'Wszystkie kości jednakowe (zawsze $pts pkt)',
        );
      case YatzyCategory.superYatzy:
        final pts = rules?.superYatzyBasePoints ?? 75;
        return _pick(
          da: 'Alle terninger ens — Bonus Jackpot ($pts point!)',
          en: 'All dice identical — Bonus Jackpot ($pts points!)',
          sv: 'Alla tärningar lika — Bonusjackpott ($pts poäng!)',
          no: 'Alle terninger like — Bonusjackpot ($pts poeng!)',
          fi: 'Kaikki nopat samat — Bonusjättipotti ($pts pistettä!)',
          is_: 'Allir teningar eins — Bónusvinningur ($pts stig!)',
          de: 'Alle Würfel gleich — Bonus-Jackpot ($pts Punkte!)',
          nl: 'Alle dobbelstenen gelijk — Bonus Jackpot ($pts punten!)',
          fr: 'Tous les dés identiques — Super Jackpot ($pts points !)',
          es: 'Todos los dados iguales — Súper Jackpot (¡$pts puntos!)',
          it: 'Tutti i dadi uguali — Super Jackpot ($pts punti!)',
          pl: 'Wszystkie kości jednakowe — Bonusowy Jackpot ($pts pkt!)',
        );
      default:
        return '';
    }
  }

  // Player Setup & Game Mode Dialog
  String get playersDialogTitle => _pick(
        da: 'Spillere & Spilvariant',
        en: 'Players & Game Variant',
        sv: 'Spelare & Spelvariant',
        no: 'Spillere & Spillvariant',
        fi: 'Pelaajat & Pelimuoto',
        is_: 'Leikmenn & Leikgerð',
        de: 'Spieler & Spielvariante',
        nl: 'Spelers & Spelvariant',
        fr: 'Joueurs & Variante',
        es: 'Jugadores y Variante',
        it: 'Giocatori e Variante',
        pl: 'Gracze i Wariant gry',
      );

  String get gameVariantLabel => _pick(
        da: 'Vælg Yatzy-variant (Forudindstillet)',
        en: 'Select Yatzy Variant (Preset)',
        sv: 'Välj Yatzy-variant (Förval)',
        no: 'Velg Yatzy-variant (Forhåndsvalg)',
        fi: 'Valitse Yatzy-pelimuoto',
        is_: 'Veldu Yatzy-leikgerð',
        de: 'Yatzy-Variante wählen (Vorlage)',
        nl: 'Kies Yatzy-variant (Voorinstelling)',
        fr: 'Choisir une variante Yatzy',
        es: 'Seleccionar variante de Yatzy',
        it: 'Seleziona variante Yatzy',
        pl: 'Wybierz wariant Yatzy',
      );

  String get selectGameTypeDialogTitle => _pick(
        da: 'Vælg Spilvariant',
        en: 'Select Game Variant',
        sv: 'Välj Spelvariant',
        no: 'Velg Spillvariant',
        fi: 'Valitse Pelivariantti',
        is_: 'Veldu Leikjaafbrigði',
        de: 'Spielvariante wählen',
        nl: 'Kies Spelvariant',
        fr: 'Choisir une variante de jeu',
        es: 'Seleccionar variante de juego',
        it: 'Seleziona variante di gioco',
        pl: 'Wybierz wariant gry',
      );

  String get selectGameTypeDialogSubtitle => _pick(
        da: 'Læs om hver Yatzy-variant og vælg dit spil:',
        en: 'Read about each Yatzy variant and choose your game:',
        sv: 'Läs om varje Yatzy-variant och välj ditt spel:',
        no: 'Les om hver Yatzy-variant og velg ditt spill:',
        fi: 'Lue eri Yatzy-varianteista ja valitse pelisi:',
        is_: 'Lestu um hvert Yatzy-afbrigði og veldu leikinn þinn:',
        de: 'Lies mehr über jede Variante und wähle dein Spiel:',
        nl: 'Lees over elke Yatzy-variant en kies je spel:',
        fr: 'Découvrez chaque variante de Yatzy et choisissez votre jeu :',
        es: 'Lee sobre cada variante de Yatzy y elige tu juego:',
        it: 'Scopri ogni variante di Yatzy e scegli il tuo gioco:',
        pl: 'Poznaj każdy wariant Yatzy i wybierz swoją grę:',
      );

  String variantShortName(YatzyGameVariant v) {
    switch (v) {
      case YatzyGameVariant.mini4Dice:
        return _pick(
          da: 'Mini-Yatzy (4 terninger)',
          en: 'Mini-Yatzy (4 Dice)',
          sv: 'Mini-Yatzy (4 tärningar)',
          no: 'Mini-Yatzy (4 terninger)',
          fi: 'Mini-Yatzy (4 noppaa)',
          is_: 'Míní-Yatzy (4 teningar)',
          de: 'Mini-Yatzy (4 Würfel)',
          nl: 'Mini-Yatzy (4 dobbelstenen)',
          fr: 'Mini-Yatzy (4 dés)',
          es: 'Mini-Yatzy (4 dados)',
          it: 'Mini-Yatzy (4 dadi)',
          pl: 'Mini-Yatzy (4 kości)',
        );
      case YatzyGameVariant.classic5Dice:
        return _pick(
          da: 'Klassisk Yatzy (5 terninger)',
          en: 'Classic Yatzy (5 Dice)',
          sv: 'Klassisk Yatzy (5 tärningar)',
          no: 'Klassisk Yatzy (5 terninger)',
          fi: 'Klassinen Yatzy (5 noppaa)',
          is_: 'Klassískt Yatzy (5 teningar)',
          de: 'Klassisches Yatzy (5 Würfel)',
          nl: 'Klassiek Yatzy (5 dobbelstenen)',
          fr: 'Yatzy Classique (5 dés)',
          es: 'Yatzy Clásico (5 dados)',
          it: 'Yatzy Classico (5 dadi)',
          pl: 'Klasyczne Yatzy (5 kości)',
        );
      case YatzyGameVariant.usYahtzee:
        return _pick(
          da: 'US Yahtzee (Amerikansk)',
          en: 'US Yahtzee (American)',
          sv: 'US Yahtzee (Amerikansk)',
          no: 'US Yahtzee (Amerikansk)',
          fi: 'US Yahtzee (Amerikkalainen)',
          is_: 'US Yahtzee (Amerískt)',
          de: 'US Yahtzee (Amerikanisch)',
          nl: 'US Yahtzee (Amerikaans)',
          fr: 'US Yahtzee (Américain)',
          es: 'US Yahtzee (Americano)',
          it: 'US Yahtzee (Americano)',
          pl: 'US Yahtzee (Amerykańskie)',
        );
      case YatzyGameVariant.maxi6Dice:
        return _pick(
          da: 'Maxi-Yatzy (6 terninger)',
          en: 'Maxi-Yatzy (6 Dice)',
          sv: 'Maxi-Yatzy (6 tärningar)',
          no: 'Maxi-Yatzy (6 terninger)',
          fi: 'Maxi-Yatzy (6 noppaa)',
          is_: 'Maxi-Yatzy (6 teningar)',
          de: 'Maxi-Yatzy (6 Würfel)',
          nl: 'Maxi-Yatzy (6 dobbelstenen)',
          fr: 'Maxi-Yatzy (6 dés)',
          es: 'Maxi-Yatzy (6 dados)',
          it: 'Maxi-Yatzy (6 dadi)',
          pl: 'Maxi-Yatzy (6 kości)',
        );
      case YatzyGameVariant.mega7Dice:
        return _pick(
          da: 'Mega-Yatzy (7 terninger)',
          en: 'Mega-Yatzy (7 Dice)',
          sv: 'Mega-Yatzy (7 tärningar)',
          no: 'Mega-Yatzy (7 terninger)',
          fi: 'Mega-Yatzy (7 noppaa)',
          is_: 'Mega-Yatzy (7 teningar)',
          de: 'Mega-Yatzy (7 Würfel)',
          nl: 'Mega-Yatzy (7 dobbelstenen)',
          fr: 'Méga-Yatzy (7 dés)',
          es: 'Mega-Yatzy (7 dados)',
          it: 'Mega-Yatzy (7 dadi)',
          pl: 'Mega-Yatzy (7 kości)',
        );
      case YatzyGameVariant.d8Fantasy:
        return _pick(
          da: 'Octa-Yatzy (d8 Krystal)',
          en: 'Octa-Yatzy (d8 Crystal)',
          sv: 'Okta-Yatzy (d8 Kristall)',
          no: 'Okta-Yatzy (d8 Krystall)',
          fi: 'Okta-Yatzy (d8 Kristalli)',
          is_: 'Okta-Yatzy (d8 Kristall)',
          de: 'Okta-Yatzy (d8 Kristall)',
          nl: 'Octa-Yatzy (d8 Kristal)',
          fr: 'Octa-Yatzy (d8 Cristal)',
          es: 'Octa-Yatzy (d8 Cristal)',
          it: 'Octa-Yatzy (d8 Cristallo)',
          pl: 'Okta-Yatzy (d8 Kryształ)',
        );
      case YatzyGameVariant.rpgD20:
        return _pick(
          da: 'RPG d20 Crit Yatzy',
          en: 'RPG d20 Crit Yatzy',
          sv: 'RPG d20 Crit Yatzy',
          no: 'RPG d20 Crit Yatzy',
          fi: 'RPG d20 Crit Yatzy',
          is_: 'RPG d20 Crit Yatzy',
          de: 'RPG d20 Crit Yatzy',
          nl: 'RPG d20 Crit Yatzy',
          fr: 'RPG d20 Crit Yatzy',
          es: 'RPG d20 Crit Yatzy',
          it: 'RPG d20 Crit Yatzy',
          pl: 'RPG d20 Crit Yatzy',
        );
      case YatzyGameVariant.turbo4Rolls:
        return _pick(
          da: 'Turbo-Yatzy (4 kast)',
          en: 'Turbo-Yatzy (4 Rolls)',
          sv: 'Turbo-Yatzy (4 kast)',
          no: 'Turbo-Yatzy (4 kast)',
          fi: 'Turbo-Yatzy (4 heittoa)',
          is_: 'Turbo-Yatzy (4 köst)',
          de: 'Turbo-Yatzy (4 Würfe)',
          nl: 'Turbo-Yatzy (4 worpen)',
          fr: 'Turbo-Yatzy (4 lancers)',
          es: 'Turbo-Yatzy (4 tiradas)',
          it: 'Turbo-Yatzy (4 lanci)',
          pl: 'Turbo-Yatzy (4 rzuty)',
        );
      case YatzyGameVariant.oneShotHardcore:
        return _pick(
          da: 'Hardcore 1-Kast Yatzy',
          en: 'Hardcore 1-Roll Yatzy',
          sv: 'Hardcore 1-Kast Yatzy',
          no: 'Hardcore 1-Kast Yatzy',
          fi: 'Hardcore 1 Heiton Yatzy',
          is_: 'Hardcore 1-Kasts Yatzy',
          de: 'Hardcore 1-Wurf Yatzy',
          nl: 'Hardcore 1-Worp Yatzy',
          fr: 'Hardcore Yatzy 1 Lancer',
          es: 'Hardcore Yatzy 1 Tirada',
          it: 'Hardcore Yatzy 1 Lancio',
          pl: 'Hardcore Yatzy 1 Rzut',
        );
    }
  }

  String variantSpecsBadge(YatzyGameVariant v) {
    switch (v) {
      case YatzyGameVariant.mini4Dice:
        return '4×d6 • 3r • Par=2 • EU';
      case YatzyGameVariant.classic5Dice:
        return '5×d6 • 3r • Par=3 • EU';
      case YatzyGameVariant.usYahtzee:
        return '5×d6 • 3r • +35p • US';
      case YatzyGameVariant.maxi6Dice:
        return '6×d6 • 3r • Par=3 • EU';
      case YatzyGameVariant.mega7Dice:
        return '7×d6 • 4r • Par=3 • EU';
      case YatzyGameVariant.d8Fantasy:
        return '6×d8 • 4r • Par=3 • EU';
      case YatzyGameVariant.rpgD20:
        return '5×d20 • 4r • Nat 20s';
      case YatzyGameVariant.turbo4Rolls:
        return '6×d6 • 4r • Par=3 • EU';
      case YatzyGameVariant.oneShotHardcore:
        return '5×d6 • 1r • Hardcore';
    }
  }

  String variantExplanation(YatzyGameVariant v) {
    switch (v) {
      case YatzyGameVariant.mini4Dice:
        return _pick(
          da: 'Hurtigt og taktisk Yatzy med 4 terninger! Par i øverste sektion kræver kun 2 ens (Par=2). Lille Straight er 1-2-3-4 (10p), Stor Straight er 3-4-5-6 (18p), og 4 ens giver Yatzy (50p)! Indeholder også Kun Lige og Kun Ulige.',
          en: 'Fast, tactical Yatzy played with 4 dice! Upper section Par requires only 2 of a kind (Par=2). Small Straight is 1-2-3-4 (10p), Large Straight is 3-4-5-6 (18p), and 4 of a kind scores Yatzy (50p)! Also includes Even Only & Odd Only.',
          sv: 'Snabbt och taktiskt Yatzy med 4 tärningar! Par i övre sektionen kräver bara 2 lika (Par=2). Liten Stege är 1-2-3-4 (10p), Stor Stege är 3-4-5-6 (18p) och 4 lika ger Yatzy (50p)! Innehåller även Endast Jämna/Udda.',
          no: 'Raskt og taktisk Yatzy med 4 terninger! Par i øvre seksjon krever kun 2 like (Par=2). Liten Straight er 1-2-3-4 (10p), Stor Straight er 3-4-5-6 (18p), og 4 like gir Yatzy (50p)! Inkluderer også Kun Partall/Oddetall.',
          fi: 'Nopea ja taktinen 4 nopan Yatzy! Yläosan Par vaatii vain 2 samaa (Par=2). Pieni suora on 1-2-3-4 (10p), Suuri suora 3-4-5-6 (18p), ja 4 samaa on Yatzy (50p)! Mukana myös Vain Parilliset ja Parittomat.',
          is_: 'Hraður og taktískur Yatzy-leikur með 4 teningum! Par í efri hluta krefst aðeins 2 eins (Par=2). Lítil röð er 1-2-3-4 (10p), Stór röð er 3-4-5-6 (18p) og 4 eins gefa Yatzy (50p)!',
          de: 'Schnelles, taktisches Yatzy mit 4 Würfeln! Oben reicht ein Paar (Par=2) für den Bonus. Kleine Straße ist 1-2-3-4 (10 Pkt), Große Straße 3-4-5-6 (18 Pkt), und 4 Gleiche zählen als Yatzy (50 Pkt)! Inklusive Nur Gerade & Ungerade.',
          nl: 'Snel en tactisch Yatzy met 4 dobbelstenen! Bovenin volstaat 2 dezelfde (Par=2). Kleine Straat is 1-2-3-4 (10p), Grote Straat is 3-4-5-6 (18p) en 4 dezelfde is Yatzy (50p)! Inclusief Alleen Even & Oneven.',
          fr: 'Yatzy rapide et tactique à 4 dés ! Le Par supérieur ne demande que 2 dés identiques (Par=2). Petite Suite : 1-2-3-4 (10 pts), Grande Suite : 3-4-5-6 (18 pts), et 4 identiques valent Yatzy (50 pts) !',
          es: '¡Yatzy rápido y táctico con 4 dados! El Par superior solo requiere 2 iguales (Par=2). Escalera Pequeña es 1-2-3-4 (10p), Grande es 3-4-5-6 (18p), ¡y 4 iguales es Yatzy (50p)! Incluye Solo Pares e Impares.',
          it: 'Yatzy veloce e tattico con 4 dadi! Il Par superiore richiede solo 2 dadi uguali (Par=2). Scala Piccola è 1-2-3-4 (10p), Grande è 3-4-5-6 (18p) e 4 uguali valgono Yatzy (50p)! Include Solo Pari e Dispari.',
          pl: 'Szybkie i taktyczne Yatzy z 4 kośćmi! Par w górnej sekcji wymaga tylko 2 takich samych (Par=2). Mały Strit to 1-2-3-4 (10 pkt), Duży to 3-4-5-6 (18 pkt), a 4 jednakowe dają Yatzy (50 pkt)!',
        );
      case YatzyGameVariant.classic5Dice:
        return _pick(
          da: 'Den originale skandinaviske Yatzy-klassiker med 5 terninger og 3 kast pr. tur. Par i øverste sektion er 3 ens (+50p bonus ved 0 eller derover). 15 klassiske rækker med 1 Par, 2 Par, 3 & 4 Ens, Lille/Stor Straight, Fuldt Hus og Yatzy.',
          en: 'The original Scandinavian classic with 5 dice and 3 rolls per turn. Upper section Par is 3 of a kind (+50p bonus at 0 or above). 15 classic rows including One Pair, Two Pairs, 3 & 4 of a Kind, Small/Large Straight, Full House, and Yatzy.',
          sv: 'Den ursprungliga skandinaviska klassikern med 5 tärningar och 3 kast per tur. Par i övre sektionen är tretal (+50p bonus vid 0 eller mer). 15 klassiska rader med Ett Par, Två Par, Tretal, Fyrtal, Liten/Stor Stege, Kåk och Yatzy.',
          no: 'Den originale skandinaviske klassikeren med 5 terninger og 3 kast per tur. Par i øvre seksjon er 3 like (+50p bonus ved 0 eller mer). 15 klassiske rader med 1 Par, 2 Par, 3 & 4 Like, Liten/Stor Straight, Hus og Yatzy.',
          fi: 'Alkuperäinen pohjoismainen klassikko 5 nopalla ja 3 heitolla vuorossa. Yläosan Par on 3 samaa (+50p bonus 0:lla tai yli). 15 perinteistä riviä: Pari, Kaksi paria, 3 & 4 samaa, Pieni/Suuri suora, Täyskäsi ja Yatzy.',
          is_: 'Hinn upprunalegi norræni klassíker með 5 teningum og 3 köstum í umferð. Par í efri hluta er þrenna (+50p bónus við 0 eða hærra). 15 hefðbundnar línur með Pari, Tveimur pörum, Þrennu, Fernu, Röðum, Fullu húsi og Yatzy.',
          de: 'Der skandinavische Klassiker mit 5 Würfeln und 3 Würfen pro Zug. Oben gilt Drilling als Par (+50 Pkt Bonus ab ±0). 15 klassische Zeilen mit Ein Paar, Zwei Paare, Drilling, Vierling, Kleine/Große Straße, Full House und Yatzy.',
          nl: 'De originele Scandinavische klassieker met 5 dobbelstenen en 3 worpen per beurt. Par bovenin is 3 dezelfde (+50p bonus vanaf ±0). 15 klassieke rijen inclusief Één Paar, Twee Paar, Three/Four of a Kind, Straat, Full House en Yatzy.',
          fr: 'Le classique scandinave original avec 5 dés et 3 lancers par tour. Le Par supérieur est le brelan (+50 pts de bonus dès ±0). 15 lignes classiques : Paire, Deux Paires, Brelan, Carré, Suites, Full et Yatzy.',
          es: 'El clásico escandinavo original con 5 dados y 3 tiradas por turno. El Par superior son 3 iguales (+50p de bono desde ±0). 15 filas clásicas: Pareja, Dos Parejas, Trío, Póker, Escaleras, Full y Yatzy.',
          it: 'Il classico scandinavo originale con 5 dadi e 3 lanci per turno. Il Par superiore è il tris (+50p di bonus da ±0). 15 righe classiche: Coppia, Doppia Coppia, Tris, Poker, Scale, Full e Yatzy.',
          pl: 'Oryginalny skandynawski klasyk z 5 kośćmi i 3 rzutami w turze. Par na górze to trójka (+50 pkt bonusu od ±0). 15 klasycznych wierszy: Para, Dwie Pary, Trójka, Kareta, Strity, Ful i Yatzy.',
        );
      case YatzyGameVariant.usYahtzee:
        return _pick(
          da: 'Amerikansk/International Yahtzee (5 terninger, 13 rækker)! Ingen 1 Par eller 2 Par. Bonus giver +35p. 3 Ens & 4 Ens tæller summen af ALLE terninger. Fuldt Hus giver fast 25p, Lille Straight (4 i rækkefølge) 30p, og Stor Straight (5 i rækkefølge) 40p!',
          en: 'American / International Yahtzee (5 dice, 13 rows)! No One Pair or Two Pairs rows. Upper Bonus awards +35p. 3 of a Kind & 4 of a Kind score the sum of ALL dice. Full House is fixed 25p, Small Straight (any 4 sequential) 30p, and Large Straight (5 sequential) 40p!',
          sv: 'Amerikansk/Internationell Yahtzee (5 tärningar, 13 rader)! Inga rader för Ett Par eller Två Par. Bonus ger +35p. Tretal & Fyrtal ger summan av ALLA tärningar. Kåk ger fast 25p, Liten Stege (4 i följd) 30p och Stor Stege (5 i följd) 40p!',
          no: 'Amerikansk/Internasjonal Yahtzee (5 terninger, 13 rader)! Ingen rader for 1 Par eller 2 Par. Bonus gir +35p. 3 Like & 4 Like teller summen av ALLE terninger. Hus gir fast 25p, Liten Straight (4 på rad) 30p og Stor Straight (5 på rad) 40p!',
          fi: 'Amerikkalainen Yahtzee (5 noppaa, 13 riviä)! Ei Yksi pari tai Kaksi paria -rivejä. Bonus on +35p. 3 ja 4 samaa laskevat KAIKKIEN noppien summan. Täyskäsi on kiinteä 25p, Pieni suora (4 peräkkäistä) 30p ja Suuri suora (5 peräkkäistä) 40p!',
          is_: 'Amerískt Yahtzee (5 teningar, 13 línur)! Engin Par eða Tvö pör. Bónus gefur +35p. Þrenna og Ferna telja summu ALLRA teninga. Fullt hús gefur fast 25p, Lítil röð (4 í röð) 30p og Stór röð (5 í röð) 40p!',
          de: 'Amerikanisches Yahtzee (5 Würfel, 13 Zeilen)! Ohne Ein Paar & Zwei Paare. Bonus bringt +35 Pkt. Drilling & Vierling zählen die Summe ALLER Würfel. Full House feste 25 Pkt, Kleine Straße (4er Folge) 30 Pkt, Große Straße (5er Folge) 40 Pkt!',
          nl: 'Amerikaans Yahtzee (5 dobbelstenen, 13 rijen)! Geen Één Paar of Twee Paar. Bonus geeft +35p. Three & Four of a Kind tellen ALLE dobbelstenen. Full House vast 25p, Kleine Straat (4 op rij) 30p en Grote Straat (5 op rij) 40p!',
          fr: 'Yahtzee Américain (5 dés, 13 lignes) ! Pas de Paire ni Deux Paires. Le bonus rapporte +35 pts. Brelan et Carré additionnent TOUS les dés. Full vaut 25 pts fixes, Petite Suite (4 dés) 30 pts et Grande Suite (5 dés) 40 pts !',
          es: '¡Yahtzee Americano (5 dados, 13 filas)! Sin Pareja ni Dos Parejas. El bono da +35p. Trío y Póker suman TODOS los dados. Full vale 25p fijos, Escalera Pequeña (4 seguidos) 30p y Escalera Grande (5 seguidos) 40p.',
          it: 'Yahtzee Americano (5 dadi, 13 righe)! Senza Coppia o Doppia Coppia. Il bonus vale +35p. Tris e Poker sommano TUTTI i dadi. Full vale 25p fissi, Scala Piccola (4 in fila) 30p e Scala Grande (5 in fila) 40p!',
          pl: 'Amerykańskie Yahtzee (5 kości, 13 wierszy)! Brak Pary i Dwóch Par. Bonus daje +35 pkt. Trójka i Kareta sumują WSZYSTKIE kości. Ful to stałe 25 pkt, Mały Strit (4 kolejne) 30 pkt, a Duży Strit (5 kolejnych) 40 pkt!',
        );
      case YatzyGameVariant.maxi6Dice:
        return _pick(
          da: 'Udvidet Yatzy med 6 terninger! Giver helt nye kombinationer: 3 Par, 5 Ens, Fuld Straight (1–6 for 21p), Villa (2×3 ens), Tårn (4+2 ens) og Maxi Yatzy (6 ens for 100p!).',
          en: 'Expanded 6-dice Yatzy! Unlocks big-hand combinations: Three Pairs, Five of a Kind, Full Straight (1–6 for 21p), Villa (two triplets), Tower (4+2 of a kind), and Maxi Yatzy (6 of a kind for 100p!).',
          sv: 'Utökad Yatzy med 6 tärningar! Ger helt nya kombinationer: Tre Par, Femtal, Full Stege (1–6 för 21p), Villa (2×tretal), Torn (fyrtal+par) och Maxi Yatzy (6 lika för 100p!).',
          no: 'Utvidet Yatzy med 6 terninger! Gir helt nye kombinasjoner: 3 Par, 5 Like, Full Straight (1–6 for 21p), Hytta (2×3 like), Tårn (4+2 like) og Maxi Yatzy (6 like for 100p!).',
          fi: 'Laajennettu 6 nopan Yatzy! Avaa uudet suurkombot: Kolme paria, Viisi samaa, Täysi suora (1–6 = 21p), Huvila (2×3 samaa), Torni (4+2 samaa) ja Maxi Yatzy (6 samaa = 100p!).',
          is_: 'Stækkað Yatzy með 6 teningum! Opnar nýjar stórar samsetningar: Þrjú pör, Fimma, Full röð (1–6 fyrir 21p), Villa (2×þrenna), Turn (4+2 eins) og Maxi Yatzy (6 eins fyrir 100p!).',
          de: 'Erweitertes Yatzy mit 6 Würfeln! Schaltet große Kombinationen frei: Drei Paare, Fünfling, Volle Straße (1–6 für 21 Pkt), Villa (2×Drilling), Turm (Vierling+Paar) und Maxi Yatzy (6 Gleiche für 100 Pkt!).',
          nl: 'Uitgebreid Yatzy met 6 dobbelstenen! Ontgrendelt grote combinaties: Drie Paar, Vijf Dezelfde, Volle Straat (1–6 voor 21p), Villa (2×3 dezelfde), Toren (4+2 dezelfde) en Maxi Yatzy (6 dezelfde voor 100p!).',
          fr: 'Yatzy étendu à 6 dés ! Débloque de grandes combinaisons : Trois Paires, Cinq Identiques, Suite Complète (1–6 pour 21 pts), Villa (2×brelan), Tour (carré+paire) et Maxi Yatzy (6 identiques pour 100 pts !).',
          es: '¡Yatzy ampliado con 6 dados! Desbloquea grandes combinaciones: Tres Parejas, Cinco Iguales, Escalera Completa (1–6 por 21p), Villa (dos tríos), Torre (póker+pareja) y Maxi Yatzy (6 iguales por 100p).',
          it: 'Yatzy esteso a 6 dadi! Sblocca grandi combinazioni: Tre Coppie, Cinque Uguali, Scala Completa (1–6 per 21p), Villa (due tris), Torre (poker+coppia) e Maxi Yatzy (6 uguali per 100p!).',
          pl: 'Rozszerzone Yatzy z 6 kośćmi! Odblokowuje nowe układy: Trzy Pary, Piątka, Pełny Strit (1–6 za 21 pkt), Willa (2×trójka), Wieża (4+2) oraz Maxi Yatzy (6 jednakowych za 100 pkt!).',
        );
      case YatzyGameVariant.mega7Dice:
        return _pick(
          da: 'Ekstraordinært Yatzy med 7 terninger og 4 kast pr. tur! Med 7 terninger kan du bygge Pyramide (3+2+1 ens), Kun Lige, Kun Ulige, 6 Ens samt Super Yatzy (alle 7 terninger ens for 100p + 75p bonus!).',
          en: 'Epic 7-dice Yatzy with 4 rolls per turn! With 7 dice you can build Pyramid (3+2+1 of a kind), Even Only, Odd Only, Six of a Kind, plus Super Yatzy (all 7 matching dice for 100p + 75p bonus!).',
          sv: 'Episkt Yatzy med 7 tärningar och 4 kast per tur! Med 7 tärningar kan du bygga Pyramid (3+2+1 lika), Endast Jämna, Endast Udda, Sextal samt Super Yatzy (alla 7 lika för 100p + 75p bonus!).',
          no: 'Episk Yatzy med 7 terninger og 4 kast per tur! Med 7 terninger kan du bygge Pyramide (3+2+1 like), Kun Partall, Kun Oddetall, 6 Like samt Super Yatzy (alle 7 like for 100p + 75p bonus!).',
          fi: 'Eeppinen 7 nopan Yatzy 4 heitolla vuorossa! 7 nopalla voit rakentaa Pyramidin (3+2+1 samaa), Vain Parilliset/Parittomat, Kuusi samaa sekä Super Yatzyn (kaikki 7 samaa = 100p + 75p bonus!).',
          is_: 'Stórbrotið Yatzy með 7 teningum og 4 köstum í umferð! Með 7 teningum geturðu byggt Píramída (3+2+1 eins), Aðeins Sléttar/Oddatölur, Sex eins og Ofur Yatzy (allir 7 eins fyrir 100p + 75p bónus!).',
          de: 'Episches 7-Würfel-Yatzy mit 4 Würfen pro Zug! Baue Pyramide (3+2+1 Gleiche), Nur Gerade, Nur Ungerade, Sechsling sowie Super Yatzy (alle 7 gleich für 100 Pkt + 75 Pkt Bonus!).',
          nl: 'Episch Yatzy met 7 dobbelstenen en 4 worpen per beurt! Met 7 stenen bouw je Piramide (3+2+1 dezelfde), Alleen Even/Oneven, Zes Dezelfde én Super Yatzy (alle 7 gelijk voor 100p + 75p bonus!).',
          fr: 'Yatzy épique à 7 dés et 4 lancers par tour ! Construisez la Pyramide (3+2+1 identiques), Pairs/Impairs Uniquement, Six Identiques, ainsi que le Super Yatzy (7 dés identiques pour 100 pts + 75 pts bonus !).',
          es: '¡Épico Yatzy de 7 dados con 4 tiradas por turno! Con 7 dados puedes formar Pirámide (3+2+1 iguales), Solo Pares/Impares, Seis Iguales y Súper Yatzy (los 7 iguales por 100p + 75p de bono).',
          it: 'Epico Yatzy a 7 dadi con 4 lanci per turno! Con 7 dadi puoi formare Piramide (3+2+1 uguali), Solo Pari/Dispari, Sei Uguali e Super Yatzy (tutti e 7 uguali per 100p + 75p bonus!).',
          pl: 'Epickie Yatzy z 7 kośćmi i 4 rzutami w turze! Z 7 kośćmi ułożysz Piramidę (3+2+1), Tylko Parzyste/Nieparzyste, Szóstkę oraz Super Yatzy (wszystkie 7 jednakowych za 100 pkt + 75 pkt bonusu!).',
        );
      case YatzyGameVariant.d8Fantasy:
        return _pick(
          da: 'Spilles med 6 otte-sidede krystal-terninger (d8 med siderne 1–8) og 4 kast pr. tur! Øverste sektion går helt til 7\'ere og 8\'ere, og du kan score Royal Straight (6 i rækkefølge for 30p), Pyramide og Super Yatzy!',
          en: 'Played with 6 eight-sided crystal dice (d8 faces 1–8) and 4 rolls per turn! Upper section extends to 7s and 8s, plus Royal Straight (any 6 sequential faces for 30p), Pyramid, and Super Yatzy!',
          sv: 'Spelas med 6 åttasidiga kristalltärningar (d8 med sidorna 1–8) och 4 kast per tur! Övre sektionen går ända till Sjuor och Åttor, plus Kunglig Stege (6 i följd för 30p), Pyramid och Super Yatzy!',
          no: 'Spilles med 6 åttesidede krystallterninger (d8 med sidene 1–8) og 4 kast per tur! Øvre seksjon går helt til Syvere og Åttere, pluss Royal Straight (6 på rad for 30p), Pyramide og Super Yatzy!',
          fi: 'Pelataan 6 kahdeksansivuisella kristallinopalla (d8 sivut 1–8) ja 4 heitolla vuorossa! Yläosa jatkuu Seiskoihin ja Kaseihin, mukana Kuningassuora (6 peräkkäistä = 30p), Pyramidi ja Super Yatzy!',
          is_: 'Spilað með 6 áttflötungs kristalteningum (d8 hliðar 1–8) og 4 köstum í umferð! Efri hluti nær upp í Sjöur og Áttur, auk Konungsraðar (6 í röð fyrir 30p), Píramída og Ofur Yatzy!',
          de: 'Gespielt mit 6 achtseitigen Kristallwürfeln (d8 mit Augen 1–8) und 4 Würfen pro Zug! Der obere Teil reicht bis 7er und 8er, dazu Königsstraße (6 aufeinanderfolgende für 30 Pkt), Pyramide und Super Yatzy!',
          nl: 'Gespeeld met 6 achtzijdige kristaldobbelstenen (d8 vlakken 1–8) en 4 worpen per beurt! Bovenste sectie gaat tot 7s en 8s, plus Koningsstraat (6 op een rij voor 30p), Piramide en Super Yatzy!',
          fr: 'Se joue avec 6 dés cristaux à 8 faces (d8 faces 1–8) et 4 lancers par tour ! La section supérieure inclut les 7 et les 8, avec Suite Royale (6 consécutifs pour 30 pts), Pyramide et Super Yatzy !',
          es: '¡Se juega con 6 dados de cristal de 8 caras (d8 caras 1–8) y 4 tiradas por turno! La sección superior llega hasta los 7s y 8s, e incluye Escalera Real (6 seguidos por 30p), Pirámide y Súper Yatzy.',
          it: 'Si gioca con 6 dadi di cristallo a 8 facce (d8 facce 1–8) e 4 lanci per turno! La sezione superiore arriva fino ai 7 e 8, con Scala Reale (6 consecutivi per 30p), Piramide e Super Yatzy!',
          pl: 'Gra z 6 ośmiościennymi kośćmi kryształowymi (d8 oczka 1–8) i 4 rzutami w turze! Górna sekcja sięga aż do 7 i 8, a w dolnej czeka Królewski Strit (6 kolejnych za 30 pkt), Piramida i Super Yatzy!',
        );
      case YatzyGameVariant.rpgD20:
        return _pick(
          da: 'Rollespils-udgaven med 5 tyvesidede d20-ikosaedre (1–20) og 4 kast! Jagt "Nat 20s" i øverste sektion, Royal Straight og astronomiske summer i Chance og Fuldt Hus!',
          en: 'Tabletop RPG edition played with 5 twenty-sided d20 icosahedrons (1–20) and 4 rolls! Chase "Nat 20s" in the upper section, Royal Straights, and astronomical high scores on Full House and Chance!',
          sv: 'Rollspelsutgåvan med 5 tjugosidiga d20-ikosaedrar (1–20) och 4 kast! Jaga "Nat 20s" i övre sektionen, Kunglig Stege och astronomiska poäng i Chans och Kåk!',
          no: 'Rollespillutgaven med 5 tjueto-sidede d20-ikosaedre (1–20) og 4 kast! Jakt på "Nat 20s" i øvre seksjon, Royal Straight og astronomiske poengsummer!',
          fi: 'Roolipeliversio 5 kaksikymmentäsivuisella d20-nopalla (1–20) ja 4 heitolla! Metsästä "Nat 20" -tuloksia yläosassa ja huimia pisteitä Sattumassa ja Täyskädessä!',
          is_: 'Hlutverkaspilsútgáfan með 5 tuttugu hliða d20 teningum (1–20) og 4 köstum! Náðu "Nat 20" í efri hlutanum og risastigum í Áhættu og Fullu húsi!',
          de: 'Rollenspiel-Edition mit 5 zwanzigseitigen d20-Ikosaedern (1–20) und 4 Würfen! Jage "Nat 20s" im oberen Teil, Königsstraßen und gigantische Summen bei Full House und Chance!',
          nl: 'RPG-editie met 5 twintigzijdige d20-icosaëders (1–20) en 4 worpen! Jaag op "Nat 20s" bovenin, Koningsstraten en astronomische scores bij Full House en Kans!',
          fr: 'Édition JDR sur table avec 5 d20 icosaèdres (faces 1–20) et 4 lancers ! Chassez les "Nat 20" dans la section supérieure et des scores astronomiques au Full et à la Chance !',
          es: '¡Edición de rol con 5 dados d20 icosaedros (caras 1–20) y 4 tiradas! ¡Consigue "Nat 20s" en la sección superior y puntuaciones astronómicas en Full y Chance!',
          it: 'Edizione GDR da tavolo con 5 dadi d20 icosaedri (facce 1–20) e 4 lanci! Caccia i "Nat 20" nella sezione superiore e punteggi astronomici a Full e Chance!',
          pl: 'Edycja RPG z 5 dwudziestościennymi kośćmi d20 (1–20) i 4 rzutami! Poluj na "Nat 20" w górnej sekcji oraz astronomiczne sumy w Fulu i Szansie!',
        );
      case YatzyGameVariant.turbo4Rolls:
        return _pick(
          da: '6 almindelige terninger kombineret med hele 4 kast pr. tur! Det ekstra kast gør det langt sjovere og mere realistisk at ramme svære kombinationer som Tårn, Villa, Pyramide, Fuld Straight og Super Yatzy (75p).',
          en: '6 standard dice combined with 4 full rolls per turn! The extra roll makes chasing high-value combinations like Tower, Villa, Pyramid, Full Straight, and Super Yatzy (75p) much more action-packed.',
          sv: '6 vanliga tärningar kombinerat med hela 4 kast per tur! Det ekstra kastet gör det mycket roligare och mer realistiskt att träffa svåra kombinationer som Torn, Villa, Pyramid, Full Stege och Super Yatzy (75p).',
          no: '6 vanlige terninger kombinert med hele 4 kast per tur! Det ekstra kastet gjør det langt morsommere å treffe krevende kombinasjoner som Tårn, Hytta, Pyramide, Full Straight og Super Yatzy (75p).',
          fi: '6 tavallista noppaa yhdistettynä peräti 4 heittoon vuorossa! Lisäheitto tekee vaikeiden suurkombojen kuten Tornin, Huvilan, Pyramidin, Täyden suoran ja Super Yatzyn (75p) tavoittelusta huippujännittävää.',
          is_: '6 hefðbundnir teningar ásamt 4 köstum í hverri umferð! Aukakastið gerir mun skemmtilegra að ná stórum samsetningum eins og Turni, Villu, Píramída, Fullri röð og Ofur Yatzy (75p).',
          de: '6 Standardwürfel kombiniert mit vollen 4 Würfen pro Zug! Der Extrawurf macht die Jagd auf schwierige Kombinationen wie Turm, Villa, Pyramide, Volle Straße und Super Yatzy (75 Pkt) noch spannender.',
          nl: '6 standaard dobbelstenen gecombineerd met maar liefst 4 worpen per beurt! De extra worp maakt het jagen op lastige combinaties zoals Toren, Villa, Piramide, Volle Straat en Super Yatzy (75p) extra spectaculair.',
          fr: '6 dés standard combinés à 4 lancers complets par tour ! Le lancer supplémentaire rend la chasse aux grandes combinaisons (Tour, Villa, Pyramide, Suite Complète, Super Yatzy 75 pts) beaucoup plus palpitante.',
          es: '¡6 dados estándar combinados con 4 tiradas completas por turno! La tirada extra hace que conseguir grandes combinaciones como Torre, Villa, Pirámide, Escalera Completa y Súper Yatzy (75p) sea mucho más emocionante.',
          it: '6 dadi standard combinati con ben 4 lanci per turno! Il lancio extra rende molto più divertente centrare grandi combinazioni come Torre, Villa, Piramide, Scala Completa e Super Yatzy (75p).',
          pl: '6 standardowych kości połączonych z aż 4 rzutami w turze! Dodatkowy rzut sprawia, że polowanie na trudne układy takie jak Wieża, Willa, Piramida, Pełny Strit i Super Yatzy (75 pkt) jest pełne akcji.',
        );
      case YatzyGameVariant.oneShotHardcore:
        return _pick(
          da: 'Kun ÉT kast pr. tur! Ingen omkast overhovedet – du skal score præcis den hånd du slår i første hug. Par i øverste sektion er sat ned til Par=2 for at kompensere for sværhedsgraden!',
          en: 'Only ONE roll per turn! No re-rolls at all — you must immediately score whatever hand lands on your first throw. Upper section Par is lowered to Par=2 to balance the hardcore challenge!',
          sv: 'Endast ETT kast per tur! Inga omkast alls — du måste poängsätta exakt den hand du slår direkt. Par i övre sektionen är sänkt till Par=2 för att balansera utmaningen!',
          no: 'Kun ETT kast per tur! Ingen omkast i det hele tatt — du må score nøyaktig den hånden du slår på første forsøk. Par i øvre seksjon er senket til Par=2!',
          fi: 'Vain YKSI heitto vuorossa! Ei lainkaan uusintaheittoja — sinun on kirjattava tulos suoraan ensimmäisestä heitosta. Yläosan Par on laskettu tasolle Par=2!',
          is_: 'Aðeins EITT kast í umferð! Engin aukaköst — þú verður að skrá nákvæmlega það sem kemur upp í fyrsta kasti. Par í efri hluta er lækkað í Par=2!',
          de: 'Nur EIN Wurf pro Zug! Keine Nachwürfe — du musst sofort eintragen, was beim ersten Wurf fällt. Oben ist Par auf Par=2 gesenkt, um die Hardcore-Herausforderung auszubalancieren!',
          nl: 'Slechts ÉÉN worp per beurt! Geen herkansingen — je moet direct scoren wat er bij je eerste worp valt. Par bovenin is verlaagd naar Par=2!',
          fr: 'Un SEUL lancer par tour ! Aucun relancer — vous devez immédiatement scorer la main obtenue du premier coup. Le Par supérieur est abaissé à Par=2 !',
          es: '¡Solo UNA tirada por turno! Sin repeticiones: debes anotar de inmediato la jugada que salga en el primer lanzamiento. ¡El Par superior baja a Par=2!',
          it: 'Solo UN lancio per turno! Nessun rilancio: devi segnare immediatamente la mano uscita al primo tiro. Il Par superiore è ridotto a Par=2!',
          pl: 'Tylko JEDEN rzut w turze! Zero przerzutów — musisz od razu zapisać układ z pierwszego rzutu. Par w górnej sekcji obniżono do Par=2!',
        );
    }
  }

  String variantTitle(YatzyGameVariant v) {
    switch (v) {
      case YatzyGameVariant.mini4Dice:
        return _pick(
          da: 'Mini 4-Terningers Yatzy (4×d6 • 3 kast • Par=2 • 15 rækker)',
          en: 'Mini 4-Dice Yatzy (4×d6 • 3 rolls • Par=2 • 15 rows)',
          sv: 'Mini 4-Tärningars Yatzy (4×d6 • 3 kast • Par=2 • 15 rader)',
          no: 'Mini 4-Terningers Yatzy (4×d6 • 3 kast • Par=2 • 15 rader)',
          fi: 'Mini 4 Nopan Yatzy (4×d6 • 3 heittoa • Par=2 • 15 riviä)',
          is_: 'Míní 4-Teninga Yatzy (4×d6 • 3 köst • Par=2 • 15 línur)',
          de: 'Mini 4-Würfel Yatzy (4×d6 • 3 Würfe • Par=2 • 15 Zeilen)',
          nl: 'Mini 4-Dobbelstenen Yatzy (4×d6 • 3 worpen • Par=2 • 15 vakken)',
          fr: 'Mini Yatzy 4 Dés (4×d6 • 3 lancers • Par=2 • 15 lignes)',
          es: 'Mini Yatzy 4 Dados (4×d6 • 3 tiradas • Par=2 • 15 filas)',
          it: 'Mini Yatzy 4 Dadi (4×d6 • 3 lanci • Par=2 • 15 righe)',
          pl: 'Mini Yatzy 4 Kości (4×d6 • 3 rzuty • Par=2 • 15 wierszy)',
        );
      case YatzyGameVariant.classic5Dice:
        return _pick(
          da: 'Klassisk 5-Terningers Yatzy (5×d6 • 3 kast • 15 rækker)',
          en: 'Classic 5-Dice Yatzy (5×d6 • 3 rolls • 15 rows)',
          sv: 'Klassisk 5-Tärningars Yatzy (5×d6 • 3 kast • 15 rader)',
          no: 'Klassisk 5-Terningers Yatzy (5×d6 • 3 kast • 15 rader)',
          fi: 'Klassinen 5 Nopan Yatzy (5×d6 • 3 heittoa • 15 riviä)',
          is_: 'Klassískt 5-Teninga Yatzy (5×d6 • 3 köst • 15 línur)',
          de: 'Klassisches 5-Würfel Yatzy (5×d6 • 3 Würfe • 15 Zeilen)',
          nl: 'Klassiek 5-Dobbelstenen Yatzy (5×d6 • 3 worpen • 15 vakken)',
          fr: 'Yatzy Classique 5 Dés (5×d6 • 3 lancers • 15 lignes)',
          es: 'Yatzy Clásico 5 Dados (5×d6 • 3 tiradas • 15 filas)',
          it: 'Yatzy Classico 5 Dadi (5×d6 • 3 lanci • 15 righe)',
          pl: 'Klasyczne Yatzy 5 Kości (5×d6 • 3 rzuty • 15 wierszy)',
        );
      case YatzyGameVariant.usYahtzee:
        return _pick(
          da: 'US Yahtzee (5×d6 • 3 kast • +35p Bonus • 25/30/40p Fast)',
          en: 'US Yahtzee (5×d6 • 3 rolls • +35p Bonus • Fixed 25/30/40p)',
          sv: 'US Yahtzee (5×d6 • 3 kast • +35p Bonus • 25/30/40p Fast)',
          no: 'US Yahtzee (5×d6 • 3 kast • +35p Bonus • 25/30/40p Fast)',
          fi: 'US Yahtzee (5×d6 • 3 heittoa • +35p Bonus • Kiinteät 25/30/40p)',
          is_: 'US Yahtzee (5×d6 • 3 köst • +35p Bónus • Fast 25/30/40p)',
          de: 'US Yahtzee (5×d6 • 3 Würfe • +35p Bonus • Feste 25/30/40p)',
          nl: 'US Yahtzee (5×d6 • 3 worpen • +35p Bonus • Vaste 25/30/40p)',
          fr: 'US Yahtzee (5×d6 • 3 lancers • Bonus +35p • 25/30/40p Fixes)',
          es: 'US Yahtzee (5×d6 • 3 tiradas • Bono +35p • 25/30/40p Fijos)',
          it: 'US Yahtzee (5×d6 • 3 lanci • Bonus +35p • 25/30/40p Fissi)',
          pl: 'US Yahtzee (5×d6 • 3 rzuty • Bonus +35 pkt • Stałe 25/30/40 pkt)',
        );
      case YatzyGameVariant.maxi6Dice:
        return _pick(
          da: 'Maxi 6-Terningers Yatzy (6×d6 • 3 kast • 20 rækker inkl. Villa & Tårn)',
          en: 'Maxi 6-Dice Yatzy (6×d6 • 3 rolls • 20 rows incl. Villa & Tower)',
          sv: 'Maxi 6-Tärningars Yatzy (6×d6 • 3 kast • 20 rader inkl. Villa & Torn)',
          no: 'Maxi 6-Terningers Yatzy (6×d6 • 3 kast • 20 rader inkl. Hytta & Tårn)',
          fi: 'Maxi 6 Nopan Yatzy (6×d6 • 3 heittoa • 20 riviä ml. Huvila & Torni)',
          is_: 'Maxi 6-Teninga Yatzy (6×d6 • 3 köst • 20 línur m.a. Villa & Turn)',
          de: 'Maxi 6-Würfel Yatzy (6×d6 • 3 Würfe • 20 Zeilen inkl. Villa & Turm)',
          nl: 'Maxi 6-Dobbelstenen Yatzy (6×d6 • 3 worpen • 20 vakken incl. Villa & Toren)',
          fr: 'Maxi Yatzy 6 Dés (6×d6 • 3 lancers • 20 lignes incl. Villa & Tour)',
          es: 'Maxi Yatzy 6 Dados (6×d6 • 3 tiradas • 20 filas incl. Villa y Torre)',
          it: 'Maxi Yatzy 6 Dadi (6×d6 • 3 lanci • 20 righe incl. Villa e Torre)',
          pl: 'Maxi Yatzy 6 Kości (6×d6 • 3 rzuty • 20 wierszy w tym Willa i Wieża)',
        );
      case YatzyGameVariant.mega7Dice:
        return _pick(
          da: 'Mega 7-Terningers Yatzy (7×d6 • 4 kast • Pyramide, Lige/Ulige & Super Yatzy)',
          en: 'Mega 7-Dice Yatzy (7×d6 • 4 rolls • Pyramid, Even/Odd & Super Yatzy)',
          sv: 'Mega 7-Tärningars Yatzy (7×d6 • 4 kast • Pyramid, Jämna/Udda & Super Yatzy)',
          no: 'Mega 7-Terningers Yatzy (7×d6 • 4 kast • Pyramide, Par/Odd & Super Yatzy)',
          fi: 'Mega 7 Nopan Yatzy (7×d6 • 4 heittoa • Pyramidi, Parilliset & Super Yatzy)',
          is_: 'Mega 7-Teninga Yatzy (7×d6 • 4 köst • Píramídi, Slétt/Odda & Ofur Yatzy)',
          de: 'Mega 7-Würfel Yatzy (7×d6 • 4 Würfe • Pyramide, Gerade/Ungerade & Super Yatzy)',
          nl: 'Mega 7-Dobbelstenen Yatzy (7×d6 • 4 worpen • Piramide, Even/Oneven & Super Yatzy)',
          fr: 'Méga Yatzy 7 Dés (7×d6 • 4 lancers • Pyramide, Pairs/Impairs & Super Yatzy)',
          es: 'Mega Yatzy 7 Dados (7×d6 • 4 tiradas • Pirámide, Pares/Impares y Súper Yatzy)',
          it: 'Mega Yatzy 7 Dadi (7×d6 • 4 lanci • Piramide, Pari/Dispari e Super Yatzy)',
          pl: 'Mega Yatzy 7 Kości (7×d6 • 4 rzuty • Piramida, Parzyste/Nieparzyste i Super Yatzy)',
        );
      case YatzyGameVariant.d8Fantasy:
        return _pick(
          da: 'Oktaeder d8 Fantasy Yatzy (6×d8 sider 1–8 • 4 kast • 7\'ere, 8\'ere & Royal Straight)',
          en: 'Octahedron d8 Fantasy Yatzy (6×d8 faces 1–8 • 4 rolls • 7s, 8s & Royal Straight)',
          sv: 'Oktaeder d8 Fantasy Yatzy (6×d8 sidor 1–8 • 4 kast • Sjuor, Åttor & Kunglig Stege)',
          no: 'Oktaeder d8 Fantasy Yatzy (6×d8 sider 1–8 • 4 kast • Syvere, Åttere & Royal Straight)',
          fi: 'Oktaedri d8 Fantasy Yatzy (6×d8 sivut 1–8 • 4 heittoa • Seiskat, Kasit & Kuningassuora)',
          is_: 'Áttflötungur d8 Fantasy Yatzy (6×d8 hliðar 1–8 • 4 köst • Sjöur, Áttur & Konungsröð)',
          de: 'Oktaeder d8 Fantasy Yatzy (6×d8 Augen 1–8 • 4 Würfe • 7er, 8er & Königsstraße)',
          nl: 'Octaëder d8 Fantasy Yatzy (6×d8 vlakken 1–8 • 4 worpen • 7s, 8s & Koningsstraat)',
          fr: 'Yatzy Fantasy d8 Octaèdre (6×d8 faces 1–8 • 4 lancers • 7, 8 & Suite Royale)',
          es: 'Yatzy Fantasía d8 Octaedro (6×d8 caras 1–8 • 4 tiradas • 7s, 8s y Escalera Real)',
          it: 'Yatzy Fantasy d8 Ottaedro (6×d8 facce 1–8 • 4 lanci • 7, 8 e Scala Reale)',
          pl: 'Ośmiościan d8 Fantasy Yatzy (6×d8 ścianki 1–8 • 4 rzuty • 7, 8 i Królewski Strit)',
        );
      case YatzyGameVariant.rpgD20:
        return _pick(
          da: 'RPG d20 Crit Yatzy (5×d20 Ikosaeder • 4 kast • Nat 20\'ere & Kæmpe-summer)',
          en: 'RPG d20 Crit Yatzy (5×d20 Icosahedron • 4 rolls • Nat 20s & Huge Totals)',
          sv: 'RPG d20 Crit Yatzy (5×d20 Ikosaeder • 4 kast • Nat 20s & Jättesummor)',
          no: 'RPG d20 Crit Yatzy (5×d20 Ikosaeder • 4 kast • Nat 20s & Kjempesummer)',
          fi: 'RPG d20 Crit Yatzy (5×d20 Ikosaedri • 4 heittoa • Nat 20 & Jättipisteet)',
          is_: 'RPG d20 Crit Yatzy (5×d20 Tuttuguflötungur • 4 köst • Nat 20 & Risasummur)',
          de: 'RPG d20 Crit Yatzy (5×d20 Ikosaeder • 4 Würfe • Nat 20s & Riesensummen)',
          nl: 'RPG d20 Crit Yatzy (5×d20 Icosaëder • 4 worpen • Nat 20s & Reuzenscores)',
          fr: 'Yatzy RPG d20 Crit (5×d20 Icosaèdre • 4 lancers • Nat 20 & Scores Géants)',
          es: 'Yatzy RPG d20 Crit (5×d20 Icosaedro • 4 tiradas • Nat 20s y Puntuaciones Gigantes)',
          it: 'Yatzy RPG d20 Crit (5×d20 Icosaedro • 4 lanci • Nat 20 e Punteggi Giganti)',
          pl: 'RPG d20 Crit Yatzy (5×d20 Dwudziestościan • 4 rzuty • Nat 20 i Gigantyczne Sumy)',
        );
      case YatzyGameVariant.turbo4Rolls:
        return _pick(
          da: 'Turbo 4-Kast Yatzy (6×d6 • 4 kast pr. tur • Alle Maxi + Bonus-kombinationer)',
          en: 'Turbo 4-Rolls Yatzy (6×d6 • 4 rolls per turn • All Maxi + Bonus Combinations)',
          sv: 'Turbo 4-Kast Yatzy (6×d6 • 4 kast per tur • Alla Maxi + Bonuskombinationer)',
          no: 'Turbo 4-Kast Yatzy (6×d6 • 4 kast per tur • Alle Maxi + Bonuskombinasjoner)',
          fi: 'Turbo 4 Heiton Yatzy (6×d6 • 4 heittoa vuorossa • Kaikki Maxi + Erikoisrivit)',
          is_: 'Turbo 4-Kasta Yatzy (6×d6 • 4 köst í umferð • Allar Maxi + Bónuslínur)',
          de: 'Turbo 4-Würfe Yatzy (6×d6 • 4 Würfe pro Zug • Alle Maxi + Bonuskombinationen)',
          nl: 'Turbo 4-Worpen Yatzy (6×d6 • 4 worpen per beurt • Alle Maxi + Bonuscombinaties)',
          fr: 'Yatzy Turbo 4 Lancers (6×d6 • 4 lancers par tour • Toutes combinaisons Maxi + Bonus)',
          es: 'Yatzy Turbo 4 Tiradas (6×d6 • 4 tiradas por turno • Todas las combinaciones Maxi + Bono)',
          it: 'Yatzy Turbo 4 Lanci (6×d6 • 4 lanci per turno • Tutte le combinazioni Maxi + Bonus)',
          pl: 'Turbo Yatzy 4 Rzuty (6×d6 • 4 rzuty w turze • Wszystkie układy Maxi + Bonusowe)',
        );
      case YatzyGameVariant.oneShotHardcore:
        return _pick(
          da: 'Hardcore 1-Kast Yatzy (5×d6 • Kun 1 kast pr. tur • Par=2 • Ingen omkast)',
          en: 'Hardcore 1-Roll Yatzy (5×d6 • Only 1 roll per turn • Par=2 • No re-rolls)',
          sv: 'Hardcore 1-Kast Yatzy (5×d6 • Endast 1 kast per tur • Par=2 • Inga omkast)',
          no: 'Hardcore 1-Kast Yatzy (5×d6 • Kun 1 kast per tur • Par=2 • Ingen omkast)',
          fi: 'Hardcore 1 Heiton Yatzy (5×d6 • Vain 1 heitto vuorossa • Par=2 • Ei uusintoja)',
          is_: 'Hardcore 1-Kasts Yatzy (5×d6 • Aðeins 1 kast í umferð • Par=2 • Engin aukaköst)',
          de: 'Hardcore 1-Wurf Yatzy (5×d6 • Nur 1 Wurf pro Zug • Par=2 • Keine Nachwürfe)',
          nl: 'Hardcore 1-Worp Yatzy (5×d6 • Slechts 1 worp per beurt • Par=2 • Geen herkansingen)',
          fr: 'Yatzy Hardcore 1 Lancer (5×d6 • 1 seul lancer par tour • Par=2 • Sans relance)',
          es: 'Yatzy Hardcore 1 Tirada (5×d6 • Solo 1 tirada por turno • Par=2 • Sin repetición)',
          it: 'Yatzy Hardcore 1 Lancio (5×d6 • Solo 1 lancio per turno • Par=2 • Nessun rilancio)',
          pl: 'Hardcore Yatzy 1 Rzut (5×d6 • Tylko 1 rzut w turze • Par=2 • Bez przerzutów)',
        );
    }
  }

  String get customRulesSectionLabel => _pick(
        da: 'Tilpas Regler (Regelsæt, Terninger, Sider & Kast)',
        en: 'Customize Rules (Rule Style, Dice, Sides & Rolls)',
        sv: 'Anpassa Regler (Regelstil, Tärningar, Sidor & Kast)',
        no: 'Tilpass Regler (Regelstil, Terninger, Sider & Kast)',
        fi: 'Mukauta Sääntöjä (Tyyli, Nopat, Sivut & Heitot)',
        is_: 'Sérsníða Reglur (Reglustíll, Teningar, Hliðar & Köst)',
        de: 'Regeln anpassen (Stil, Würfel, Seiten & Würfe)',
        nl: 'Regels aanpassen (Stijl, Dobbelstenen, Zijden & Worpen)',
        fr: 'Personnaliser les Règles (Style, Dés, Faces & Lancers)',
        es: 'Personalizar Reglas (Estilo, Dados, Caras y Tiradas)',
        it: 'Personalizza Regole (Stile, Dadi, Facce e Lanci)',
        pl: 'Dostosuj Zasady (Styl, Kości, Ścianki i Rzuty)',
      );

  String get ruleRegionSettingLabel => _pick(
        da: 'Regelstil (EU vs. US)',
        en: 'Rule Style (EU vs. US)',
        sv: 'Regelstil (EU vs. US)',
        no: 'Regelstil (EU vs. US)',
        fi: 'Sääntötyyli (EU vs. US)',
        is_: 'Reglustíll (EU vs. US)',
        de: 'Regel-Stil (EU vs. US)',
        nl: 'Regelstijl (EU vs. US)',
        fr: 'Style de Règles (UE vs. US)',
        es: 'Estilo de Reglas (UE vs. EE. UU.)',
        it: 'Stile Regole (UE vs. USA)',
        pl: 'Styl Zasad (UE vs. USA)',
      );

  String ruleRegionOptionLabel(YatzyRuleRegion region) {
    switch (region) {
      case YatzyRuleRegion.euScandinavian:
        return _pick(
          da: '🇪🇺 EU / Skandinavisk (Par-rækker • +50p bonus • Sum ved Hus/3/4 ens)',
          en: '🇪🇺 EU / Scandinavian (Includes Pairs • +50p Bonus • Sum 3/4 Kind & House)',
          sv: '🇪🇺 EU / Skandinavisk (Par-rader • +50p bonus • Summa vid Kåk/Tretal)',
          no: '🇪🇺 EU / Skandinavisk (Par-rader • +50p bonus • Sum ved Hus/3/4 like)',
          fi: '🇪🇺 EU / Pohjoismainen (Paririvit • +50p bonus • Summa Täyskäsi/3/4 samaa)',
          is_: '🇪🇺 EU / Norrænt (Par-línur • +50p bónus • Summa fyrir Fullt hús/Þrennu)',
          de: '🇪🇺 EU / Skandinavisch (Mit Paaren • +50p Bonus • Summe bei Drilling/Full House)',
          nl: '🇪🇺 EU / Scandinavisch (Met Paren • +50p Bonus • Som bij Full House/3/4 Dezelfde)',
          fr: '🇪🇺 UE / Scandinave (Avec Paires • Bonus +50 pts • Somme au Brelan/Full)',
          es: '🇪🇺 UE / Escandinavo (Con Parejas • Bono +50p • Suma en Trío/Full)',
          it: '🇪🇺 UE / Scandinavo (Con Coppie • Bonus +50p • Somma per Tris/Full)',
          pl: '🇪🇺 UE / Skandynawskie (Z Parami • Bonus +50 pkt • Suma w Trójce/Fulu)',
        );
      case YatzyRuleRegion.usYahtzee:
        return _pick(
          da: '🇺🇸 US / Yahtzee (Ingen Par • +35p bonus • Alle terninger tæller • 25/30/40p fast)',
          en: '🇺🇸 US / Yahtzee (No Pairs • +35p Bonus • 3/4 Kind Sum All • Fixed 25/30/40p)',
          sv: '🇺🇸 US / Yahtzee (Inga Par • +35p bonus • Alla tärningar räknas • 25/30/40p fast)',
          no: '🇺🇸 US / Yahtzee (Ingen Par • +35p bonus • Alle terninger teller • 25/30/40p fast)',
          fi: '🇺🇸 US / Yahtzee (Ei Pareja • +35p bonus • Kaikki nopat lasketaan • 25/30/40p)',
          is_: '🇺🇸 US / Yahtzee (Engin Pör • +35p bónus • Allir teningar telja • Fast 25/30/40p)',
          de: '🇺🇸 US / Yahtzee (Ohne Paare • +35p Bonus • Alle Würfel zählen • Feste 25/30/40p)',
          nl: '🇺🇸 US / Yahtzee (Geen Paren • +35p Bonus • Alle stenen tellen • Vaste 25/30/40p)',
          fr: '🇺🇸 US / Yahtzee (Sans Paires • Bonus +35 pts • Tous les dés comptent • 25/30/40p)',
          es: '🇺🇸 EE. UU. / Yahtzee (Sin Parejas • Bono +35p • Todos los dados cuentan • 25/30/40p)',
          it: '🇺🇸 USA / Yahtzee (Senza Coppie • Bonus +35p • Tutti i dadi contano • 25/30/40p)',
          pl: '🇺🇸 USA / Yahtzee (Bez Par • Bonus +35 pkt • Suma wszystkich kości • Stałe 25/30/40 pkt)',
        );
    }
  }

  String get scalePointsSettingLabel => _pick(
        da: 'Point-skalering (Bonus & Yatzy)',
        en: 'Point Scaling (Bonus & Yatzy)',
        sv: 'Poängskalning (Bonus & Yatzy)',
        no: 'Poengskalering (Bonus & Yatzy)',
        fi: 'Pisteytyksen skaalaus (Bonus & Yatzy)',
        is_: 'Stigaskölun (Bónus & Yatzy)',
        de: 'Punkte-Skalierung (Bonus & Yatzy)',
        nl: 'Puntenschaling (Bonus & Yatzy)',
        fr: 'Échelle des Points (Bonus & Yatzy)',
        es: 'Escalado de Puntos (Bono y Yatzy)',
        it: 'Scala Punti (Bonus e Yatzy)',
        pl: 'Skalowanie Punktów (Bonus i Yatzy)',
      );

  String scalePointsOptionLabel(bool scaled) => scaled
      ? _pick(
          da: '⚖️ Dynamisk (Skaleret efter terninger & sider)',
          en: '⚖️ Dynamic (Scaled to Dice & Sides)',
          sv: '⚖️ Dynamisk (Skalad efter tärningar & sidor)',
          no: '⚖️ Dynamisk (Skalert etter terninger & sider)',
          fi: '⚖️ Dynaaminen (Skaalattu noppien mukaan)',
          is_: '⚖️ Kvik (Skalað eftir teningum & hliðum)',
          de: '⚖️ Dynamisch (Skaliert nach Würfeln & Seiten)',
          nl: '⚖️ Dynamisch (Geschaald naar dobbelstenen)',
          fr: '⚖️ Dynamique (Adapté aux dés et faces)',
          es: '⚖️ Dinámico (Escalado según dados y caras)',
          it: '⚖️ Dinamico (Adattato a dadi e facce)',
          pl: '⚖️ Dynamiczne (Skalowane do kości i ścianek)',
        )
      : _pick(
          da: '🔒 Klassisk Fast (Fast 50p/35p uanset terninger)',
          en: '🔒 Classic Fixed (Fixed 50p/35p always)',
          sv: '🔒 Klassisk Fast (Fast 50p/35p oavsett tärningar)',
          no: '🔒 Klassisk Fast (Fast 50p/35p uansett terninger)',
          fi: '🔒 Klassinen Kiinteä (Kiinteä 50p/35p aina)',
          is_: '🔒 Klassískt Fast (Fast 50p/35p alltaf)',
          de: '🔒 Klassisch Fest (Immer feste 50p/35p)',
          nl: '🔒 Klassiek Vast (Altijd vaste 50p/35p)',
          fr: '🔒 Classique Fixe (50p/35p fixes toujours)',
          es: '🔒 Clásico Fijo (Siempre 50p/35p fijos)',
          it: '🔒 Classico Fisso (Sempre 50p/35p fissi)',
          pl: '🔒 Klasyczne Stałe (Zawsze stałe 50/35 pkt)',
        );

  String get diceCountSettingLabel => _pick(
        da: 'Antal terninger',
        en: 'Number of Dice',
        sv: 'Antal tärningar',
        no: 'Antall terninger',
        fi: 'Noppien määrä',
        is_: 'Fjöldi teninga',
        de: 'Würfelanzahl',
        nl: 'Aantal dobbelstenen',
        fr: 'Nombre de dés',
        es: 'Número de dados',
        it: 'Numero di dadi',
        pl: 'Liczba kości',
      );

  String get dieSidesSettingLabel => _pick(
        da: 'Terningtype (Rollespil & Klassisk)',
        en: 'Die Type (Polyhedral RPG & Classic)',
        sv: 'Tärningstyp (Rollspel & Klassisk)',
        no: 'Terningtype (Rollespill & Klassisk)',
        fi: 'Noppatyyppi (Roolipeli & Klassinen)',
        is_: 'Gerð tenings (Hlutverkaspil & Klassískt)',
        de: 'Würfelform (Rollenspiel & Klassisch)',
        nl: 'Type dobbelsteen (RPG & Klassiek)',
        fr: 'Type de dé (JDR Polyédrique & Classique)',
        es: 'Tipo de dado (RPG Poliedros y Clásico)',
        it: 'Tipo di dado (GDR Poliedrico e Classico)',
        pl: 'Typ kości (Wielościany RPG i Klasyczna)',
      );

  String dieSidesOptionLabel(int sides) {
    switch (sides) {
      case 4:
        return _pick(
          da: 'd4 Pyramide (1–4)',
          en: 'd4 Tetrahedron (1–4)',
          sv: 'd4 Pyramid (1–4)',
          no: 'd4 Pyramide (1–4)',
          fi: 'd4 Tetraedri (1–4)',
          is_: 'd4 Fjórflötungur (1–4)',
          de: 'd4 Tetraeder (1–4)',
          nl: 'd4 Tetraëder (1–4)',
          fr: 'd4 Tétraèdre (1–4)',
          es: 'd4 Tetraedro (1–4)',
          it: 'd4 Tetraedro (1–4)',
          pl: 'd4 Czworościan (1–4)',
        );
      case 8:
        return _pick(
          da: 'd8 Oktaeder (1–8)',
          en: 'd8 Octahedron (1–8)',
          sv: 'd8 Oktaeder (1–8)',
          no: 'd8 Oktaeder (1–8)',
          fi: 'd8 Oktaedri (1–8)',
          is_: 'd8 Áttflötungur (1–8)',
          de: 'd8 Oktaeder (1–8)',
          nl: 'd8 Octaëder (1–8)',
          fr: 'd8 Octaèdre (1–8)',
          es: 'd8 Octaedro (1–8)',
          it: 'd8 Ottaedro (1–8)',
          pl: 'd8 Ośmiościan (1–8)',
        );
      case 10:
        return _pick(
          da: 'd10 Dekaeder (1–10)',
          en: 'd10 Decahedron (1–10)',
          sv: 'd10 Dekaeder (1–10)',
          no: 'd10 Dekaeder (1–10)',
          fi: 'd10 Dekaedri (1–10)',
          is_: 'd10 Tíflötungur (1–10)',
          de: 'd10 Dekaeder (1–10)',
          nl: 'd10 Decaëder (1–10)',
          fr: 'd10 Décaèdre (1–10)',
          es: 'd10 Decaedro (1–10)',
          it: 'd10 Decaedro (1–10)',
          pl: 'd10 Dziesięciościan (1–10)',
        );
      case 12:
        return _pick(
          da: 'd12 Dodekaeder (1–12)',
          en: 'd12 Dodecahedron (1–12)',
          sv: 'd12 Dodekaeder (1–12)',
          no: 'd12 Dodekaeder (1–12)',
          fi: 'd12 Dodekaedri (1–12)',
          is_: 'd12 Tólfflötungur (1–12)',
          de: 'd12 Dodekaeder (1–12)',
          nl: 'd12 Dodecaëder (1–12)',
          fr: 'd12 Dodécaèdre (1–12)',
          es: 'd12 Dodecaedro (1–12)',
          it: 'd12 Dodecaedro (1–12)',
          pl: 'd12 Dwunastościan (1–12)',
        );
      case 20:
        return _pick(
          da: 'd20 Ikosaeder (1–20)',
          en: 'd20 Icosahedron (1–20)',
          sv: 'd20 Ikosaeder (1–20)',
          no: 'd20 Ikosaeder (1–20)',
          fi: 'd20 Ikosaedri (1–20)',
          is_: 'd20 Tuttuguflötungur (1–20)',
          de: 'd20 Ikosaeder (1–20)',
          nl: 'd20 Icosaëder (1–20)',
          fr: 'd20 Icosaèdre (1–20)',
          es: 'd20 Icosaedro (1–20)',
          it: 'd20 Icosaedro (1–20)',
          pl: 'd20 Dwudziestościan (1–20)',
        );
      case 6:
      default:
        return _pick(
          da: 'd6 Standard (1–6)',
          en: 'd6 Cube (1–6)',
          sv: 'd6 Kub (1–6)',
          no: 'd6 Kube (1–6)',
          fi: 'd6 Kuutio (1–6)',
          is_: 'd6 Teningur (1–6)',
          de: 'd6 Würfel (1–6)',
          nl: 'd6 Kubus (1–6)',
          fr: 'd6 Cube (1–6)',
          es: 'd6 Cubo (1–6)',
          it: 'd6 Cubo (1–6)',
          pl: 'd6 Sześcian (1–6)',
        );
    }
  }

  String get maxRollsSettingLabel => _pick(
        da: 'Kast pr. tur',
        en: 'Rolls per Turn',
        sv: 'Kast per tur',
        no: 'Kast per tur',
        fi: 'Heittoja vuorossa',
        is_: 'Köst í umferð',
        de: 'Würfe pro Zug',
        nl: 'Worpen per beurt',
        fr: 'Lancers par tour',
        es: 'Tiradas por turno',
        it: 'Lanci per turno',
        pl: 'Rzuty w turze',
      );

  String maxRollsOptionLabel(int rolls) {
    if (rolls == 1) {
      return _pick(
        da: '1 kast (Hardcore)',
        en: '1 roll (Hardcore)',
        sv: '1 kast (Hardcore)',
        no: '1 kast (Hardcore)',
        fi: '1 heitto (Hardcore)',
        is_: '1 kast (Hardcore)',
        de: '1 Wurf (Hardcore)',
        nl: '1 worp (Hardcore)',
        fr: '1 lancer (Hardcore)',
        es: '1 tirada (Hardcore)',
        it: '1 lancio (Hardcore)',
        pl: '1 rzut (Hardcore)',
      );
    }
    return _pick(
      da: '$rolls kast',
      en: '$rolls rolls',
      sv: '$rolls kast',
      no: '$rolls kast',
      fi: '$rolls heittoa',
      is_: '$rolls köst',
      de: '$rolls Würfe',
      nl: '$rolls worpen',
      fr: '$rolls lancers',
      es: '$rolls tiradas',
      it: '$rolls lanci',
      pl: '$rolls rzuty',
    );
  }

  String get upperParSettingLabel => _pick(
        da: 'Øverste bonus-krav (± beregning)',
        en: 'Upper Section Par (± calculation)',
        sv: 'Övre bonuskrav (± beräkning)',
        no: 'Øvre bonuskrav (± beregning)',
        fi: 'Yläosan bonustavoite (± laskenta)',
        is_: 'Viðmið í efri hluta (± útreikningur)',
        de: 'Bonus-Richtwert oben (± Berechnung)',
        nl: 'Bonus-richtlijn boven (± berekening)',
        fr: 'Référence Bonus Supérieur (calcul ±)',
        es: 'Referencia Bono Superior (cálculo ±)',
        it: 'Riferimento Bonus Superiore (calcolo ±)',
        pl: 'Wymóg bonusu górnej sekcji (obliczanie ±)',
      );

  String upperParOptionLabel(int parCount, {int sumOfFaces = 21}) {
    final parTotal = parCount * sumOfFaces;
    return _pick(
      da: '± omkring $parCount ens af hver (Par = $parTotal p)',
      en: '± around $parCount of each kind (Par = $parTotal pts)',
      sv: '± runt $parCount lika av varje (Par = $parTotal p)',
      no: '± rundt $parCount like av hver (Par = $parTotal p)',
      fi: '± $parCount kutakin lukua (Par = $parTotal p)',
      is_: '± miðað við $parCount af hverjum (Par = $parTotal p)',
      de: '± um $parCount Gleiche je Zahl (Par = $parTotal Pkt)',
      nl: '± rond $parCount van elk (Par = $parTotal pnt)',
      fr: '± autour de $parCount de chaque (Par = $parTotal pts)',
      es: '± sobre $parCount de cada número (Par = $parTotal pts)',
      it: '± rispetto a $parCount per tipo (Par = $parTotal pt)',
      pl: '± wokół $parCount z każdego oczka (Par = $parTotal pkt)',
    );
  }

  String get playersSectionLabel => _pick(
        da: 'Spillere',
        en: 'Players',
        sv: 'Spelare',
        no: 'Spillere',
        fi: 'Pelaajat',
        is_: 'Leikmenn',
        de: 'Spieler',
        nl: 'Spelers',
        fr: 'Joueurs',
        es: 'Jugadores',
        it: 'Giocatori',
        pl: 'Gracze',
      );

  String get addAnotherPlayer => _pick(
        da: '+ Tilføj spiller',
        en: '+ Add Another Player',
        sv: '+ Lägg till spelare',
        no: '+ Legg til spiller',
        fi: '+ Lisää pelaaja',
        is_: '+ Bæta við leikmanni',
        de: '+ Spieler hinzufügen',
        nl: '+ Speler toevoegen',
        fr: '+ Ajouter un joueur',
        es: '+ Añadir jugador',
        it: '+ Aggiungi giocatore',
        pl: '+ Dodaj gracza',
      );

  String get updateNamesOnly => _pick(
        da: 'Opdater kun navne',
        en: 'Update Names Only',
        sv: 'Uppdatera endast namn',
        no: 'Oppdater kun navn',
        fi: 'Päivitä vain nimet',
        is_: 'Uppfæra aðeins nöfn',
        de: 'Nur Namen aktualisieren',
        nl: 'Alleen namen bijwerken',
        fr: 'Mettre à jour les noms',
        es: 'Actualizar solo nombres',
        it: 'Aggiorna solo i nomi',
        pl: 'Zaktualizuj tylko imiona',
      );

  String get startNewGame => _pick(
        da: 'Start nyt spil',
        en: 'Start New Game',
        sv: 'Starta nytt spel',
        no: 'Start nytt spill',
        fi: 'Aloita uusi peli',
        is_: 'Hefja nýjan leik',
        de: 'Neues Spiel starten',
        nl: 'Nieuw spel starten',
        fr: 'Nouvelle partie',
        es: 'Empezar nueva partida',
        it: 'Nuova partita',
        pl: 'Nowa gra',
      );

  String get removePlayerTooltip => _pick(
        da: 'Fjern spiller',
        en: 'Remove player',
        sv: 'Ta bort spelare',
        no: 'Fjern spiller',
        fi: 'Poista pelaaja',
        is_: 'Fjarlægja leikmann',
        de: 'Spieler entfernen',
        nl: 'Speler verwijderen',
        fr: 'Supprimer le joueur',
        es: 'Eliminar jugador',
        it: 'Rimuovi giocatore',
        pl: 'Usuń gracza',
      );

  // Game Over Dialog
  String tieHeader(String names) => _pick(
        da: 'Uafgjort! ($names)',
        en: "It's a Tie! ($names)",
        sv: 'Oavgjort! ($names)',
        no: 'Uavgjort! ($names)',
        fi: 'Tasapeli! ($names)',
        is_: 'Jafntefli! ($names)',
        de: 'Unentschieden! ($names)',
        nl: 'Gelijkspel! ($names)',
        fr: 'Égalité ! ($names)',
        es: '¡Empate! ($names)',
        it: 'Pareggio! ($names)',
        pl: 'Remis! ($names)',
      );

  String winnerHeader(String name) => _pick(
        da: '$name vinder!',
        en: '$name Wins!',
        sv: '$name vinner!',
        no: '$name vinner!',
        fi: '$name voittaa!',
        is_: '$name vinnur!',
        de: '$name gewinnt!',
        nl: '$name wint!',
        fr: '$name gagne !',
        es: '¡$name gana!',
        it: '$name vince!',
        pl: '$name wygrywa!',
      );

  String get finalStandingsSub => _pick(
        da: 'Endelig stilling på pointblokken',
        en: 'Final Scorecard Standings',
        sv: 'Slutställning i protokollet',
        no: 'Endelig stilling på blokken',
        fi: 'Lopulliset tulokset',
        is_: 'Lokastaða á stigablaði',
        de: 'Endstand auf dem Spielblock',
        nl: 'Eindstand op het scoreblok',
        fr: 'Classement final',
        es: 'Clasificación final',
        it: 'Classifica finale',
        pl: 'Końcowa klasyfikacja',
      );

  String playerBreakdownLine(
    int parTotal,
    String diffStr,
    int bonus,
    int lower,
  ) =>
      _pick(
        da: '$parTotal (par) $diffStr (øverste ±) + $bonus (bonus) + $lower (nederste)',
        en: '$parTotal (par) $diffStr (upper ±) + $bonus (bonus) + $lower (lower)',
        sv: '$parTotal (par) $diffStr (övre ±) + $bonus (bonus) + $lower (nedre)',
        no: '$parTotal (par) $diffStr (øvre ±) + $bonus (bonus) + $lower (nedre)',
        fi: '$parTotal (par) $diffStr (ylä ±) + $bonus (bonus) + $lower (ala)',
        is_: '$parTotal (par) $diffStr (efri ±) + $bonus (bónus) + $lower (neðri)',
        de: '$parTotal (Par) $diffStr (oben ±) + $bonus (Bonus) + $lower (unten)',
        nl: '$parTotal (par) $diffStr (boven ±) + $bonus (bonus) + $lower (onder)',
        fr: '$parTotal (par) $diffStr (sup ±) + $bonus (bonus) + $lower (inf)',
        es: '$parTotal (par) $diffStr (sup ±) + $bonus (bono) + $lower (inf)',
        it: '$parTotal (par) $diffStr (sup ±) + $bonus (bonus) + $lower (inf)',
        pl: '$parTotal (par) $diffStr (góra ±) + $bonus (bonus) + $lower (dół)',
      );

  String get inspectScorecard => _pick(
        da: 'Se pointblok',
        en: 'Inspect Scorecard',
        sv: 'Se protokoll',
        no: 'Se poengblokk',
        fi: 'Tarkastele korttia',
        is_: 'Skoða stigablað',
        de: 'Spielblock ansehen',
        nl: 'Scoreblok bekijken',
        fr: 'Voir la feuille',
        es: 'Ver tabla de puntos',
        it: 'Vedi segnapunti',
        pl: 'Zobacz kartę wyników',
      );

  String get playAgainRematch => _pick(
        da: 'Spil igen (Revanche)',
        en: 'Play Again (Rematch)',
        sv: 'Spela igen (Revansch)',
        no: 'Spill igjen (Omkamp)',
        fi: 'Pelaa uudelleen',
        is_: 'Spila aftur',
        de: 'Nochmal spielen (Revanche)',
        nl: 'Opnieuw spelen',
        fr: 'Rejouer (Revanche)',
        es: 'Jugar de nuevo (Revancha)',
        it: 'Gioca ancora (Rivincita)',
        pl: 'Zagraj ponownie (Rewanż)',
      );

  // Rules Dialog Content
  String get rulesDialogTitle => _pick(
        da: 'Yatzy-regler & Varianter (5, 6, 7 & d8)',
        en: 'Yatzy Rules & Variants (5, 6, 7 & d8)',
        sv: 'Yatzy-regler & Varianter (5, 6, 7 & d8)',
        no: 'Yatzy-regler & Varianter (5, 6, 7 & d8)',
        fi: 'Yatzy-säännöt & Muodot (5, 6, 7 & d8)',
        is_: 'Yatzy-reglur & Leikgerðir (5, 6, 7 & d8)',
        de: 'Yatzy-Regeln & Varianten (5, 6, 7 & d8)',
        nl: 'Yatzy-regels & Varianten (5, 6, 7 & d8)',
        fr: 'Règles & Variantes du Yatzy (5, 6, 7 & d8)',
        es: 'Reglas y Variantes de Yatzy (5, 6, 7 y d8)',
        it: 'Regole e Varianti Yatzy (5, 6, 7 e d8)',
        pl: 'Zasady i Warianty Yatzy (5, 6, 7 i d8)',
      );

  List<RulesSectionData> get rulesSections => [
        RulesSectionData(
          title: _pick(
            da: '1. Turforløb, Kast & Fortryd (Undo)',
            en: '1. Turn Flow, Rolls & Undo',
            sv: '1. Spelomgång, Kast & Ångra (Undo)',
            no: '1. Turforløp, Kast & Angre (Undo)',
            fi: '1. Vuoron kulku, Heitot & Kumoa (Undo)',
            is_: '1. Umferð, Köst & Afturkalla (Undo)',
            de: '1. Spielzug, Würfe & Rückgängig (Undo)',
            nl: '1. Beurtverloop, Worpen & Ongedaan maken',
            fr: '1. Déroulement, Lancers & Annuler (Undo)',
            es: '1. Turno, Tiradas y Deshacer (Undo)',
            it: '1. Turno, Lanci e Annulla (Undo)',
            pl: '1. Tura, Rzuty i Cofanie (Undo)',
          ),
          bullets: [
            _pick(
              da: 'Kast 1 rulles automatisk ved turens start. Du har 3, 4 eller 5 kast pr. tur afhængigt af valgt variant.',
              en: 'Roll 1 happens automatically at the start of every turn. You get 3, 4, or 5 rolls per turn depending on the chosen variant.',
              sv: 'Kast 1 slås automatiskt. Du har 3, 4 eller 5 kast per tur beroende på vald variant.',
              no: 'Kast 1 trilles automatisk. Du har 3, 4 eller 5 kast per tur avhengig av valgt variant.',
              fi: 'Heitto 1 heitetään automaattisesti. Saat 3, 4 tai 5 heittoa vuorossa valitun muodon mukaan.',
              is_: 'Kasti 1 er kastað sjálfkrafa. Þú færð 3, 4 eða 5 köst í umferð eftir leikgerð.',
              de: 'Wurf 1 erfolgt automatisch. Je nach Variante hast du 3, 4 oder 5 Würfe pro Zug.',
              nl: 'Worp 1 gaat automatisch. Afhankelijk van de variant heb je 3, 4 of 5 worpen per beurt.',
              fr: 'Le Lancer 1 est automatique. Vous disposez de 3, 4 ou 5 lancers selon la variante.',
              es: 'La Tirada 1 es automática. Tienes 3, 4 o 5 tiradas por turno según la variante.',
              it: 'Il Lancio 1 è automatico. Hai 3, 4 o 5 lanci per turno a seconda della variante.',
              pl: 'Rzut 1 wykonywany jest automatycznie. Masz 3, 4 lub 5 rzutów w zależności od wariantu.',
            ),
            _pick(
              da: 'Klik på en terning for at HOLDE/frigive den. Du kan når som helst klikke på en ledig række på blokken for at notere point.',
              en: 'Tap any die to HOLD/release it. You can assign your current dice to ANY open row at ANY point during your turn.',
              sv: 'Klicka på en tärning för att SPARA/släppa den. Klicka på valfri ledig rad när som helst för att poängsätta.',
              no: 'Klikk på en terning for å HOLDE/frigi den. Klikk på en ledig rad når som helst for å notere poeng.',
              fi: 'Napauta noppaa LUKITAKSESI sen. Voit merkitä tuloksen mille tahansa vapaalle riville milloin vain.',
              is_: 'Smelltu á tening til að GEYMA hann. Þú getur skráð stig á lausa línu hvenær sem er.',
              de: 'Tippe Würfel an zum HALTEN. Du kannst jederzeit eine freie Zeile im Block antippen, um Punkte einzutragen.',
              nl: 'Tik op een dobbelsteen om VAST te houden. Klik op elk moment op een open vak om te scoren.',
              fr: 'Touchez un dé pour le GARDER. Cliquez sur une ligne libre à tout moment pour inscrire le score.',
              es: 'Toca un dado para GUARDARLO. Haz clic en cualquier casilla libre en cualquier momento para anotar.',
              it: 'Tocca un dado per TENERLO. Clicca su una riga libera in qualsiasi momento per segnare i punti.',
              pl: 'Kliknij kość, aby ją ZATRZYMAĆ. W każdej chwili możesz kliknąć wolny wiersz, aby zapisać punkty.',
            ),
            _pick(
              da: 'FORTRYD-knappen (Undo) er altid tilgængelig øverst og i terningbakken — du kan fortryde noterede point flere træk tilbage!',
              en: 'The UNDO button is always available in the header and dice tray — you can undo score assignments multiple turns back!',
              sv: 'ÅNGRA-knappen (Undo) finns alltid i toppen och vid tärningarna — du kan ångra flera drag bakåt!',
              no: 'ANGRE-knappen (Undo) er alltid tilgjengelig øverst og i terningbrettet — du kan angre flere trekk tilbake!',
              fi: 'KUMOA-painike (Undo) on aina näkyvissä yläpalkissa ja noppatarjottimella!',
              is_: 'AFTURKALLA-hnappurinn (Undo) er alltaf sýnilegur efst og við teningana!',
              de: 'Der RÜCKGÄNGIG-Button (Undo) ist immer oben und beim Würfelbrett sichtbar!',
              nl: 'De ONGEDAAN MAKEN-knop (Undo) is altijd zichtbaar bovenin en bij het dobbelsteenveld!',
              fr: 'Le bouton ANNULER (Undo) est toujours accessible en haut et près des dés !',
              es: 'El botón DESHACER (Undo) está siempre visible arriba y junto a los dados.',
              it: 'Il pulsante ANNULLA (Undo) è sempre visibile in alto e nel vassoio dei dadi.',
              pl: 'Przycisk COFNIJ (Undo) jest zawsze widoczny na górze i przy kościach!',
            ),
          ],
        ),
        RulesSectionData(
          title: _pick(
            da: '2. Øverste Sektion (± Omkring Par & d8 Terninger)',
            en: '2. Upper Section (± Around Par & d8 Dice)',
            sv: '2. Övre Sektion (± Runt Par & d8 Tärningar)',
            no: '2. Øvre Del (± Rundt Par & d8 Terninger)',
            fi: '2. Yläosa (± Par-luku & d8 Nopat)',
            is_: '2. Efri Hluti (± Viðmið & d8 Teningar)',
            de: '2. Oberer Teil (± Um Par & d8 Würfel)',
            nl: '2. Bovenste Helft (± Rond Par & d8 Dobbelstenen)',
            fr: '2. Section Supérieure (± Autour du Par & Dés d8)',
            es: '2. Sección Superior (± Sobre Par y Dados d8)',
            it: '2. Sezione Superiore (± Rispetto al Par e Dadi d8)',
            pl: '2. Górna Sekcja (± Wokół Par i Kości d8)',
          ),
          bullets: [
            _pick(
              da: 'Øverste sektion tælles som ± omkring 3 ens eller 4 ens. Samlet ± sum på 0 eller mere udløser +50p Bonus!',
              en: 'Upper section is scored as ± around 3 or 4 of a kind. A total ± sum of 0 or higher awards the +50p Bonus!',
              sv: 'Övre sektionen räknas som ± runt 3 eller 4 lika. Total ± summa på 0 eller mer ger +50p Bonus!',
              no: 'Øvre del regnes som ± rundt 3 eller 4 like. Total ± sum på 0 eller mer gir +50p Bonus!',
              fi: 'Yläosa lasketaan ± suhteessa 3 tai 4 samaan. Yhteissumma ≥ 0 antaa +50p Bonuksen!',
              is_: 'Efri hluti reiknast sem ± miðað við 3 eða 4 eins. Heildarsumma ≥ 0 gefur +50p Bónus!',
              de: 'Der obere Teil wird als ± um 3 oder 4 Gleiche gewertet. Summe ≥ 0 bringt den +50p Bonus!',
              nl: 'Bovenste helft telt als ± rond 3 of 4 dezelfde. Som ≥ 0 levert de +50p Bonus op!',
              fr: 'La section supérieure est comptée en ± autour de 3 ou 4 dés identiques. Somme ≥ 0 donne +50p Bonus !',
              es: 'La sección superior se puntúa en ± sobre 3 o 4 iguales. ¡Suma ≥ 0 otorga +50p de Bono!',
              it: 'La sezione superiore si calcola in ± rispetto a 3 o 4 uguali. Somma ≥ 0 assegna +50p Bonus!',
              pl: 'Górna sekcja liczona jest jako ± wokół 3 lub 4 jednakowych. Suma ≥ 0 daje +50 pkt Bonusu!',
            ),
            _pick(
              da: 'I Oktaeder d8 Fantasy-varianten har terningerne 8 sider (1–8), så øverste sektion indeholder også 7\'ere og 8\'ere!',
              en: 'In Octahedron d8 Fantasy mode, dice have 8 faces (1–8), expanding the Upper Section with Sevens (7s) and Eights (8s)!',
              sv: 'I Oktaeder d8 Fantasy har tärningarna 8 sidor (1–8), vilket lägger till Sjuor (7) och Åttor (8) i övre sektionen!',
              no: 'I Oktaeder d8 Fantasy har terningene 8 sider (1–8), så øvre del inkluderer Syvere (7) og Åttere (8)!',
              fi: 'Oktaedri d8 -muodossa nopissa on 8 sivua (1–8), jolloin mukana ovat myös Seiskat (7) ja Kasit (8)!',
              is_: 'Í d8 Fantasy eru teningar með 8 hliðar (1–8), og bætast þá Sjöur og Áttur við efri hlutann!',
              de: 'Im Oktaeder d8 Fantasy-Modus haben die Würfel 8 Seiten (1–8) inkl. Siebener (7) und Achter (8)!',
              nl: 'In Octaëder d8 Fantasy hebben dobbelstenen 8 zijden (1–8), inclusief Zevens (7) en Achten (8)!',
              fr: 'En mode Fantasy d8, les dés ont 8 faces (1–8), ajoutant les Sept (7) et Huit (8) !',
              es: 'En el modo Fantasía d8, los dados tienen 8 caras (1–8), ¡añadiendo Sietes y Ochos!',
              it: 'Nella modalità Fantasy d8 i dadi hanno 8 facce (1–8), aggiungendo Sette e Otto!',
              pl: 'W trybie Fantasy d8 kości mają 8 ścianek (1–8), dodając Siódemki (7) i Ósemki (8)!',
            ),
          ],
        ),
        RulesSectionData(
          title: _pick(
            da: '3. Nye Spændende Kombinationer (Maxi, Mega & d8)',
            en: '3. New Exciting Combinations (Maxi, Mega & d8)',
            sv: '3. Nya Spännande Kombinationer (Maxi, Mega & d8)',
            no: '3. Nye Spennende Kombinasjoner (Maxi, Mega & d8)',
            fi: '3. Uudet Erikoisyhdistelmät (Maxi, Mega & d8)',
            is_: '3. Nýjar Spennandi Samsetningar (Maxi, Mega & d8)',
            de: '3. Neue Spezialkombinationen (Maxi, Mega & d8)',
            nl: '3. Nieuwe Speciale Combinaties (Maxi, Mega & d8)',
            fr: '3. Nouvelles Combinaisons (Maxi, Méga & d8)',
            es: '3. Nuevas Combinaciones Especiales (Maxi, Mega y d8)',
            it: '3. Nuove Combinazioni Speciali (Maxi, Mega e d8)',
            pl: '3. Nowe Układy Specjalne (Maxi, Mega i d8)',
          ),
          bullets: [
            _pick(
              da: 'Villa (2×3 ens) & Tårn (4+2 ens): Klassiske 6-terningers Maxi-kombinationer med forskellige terningværdier.',
              en: 'Villa (2×3 of a Kind) & Tower (4+2 of a Kind): Classic 6-dice combinations requiring distinct face values.',
              sv: 'Villa (2×tretal) & Torn (fyrtal+par): Klassiska 6-tärningskombinationer med olika valörer.',
              no: 'Hytta (2×3 like) & Tårn (4+2 like): Klassiske 6-terningskombinasjoner med ulike verdier.',
              fi: 'Huvila (2×3 samaa) & Torni (4+2 samaa): 6 nopan erikoisyhdistelmät eri silmäluvuilla.',
              is_: 'Villa (2×þrenna) & Turn (4+2 eins): 6 teninga samsetningar með ólíkum tölum.',
              de: 'Villa (2×Drilling) & Turm (4+2 Gleiche): 6-Würfel-Kombinationen mit unterschiedlichen Zahlen.',
              nl: 'Villa (2×3 dezelfde) & Toren (4+2 dezelfde): 6-dobbelstenen combinaties met verschillende waarden.',
              fr: 'Villa (2×brelan) & Tour (carré+paire) : Combinaisons à 6 dés de valeurs distinctes.',
              es: 'Villa (2×trío) y Torre (póker+pareja): Combinaciones de 6 dados con valores distintos.',
              it: 'Villa (2×tris) e Torre (poker+coppia): Combinazioni a 6 dadi con valori diversi.',
              pl: 'Willa (2×trójka) i Wieża (4+2): Układy 6 kości o różnych wartościach oczek.',
            ),
            _pick(
              da: 'Pyramide (3+2+1 ens): 3 af én slags + 2 af en anden + 1 af en tredje (sum af de 6 terninger).',
              en: 'Pyramid (3+2+1 Kind): 3 of one face + 2 of another + 1 of a third distinct face (sum of those 6 dice).',
              sv: 'Pyramid (3+2+1 lika): Tretal + par + 1 annan valör (summan av de 6 tärningarna).',
              no: 'Pyramide (3+2+1 like): 3 av én + 2 av en annen + 1 av en tredje (summen av de 6).',
              fi: 'Pyramidi (3+2+1 samaa): 3 samaa + pari + 1 eri luku (6 nopan summa).',
              is_: 'Píramídi (3+2+1 eins): Þrenna + par + 1 önnur tala (summa 6 teninga).',
              de: 'Pyramide (3+2+1 Gleiche): Drilling + Paar + 1 einzelner (Summe der 6 Würfel).',
              nl: 'Piramide (3+2+1 dezelfde): 3 dezelfde + paar + 1 andere (som van de 6).',
              fr: 'Pyramide (3+2+1) : Brelan + paire + 1 dé distinct (somme des 6 dés).',
              es: 'Pirámide (3+2+1): Trío + pareja + 1 dado distinto (suma de los 6 dados).',
              it: 'Piramide (3+2+1): Tris + coppia + 1 dado diverso (somma dei 6 dadi).',
              pl: 'Piramida (3+2+1): Trójka + para + 1 inna kość (suma 6 kości).',
            ),
            _pick(
              da: 'Kun Lige / Kun Ulige: Alle terninger viser lige tal (2,4,6,8) hhv. ulige tal (1,3,5,7) — giver summen af alle terninger!',
              en: 'Even Only / Odd Only: All rolled dice show even numbers (or all odd numbers) — scores the sum of all dice!',
              sv: 'Endast Jämna / Endast Udda: Alla tärningar är jämna respektive udda — ger summan av alla tärningar!',
              no: 'Kun Partall / Kun Oddetall: Alle terninger viser partall eller oddetall — gir summen av alle terninger!',
              fi: 'Vain Parilliset / Parittomat: Kaikki nopat parillisia tai parittomia — antaa kaikkien noppien summan!',
              is_: 'Aðeins Sléttar / Oddatölur: Allir teningar sléttir eða oddatölur — gefur summu allra teninga!',
              de: 'Nur Gerade / Nur Ungerade: Alle Würfel gerade bzw. ungerade — zählt die Summe aller Würfel!',
              nl: 'Alleen Even / Alleen Oneven: Alle dobbelstenen even of oneven — scoort de som van alle dobbelstenen!',
              fr: 'Pairs / Impairs Uniquement : Tous les dés pairs ou impairs — marque la somme de tous les dés !',
              es: 'Solo Pares / Solo Impares: Todos los dados pares o impares — ¡suma todos los dados!',
              it: 'Solo Pari / Solo Dispari: Tutti i dadi pari o dispari — vale la somma di tutti i dadi!',
              pl: 'Tylko Parzyste / Nieparzyste: Wszystkie kości parzyste lub nieparzyste — daje sumę wszystkich oczek!',
            ),
            _pick(
              da: 'Royal Straight (30p ved 6 i træk på d8) • Yatzy (50p) • Super Yatzy (75p når alle terninger er ens i Mega/Turbo/d8)!',
              en: 'Royal Straight (30p for 6 consecutive on d8) • Yatzy (50p) • Super Yatzy (75p bonus jackpot when all dice match)!',
              sv: 'Kunglig Stege (30p för 6 i rad på d8) • Yatzy (50p) • Super Yatzy (75p bonusjackpott när alla är lika)!',
              no: 'Royal Straight (30p for 6 på rad med d8) • Yatzy (50p) • Super Yatzy (75p bonusjackpot når alle er like)!',
              fi: 'Kuningassuora (30p d8-nopilla) • Yatzy (50p) • Super Yatzy (75p kun kaikki nopat ovat samat)!',
              is_: 'Konungsröð (30p á d8) • Yatzy (50p) • Ofur Yatzy (75p þegar allir teningar eru eins)!',
              de: 'Königsstraße (30p bei d8) • Yatzy (50p) • Super Yatzy (75p Jackpot, wenn alle Würfel gleich sind)!',
              nl: 'Koningsstraat (30p bij d8) • Yatzy (50p) • Super Yatzy (75p jackpot als alle dobbelstenen gelijk zijn)!',
              fr: 'Suite Royale (30p sur d8) • Yatzy (50p) • Super Yatzy (75p jackpot si tous les dés sont identiques) !',
              es: 'Escalera Real (30p en d8) • Yatzy (50p) • Súper Yatzy (¡75p si todos los dados son iguales!)',
              it: 'Scala Reale (30p con d8) • Yatzy (50p) • Super Yatzy (75p se tutti i dadi sono uguali)!',
              pl: 'Królewski Strit (30 pkt na d8) • Yatzy (50 pkt) • Super Yatzy (75 pkt gdy wszystkie kości są jednakowe)!',
            ),
          ],
        ),
        RulesSectionData(
          title: _pick(
            da: '4. Formel for Samlet Sum',
            en: '4. Grand Total Formula',
            sv: '4. Formel för Totalsumma',
            no: '4. Formel for Totalsum',
            fi: '4. Lopputuloksen kaava',
            is_: '4. Reikniregla fyrir Heildartölu',
            de: '4. Formel für die Gesamtsumme',
            nl: '4. Formule voor de Totaalscore',
            fr: '4. Formule du Total Général',
            es: '4. Fórmula del Total General',
            it: '4. Formula del Totale Generale',
            pl: '4. Wzór na Sumę Całkowitą',
          ),
          bullets: [
            _pick(
              da: 'Samlet Sum = Par (63/84/108/144) + Øverste (± sum) + Bonus (50p) + Nederste Sektion',
              en: 'Grand Total = Par (63/84/108/144) + Upper (± sum) + Bonus (50p) + Lower Section',
              sv: 'Totalsumma = Par (63/84/108/144) + Övre (± summa) + Bonus (50p) + Nedre Sektion',
              no: 'Totalsum = Par (63/84/108/144) + Øvre (± sum) + Bonus (50p) + Nedre Del',
              fi: 'Lopputulos = Par (63/84/108/144) + Yläosa (± summa) + Bonus (50p) + Alaosa',
              is_: 'Heildartala = Par (63/84/108/144) + Efri (± summa) + Bónus (50p) + Neðri Hluti',
              de: 'Gesamtsumme = Par (63/84/108/144) + Oben (± Summe) + Bonus (50p) + Unterer Teil',
              nl: 'Totaalscore = Par (63/84/108/144) + Boven (± som) + Bonus (50p) + Onderste Helft',
              fr: 'Total Général = Par (63/84/108/144) + Supérieur (somme ±) + Bonus (50p) + Section Inférieure',
              es: 'Total General = Par (63/84/108/144) + Superior (suma ±) + Bono (50p) + Sección Inferior',
              it: 'Totale Generale = Par (63/84/108/144) + Superiore (somma ±) + Bonus (50p) + Sezione Inferiore',
              pl: 'Suma Całkowita = Par (63/84/108/144) + Góra (suma ±) + Bonus (50p) + Dolna Sekcja',
            ),
          ],
        ),
      ];

  // ---------------------------------------------------------------------------
  // Strategy Coach / Expected Best Score (EV) Mode
  // ---------------------------------------------------------------------------

  String get coachButtonLabel => _pick(
        da: '🎓 Coach',
        en: '🎓 Coach',
        sv: '🎓 Coach',
        no: '🎓 Coach',
        fi: '🎓 Valmentaja',
        is_: '🎓 Þjálfari',
        de: '🎓 Coach',
        nl: '🎓 Coach',
        fr: '🎓 Coach',
        es: '🎓 Coach',
        it: '🎓 Coach',
        pl: '🎓 Trener',
      );

  String coachButtonTooltip(bool enabled) => enabled
      ? _pick(
          da: 'Strategi-coach er TIL (viser forventet værdi / bedste hold & kategori)',
          en: 'Strategy Coach is ON (shows expected best hold & category placement)',
          sv: 'Strategicoach är PÅ (visar förväntat värde / bästa håll & kategori)',
          no: 'Strategicoach er PÅ (viser forventet verdi / beste hold & kategori)',
          fi: 'Strategiavalmentaja PÄÄLLÄ (näyttää odotusarvon ja parhaan valinnan)',
          is_: 'Herkænskuþjálfari KVEIKTUR (sýnir væntigildi og bestu valkosti)',
          de: 'Strategie-Coach ist AN (zeigt Erwartungswert / besten Halt & Kategorie)',
          nl: 'Strategie-coach staat AAN (toont verwachte waarde & beste keuze)',
          fr: 'Coach stratégique ACTIVÉ (affiche l\'espérance / meilleure garde et catégorie)',
          es: 'Coach estratégico ACTIVADO (muestra valor esperado y mejor jugada)',
          it: 'Coach strategico ATTIVO (mostra valore atteso e scelta migliore)',
          pl: 'Trener strategii WŁĄCZONY (pokazuje wartość oczekiwaną i najlepszy ruch)',
        )
      : _pick(
          da: 'Slå Strategi-coach til (lær optimal Yatzy-strategi med forventet score)',
          en: 'Turn ON Strategy Coach (learn optimal Yatzy strategy with expected scores)',
          sv: 'Slå PÅ Strategicoach (lär dig optimal Yatzy-strategi med förväntad poäng)',
          no: 'Slå PÅ Strategicoach (lær optimal Yatzy-strategi med forventet poengsum)',
          fi: 'Kytke Strategiavalmentaja PÄÄLLE (opi optimaalinen Yatzy-strategia)',
          is_: 'Kveikja á Herkænskuþjálfara (lærðu bestu Yatzy-herkænskuna)',
          de: 'Strategie-Coach einschalten (optimale Yatzy-Strategie & Erwartungswerte lernen)',
          nl: 'Schakel Strategie-coach AAN (leer optimale Yatzy-strategie met EV)',
          fr: 'Activer le Coach stratégique (apprendre la stratégie optimale avec espérance)',
          es: 'Activar Coach estratégico (aprende la estrategia óptima con puntaje esperado)',
          it: 'Attiva Coach strategico (impara la strategia ottimale con punteggio atteso)',
          pl: 'Włącz Trenera strategii (ucz się optymalnej strategii Yatzy z EV)',
        );

  String get coachOptimalBadge => _pick(
        da: '✓ Optimalt hold!',
        en: '✓ Optimal hold!',
        sv: '✓ Optimalt val!',
        no: '✓ Optimalt hold!',
        fi: '✓ Optimaalinen!',
        is_: '✓ Besta val!',
        de: '✓ Optimal gehalten!',
        nl: '✓ Optimale keuze!',
        fr: '✓ Garde optimale !',
        es: '✓ ¡Selección óptima!',
        it: '✓ Scelta ottimale!',
        pl: '✓ Optymalny wybór!',
      );

  String get coachApplyHoldButton => _pick(
        da: 'Vælg bedste hold',
        en: 'Select best hold',
        sv: 'Välj bästa håll',
        no: 'Velg beste hold',
        fi: 'Valitse paras pito',
        is_: 'Velja bestu',
        de: 'Beste Auswahl',
        nl: 'Kies beste',
        fr: 'Choisir optimal',
        es: 'Elegir óptimo',
        it: 'Scegli ottimo',
        pl: 'Wybierz najlepsze',
      );

  String coachHoldRecommendation({
    required List<int> heldFaces,
    required double expectedPoints,
    required bool shouldScoreNow,
    required String bestCategoryName,
    required String bestCategoryScore,
    required String targetNames,
  }) {
    final evStr = expectedPoints.toStringAsFixed(1);
    if (shouldScoreNow) {
      return _pick(
        da: '🛑 Stop & notér nu: $bestCategoryName ($bestCategoryScore) er bedre end at kaste om!',
        en: '🛑 Stop & score now: $bestCategoryName ($bestCategoryScore) beats rerolling!',
        sv: '🛑 Stanna & bokför nu: $bestCategoryName ($bestCategoryScore) är bättre än omslag!',
        no: '🛑 Stopp & noter nå: $bestCategoryName ($bestCategoryScore) er bedre enn omkast!',
        fi: '🛑 Merkitse nyt: $bestCategoryName ($bestCategoryScore) on parempi kuin uusi heitto!',
        is_: '🛑 Skráðu núna: $bestCategoryName ($bestCategoryScore) er betra en að kasta aftur!',
        de: '🛑 Jetzt eintragen: $bestCategoryName ($bestCategoryScore) ist besser als neu würfeln!',
        nl: '🛑 Nu noteren: $bestCategoryName ($bestCategoryScore) is beter dan opnieuw gooien!',
        fr: '🛑 Notez maintenant : $bestCategoryName ($bestCategoryScore) bat un relancer !',
        es: '🛑 Anota ahora: ¡$bestCategoryName ($bestCategoryScore) supera volver a tirar!',
        it: '🛑 Segna ora: $bestCategoryName ($bestCategoryScore) è meglio che ritirare!',
        pl: '🛑 Zapisz teraz: $bestCategoryName ($bestCategoryScore) jest lepsze niż przerzut!',
      );
    }
    if (heldFaces.isEmpty) {
      return _pick(
        da: '💡 Bedste træk: Kast alle terninger om (EV: ~$evStr p) → sigter mod $targetNames',
        en: '💡 Best move: Reroll all dice (EV: ~$evStr p) → aiming for $targetNames',
        sv: '💡 Bästa drag: Slå om alla tärningar (EV: ~$evStr p) → siktar på $targetNames',
        no: '💡 Beste trekk: Kast alle terninger om (EV: ~$evStr p) → sikter mot $targetNames',
        fi: '💡 Paras siirto: Heitä kaikki uudelleen (EV: ~$evStr p) → tähtäimessä $targetNames',
        is_: '💡 Besti leikur: Kasta öllum aftur (EV: ~$evStr p) → stefnir á $targetNames',
        de: '💡 Bester Zug: Alle neu würfeln (EV: ~$evStr P.) → Ziel: $targetNames',
        nl: '💡 Beste zet: Gooi alles opnieuw (EV: ~$evStr p) → mikt op $targetNames',
        fr: '💡 Meilleur coup : Tout relancer (EV : ~$evStr p) → vise $targetNames',
        es: '💡 Mejor jugada: Tirar todos de nuevo (EV: ~$evStr p) → buscando $targetNames',
        it: '💡 Mossa migliore: Ritira tutti i dadi (EV: ~$evStr p) → punta a $targetNames',
        pl: '💡 Najlepszy ruch: Przerzuć wszystkie (EV: ~$evStr pkt) → cel: $targetNames',
      );
    }
    final facesStr = '[${heldFaces.join(', ')}]';
    return _pick(
      da: '💡 Bedste hold: Behold $facesStr (EV: ~$evStr p) → sigter mod $targetNames',
      en: '💡 Best hold: Keep $facesStr (EV: ~$evStr p) → aiming for $targetNames',
      sv: '💡 Bästa håll: Behåll $facesStr (EV: ~$evStr p) → siktar på $targetNames',
      no: '💡 Beste hold: Behold $facesStr (EV: ~$evStr p) → sikter mot $targetNames',
      fi: '💡 Paras pito: Pidä $facesStr (EV: ~$evStr p) → tähtäimessä $targetNames',
      is_: '💡 Best að halda: Halda $facesStr (EV: ~$evStr p) → stefnir á $targetNames',
      de: '💡 Bester Halt: Behalte $facesStr (EV: ~$evStr P.) → Ziel: $targetNames',
      nl: '💡 Beste keuze: Houd $facesStr (EV: ~$evStr p) → mikt op $targetNames',
      fr: '💡 Meilleure garde : Garder $facesStr (EV : ~$evStr p) → vise $targetNames',
      es: '💡 Mejor selección: Guardar $facesStr (EV: ~$evStr p) → buscando $targetNames',
      it: '💡 Scelta migliore: Tieni $facesStr (EV: ~$evStr p) → punta a $targetNames',
      pl: '💡 Najlepszy wybór: Zatrzymaj $facesStr (EV: ~$evStr pkt) → cel: $targetNames',
    );
  }

  String coachCategoryRecommendation({
    required String categoryName,
    required String scoreFormatted,
    required double bonusDelta,
    required double netStrategicValue,
    required bool isFinalRoll,
  }) {
    String bonusNote = '';
    if (bonusDelta.abs() >= 1.0) {
      final sign = bonusDelta >= 0 ? '+' : '';
      bonusNote = ' • Bonus EV: $sign${bonusDelta.toStringAsFixed(1)}p';
    }
    final netSign = netStrategicValue >= 0 ? '+' : '';
    final netStr = '$netSign${netStrategicValue.toStringAsFixed(1)}';
    return _pick(
      da: '★ Bedste felt nu: $categoryName ($scoreFormatted) [Strategisk værdi: $netStr$bonusNote]',
      en: '★ Best score slot now: $categoryName ($scoreFormatted) [Strategic EV: $netStr$bonusNote]',
      sv: '★ Bästa ruta nu: $categoryName ($scoreFormatted) [Strategiskt EV: $netStr$bonusNote]',
      no: '★ Beste felt nå: $categoryName ($scoreFormatted) [Strategisk EV: $netStr$bonusNote]',
      fi: '★ Paras rivi nyt: $categoryName ($scoreFormatted) [Strateginen EV: $netStr$bonusNote]',
      is_: '★ Besti reitur núna: $categoryName ($scoreFormatted) [Væntigildi: $netStr$bonusNote]',
      de: '★ Bestes Feld jetzt: $categoryName ($scoreFormatted) [Strategie-EV: $netStr$bonusNote]',
      nl: '★ Beste vakje nu: $categoryName ($scoreFormatted) [Strategische EV: $netStr$bonusNote]',
      fr: '★ Meilleure case : $categoryName ($scoreFormatted) [EV stratégique : $netStr$bonusNote]',
      es: '★ Mejor casilla ahora: $categoryName ($scoreFormatted) [EV estratégico: $netStr$bonusNote]',
      it: '★ Miglior casella ora: $categoryName ($scoreFormatted) [EV strategico: $netStr$bonusNote]',
      pl: '★ Najlepsze pole teraz: $categoryName ($scoreFormatted) [Strategiczne EV: $netStr$bonusNote]',
    );
  }

  String coachCurrentHoldComparison({
    required List<int> curFaces,
    required double curEvPoints,
    required double deltaStrategicEv,
  }) {
    final facesStr = curFaces.isEmpty ? '—' : '[${curFaces.join(',')}]';
    final ptsStr = curEvPoints.toStringAsFixed(1);
    final dStr = deltaStrategicEv.toStringAsFixed(1);
    return _pick(
      da: 'Dit nuværende hold $facesStr: ~$ptsStr p ($dStr EV ift. bedst)',
      en: 'Your current hold $facesStr: ~$ptsStr p ($dStr EV vs best)',
      sv: 'Ditt nuvarande val $facesStr: ~$ptsStr p ($dStr EV mot bäst)',
      no: 'Ditt nåværende hold $facesStr: ~$ptsStr p ($dStr EV mot best)',
      fi: 'Nykyinen valintasi $facesStr: ~$ptsStr p ($dStr EV vrt. paras)',
      is_: 'Núverandi val $facesStr: ~$ptsStr p ($dStr EV m.v. best)',
      de: 'Dein aktueller Halt $facesStr: ~$ptsStr P. ($dStr EV ggü. Bestwert)',
      nl: 'Jouw huidige keuze $facesStr: ~$ptsStr p ($dStr EV t.o.v. beste)',
      fr: 'Votre garde actuelle $facesStr : ~$ptsStr p ($dStr EV vs optimal)',
      es: 'Tu selección actual $facesStr: ~$ptsStr p ($dStr EV vs óptimo)',
      it: 'Scelta attuale $facesStr: ~$ptsStr p ($dStr EV vs migliore)',
      pl: 'Twój obecny wybór $facesStr: ~$ptsStr pkt ($dStr EV vs najlepszy)',
    );
  }

  String get coachHoldAlternativesLabel => _pick(
        da: 'Hold-alternativer:',
        en: 'Hold alternatives:',
        sv: 'Håll-alternativ:',
        no: 'Hold-alternativer:',
        fi: 'Pitovaihtoehdot:',
        is_: 'Valkostir (halda):',
        de: 'Halte-Alternativen:',
        nl: 'Vasthoud-opties:',
        fr: 'Alternatives de garde :',
        es: 'Alternativas de dados:',
        it: 'Alternative dadi:',
        pl: 'Alternatywy zatrzymania:',
      );

  String get coachCategoryAlternativesLabel => _pick(
        da: 'Felt-alternativer:',
        en: 'Slot alternatives:',
        sv: 'Fält-alternativ:',
        no: 'Felt-alternativer:',
        fi: 'Rivivaihtoehdot:',
        is_: 'Valkostir (reitir):',
        de: 'Feld-Alternativen:',
        nl: 'Vak-opties:',
        fr: 'Alternatives de case :',
        es: 'Alternativas de casilla:',
        it: 'Alternative casella:',
        pl: 'Alternatywy pól:',
      );

  String coachFormatHoldShort(List<int> faces, int totalDiceCount) {
    if (faces.isEmpty) {
      return _pick(
        da: 'Kast alle',
        en: 'Reroll all',
        sv: 'Slå om alla',
        no: 'Kast alle',
        fi: 'Heitä kaikki',
        is_: 'Kasta öllum',
        de: 'Alle würfeln',
        nl: 'Alles gooien',
        fr: 'Tout relancer',
        es: 'Tirar todos',
        it: 'Ritira tutti',
        pl: 'Przerzuć',
      );
    }
    if (faces.length == totalDiceCount) {
      return _pick(
        da: 'Behold alle',
        en: 'Keep all',
        sv: 'Behåll alla',
        no: 'Behold alle',
        fi: 'Pidä kaikki',
        is_: 'Halda öllum',
        de: 'Alle halten',
        nl: 'Houd alles',
        fr: 'Tout garder',
        es: 'Guardar todos',
        it: 'Tieni tutti',
        pl: 'Zatrzymaj wszystkie',
      );
    }
    return '[${faces.join(',')}]';
  }

  String get coachHowItWorksButton => _pick(
        da: '📖 Sådan virker Coachen',
        en: '📖 How Coach Works',
        sv: '📖 Så fungerar Coachen',
        no: '📖 Slik virker Coachen',
        fi: '📖 Miten Valmentaja toimii',
        is_: '📖 Hvernig Þjálfarinn virkar',
        de: '📖 Wie der Coach rechnet',
        nl: '📖 Hoe de Coach werkt',
        fr: '📖 Comment fonctionne le Coach',
        es: '📖 Cómo funciona el Coach',
        it: '📖 Come funziona il Coach',
        pl: '📖 Jak działa Trener',
      );

  String get coachGuideTitle => _pick(
        da: '🎓 Sådan regner Strategi-Coachen (Matematik & EV)',
        en: '🎓 How the Strategy Coach Works (Mathematics & EV)',
        sv: '🎓 Så räknar Strategi-Coachen (Matematik & EV)',
        no: '🎓 Slik regner Strategi-Coachen (Matematikk & EV)',
        fi: '🎓 Miten Strategiavalmentaja laskee (Matematiikka & EV)',
        is_: '🎓 Hvernig Herkænskuþjálfarinn reiknar (Stærðfræði & EV)',
        de: '🎓 Wie der Strategie-Coach rechnet (Mathematik & EV)',
        nl: '🎓 Hoe de Strategie-Coach rekent (Wiskunde & EV)',
        fr: '🎓 Comment calcule le Coach Stratégique (Mathématiques & EV)',
        es: '🎓 Cómo calcula el Coach Estratégico (Matemáticas y EV)',
        it: '🎓 Come calcola il Coach Strategico (Matematica ed EV)',
        pl: '🎓 Jak liczy Trener Strategii (Matematyka i EV)',
      );

  String get coachGuideSubtitle => _pick(
        da: 'Eksakt baglæns induktion (Bellman-ligninger), alternativomkostning og +50p bonus-skyggepris',
        en: 'Exact backward induction (Bellman equations), opportunity cost & Upper Bonus shadow pricing',
        sv: 'Exakt bakåtinduktion (Bellman-ekvationer), alternativkostnad och +50p bonusskuggpris',
        no: 'Eksakt baklengs induksjon (Bellman-ligninger), alternativkostnad og +50p bonusskyggepris',
        fi: 'Eksakti takaperin induktio, vaihtoehtoiskustannus ja yläosan bonuksen varjohinta',
        is_: 'Nákvæm afturábak treysting, fórnarkostnaður og bónus-skuggaverð',
        de: 'Exakte Rückwärtsinduktion (Bellman-Gleichungen), Opportunitätskosten & Bonus-Schattenpreis',
        nl: 'Exacte achterwaartse inductie, opportuniteitskosten & bonus-schaduwprijs',
        fr: 'Induction à rebours exacte (équations de Bellman), coût d\'opportunité et prix fictif du bonus',
        es: 'Inducción hacia atrás exacta (ecuaciones de Bellman), costo de oportunidad y valor sombra del bono',
        it: 'Induzione a ritroso esatta, costo opportunità e prezzo ombra del bonus superiore',
        pl: 'Dokładna indukcja wsteczna (równania Bellmana), koszt alternatywny i cena ukryta premii',
      );

  String get coachLiveTableTitle => _pick(
        da: '📊 Live Strategisk Sammenligning for Nuværende Kast',
        en: '📊 Live Strategic Comparison for Your Current Roll',
        sv: '📊 Live Strategisk Jämförelse för Aktuellt Kast',
        no: '📊 Live Strategisk Sammenligning for Nåværende Kast',
        fi: '📊 Reaaliaikainen strateginen vertailu nykyiselle heitolle',
        is_: '📊 Lifandi herkænskusamanburður fyrir núverandi kast',
        de: '📊 Live-Strategievergleich für deinen aktuellen Wurf',
        nl: '📊 Live Strategische Vergelijking voor je Huidige Worp',
        fr: '📊 Comparaison Stratégique en Direct pour votre Lancer Actuel',
        es: '📊 Comparación Estratégica en Vivo para tu Tirada Actual',
        it: '📊 Confronto Strategico Live per il Lancio Attuale',
        pl: '📊 Strategiczne Porównanie na Żywo dla Obecnego Rzutu',
      );

  List<RulesSectionData> coachGuideSections(YatzyGameRules rules) {
    final bonusPts = rules.upperBonusPoints;
    return [
      RulesSectionData(
        title: _pick(
          da: '1. Hvorfor flest rå point her-og-nu ofte er en fejl!',
          en: '1. Why "Highest Raw Points Right Now" is Often a Trap!',
          sv: '1. Varför "flest råa poäng just nu" ofta är en fälla!',
          no: '1. Hvorfor «flest råpoeng akkurat nå» ofte er en felle!',
          fi: '1. Miksi "eniten pisteitä heti" on usein ansa!',
          is_: '1. Af hverju „flest stig strax“ er oft gildra!',
          de: '1. Warum „meiste Rohpunkte sofort“ oft eine Falle ist!',
          nl: '1. Waarom "meeste directe punten" vaak een valkuil is!',
          fr: '1. Pourquoi « le plus de points bruts immédiats » est souvent un piège !',
          es: '1. ¡Por qué "más puntos directos ahora mismo" suele ser una trampa!',
          it: '1. Perché "più punti immediati" è spesso una trappola!',
          pl: '1. Dlaczego „najwięcej punktów naraz” to często pułapka!',
        ),
        bullets: [
          _pick(
            da: 'Begyndere vælger næsten altid det felt, der giver flest point lige nu (f.eks. 20 point i Chance på runde 2, eller 16 point i To Par i stedet for 12 point = 0 Par i 4\'ere).',
            en: 'Beginners often pick whichever category gives the highest immediate score (e.g., burning Chance for 20p on Turn 2, or taking 16p in Two Pairs instead of 12p = Par in Fours).',
            sv: 'Nybörjare väljer ofta den ruta som ger flest poäng direkt (t.ex. bränna Chans för 20p i runda 2).',
            no: 'Nybegynnere velger ofte feltet som gir flest poeng der og da (f.eks. bruke Sjanse for 20p i runde 2).',
            fi: 'Aloittelijat valitsevat usein suurimmat välittömät pisteet (esim. Sattuman käyttäminen 20 pisteeseen vuorolla 2).',
            is_: 'Byrjendur velja oft reitinn sem gefur flest stig strax (t.d. eyða Áhættu fyrir 20 stig í 2. umferð).',
            de: 'Anfänger wählen oft das Feld mit den meisten sofortigen Punkten (z. B. Chance für 20 P. in Runde 2 verbrauchen).',
            nl: 'Beginners kiezen vaak het vakje met de hoogste directe score (bijv. Kans vroeg gebruiken voor 20p).',
            fr: 'Les débutants choisissent souvent la case offrant le plus de points immédiats (ex. gaspiller Chance pour 20p au tour 2).',
            es: 'Los principiantes suelen elegir la casilla que da más puntos inmediatos (p. ej. gastar Libre por 20p en el turno 2).',
            it: 'I principianti scelgono spesso la casella con più punti immediati (es. bruciare Libera per 20p al turno 2).',
            pl: 'Początkujący często wybierają pole dające najwięcej punktów od razu (np. zużycie Szansy za 20 pkt w 2. turze).',
          ),
          _pick(
            da: 'Coachen evaluerer i stedet hvert åbent felt med formlen: Strategisk EV(c) = Rå Point(c) − Alternativomkostning(c) + Δ Bonus-EV(c).',
            en: 'Instead, the Coach evaluates every open slot using: Strategic EV(c) = Raw Points(c) − Opportunity Cost(c) + Δ Upper Bonus EV(c).',
            sv: 'Coachen utvärderar istället varje öppen ruta med: Strategiskt EV(c) = Råpoäng(c) − Alternativkostnad(c) + Δ Bonus-EV(c).',
            no: 'Coachen vurderer i stedet hvert åpent felt med: Strategisk EV(c) = Råpoeng(c) − Alternativkostnad(c) + Δ Bonus-EV(c).',
            fi: 'Valmentaja arvioi jokaisen avoimen rivin kaavalla: Strateginen EV(c) = Pisteet(c) − Vaihtoehtoiskustannus(c) + Δ Bonus-EV(c).',
            is_: 'Þjálfarinn metur hvern opinn reit með: Strategískt EV(c) = Stig(c) − Fórnarkostnaður(c) + Δ Bónus-EV(c).',
            de: 'Der Coach bewertet jedes offene Feld nach: Strategie-EV(c) = Rohpunkte(c) − Opportunitätskosten(c) + Δ Bonus-EV(c).',
            nl: 'De Coach beoordeelt elk open vakje via: Strategische EV(c) = Directe Punten(c) − Opportuniteitskosten(c) + Δ Bonus-EV(c).',
            fr: 'Le Coach évalue chaque case ouverte selon : EV Stratégique(c) = Points Bruts(c) − Coût d\'Opportunité(c) + Δ EV Bonus(c).',
            es: 'El Coach evalúa cada casilla abierta mediante: EV Estratégico(c) = Puntos Directos(c) − Costo de Oportunidad(c) + Δ EV Bono(c).',
            it: 'Il Coach valuta ogni casella aperta con: EV Strategico(c) = Punti(c) − Costo Opportunità(c) + Δ EV Bonus(c).',
            pl: 'Trener ocenia każde wolne pole według wzoru: Strategiczne EV(c) = Punkty(c) − Koszt Alternatywny(c) + Δ EV Premii(c).',
          ),
        ],
      ),
      RulesSectionData(
        title: _pick(
          da: '2. Alternativomkostning & "Skraldespands-felter" (1\'ere & 2\'ere)',
          en: '2. Opportunity Cost & Smart "Dump Slots" (Ones & Twos)',
          sv: '2. Alternativkostnad & Smarta "Slaskrutor" (1:or & 2:or)',
          no: '2. Alternativkostnad & Smarte «Dump-felt» (1-ere & 2-ere)',
          fi: '2. Vaihtoehtoiskustannus ja "roskakoririvit" (Ykköset & Kakkoset)',
          is_: '2. Fórnarkostnaður og „ruslareitir“ (Ásar & Tvistar)',
          de: '2. Opportunitätskosten & „Streicher-Felder“ (1er & 2er)',
          nl: '2. Opportuniteitskosten & Slimme "Wegstreep-vakjes" (Enen & Tweeën)',
          fr: '2. Coût d\'Opportunité et Cases de Défausse (As & Deux)',
          es: '2. Costo de Oportunidad y Casillas de Descarte (Unos y Doses)',
          it: '2. Costo Opportunità e Caselle di Scarto (Uno e Due)',
          pl: '2. Koszt Alternatywny i „Pola Zrzutowe” (Jedynki i Dwójki)',
        ),
        bullets: [
          _pick(
            da: 'Når du udfylder et felt nu, mister du den score, feltet i gennemsnit ville give senere i spillet (Alternativomkostning). Chance har en høj fremtidig værdi (~22,5p) som sikkerhedsnet, mens 1\'ere (~2,5p) og 2\'ere (~5,2p) er billige at ofre.',
            en: 'Filling a category now sacrifices what that slot would average on a future turn (Opportunity Cost). Chance has a high future value (~22.5p) as a late-game safety net, whereas Ones (~2.5p) and Twos (~5.2p) cost very little to sacrifice.',
            sv: 'Att fylla i en ruta nu offrar vad rutan i snitt ger senare. Chans har högt framtida värde (~22,5p), medan 1:or och 2:or är billiga att offra.',
            no: 'Å fylle ut et felt nå ofrer hva feltet i snitt gir senere. Sjanse har høy fremtidig verdi (~22,5p), mens 1-ere og 2-ere er billige å ofre.',
            fi: 'Rivin täyttäminen nyt uhraa sen odotetun tulevan pistearvon. Sattuma on arvokas (~22,5p), kun taas Ykköset ja Kakkoset ovat edullisia uhrata.',
            is_: 'Að fylla í reit núna fórnar væntum stigum síðar. Áhætta er dýrmæt (~22,5 stig), en Ásar og Tvistar kosta lítið að fórna.',
            de: 'Ein Feld jetzt zu füllen opfert seinen zukünftigen Erwartungswert. Chance ist später ~22,5 P. wert, während 1er und 2er kaum Verlust bedeuten.',
            nl: 'Een vakje nu invullen kost wat het later gemiddeld oplevert. Kans is ~22,5p waard als vangnet, terwijl Enen en Tweeën goedkoop op te offeren zijn.',
            fr: 'Remplir une case sacrifie sa valeur future moyenne. Chance vaut ~22,5p en fin de partie, alors que les As et Deux coûtent très peu à sacrifier.',
            es: 'Llenar una casilla ahora sacrifica su promedio futuro. Libre vale ~22,5p como red de seguridad, mientras que Unos y Doses cuestan muy poco sacrificar.',
            it: 'Riempire una casella ora sacrifica il suo valore futuro medio. Libera vale ~22,5p come paracadute, mentre Uno e Due costano pochissimo.',
            pl: 'Wypełnienie pola teraz poświęca jego średnią przyszłą wartość. Szansa jest warta ~22,5 pkt jako koło ratunkowe, a Jedynki i Dwójki kosztują niewiele.',
          ),
          _pick(
            da: 'Derfor anbefaler Coachen ofte at tage -2 eller -3 på 1\'ere på et dårligt kast i stedet for at brænde Chance eller tage et stort minus på 5\'ere/6\'ere!',
            en: 'That is why the Coach often recommends taking -2 or -3 on Ones after a bad roll rather than wasting Chance or taking a heavy deficit on Fives/Sixes!',
            sv: 'Därför rekommenderar Coachen ofta att ta -2 eller -3 på 1:or vid ett dåligt kast i stället för att slösa Chans!',
            no: 'Derfor anbefaler Coachen ofte å ta -2 eller -3 på 1-ere ved et dårlig kast fremfor å kaste bort Sjanse!',
            fi: 'Siksi Valmentaja suosittelee usein ottamaan -2 tai -3 Ykkösiin huonolla heitolla Sattuman tuhlaamisen sijaan!',
            is_: 'Þess vegna mælir Þjálfarinn oft með -2 eða -3 á Ása eftir slæmt kast frekar en að eyða Áhættu!',
            de: 'Darum empfiehlt der Coach bei einem Fehlwurf oft -2 oder -3 auf 1er, statt Chance zu verschwenden!',
            nl: 'Daarom adviseert de Coach bij een slechte worp vaak -2 of -3 op Enen in plaats van Kans te verspillen!',
            fr: 'C\'est pourquoi le Coach recommande souvent de prendre -2 ou -3 aux As sur un mauvais lancer plutôt que de gaspiller Chance !',
            es: '¡Por eso el Coach suele recomendar tomar -2 o -3 en Unos tras una mala tirada en lugar de malgastar Libre!',
            it: 'Ecco perché il Coach consiglia spesso -2 o -3 sugli Uno dopo un brutto tiro invece di sprecare Libera!',
            pl: 'Dlatego po słabym rzucie Trener często zaleca wpisanie -2 lub -3 w Jedynki zamiast marnowania Szansy!',
          ),
        ],
      ),
      RulesSectionData(
        title: _pick(
          da: '3. Øverste Bonus-Skyggepris (+$bonusPts p ved ±0)',
          en: '3. Upper Section Bonus Shadow Price (+$bonusPts p at ±0)',
          sv: '3. Övre Bonusskuggpris (+$bonusPts p vid ±0)',
          no: '3. Øvre Bonusskyggepris (+$bonusPts p ved ±0)',
          fi: '3. Yläosan bonuksen varjohinta (+$bonusPts p tasolla ±0)',
          is_: '3. Skuggaverð Efri Bónuss (+$bonusPts stig við ±0)',
          de: '3. Oberer Bonus-Schattenpreis (+$bonusPts P. bei ±0)',
          nl: '3. Bovenste Bonus Schaduwprijs (+$bonusPts p bij ±0)',
          fr: '3. Prix Fictif du Bonus Supérieur (+$bonusPts p à ±0)',
          es: '3. Valor Sombra del Bono Superior (+$bonusPts p en ±0)',
          it: '3. Prezzo Ombra del Bonus Superiore (+$bonusPts p a ±0)',
          pl: '3. Cena Ukryta Premii Górnej (+$bonusPts pkt przy ±0)',
        ),
        bullets: [
          _pick(
            da: 'At rulle fire 6\'ere (24p = +6 over Par) giver ikke kun 24 rå point — de +6 i buffer øger din sandsynlighed for at nå +$bonusPts p bonussen markant (ofte +12 til +15 ekstra forventede bonuspoint!).',
            en: 'Rolling four Sixes (24p = +6 above Par) doesn\'t just score 24 points — that +6 buffer dramatically increases your probability of earning the +$bonusPts p Upper Bonus (often adding +12 to +15 extra expected bonus points!).',
            sv: 'Att slå fyra 6:or (24p = +6 över Par) ger inte bara 24 poäng — +6 i buffert ökar chansen till +$bonusPts p bonusen rejält (+12 till +15 extra bonus-EV!).',
            no: 'Å kaste fire 6-ere (24p = +6 over Par) gir ikke bare 24 poeng — +6 i buffer øker sjansen for +$bonusPts p bonusen kraftig (+12 til +15 ekstra bonus-EV!).',
            fi: 'Neljän kuutosen heittäminen (+6 yli Parin) ei anna vain 24 pistettä — +6 puskuri nostaa +$bonusPts p bonuksen todennäköisyyttä huomattavasti (+12..+15 bonus-EV)!',
            is_: 'Fjórir sexar (+6 yfir Par) gefa ekki bara 24 stig — +6 varasjóðurinn eykur líkur á +$bonusPts stiga bónusnum verulega (+12 til +15 bónus-EV)!',
            de: 'Vier 6er (24 P. = +6 über Par) bringen nicht nur 24 Punkte — der +6-Puffer steigert die Chance auf den +$bonusPts-P.-Bonus massiv (+12 bis +15 Bonus-EV!).',
            nl: 'Vier zessen (24p = +6 boven Par) geeft niet alleen 24 punten — die +6 buffer verhoogt je kans op de +$bonusPts p bonus enorm (+12 tot +15 extra bonus-EV!).',
            fr: 'Obtenir quatre 6 (+6 au-dessus du Par) ne donne pas seulement 24 points — ce coussin de +6 augmente fortement la probabilité du bonus de +$bonusPts p (+12 à +15 EV bonus !).',
            es: 'Sacar cuatro 6 (+6 sobre el Par) no solo da 24 puntos: ¡ese colchón de +6 dispara tu probabilidad de ganar el bono de +$bonusPts p (+12 a +15 EV extra)!',
            it: 'Fare quattro 6 (+6 sopra il Par) non dà solo 24 punti: quel margine di +6 aumenta enormemente la probabilità del bonus da +$bonusPts p (+12..+15 EV bonus)!',
            pl: 'Wyrzucenie czterech szóstek (+6 ponad Par) daje nie tylko 24 pkt — zapas +6 znacząco zwiększa szansę na premię +$bonusPts pkt (+12 do +15 pkt EV)!',
          ),
        ],
      ),
      RulesSectionData(
        title: _pick(
          da: '4. Eksakt Baglæns Induktion på Terninge-Hold (Kast 1 → 2 → 3)',
          en: '4. Exact Within-Turn Backward Induction (Roll 1 → 2 → 3)',
          sv: '4. Exakt Bakåtinduktion för Tärningsval (Kast 1 → 2 → 3)',
          no: '4. Eksakt Baklengs Induksjon for Terninghold (Kast 1 → 2 → 3)',
          fi: '4. Eksakti takaperin induktio noppien pidolle (Heitto 1 → 2 → 3)',
          is_: '4. Nákvæm afturábak reikningur fyrir teningaval (Kast 1 → 2 → 3)',
          de: '4. Exakte Rückwärtsinduktion beim Würfelhalten (Wurf 1 → 2 → 3)',
          nl: '4. Exacte Achterwaartse Inductie voor Dobbelstenen (Worp 1 → 2 → 3)',
          fr: '4. Induction à Rebours Exacte sur les Gardes (Lancer 1 → 2 → 3)',
          es: '4. Inducción Hacia Atrás Exacta en la Retención de Dados (Tiro 1 → 2 → 3)',
          it: '4. Induzione a Ritroso Esatta sui Dadi Tenuti (Tiro 1 → 2 → 3)',
          pl: '4. Dokładna Indukcja Wsteczna dla Zatrzymywania Kości (Rzut 1 → 2 → 3)',
        ),
        bullets: [
          _pick(
            da: 'Med 5 sekssidede terninger findes der præcis 252 unikke terningekombinationer og 462 mulige delmængder at beholde. Coachen beregner de eksakte multinomiale overgangssandsynligheder baglæns fra Kast 3 til Kast 1 på under 2 millisekunder!',
            en: 'With 5 six-sided dice, there are exactly 252 unique dice combinations and 462 possible held sub-multisets. The Coach computes exact multinomial transition probabilities backward from Roll 3 to Roll 1 in under 2 milliseconds!',
            sv: 'Med 5 sexsidiga tärningar finns exakt 252 unika kombinationer och 462 delmängder att behålla. Coachen beräknar de exakta sannolikheterna baklänges från Kast 3 till Kast 1 på under 2 millisekunder!',
            no: 'Med 5 sekssidede terninger finnes det nøyaktig 252 unike kombinasjoner og 462 delmengder å beholde. Coachen beregner de eksakte sannolikhetene baklengs fra Kast 3 til Kast 1 på under 2 millisekunder!',
            fi: 'Viidellä d6-nopalla on täsmälleen 252 uniikkia yhdistelmää ja 462 osajoukkoa. Valmentaja laskee tarkat multinomiaaliset siirtymätodennäköisyydet Heitosta 3 Heittoon 1 alle 2 millisekunnissa!',
            is_: 'Með 5 sexhliða teningum eru nákvæmlega 252 samsetningar og 462 hlutmengi. Þjálfarinn reiknar nákvæmar líkur afturábak frá Kasti 3 til Kasts 1 á innan við 2 millisekúndum!',
            de: 'Bei 5 sechsseitigen Würfeln gibt es genau 252 Kombinationen und 462 Haltemuster. Der Coach berechnet alle exakten Multinomial-Übergangswahrscheinlichkeiten von Wurf 3 bis Wurf 1 in unter 2 Millisekunden!',
            nl: 'Met 5 zeszijdige dobbelstenen zijn er exact 252 combinaties en 462 vasthoud-patronen. De Coach berekent alle exacte multinomiale overgangskansen achterwaarts van Worp 3 naar Worp 1 in minder dan 2 milliseconden!',
            fr: 'Avec 5 dés à 6 faces, il existe exactement 252 combinaisons uniques et 462 sous-ensembles de garde. Le Coach calcule toutes les probabilités multinomiales exactes du Lancer 3 au Lancer 1 en moins de 2 millisecondes !',
            es: 'Con 5 dados de 6 caras, existen exactamente 252 combinaciones únicas y 462 subconjuntos de retención. ¡El Coach calcula todas las probabilidades multinomiales exactas del Tiro 3 al Tiro 1 en menos de 2 milisegundos!',
            it: 'Con 5 dadi a 6 facce esistono esattamente 252 combinazioni e 462 sottoinsiemi. Il Coach calcola tutte le probabilità multinomiali esatte dal Tiro 3 al Tiro 1 in meno di 2 millisecondi!',
            pl: 'Dla 5 sześciennych kości istnieją dokładnie 252 kombinacje i 462 podzbiory zatrzymania. Trener oblicza dokładne prawdopodobieństwa wielomianowe wstecz od Rzutu 3 do Rzutu 1 w mniej niż 2 milisekundy!',
          ),
        ],
      ),
    ];
  }
}
