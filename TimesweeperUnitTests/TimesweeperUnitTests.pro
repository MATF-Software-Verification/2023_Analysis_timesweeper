QT += testlib
QT += core gui multimedia
CONFIG += qt warn_on depend_includepath testcase
CONFIG += gcov

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

TEMPLATE = app

#SUBDIRS += \
#    ../06-timesweeper/timesweeper/timesweeper.pro

INCLUDEPATH += \
    ../06-timesweeper/timesweeper

SOURCES +=  tst_timesweeper.cpp \
    ../06-timesweeper/timesweeper/Source/Building.cpp \
    ../06-timesweeper/timesweeper/Source/Character.cpp \
    ../06-timesweeper/timesweeper/Source/DialogueBox.cpp \
    ../06-timesweeper/timesweeper/Source/DialogueHandler.cpp \
    ../06-timesweeper/timesweeper/Source/DialogueTriggerBox.cpp \
    ../06-timesweeper/timesweeper/Source/EnemyBoss.cpp \
    ../06-timesweeper/timesweeper/Source/EnemyCharacter.cpp \
    ../06-timesweeper/timesweeper/Source/EnemyHealthBar.cpp \
    ../06-timesweeper/timesweeper/Source/Game.cpp \
    ../06-timesweeper/timesweeper/Source/GunArm.cpp \
    ../06-timesweeper/timesweeper/Source/Help.cpp \
    ../06-timesweeper/timesweeper/Source/Level.cpp \
    ../06-timesweeper/timesweeper/Source/Menu.cpp \
    ../06-timesweeper/timesweeper/Source/Options.cpp \
    ../06-timesweeper/timesweeper/Source/Pickup.cpp \
    ../06-timesweeper/timesweeper/Source/PlayerCharacter.cpp \
    ../06-timesweeper/timesweeper/Source/Portal.cpp \
    ../06-timesweeper/timesweeper/Source/Projectile.cpp \
    ../06-timesweeper/timesweeper/Source/Tile.cpp

RESOURCES += \
    ../06-timesweeper/timesweeper/resources.qrc

HEADERS += \
    ../06-timesweeper/timesweeper/Headers/Building.h \
    ../06-timesweeper/timesweeper/Headers/Character.h \
    ../06-timesweeper/timesweeper/Headers/DialogueBox.h \
    ../06-timesweeper/timesweeper/Headers/DialogueHandler.h \
    ../06-timesweeper/timesweeper/Headers/DialogueTriggerBox.h \
    ../06-timesweeper/timesweeper/Headers/EnemyBoss.h \
    ../06-timesweeper/timesweeper/Headers/EnemyCharacter.h \
    ../06-timesweeper/timesweeper/Headers/EnemyHealthBar.h \
    ../06-timesweeper/timesweeper/Headers/Game.h \
    ../06-timesweeper/timesweeper/Headers/GunArm.h \
    ../06-timesweeper/timesweeper/Headers/Help.h \
    ../06-timesweeper/timesweeper/Headers/Level.h \
    ../06-timesweeper/timesweeper/Headers/Menu.h \
    ../06-timesweeper/timesweeper/Headers/Options.h \
    ../06-timesweeper/timesweeper/Headers/Pickup.h \
    ../06-timesweeper/timesweeper/Headers/PlayerCharacter.h \
    ../06-timesweeper/timesweeper/Headers/Portal.h \
    ../06-timesweeper/timesweeper/Headers/Projectile.h \
    ../06-timesweeper/timesweeper/Headers/Tile.h

FORMS += \
    ../06-timesweeper/timesweeper/Forms/Game.ui \
    ../06-timesweeper/timesweeper/Forms/Help.ui \
    ../06-timesweeper/timesweeper/Forms/Menu.ui \
    ../06-timesweeper/timesweeper/Forms/Options.ui

SUBDIRS += \
    ../06-timesweeper/timesweeper/timesweeper.pro
