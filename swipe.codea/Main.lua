-- maze

-- Use this function to perform your initial setup
displayMode(FULLSCREEN_NO_BUTTONS)
rectMode(CENTER)
backingMode(RETAINED)
--saveGlobalData("menuLevel",1)
--saveGlobalData("gameLevel",27)
--saveGlobalData(5,1000)
function setup()
    popup=0
    mode=readGlobalData("mode","menu")
    if mode=="game" then
        setupGame()
    else
        setupMenu()
    end
end


function setupGame()
    blocksize=50
    zoom=3300
    deltaTouch=20
    strokeW=3
    border=5.5
    corner=1/7
    normalStep=0.5
    step=normalStep
    bmax=2
    step1=0.75
    bounchLevel=2
    deform=50
    slowMode=true
    volume=0
    maxLevel=readGlobalData("maxLevel",1)
    
    blocks={}
    coins={}
    spikes={}
    blocks1={}
    edges={}
    level=readGlobalData("gameLevel",1)
    
    if level>maxLevel then
        saveGlobalData("maxLevel",level)
    end
    
    bestmoves=readGlobalData(level,1000)
    moves=0
    for i=2, table.maxn(levels[level]) do
        table.insert(blocks,Block(levels[level][i][1],levels[level][i][2]))
    end
    for i=1, table.maxn(levelcoins[level]) do
        table.insert(coins,Coin(levelcoins[level][i][1],levelcoins[level][i][2]))
    end
    for i=1, table.maxn(levelspikes[level]) do
        table.insert(spikes,Spike(levelspikes[level][i][1],levelspikes[level][i][2]))
    end
    
    for i=1, table.maxn(levelblock1[level]) do
        table.insert(blocks1,Block1(levelblock1[level][i][1],levelblock1[level][i][2]))
    end
    
    for i=1, table.maxn(leveledges[level]) do
        table.insert(edges,Edge(leveledges[level][i][1],leveledges[level][i][2],leveledges[level][i][3]))
    end
    
    if table.maxn(leveledges[level])<1 then
        slowMode=false
    end
    
    fade=1
    left=0
    right=0
    down=0
    up=0
    movingLeft=false
    movingRight=false
    movingUp=false
    movingDown=false
    
    t=false
    start=false
    
    size=0
    
    win=false
    fast=false
    zoomIn=1
    zoomIn1=1
    fadeOut=1
    colornum=0
    lastMove=""
    lastMove2=""
    zText=0
    times=0
    lastMoves=""
    slow=false
    normalBackgroundAlpha=1
    backgroundAlpha=normalBackgroundAlpha
    slower=1
    once=true
    soundOnce=""
    
    char=Char(levels[level][1][1],levels[level][1][2])
end

-- This function gets called once every frame
function draw()
    if mode=="game" then
        drawGame()
    else
        drawMenu()
    end
end


