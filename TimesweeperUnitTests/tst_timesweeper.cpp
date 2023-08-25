#include <QtTest>
#include <QCoreApplication>

// add necessary includes here
#include <Headers/Game.h>
#include <Headers/Level.h>
#include <Headers/PlayerCharacter.h>
#include <Headers/Menu.h>


class timesweeper : public QObject
{
    Q_OBJECT

public:
    timesweeper();
    ~timesweeper();
    Game* testGame;
    PlayerCharacter* testPlayer;

private slots:
    void init();
    void cleanup();

    // Game
    // LevelID should be 2 as changeLevel should be called when instantiating Game
    void testIsLevelID2AfterGameCreation();
    // PlayerCharacter should be created with the Game instance
    void testIsPlayerInitialisedAfterGameCreation();
    // m_sound variable should be true when the Game instance is created
    void testIsSoundOnAfterGameCreation();
    // QMediaPlayer should be created with the Game instance
    void testMediaPlayerSetAfterGameCreation();
    // QTimer should be created with the Game instance
    void testMainTimerSetAfterGameCreation();
    // A GameOverLabel should be created with the Game instance
    void testGameOverLabelCreatedAndHiddenAfterGameCreation();
    // A PauseLabel should be created with the Game instance
    void testPauseLabelCreatedAndHiddenAfterGameCreation();
    // levelID should increase when changeLevel is called
    void testIsLevelIDChangesAfterChangeLevel();
    // QGraphicsScene should change when changeLevel is called
    void testIsLevelChangedAfterChangeLevel();
    // PlayerCharacter should persist through changeLevel calls
    void testPlayerPersistsThroughChangeLevel();
    // QTimer should stop when gameOver is called
    void testMainTimerStopedWhenGameOver();
    // QMediaPlayer should be pased when gameOver is called
    void testMusicPausedWhenGameOver();
    // m_isGameOver variable should be true when gameOver is called
    void testIsGameOverTrueWhenGameOver();
    // GameOverLabel should be shown when gameOver is called
    void testGameOverLabelShownWhenGameOver();

    // PlayerCharacter
    // gunArm should be initialized with the PlayerCharacter
    void testIsGunArmInitializedAfterPlayerCreation();
    // shoulderPosition should be set with the creation of the PlayerCharacter
    void testIsShoulderPositionSetAfterPlayerCreation();
    // increaseHealth should not change hp when at max hp
    void testIncreaseHealthWhileMaxHealth();
    // increaseHealth should increase the hp by 1 when not at max hp
    void testIncreaseHealthWhileNotMaxHealth();
    // decreaseHealth should lower the hp by 1 when not at 0 hp
    void testDecreaseHealthWhileNotAt0Health();
    // decreaseHealth should emit playerIsDead signal when at 0 hp
    void testDecreaseHealthWhileAt0Health();
    // shootProjectile should create a new entity and add it to the currentLevel items
    void testShootProjectileCreatesNewProjectile();
};

timesweeper::timesweeper()
{

}

timesweeper::~timesweeper()
{

}

void timesweeper::init()
{
    testGame = nullptr;
    testPlayer = nullptr;
}

void timesweeper::cleanup(){
    delete testGame;
    delete testPlayer;
}

void timesweeper::testIsLevelID2AfterGameCreation()
{
    testGame = new Game();
    int expectedValue = 2;

    QCOMPARE(testGame->getLevelID(),expectedValue);
}

void timesweeper::testIsPlayerInitialisedAfterGameCreation()
{
    testGame = new Game();
    QVERIFY(testGame->player != nullptr);
}

void timesweeper::testIsSoundOnAfterGameCreation()
{
    testGame = new Game();
    bool expectedValue = true;

    QCOMPARE(testGame->getSoundOn(),expectedValue);
}

void timesweeper::testMediaPlayerSetAfterGameCreation()
{
    testGame = new Game();
    QVERIFY(testGame->music != nullptr);
}

void timesweeper::testMainTimerSetAfterGameCreation()
{
    testGame = new Game();
    QVERIFY(testGame->mainTimer != nullptr);
}

void timesweeper::testGameOverLabelCreatedAndHiddenAfterGameCreation()
{
    testGame = new Game();
    QVERIFY(testGame->getGameOverLabel() != nullptr);
    QVERIFY(testGame->getGameOverLabel()->isHidden());
}

