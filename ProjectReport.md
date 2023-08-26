# Izvestaj projekta za kurs "Verifikacija softvera"

## Informacije o projektu koji se analizira
- Projekat koji se analizira se zove **Timesweeper** i može se pronaći na linku: https://gitlab.com/matf-bg-ac-rs/course-rs/projects-2020-2021/06-timesweeper
- Projekat je bio urađen za kurs "Razvoj softvera" u QtCreator razvojnom okruženju (jezik C++)
- Projekat predstavlja 2D platformer igricu u kojoj igrač putuje kroz portale koji ga vode kroz vreme kako bi zaustavio zle vanzemaljce koji su rasprostanjeni svuda po vremenu
## Uvod u analizu
- Analiza se vrši nad main granom projekta i to nad commit-om čiji je SHA: b1b27d201f6a60a855cb1a98c9624a16a6153951
- Analiza će se vršiti pomoću alata pokrenutih iz **terminala** kao i alatima pokrenutih direktno iz **QtCreator** okruženja
- Načini verifikacije koji su upotrebljeni:
  - **UnitTest** - pomoću QtTest biblioteke
  - **Gcov i Lcov** - za proveru pokrivenosti koda testovima
  - **Memcheck** - za proveru upotrebe i curenja memorije
  - **Clang-Tidy i Clazy** - za statičku analizu koda

## Unit testovi (QtTest)
- Unit testovi predstavljaju testove manjih jedinica koda, pretežno za proveru ispravnosti implementacije pojedinih delova
- Unit testovi predstavljaju vid dinamičke analize koda
- U idealnoj situaciji kod je napisan na način koji olakšava testiranje i unit testovi bi trebalo da pokrivaju sto veći procenat napisanog koda
- Za demonstraciju unit testova testirane su klase **Game** i **PlayerCharacter** kao dve najveće klase u projektu
### Testovi nad Game klasom
- void testIsLevelID2AfterGameCreation();
  - Kada se inicijalizuje novi instanca Game klase vrednost levelID promenljive treba da se promeni sa 1 na 2
- void testIsPlayerInitialisedAfterGameCreation();
  - Pri inicijalizaciji _Game_ instance potrebno je inicijalizovati njenu _player_ promenljivu tipa PlayerCharacter
- void testIsSoundOnAfterGameCreation();
  - Nakon inicijalizacije _Game_ instance zvuk bi trebalo da bude upaljen
- void testMediaPlayerSetAfterGameCreation();
  - Pri inicijalizaciji _Game_ instance potrebno je inicijalizovati njenu _music_ promenljivu tipa QMediaPlayer
- void testMainTimerSetAfterGameCreation();
  - Pri inicijalizaciji _Game_ instance potrebno je inicijalizovati njenu _mainTimer_ promenljivu tipa QTimer
- void testGameOverLabelCreatedAndHiddenAfterGameCreation();
  - Pri inicijalizaciji _Game_ instance potrebno je inicijalizovati i _GameOverLabel_ labelu koja je sakrivena i prikazuje se pri kraju igre 
- void testPauseLabelCreatedAndHiddenAfterGameCreation();
  - Pri inicijalizaciji _Game_ instance potrebno je inicijalizovati i _PauseLabel_ labelu koja je sakrivena i prikazuje se pri kraju igre
- void testIsLevelIDChangesAfterChangeLevel();
  - Kada se pozove funkcija _ChangeLevel_ potrebno je da se inkrementira promenljiva _levelID_ 
- void testIsLevelChangedAfterChangeLevel();
  - Kada se pozove funkcija _ChangeLevel_ potrebno je da se promeni i scena u _Game_ instanci
- void testPlayerPersistsThroughChangeLevel();
  - Kada se menja nivo potrebno je da se prenese isti _PlayerCharacter_ objekat kao i u prethodnom nivou
- void testMainTimerStopedWhenGameOver();
  - Kada se igra završi potrebno je da se zaustavi _mainTimer_ instance klase _Game_
- void testMusicPausedWhenGameOver();
  - Kada se igra završi potrebno je da se zaustavi muzika _music_ polja instance klase _Game_
- void testIsGameOverTrueWhenGameOver();
  - Kada se igra završi potrebno je postavi vrednost _isGameOver_ promenljive na true
- void testGameOverLabelShownWhenGameOver();
  - Kada se igra završi potrebno je prikazati _GameOverLabel_ labelu