function drawGame()
    
    --clip(10,10,WIDTH-10,HEIGHT-10)
    
    if slow then
        fill(0, 0, 0, 255*backgroundAlpha)
        noStroke()
        rect(WIDTH/2,HEIGHT/2,WIDTH,HEIGHT)
    else
        background(0, 0, 0, 255)
    end
    --strokeW=size/18
    if size<0 then
        strokeW=0
    end
    
    strokeWidth(strokeW)
    
    char:draw()
    
    drawBorder()
    
    
    score(moves)
    printmoves()
    
    charX=char:getPosX()
    charY=char:getPosY()
    
    for i=1, table.maxn(blocks) do
        blocks[i]:draw()
    end
    
    for i=1, table.maxn(coins) do
        coins[i]:draw()
    end
    
    for i=1, table.maxn(spikes) do
        spikes[i]:draw()
    end
    
    for i=1, table.maxn(blocks1) do
        blocks1[i]:draw()
    end
    
    for i=1, table.maxn(edges) do
        edges[i]:draw()
    end
    
    if touchNext and soundOnce~=lastMove then
        soundOnce=lastMove
        --sound(SOUND_HIT, 36378,volume)
    end
    
    --print(char:getPosY())
    for i=1, table.maxn(coins) do
        if char:getPosX()==coins[i]:getPosX() and char:getPosY()==coins[i]:getPosY() then
            --table.insert(coins,i,coins[table.maxn(coins)])
            table.remove(coins,i)
            --sound(SOUND_PICKUP, 104, volume)
            break
        end
    end
    if table.maxn(coins)==0 then
        win=true
    end
    
    for i=1, table.maxn(spikes) do
        if char:getPosX()==spikes[i]:getPosX() and char:getPosY()==spikes[i]:getPosY() then
            if fadeOut>0 and not win then
                --sound(SOUND_HIT, 130, volume)
                --sound(SOUND_SHOOT, 36374, volume)
                movingRight=false
                movingLeft=false
                movingDown=false
                movingUp=false
                fadeOut = fadeOut - 0.1
            else
                if not win then
                    newGame()
                end
            end
            break
        end
    end
    
    for i=1, table.maxn(blocks1) do
        if char:getPosX()==blocks1[i]:getPosX() and char:getPosY()==blocks1[i]:getPosY() then
            blocks1[i]:hit()
            break
        end
    end
    
    for i=1, table.maxn(edges) do
        if char:getPosX()==edges[i]:getPosX() and char:getPosY()==edges[i]:getPosY() then
            edges[i]:hit()
            break
        end
    end
    
    if left-step>=0 then
        left = left - step
    elseif movingLeft then
        movingLeft=false
        char:moveLeft()
    end
    if right-step>=0 then
        right = right - step
    elseif movingRight then
        movingRight=false
        char:moveRight()
    end
    if down-step>=0 then
        down = down - step
    elseif movingDown then
        movingDown=false
        char:moveDown()
    end
    if up-step>=0 then
        up = up - step
    elseif movingUp then
        movingUp=false
        char:moveUp()
    end
    
    if not win then
        if size<blocksize and not out then
            size = size+0.05*size+1
        else
            size=blocksize
            start=true
        end
    else
        if size>-1 then
            size = size - 1.5
        end
        if once then
            once=false
            --sound(SOUND_POWERUP, 3152,volume)
        end
    end
    if win then
        if moves<=bestmoves then
            fast=true
            saveGlobalData(level,moves)
            saveGlobalData("rainbow"..level,true)
            bestmoves=moves
        end
        if zoomIn>0 and not fast then
            zoomIn = zoomIn - 0.02 - zoomIn*0.05
        elseif zoomIn1>0 and fast then
            zoomIn1 = zoomIn1 - 0.02 - zoomIn1*0.05
            zoomIn = zoomIn - 0.02 - zoomIn*0.05
        else
            if CurrentTouch.state==BEGAN then
                saveGlobalData("gameLevel",(level%table.maxn(levels)+1))
                newGame()
            end
        end
    end
    
    if CurrentTouch.tapCount==3 then
        saveGlobalData("mode","menu")
        --saveGlobalData("mainMenu",true)
        saveGlobalData("menuLevel",math.ceil(level/4))
        setup()
    end
    
    if movingRight or movingLeft or movingUp or movingDown then
        if CurrentTouch.tapCount==1 and CurrentTouch.state==MOVING then
            slow=true
        else
            slow=false
        end 
    end
    
    if slow and start and not win and slowMode then
        slowDown()
    else
        speedUp()
    end
    
    if level==1 and not menu and start and not win then --tutorial
        if moves==0 then
            printText("slide to move")
        else
            printText("collect all coins")
        end
    end
    
    unable()
    changeLevel()
end



function gridX(x)
    return (zoom*x/size+WIDTH/2)
end

function gridY(y)
    return (zoom*y/size+HEIGHT/2)
end

function touched(touch)
    if touch.state==BEGAN then
        startX=touch.x
        startY=touch.y
    end
    if CurrentTouch.state==ENDED and 
    ((not movingRight) and (not movingLeft) and (not movingUp) and (not movingDown)) 
        and not win 
        and start then
        max=math.max(math.abs(CurrentTouch.x-startX),math.abs(CurrentTouch.y-startY))
        if max>deltaTouch then
            if CurrentTouch.x-startX==max then
                if char:moveRight() then moves = moves + 1 end
                elseif CurrentTouch.x-startX==-max then
                    if char:moveLeft() then moves = moves + 1 end
                elseif CurrentTouch.y-startY==max then
                    if char:moveUp() then moves = moves + 1 end
                elseif CurrentTouch.y-startY==-max then
                    if char:moveDown() then moves = moves + 1 end
            end
        end
    end
    
    if touch.state==BEGAN then
        if t then
            newGame()
        end
        t=true
    else
        t=false
    end
