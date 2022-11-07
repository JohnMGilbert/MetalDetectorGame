pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--init


debugvar = 0
dgenx=0
dgeny=0

in_rest = true
outside = true
rx = 0
ry = 384

btn5={}
btn5.timer=-1
btn5.sw=true

this=false
debug1 = false
pdebug = ""
debug_q1={0,0}
stopadding=false
debug = false
onObject = false
-- draw_drummer = true
-- draw_bass = false
-- draw_guitar = false

tranbool=false
transition={}
transition.timer=-1
transition.sw=true

pa1={}
pa1.val=0
pa1.sel=true
pa1.rew=76
pa1.done=false
pa1.coords={}

pa2={}
pa2.val=0
pa2.sel=false
pa2.rew=76
pa2.done=false
pa2.coords={}

pa3={}
pa3.val=0
pa3.sel=false
pa3.rew=76
pa3.done=false
pa3.coords={}

pa4={}
pa4.val=0
pa4.sel=false
pa4.rew=76
pa4.done=false
pa4.coords={}

found_main = false
m_items={}
m_items.type = nil
m_items.coords = {nil,nil}
m_items.spr = nil
-- m_items.gu1 = {}
-- m_items.gu1.coords = {43,2}
-- m_items.gu1.spr = 36
-- m_items.gu2 = {}
-- m_items.gu2.coords={nil,nil}
-- m_items.gu2.spr = 52

testbarmid = 0

-- dialogue box
init_dia = true
dia_iter = 1
dia_cursor_off=0

do_waves=true

mounds={}

dhx = 0
dhy = 0

dig_cursor ={}
dig_cursor.x = dhx
dig_cursor.y = dhy
initDig = true

dig_nav_l = true
dig_nav_t = true

k_arrow_speed = 1
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

hitboxes={}
hitboxes.x = -8
hitboxes.y = -8

txt={}
txt.timer=-1
txt.sw=false
txt.line1=""
txt.line2=""
txt.line3=""
txt.option1="sorry"
txt.option2="my bad"
txt.spd=.05
txt.opt=1

talking_to=nil

bart={}
bart.spr=34
bart.txt="welcome, need any supplies? i'm only accepting licorice at the moment but i suppose anything is can be used as currency."
bart.x=rx+18
bart.y=ry+20
bart.vo=2


_d=0

map_tile = 0
flag_tile = 0

mx,my=0,0
cx,cy=0,0

ix=cx+128
show_inv=false

npcs = {}

gen_npcs={}
gen_npcs.dia={}
gen_npcs.dia[1] = "i might just skip town."
gen_npcs.dia[2] = "i'm just sitting here."
gen_npcs.dia[3] = "i want to visit hawaii."


_time=time()

--det light
light ={}
light.timer=-1
light.interval = 1
light.sw=false

stam={}
stam.val=1
stam.timer=-1

dflag=true
--detgt = time()
function _init()
	main_pal()
   scene="menu"
   x=64
   y=64
   add(npcs, gu)
   add(npcs, ba)
   add(npcs, dr)
   add(npcs,bart)
--    add(npcs, bart)
	add(npcs, lounger)
	_add_npc_gen(20,20)
	-- _add_npc_gen(20,20)
	-- guitar parts
	add(m_items, {
		type = 36,
		coords = {6,6},
		spr = 36
	})
	add(m_items, {
		type = 52,
		coords = {74,20},
		spr = 52
	})

	-- drummer parts 
	-- cymbols
	add(m_items, {
		type = 39,
		coords = {38,2},
		spr = 39
	})
	-- drum
	add(m_items, {
		type = 55,
		coords = {4,40},
		spr = 55
	})
	-- dirty drum
	add(m_items, {
		type = 56,
		coords = {18,28},
		spr = 56
	})
	-- add(m_items, {
	-- 	type = 36,
	-- 	coords = {6,6},
	-- 	spr = 36
	-- })
	-- add(m_items, {
	-- 	type = 36,
	-- 	coords = {6,6},
	-- 	spr = 36
	-- })

--    music(0)
end

function main_pal()
	pal()
	
	pal(3,0+128,1)
	pal(11,6+128,1)
	pal(10,5+128,1)
	pal(14,15+128,1)
end

-->8
--update
function _update60()
	if btnp(3,1) then debug = not debug end
	
	if count(mounds) > 30 then
		
			deli(mounds,1)
		
	end
	update_pl()
	update_map()
	if do_waves then 
		-- sfx(0) 
		do_waves=false
	end

	if on_tile() == 5 then
		debug1 = true
	end
end


function fade_to_black()
	pal()
	palt(0,false)
	rectfill(cx,cy,cx+128,cy+128,0)
end

-->8
--draw
function _draw()
	cls(0)
	update_camera()
	if tranbool == true then
		fade_to_black()
		if timer(transition,1,transition.sw) then tranbool = false end
		
	else 
		map(0, 0, 0, 0, 128, 128)

		_draw_rest()
		draw_mounds()
		draw_flipped()
		draw_stuff1()
		-- spr(pl.head,pl.x,pl.y-8,1,1,pl.mrr)
		drawplayer()
		main_pal()
	-- draw_stuff2()
		if digging then dig_hud() end
		hud()

		if btnp(4,1) then show_inv = not show_inv end
		draw_invent(show_inv) 
		
		
		for n in all(gen_npcs) do
			n:draw()

		end
	-- Temp stuff
		
		
		if debug then
			rect(pl.x-4,pl.y-8,pl.x+12,pl.y+8,9)
			print("debug on",52,4,8)
			print("tile x,y: "..(flr(pl.x)).." "..(flr(pl.y)),cx+10,cy+10,9)
			print("Gen: "..dgenx.." "..dgeny,1)
			if digging then 
				print("dig coords x:"..debug_q1[1].." y:"..debug_q1[2],cx+40,cy+120)
			end
			
			pset(pl.x,pl.y,8)
			if not stopadding then
				pl.inv[1]+=1
				pl.inv[2]+=1
				pl.inv[3]+=1
				pl.inv[4]+=1
				pl.inv[5]+=1
				pl.inv[6]+=1
				
				stopadding=true
			end
			print("curr slot: "..pl.curr_slot,cx,cy)
			print(debugvar)
			if this then print("do dialogue done",cx,cy+10) end
			
		end
	end

 --dialogue stuff
	if pl.engaging then do_dialogue(pl.talking_to) end

