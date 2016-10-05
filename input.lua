Input = {}
    Input.key = {}
        Input.key.up    = false
        Input.key.down  = false
        Input.key.left  = false
        Input.key.right = false

    function Input:update()
        for key, value in pairs(self.key)
            if love.keyboard.isDown(key) then
                self.key[key] = true
            else
                self.key[key] = false
            end
        end
    end
