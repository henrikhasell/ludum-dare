SoundManager = {}

function play_sound(sound)
    local clone = sound:clone()
    clone:play()
end

function SoundManager:new()
    local instance = {
        sounds = {
            rocket_fire = love.audio.newSource('Assets/Sound/rocket_fire.wav', 'static'),
            death = love.audio.newSource('Assets/Sound/death.wav', 'static'),
	    level_up = love.audio.newSource('Assets/Sound/level_up.wav', 'static'),
	    pickup_key = love.audio.newSource('Assets/Sound/pickup_key.wav', 'static'),
	    pickup_key_alt = love.audio.newSource('Assets/Sound/pickup_key_alt.wav', 'static'),
	    ghost_spread_attack = love.audio.newSource('Assets/Sound/Ghost/spread_attack.wav', 'static'),
	    ghost_hit = love.audio.newSource('Assets/Sound/Ghost/hit.wav', 'static'),
	    missile_die = love.audio.newSource('Assets/Sound/Ghost/missile_die.wav', 'static'),
        },
        sound_pool = {
    	rocket_fire = {}
        }
    }
    setmetatable(instance, {__index = SoundManager})
    return instance
end

function SoundManager:playRocketSound()
    for k, v in ipairs(self.sound_pool.rocket_fire) do
        if not v:isPlaying() then
	    love.audio.play(v)
	    return
        end
    end
    if #self.sound_pool.rocket_fire < 4 then
        local clone = self.sounds.rocket_fire:clone()
	table.insert(self.sound_pool.rocket_fire, clone)
	love.audio.play(clone)
    end
end

function SoundManager:playDeathSound()
    play_sound(self.sounds.death)
end

function SoundManager:playPickupKeySound()
    play_sound(self.sounds.pickup_key)
end

function SoundManager:playUnlockDoorSound()
    self.sounds.pickup_key_alt:play()
end

function SoundManager:playLevelUpSound()
    self.sounds.level_up:play()
end

function SoundManager:playGhostSpreadAttackSound()
    play_sound(self.sounds.ghost_spread_attack)
end

function SoundManager:playGhostHitSound()
    self.sounds.ghost_hit:play()
end

function SoundManager:playMissileDieSound()
    self.sounds.missile_die:play()
end