end

function oven_spr(ox,oy)
	rectfill(ox+1,oy+3,ox+7,oy+7,7)
	line(ox+1,oy+6,ox+7,oy+6,13)
	rect(ox,oy+2,ox+8,oy+7,0)
	line(ox+1,oy,ox+7,oy,0)
	pset(ox,oy+1,0)
	pset(ox+8,oy+1,0)
	line(ox+1,oy+1,ox+7,oy+1,13)
	line(ox+5,oy+4,ox+6,oy+4,0)
end

function _draw_rest()
	
	draw_dm()
	drawba()
	drawgu()
	draw_bart()
	for i=0,2 do
		oven_spr(rx+8+i*8,ry+8)
	end
	

	--corners
	spr(125,rx,ry,1,1,false,true)
	spr(125,rx+120,ry,1,1,true,true)
	spr(125,rx+120,ry+120,1,1,true,false)

	--tables
	
	for i=0,1 do
		spr(91,rx+30+i*40,ry+100,2,1)
		spr(91,rx+46+i*40,ry+100,2,1,true,false)
	end

	for i=0,1 do
		spr(91,rx+30+i*40,ry+80,2,1)
		spr(91,rx+46+i*40,ry+80,2,1,true,false)
	end
	



	spr(91,rx+30,ry+100,2,1)
	spr(91,rx+46,ry+100,2,1,true,false)
	-- bar
	spr(91,rx+16,ry+28,2,1,true)
	spr(92,rx+8,ry+28)
	-- rotate(sprite,mode,dx,dy,w,h)
	rotate(91,2,rx+32,ry+24,1,1)
	rotate(92,2,rx+32,ry+16,1,1)
	rotate(92,2,rx+32,ry+8,1,1)

	--npcs
	for n in all(gen_npcs) do
		n:draw()
	end
	


end


function _add_npc_gen(nx,ny)
	-- tx = rnd(60)+rx+10
	-- ty = rnd(60)+ry+10
	tx = rx + 40
	ty = ry+92
	add(gen_npcs,{
		x = tx,
		y = ty,
		vo=3,
		txt = gen_npcs.dia[flr(rnd(3))+1],
		-- hitbox = {}
		-- pallet={rnd()}
		draw = function(self)
			-- pal()
			-- pal(2,12)
			spr(15,self.x,self.y,1,1) -- change second 1 param to 2 for legs, below as well
			spr(15,self.x-8,self.y,1,1,true,false)
			-- main_pal()
		end
	})
	add(hitboxes, {x=tx,y=ty})
end


function draw_mounds()
	for i=1,count(mounds) do
		spr(81,mounds[i][1]+mounds[i][3],mounds[i][2]+mounds[i][3])
	end
end

function draw_stuff1()
	draw_lounger()
	spr(58,90,95)

	-- mushrooms
	spr(43,90,10)
	spr(43,94,16,1,1,true,false)

	spr(43,33*8,8)
	-- spr(43,94,16,1,1,true,false)

	
end

function draw_flipped()
	-- 1, 11
	spr(111,1*8,10*8,1,1,false,true)
	rotate(127,1,0*8,1*8)
	rotate(127,3,0*8,10*8)
	rectfill(0,16,8,8*10,8)
end

function dig_hud()
	dx_off = 0
	dy_off = 0
	if pl.mrr then
		plx=flr(pl.x/8)*8+8
	else
		plx=flr(pl.x/8)*8-8
	end
	ply=flr(pl.y/8)*8
	tile = on_tile()
	pa1.coords={plx,ply,rndb(0,3)}
	pa2.coords={plx+8,ply,rndb(0,3)}
	pa3.coords={plx,ply+8,rndb(0,3)}
	pa4.coords={plx+8,ply+8,rndb(0,3)}

	if debug then rect(plx,ply,plx+16,ply+16,8) end
	debug_q1={plx,ply}
	if pl.x < cx+50 then dx_off = 51 end
	if pl.y < cy+50 then dy_off = 48 end
	dhx = (pl.x-43) + dx_off
	dhy = (pl.y-50) + dy_off
	color = 7
	bmid= dhx+20

	--temp
	testbarmid=bmid
	if initDig then
		dig_cursor.x = dhx+3
		dig_cursor.y = dhy+3
		pa1.rew=46
		pa2.rew=46
		pa3.rew=46
		pa4.rew=46
		pa1.done=false
		pa2.done=false
		pa3.done=false
		pa4.done=false
		pa1.val=0
		pa2.val=0
		pa3.val=0
		pa4.val=0
		dig_nav_l=true
		dig_nav_t=true
		initArrow=true
		initDig = false
	end
	-- 72 for corner, 88 for regular

	
	-- corners can be put in a loop TODO
	rectfill(dhx+1,dhy+1,dhx+38,dhy+38,7)
	for i=1,4 do
		spr(75,dhx+8*i,dhy)
		spr(75,dhx+8*i,dhy+8*4+1,1,1,false,true)
		rotate(75,2,dhx+8*4+1,dhy+7*i)
		rotate(75,1,dhx,dhy+7*i)
	end
	spr(74,dhx,dhy)
	spr(74,dhx,dhy+8*4+1,1,1,false,true)
	spr(74,dhx+8*4+1,dhy,1,1,true,false)
	spr(74,dhx+8*4+1,dhy+8*4+1,1,1,true,true)

	draw_dig_field(pa1,dhx+3,dhy+3,bmid)
	draw_dig_field(pa2,dhx+3+19,dhy+3,bmid)
	draw_dig_field(pa3,dhx+3,dhy+3+19,bmid)
	draw_dig_field(pa4,dhx+3+19,dhy+3+19,bmid)

	if btn(4) and not pl.engaging then
		sspr(32,32,16,8,dig_cursor.x,dig_cursor.y)
		spr(84,dig_cursor.x,dig_cursor.y+8)
		spr(83,dig_cursor.x+8,dig_cursor.y+8)
		
	else 
		sspr(16,32,16,16,dig_cursor.x,dig_cursor.y)
	end

	dig_bar(bmid,dhy+48)

end

-- 86, 87
function dig_bar(mid,top)

	for i=4,1, -1 do
		rectfill(mid-i*3.5,top-1,mid+i*3.5,top-5,12-i)
	end
	sspr(64,32,16,8,mid,top-5)
	sspr(64,32,16,8,mid-15,top-5,16,8,true)
	arrow_ctrl(mid-17,top-10)

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

