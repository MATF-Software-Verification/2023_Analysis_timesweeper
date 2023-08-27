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
### Testovi nad PlayerCharacter klasom
- void testIsGunArmInitializedAfterPlayerCreation();
  - Kada se inicijalizuje _PlayerCharacter_ instanca potrebno je da se inicijalizuje i njena _gunArm_ promenljiva tipa _GunArm_
- void testIsShoulderPositionSetAfterPlayerCreation();
  - Kada se inicijalizuje _PlayerCharacter_ instanca potrebno je da joj se podesi vrednost _shoulderPosition_ promenljive koja se koristi za određivanje pozicije ruke u prostoru
- void testIncreaseHealthWhileMaxHealth();
  - Kada se pozove _increaseHealth_ metod nad instancom _PlayerCharacter_ koja ima maksimalnu vrednost _m_health_ promenljive ne bi trebalo da dođe do promene   
- void testIncreaseHealthWhileNotMaxHealth();
  - Kada se pozove _increaseHealth_ metod nad instancom _PlayerCharacter_ koja nema maksimalnu vrednost _m_health_ promenljive trebalo bi da se uveća njena vrednost za 1 
- void testDecreaseHealthWhileNotAt0Health();
  - Kada se pozove _decreaseHealth_ metod nad instancom _PlayerCharacter_ koja ima više od 0 kao vrednost _m_health_ promenljive trebalo bi da se umanji njena vrednost za 1
- void testDecreaseHealthWhileAt0Health();
  - Kada se pozove _decreaseHealth_ metod nad instancom _PlayerCharacter_ koja ima 0 kao vrednost _m_health_ promenljive trebalo bi da dođe do emisije _playerIsDead()_ signala
- void testShootProjectileCreatesNewProjectile();
  - Kada se pozove _shootProjectile_ trebalo bi da se doda na scenu i time da se uveća broj item-a u njoj
### Rezultati izvršenih testova
- Ukupno je pozvano 23 testa od čega su 2 **init()** koji služi za inicijalizaciju nekih promenljivih pre svakog testa i **cleanup()** koji služi za čišćenje tih istih promenljivih između svaka 2 testa
- Ovime se okruženje održava istim između svaka 2 testa pa nije bitan redosled izvršavanja
- Izlaz pokretanja testova se može videti u narednoj slici
![img](./Screenshots/unit_test_results.jpeg)
- Može se primetiti da svi testovi prolaze čime je potvrđena ispravna funkcionalnost navedenih zahteva
## Provera pokrivenosti pomoću Gcov i Lcov
- Kao što je već navedeno idealno je pokriti što veći procenat koda testovima
- Kako bismo proverili koliko koda je pokriveno pomoću testova možemo koristiti **Gcov** i **Lcov**
- Prvo treba podeseti podesiti _.pro_ file projekta sa testovima kako bi se uz _.o_ objekte u build folderu napravili i _.gcno_ file-ovi koji će služiti za proveru pokrivenosti i to radimo tako što dodajemo narednu liniju
```
CONFIG += gcov
```
- Qt okruženje ume da tumači tu liniju i dodaje funkcionalnost **Gcov** alata pri kompilaciji
- Nakon što se build-uje projekat, potrebno je pokrenuti sve testove, ovime će se pojaviti _.gcda_ file-ovi koji nam isto služe za proveru pokrivenosti
- Pozicioniramo se terminalom u folder u kojem želimo da pomoću **Lcov** alata napravimo _.info_ file
- Nakon toga pokrećemo sledeću komandu
```
lcov -d ../build-TimesweeperUnitTests-Desktop-Debug/ -c -o coverage.info
```
- Nakon toga možemo malo da filtriramo nepotrebne elemente samog Qt okruženja pomoću sledeće komande
```
lcov -r "coverage.info" "*Qt*.framework*" "*.h" "*/tests/*" "*Xcode.app*" "*.moc" "*moc_*.cpp" "*/test/*" "*/build*/*" -o "coverage-filtered.info"
```
- Sada možemo pomoću **genhtml** komande da generišemo folder-a sa html prikazom _coverage-filtered.info_ file-a sledećom komandom
```
genhtml -o coverage_html coverage-filtered.info
```
- Sada možemo da otvorimo _coverage_html/index.html_ file i videćemo prikaz sa procentima pokrenutog koda
![img](./Screenshots/CodeCoverage/lcov_index.jpg)
- Sa slike možemo da vidimo da je pokrenuto 100% linija koda iz _TimesweeperUnitTests_ što je i očekivano jer se tu nalaze svi testovi
- Možemo isto videti i da je pokrivenost linija _Source_ folder-a (odnosno projekta koji se analizira) 20% što isto nije iznenađujuće jer se testovi odnose samo na 2 klase projekta, a ni one nisu 100% pokrivene testovima
- Ako pritisnemo link ka _Source_ možemo videti detaljniji pregled pokrivenosti po klasama
![img](./Screenshots/CodeCoverage/lcov_source.jpg)
- Ovde možemo videti da je pokrivenost linija klase _Game_ 66.9%, ali samo 55% funkcija
- Takođe možemo videti da je pokrivenost linija klase _PlayerCharacter_ 19.2%, ali zato 37.5%
- Na osnovu ovih brojeva zaključujemo da bi trebalo pokriti veći broj funkcija testovima i zato je bitno pisati lako testabilan kod
## Provera upotrebe i curenja memorije pomoću Memcheck
- Za proveru memorije idealno je koristiti **Valgrind**, specifično njegov alat **Memcheck**
- Iako curenje memorije ne mora uvek da bude najveći problem u programu, ako se ne ispravi nagomilavanjem može dovesti do velikih problema čak i pada celog programa
- Pomoću **Memcheck**-a možemo proveriti da li postoji:
  - Curenje memorije
  - Upotreba neinicializovanih promenljivih
  - Pristupanje već oslobođenoj memoriji i dr.