end

function colors(s)
    if s<=3 then
    r=-math.sqrt(((s-0)^2))+2
    else
    r=-math.sqrt(((s-6)^2))+2
    end  
    g=-math.sqrt(((s-2)^2))+2
    b=-math.sqrt(((s-4)^2))+2
    return color(255*r,255*g,255*b)
end

function score(num)
    font("HelveticaNeue-UltraLight")
    fontSize(50+(1-zoomIn)*100)
    fill(255, 255, 255, 255*zoomIn1)
    if moves<100 then
        txt=math.ceil(num)
    else
        txt="99+"
    end
    text(txt,WIDTH/2+(WIDTH/2-70)*zoomIn, HEIGHT/2+(HEIGHT/2-50)*zoomIn)
end

function printmoves()
    font("HelveticaNeue-UltraLight")
    fontSize(50+(1-zoomIn1)*100)
    if fast then
        fill(colors(colornum))
        colornum = (colornum + 0.1)%6
    else
        fill(255, 255, 255, 255)
    end
    if bestmoves==1000 then
        txt="--"
    else
        txt=bestmoves
    end
    text(txt,WIDTH/2-(WIDTH/2-70)*zoomIn1, HEIGHT/2+(HEIGHT/2-50)*zoomIn1)
end

function drawBorder() 
    rectMode(CORNER)
    fill(0, 0, 0, 255)
    noStroke()
    rect(-1,0,gridX(-border),HEIGHT)
    rect(0,-1,WIDTH,gridY(-border))
    rect(gridX(border),0,WIDTH-gridX(border)+1,HEIGHT)
    rect(0,gridY(border),WIDTH,HEIGHT-gridY(border)+1)
    rectMode(CENTER)
end

function newGame()
    restart()
end

function changeLevel()
    if CurrentTouch.x>WIDTH-10 and CurrentTouch.y<10 and lastMove~="" then
        saveGlobalData("gameLevel",(level%table.maxn(levels)+1))
        newGame()
    end
end

function printText(txt)
    if zIn then 
        if zText<1 then
            zText = zText + 0.01 + zText*0.005
        else
            zIn=false
        end
    else
        if zText>0 then
            zText = zText - 0.01 - zText*0.005
        else
            zIn=true
        end
    end
    font("HelveticaNeue-UltraLight")
    fontSize(30+zText*10)
    fill(255, 255, 255, 255*zText)
    text(txt,WIDTH/2, 50)
end

function unable()
    --print(lastMoves)
    if lastMoves==moves and lastMove==lastMove2 and (movingLeft or movingRight or movingUp or movingDown) and not win then
        times = times + 1
        if times>60*slower then
            printText("2 fingers to restart")
        end
    else
        times=0
    end
    lastMoves=moves
end

function slowDown()
    slower=2
    step=normalStep*0.5
    backgroundAlpha=normalBackgroundAlpha*0.2
    
end
function speedUp()
    slower=1
    step=normalStep
    backgroundAlpha=normalBackgroundAlpha
end


