function dig_points(xval)
	points = 0
	--perfect hit
	if abs(arrow.x +3.5- xval) < 2 then
		sfx(18)
		return 2
	elseif abs(arrow.x+3.5-xval) < 5 then
		sfx(17)
		return .5
	else 
		sfx(16)
		return .1 
	end
end

function canDig()
	
end

function on_tile()
	return fget(mget(flr(pl.x/8),flr(pl.y/8)))
end

tempbol = true

--def: 65, 82.mirror, 81,82
function draw_dig_field(type,qx,qy,barmid)

	if count(mounds) > 0 then
		b1 = mounds[1][1]
		for i=1,count(mounds) do
			if (type.coords[1] == mounds[i][1]) and (type.coords[2] == mounds[i][2]) then
				type.done = true
			end
		end
	end
	if fget(mget(type.coords[1]/8,type.coords[2]/8),1) == true then
		type.val=500
	end
	
	if btn(4) then
		if type.sel == true then
			if timer(stam,.5,pl.dug) then 
				stam.val -=.01 
				type.val+=.5+dig_points(barmid)
			end
		end
	end
	if type.val < 500 then
		if (type.val >=0) and (type.val < 3) and not type.done then
			sspr(0,32,8,16,qx,qy)
			spr(80,qx+8,qy)
			spr(64,qx+8,qy+8)

			if type.val >= .7 then
				spr(70,qx,qy)
				if type.val > 1.5 then
					spr(70,qx+8,qy+8,1,1,true,true)
					spr(71,qx+8,qy)
				end
				if type.val > 1.8 then
					spr(71,qx,qy+8,1,1,true,true)
				end

			end


		else 
			spr(65,qx,qy+8)
			spr(65,qx,qy,1,1,false,true)
			spr(65,qx+8,qy,1,1,true,true)
			spr(65,qx+8,qy+8,1,1,true,false)
			boost = 5 -- TODO make global
			chance = rndb(0,10+boost)
			
			
			if not type.done then -- give rewards
				for main_item in all(m_items) do
					-- debugvar = type.coords[0]
					if (flr(type.coords[1]/8) == main_item.coords[1]) and (flr(type.coords[2]/8) == main_item.coords[2]) then
						chance = 0
						-- debugvar =  "found!"
						type.rew = main_item.spr
						_add_main_item(main_item)
						del(m_items,main_item)
						-- return
					end
				end
				if chance == 0 then
					sfx(10)
				elseif chance < .1 then -- crab
					type.rew=58
					pl.inv[6]=1
				elseif chance < .2 then  -- soda
					type.rew += 61
					pl.inv[2]+=1
				elseif chance < .5 then -- gold
					type.rew = 45
					pl.inv[5]+=1
					if not type.done then sfx(20) end
					
				elseif chance < 5 then
					if rndb(0,2) <= 1 then
						type.rew = 49
						pl.inv[1]+=1
					else type.rew = 60
						pl.inv[3] +=1
					end
				end
				
				type.done=true
				add(mounds,type.coords)
			end
			spr(type.rew,qx+4,qy+4)
			
		end
	end
	
end

function _add_main_item(it)
	if (it.spr == 36) or (it.spr == 52) then -- guitar
		add(pl.g_parts,it.spr)
	elseif (it.spr == 39) or (it.spr == 55) then -- drums
		add(pl.d_parts,it.spr)
	end
end

function check_all_boxes(x,y)
	for box in all(hitboxes) do
		if box_hit(x,y+8,1,1,box.x+3,box.y+20,14,10) then
			return true end
	end
	return false
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
	spr(72,cx+3,cy+118,2,1,true,true)
	spr(72,cx+19,cy+118,2,1,false,true)
	rectfill(cx+4,cy+121,cx+4+stam.val*29,cy+124,8)
	draw_batt()
end

function draw_batt()
	
	if pl.batt < 25 then
		batt_w = 2
	elseif pl.batt < 50 then
		batt_w = 4
	elseif pl.batt < 75 then
		batt_w = 8
	else batt_w = 10 end
	if pl.batt > 0 then rectfill(cx+3,cy+111,cx+3+batt_w,cy+117,9) end
	spr(86,cx+1,cy+111,2,1,true,false)

end

function rm_inventory()
	show_inv=false
end

function draw_invent(yes)
	--can remove the inner ifs with exact math SPACE
	
	if yes and (ix>=112) then
		ix-=2.5
		if ix < 112 then ix = 112 end
	elseif (ix<130) then 
		ix += 2.5 
		if ix > 130 then ix = 130 end
	end
	iy=cy+16
	pal()
	pal(7,2)
	pal(13,5)
	for i=0,5 do
		spr(74,cx+ix,iy+i*16)
		spr(74,cx+ix+8,iy+i*16,1,1,true)
		spr(74,cx+ix+8,iy+8+i*16,1,1,true,true)
		spr(74,cx+ix,iy+8+i*16,1,1,false,true)
	end
	main_pal()
	-- draw arrow lines 7,5,3,1,3,1
	cs = pl.curr_slot
	
	line(cx+ix-1,iy+4+16*cs,cx+ix-1,iy+11+16*cs,15)
	line(cx+ix,iy+5+16*cs,cx+ix,iy+10+16*cs,15)
	line(cx+ix+1,iy+6+16*cs,cx+ix+1,iy+9+16*cs,15)
	line(cx+ix+2,iy+7+16*cs,cx+ix+2,iy+8+16*cs,15)

	line(cx+ix,iy+6+16*cs,cx+ix,iy+9+16*cs,14)
	line(cx+ix+1,iy+7+16*cs,cx+ix+1,iy+8+16*cs,14)

	--draw inventory items
	if pl.inv[1] > 0 then
		spr(49,cx+ix+3,iy+3)
		print(pl.inv[1],cx+ix+9,iy+8,0)
	end
	if pl.inv[2] > 0 then
		spr(48,cx+ix+3,iy+19)
		print(pl.inv[2],cx+ix+9,iy+24,0)
	end
	if pl.inv[3] > 0 then
		spr(60,cx+ix+3,iy+35)
		print(pl.inv[3],cx+ix+9,iy+40,0)
	end
	if pl.inv[4] > 0 then
		spr(44,cx+ix+3,iy+51)
		print(pl.inv[4],cx+ix+9,iy+56,0)
	end
	if pl.inv[5] > 0 then
		spr(45,cx+ix+3,iy+67)
		print(pl.inv[5],cx+ix+9,iy+72,0)
	end

	if pl.inv[6] > 0 then
		spr(58,cx+ix+4,iy+84)
		print("",cx+ix+9,iy+104,0)
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