- U kodu projekta može se primetiti nedostatak velikog broja destruktora i veliki nedostatak poziva **delete** funkcije tako da se može i očekivati veći broj problema sa memorijom
- Kako je u pitanju demonstracija upotrebe alata u ove svhre, biće prikazano rešenje jedne instance curenja memorije i jedne instance upotrebe neinicializovanih promenljivih
- Prvo treba izgraditi projekat što lako možemo uraditi pomoću Qt okruženja tako što podesimo da se pomoću Build pravi Release Build
- Nakon toga se terminalom pozicioniramo u folder u kojem želimo da čuvamo izlaz **Memcheck**-a i pokrećemo sledeću komandu
```
valgrind --leak-check=full --track-origins=yes --log-file=memcheck_output.txt ../06-timesweeper/build-timesweeper-Desktop-Release/timesweeper
```
- Ovime ćemo pokrenuti igricu sa prikačenim **Memcheck** alatom
- Nakon malo igranja i umiranja negde na pola prvog nivoa dobijamo sledeći izlaz
```
==17738== Memcheck, a memory error detector
==17738== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==17738== Using Valgrind-3.15.0 and LibVEX; rerun with -h for copyright info
==17738== Command: ../06-timesweeper/build-timesweeper-Desktop-Release/timesweeper
==17738== Parent PID: 2244
==17738== 
==17738== Conditional jump or move depends on uninitialised value(s)
==17738==    at 0x6BD4565: pa_shm_cleanup (in /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsecommon-13.99.so)
==17738==    by 0x6BD47A1: pa_shm_create_rw (in /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsecommon-13.99.so)
==17738==    by 0x6BC44B6: pa_mempool_new (in /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsecommon-13.99.so)
==17738==    by 0x62949B1: pa_context_new_with_proplist (in /usr/lib/x86_64-linux-gnu/libpulse.so.0.21.2)
==17738==    by 0xFDF204C: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstpulseaudio.so)
==17738==    by 0xEFA2262: gst_audio_ring_buffer_open_device (in /usr/lib/x86_64-linux-gnu/libgstaudio-1.0.so.0.1603.0)
==17738==    by 0xEFC3248: ??? (in /usr/lib/x86_64-linux-gnu/libgstaudio-1.0.so.0.1603.0)
==17738==    by 0xFDF6CFA: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstpulseaudio.so)
==17738==    by 0xED3A9D1: gst_element_change_state (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED3B118: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC6275A: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstautodetect.so)
==17738==    by 0xED3A9D1: gst_element_change_state (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==  Uninitialised value was created by a heap allocation
==17738==    at 0x483B7F3: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x5FAEF18: __alloc_dir (opendir.c:118)
==17738==    by 0x5FAEF18: opendir_tail (opendir.c:69)
==17738==    by 0x5FAEF18: opendir (opendir.c:92)
==17738==    by 0x6BD452F: pa_shm_cleanup (in /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsecommon-13.99.so)
==17738==    by 0x6BD47A1: pa_shm_create_rw (in /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsecommon-13.99.so)
==17738==    by 0x6BC44B6: pa_mempool_new (in /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsecommon-13.99.so)
==17738==    by 0x62949B1: pa_context_new_with_proplist (in /usr/lib/x86_64-linux-gnu/libpulse.so.0.21.2)
==17738==    by 0xFDF204C: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstpulseaudio.so)
==17738==    by 0xEFA2262: gst_audio_ring_buffer_open_device (in /usr/lib/x86_64-linux-gnu/libgstaudio-1.0.so.0.1603.0)
==17738==    by 0xEFC3248: ??? (in /usr/lib/x86_64-linux-gnu/libgstaudio-1.0.so.0.1603.0)
==17738==    by 0xFDF6CFA: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstpulseaudio.so)
==17738==    by 0xED3A9D1: gst_element_change_state (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED3B118: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738== 
--17738-- WARNING: unhandled amd64-linux syscall: 315
--17738-- You may be able to write your own handler.
--17738-- Read the file README_MISSING_SYSCALL_OR_IOCTL.
--17738-- Nevertheless we consider this a bug.  Please report
--17738-- it at http://valgrind.org/support/bug_reports.html.
==17738== Conditional jump or move depends on uninitialised value(s)
==17738==    at 0x11FC57: PlayerCharacter::jump() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x12188E: PlayerCharacter::advance(int) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4E0B446: QGraphicsScene::advance() (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E151C1: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x58B41CF: QMetaObject::activate(QObject*, int, int, void**) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58C13ED: QTimer::timeout(QTimer::QPrivateSignal) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58B4BC4: QObject::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x5888809: QCoreApplication::notifyInternal2(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58DF77F: QTimerInfoList::activateTimers() (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58E006B: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==  Uninitialised value was created by a heap allocation
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x11B7AB: Game::Game() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x11D8B4: Menu::Menu(QWidget*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x117618: main (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738== 
==17738== 
==17738== HEAP SUMMARY:
==17738==     in use at exit: 26,083,406 bytes in 50,164 blocks
==17738==   total heap usage: 1,036,469 allocs, 986,305 frees, 514,723,417 bytes allocated
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,987 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13AEDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340B7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,988 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13AEDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340B7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,989 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13AF41: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340B7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,990 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13AF41: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340B7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,991 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF144FFF: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340C1: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,992 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF144FFF: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340C1: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,993 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13FCC3: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340C6: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,994 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13FCC3: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340C6: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,995 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8805: gst_int_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E5E: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,996 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8805: gst_int_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E5E: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,997 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA88B5: gst_int64_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E76: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,998 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA88B5: gst_int64_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E76: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 1,999 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8965: gst_double_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E8E: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,000 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8965: gst_double_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E8E: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,001 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8A15: gst_fraction_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8EA6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,002 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8A15: gst_fraction_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8EA6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,003 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8AC5: gst_value_list_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8EBE: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,004 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8AC5: gst_value_list_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8EBE: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,005 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8B75: gst_value_array_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8ED6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,006 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8B75: gst_value_array_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8ED6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,007 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8C25: gst_fraction_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8F39: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,008 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8C25: gst_fraction_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8F39: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,009 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8CD5: gst_bitmask_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8FB6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,010 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8CD5: gst_bitmask_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8FB6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,011 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BDDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8D88: gst_flagset_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8FE6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 16 bytes in 1 blocks are possibly lost in loss record 2,012 of 12,418
==17738==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BD57: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0D6: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8D88: gst_flagset_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8FE6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 24 bytes in 1 blocks are possibly lost in loss record 2,922 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15E33C: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15DE84: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xED09721: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738==    by 0x48FB61D: QMediaPlayer::QMediaPlayer(QObject*, QFlags<QMediaPlayer::Flag>) (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738==    by 0x120D5B: PlayerCharacter::PlayerCharacter() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738== 
==17738== 24 bytes in 1 blocks are possibly lost in loss record 2,923 of 12,418
==17738==    at 0x483DFAF: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B063: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F324: g_type_register_static (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F414: g_type_register_static_simple (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF0B8179: ??? (in /usr/lib/x86_64-linux-gnu/libgstbase-1.0.so.0.1603.0)
==17738==    by 0xF0B88C4: gst_adapter_get_type (in /usr/lib/x86_64-linux-gnu/libgstbase-1.0.so.0.1603.0)
==17738==    by 0xF0B88EC: gst_adapter_new (in /usr/lib/x86_64-linux-gnu/libgstbase-1.0.so.0.1603.0)
==17738==    by 0xF37B847: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstcoreelements.so)
==17738==    by 0xF1601DC: g_type_create_instance (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13F34C: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF141377: g_object_new_valist (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738== 
==17738== 32 bytes in 1 blocks are possibly lost in loss record 4,456 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15E33C: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15DE84: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xED415BA: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09662: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738==    by 0x48FB61D: QMediaPlayer::QMediaPlayer(QObject*, QFlags<QMediaPlayer::Flag>) (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 76 bytes in 1 blocks are possibly lost in loss record 8,421 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C1F9: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8AC5: gst_value_list_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8EBE: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 76 bytes in 1 blocks are possibly lost in loss record 8,422 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C1F9: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8B75: gst_value_array_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8ED6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 76 bytes in 1 blocks are possibly lost in loss record 8,423 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C1F9: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8CD5: gst_bitmask_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8FB6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 78 bytes in 1 blocks are possibly lost in loss record 8,427 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C1F9: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8805: gst_int_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E5E: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 78 bytes in 1 blocks are possibly lost in loss record 8,428 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C1F9: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA88B5: gst_int64_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E76: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 78 bytes in 1 blocks are possibly lost in loss record 8,429 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C1F9: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8965: gst_double_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E8E: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 78 bytes in 1 blocks are possibly lost in loss record 8,430 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C1F9: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8C25: gst_fraction_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8F39: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 80 bytes in 1 blocks are possibly lost in loss record 8,924 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15E33C: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15DE84: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15FFC7: g_type_create_instance (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1455FF: g_param_spec_internal (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF14A13C: g_param_spec_string (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xED0B729: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xF15E1D0: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15DE84: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15DE84: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF140C37: g_object_new_with_properties (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738== 
==17738== 82 bytes in 1 blocks are possibly lost in loss record 8,926 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C1F9: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8A15: gst_fraction_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8EA6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,534 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF133FDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738==    by 0x69C634B: dlopen_doit (dlopen.c:66)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,535 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13AEDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340B7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,536 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13AF41: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340B7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,537 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF144FFF: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340C1: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,538 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13FCC3: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340C6: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,539 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8805: gst_int_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E5E: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,540 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA88B5: gst_int64_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E76: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,541 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8965: gst_double_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8E8E: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,542 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8A15: gst_fraction_range_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8EA6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,543 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8AC5: gst_value_list_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8EBE: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,544 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8B75: gst_value_array_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8ED6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,545 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8C25: gst_fraction_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8F39: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,546 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8CD5: gst_bitmask_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8FB6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 96 bytes in 1 blocks are possibly lost in loss record 9,547 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B0E7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15B28A: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F0C8: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8D88: gst_flagset_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8FE6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 132 bytes in 1 blocks are possibly lost in loss record 10,222 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C0F4: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13AEDE: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340B7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738== 
==17738== 132 bytes in 1 blocks are possibly lost in loss record 10,223 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C0F4: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13AF41: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340B7: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738== 
==17738== 134 bytes in 1 blocks are possibly lost in loss record 10,224 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15C0F4: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEDA8D88: gst_flagset_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEDA8FE6: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED09B88: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0x6AC3DF7: g_option_context_parse (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED0A6B6: gst_init_check (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED0A717: gst_init (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xEC58445: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738==    by 0x48BDB74: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Multimedia.so.5.12.8)
==17738== 
==17738== 148 bytes in 1 blocks are possibly lost in loss record 10,456 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BF08: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF144FFF: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340C1: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738== 
==17738== 148 bytes in 1 blocks are possibly lost in loss record 10,457 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCEF0: g_malloc0 (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15BF08: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F159: g_type_register_fundamental (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13FCC3: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1340C6: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0x4011B99: call_init.part.0 (dl-init.c:72)
==17738==    by 0x4011CA0: call_init (dl-init.c:30)
==17738==    by 0x4011CA0: _dl_init (dl-init.c:119)
==17738==    by 0x6031984: _dl_catch_exception (dl-error-skeleton.c:182)
==17738==    by 0x40160CE: dl_open_worker (dl-open.c:758)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738== 
==17738== 200 bytes in 1 blocks are possibly lost in loss record 10,703 of 12,418
==17738==    at 0x483DFAF: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B063: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F324: g_type_register_static (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF146D12: g_param_type_register_static (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xED5FBEE: gst_param_spec_array_get_type (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED5FC99: gst_param_spec_array (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xF044643: gst_video_overlay_install_properties (in /usr/lib/x86_64-linux-gnu/libgstvideo-1.0.so.0.1603.0)
==17738==    by 0xF3A358F: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstxvimagesink.so)
==17738==    by 0xF15E1D0: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF140C37: g_object_new_with_properties (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1416F0: g_object_new (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738== 
==17738== 224 (136 direct, 88 indirect) bytes in 1 blocks are definitely lost in loss record 10,942 of 12,418
==17738==    at 0x483C583: operator new[](unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x57157D7: QHashData::rehash(int) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4E0E73B: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E0F1F9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1514C: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x58B4C29: QObject::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4E22FB2: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x5888809: QCoreApplication::notifyInternal2(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x588B487: QCoreApplicationPrivate::sendPostedEvents(QObject*, int, QThreadData*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58E0E36: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738== 
==17738== 224 (136 direct, 88 indirect) bytes in 1 blocks are definitely lost in loss record 10,943 of 12,418
==17738==    at 0x483C583: operator new[](unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x57157D7: QHashData::rehash(int) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4E0E73B: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E0DF9F: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E0F1F9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1514C: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x58B4C29: QObject::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4E22FB2: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x5888809: QCoreApplication::notifyInternal2(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x588B487: QCoreApplicationPrivate::sendPostedEvents(QObject*, int, QThreadData*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738== 
==17738== 256 (24 direct, 232 indirect) bytes in 1 blocks are definitely lost in loss record 11,062 of 12,418
==17738==    at 0x483B7F3: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x57153D7: QHashData::allocateNode(int) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x5247E3D: QTextFormatCollection::indexForFormat(QTextFormat const&) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x52675AC: QTextDocumentPrivate::init() (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5268EAB: QTextDocumentPrivate::clear() (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5252ECF: QTextDocument::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x4CD374F: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 288 (256 direct, 32 indirect) bytes in 1 blocks are definitely lost in loss record 11,147 of 12,418
==17738==    at 0x483B7F3: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x9C962F4: ??? (in /usr/lib/x86_64-linux-gnu/libfontconfig.so.1.12.0)
==17738==    by 0x9C969B8: ??? (in /usr/lib/x86_64-linux-gnu/libfontconfig.so.1.12.0)
==17738==    by 0x9C97FDC: ??? (in /usr/lib/x86_64-linux-gnu/libfontconfig.so.1.12.0)
==17738==    by 0x9C9F06C: ??? (in /usr/lib/x86_64-linux-gnu/libfontconfig.so.1.12.0)
==17738==    by 0xA276A59: ??? (in /usr/lib/x86_64-linux-gnu/libexpat.so.1.6.11)
==17738==    by 0xA27772F: ??? (in /usr/lib/x86_64-linux-gnu/libexpat.so.1.6.11)
==17738==    by 0xA274B85: ??? (in /usr/lib/x86_64-linux-gnu/libexpat.so.1.6.11)
==17738==    by 0xA2760CD: ??? (in /usr/lib/x86_64-linux-gnu/libexpat.so.1.6.11)
==17738==    by 0xA279E7F: XML_ParseBuffer (in /usr/lib/x86_64-linux-gnu/libexpat.so.1.6.11)
==17738==    by 0x9C9CF42: ??? (in /usr/lib/x86_64-linux-gnu/libfontconfig.so.1.12.0)
==17738==    by 0x9C9D37B: ??? (in /usr/lib/x86_64-linux-gnu/libfontconfig.so.1.12.0)
==17738== 
==17738== 296 bytes in 1 blocks are possibly lost in loss record 11,160 of 12,418
==17738==    at 0x483DFAF: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B063: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F324: g_type_register_static (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13B10B: g_flags_register_static (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF0700A2: gst_video_multiview_flags_get_type (in /usr/lib/x86_64-linux-gnu/libgstvideo-1.0.so.0.1603.0)
==17738==    by 0xF2E0FA2: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstplayback.so)
==17738==    by 0xF15E1D0: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF140C37: g_object_new_with_properties (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1416F0: g_object_new (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xED3C2DA: gst_element_factory_create (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED3C44D: gst_element_factory_make (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738== 
==17738== 352 bytes in 1 blocks are possibly lost in loss record 11,286 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x40149DA: allocate_dtv (dl-tls.c:286)
==17738==    by 0x40149DA: _dl_allocate_tls (dl-tls.c:532)
==17738==    by 0x62E2322: allocate_stack (allocatestack.c:622)
==17738==    by 0x62E2322: pthread_create@@GLIBC_2.2.5 (pthread_create.c:660)
==17738==    by 0x56C0463: QThread::start(QThread::Priority) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x9B2C49C: QXcbConnection::QXcbConnection(QXcbNativeInterface*, bool, unsigned int, char const*) (in /usr/lib/x86_64-linux-gnu/libQt5XcbQpa.so.5.12.8)
==17738==    by 0x9B31069: QXcbIntegration::QXcbIntegration(QStringList const&, int&, char**) (in /usr/lib/x86_64-linux-gnu/libQt5XcbQpa.so.5.12.8)
==17738==    by 0x484C512: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/platforms/libqxcb.so)
==17738==    by 0x5126FC2: QPlatformIntegrationFactory::create(QString const&, QStringList const&, int&, char**, QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5134FA0: QGuiApplicationPrivate::createPlatformIntegration() (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5136707: QGuiApplicationPrivate::createEventDispatcher() (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x588EF54: QCoreApplicationPrivate::init() (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x5138542: QGuiApplicationPrivate::init() (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738== 
==17738== 384 bytes in 1 blocks are possibly lost in loss record 11,324 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x40149DA: allocate_dtv (dl-tls.c:286)
==17738==    by 0x40149DA: _dl_allocate_tls (dl-tls.c:532)
==17738==    by 0x62E2322: allocate_stack (allocatestack.c:622)
==17738==    by 0x62E2322: pthread_create@@GLIBC_2.2.5 (pthread_create.c:660)
==17738==    by 0x6B042BA: ??? (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0x6AE0EC3: g_thread_new (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0x6AE19D3: g_thread_pool_new (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xED8B2D2: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED8A045: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xF1601DC: g_type_create_instance (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13F34C: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF140B44: g_object_new_with_properties (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1416F0: g_object_new (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738== 
==17738== 504 bytes in 1 blocks are possibly lost in loss record 11,441 of 12,418
==17738==    at 0x483DFAF: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x6ABCF3F: g_realloc (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF15B063: ??? (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF15F324: g_type_register_static (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF13B00B: g_enum_register_static (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xEFCF152: gst_audio_resampler_filter_interpolation_get_type (in /usr/lib/x86_64-linux-gnu/libgstaudio-1.0.so.0.1603.0)
==17738==    by 0x2C186E78: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstaudioresample.so)
==17738==    by 0xF15E1D0: g_type_class_ref (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1415E0: g_object_new_valist (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xF1416CC: g_object_new (in /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0.6400.6)
==17738==    by 0xED3C1F0: gst_element_factory_create (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED3C44D: gst_element_factory_make (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738== 
==17738== 640 bytes in 9 blocks are definitely lost in loss record 11,631 of 12,418
==17738==    at 0x483B7F3: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x401677C: resize_scopes (dl-open.c:282)
==17738==    by 0x401677C: dl_open_worker (dl-open.c:693)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x4015609: _dl_open (dl-open.c:837)
==17738==    by 0x69C634B: dlopen_doit (dlopen.c:66)
==17738==    by 0x6031927: _dl_catch_exception (dl-error-skeleton.c:208)
==17738==    by 0x60319F2: _dl_catch_error (dl-error-skeleton.c:227)
==17738==    by 0x69C6B58: _dlerror_run (dlerror.c:170)
==17738==    by 0x69C63D9: dlopen@@GLIBC_2.2.5 (dlopen.c:87)
==17738==    by 0xCF98C16: g_module_open (in /usr/lib/x86_64-linux-gnu/libgmodule-2.0.so.0.6400.6)
==17738==    by 0xED6470A: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED65761: gst_plugin_load_by_name (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738== 
==17738== 768 bytes in 2 blocks are possibly lost in loss record 11,701 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x40149DA: allocate_dtv (dl-tls.c:286)
==17738==    by 0x40149DA: _dl_allocate_tls (dl-tls.c:532)
==17738==    by 0x62E2322: allocate_stack (allocatestack.c:622)
==17738==    by 0x62E2322: pthread_create@@GLIBC_2.2.5 (pthread_create.c:660)
==17738==    by 0x6B042BA: ??? (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0x6AE0F40: g_thread_try_new (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0xF3A45F0: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstxvimagesink.so)
==17738==    by 0xF3A4979: ??? (in /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstxvimagesink.so)
==17738==    by 0xED3A9D1: gst_element_change_state (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xED3B118: ??? (in /usr/lib/x86_64-linux-gnu/libgstreamer-1.0.so.0.1603.0)
==17738==    by 0xECB042B: ??? (in /usr/lib/x86_64-linux-gnu/libQt5MultimediaGstTools.so.5.12.8)
==17738==    by 0xECAF5B7: QGstreamerVideoWindow::QGstreamerVideoWindow(QObject*, QByteArray const&) (in /usr/lib/x86_64-linux-gnu/libQt5MultimediaGstTools.so.5.12.8)
==17738==    by 0xEC4AD96: ??? (in /usr/lib/x86_64-linux-gnu/qt5/plugins/mediaservice/libgstmediaplayer.so)
==17738== 
==17738== 3,744 bytes in 8 blocks are possibly lost in loss record 12,157 of 12,418
==17738==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x40149DA: allocate_dtv (dl-tls.c:286)
==17738==    by 0x40149DA: _dl_allocate_tls (dl-tls.c:532)
==17738==    by 0x62E2322: allocate_stack (allocatestack.c:622)
==17738==    by 0x62E2322: pthread_create@@GLIBC_2.2.5 (pthread_create.c:660)
==17738==    by 0x6B042BA: ??? (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0x6AE0F40: g_thread_try_new (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0x6AE1189: ??? (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0x6AE0AD0: ??? (in /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0.6400.6)
==17738==    by 0x62E1608: start_thread (pthread_create.c:477)
==17738==    by 0x5FF0132: clone (clone.S:95)
==17738== 
==17738== 14,340 (288 direct, 14,052 indirect) bytes in 1 blocks are definitely lost in loss record 12,313 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x527DFF8: QTextDocumentLayout::QTextDocumentLayout(QTextDocument*) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5252ABA: QTextDocument::documentLayout() const (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x4CD325C: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD35EE: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738== 
==17738== 30,892 (16 direct, 30,876 indirect) bytes in 1 blocks are definitely lost in loss record 12,351 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x4CD3812: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E23154: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 30,924 (344 direct, 30,580 indirect) bytes in 1 blocks are definitely lost in loss record 12,352 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x4CD6C8C: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E23154: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 30,956 (416 direct, 30,540 indirect) bytes in 1 blocks are definitely lost in loss record 12,353 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x4DF8177: QGraphicsPixmapItem::QGraphicsPixmapItem(QGraphicsItem*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D0C: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x58B4327: QMetaObject::activate(QObject*, int, int, void**) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x12017A: PlayerCharacter::detectCollision() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4E0B446: QGraphicsScene::advance() (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E151C1: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x58B41CF: QMetaObject::activate(QObject*, int, int, void**) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58C13ED: QTimer::timeout(QTimer::QPrivateSignal) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58B4BC4: QObject::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 31,020 (72 direct, 30,948 indirect) bytes in 1 blocks are definitely lost in loss record 12,354 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x58B8AE9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BB084: QObject::connect(QObject const*, char const*, QObject const*, char const*, Qt::ConnectionType) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4CD3662: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 31,020 (72 direct, 30,948 indirect) bytes in 1 blocks are definitely lost in loss record 12,355 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x58B8AE9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BB084: QObject::connect(QObject const*, char const*, QObject const*, char const*, Qt::ConnectionType) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4DF0120: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E23154: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 31,052 (72 direct, 30,980 indirect) bytes in 1 blocks are definitely lost in loss record 12,356 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x58B8AE9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BB084: QObject::connect(QObject const*, char const*, QObject const*, char const*, Qt::ConnectionType) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4CD36AE: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 31,148 (32 direct, 31,116 indirect) bytes in 1 blocks are definitely lost in loss record 12,357 of 12,418
==17738==    at 0x483B7F3: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x5716D73: QListData::detach_grow(int*, int) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x587354F: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BD7F5: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BBC85: QObjectPrivate::setParent_helper(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BCBBE: QObject::QObject(QObjectPrivate&, QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x52524A0: QTextDocument::QTextDocument(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x4CD3822: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 31,148 (72 direct, 31,076 indirect) bytes in 1 blocks are definitely lost in loss record 12,358 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x58B8AE9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BB084: QObject::connect(QObject const*, char const*, QObject const*, char const*, Qt::ConnectionType) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x52797B7: QAbstractTextDocumentLayout::registerHandler(int, QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5252ABA: QTextDocument::documentLayout() const (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x4CD325C: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD35EE: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738== 
==17738== 31,148 (72 direct, 31,076 indirect) bytes in 1 blocks are definitely lost in loss record 12,359 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x58B8AE9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BB084: QObject::connect(QObject const*, char const*, QObject const*, char const*, Qt::ConnectionType) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4CD344C: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 31,148 (72 direct, 31,076 indirect) bytes in 1 blocks are definitely lost in loss record 12,360 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x58B8AE9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BB084: QObject::connect(QObject const*, char const*, QObject const*, char const*, Qt::ConnectionType) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4DF00FC: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E23154: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 31,276 (64 direct, 31,212 indirect) bytes in 1 blocks are definitely lost in loss record 12,361 of 12,418
==17738==    at 0x483B7F3: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x56CC240: QArrayData::allocate(unsigned long, unsigned long, unsigned long, QFlags<QArrayData::AllocationOption>) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BD604: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58B60FE: QObjectPrivate::addConnection(int, QObjectPrivate::Connection*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58B8B5C: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BB084: QObject::connect(QObject const*, char const*, QObject const*, char const*, Qt::ConnectionType) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x52797B7: QAbstractTextDocumentLayout::registerHandler(int, QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5252ABA: QTextDocument::documentLayout() const (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x4CD325C: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD35EE: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 31,276 (8 direct, 31,268 indirect) bytes in 1 blocks are definitely lost in loss record 12,362 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x524D3F9: QTextBlock::layout() const (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5283789: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5285EF8: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x528CD44: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x528D38C: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x528DD07: QTextDocumentLayout::doLayout(int, int, int) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x528F2D2: QTextDocumentLayout::documentChanged(int, int, int) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5268F3F: QTextDocumentPrivate::clear() (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x5252ECF: QTextDocument::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x4CD374F: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738== 
==17738== 31,276 (480 direct, 30,796 indirect) bytes in 1 blocks are definitely lost in loss record 12,363 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x5252487: QTextDocument::QTextDocument(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8)
==17738==    by 0x4CD3822: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 45,488 (144 direct, 45,344 indirect) bytes in 2 blocks are definitely lost in loss record 12,374 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x58B8AE9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58B92C7: QMetaObject::connect(QObject const*, int, QObject const*, int, int, int*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4CD33E7: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E23154: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 62,168 (80 direct, 62,088 indirect) bytes in 2 blocks are definitely lost in loss record 12,382 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x1182B3: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E23154: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x5888809: QCoreApplication::notifyInternal2(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4E420CF: QGraphicsView::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4B2977C: QWidget::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4BD6D51: QFrame::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== 62,424 (144 direct, 62,280 indirect) bytes in 2 blocks are definitely lost in loss record 12,383 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x58B8AE9: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58BB084: QObject::connect(QObject const*, char const*, QObject const*, char const*, Qt::ConnectionType) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4CD327E: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD35EE: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6C35: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4CD6CD6: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738== 
==17738== 76,444 (1,008 direct, 75,436 indirect) bytes in 3 blocks are definitely lost in loss record 12,387 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x4DF7107: QGraphicsTextItem::QGraphicsTextItem(QGraphicsItem*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D3B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E23154: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x5888809: QCoreApplication::notifyInternal2(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4E420CF: QGraphicsView::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738== 
==17738== LEAK SUMMARY:
==17738==    definitely lost: 4,648 bytes in 36 blocks
==17738==    indirectly lost: 662,132 bytes in 1,975 blocks
==17738==      possibly lost: 9,484 bytes in 72 blocks
==17738==    still reachable: 25,198,694 bytes in 47,400 blocks
==17738==                       of which reachable via heuristic:
==17738==                         length64           : 1,712 bytes in 32 blocks
==17738==                         newarray           : 2,712 bytes in 52 blocks
==17738==                         multipleinheritance: 544 bytes in 2 blocks
==17738==         suppressed: 0 bytes in 0 blocks
==17738== Reachable blocks (those to which a pointer was found) are not shown.
==17738== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==17738== 
==17738== For lists of detected and suppressed errors, rerun with: -s
==17738== ERROR SUMMARY: 90 errors from 89 contexts (suppressed: 2 from 2)
```
- Kao što se da primetiti ovde zaista ima previše curenja memorije, tako da ćemo se fokusirati curenje vezano za **DialogueBox** i **DialogueHandler** klase kao i na upotrebu neinicializovanih vrednosti kod **PlayerCharacter** klase
### Curenje memorije kod DialogueBox i DialogueHandler klasa
- Primećujemo da postoji curenje memorije kod ovih klasa zbog ovakvih delova memcheck-ovog izveštaja
```
==17738== 30,924 (344 direct, 30,580 indirect) bytes in 1 blocks are definitely lost in loss record 12,352 of 12,418
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x4CD6C8C: QWidgetTextControl::QWidgetTextControl(QObject*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0056: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4DF0220: QGraphicsTextItem::setPlainText(QString const&) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x117D4B: DialogueBox::DialogueBox(QPair<DialogueHandler::Speaker, QString>&) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1182C1: DialogueHandler::advanceDialogue() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x1210E6: PlayerCharacter::keyPressEvent(QKeyEvent*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4DEDC54: QGraphicsItem::sceneEvent(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E1182D: QGraphicsScene::keyPressEvent(QKeyEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E23154: QGraphicsScene::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
```
- Ispostavlja se da se pri izmeni trenutno aktivnog **DialogueBox** objekta od strane **DialogueHandler**-a on ne briše već samo biva zamenjen novim
- Zbog toga se menja vrednost jedinog pokazivača ka tom segmentu memorije i on postaje nedostižan
- Da bismo rešili dodajemo poziv za _delete_ funkciju u kod odmah pre zamene **DialogueBox**-a
![img](./Screenshots/Memcheck/dialogue_changes.jpg)
- Na ovaj način imamo brisanje objekta na koji pokazuje _m_box_ promenljiva odmah pre izmene njene vrednosti, a kako je _delete_ bezbedan za pozivanje nad _nullptr_ nije nepohodno ni da proveravamo da li pokazuje na pravi objekat ili ne
### Upotreba neinicializovanih vrednosti promenljive u PlayerCharacter klasi
- Primećujemo da postoji upotreba neinicializovanih vrednosti promenljive u PlayerCharacter klasi zbog ovog dela memcheck-ovog izveštaja
```
==17738== Conditional jump or move depends on uninitialised value(s)
==17738==    at 0x11FC57: PlayerCharacter::jump() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x12188E: PlayerCharacter::advance(int) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x4E0B446: QGraphicsScene::advance() (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4E151C1: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x58B41CF: QMetaObject::activate(QObject*, int, int, void**) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58C13ED: QTimer::timeout(QTimer::QPrivateSignal) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58B4BC4: QObject::event(QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x4AE6A65: QApplicationPrivate::notify_helper(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x4AF00EF: QApplication::notify(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8)
==17738==    by 0x5888809: QCoreApplication::notifyInternal2(QObject*, QEvent*) (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58DF77F: QTimerInfoList::activateTimers() (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==    by 0x58E006B: ??? (in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8)
==17738==  Uninitialised value was created by a heap allocation
==17738==    at 0x483BE63: operator new(unsigned long) (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==17738==    by 0x11B7AB: Game::Game() (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x11D8B4: Menu::Menu(QWidget*) (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
==17738==    by 0x117618: main (in /home/user/Desktop/VS projekat/2023_Analysis_timesweeper/06-timesweeper/build-timesweeper-Desktop-Release/timesweeper)
```
- Kada se pogleda **PlayerCharacter.h** primećuje se da je većina promenljivih inicijalizovana od samog početka, mada ima par njih koje nisu i one se koriste u _jump()_ i _walk()_ funkcijama i to su _m_isOnGround_ i _m_velocityX_
- Ove promenljive se vremenom inicijalizuju ali kako se _advance()_ funkcija poziva od samog početka igre, oni moraju da budu inicijalizovani od starta
- Kako bismo ispravili ovu grešku jednostavno inicijalizujemo vrednosti ovih promenljivih ovako

![img](./Screenshots/Memcheck/player_changes.jpg)
