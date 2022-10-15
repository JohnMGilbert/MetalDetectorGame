pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--init




--poke(0x5f5f,0x10)

palt(11,true)

pal(0,128,1)
--1 stays same
--2 stays same
--3 open
--4 stays same
--5 stays same
--6 stays same
--7 stays same

pal(13,6+128,1)
palt(0,false)


debug = false
onObject = false
draw_drummer = false
draw_bass = false
draw_guitar = false

pane1=0


pane2=0
pane3=0
pane4=0


dhx = 0
dhy = 0

dig_cursor ={}
dig_cursor.x = dhx
dig_cursor.y = dhy
initDig = true

k_arrow_speed = .5
initArrow=true
arrow={}
arrow.x = 0
arrow.y=0
arrow.spd=k_arrow_speed
-- settings
-- player
spd=.7 -- Speed
digging = false
-- misc
tran_spd=0.1 -- how fast screen moves

-- game states
listen = false
acting=false

txt={}
txt.timer=-1
txt.t=""
_d=0

map_tile = 0
flag_tile = 0

mx,my=0,0
cx,cy=0,0


_time=time()

--det light
light ={}
light.timer=-1
light.interval = 1
light.sw=false

dflag=true
--detgt = time()
function _init()
	
   scene="menu"
   x=64
   y=64
end


-->8
--update
function _update60()
	
	--_draw()
	
	move_pl()
	update_map()
	--update_camera()
 --camera(pl.x-64,pl.y-64)
end

-->8
--draw
function _draw()

	cls(0)
	
	update_camera()


	

	map(0, 0, 0, 0, 128, 32)

	spr(pl.head,pl.x,pl.y-8,1,1,pl.mrr)

	draw_stuff1()
	drawplayer()
-- draw_stuff2()
	if digging then dig_hud() end
	
 -- Temp stuff
 if draw_drummer then  drawdm() end
 if draw_bass then drawba() end
 if draw_guitar then drawgu() end

 if debug then
	print("map tile: "..map_tile,5,11)
	print("flag_tile: "..flag_tile,5,17)
	if onObject then print("ITEM FOUND!",5,24) end
 end
end

function draw_stuff1()
	sspr(0,16,16,8,30,20)
	spr(58,90,95)
end


function dig_hud()
	dhx = pl.x-50
	dhy = pl.y-50
	if initDig then
		dig_cursor.x = dhx+3
		dig_cursor.y = dhy+3
		initDig = false
	end
	-- 72 for corner, 88 for regular

	
	-- corners can be put in a loop TODO

	for i=1,4 do
		spr(73,dhx+8*i,dhy)
		spr(73,dhx+8*i,dhy+8*5,1,1,false,true)
		rotate(73,2,dhx+8*5,dhy+8*i)
		rotate(73,1,dhx,dhy+8*i)
	end
	spr(72,dhx,dhy)
	spr(72,dhx,dhy+8*5,1,1,false,true)
	spr(72,dhx+8*5,dhy,1,1,true,false)
	spr(72,dhx+8*5,dhy+8*5,1,1,true,true)
	rectfill(dhx+1,dhy+1,dhx+8*5,dhy+8*5,8)


	draw_dig_field(pane1,dhx+3,dhy+3)
	draw_dig_field(pane2,dhx+3+19,dhy+3)
	draw_dig_field(pane3,dhx+3,dhy+3+19)
	draw_dig_field(pane4,dhx+3+19,dhy+3+19)
	-- barrier drawn, start populatie 4 fields
	
	if btn(4) then
		sspr(32,32,16,8,dig_cursor.x,dig_cursor.y)
		spr(84,dig_cursor.x,dig_cursor.y+8)
		spr(83,dig_cursor.x+8,dig_cursor.y+8)
		dig_bar()

	else sspr(16,32,16,16,dig_cursor.x,dig_cursor.y)
	end

	sspr(48,32,16,8,pl.x-20,pl.y+1)
	sspr(48,32,16,8,pl.x-36,pl.y+1,16,8,true)
	
	arrow_ctrl(pl.x-38,pl.y-3)
	

	-- draw 4 quadrants
	--draw_digging()

