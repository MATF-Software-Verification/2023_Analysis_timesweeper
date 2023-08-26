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
