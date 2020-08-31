pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- start
game = {}

input={
	x=0,
	y=0
}

camera_pos={
	x=0,
	y=0
}


flags = {
	collision=0,
	spike=1,
	portal=7
}

sfxs = {
 spike = 0,
 walk  = 1,
 catch = 2,
 open_door = 3,
 button = 4
}

function _init()
	show_menu()
end

function _update()
	game.update()
end

function _draw()
	game.draw()
end
-->8
-- main menu

function show_menu()
	game.update = update_menu
	game.draw = draw_menu
end

function update_menu()
	if btn(❎) then
  start_game()
	end
end

function draw_menu()
	cls()
	rectfill(0,0,128,128,1)
	spr(64,32,20,8,2)
	spr(96,24,40,10,2)
	print_centered("press x to start", 0, 10)
end
-->8
-- levels

is_walking = false

function start_game()
	game.time = 0
	game.level = 1
	
	camera_pos.x=0
	camera_pos.y=0
	game.scenes={
		{show=show_level1},
		{show=show_level2},
		{show=show_level3},
		{show=show_level4},
		{show=show_level5},
		{show=show_level6},
		{show=show_level7},
		{show=show_level8},
		{show=show_level9},
		{show=show_level10}
	}
 game.update = update_anim_level
	game.draw = draw_anim_level
end

function show_level1()
	add(slimes,new_slime(5*8,6*8,1))
	get_portals()
end

function show_level2()
	add(slimes,new_slime(camera_pos.x+5*8,camera_pos.y+6*8,1))
 get_portals()
end

function show_level3()
	add(slimes,new_slime(camera_pos.x+5*8,camera_pos.y+6*8,1))
 get_portals()
end

function is_tile(x,y,type_tile)
	local tile=mget(x/8, y/8)
	return fget(tile, type_tile)
end

function input_walk()
	input.x=0
	input.y=0

 if btn(➡️) then input.x+=1 
	elseif btn(⬅️) then input.x-=1 
	elseif btn(⬇️) then input.y+=1
	elseif btn(⬆️) then input.y-=1 end
end

function verify_input()
		if input.x != 0 or input.y != 0 then
				local flag_walk=false
				for slime in all(slimes) do
					if not flag_walk then
						flag_walk = set_input_walk(slime)
					else
					 set_input_walk(slime)
					end
				end
				
				if flag_walk then
					sfx(sfxs.walk)
					is_walking=true
				end
		end
end

function complete_level()

	local portals_count = #portals

	for slime in all(slimes) do
		if is_tile(slime.x,slime.y,flags.portal) then
			portals_count-=1
		end
	end
	
	if portals_count==0 then
		return true
	end
	
	return false
end

function update_level()
	anim_portals()

 if not is_walking then
	 input_walk()
	 anim_idle()
		
		verify_input()
 else
 		is_walking=process_walk()
 		
 		if not is_walking then
 		 if complete_level() then
 		 	next_level()
 		 end
 		 
 		 for slime in all(slimes) do
 		  if is_tile(slime.x,slime.y,flags.spike) then
 		 		divide(slime)
 		  end
 		 end
 		 
 		 for slime in all(slimes) do
 		 	process_fusion(slime)
 		 end
 		end
 end

end

function next_level()
 game.time=0
 game.level+=1
 
 portals={}
	slimes={}
 
 camera_pos.x+=128
 if (camera_pos.x/128 == 5) then
  camera_pos.x=0
  camera_pos.y+=128
 end
 camera(camera_pos.x, camera_pos.y)
 
 game.update = update_anim_level
	game.draw = draw_anim_level
end

