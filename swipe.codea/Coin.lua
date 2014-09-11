Coin = class()

function Coin:init(x,y)
    self.x=x
    self.y=y
    self.color=colors((math.random(1000)/1000)+3)--+(level+2)%5)
end

function Coin:draw()
    strokeWidth(strokeW*0.5)
    noFill()
    stroke(self.color)
    ellipse(gridX(self.x),gridY(self.y),size*0.5)
end

function Coin:getPosX()
    return self.x
end
function Coin:getPosY()
    return self.y
end