end

-- 86, 87
function dig_bar()
	sspr(48,32,16,8,pl.x-20,pl.y+1)
	sspr(48,32,16,8,pl.x-36,pl.y+1,16,8,true)
	-- spr(70,pl.x-20,pl.y+2)
	-- spr(71,pl.x-32,pl.y+2)
end

function arrow_ctrl(left,top)
	if initArrow then 
		arrow.x=left
		arrow.y = top
		initArrow = false
	end
	if (arrow.x > left+28) or (arrow.x < left-2) then
		arrow.spd = arrow.spd*-1
	end
	if not btn(4) then
	arrow.x += arrow.spd
	
	end
	spr(85,arrow.x,arrow.y)

end

--def: 65, 82.mirror, 81,82
function draw_dig_field(type,qx,qy)
	if type == 0 then
		spr(80,qx,qy)
		spr(80,qx+8,qy,1,1,true,true)
		spr(80,qx,qy+8)
		spr(80,qx+8,qy+8)
	end
end

--move this function TODO
	function rotate(sprite,mode,dx,dy,w,h)
		local sx=sprite%16*8
		local sy=flr(sprite/16)*8
		w,h=w or 1,h or 1
		w,h=w*8-1,h*8-1
		local ya,yb,xa,xb=0,1,0,1
		if mode==0 then
		 ya,yb=h,-1
		elseif mode==1 then
		 xa,xb=w,-1
		elseif mode==2 then
		 ya,yb,xa,xb=h,-1,w,-1
		end
		for y=0,h do
		 for x=0,w do
		  pset((y-ya)*yb+dx,(x-xa)*xb+dy,sget(x+sx,y+sy))
		 end
		end
	   end


function hud() --testing dia
	top = cy+112
	bot = cy+128
	-- temp
	
	rectfill(cx,top,cx+128,bot,5)
	rect(cx,top,cx+127,bot-1,6)

	if onObject then
		start_dig()
	end

	-- det light TODO: link with timer
	if timer(light,light.interval,light.sw) then
		rectfill(cx+10,top-2,cx+13,top-1,8)
	else
		rectfill(cx+10,top-2,cx+13,top-1,134 / -10)
	end

	-- signal
	
	rectfill(cx+2,top+2,cx+40,bot-3,3)
	line(cx+3,top+3,cx+38,bot-5, 13)

	if listen then 
		-- transition to dialog box
		rect(cx+1,cy+80,cx+126,cy+126,14)
	end

end

dig_bary=cy+128

function start_dig()
	if dig_bary > cy+16 then
		dig_bary -= 5
		print(dig_bary,cx,cy,0)
	else
		dig_bary = cy+16
	end
	rectfill(cx+104,dig_bary,cx+125,cy+112,2)
	rect(cx+104,dig_bary,cx+125,cy+112,6)
	
end

function stop_dig()
	if dig_bary < cy+16 then
		dig_bary += 5
		
	else
		dig_bary = cy+128
	end
	rectfill(cx+104,dig_bary,cx+125,cy+112,2)
	rect(cx+104,dig_bary,cx+125,cy+112,6)
end

function dia(str)
	-- short anim for popup
	-- if player in lower half of screen, draw dialogue in upper half.	
end




 



-->8
--player

--player variables
pl={}
pl.x=50--start pos
pl.y=50--start pos
pl.head=1
pl.bod=2
pl.det=0
pl.dir=false
pl.mvg=false
pl.mrr=false
pl.search=false
pl.cdir=false
pl.srch=false
pl.w=16
pl.h=16
pl.dx=0
pl.dy=0

det={}
det.x=pl.x-8
det.y=pl.y
det.spr=0
det.et=time()
det.incycle=false
det.timer=-1
det.sw=false

t1 = -1

function move_pl()
  
  map_tile = mget(flr(pl.x/8),flr(pl.y/8))
  flag_tile=fget(map_tile)
  t=pl.mrr
  pl.dx=0
  pl.dy=0
  if digging then 
	dig_hud() 
	dig_nav() 