function setupMenu()
    blocksize=50
    zoom=3300
    deltaTouch=20
    strokeW=3
    border=5.5
    corner=1/7
    normalStep=0.5
    step=normalStep
    bmax=2
    step1=0.75
    bounchLevel=2
    deform=50
    slowMode=true
    volume=0
    maxLevel=readGlobalData("maxLevel",1)
    mainMenu=readGlobalData("mainMenu")
    popupMode=readGlobalData("popup")
    set=readGlobalData("set")
    if mainMenu then
        popup=0
        size=0
        saveGlobalData("menuLevel",1)
        saveGlobalData("set",false)
    else
        if popupMode=="up" then
            popup=-HEIGHT
            size=blocksize
        elseif popupMode=="down" then
            popup=HEIGHT
            size=blocksize
        else
            popup=0
            size=0
            popupMode=""
        end
    end
    
    blocks={}
    coins={}
    spikes={}
    blocks1={}
    edges={}
    mainCoins={}
    level=readGlobalData("menuLevel",1)
    if level<1 then
        level=1
    end
    
    moves=0
    if set then
        for i=1, table.maxn(menulevels[level]) do
            table.remove(menulevels[level])
        end
        for i=1, table.maxn(menulevelcoins[level]) do
            table.remove(menulevelcoins[level])
        end
        for i=1, table.maxn(menulevelspikes[level]) do
            table.remove(menulevelspikes[level])
        end
        table.insert(mainCoins,MainMenu(4,-3,"reset",1.5))
        table.insert(menulevels[level],1,{0,-1})
        table.insert(menulevels[level],2,{0,-1})
        table.insert(menulevels[level],3,{1,-2})
        table.insert(menulevels[level],4,{2,-3})
        table.insert(menulevels[level],5,{3,-4})
        table.insert(menulevels[level],6,{2,0})
        table.insert(menulevels[level],7,{3,-1})
        table.insert(menulevels[level],8,{4,-2})
        table.insert(spikes,Spike(0,1))
        table.insert(spikes,Spike(-1,0))
    end
    if not mainMenu or set then
        for i=2, table.maxn(menulevels[level]) do
            table.insert(blocks,Block(menulevels[level][i][1],menulevels[level][i][2]))
        end
        for i=1, table.maxn(menulevelcoins[level]) do
            table.insert(coins,MenuCoin(menulevelcoins[level][i][1],menulevelcoins[level][i][2],(level-1)*4+i))
        end
        for i=1, table.maxn(menulevelspikes[level]) do
            table.insert(spikes,Spike(menulevelspikes[level][i][1],menulevelspikes[level][i][2]))
        end
        
        for i=1, table.maxn(menulevelblock1[level]) do
            table.insert(blocks1,Block1(menulevelblock1[level][i][1],menulevelblock1[level][i][2]))
        end
        
        for i=1, table.maxn(menuleveledges[level]) do
            table.insert(edges,Edge(menuleveledges[level][i][1],menuleveledges[level][i][2],menuleveledges[level][i][3]))
        end
    end
    
        
    if mainMenu then
        if set then
            char=MenuChar(0,0)
            table.insert(mainCoins,MainMenu(4,-3,"reset",0))
            table.insert(blocks,Block(0,-1))
            table.insert(blocks,Block(1,-2))
            table.insert(blocks,Block(2,-3))
            table.insert(blocks,Block(3,-4))
            table.insert(blocks,Block(2,0))
            table.insert(blocks,Block(3,-1))
            table.insert(blocks,Block(4,-2))
            table.insert(spikes,Spike(0,1))
            table.insert(spikes,Spike(-1,0))
            table.insert(spikes,Spike(1,2))
            
            saveGlobalData("popup","")
        else
            char=MenuChar(0,0)
            table.insert(mainCoins,MainMenu(2,0,"play",4))
            table.insert(mainCoins,MainMenu(0,-2,"level",1))
            table.insert(mainCoins,MainMenu(0,2,"set",0))
            saveGlobalData("popup","")
        end
    else
        char=MenuChar(menulevels[level][1][1],menulevels[level][1][2])
    end
    
    
    fade=1
    left=0
    right=0
    down=0
    up=0
    movingLeft=false
    movingRight=false
    movingUp=false
    movingDown=false
    
    t=false
    start=false
    
    win=false
    fast=false
    zoomIn=1
    zoomIn1=1
    fadeOut=1
    colornum=0
    lastMove=""
    lastMove2=""
    zText=0
    times=0
    lastMoves=""
    slow=false
    normalBackgroundAlpha=1
    backgroundAlpha=normalBackgroundAlpha
    slower=1
    once=true
    soundOnce=""
    out=false
    outDown=false
    outUp=false
    withoutTouch=false
    rainbow=0
    fadeIn=0
    frame=0
    
    --char=Char(levels[level][1][1],levels[level][1][2])
end
















