Block = class()

function Block:init(x,y)
    -- you can accept and set parameters here
    self.x=x
    self.y=y
    self.size=size
    self.color=colors((math.random(1000)/1000))--+(level-1)%5)
end

function Block:draw()
    noFill()
    --fill(self.color)
    strokeWidth(strokeW)
    stroke(self.color)
    rect(gridX(self.x),gridY(self.y)+popup,size,size)
end

function Block:touched(touch)
    
end