function do_dialogue(npc)
	dia_topx=cx
	dia_topy=cy+80
	if init_dia then
	   init_dia = false
	end
	rectfill(dia_topx+2,dia_topy+2,dia_topx+120,dia_topy+41,7)
	spr(74,dia_topx,dia_topy)
	spr(74,dia_topx+120,dia_topy,1,1,true)
	spr(74,dia_topx,dia_topy+40,1,1,false,true)
	spr(74,dia_topx+120,dia_topy+40,1,1,true,true)
	for i=1,14 do 
	   spr(75,dia_topx+i*8,dia_topy)
	   spr(75,dia_topx+i*8,dia_topy+40,1,1,false,true)
	end
	for i=1,4 do
	   rotate(75,1,dia_topx,dia_topy+i*8)
	   rotate(75,2,dia_topx+120,dia_topy+i*8)
	end
	dia_text(npc)
end

function dia_text(npc)
	current_words = split(npc.txt, " ")
	if timer(txt,txt.spd,txt.sw) and (dia_iter < count(current_words)+1) then
		
		if #txt.line1 < 25 then
			txt.line1=txt.line1.." "..current_words[dia_iter]
		elseif #txt.line2 < 25 then
			txt.line2=txt.line2.." "..current_words[dia_iter]
		elseif #txt.line3 < 25 then
			txt.line3=txt.line3.." "..current_words[dia_iter] 
		else
			print("sadfs")
		end
		dia_iter += 1
		sfx(npc.vo)
	end
	print(txt.line1,dia_topx+4,dia_topy+6,2)
	print(txt.line2,dia_topx+4,dia_topy+14,2)
	print(txt.line3,dia_topx+4,dia_topy+22,2)

	if count(current_words) <= dia_iter and pl.talking_to != crab then

		-- if check this
		print(txt.option1,dia_topx+14,dia_topy+33,1)
		print(txt.option2,dia_topx+60,dia_topy+33,1)
		dia_cursorx =dia_topx+9
		dia_cursory = dia_topy+34
		if btnp(1) and (dia_cursorx < dia_cursorx + 30) then 
			dia_cursor_off = 46
			txt.opt=1
		end
		if btnp(0) and (dia_cursorx > dia_cursorx - 30) then
			dia_cursor_off = 0
			txt.opt=2
		end
		if btn(4) then confirm_option(npc) end
		rectfill(dia_cursorx+dia_cursor_off,dia_cursory,dia_cursorx+2+dia_cursor_off,dia_cursory+2,2)

	end
end

-- dialogue selection confirmed, update variables.
function  confirm_option(npc)
	reset_dia()
	npc.txt="just be respectful please."

	
end

-- function nps_state
	
-- end

function reset_dia()
	txt.line1=""
	txt.line2=""
	txt.line3=""
	dia_iter=1
	init_dia=true
end



 



-->8
--player
--start pos 50,50
--player variables
pl={}
pl.x=50--start pos
pl.y=50--start pos
pl.head=1
pl.bod=2
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
pl.dug=false
pl.dug_timer=-1
pl.engaging=false
pl.talking_to=lounger
pl.batt= 120

--PUT INVENTORY IN TABLE

pl.inv={}
pl.curr_slot=0
pl.inv[1]=0 --lic
pl.inv[2]=0 --soda
pl.inv[3]=0 --trash
pl.inv[4]=0 --bullets
pl.inv[5]=0 -- gold
pl.inv[6]=0 -- crab
pl.g_parts={}
pl.b_parts={}
pl.d_parts={}




det={}
det.x=pl.x-8
det.y=pl.y
det.spr=0
det.et=time()
det.incycle=false
det.timer=-1
det.sw=false

t1 = -1

function move_player()
	pl.dx=0
	pl.dy=0
	if btn(0) then	
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
end

function update_pl()  
	map_tile = mget(flr(pl.x/8),flr(pl.y/8))
	flag_tile=fget(map_tile)
	t=pl.mrr
	
	if pl.batt <= 0 then
		cant_dig = true
	end
	-- if stam <= 0 then
	-- 	pl.src
	
	-- pl.dx=0
	-- pl.dy=0
	
	if pl.engaging then -- don't do anything but listen and respond
		pl.mvg=false -- Nec?
		if btn(5) and timer(btn5,.2,btn5.sw) then 
			pl.engaging = false 
			reset_dia()	
		end
	
	elseif show_inv then -- player is in inventory
		pl.mvg=false -- Nec?
		if btnp(2) and (pl.curr_slot > 0) then 
			pl.curr_slot -= 1 
		end
		if btnp(3) and (pl.curr_slot < 5) then 
			pl.curr_slot +=1
		end
		if btn(4) and (pl.curr_slot == 5) and (pl.inv[6] > 0) then
			this=true
			pl.engaging=true
			pl.talking_to=crab
			do_dialogue(crab)
		end
		-- rect(pl.x-4,pl.y-8,pl.x+12,pl.y+8,9)
	elseif btn(5) and timer(btn5,.5,btn5.sw) then
		for npchar in all(npcs) do
			if box_hit(pl.x,pl.y-4,16,16,npchar.x+16,npchar.y+8,20,12) then
				pl.mvg=false
				pl.talking_to=npchar
				pl.engaging=true
				show_inv=false
				break
			end
		end
		for gen_np in all(gen_npcs) do
			dgenx=gen_np.x
			dgeny=gen_np.y
			if box_hit(pl.x,pl.y-4,16,16,gen_np.x+16,gen_np.y+8,20,12) then				pl.mvg=false
				pl.talking_to=gen_np
				pl.engaging=true
				show_inv=false
				break
			end
				
		end

	elseif btn(4) then 
		pl.mvg=false
		if not digging and not cant_dig then 
			mvdet(5,3) 
			pl.batt -=.1
		else retdet() end
		
		
		-- end
		if pl.mrr != t then
			if pl.mrr then
				det.x=pl.x+8
			else 
				det.x=pl.x-8
			end
		end
		if btn(5) then -- do digging
			
			digging=true 
			pl.srch=true
			pl.mvg=false
		
			initArrow = true
			digging=true
			pl.srch=false

		end
	
	elseif digging then
		pl.mvg=false
		pl.srch=false 
		dig_nav()

		if btn(5) then 
			digging = false 
			initDig=true
		end -- stop digging
	
	else 
		move_player() 
		retdet()
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
		-- find distance between main items
		sfx_val = 8
		for main_item in all(m_items) do
			dist = dstf2(pl.x,pl.y,main_item.coords[1]*8,main_item.coords[2]*8)
			debugvar = dist
			
			if dist == 0 then
				sfx_val = 8
				break
			elseif dist < 1 then
				sfx_val = 10
				break
			
			elseif dist < 6 then
				sfx_val = 9
				break
			end
		end
		sfx(sfx_val)
	end 