function drawMenu()
    --clip(10,10,WIDTH-10,HEIGHT-10)
    
    if slow then
        fill(0, 0, 0, 255*backgroundAlpha)
        noStroke()
        rect(WIDTH/2,HEIGHT/2,WIDTH,HEIGHT)
    else
        background(0, 0, 0, 255)
    end
    --strokeW=size/18
    if size<0 then
        strokeW=0
    end
    
    strokeWidth(strokeW)
    
    
    if fadeIn<1 and start then
        fadeIn = fadeIn + 0.05
    end
    if not mainMenu then
        arrow(2,-4.5,-0.25*fadeIn)
        arrow(2,4.5,0.25*fadeIn)
    end
    
    char:draw()
    
    drawBorder()
    
    
    --score(moves)
    --printmoves()
    
    charX=char:getPosX()
    charY=char:getPosY()
    
    for i=1, table.maxn(blocks) do
        blocks[i]:draw()
    end
    
    for i=1, table.maxn(coins) do
        coins[i]:draw()
    end
    
    for i=1, table.maxn(spikes) do
        spikes[i]:draw()
    end
    
    for i=1, table.maxn(blocks1) do
        blocks1[i]:draw()
    end
    
    for i=1, table.maxn(edges) do
        edges[i]:draw()
    end
    
    if mainMenu then
        for i=1, table.maxn(mainCoins) do
            mainCoins[i]:draw()
        end
    end
    
    if touchNext and soundOnce~=lastMove then
        soundOnce=lastMove
        --sound(SOUND_HIT, 36378,volume)
    end
    
    --print(char:getPosY())
    for i=1, table.maxn(coins) do
        if char:getPosX()==coins[i]:getPosX() and char:getPosY()==coins[i]:getPosY() then
            --table.insert(coins,i,coins[table.maxn(coins)])
            
            
            saveGlobalData("mode","game")
            saveGlobalData("gameLevel",coins[i]:getId())
            --print(coins[i]:getId())
            
            withoutTouch=true
            table.remove(coins,i)
            --sound(SOUND_PICKUP, 104, volume)
            win=true
            break
        end
    end
    
    for i=1, table.maxn(mainCoins) do
        if char:getPosX()==mainCoins[i]:getPosX() and char:getPosY()==mainCoins[i]:getPosY() then
            --table.insert(coins,i,coins[table.maxn(coins)])
            if mainCoins[i]:getId()=="set" then
                set=true
                saveGlobalData("set",true)
                saveGlobalData("mainMenu",true)
                print("test")
                out=true
            end
            if mainCoins[i]:getId()=="play" then
                print("play")
                saveGlobalData("mode","game")
            end
            if mainCoins[i]:getId()=="reset" then
                print("reset")
                for i=1, 4 do--table.maxn(levels) do
                    saveGlobalData(i,1000)
                    saveGlobalData("rainbow"..i,false)
                end
                saveGlobalData("maxLevel",1)
                saveGlobalData("gameLevel",1)
            end
            table.remove(mainCoins,i)
            --sound(SOUND_PICKUP, 104, volume)
            win=true
            break
        end
    end
    
    for i=1, table.maxn(spikes) do
        if char:getPosX()==spikes[i]:getPosX() and char:getPosY()==spikes[i]:getPosY() then
            if fadeOut>0 and not win then
                --sound(SOUND_HIT, 130, volume)
                --sound(SOUND_SHOOT, 36374, volume)
                movingRight=false
                movingLeft=false
                movingDown=false
                movingUp=false
                fadeOut = fadeOut - 0.1
            else
                if not win then
                    saveGlobalData("mainMenu",true)
                    saveGlobalData("set",false)
                    newGame()
                end
            end
            break
        end
    end
    
    for i=1, table.maxn(blocks1) do
        if char:getPosX()==blocks1[i]:getPosX() and char:getPosY()==blocks1[i]:getPosY() then
            blocks1[i]:hit()
            break
        end
    end
    
    for i=1, table.maxn(edges) do
        if char:getPosX()==edges[i]:getPosX() and char:getPosY()==edges[i]:getPosY() then
            edges[i]:hit()
            break
        end
    end
    
    if left-step>=0 then
        left = left - step
    elseif movingLeft then
        movingLeft=false
        char:moveLeft()
    end
    if right-step>=0 then
        right = right - step
    elseif movingRight then
        movingRight=false
        char:moveRight()
    end
    if down-step>=0 then
        down = down - step
    elseif movingDown then
        movingDown=false
        char:moveDown()
    end
    if up-step>=0 then
        up = up - step
    elseif movingUp then
        movingUp=false
        char:moveUp()
    end
    
    
    
    
    if popupMode=="up" and not mainMenu then 
        if not out and not outUp then
            if popup+30<0 then
                popup = popup + 30
            else
                popup=0
                start=true
            end
        else 
            if popup<HEIGHT then
                start=false
                down=0
                popup = popup + 30
            else
                saveGlobalData("menuLevel",(level%table.maxn(menulevels)+1))
                newGame()
            end
        end
    end
    
    if popupMode=="down" and not mainMenu then 
        if not out and not outDown then
            if popup-30>0 then
                popup = popup - 30
            else
                popup=0
                start=true
            end
        else 
            if popup>-HEIGHT then
                start=false
                up=0
                popup = popup - 30
            else
                if level-1==0 then
                    saveGlobalData("menuLevel",table.maxn(menulevels))
                else
                    saveGlobalData("menuLevel",(level-1))
                end
                newGame()
            end
        end
    end
        

    if (mainMenu or popupMode=="") and not win then       
        if size<blocksize and not out then
            size = size+0.05*size+1
        else
            size=blocksize
            start=true
        end
    end
    
    if win then
        if size>-1 then
            size = size - 1.5 - size*0.02
        else
            if mainMenu then
                print("end")
                saveGlobalData("mainMenu",false)
                newGame()
            end
        end
        if once then
            once=false
            --sound(SOUND_POWERUP, 3152,volume)
        end
    end

    if win then
        if CurrentTouch.state==BEGAN or (set and size<0) or (withoutTouch and size<0) then
            saveGlobalData("menuLevel",(level%table.maxn(menulevels)+1))
            newGame()
        end
    end
    
    rainbow=(rainbow+0.1)%6
    
    frame = frame + 1
    if frame>100 and mainMenu and not set and not win then 
        printText("slide to play –>")
    end
    
    if CurrentTouch.tapCount==4 and mode=="menu"then
        close()
    end
