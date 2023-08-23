#include <QtTest>
#include <QCoreApplication>

// add necessary includes here
#include <Headers/Game.h>
#include <Headers/Level.h>
#include <Headers/PlayerCharacter.h>
#include <Headers/DialogueHandler.h>


class timesweeper : public QObject
{
    Q_OBJECT

public:
    timesweeper();
    ~timesweeper();
    Game* game;

private slots:
    void cleanup();

    // Game creation
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

    // changeLevel
    // levelID should increase when changeLevel is called
    void testIsLevelIDChangesAfterChangeLevel();
    // QGraphicsScene should change when changeLevel is called
    void testIsLevelChangedAfterChangeLevel();
    // PlayerCharacter should persist through changeLevel calls
    void testPlayerPersistsThroughChangeLevel();

    // gameOver
    // QTimer should stop when gameOver is called
    void testMainTimerStopedWhenGameOver();
    // QMediaPlayer should be pased when gameOver is called
    void testMusicPausedWhenGameOver();
    // m_isGameOver variable should be true when gameOver is called
    void testIsGameOverTrueWhenGameOver();
    // GameOverLabel should be shown when gameOver is called
    void testGameOverLabelShownWhenGameOver();

};

timesweeper::timesweeper()
{

}

timesweeper::~timesweeper()
{

}

void timesweeper::cleanup(){
    delete game;
}

void timesweeper::testIsLevelID2AfterGameCreation()
{
    game = new Game();
    int expectedValue = 2;

    QCOMPARE(game->getLevelID(),expectedValue);
}

void timesweeper::testIsPlayerInitialisedAfterGameCreation()
{
    game = new Game();
    QVERIFY(game->player != nullptr);
}

void timesweeper::testIsSoundOnAfterGameCreation()
{
    game = new Game();
    bool expectedValue = true;

    QCOMPARE(game->getSoundOn(),expectedValue);
}

void timesweeper::testMediaPlayerSetAfterGameCreation()
{
    game = new Game();
    QVERIFY(game->music != nullptr);
}

void timesweeper::testMainTimerSetAfterGameCreation()
{
    game = new Game();
    QVERIFY(game->mainTimer != nullptr);
}

void timesweeper::testGameOverLabelCreatedAndHiddenAfterGameCreation()
{
    game = new Game();
    QVERIFY(game->getGameOverLabel() != nullptr);
    QVERIFY(game->getGameOverLabel()->isHidden());
}

void timesweeper::testPauseLabelCreatedAndHiddenAfterGameCreation()
{
    game = new Game();
    QVERIFY(game->getPauseLabel() != nullptr);
    QVERIFY(game->getPauseLabel()->isHidden());
}

void timesweeper::testIsLevelIDChangesAfterChangeLevel()
{
    game = new Game();
    int levelIDBeforeChangeLevel = game->getLevelID();
    game->changeLevel();

    QCOMPARE(game->getLevelID(), levelIDBeforeChangeLevel + 1);
}

void timesweeper::testIsLevelChangedAfterChangeLevel()
{
    game = new Game();
    QGraphicsScene* levelBeforeChangeLevel = game->currentLevel;
    game->changeLevel();
    QGraphicsScene* levelAfterChangeLevel = game->currentLevel;

    QVERIFY(levelAfterChangeLevel != levelBeforeChangeLevel);
}

void timesweeper::testPlayerPersistsThroughChangeLevel()
{
    game = new Game();
    PlayerCharacter* playerBeforeChangeLevel = game->player;
    game->changeLevel();
    PlayerCharacter* playerAfterChangeLevel = game->player;

    QCOMPARE(playerAfterChangeLevel,playerBeforeChangeLevel);
}

void timesweeper::testMainTimerStopedWhenGameOver()
{
    game = new Game();
    game->gameOver();

    QVERIFY(!game->mainTimer->isActive());
}

void timesweeper::testMusicPausedWhenGameOver()
{
    game = new Game();
    game->gameOver();

    QVERIFY(game->music->state() == QMediaPlayer::PausedState);
}

void timesweeper::testIsGameOverTrueWhenGameOver()
{
    game = new Game();
    game->gameOver();

    QVERIFY(game->getIsGameOver());
}

void timesweeper::testGameOverLabelShownWhenGameOver()
{
    game = new Game();
    game->gameOver();

    QVERIFY(!game->getGameOverLabel()->isHidden());
}

QTEST_MAIN(timesweeper)

#include "tst_timesweeper.moc"