end

-- returns metal detector to player.
function retdet()
 det.y=pl.y
 if pl.mrr then det.x=pl.x+5
 else det.x=pl.x-5
 end
end



function hit(x,y,w,h)
	collide=false
	for i=x,x+w,w do
		if fget(mget(i/8,y/8)) ==2 or
			fget(mget(i/8,(y+h)/8))== 2 then
				return true
		end
		
		if fget(mget(i/8,y/8)) ==5 or
			fget(mget(i/8,(y+h)/8))== 0x10 then
			-- debug1=true
			tranbool=true
			timer(ba,4,ba.sw)
			timer(gu,10,gu.sw)
			music(0)
			if outside then 
				tx_hold = pl.x
				ty_hold= pl.y
				pl.x = 110
				pl.y = 445
			else
				pl.x = tx_hold+5
				pl.y = ty_hold
			end
			outside = not outside
			
			-- debug=true	
		end
		if check_all_boxes(x,y) == true then collide = true end
	end
	
	return collide
end

function drawplayer()
	spr(pl.head,pl.x,pl.y-8,1,1,pl.mrr)
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
		dig_nav_l = true
		sfx(12)
	end
	if btn(1) and (dig_cursor.x < dhx+10) then
		dig_cursor.x += 19
		dig_nav_l = false
		sfx(12)
	end
	if btn(3) and (dig_cursor.y < dhy+5) then
		dig_cursor.y += 19
		dig_nav_t = false
		sfx(12)
	end
	if btn(2) and (dig_cursor.y > dhy+10) then
		dig_cursor.y -= 19
		dig_nav_t = true
		sfx(12)
	end

	pa1.sel=false 
	pa2.sel=false
	pa3.sel=false
	pa4.sel=false
	if dig_nav_l == true then
		if dig_nav_t == true then 
			pa1.sel=true 
		else pa3.sel=true end
	else 
		if dig_nav_t == true then pa2.sel=true
		else pa4.sel= true end
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

-- divides by 8 to prevent overflow.
function dstf2(x1,y1,x2,y2)
	return sqrt(sqr(x1/8-x2/8) + sqr(y1/8-y2/8))
end
 
-- function disptxt()
--  if timer(txt,3) then
--   txt.t="i lost my special coin!"
--  end
-- end
-->8
--band

--drummer
dr={}
dr.spr=6
dr.x=87
dr.y=390
dr.sc=5
dr.an=false
dr.timer=-1
dr.sw=false
dr.hb={}
dr.txt = "I'm in the zone!"
dr.vo=6

function draw_dm()
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
ba.hands=22
ba.arms=23
ba.x=103
ba.y=425
ba.sc=5
ba.an=true
ba.timer=-1
ba.sw=false
ba.w = 8
ba.h=16
ba.timer=-1
ba.txt = "One of our best performances right here."
ba.vo = 5

function drawba()
	animba()
	spr(ba.spr,ba.x,ba.y-16,2,1) -- head
 	spr(ba.arms,ba.x+8,ba.y-8) -- body
	spr(ba.hands,ba.x,ba.y-8) -- bass top
    spr(19,ba.x+8,ba.y) -- legs
	spr(21,ba.x,ba.y) --bass body
end
	--object,start,#frames,speed, flip
function animba()

	if timer(ba,rndb(.1,.7),ba.sw) then 
		ba.sw = not ba.sw
	end

	if ba.sw then
		ba.hands=24
		ba.arms=25
	else
		ba.hands=22
		ba.arms=23
	end 
	
end

function baact()
	disptxt()
end

--guitar
gu={}
gu.spr=11
gu.body=14
gu.hands=27
gu.x=70
gu.y=396
gu.sc=5
gu.an=true
gu.timer=-1
gu.sw=false
gu.txt = "couldn't have done it without you friend."
gu.vo=4

function drawgu()
	animgu()
	spr(gu.spr,gu.x,gu.y) -- head
	spr(gu.body,gu.x,gu.y+8)
	spr(gu.hands,gu.x+8,gu.y)
end

function draw_bart()
	spr(bart.spr,bart.x,bart.y,2,1)
end

function animgu()
	if timer(gu,rndb(.1,.7),gu.sw) then 
		gu.sw = not gu.sw
	end
	if gu.sw then
		gu.spr=12
		gu.body=13
		gu.hands=28
	else
		gu.spr=11
		gu.body=14
		gu.hands=27
	end 
end

crab={}
crab.txt="...chit..chit chit...chit..."

lounger={}
lounger.spr=32
lounger.x=34
lounger.y=77
lounger.txt="c'mon man... don't step on me while i'm enjoying a nice day in the sun."
lounger.vo=7

