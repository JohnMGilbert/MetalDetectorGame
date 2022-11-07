pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--logo for metal game

function _init()
    tw = 0
    th = 1
    sw = 0
    sh = 1
    fillw = 0
    fillh = 1
    txu = 5
    tyu = 20
    pal_iter=0

    a1=0
    a2=0
    b1=0
    b2=0

    _d = 0
    timer1={}
    timer1.timer=-1
    timer1.sw=false

    timer2={}

    timer3={}
    
end

function _draw()
    cls(1)
    sspr(8,0,32,8,5,20,tw,th)
    sspr(8,8,40,8,5,60,sw,sh)
    if _timer(timer1,.1) then
        swap_pal()
        
    end
    draw_rest()
end

function swap_pal()
    pal_iter += 1
    if pal_iter >3 then pal_iter = 0 end
    if pal_iter == 0 then
        pal()
        pal(9,9+128,1)
    elseif pal_iter == 1 then
        pal()
        pal(9,10+128,1)
        
    elseif pal_iter == 2 then
        pal()
        pal(9,10,1)
    elseif pal_iter == 3 then
        pal()
    end

end

function _timer(obj,c)

	
	if obj.timer==-1 then
		obj.timer=time()	
		return false
	end
	
	if obj.timer+c < time() then
		obj.timer=-1
		obj.sw = not sw
		_d+=1
		return true
	end
	return false
end

function draw_rest()
    sspr(8,0,32,8,5,20,a1,1)
    sspr(8,8,40,8,15,56,a2,1)
    sspr(8,8,40,8,5,60,b1,1)
    sspr(8,8,40,8,5,96,b2,1)
    a1+=1
    a2+=1
    b1+=1
    b2+=1
end

function logo_anim()
    
        if (tw < 60) then
            tw += 1
            sw +=1
            fillw +=1
            
            if (th < 20) then
                -- tw += .5
                th += .01
                -- sw +=.5
                sh+=.01
                -- fillw += 1
            end
        end
        if (tw < 120) and (tw > 59) then
            tw += 2
            sw +=2
            th +=1.2
            sh+= 1.2
            fillw +=1
        end
end

function _update60()
    logo_anim(1)
    -- logo_anim(1)
    -- logo_anim(2)
end


__gfx__
00000000099999900999999009990090090000900000000000000220200220000002002220000000000000000000000000000000000000000000000000000000
00000000099999900999999009999090099009900000000000002200222220222222222022200000000000000000000000000000000000000000000000000000
00700700099999900990099009999990099999900000000000002000022022202222200022220000000000000000000000000000000000000000000000000000
00077000000990000900009009999990099999900000000002222000002222000000220000022000000000000000000000000000000000000000000000000000
00077000000990000900009009999990009999000000000000000020000200000000200000002200000000000000000000000000000000000000000000000000
00700700000990000990099009999990000990000000000000002200000000000002200000000220000000000000000000000000000000000000000000000000
00000000000990000999999009099990000990000000000000222000000000000222000000000020000000000000000000000000000000000000000000000000
00000000000990000999999009009990000990000000000002222220000000202200000000000002000000000000000000000000000000000000000000000000
00000000099999900999999009999990099999900990999000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099999900999999009999990099999900990999000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099000000900009009099090999999900990999000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099999900999999000099000999900000999999000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099999900999999000099000999900000999909000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099900900000009099090999999900000009000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999900900000009999990099999900999999000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999900900000009999990099999900999999000000000000000000000000000000000000000000000000000000000000000000000000000000000