end

  if btn(4) and not digging then
  	pl.srch=true
  	pl.mvg=false


	if btn(5) then
		
		digging=true
		pl.srch=false
	end

	elseif digging then
		-- dig_hud()
		pl.srch=false
		if btn(5) and not btn(4) then 
			digging = false
			initDig = true
		 end
	
  else pl.srch=false 

	if btn(5) then
		if onObject then
			start_dig()
		else
			stop_dig()
			act()
		end
		pl.mvg=false

	
	elseif btn(0) then	
		pl.dx = -1*spd
		pl.mrr=false
	
	elseif btn(1) then
		pl.dx = 1*spd
		if (pl.mrr==false) then 
			pl.cdir=false
		end
		pl.mrr=true
		
	elseif btn(2) then
		pl.dy = -1*spd

	elseif btn(3) then
		pl.dy = 1*spd
	end
end

  if hit(pl.x+pl.dx,pl.y,7,7) then
	pl.dx=0
  end

  if hit(pl.x,pl.y+pl.dy,7,7) then
	pl.dy=0
  end

  if pl.dx == 0 and pl.dy == 0 then 
	pl.mvg = false
  else pl.mvg = true end
  
  pl.x+=pl.dx
  pl.y+=pl.dy
  if pl.srch then 
	mvdet(5,3)
	_searching()
  else
	retdet()
  end

  
  
  if pl.mrr != t then
  	if pl.mrr then
  	 det.x=pl.x+8
  	else 
  			det.x=pl.x-8
  	end
  end



end

function act()
 if dstf(pl,ba) < 55 then
  baact()
 end

end


function anim_pl()
	if (pl.mvg) then
		if(pl.bod==2) then
			pl.bod=3
	 elseif(pl.bod==3) then
			pl.bod=4
		elseif(pl.bod==4) then
			pl.bod=2
		end
 	else
			pl.bod=2
	end
end
		
function mvdet(spd,rad)
		i=1
		j=1
		if pl.mrr then
			if dst(pl.x,det.x-2) > rad then
					i=-1				
			end
		else 
		 if dst(pl.x,det.x+10) > rad then
				i=-1
		end
end
  if timer(det,.3,det.sw) then
	det.x+=i*rad
	sfx(0,1)
	end 
end

-- returns metal detector to player.
function retdet()
 det.y=pl.y
 if pl.mrr then det.x=pl.x+8
 else det.x=pl.x-8
 end
end

function _searching()
	if (fget(mget(flr(pl.x/8),flr(pl.y/8)))) == 1 then
		onObject=true
	else onObject=false end
end

function hit(x,y,w,h)
	collide=false
	for i=x,x+w,w do
		if fget(mget(i/8,y/8)) ==2 or
			fget(mget(i/8,(y+h)/8))==2 then
				collide=true
		end
	end
	return collide
end

function drawplayer()

 if(pl.mvg==true)then 
		anim(pl,2,3,3,0,0,pl.mrr)
		anim(det,0,1,3,0,0,pl.mrr)
	else
 	spr(pl.bod,pl.x,pl.y,1,1,pl.mrr)
 	spr(det.spr,det.x,pl.y,1,1,pl.mrr)
 end

end

function dig_nav()
	if btn(0) and (dig_cursor.x > dhx+5) then
		dig_cursor.x -= 19
	end
	if btn(1) and (dig_cursor.x < dhx+10) then
		dig_cursor.x += 19
	end
	if btn(3) and (dig_cursor.y < dhy+5) then
		dig_cursor.y += 19
	end
	if btn(2) and (dig_cursor.y > dhy+10) then
		dig_cursor.y -= 19
	end
end


-->8
--anim
  --object,start,#frames,speed, flip
function anim(o,sf,nf,sp,offx,offy,fl)
  if(not o.a_ct) o.a_ct=0
  if(not o.a_st) o.a_st=0

  o.a_ct+=1

  if(o.a_ct%(30/sp)==0) then
    o.a_st+=1
    if(o.a_st==nf) o.a_st=0
  end

  o.a_fr=sf+o.a_st
  spr(o.a_fr,o.x+offx,o.y+offy,1,1,fl)
