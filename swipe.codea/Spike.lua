Spike = class()

function Spike:init(x,y)
    self.x=x
    self.y=y
    self.color=colors((math.random(1000)/1000)+5)
end

function Spike:draw()
    lineCapMode(ROUND)
    strokeWidth(strokeW)
    stroke(self.color)
    line(gridX(self.x)-size/2,gridY(self.y)+popup,gridX(self.x)-size*corner,gridY(self.y)-size*corner+popup)
    line(gridX(self.x),gridY(self.y)-size/2+popup,gridX(self.x)-size*corner,gridY(self.y)-size*corner+popup)
    
    line(gridX(self.x)+size/2,gridY(self.y)+popup,gridX(self.x)+size*corner,gridY(self.y)+size*corner+popup)
    line(gridX(self.x),gridY(self.y)+size/2+popup,gridX(self.x)+size*corner,gridY(self.y)+size*corner+popup)
    
    line(gridX(self.x)-size/2,gridY(self.y)+popup,gridX(self.x)-size*corner,gridY(self.y)+size*corner+popup)
    line(gridX(self.x),gridY(self.y)+size/2+popup,gridX(self.x)-size*corner,gridY(self.y)+size*corner+popup)
    
    line(gridX(self.x)+size/2,gridY(self.y)+popup,gridX(self.x)+size*corner,gridY(self.y)-size*corner+popup)
    line(gridX(self.x),gridY(self.y)-size/2+popup,gridX(self.x)+size*corner,gridY(self.y)-size*corner+popup)
    
    ---line(gridX(self.x)-size/2,gridY(self.y),gridX(self.x),gridY(self.y)+size/2)
    ---line(gridX(self.x)+size/2,gridY(self.y),gridX(self.x),gridY(self.y)-size/2)
    ---line(gridX(self.x)+size/2,gridY(self.y),gridX(self.x),gridY(self.y)+size/2)
end

function Spike:getPosX()
    return self.x
end
function Spike:getPosY()
    return self.y
end
