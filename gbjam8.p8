pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- start
game = {}

flags = {
	collision=0,
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
		show_level()
	end
end

function draw_menu()
	cls()
	pal(1, true)
	spr(64,32,20,8,2)
	spr(96,24,40,10,2)
	pal()
	print_centered("press x to start", 0, 10)
end
-->8
-- levels
slimes={}

input={
	x=0,
	y=0
}

function show_level()
	game.update = update_level
	game.draw = draw_level
	
	add(slimes,new_player(5*8,6*8))
end

function input_walk()
	input.x=0
	input.y=0

 if btn(➡️) then input.x+=1 
	elseif btn(⬅️) then input.x-=1 
	elseif btn(⬇️) then input.y+=1
	elseif btn(⬆️) then input.y-=1 end
end

function update_level()
	input_walk()
	
	for slime in all(slimes) do
				slime.spt=1
	end
	
	if input.x != 0 or input.y != 0 then
			
			local flag_walk
			for slime in all(slimes) do
				if not flag_walk then
					flag_walk = walk(slime)
				else
				 walk(slime)
				end
			end
			
			if flag_walk then
				sfx(sfxs.walk)
			end
			
			game.update = update_walk
	end
	
end

function update_walk()
	local can_walk = true

	for slime in all(slimes) do
		if slime.x>slime.next_x then 
			slime.x-=1 
			can_walk = false
		elseif slime.x<slime.next_x then 
			slime.x+=1
			can_walk = false
		elseif slime.y>slime.next_y then 
			slime.y-=1 
			can_walk = false
		elseif slime.y<slime.next_y then 
			slime.y+=1 
			can_walk = false
		end
		
		anim(slime)		
	end
	
	for slime in all(slimes) do
		if can_walk and is_finish(slime.x,slime.y) then
			next_level()
		end
	end

	if can_walk then
	 game.update=update_level
	end
	
end

function is_finish(x,y)
		local tile=mget(x/8, y/8)
	return fget(tile, flags.portal)
end

function next_level()
 anim_level(2)
end

function draw_level()
	cls()
	map()
	for slime in all(slimes) do
		spr(slime.spt,slime.x,slime.y)
	end
end

function anim_level(level)
 cls()
 camera(128,0)
	print_centered("level "..level, 0, 0)
end
-->8
-- credits

-->8
-- tools
function print_centered(str, offset_x, offset_y)
  print(str, 
  64 - (#str * 2) + offset_x, 
  60 + offset_y) 
end

-->8
-- player
function new_player(x,y)
	local player={}
	player.x = x
	player.y = y
	player.next_x=0
	player.next_y=0
	player.spt=1
	return player
end

function walk(player)

	local next_x = player.x+input.x*8
	local next_y = player.y+input.y*8
	if not is_block(next_x, next_y) then
		player.next_x = next_x
		player.next_y = next_y
		
		return true
	end
	
	return false
end

function is_block(x, y)
	local tile=mget(x/8, y/8)
	return fget(tile, flags.collision)
end

function anim(player)
	player.spt+=0.5
	if player.spt > 4 then
	 player.spt=1
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
0000000000000000000000000000000000808000000101010100000000000000000000000001010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141715151515151515151814141414141414171515151515151814141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141614141414141414142614141414141414161414141414112614141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141614141414141411142614141414141414161414141314252614141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141614141414141414142614141414141414161414141414112614141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414142725252525252525252814141414141414272525252525252814141414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
