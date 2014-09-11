Edge = class()

function Edge:init(x,y,d)
    self.x=x
    self.y=y
    self.d=d
    self.color=colors((math.random(1000)/1000)+2)
end

function Edge:draw()
    
    smooth()
    if size>1 then
        lineCapMode(ROUND)
        stroke(self.color)
    else 
        lineCapMode(SQUARE)
        noStroke()
    end
    if self.d==1 then
        line(gridX(self.x)-size/2,gridY(self.y)-size/2+popup,gridX(self.x)+size/2,gridY(self.y)+size/2+popup)
    else
        line(gridX(self.x)+size/2,gridY(self.y)-size/2+popup,gridX(self.x)-size/2,gridY(self.y)+size/2+popup)
    end
end

function Edge:hit()
    if not win then
        --sound(SOUND_JUMP, 49208,volume)
        if self.d==1 then
            if lastMove=="right" then
                movingRight=false
                movingUp=true
                elseif lastMove=="left" then
                movingLeft=false
                movingDown=true
                elseif lastMove=="up" then
                movingUp=false
                movingRight=true
                elseif lastMove=="down" then
                movingDown=false
                movingLeft=true
            end
            else
            if lastMove=="right" then
                movingRight=false
                movingDown=true
                elseif lastMove=="left" then
                movingLeft=false
                movingUp=true
                elseif lastMove=="up" then
                movingUp=false
                movingLeft=true
                elseif lastMove=="down" then
                movingDown=false
                movingRight=true
            end
        end
    end
end

function Edge:getPosX()
    return self.x
end
function Edge:getPosY()
    return self.y
end
