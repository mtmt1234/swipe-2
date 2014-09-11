Char = class()

function Char:init(x,y)
    self.x=x
    self.y=y
    self.size=size
    self.bnum=bmax
    self.b=0
    self.bx=0
    self.by=0
    
end

function Char:draw()
    char:bounch()
    if (movingDown or movingUp or movingLeft or movingRight) or win then
        self.bx=0
        self.by=0
    end
    noFill()
    strokeWidth(strokeW)
    stroke(255, 255, 255, 255)
    
    if self.x>border or self.x<-border then
        self.x=-self.x
    end
    if self.y>border or self.y<-border then
        self.y=-self.y
    end
    
    ellipse(gridX(self.x+left-right+self.bx),gridY(self.y+down-up+self.by),size*fadeOut-math.abs(self.bx)*deform,size*fadeOut-math.abs(self.by)*deform)
end

function Char:setPos(x,y)
    self.x=x
    self.y=y
    --self.gridX=x
    --self.gridY=y
end

function Char:getPosX()
    return self.x
end
function Char:getPosY()
    return self.y
end

function Char:moveRight()
    touchNext=false
    for i=2, table.maxn(levels[level]) do
        if self.x+1==levels[level][i][1] and self.y==levels[level][i][2] then
            touchNext=true
        end
    end
    if not touchNext then
        movingRight=true
        lastMove2=lastMove
        lastMove="right"
        right=1
        self.x=self.x+1
        self.y=self.y
        return true
    end
    return false
end
function Char:moveLeft()
    touchNext=false
    for i=2, table.maxn(levels[level]) do
        if self.x-1==levels[level][i][1] and self.y==levels[level][i][2] then
            touchNext=true
        end
    end
    if not touchNext then
        movingLeft=true
        lastMove2=lastMove
        lastMove="left"
        left=1
        self.x=self.x-1
        self.y=self.y
        return true
    end
    return false
end
function Char:moveUp()
    touchNext=false
    for i=2, table.maxn(levels[level]) do
        if self.x==levels[level][i][1] and self.y+1==levels[level][i][2] then
            touchNext=true
        end
    end
    if not touchNext then
        movingUp=true
        lastMove2=lastMove
        lastMove="up"
        up=1
        self.x=self.x
        self.y=self.y+1
        return true 
    end
    return false
end
function Char:moveDown()
    touchNext=false
    for i=2, table.maxn(levels[level]) do
        if self.x==levels[level][i][1] and self.y-1==levels[level][i][2] then
            touchNext=true
        end
    end
    if not touchNext then
        movingDown=true
        lastMove2=lastMove
        lastMove="down"
        down=1
        self.x=self.x
        self.y=self.y-1
        return true
    end
    return false
end

function Char:bounch()
    if touchNext then
        if self.bnum==2 then
            if self.b<bounchLevel then
                self.b = self.b + step1
            else
                self.bnum=1
            end
        elseif self.bnum==1 then
            if self.b>0 then
                self.b = self.b - step1
            else
                self.bnum=0
            end
        else
            self.b=0
        end
    else
        self.bnum=bmax
        self.b=0
    end
    
    if lastMove=="left" then
        self.bx=-self.b*0.1
    elseif lastMove=="right" then
        self.bx=self.b*0.1
    elseif lastMove=="up" then
        self.by=self.b*0.1
    elseif lastMove=="down" then
        self.by=-self.b*0.1
    end
end