end
-->8
--util

function box_hit(x1,y1,w1,h1,x2,y2,w2,h2)
	local hit=false

	local xs = w1*.5+w2*.5
	local ys = h1*.5+h2*.5
	local xd = abs((x1+(w1/2))-x2+(w2/2))
	local yd = abs((y1+(h1/2))-y2+(h2/2))

	if xd<xs and yd<ys then
		hit=true
	end
	return hit
end

--random int between l,h
function rndb(l,h) --exclusive
    return rnd(h-l)+l
end

function dst(a,b)
	return abs(a-b)
end

--return current gt with added time
function timer(obj,c,sw)

	
	if obj.timer==-1 then
		obj.timer=time()	
		return false
	end
	
	if obj.timer+c < time() then
		obj.timer=-1
		sw = not sw
		_d+=1
		return true
	end
	return false
end

function sqr(x) return x*x end

function dstf(a,b)
 return sqrt(sqr(a.x-b.x) + sqr(a.y-b.y))
 end
 
function disptxt()
 if timer(txt,3) then
  txt.t="i lost my special coin!"
 end
end
-->8
--band

--drummer
dr={}
dr.spr=8
dr.x=60
dr.y=20
dr.sc=5
dr.an=false
dr.timer=-1
dr.sw=false

function drawdm()
	 animdr()
	 spr(dr.spr+3,dr.x,dr.y+8)	 
	 spr(dr.spr+4,dr.x+8,dr.y+8)	 
	 spr(dr.spr+3,dr.x+16,dr.y+8,1,1,true)	 
end

function animdr()
  
 if timer(dr,rndb(.01,.7),dr.sw) then 
  dr.sw = not dr.sw
 end
 if dr.sw then
 	spr(dr.spr,dr.x,dr.y)
 	spr(dr.spr+1,dr.x+8,dr.y)
 	spr(dr.spr+2,dr.x+16,dr.y)
 else
 	spr(dr.spr+2,dr.x,dr.y,1,1,true)
 	spr(dr.spr+1,dr.x+8,dr.y,1,1,true)
  spr(dr.spr,dr.x+16,dr.y,1,1,true)
 end
end
	
--bass
ba={}
ba.spr=16
ba.x=80
ba.y=80
ba.sc=5
ba.an=true
ba.timer=-1
ba.sw=false
ba.w = 8
ba.h=16

function drawba()
	animba()
	spr(ba.spr,ba.x,ba.y) -- head
	spr(ba.spr+1,ba.x+8,ba.y)
	spr(ba.spr+6,ba.x,ba.y+16)--bass body
 spr(ba.spr+7,ba.x+8,ba.y+16)

end
	
function animba()
  anim(ba,18,2,1,0,8,false)
  anim(ba,20,2,1,8,8,false)
end

function baact()
	disptxt()
end

--guitar
gu={}
gu.spr=24
gu.x=10
gu.y=10
gu.sc=5
gu.an=true
gu.timer=-1
gu.sw=false

function drawgu()
	animgu()
	spr(gu.spr,gu.x,gu.y) -- head
end

function animgu()
  anim(gu,25,2,.5,8,0,false)
  anim(gu,27,2,.5,0,8,false)
  anim(gu,29,2,.5,8,8,false)
end

-->8
--camera/map: finds current map quadrant
function update_map()
	mx=flr(pl.x/128)*16+1/16
	my=flr(pl.y/128)*16+1/16
end

function update_camera()
 cx_diff=mx*8-cx
 cy_diff=my*8-cy
 
 if (abs(cx_diff)<0.1) cx_diff=0
 if (abs(cy_diff)<0.1) cy_diff=0
  
 cx_diff*=tran_spd
 cy_diff*=tran_spd
 cx+=cx_diff
 cy+=cy_diff
 
 camera(cx,cy)
end