function draw_lounger()
	sspr(0,16,16,8,lounger.x,lounger.y)
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
00000000000dd00000111ff10011111100111ff10011110000000000000000000000000006666620012222100000000000000010221444562214445655500000
00000dd000d11d0001111eef01111ff101111eef01111110000000000000000000000000022222210621126001111010011111002214ff5522144555fff50000
0000ff000d1111d01111111001111eef111111100ff11ff00000000000ffff00000000000222662122166122111ff110111ff000222eef542224ff54ff1f5000
0000eef1dd1171dd00111110101111100011111001e11e109909000001fff1f00400900000662261216666121fffff001fff1f000222444d022eef4d1fff5000
0000d0000d1e11d000100010000111000000111005555550009904000e1f1ef0049999990022220021666612e11f11f01f1fe1f0055111dd055111ddfffe0000
000d000000eeff0000110011000115500001101155111155010099400eeefff0ff0000100000010022166122eeefeef0e1effff0055511d0055511d0eee10000
06ddd6000000ef0000050005000050500005000505066050100000ff00eeef00e000000100000010062112600eee1ff00eee1ff00500510005005100ff111000
6666600000011110055505550055505005550555ee6006ef1000666e0011110006660001000001111022220122eeef2022eeef4405005ddd05005dddeee11000
0011000000000000000220000002220000110000041541400000500000022000000e5f0000022000221221fe0000000000000000422000008888800011111000
011110000000000000022200000244000111100001454410000e5f0000222200000552200022220022122fe20000000000000000410000008888800011110000
00111110000000000022220000044400001111104445444400054220002222000005402200222200222212220000000000000000411000001888800022220000
0000011ff000000000222220000444000000011f44466444004544220202222000454402220222200eff22210000140000001400110000001888800022220000
000040ee1f0000000ff2222000044000000410ee444444440444544220022220044454400022222001111d110006410000064100000000000888800000220000
0000401eeef000000e222220000440000014401e04455440044454400022222004445440222022200511dd1000f6000000ff0000000000000888800000020000
0000500eeeef000000f22220000440000000500e00455400004454ff222222200044ff22000222200501d5000ee0000006e20000000000000003000000030000
00045400000e20000ee22200ddd555dd000050000000500000154ee000022200001ee10000022200050dddd06620000066220000000000000003300000033000
0af1f0000000000000000000000550000014410000000000000001400000e0000022220000144100090000900088000090009000000000000000000000000000
afffff000000000000000000fff5500000044000000000000000144a0099e9900266662000066000999009990878880090909499099999000000000000000000
af1ffff0000000000000000ff1fff000001aa10000000000000044a1099999992666666200466400100000018787878040904000097799000000000000000000
affff1f000000000000000fffe1fff00000660000000000000005a1000eee99032666623044664401600006122557880004004990eeeee000000000000000000
feffffef1100ff0000000ff1ffffff0000066000000000044445000000991111162222630a4554a0621221260052220090009000000997990000000000000000
0fefeeff111f00f000002f1ffff1f0000006600000000044445400009999e9901266662044444444262662620055000090909499000979990000000000000000
0fefffff111000ef00022ee1ff1e55000006600000000044454400000eee999913222231a444444a032662300005500040904000000eeeee0000000000000000
0feefeff111ffffe002212eeeee05500004664000044141454440000011119e0001111100aaaaaa010122101000aa00000400499000000000000000000000000
006666000008000000221ff200000000044664400444414544440000002222000000040000144100e000000e00000000000006600000dd6d0000000000000000
088888800080080002211efe000000000446644004444454144a0000061111600264464000a55a004e0000e40000660006600d60000d7d160000000000000000
0888888000808000022112ee0000000f0a4334a0044445414aa00000216666122646446204454440e030030e0000d6000d66d00000d7771d0000000000000000
088777700808000802222222000000ff04455440044654441000000021666612326466230a1451a00e0ee0e000dd0990000d66600d78c77d0000000000000000
07777870080808800111111000000f1f44444444044464444000000026111162362222610144541000eeee00009d0e9006d00d60d77987d00000000000000000
08888880808080000011110000002ff1a444444a05544444a00000003d2222d3026666214466664400044000090000900d606d00d1777d000000000000000000
02222880080800880001100000022e1e0a4444a0055aaaaa000000001133331113222231a455554a0e4004e0000009900066d6006117d0000000000000000000
006666000080880005555550002212ee00aaaa00500000000000000001dddd10011111000aaa5aa00e0000e00000000000dd0000d6dd00000000000000000000
bbbbbbbbb35bbbbb00000000000000000000000000000000000000000000000033333333333333300033333333333333cccc7cccccccccccccccc5b77b5ccccc
bbbbbbb7b35bbbbb000003333000000000000000000000000000000000000000000000000000000303ddddddddddddddcc7ccccccccc7ccccccc75b77b57cccc
bbbbbbb77b35bbbb00033f3ef30000000000000000000000000000000030000000000000000000033d7777777777777777ccccccc7777777c777775bb577777c
bbb7bb777b35bbbb003f3ef3ef3000000000003333300000000000000300000000000000000000033d7777777777777777777ccc77ccccc777cccc5bb5cccc77
bbbbb77777b355bb003ef3ef3ef30000000033ef3ef30000000003000030003000000000000000033d77777777777777cccc77777ccccccc7ccccc5bb5ccccc7
bbbb777b775b335503f3ef3ef3ef30000003ef3ef3ef3000000003000030330033333333333333303d77777777777777c55555ccc55555ccc5555c5bb5c5555c
bbb7777b7575bb3303ef3ef3effff30000033ef3effff300000030300303000000000000000000003d777777777777775bbbbb555bbbbb555bbbb5b77b5bbbb5
b77777bb777777bb003ef3effffff300003ef3effffff300000000033000000000000000000000003d77777777777777b77777bbbbbbbbbbb777777bb777777b
777777bb7b55b5b70003effffffff3000033efff000000000003333333333300b773333333333333333337bb0333333333333333aaaaaaaaaaaaaaaa55b5aa5a
7777bbbbb533335b003f3efffffff30000033eff0000000000300d00d00d0030bb33555555335355555533b7355b55555555b55baa55555a55a5a55555b5a55a
77bbbbbb53355335003ef3effffff3000003f3ef0000000000300d00d00d00307335555555535555b55353373bb5555555bb5555a5a55a5a5555a55a55b5a55a
bbbbbb7b535bb53b0003eeeefffff3000003eeee0333333303300d00d00d00303355555555555555355555333555b55bbb55555ba55aaaaaaaaaaaaa55b5aaaa
bbbbbbbbb3b77b350000333eeeee30000000333e0037773003300d00d00d003035355bb5bbb55bbb55b55553355b55b5555555b5a55a55555555555555b5a55a
bbbbbbbb535555350000000333330000000000030003730000300d00d00d00303555bb5bb55bb55bbb5b55533bbbbbbbbbbbbbbbaa5a5bbbbbbbbbbb55b5a5aa
bbbb7bbbb533335b0000000000000000000000000000300000300d00d00d00303555b55555555555555bb5530333333333333333a55a5b555555555555b5a55a
bbb777bb775b55b7000000000000000000000000000000000003333333333300355b5555555555555555bb530033000000033000aaaa5b555555555555b5a55a
bbbb777777777b77b77777bbbbbbbbbbb7bbbbbbb777777b5555555555555555355b5555bbb777775555b553bbbbbbbbbbbbbbbba5aa5b55aaaaaaaa33333333
bbb777777777777b5bbbbb555bbbbb557b5bbb555bbbb5b7553b555555555555355b5b35bb7b777753b5b553bbbbbbbbbbbbbbbba55a5b55abafbafb88888883
bb7777777777777bc55555ccc55555ccb5c555ccc5555c5b5555555555b55535335b5555b7b777775555b533bbbbbbbbbbbbbbbba55a5b55abafbafb22888783
b7b77777777777bbcccc77777cccccccb5cc77777ccccc5b5555b55bbbbb55b53335b555bb7b7777555b5333abbbbbbbbbbbbbbaaaaa5b55abafbafb28888883
77777777777777bb77777ccc77ccccc7b5777ccc77cccc5b555b5bb55555b5553355b555b7b77777555b5533bbbbbabbbbbbbbbba55a5b55abafbafb88878883
7777777777777bbb77ccccccc7777777b5ccccccc777775b55bb5555535b5555355bb555bb7b7777555bb553fffffaafffffffffaa5a5b55abafbafb88788883
b777777777777bb7cc7ccccccccc7ccc7b5ccccccccc75b7555b5353355b555535bb5555bbb7b7775555bb53aaaaaaaaaaaaaaaaa55a5b55abafbafb78888283
777777777777bbb7cccc7ccccccccccc7b5c7cccccccc5b7555b55333355b55535b55555aaaa7b7755555b53bbbbbbbbbbbbbbbba55a5b55abafbafb87882283
777777777777bbb7ccccccccccccccccb5cccccccccccc5b555b55333355b55535bb55555555555555555b53bbbbbbbbbbbbbbbb55b5a55a5555555587822283
77777777777bbb77cc777777ccc7cccc7b577777ccc7c5b75555b5533535b555355bb5555555555553555b53bbbbbbbbbbbbbbbb55b5aa555555555587822283
7777777777bbb7b7777c77777ccccccc7b5c77777cccc5b75555b5355555bb553555b5bbb55bb55b555bb553bbbaabbbbbbbbbbb55b5a555bbbbbbbb87822283
777777777bbbb77777c7ccc777c777777b57ccc777c775b7555b55555bb5b55535555b55bbb55bbbbbb55353bbbbbbbbbbbbbbbb55b5aaaa5555555587822283
77777777bbbb7777ccccc7cc7777c77c7b5cc7cc7777c5b75b55bbbbb55b555533555553555555555b555533bbbbbbbbbbbbbbbb55b55555aaaaaaaa87822283
77777bbbbb777777ccccccccccc77ccc7b5cccccccc775b753555b55555555557335355b5553555555555337ffffffffffaaafff55bbbbbb5555a55a87822283
777bbbbbb777777bcc7cccccccccccccb5cccccccccccc5b555555555555b3557b33555555335355555533bbaaaaaaaaaaaaaaaa5555555555a5a55587822283
77bbbb7777777777ccccccccccccccccb5cccccccccccc5b5555555555555555bb733333333333333333377bbbbbbbbaabbbbbbb55555555aaaaaaaa87822283
a6170717071707170717071707170717071707174700000000000000000000000000000000000000000000000000000000000000000717071707170717071707
17071707170717071707170717071707170717071707170717071707170717071707170717071707170717071700000000000000000000000000000000000000
a6160616061606160616061606160616061600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a6170717071707170717071707170717071700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a6160616061606160616061606160616061600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a6170717071707170717071707170717071700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a6160616061606160616061606168616000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a6170717071707170717071707178617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6795959595a506168595959595957716000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00170717071707170717071707170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00161707170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00170006160616000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000006160616000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007170717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000006160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d7e7e7e7e7e7e7e7e7e7e7e7e7e7e7d7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b6c6b6c6b6c6b6c6b6c6b6c6b6c6d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b7c7b7c7b7c7b7c7b7c7b7c7b7c7d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b6c6b6c6b6c6b6c6b6c6b6c6b6c6d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b7c7b7c7b7c7b7c7b7c7b7c7b7c7d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b6c6b6c6b6c6b6c6b6c6b6c6b6c6d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b7c7b7c7b7c7b7c7b7c7b7c7b7c7d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b6c6b6c6b6c6b6c6b6c6b6c6b6e696000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b7c7b7c7b7c7b7c7b7c7b7c7b7e696000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b6c6b6c6b6c6b6c6b6c6b6c6b6c6d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b7c7b7c7b7c7b7c7b7c7b7c7b7c7d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b6c6b6c6b6c6b6c6b6c6b6c6b6c6d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b7c7b7c7b7c7b7c7b7c7b7c7b7c7d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b6c6b6c6b6c6b6c6b6c6b6c6b6c6d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f5b7c7b7c7b7c7b7c7b7c7b7c7b7c7d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d7e7e7e7e7e7e7e7e7e7e7e7e7e7e7d7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000100000000000000000001000000000000000000020000000000000000000080000000000100000000000000000000000000000000000000000000000000000002020202000000000000000002020200000202020000020202020202021002000002000200000202020202020202020000020202
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
6679797979797979797979797979797979797967667979797979796779797979667979797979677679797979796779797979797971707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
7f6f616061606160616061607867667a616061787a60616061606168665967676a60616061607876797959596a6761606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
6a7f5d70717071707170717071686a7071707170717071707170716868776a6a6a70717071707170717068686a7a71707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
6a7f6d6061606160616061606168765a616061585a60616061606168767979776a60616061606160616078797a6061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
6a7f5d70717071707170717071786776595959776a70717071707178797979797a7071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
6a7f696e616061606160616061607867667979797a6061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
6a7f696e7170717071707170717071787a707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
6a7f5d6061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
6a7f6d7071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
6a7f5d6061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
7f6f717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
6362636263626362636265606160646362636263626362636263626362636263626362636560616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
7372737273727372737375707170747372737273727372737272737273727372737273727570717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
7273727372737273727373626560747372737273727372737372737273727372737273727560616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
727372734c4d4c4d4c4d4c4d4e70747273727372737273727372737273727372737273727362626262626270717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
7273727560616061606160616061747273727372737273727372737273727372737273727372737273727375706061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
7273727570717071707170717071747372737272737273727372737273727372737273727372737273727375607071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
7273727560616061606160616061747273727372737273727372737273727372737273727372737273727375706061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
72734c4e70717071707170717071747272737273727372737273727300000000000000727372737272737273657071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
585a606160616061606160616061747273727372737273727372737200000000000000727372737273737273726263626362636265606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160
686a707170717071707170717071747272737273727372737273727300000000000000727372737273727273727372737273727375707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170
686a606160616061606160616061747273727372737273727372737200000000000000727372737273727373727372737273727375606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606100000000000000000000000000000000000020
686a707170717071707170717071747272737273727372737273727300000000000000727372737273727373727372737273727375707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707100000000000000000000000000000000000020
667a606160616061606160616061747273727372737273727372737200000000000000727372737273727372737372737272737075606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606100000000000000000000000000000000000020
6a71707170717071707170717071747272737273727372737273727300000000000000727372737273727372737273727372736060707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707100000000000000000000000000000000000020
6a61606160616061606160616061747373727372737273727372737200000000000000000000000000000000000000000060606060606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606100000000000000000000000000000000000020
6a717071707170717071707170714f4d4c4d4c4d727300000000000000000000000000000000000000000000000000000000000000707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707100000000000000000000000000000000000020
6a61606160616061606160616061606160616061747200000000000000000000000000000000000000000000000000000000000000606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606100000000000000000000000000000000000020
6a71707170717071707170717071707170717071747200000000000000000000000000000000000000000000000000000000000000707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707100000000000000000000000000000000000020
6a61606160616061606160616061606160616061747200000000000000000000000000000000000000000000000000000000000000606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606100000000000000000000000000000000000020
6a71707170717071707170717071707170717071747200000000000000000000000000000000000000000000000000000000000000707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707170717071707100000000000000000000000000000000000020
6a61606160616061606160616061606160616061740000000000000000000000000000000000000000000000000000000000000000606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606160616061606100000000000000000000000000000000000020
__sfx__
480c002000000000003261133611336113f6113e6113e6113e6123e6123e6123e6123e6123e612326123261232612266112461124611246110c611006120c6120061500000000000000000000000000000000000
01020000155541d54119543363003630036300107000f7000f7001070003700337003370033700337003370033700337003370033700337003370033700337003370033700337003f7001b7001b7001b70000000
490200001a7442a2311e7330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09020000151441a132191330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020000131422d314171230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4d030000075451b532185310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200000064438131006320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03020000137311b612187220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0300000031603321063320634206341063410633500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d030000183161b3211e3321e3421e3411e3411e33500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0903000024316273212a3322a3422a3412a3412a33500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102000014555155511b55220552207521b5541815413151101510d5530d5530d5530d5530d5530d1531215319153251532f75330755317513275132751327513275400500005000050000500005000000000000
0101000020552207521b5541815413151101510d5530d5530d5530d5530d5530d1531215319153251532f75330755317513275132751327513275400000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000f7500f7500f7500f7500f7500f7500f7500f7500f7500f7500f7500f7500f75010750107500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001275012750127501275012750127501275012750127501275014750147501370000000000001370013700137001370000000000000000000000000000000000000000000000000000000000000000000
0001000019750197501875017750177501775017750177501775017750197501a750277001e5001e500005002a5002a5002950029500285002850027500285002850029500295002950029500295002950029500
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00001f6132b6001f6130060022623166001f612006001f6150e60024623096001f613006001f613006001f6132b6001f6130060022623006001f612006001f6150f60024623006001f613006001f61309600
490f00003c6323c63328623006000c663166003761200600376150e6003c6323c6330c663006003c6323c6333c6323c63337613006000c663006003761200600376150f6003c6323c6330c663006003761309600
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00001140000000000001740018400000000000000000000000000011400000000000017400184000000000000000001540000000000001740018400000000000000000154000000018400184001740000000
170f00001144500000000001742018452184450000000000000000000011445000000000017420184521844500000000001544500000000001742018452184450000000000154421742118442184551744017410
170f00001644500000000001842019452194450000000000164000000016445000000000018420194521944519400000001944517400174001740016452164551540017400194451840016420000001945219445
170f0000214221e4201f4521f44500000004001e4301e4411d4501d4550040000000000001f4201f4521f4451e4301e4411d4501d455004001f4201f4521f455000002140021450214211d4501d4211c4501c421
170f00001a4501a4221a4221a42500400194201a4521a4401a4521a42119452194401944219421184521844018442184211645216440164421642118452184401844218421164521642115452154211845218421
170f0000184211e4201f4521f44500000004001e4301e4411d4501d4550040000000000001f4002143221455204322045521432214551f4001f4002645226445000002d400284522844228445000001d4301d455
170f00001a4501a4221a4221a42500400194201a4521a4401a4521a425194321945019452194451a4521a4401a4521a4251c4521c4401c4521c42526450264422644226425004001742017452184201845218442
170f0000184521845218425000000000014425154311545018431184551a4311a452000001b4201c4501c4521c4321c4321c425000002d40020420214512145221432214322142500000000001b4251c4301c452
170f00001b4201b4551a4511a4521a4321a4550000000000000001d4201d4521d435000001f4201f4521f4321f435000002145021435224522243500000000002542025442254522545225452254302542523400
170f000023420234552445224450244302443224425004000040000400004000040019400194201945219425194001c4201c4521c4521c4321c4251b4201b4511a4501a4421a4252042021452214522143221425
170f00001e4521e4551f4521f4501f4501f4301f4321f425004001d4201d4521d4521d4321d4251f4521f4521f4321f4251e4211e4521d4511d4321d425004000000022420244522442122422224552142021455
170f00001a4201a4521a4321a42500000000001d4221d4511f4201f45121452214251c4001c400244222445527400274002242222455274000000024422244551840018400224222245524400244002142221452
010f00002445024450244502445024450244500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
110f00000516205165000000000000000000000c1620c1650c1620c1650000000000000000000005162051650516205165000000000000000000000c1620c1650c1620c1650c1620d1610e1620e1650c1620c165
110f00000a1620a1653c000000000000000000051620516505162051650000000000000000000009162091650a1620a1650000000000000000000005162051650516205165051620616107162071650616206165
__music__
00 22674344
00 22683544
00 22693644
01 22283544
00 22293644
00 222a3568
00 222b3669
00 222c3568
00 222d3669
00 222e3544
00 222f3644
00 22303544
00 22313644
00 222a3568
00 222b3669
00 222c3568
02 22323669
00 626a7568
00 626b7669
00 626c7568
00 62727669

