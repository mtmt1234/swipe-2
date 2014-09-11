MenuCoin = class()

function MenuCoin:init(x,y,id)
    self.x=x
    self.y=y
    self.id=id
    self.color=(id%4)/4*6--+(level+2)%5)
end

function MenuCoin:draw()
    if readGlobalData("rainbow"..self.id,false) then
        self.color=rainbow
    end
    strokeWidth(strokeW*0.4)
    noFill()
    stroke(colors(self.color))
    ellipse(gridX(self.x),gridY(self.y)+popup,size)
    
    font("HelveticaNeue-UltraLight")
    fontSize(size*0.6)
    fill(colors(self.color))
    text(self.id,gridX(self.x),gridY(self.y)+popup)
end

function MenuCoin:getPosX()
    return self.x
end
function MenuCoin:getPosY()
    return self.y
end
function MenuCoin:getId()
    return self.id
end