function rrectfill(x0, y0, x1, y1, col, corners)
	local tl = corners and corners.tl
	local tr = corners and corners.tr
	local bl = corners and corners.bl
	local br = corners and corners.br
  
	local new_x0 = x0 + max(tl, bl)
	local new_y0 = y0 + max(tl, tr)
	local new_x1 = x1 - max(tr, br)
	local new_y1 = y1 - max(bl, br)
  
	rectfill(new_x0, new_y0, new_x1, new_y1, col)
  
	if tl and tl>0 then
	  circfill(new_x0, new_y0, tl, col)
	end
	if tr and tr>0 then
	  circfill(new_x1, new_y0, tr, col)
	end
	if bl and bl>0 then
	  circfill(new_x0, new_y1, bl, col)
	end
	if br and br>0 then
	  circfill(new_x1, new_y1, br, col)
	end
  
	-- draw top rect
	rectfill(new_x0, y0, new_x1, new_y0, col)
  
	-- draw left rect
	rectfill(x0, new_y0, new_x0, new_y1, col)
  
	-- draw right rect
	rectfill(new_x1, new_y0, x1, new_y1, col)
  
	-- draw bottom rect
	rectfill(new_x0, new_y1, new_x1, y1, col)
  end

__gfx__
bbbbbbbbbbbddbbbbb111ff1bb111111bb111ff1bb1111bbbbbbbbbbbbbbbbbbbbbbbbbbb666662bb122221bbbbbbbbbbbbbbb1b2214445622144456555bbbbb
bbbbbddbbbd11dbbb1111eefb1111ff1b1111eefb111111bbbbbbbbbbbbbbbbbbbbbbbbbb2222221b621126bb1111b1bb11111bb2214ff5522144555fff5bbbb
bbbbffbbbd1111db1111111bb1111eef1111111bbff11ffbbbbbbbbbbbffffbbbbbbbbbbb222662122166122111ff11b111ffbbb222eef542224ff54ff1f5bbb
bbbbeef1dd1171ddbb11111b1b11111bbb11111bb1e11e1b99b9bbbbb1fff1fbb4bb9bbbbb662261216666121fffffbb1fff1fbbb222444db22eef4d1fff5bbb
bbbbdbbbbd1e11dbbb1bbb1bbbb111bbbbbb111bb555555bbb99b4bbbe1f1efbb4999999bb2222bb21666612e11f11fb1f1fe1fbb55111ddb55111ddfffebbbb
bbbdbbbbbbeeffbbbb11bb11bbb1155bbbb11b1155111155b1bb994bbeeefffbffbbbb1bbbbbb1bb22166122eeefeefbe1effffbb55511dbb55511dbeee1bbbb
b6ddd6bbbbbbefbbbbb5bbb5bbbb5b5bbbb5bbb5b5b66b5b1bbbbbffbbeeefbbebbbbbb1bbbbbb1bb621126bbeee1ffbbeee1ffbb5bb51bbb5bb51bbff111bbb
66666bbbbbb1111bb555b555bb555b5bb555b555ee6bb6ef1bbb666ebb1111bbb666bbb1bbbbb1111b2222b122eeef2b22eeef44b5bb5dddb5bb5dddeee11bbb
bb11bbbbbbbbbbbbbbb22bbbbbb222bbbb11bbbbb415414bbbbb5bbbbbb22bbbbbbe5fbbbbb22bbb221221febbbbbbbbbbbbbbbb422bbbbb88888bbb11111bbb
b1111bbbbbbbbbbbbbb222bbbbb244bbb1111bbbb145441bbbbe5fbbbb2222bbbbb5522bbb2222bb22122fe2bbbbbbbbbbbbbbbb41bbbbbb88888bbb1111bbbb
bb11111bbbbbbbbbbb2222bbbbb444bbbb11111b44454444bbb5422bbb2222bbbbb54b22bb2222bb22221222bbbbbbbbbbbbbbbb411bbbbb18888bbb2222bbbb
bbbbb11ffbbbbbbbbb22222bbbb444bbbbbbb11f44466444bb454422b2b2222bbb4544b222b2222bbeff2221bbbb14bbbbbb14bb11bbbbbb18888bbb2222bbbb
bbbbbbee1fbbbbbbbff2222bbbb44bbbbbb41bee44444444b44454422bb2222bb444544bbb22222bb1111d11bbb641bbbbb641bbbbbbbbbbb8888bbbbb22bbbb
bbbbbb1eeefbbbbbbe22222bbbb44bbbbb144b1eb445544bb444544bbb22222bb444544b222b222bb511dd1bbbf6bbbbbbffbbbbbbbbbbbbb8888bbbbbb2bbbb
bbbbbbbeeeefbbbbbbf2222bbbb44bbbbbbb5bbebb4554bbbb4454ff2222222bbb44ff22bbb2222bb5b1d5bbbeebbbbbb6e2bbbbbbbbbbbbbbb0bbbbbbb0bbbb
bbbbbbbbbbbe2bbbbee222bbddd555ddbbbb5bbbbbbb5bbbbb154eebbbb222bbbb1ee1bbbbb222bbb5bddddb662bbbbb6622bbbbbbbbbbbbbbb00bbbbbb00bbb
b2f1fbbbbbbbbbbbbbbbbbbbbbb55bbbbb1441bbbbbbbbbbbbbbb14bbbbb9bbbbbb222bbbb1441bbb9bbbb9bbb88bbbb9bbb9bbbbbbbbbbbbbbbbbbbbbbbbbbb
2fffffbbbbbbbbbbbbbbbbbbfff55bbbbbb44bbbbbbbbbbbbbbb1442bb99999bb266662bbbb66bbb999bb999b87888bb9b9b9499b99999bbbbbbbbbbbbbbbbbb
2f1ffffbbbbbbbbbbbbbbbbff1fffbbbbb1221bbbbbbbbbbbbbb4421b999999926666662bb4664bb1bbbbbb18787878b4b9b4bbbb97799bbbbbbbbbbbbbbbbbb
2ffff1fbbbbbbbbbbbbbbbfffe1fffbbbbb66bbbbbbbbbbbbbbb521bbb99999b12666621b446644b16bbbb612255788bbb4bb499b99999bbbbbbbbbbbbbbbbbb
feffffef11bbffbbbbbbbff1ffffffbbbbb66bbbbbbbbbb44445bbbbbb99111116222261b245542b62122126bb5222bb9bbb9bbbbbb99799bbbbbbbbbbbbbbbb
bfefeeff111fbbfbbbbb2f1ffff1fbbbbbb66bbbbbbbbb444454bbbb9999999b1266662b4444444426266262bb55bbbb9b9b9499bbb97999bbbbbbbbbbbbbbbb
bfefffff111bbbefbbb22ee1ff1e55bbbbb66bbbbbbbbb444544bbbbb99999991122221124444442b126621bbbb55bbb4b9b4bbbbbb99999bbbbbbbbbbbbbbbb
bfeefeff111ffffebb2212eeeeeb55bbbb4664bbbb4414145444bbbbb111199bbb11111bb222222b1b1221b1bbb11bbbbb4bb499bbbbbbbbbbbbbbbbbbbbbbbb
bb6666bbbbb8bbbbbb221ff2bbbbbbbbb446644bb44441454444bbbbbb2222bbbbbbb4bbbb1441bbebbbbbbebbbbbbbbbbbbb66bbbbbdd6dbbbbbbbbbbbbbbbb
b888888bbb8bb8bbb2211efebbbbbbbbb446644bb44444541442bbbbb611116bb264464bbb2552bb4ebbbbe4bbbb66bbb66bbd6bbbbd7d16bbbbbbbbbbbbbbbb
b888888bbb8b8bbbb22112eebbbbbbbfb240042bb4444541422bbbbb2166661226464462b445444beb0bb0bebbbbd6bbbd66dbbbbbd7771dbbbbbbbbbbbbbbbb
b887777bb8b8bbb8b2222222bbbbbbffb445544bb44654441bbbbbbb2166661212646621b214512bbebeebebbbddb99bbbbd666bbd78c77dbbbbbbbbbbbbbbbb
b777787bb8b8b88bb111111bbbbbbf1f44444444b44464444bbbbbbb2611116216222261b144541bbbeeeebbbb9db99bb6dbbd6bd77987dbbbbbbbbbbbbbbbbb
b888888b8b8b8bbbbb1111bbbbbb2ff124444442b55444442bbbbbbb1d2222d1b266662144666644bbb44bbbb9bbbb9bbd6b6dbbd1777dbbbbbbbbbbbbbbbbbb
b222288bb8b8bb88bbb11bbbbbb22e1eb244442bb5522222bbbbbbbb111111111122221124555542be4bb4ebbbbbb99bbb66d6bb6117dbbbbbbbbbbbbbbbbbbb
bb6666bbbb8b88bbb555555bbb2212eebb2222bb5bbbbbbbbbbbbbbbb1dddd1bb11111bbb222522bbebbbbebbbbbbbbbbbddbbbbd6ddbbbbbbbbbbbbbbbbbbbb
ddddddddd05dddddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdddddddddddddddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
ddddddd7d05dddddbbbbb0000bbbbbbbbbbbbbbbbbbbbbbb000000000000000bd777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
ddddddd77d05ddddbbb00f0ef0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0d777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
ddd7dd777d05ddddbb0f0ef0ef0bbbbbbbbbbb00000bbbbbbbbbbbbbbbbbbbb0d777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
ddddd77777d055ddbb0ef0ef0ef0bbbbbbbb00ef0ef0bbbbbbbbbbbbbbbbbbb0d777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
dddd777d775d0055b0f0ef0ef0ef0bbbbbb0ef0ef0ef0bbbbbbbbbbbbbbbbbb0d777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
ddd7777d7575dd00b0ef0ef0effff0bbbbb00ef0effff0bb000000000000000bd777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
d77777dd777777ddbb0ef0effffff0bbbb0ef0effffff0bbbbbbbbbbbbbbbbbbd777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
777777dd7d55d5d7bbb0effffffff0bbbb00efffbbbbbbbbbbbbbbbbbbbbbbbbd770000000000000000007ddb000000000000000555555555555555555d55555
7777ddddd500005dbb0f0efffffff0bbbbb00effbbbbbbbbbbbbbbbbbbbbbbbbdd00555555005055555500d7055d55555555d55d555555555555555555d55555
77dddddd50055005bb0ef0effffff0bbbbb0f0efbbbbbbbbbbbbbbbbbbbbbbbb7005555555505555d55050070dd5555555dd5555555555555555555555d55555
dddddd7d505dd50dbbb0eeeefffff0bbbbb0eeeeb0000000bbbbbbbbbbbbbbbb0055555555555555055555000555d55ddd55555d555555555555555555d55555
ddddddddd0d77d05bbbb000eeeee0bbbbbbb000ebb07770bbbbbbbbbbbbbbbbb05055dd5ddd55ddd55d55550055d55d5555555d5555555555555555555d55555
dddddddd50555505bbbbbbb00000bbbbbbbbbbb0bbb070bbbbbbbbbbbbbbbbbb0555dd5dd55dd55ddd5d55500ddddddddddddddd55555ddddddddddd55d55555
dddd7dddd500005dbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbbbbbbbbbbbbbbb0555d55555555555555dd550b00000000000000055555d555555555555d55555
ddd777dd775d55d7bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb055d5555555555555555dd50bb00bbbbbbb00bbb55555d555555555555d55555
dddd777777777d7dd77777ddddddddddd7ddddddd777777d5555555555555555055d5555ddd777775555d550dddddddddddddddd55555d555555555500000000
ddd77777777777dd5ddddd555ddddd557d5ddd555dddd5d7550d555555555555055d5d05dd7d777750d5d550dddddddddddddddd55555d555d5fd5fd88888880
dd777777777777ddc55555ccc55555ccd5c555ccc5555c5d5555555555d55505005d5555d7d777775555d500dddddddddddddddd55555d555d5fd5fd22888780
d7d7777777777dddcccc77777cccccccd5cc77777ccccc5d5555d55ddddd55d50005d555dd7d7777555d50005dddddddddddddd555555d555d5fd5fd28888880
7777777777777ddd77777ccc77ccccc7d5777ccc77cccc5d555d5dd55555d5550055d555d7d77777555d5500ddddd5dddddddddd55555d555d5fd5fd88878880
777777777777dddd77ccccccc7777777d5ccccccc777775d55dd5555505d5555055dd555dd7d7777555dd550fffff55fffffffff55555d555d5fd5fd88788880
d77777777777ddd7cc7ccccccccc7ccc7d5ccccccccc75d7555d5050055d555505dd5555ddd7d7775555dd50555555555555555555555d555d5fd5fd78888280
77777777777dddd7cccc7ccccccccccc7d5c7cccccccc5d7555d55000055d55505d5555555557d7755555d50dddddddddddddddd55555d555d5fd5fd87882280
77777777777dddd7ccccccccccccccccd5cccccccccccc5d555d55000055d55505dd55555555555555555d50dddddddddddddddd55d555555555555587822280
7777777777dddd77cc777777ccc7cccc7d577777ccc7c5d75555d5500505d555055dd5555555555550555d50dddddddddddddddd55d555555555555587822280
777777777dddd7d7777c77777ccccccc7d5c77777cccc5d75555d5055555dd550555d5ddd55dd55d555dd550ddd55ddddddddddd55d55555dddddddd87822280
7777777dddddd77777c7ccc777c777777d57ccc777c775d7555d55555dd5d55505555d55ddd55dddddd55050dddddddddddddddd55d555555555555587822280
77777ddddddd7777ccccc7cc7777c77c7d5cc7cc7777c5d75d55ddddd55d555500555550555555555d555500dddddddddddddddd55d555555555555587822280
777ddddddd777777ccccccccccc77ccc7d5cccccccc775d750555d55555555557005055d5550555555555007ffffffffff555fff55dddddd5555555587822280
7dddddddd777777dcc7cccccccccccccd5cccccccccccc5d555555555555d0557d00555555005055555500dd5555555555555555555555555555555587822280
dddddd7777777777ccccccccccccccccd5cccccccccccc5d5555555555555555dd700000000000000000077dddddddd55ddddddd555555555555555587822280
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
__gff__
0000000000000000000000000100000000000000000001000000000000000000020000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000002020200000000000000020202020202020202000000000200000000000000000202020000000002
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
6679797979797979797979797979797900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a60616061606160616061606160616000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a70717071707170717071707170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a60616061606160616061606160616000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a6f717071707170717071707170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a7f6d6061606160616061606160616000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a7f6e7071707170717071707170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a7f6e6061606160616061606160616000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a7f6d7071707170717071707170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
686f616061606160616061606160616000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7a70717071707170717071707170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6362636263626362636265606160616062000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7372737273727372737375707170717072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6373737373737373737373626362636263646364000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020202020202020200020202000200020000020002000200020000020002000202020202020
7373737373737373737373737373737373747374000000000000000000000000000000000000000000000000000000202000000000000000000000000000002020202020202020202020202020202020202020202020202020202020202020002000202020002020002020202020202020202020202020202020202020202020
6573737373737373737373737373737366202020202020202020202000200020200020200020002000200020002020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
7576737576757675767576757675767576000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
6566656665666566656665666566000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
7576757675767576757675767576000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000000000000004141434141414141414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000000000000414141414141414141414141414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000000000000000041414141434141434141414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000000000000000041414141414141414141410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000000000000000000004141414141414141000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000000000000000000000000414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0061626162616261626162616261620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0071727172717271727172717271720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000066760000616261620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0000620000000076000000717271720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
6566656620202020202020200061620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
__sfx__
000a0000205002d75027750225001e500060003370009700097000970009700097000870008700087000870008700087000870007700067000470002700007000000000000000000000000000000000000000000
001000000705009050060000b0500c050070000505003050070000700007000080500b050100501d3000710006100061000510005100051000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002405000000000000000000000000000000023050000000000030050260503005030050300500000030050300501a0501a0501f0502505032050000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021050000000000000000
__music__
04 41424344

