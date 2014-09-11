MainMenu = class()

function MainMenu:init(x,y,id,c)
    self.x=x
    self.y=y
    self.id=id
    self.color=colors(c)--+(level+2)%5)
end

function MainMenu:draw()
    strokeWidth(strokeW*0.4)
    noFill()
    tint(self.color)
    sprite("Documents:"..self.id,gridX(self.x),gridY(self.y),size*1.2,size*1.2)
    noTint()
    
    font("HelveticaNeue-UltraLight")
    fontSize(size*0.6)
    fill(self.color)
    --text(self.id,gridX(self.x),gridY(self.y)+popup)
end

function MainMenu:getPosX()
    return self.x
end
function MainMenu:getPosY()
    return self.y
end
function MainMenu:getId()
    return self.id
end