function draw_level()
	cls()
	map()
	for slime in all(slimes) do
		spr(slime.spt,slime.x,slime.y)
	end
	
	for slime in all(slimes) do
		palt(1,true)
		
		if slime.life%1 != 0 then
		 for i=0,slime.life-1 do
			 spr(34,slime.x-(slime.life)*8+i*8+8*(slime.life+1)/2.5-2.5,slime.y-8)
	 	end
			spr(spr(35,slime.x-(slime.life-1)*8+(slime.life-1)*8+8*slime.life/2.5-2.5,slime.y-8))
	 else
	 	for i=0,slime.life-1,1 do
			 spr(34,slime.x-(slime.life-1)*8+i*8+8*slime.life/2.5-2.5,slime.y-8)
	 	end
	 end
	 palt(1,false)
	end
end

function update_anim_level()
 game.time+=1
 if game.time == 30 then
  game.scenes[game.level].show()
  game.update = update_level
	 game.draw = draw_level
 end
end

function draw_anim_level()
 cls()
 rectfill(camera_pos.x,camera_pos.y,camera_pos.x+128,camera_pos.y+128,1)
	print_centered("level "..game.level, camera_pos.x, camera_pos.y)
end
-->8
-- credits

-->8
-- tools
function print_centered(str, offset_x, offset_y)
  print(str, 
  64 - (#str * 2) + offset_x, 
  60 + offset_y,7) 
end
-->8
-- slime
slimes={}

function new_slime(x,y,life)
	local slime={}
	slime.x = x
	slime.y = y
	slime.life = life
	slime.next_x=0
	slime.next_y=0
	slime.spt=1
	return slime
end

function set_input_walk(slime)

	local next_x = slime.x+input.x*8
	local next_y = slime.y+input.y*8
	if not is_tile(next_x, next_y, flags.collision) then
		slime.next_x = next_x
		slime.next_y = next_y
		
		return true
	end
	
	slime.next_x = slime.x
	slime.next_y = slime.y
	
	return false
end

function process_fusion(slime)
 for slm in all(slimes) do
  if slm != slime then
   if slm.x == slime.x and
      slm.y == slime.y then
      slm.life+=slime.life
      del(slimes,slime)
   end
  end
 end
end

function divide(slime)
	sfx(sfxs.spike)
 if (slime.life >= 1) then
  if input.x != 0 then
   if (is_tile(slime.x,slime.y+1*8,flags.collision) and
      is_tile(slime.x,slime.y-1*8,flags.collision)) then
      if input.x > 0 then
      	add(slimes,new_slime(slime.x+1*8, slime.y, slime.life/2))
      else
       add(slimes,new_slime(slime.x-1*8, slime.y, slime.life/2))
      end
   elseif is_tile(slime.x,slime.y+1*8,flags.collision) then
    if input.x > 0 then
    	add(slimes,new_slime(slime.x+1*8, slime.y, slime.life/2))
    else
     add(slimes,new_slime(slime.x-1*8, slime.y, slime.life/2))
    end
	  	add(slimes,new_slime(slime.x, slime.y-1*8, slime.life/2))
   elseif is_tile(slime.x,slime.y-1*8,flags.collision) then 
	  	if input.x > 0 then
    	add(slimes,new_slime(slime.x+1*8, slime.y, slime.life/2))
    else
     add(slimes,new_slime(slime.x-1*8, slime.y, slime.life/2))
    end
    add(slimes,new_slime(slime.x, slime.y+1*8, slime.life/2))
   else
	   add(slimes,new_slime(slime.x, slime.y+1*8, slime.life/2))
	  	add(slimes,new_slime(slime.x, slime.y-1*8, slime.life/2))
   end
  elseif input.y != 0 then
  	add(slimes,new_slime(slime.x+1*8, slime.y, slime.life/2))
  	add(slimes,new_slime(slime.x-1*8, slime.y, slime.life/2))
  end
  del(slimes,slime)
 else
 	del(slimes,slime)
 end
end

function process_walk()

	local is_finish = true

	for slime in all(slimes) do
		if slime.x>slime.next_x then 
			slime.x-=1 
			is_finish = false
		elseif slime.x<slime.next_x then 
			slime.x+=1
			is_finish = false
		elseif slime.y>slime.next_y then 
			slime.y-=1 
			is_finish = false
		elseif slime.y<slime.next_y then 
			slime.y+=1 
			is_finish = false
		end
		
		anim_walk(slime)		
	end

	if is_finish then
	 return false
	end
	
	return true
	
end

function anim_idle()
	for slime in all(slimes) do
				slime.spt=1
	end
end

function anim_walk(slime)
	slime.spt+=0.5
	if slime.spt > 4 then
	 slime.spt=1
	end
end
-->8
--portal
portals={}

function new_portal(x,y)
	local portal={}
	portal.x = x
	portal.y = y
	portal.spt=17
	return portal
end

function get_portals()
	for i=camera_pos.x,camera_pos.x+128,8 do
		for j=camera_pos.y,camera_pos.y+128,8 do
		 if is_tile(i,j,flags.portal) then
		 	add(portals,new_portal(i,j))
		 end
		end
	end
end

function anim_portals()
	for p in all(portals) do
	 p.spt+=0.2
	 if p.spt > 19 then
	  p.spt=17
	 end
	 mset(p.x/8,p.y/8,flr(p.spt))
	end
end
__gfx__
00000000000000000000000000000000000990000000000000000000000000000009900000000000000000000000000000000000000000000000000000000000
00000000000990000000000000099000009999000009900000000000000990000099990000099000000000000000000090000009000000000000000000000000
00700700009999000000000000999900001991000099990000000000009999000018910000999900000000000900009000000000000000000000000000000000
00077000091991900009900009199190009999000918919000099000091891900089888009199190001991000000000000000000000000000000000000000000
00077000099999900999999009999990009999000989888009189190098988800098980009999990009999000009900000000000000000000000000000000000
00700700099999909199991909999990009999000998989099898889099898900099990009999990009999000000000000000000000000000000000000000000
00000000009999009999999900999900000990000099990099989899009999000009900000999900000000000900009000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000090000009000000000000000000000000
00000000111111111111111111111111111111111111111111111999111111111111111100000000000000000000000000000000000000000000000000000000
00000000118888111188881111111111111111119999999119991999119999999999991100000000000000000000000000000000000000000000000000000000
00000000181881811818818111171117111111119999999119991999191999999999919100000000000000000000000000000000000000000000000000000000
00000000188798811889788111771177111111119999999119991999199199999999199100000000000000000000000000000000000000000000000000000000
00000000188978811887988117771777111111111111111119991111199911111111999100000000000000000000000000000000000000000000000000000000
00000000181881811818818177777777111111119999199919991999199911999911999100000000000000000000000000000000000000000000000000000000
00000000118888111188881111111111111111119999199919991999199919199191999100000000000000000000000000000000000000000000000000000000
00000000111111111111111111111111111111119999199919991999199919911991999100000000000000000000000000000000000000000000000000000000
00000000111111111111111111111111111111119999999199919991199919911991999100000000000000000000000000000000000000000000000000000000
00000000117777111177177111771771117717719999999199919991199919199191999100000000000000000000000000000000000000000000000000000000
00000000177777711788788717887117171171179999999199919991199911999911999100000000000000000000000000000000000000000000000000000000
00000000177777711788888717888117171111171111111199919991199911111111999100000000000000000000000000000000000000000000000000000000
00000000177777711788888717888117171111179999199999911111199199999999199100000000000000000000000000000000000000000000000000000000
00000000177777711178887111788171117111719999199999919991191999999999919100000000000000000000000000000000000000000000000000000000
00000000117777111117871111178711111717119999199999919991119999999999991100000000000000000000000000000000000000000000000000000000
00000000111111111111711111117111111171111111111111119991111111111111111100000000000000000000000000000000000000000000000000000000
00000000111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000117777111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777711991111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777719119111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000171777719119999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000171777719119119100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777711991111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777711111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19911111199111111999999999911111199111111111111119999999999111110000000000000000000000000000000000000000000000000000000000000000
99998111999981119999999999998111999911111111111199999999999911110000000000000000000000000000000000000000000000000000000000000000
99998811999988119999999999998811999981111111111199999888999981110000000000000000000000000000000000000000000000000000000000000000
99998811999988119999999999988811999981111111111199998111899981110000000000000000000000000000000000000000000000000000000000000000
99998811999988119999988888888111999981111111111199999111999981110000000000000000000000000000000000000000000000000000000000000000
99999999999988119999881111111111999981111111111199999999999981110000000000000000000000000000000000000000000000000000000000000000
99999999999988119999999111111111999981111111111199999999999981110000000000000000000000000000000000000000000000000000000000000000
99999999999988119999999811111111999981111111111199999999999881110000000000000000000000000000000000000000000000000000000000000000
99999999999988119999888811111111999981111111111199998888888811110000000000000000000000000000000000000000000000000000000000000000
99998888999988119999911111111111999981111111111199998111111111110000000000000000000000000000000000000000000000000000000000000000
99998888999988119999999999911111999999999991111199998111111111110000000000000000000000000000000000000000000000000000000000000000
99998811999988119999999999998111999999999999811199998111111111110000000000000000000000000000000000000000000000000000000000000000
99998811999988119999999999998811999999999999881199998111111111110000000000000000000000000000000000000000000000000000000000000000
19988811199881111999999999988811199999999998881119988111111111110000000000000000000000000000000000000000000000000000000000000000
11188111118811111188888888888111118888888888811111881111111111110000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
11999999999111111991111111111111111119999911111119911111111991111999999999911111000000000000000000000000000000000000000000000000
19999999999911119999111111111111111999888999111199991111119999119999999999998111000000000000000000000000000000000000000000000000
99999999999981119999811111111111119998888899911199999111199999819999999999998811000000000000000000000000000000000000000000000000
99998888999881119999811111111111119998999899981199999911999999819999999999988811000000000000000000000000000000000000000000000000
99999888888811119999811111111111111997797799881199999999999999819999988888888111000000000000000000000000000000000000000000000000
99999911111111119999811111111111111177181778811199999999999999819999881111111111000000000000000000000000000000000000000000000000
19999999111111119999811111111111111177181778111199999999999999819999999111111111000000000000000000000000000000000000000000000000
11899999991111119999811111111111111197787798111199998999989999819999999811111111000000000000000000000000000000000000000000000000
11118999999111119999811111111111111999989999111199998199889999819999888811111111000000000000000000000000000000000000000000000000
11111199999911119999811111111111111999989999811199998118819999819999911111111111000000000000000000000000000000000000000000000000
19911119999981119999999999911111111998889999811199998111119999819999999999911111000000000000000000000000000000000000000000000000
99999999999981119999999999998111111998889999811199998111119999819999999999998111000000000000000000000000000000000000000000000000
99999999999881119999999999998811111999989999811199998111119999819999999999998811000000000000000000000000000000000000000000000000
19999999998881111999999999988811111199999998811119988111111998811999999999988811000000000000000000000000000000000000000000000000
11888888888811111188888888888111111118888888111111881111111188111188888888888111000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000
41414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141410000000000
__gff__
0000000000000000000000000000000000808002000101010100000000000000000000000001010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141715151515151515151814141414141417151515151515151518141414141414171515151515151515181414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141614141414141414142614141414141416141414141414141126141414141414161414141413141411261414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141614141414141411142614141414141416141414141314142526141414141414161314141414142525261414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141614141414141414142614141414141416141414141414141126141414141414161414141413141411261414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414142725252525252525252814141414141427252525252525252528141414141414272525252525252525281414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001b0701b070000000604006040060001a0701a070000000504005040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001a6201c62020620256202a6202f6203262034620376203862000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200001245012450000002145021450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000243502465015350156501a3001a3000160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003125031250000000000033250332500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
