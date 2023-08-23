QT += testlib
QT += core gui multimedia
CONFIG += qt warn_on depend_includepath testcase

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

DISTFILES += \
    ../06-timesweeper/timesweeper/CMakeLists.txt \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/alien_alpha_front.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/alien_left.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/alien_right.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/gun_arm_left.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/gun_arm_right.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/player_front.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/player_left.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/player_no_gun_left.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/player_no_gun_right.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/player_right.png \
    ../06-timesweeper/timesweeper/Resources/CharacterModels/strauss_front.png \
    ../06-timesweeper/timesweeper/Resources/LevelBackgrounds/level_1.png \
    ../06-timesweeper/timesweeper/Resources/LevelBackgrounds/level_2.png \
    ../06-timesweeper/timesweeper/Resources/LevelBackgrounds/level_3_dino.jpg \
    ../06-timesweeper/timesweeper/Resources/LevelBackgrounds/level_4.png \
    ../06-timesweeper/timesweeper/Resources/LevelBackgrounds/level_5.png \
    ../06-timesweeper/timesweeper/Resources/Levels/level1.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level1_dialogue.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level2.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level2_dialogue.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level3.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level3_dialogue.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level4.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level4_dialogue.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level5.txt \
    ../06-timesweeper/timesweeper/Resources/Levels/level5_dialogue.txt \
    ../06-timesweeper/timesweeper/Resources/Other/bank_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/big_saloon_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/boss.png \
    ../06-timesweeper/timesweeper/Resources/Other/church_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/credits.png \
    ../06-timesweeper/timesweeper/Resources/Other/crosshair.png \
    ../06-timesweeper/timesweeper/Resources/Other/dialogue_box.png \
    ../06-timesweeper/timesweeper/Resources/Other/dialogue_box_strauss.png \
    ../06-timesweeper/timesweeper/Resources/Other/enemy_projectile.png \
    ../06-timesweeper/timesweeper/Resources/Other/gameover.png \
    ../06-timesweeper/timesweeper/Resources/Other/general_store_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_bar_1.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_bar_2.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_bar_3.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_bar_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_bar_5.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_bar_6.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_bar_7.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_bar_8.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_level_2.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_level_3.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/health_level_5.png \
    ../06-timesweeper/timesweeper/Resources/Other/help.png \
    ../06-timesweeper/timesweeper/Resources/Other/helpbg.png \
    ../06-timesweeper/timesweeper/Resources/Other/hotel_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/icon.png \
    ../06-timesweeper/timesweeper/Resources/Other/office_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/options.png \
    ../06-timesweeper/timesweeper/Resources/Other/optionsbg.png \
    ../06-timesweeper/timesweeper/Resources/Other/pause.png \
    ../06-timesweeper/timesweeper/Resources/Other/player_projectile.png \
    ../06-timesweeper/timesweeper/Resources/Other/portal.png \
    ../06-timesweeper/timesweeper/Resources/Other/saloon_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/sheriff_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/sign_level_4.png \
    ../06-timesweeper/timesweeper/Resources/Other/splash.png \
    ../06-timesweeper/timesweeper/Resources/Other/volume.png \
    ../06-timesweeper/timesweeper/Resources/Sounds/bgsound_level_1.mp3 \
    ../06-timesweeper/timesweeper/Resources/Sounds/bgsound_level_2.mp3 \
    ../06-timesweeper/timesweeper/Resources/Sounds/bgsound_level_3.mp3 \
    ../06-timesweeper/timesweeper/Resources/Sounds/bgsound_level_4.mp3 \
    ../06-timesweeper/timesweeper/Resources/Sounds/bgsound_level_5.mp3 \
    ../06-timesweeper/timesweeper/Resources/Sounds/projectile.mp3 \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_1_Tiles/floor_tile.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_2_Tiles/inner_tile_lvl2.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_2_Tiles/single_tile_lvl2.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_2_Tiles/single_tile_rot_lvl2.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_2_Tiles/single_tile_spec_lvl2.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_2_Tiles/spikes_lvl2.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_2_Tiles/step_tile_lvl2.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_2_Tiles/step_tile_rot_lvl2.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/bodlje.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/down.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/left_platform.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/leftside_down_lvl3.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/leftside_tile_lvl3.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/platform_tile_lvl3.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/right_platform.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/rightside_down_lvl3.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/rightside_tile_lvl3.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/single_tile_lvl3.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/ugao1.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/ugao2.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/underground_tile_lvl3.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_3_Tiles/water_tile_lvl3.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/crate_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/inner_tile_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/platform_left_tile_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/platform_right_tile_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/platform_tile_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/single_tile_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/spikes_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/stone_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_1_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_2_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_3_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_4_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_5_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_6_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_7_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_8_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_9_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_4_Tiles/tile_down_lvl4.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_5_Tiles/inner_tile_lvl5.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_5_Tiles/middle_tile_lvl5.png \
    ../06-timesweeper/timesweeper/Resources/Terrain/Level_5_Tiles/paltform_tile_lvl5.png
