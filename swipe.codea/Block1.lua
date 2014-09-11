Block1 = class()

function Block1:init(x,y)
    -- you can accept and set parameters here
    self.x=x
    self.y=y
    self.size=0.5
    self.check=false
    self.once=true
    self.color=colors((math.random(1000)/1000)+1)--+(level-1)%5)
end

function Block1:draw()
    noFill()
    --fill(self.color)
    strokeWidth(strokeW)
    stroke(self.color)
    if self.check then
        if self.size<1 then
            self.size = self.size + 0.1
        else
            self.size=1
            table.insert(levels[level],{self.x,self.y})
        end
    end
    rect(gridX(self.x),gridY(self.y)+popup,size*self.size,size*self.size)
end

function Block1:hit()
    if self.once then
        self.once=false
        sound(SOUND_BLIT, 19320, volume)
    end
    self.check=true
end

function Block1:getPosX()
    return self.x
end
function Block1:getPosY()
    return self.y
end
