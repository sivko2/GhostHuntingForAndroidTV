import QtQuick 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.0
import Qt.labs.settings 1.0


Window
{
    id: mainWindow
    visible: true
    width: 1280 // Screen.width
    height: 720 // Screen.height
    color: "black"

    property double k: mainWindow.width / 1920

    property int score: 0

    property int menu: 1

    property int gameState: 1

    property int level: 1

    property int diaCounter: 0;

    property int lives: 3

    property bool ghostMove: true;

    property int svitDir: -1

    property int action: 0;

    property variant map:
      [
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0,
        0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 1, 0, 1, 0, 0, 1, 1, 2, 1, 0, 0, 1, 0, 1, 1,
        0, 0, 0, 1, 1, 0, 1, 2, 2, 1, 0, 1, 1, 0, 0, 0,
        1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0,
        0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]

    property variant walls: []
    property variant diamonds: []
	property variant ghosts: []

    Settings
    {
        id: scoreSettings
        property int score: 0
    }

    Timer
    {
        id: timer

        interval: 25
        running: false
        repeat: true

        onTriggered:
        {
            if (svit.currentFrame < 0)
            {
                svit.currentFrame = 0;

            }

            if (action <= 0)
            {
                battery1.visible = false;
                battery2.visible = false;
                battery3.visible = true;
            }
            else if (action > 500)
            {
                battery1.visible = true;
                battery2.visible = false;
                battery3.visible = false;
            }
            else
            {
                battery1.visible = false;
                battery2.visible = true;
                battery3.visible = false;
            }

            if (action > 0)
            {
                action--;
            }

            // GHOSTS INTERACTION
            for (var i = 0; i < ghosts.length; i++)
            {
                var ghost = ghosts[i];

                if (!ghostMove)
                {
                    break;
                }

				if (ghost.dir === -1)
                {
                    ghost.dir = Math.floor(Math.random() * 4);
                }


                if (ghost.dir === 0)
                {
                    if (ghost.y >= 1004 * k)
                    {
                        ghost.dir = -1;
                    }
                    else
                    {
                        ghost.y += 8 * k;
                        ghost.counter = ghost.counter + 1;
                    }
                }
                else if (ghost.dir === 3)
                {
                    if (ghost.y <= 28 * k)
                    {
                        ghost.dir = -1;
                    }
                    else
                    {
                        ghost.y -= 8 * k;
                        ghost.counter = ghost.counter + 1;
                    }
                }
                else if (ghost.dir === 1)
                {
                    if (ghost.x <= 36 * k)
                    {
                        ghost.dir = -1;
                    }
                    else
                    {
                        ghost.x -= 8 * k;
                        ghost.counter = ghost.counter + 1;
                    }
                }
                else if (ghost.dir === 2)
                {
                    if (ghost.x >= 1512 * k)
                    {
                        ghost.dir = -1;
                    }
                    else
                    {
                        ghost.x += 8 * k;
                        ghost.counter = ghost.counter + 1;
                    }
                }

                if (ghost.dir > -1)
                {
                    if (ghost.counter % 12 === 0)
                    {
                        ghost.dir = Math.floor(Math.random() * 4);

                        if (ghost.dir === 0)
                        {
                            ghost.y += 8 * k;
                            ghost.counter = ghost.counter + 1;
                        }
                        else if (ghost.dir === 3)
                        {
                            ghost.y -= 8 * k;
                            ghost.counter = ghost.counter + 1;
                        }
                        else if (ghost.dir === 1)
                        {
                            ghost.x -= 8 * k;
                            ghost.counter = ghost.counter + 1;
                        }
                        else if (ghost.dir === 2)
                        {
                            ghost.x += 8 * k;
                            ghost.counter = ghost.counter + 1;
                        }
                    }
                }
			}

            // SVIT MOVEMENTS
            if (svitDir >= 0 && svit.visible)
            {
                if (svit.currentFrame >= svitDir * 4 + 3)
                {
                    svit.currentFrame = svitDir * 4;
                }
                else if (svit.currentFrame < svitDir * 4)
                {
                    svit.currentFrame = svitDir * 4;
                }
                else
                {
                    svit.currentFrame = svit.currentFrame + 1;
                }
            }

            // WALLS
            for (var i = 0; i < walls.length; i++)
            {
                var w = walls[i];

                if (svitDir === 0)
                {
                    if (svit.x + svit.width > w.x && svit.x < w.x + w.width - 1)
                    {
                        if (svit.y < w.y && svit.y + svit.height >= w.y)
                        {
                            svitDir = -1;
                        }
                    }
                }

                if (svitDir === 3)
                {
                    if (svit.x + svit.width > w.x && svit.x < w.x + w.width - 1)
                    {
                        if (svit.y < w.y + w.height + 1 && svit.y + svit.height >= w.y + w.height)
                        {
                           svitDir = -1;
                        }
                    }
                }

                if (svitDir === 1)
                {
                    if (svit.y + svit.height > w.y && svit.y < w.y + w.height - 1)
                    {
                        if (svit.x < w.x + w.width + 1 && svit.x + svit.width >= w.x + w.width + 1)
                        {
                            svitDir = -1;
                        }
                    }
                }

                if (svitDir === 2)
                {
                    if (svit.y + svit.height > w.y && svit.y < w.y + w.height - 1)
                    {
                        if (svit.x < w.x && svit.x + svit.width >= w.x)
                        {
                            svitDir = -1;
                        }
                    }
                }
            }

            // DIAMONDS
            for (var i = 0; i < diamonds.length; i++)
            {
                var w = diamonds[i];

                if (!svit.visible)
                {
                    break;
                }

                if (w.visible === true)
                {
                    if (svit.x + svit.width > w.x && svit.x < w.x + w.width - 1)
                    {
                        if (svit.y < w.y && svit.y + svit.height >= w.y)
                        {
                            w.visible = false;
                            score++;
                            diaCounter++;
                            pingSound.play();
                            break;
                        }
                    }

                    if (svit.x + svit.width > w.x && svit.x < w.x + w.width - 1)
                    {
                        if (svit.y < w.y + w.height && svit.y + svit.height >= w.y + w.height)
                        {
                            w.visible = false;
                            score++;
                            diaCounter++;
                            pingSound.play();
                            break;
                        }
                    }

                    if (svit.y + svit.height > w.y && svit.y < w.y + w.height)
                    {
                        if (svit.x < w.x + w.width + 1 && svit.x + svit.width >= w.x + w.width + 1)
                        {
                            w.visible = false;
                            score++;
                            diaCounter++;
                            pingSound.play();
                            break;
                        }
                    }

                    if (svit.y + svit.height > w.y && svit.y < w.y + w.height)
                    {
                        if (svit.x < w.x && svit.x + svit.width >= w.x)
                        {
                            w.visible = false;
                            score++;
                            diaCounter++;
                            pingSound.play();
                            break;
                        }
                    }
                }
            }

            if (diaCounter === diamonds.length)
            {
                timer.stop();
                svit.visible = false;
                aplauseSound.play();
            }

            // GHOSTS
            for (var i = 0; i < ghosts.length; i++)
            {
                if (!svit.visible)
                {
                    break;
                }

                var ghost = ghosts[i];
                if (svit.x + svit.width > ghost.x && svit.x < ghost.x + ghost.width - 1)
                {
                    if (svit.y < ghost.y && svit.y + svit.height >= ghost.y)
                    {
                        svitDir = 5;
                        svit.visible= false;
                        lives--;
//                        timer.stop();
                        overSound.play();
                        return;
                    }
                }
                if (svit.x + svit.width > ghost.x && svit.x < ghost.x + ghost.width - 1)
                {
                    if (svit.y < ghost.y + ghost.height && svit.y + svit.height >=ghost.y + ghost.height)
                    {
                        svitDir = 5;
                        svit.visible= false;
                        lives--;
//                        timer.stop();
                        overSound.play();
                        return;
                    }
                }
                if (svit.y + svit.height > ghost.y && svit.y < ghost.y + ghost.height)
                {
                    if (svit.x < ghost.x + ghost.width + 1 && svit.x + svit.width >= ghost.x + ghost.width + 1)
                    {
                        svitDir = 5;
                        svit.visible= false;
                        lives--;
//                        timer.stop();
                        overSound.play();
                        return;
                    }
                }
                if (svit.y + svit.height > ghost.y && svit.y < ghost.y + ghost.height)
                {
                    if (svit.x < ghost.x && svit.x + svit.width >= ghost.x)
                    {
                        svitDir = 5;
                        svit.visible= false;
                        lives--;
//                        timer.stop();
                        overSound.play();
                        return;
                    }
                }
            }

            if (svit.visible)
            {
                switch (svitDir)
                {
                    case 0:
                        svit.y = svit.y + 4 * k;
                        break;

                    case 1:
                        svit.x = svit.x - 4 * k;
                        break;

                    case 2:
                        svit.x = svit.x + 4 * k;
                        break;

                    case 3:
                        svit.y = svit.y - 4 * k;
                        break;
                }
            }

            if (svit.x < 48 * k)
            {
                svit.x = 48 * k;
            }

            if (svit.y < 12 * k)
            {
                svit.y = 12 * k;
            }

            if (svit.x > 1935 * k)
            {
                svit.x = 1935 * k;
            }

            if (svit.y > 1004 * k)
            {
                svit.y = 1004 * k;
            }
        }
    }

    onSceneGraphInitialized:
    {
        logoSound.play();
    }


    Item
    {
        id: rect

        x: 0
        y: 0
        width: 1920 * k
        height: 1080 * k

        Rectangle
        {
            color: "white"
            anchors.fill: parent
        }

        Image
        {
            id: bgdImage

            source: "logo.jpg"
            anchors.fill: parent
        }

        Image
        {
            id: heart1

            source: "heart.png"
            visible: gameState === 4 && lives >= 1
            x: 1840 * k
            y: 16 * k
            width: 64 * k
            height: 64 * k
        }

        Image
        {
            id: heart2

            source: "heart.png"
            visible: gameState === 4 && lives >= 2
            x: 1760 * k
            y: 16 * k
            width: 64 * k
            height: 64 * k
        }

        Image
        {
            id: heart3

            source: "heart.png"
            visible: gameState === 4 && lives >= 3
            x: 1680 * k
            y: 16 * k
            width: 64 * k
            height: 64 * k
        }

        Image
        {
            id: battery1

            source: "l1.png"
            visible: gameState === 4
            x: 1840 * k
            y: 1000 * k
            width: 64 * k
            height: 64 * k
        }

        Image
        {
            id: battery2

            source: "l2.png"
            visible: gameState === 4
            x: 1840 * k
            y: 1000 * k
            width: 64 * k
            height: 64 * k
        }

        Image
        {
            id: battery3

            source: "l3.png"
            visible: gameState === 4
            x: 1840 * k
            y: 1000 * k
            width: 64 * k
            height: 64 * k
        }

        Image
        {
            source: "g1.png"
            visible: gameState === 4
            x: 1640 * k
            y: 150 * k
            width: 194 * k
            height: 170 * k
        }

        Image
        {
            source: "g2.png"
            visible: gameState === 4
            x: 1600 * k
            y: 600 * k
            width: 236 * k
            height: 291 * k
        }

        Text
        {
            id: scoreLabel

            text: scoreSettings.score
            anchors.fill: parent
            font.weight: Font.DemiBold
            font.pixelSize: 256
            visible: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text
        {
            id: scoring

            text: score
            x: 1600 * k
            y: 440 * k
            width: 320 * k
            height: 200 * k
            font.weight: Font.Bold
            font.pixelSize: 64 * k
            visible: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        AnimatedSprite
        {
            id: svit

            visible: gameState === 4
            source: "svit.png"
            frameCount: 4
            frameX: 0
            frameY: 0
            frameWidth: 32
            frameHeight: 64
            width: 32 * k
            height: 64 * k
            frameRate: 12
            currentFrame: 0
            running: false
            loops: AnimatedSprite.Infinite
        }

        focus: true

        Keys.enabled: true

        Keys.onReleased:
        {
            // INTRO
            if (gameState === 1)
            {
                return;
            }

            // GAME
            if (gameState === 4)
            {
                switch (event.key)
                {
                    case Qt.Key_Down:
                    case Qt.Key_A:
                        if (svitDir !== 0)
                        {
                            svitDir = 0;
                            svit.running = true;
                            svit.frameY = 0;
                        }
                        else
                        {
                            svitDir = -1;
                            svit.running = false;
                        }
                        break;

                    case Qt.Key_Left:
                    case Qt.Key_O:
                        if (svitDir !== 1)
                        {
                            svitDir = 1;
                            svit.running = true;
                            svit.frameY = 64;
                        }
                        else
                        {
                            svitDir = -1;
                            svit.running = false;
                        }
                        break;

                    case Qt.Key_Right:
                    case Qt.Key_P:
                        if (svitDir !== 2)
                        {
                            svitDir = 2;
                            svit.running = true;
                            svit.frameY = 128;
                        }
                        else
                        {
                            svitDir = -1;
                            svit.running = false;
                        }
                        break;

                    case Qt.Key_Up:
                    case Qt.Key_Q:
                        if (svitDir !== 3)
                        {
                            svitDir = 3;
                            svit.running = true;
                            svit.frameY = 192;
                        }
                        else
                        {
                            svitDir = -1;
                            svit.running = false;
                        }
                        break;

                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                    case Qt.Key_Space:
                        if (action === 0)
                        {
                            ghostMove = false;
                            action = 1000;
                            initPositionGhosts();
                            transportSound.play();
                        }

                        break;

                    case Qt.Key_Menu:
                    case Qt.Key_Delete:
                    case Qt.Key_Backspace:
                        finishGame();
                        break;

                }

                return;
            }

            // MENU
            if (gameState === 2)
            {
                switch (event.key)
                {
                    case Qt.Key_Down:
                    case Qt.Key_A:
                        if (menu < 4)
                        {
                            menu++;
                        }
                        switch (menu)
                        {
                            case 1:
                                bgdImage.source = "hand1.jpg";
                                break;
                            case 2:
                                bgdImage.source = "hand2.jpg";
                                break;
                            case 3:
                                bgdImage.source = "hand3.jpg";
                                break;
                            case 4:
                                bgdImage.source = "hand4.jpg";
                                break;
                        }
                        break;

                    case Qt.Key_Up:
                    case Qt.Key_Q:
                        if (menu > 1)
                        {
                            menu--;
                        }
                        switch (menu)
                        {
                            case 1:
                                bgdImage.source = "hand1.jpg";
                                break;
                            case 2:
                                bgdImage.source = "hand2.jpg";
                                break;
                            case 3:
                                bgdImage.source = "hand3.jpg";
                                break;
                            case 4:
                                bgdImage.source = "hand4.jpg";
                                break;
                        }
                        break;

                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                    case Qt.Key_Space:
                        if (menu === 4)
                        {
                            bgdImage.source = "about.jpg";
                            gameState = 3;
                        }
                        else if (menu === 3)
                        {
                            bgdImage.source = "help.jpg";
                            gameState = 3;
                        }
                        else if (menu === 2)
                        {
                            bgdImage.source = "score.jpg";
                            scoreLabel.visible = true;
                            gameState = 3;
                        }
                        else if (menu === 1)
                        {
                            bgdImage.source = "game.png";

                            menuSound.stop();

                            startGame();
                        }
                        break;
                }

                return;
            }

            if (gameState === 3)
            {
                if (event.key === Qt.Key_Menu || event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace || event.key === Qt.Key_Backspace ||
                    event.key === Qt.Key_Return || event.key === Qt.Key_Enter || Qt.Key_Space)
                {
                    switch (menu)
                    {
                        case 1:
                            bgdImage.source = "hand1.jpg";
                            break;
                        case 2:
                            bgdImage.source = "hand2.jpg";
                            break;
                        case 3:
                            bgdImage.source = "hand3.jpg";
                            break;
                        case 4:
                            bgdImage.source = "hand4.jpg";
                            break;
                    }

                    scoreLabel.visible = false;
                    gameState = 2;
                }

                return;
            }

        }

    }

    function initPositionSvit()
    {
        svit.x = (32 + 48) * k;
        svit.y = (16 + 12) * k;
    }

    function initPositionGhosts()
    {
        for (var i = 0; i < ghosts.length; i++)
        {
            var ghost = ghosts[i];

            ghost.x = (696 + Math.floor(i / 4) * 96 + 48) * k;
            ghost.y = (496 + 12) * k;
            ghost.dir = i % 4;
        }
    }

    function startGame()
    {
        bgdImage.source = "game.png";
        score = 0;
        level = 0;
        lives = 3;
        diaCounter = 0;
        timer.interval = 40;
        action = 0;
        ghostMove = true;
        battery1.visible = false;
        battery2.visible = false;
        battery3.visible = true;

        scoring.visible = true;

        svitDir = -1;
        svit.visible = true;
        svit.currentFrame = 0
        svit.frameRate = 12;
        initPositionSvit();

        var list = new Array(0);
        var list2 = new Array(0);
        var list3 = new Array(0);

        var wallComp = Qt.createComponent("MyImage.qml");
        var ghComp = Qt.createComponent("MyAnimatedSprite.qml");

        var wall;
        var d;
        var gh;

        for (var i = 0; i < map.length; i++)
        {
            if (map[i] === 1)
            {
                wall = wallComp.createObject(rect);
                wall.source = "wall.png";
                wall.x = ((i % 16) * 96 + 48) * k;
                wall.y = (Math.floor(i / 16) * 96 + 12) * k;
                wall.width = 96 * k;
                wall.height = 96 * k;
                list.push(wall);
            }

            if (map[i] === 0)
            {
                d = wallComp.createObject(rect);
                d.source = "diamond.png";
                d.x = ((i % 16) * 96 + 48) * k;
                d.y = (Math.floor(i / 16) * 96 + 12) * k;
                d.width = 96 * k;
                d.height = 96 * k;
                list2.push(d);
            }

        }

        for (var j = 0; j < 8; j++)
        {
            gh = ghComp.createObject(rect);
            gh.visible = true;
            gh.counter = 1;
            gh.source = "ghost.png";
            gh.frameX = 0;
            gh.frameY = 0;
            gh.frameCount = 6;
            gh.frameWidth = 48;
            gh.frameHeight = 64;
            gh.width = 48 * k;
            gh.height = 64 * k;
            gh.currentFrame = 0;
            gh.frameRate = 8;
            gh.dir = j % 4;
            gh.currentFrame = 0
            gh.running = true;
            gh.start();
            list3.push(gh);
        }

        walls = list;
        diamonds = list2;
        ghosts = list3;

        initPositionGhosts();

        gameState = 4;
        timer.start();
    }

    SoundEffect
    {
        id: logoSound

        source: "intro.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                logoPause.start();
            }
        }
    }


    SoundEffect
    {
        id: presentsSound

        source: "presents.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                presentsPause.start();
            }
        }
    }

    SoundEffect
    {
        id: svitSound

        source: "svit.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                svitPause.start();
            }
        }
    }

    SoundEffect
    {
        id: transportSound

        source: "transport.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                ghostMove = true;
            }
        }
    }

    SoundEffect
    {
        id: aplauseSound

        source: "aplause.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                diaCounter = 0;
                diaCounter
                svitDir = -1;
                svit.visible = true;
                svit.currentFrame = 0;

                initPositionSvit();
                initPositionGhosts();

                for (var i = 0; i < diamonds.length; i++)
                {
                    var d = diamonds[i];
                    d.visible = true;
                }

                timer.interval = parseInt(timer.interval * 0.8, 10);
                timer.start();
            }
        }
    }

    function finishGame()
    {
        if (score > scoreSettings.score)
        {
            scoreSettings.score = score;
        }

        battery1.visible = false;
        battery2.visible = false;
        battery3.visible = false;

        timer.stop();

        for (var i = 0; i < walls.length; i++)
        {
            var w = walls[i];
            w.visible = false;
//            w.deleteLater();
        }

        for (var i = 0; i < diamonds.length; i++)
        {
            var d = diamonds[i];
            d.visible = false;
//            d.deleteLater();
        }

        for (var i = 0; i < ghosts.length; i++)
        {
            var d = ghosts[i];
            d.visible = false;
//            d.deleteLater();
        }

        svit.visible = false;

        scoring.visible = false;

        bgdImage.visible = true;

        switch (menu)
        {
            case 1:
                bgdImage.source = "hand1.jpg";
                break;
            case 2:
                bgdImage.source = "hand2.jpg";
                break;
            case 3:
                bgdImage.source = "hand3.jpg";
                break;
            case 4:
                bgdImage.source = "hand4.jpg";
                break;
        }

        gameState = 2;
        menuSound.play();
    }


    SoundEffect
    {
        id: overSound

        source: "laugh.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                if (lives < 0)
                {
                    finishGame();
                }
                else
                {
                    svitDir = -1;
                    svit.visible= true;
                    svit.currentFrame = 0;
                    initPositionGhosts();
                    initPositionSvit();
//                    timer.start();
                }
            }
        }
    }

    SoundEffect
    {
        id: fellowSound

        source: "fellow.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                fellowPause.start();
            }
        }
    }

    SoundEffect
    {
        id: saveSound

        source: "save.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                savePause.start();
            }
        }
    }

    SoundEffect
    {
        id: pingSound

        source: "ping.wav"
    }

    SoundEffect
    {
        id: maySound

        source: "may.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                mayPause.start();
            }
        }
    }

    SoundEffect
    {
        id: laughSound

        source: "laugh.wav"

        onPlayingChanged:
        {
            if (!playing)
            {
                bgdImage.source = "hand1.jpg";
                menu = 1;
                gameState = 2;
                menuSound.play();
            }
        }
    }


    Audio
    {
        id: menuSound
        source: "menu.mp3"
        loops: SoundEffect.Infinite
    }

    PauseAnimation
    {
        id: logoPause

        duration: 1000
        loops: 1

        onStopped:
        {
            presentsSound.play();
            bgdImage.source = "presents.jpg";
        }
    }

    PauseAnimation
    {
        id: presentsPause

        duration: 1000
        loops: 1

        onStopped:
        {
            svitSound.play();
            bgdImage.source = "first_screen_1.jpg";
        }
    }

    PauseAnimation
    {
        id: svitPause

        duration: 400
        loops: 1

        onStopped:
        {
            fellowSound.play();
            bgdImage.source = "first_screen_2.jpg";
        }
    }

    PauseAnimation
    {
        id: fellowPause

        duration: 400
        loops: 1

        onStopped:
        {
            saveSound.play();
            bgdImage.source = "first_screen_3.jpg";
        }
    }

    PauseAnimation
    {
        id: savePause

        duration: 400
        loops: 1

        onStopped:
        {
            maySound.play();
            bgdImage.source = "first_screen_4.jpg";
        }
    }

    PauseAnimation
    {
        id: mayPause

        duration: 400
        loops: 1

        onStopped:
        {
            laughSound.play();
            bgdImage.source = "first_screen_5.jpg";
        }
    }


}