end



function gridX(x)
    return (zoom*x/size+WIDTH/2)
end

function gridY(y)
    return (zoom*y/size+HEIGHT/2)
end

function touched(touch)
    if touch.state==BEGAN then
        startX=touch.x
        startY=touch.y
    end
    if CurrentTouch.state==ENDED and 
    ((not movingRight) and (not movingLeft) and (not movingUp) and (not movingDown)) 
        and not win 
        and start then
        max=math.max(math.abs(CurrentTouch.x-startX),math.abs(CurrentTouch.y-startY))
        if max>deltaTouch then
            if CurrentTouch.x-startX==max then
                if char:moveRight() then moves = moves + 1 end
                elseif CurrentTouch.x-startX==-max then
                    if char:moveLeft() then moves = moves + 1 end
                elseif CurrentTouch.y-startY==max then
                    if char:moveUp() then moves = moves + 1 end
                elseif CurrentTouch.y-startY==-max then
                    if char:moveDown() then moves = moves + 1 end
            end
        end
    end
    
    if touch.state==BEGAN then
        if t then
            newGame()
        end
        t=true
    else
        t=false
    end
end

function colors(s)
    if s<=3 then
    r=-math.sqrt(((s-0)^2))+2
    else
    r=-math.sqrt(((s-6)^2))+2
    end  
    g=-math.sqrt(((s-2)^2))+2
    b=-math.sqrt(((s-4)^2))+2
    return color(255*r,255*g,255*b)
end


--[[
function drawBorder() 
    rectMode(CORNER)
    fill(0, 0, 0, 255)
    noStroke()
    rect(-1,0,gridX(-border),HEIGHT)
    rect(0,-1,WIDTH,gridY(-border))
    rect(gridX(border),0,WIDTH-gridX(border)+1,HEIGHT)
    rect(0,gridY(border),WIDTH,HEIGHT-gridY(border)+1)
    rectMode(CENTER)
end
  ]]

function arrow(x,y,s)
    stroke(0, 225, 255, 255*fadeIn)
    line(gridX(x),gridY(y+s)+popup,gridX(x),gridY(y-2*s)+popup)
    line(gridX(x),gridY(y+s)+popup,gridX(x+s),gridY(y)+popup)
    line(gridX(x),gridY(y+s)+popup,gridX(x-s),gridY(y)+popup)
end

function newGame()
    restart()
end