void timesweeper::testPauseLabelCreatedAndHiddenAfterGameCreation()
{
    testGame = new Game();
    QVERIFY(testGame->getPauseLabel() != nullptr);
    QVERIFY(testGame->getPauseLabel()->isHidden());
}

void timesweeper::testIsLevelIDChangesAfterChangeLevel()
{
    testGame = new Game();
    int levelIDBeforeChangeLevel = testGame->getLevelID();
    testGame->changeLevel();

    QCOMPARE(testGame->getLevelID(), levelIDBeforeChangeLevel + 1);
}

void timesweeper::testIsLevelChangedAfterChangeLevel()
{
    testGame = new Game();
    QGraphicsScene* levelBeforeChangeLevel = testGame->currentLevel;
    testGame->changeLevel();
    QGraphicsScene* levelAfterChangeLevel = testGame->currentLevel;

    QVERIFY(levelAfterChangeLevel != levelBeforeChangeLevel);
}

void timesweeper::testPlayerPersistsThroughChangeLevel()
{
    testGame = new Game();
    PlayerCharacter* playerBeforeChangeLevel = testGame->player;
    testGame->changeLevel();
    PlayerCharacter* playerAfterChangeLevel = testGame->player;

    QCOMPARE(playerAfterChangeLevel,playerBeforeChangeLevel);
}

void timesweeper::testMainTimerStopedWhenGameOver()
{
    testGame = new Game();
    testGame->gameOver();

    QVERIFY(!testGame->mainTimer->isActive());
}

void timesweeper::testMusicPausedWhenGameOver()
{
    testGame = new Game();
    testGame->gameOver();

    QVERIFY(testGame->music->state() == QMediaPlayer::PausedState);
}

void timesweeper::testIsGameOverTrueWhenGameOver()
{
    testGame = new Game();
    testGame->gameOver();

    QVERIFY(testGame->getIsGameOver());
}

void timesweeper::testGameOverLabelShownWhenGameOver()
{
    testGame = new Game();
    testGame->gameOver();

    QVERIFY(!testGame->getGameOverLabel()->isHidden());
}

void timesweeper::testIsGunArmInitializedAfterPlayerCreation()
{
    testPlayer = new PlayerCharacter();

    QVERIFY(testPlayer->getGunArm() != nullptr);
}

void timesweeper::testIsShoulderPositionSetAfterPlayerCreation()
{
    testPlayer = new PlayerCharacter();

    QCOMPARE(testPlayer->shoulderPosition, testPlayer->pos()+ QPointF(35, 60));
}

void timesweeper::testIncreaseHealthWhileMaxHealth()
{
    testPlayer = new PlayerCharacter();
    int healthBefore = testPlayer->getHealth();
    testPlayer->increaseHealth();
    int healthAfter = testPlayer->getHealth();

    QCOMPARE(healthAfter, healthBefore);
}

void timesweeper::testIncreaseHealthWhileNotMaxHealth()
{
    testPlayer = new PlayerCharacter();
    testPlayer->decreaseHealth();
    int healthBefore = testPlayer->getHealth();
    testPlayer->increaseHealth();
    int healthAfter = testPlayer->getHealth();

    QCOMPARE(healthAfter, healthBefore + 1);
}

void timesweeper::testDecreaseHealthWhileNotAt0Health()
{
    testPlayer = new PlayerCharacter();
    int healthBefore = testPlayer->getHealth();
    testPlayer->decreaseHealth();
    int healthAfter = testPlayer->getHealth();

    QCOMPARE(healthAfter, healthBefore - 1);
}

void timesweeper::testDecreaseHealthWhileAt0Health()
{
    testPlayer = new PlayerCharacter();
    QSignalSpy signalSpy(testPlayer, SIGNAL(playerIsDead()));

    // lowering the players health to 0
    while(testPlayer->getHealth() != 0)
        testPlayer->decreaseHealth();

    // one last call should trigger the signal emission
    testPlayer->decreaseHealth();

    QCOMPARE(signalSpy.count(),1);
}

void timesweeper::testShootProjectileCreatesNewProjectile()
{
    Menu m;
    extern Game* game;
    testGame = game;
    testPlayer = new PlayerCharacter();
    int numberOfObjectsBeforeShoot = testGame->currentLevel->items().count();
    testPlayer->shootProjectile();
    int numberOfObjectsAfterShoot = testGame->currentLevel->items().count();

    QCOMPARE(numberOfObjectsAfterShoot, numberOfObjectsBeforeShoot + 1);
}

QTEST_MAIN(timesweeper)

#include "tst_timesweeper.moc"
