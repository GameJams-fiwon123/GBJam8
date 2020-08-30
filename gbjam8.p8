pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- start
game = {}

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
	print_centered("slime adventure", 0, 0)
	print_centered("press x to start", 0, 10)
end
-->8
-- levels
slimes={}

function show_level()
	game.update = update_level
	game.draw = draw_level
	
	add(slimes,new_player(0,0))
end

function update_level()
 for slime in all(slimes) do
		walk(slime)
		anim(slime)
	end
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
	print_centered("level "+level, 0, 0)
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
	player.spt=1
	return player
end

function walk(player)
	if btn(➡️) then player.x+=1 
	elseif btn(⬅️) then player.x-=1 
	elseif btn(⬇️) then player.y+=1
	elseif btn(⬆️) then player.y-=1 end
end

function anim(player)
	player.spt+=0.25
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
00000000111111111111111100000000111111111111111111111999111111111111111100000000000000000000000000000000000000000000000000000000
00000000118888111188881100000000111111119999999119991999119999919999991100000000000000000000000000000000000000000000000000000000
00000000181881811818818100070007111111119999999119991999191999919999919100000000000000000000000000000000000000000000000000000000
00000000188798811889788100770077111111119999999119991999199199919999199100000000000000000000000000000000000000000000000000000000
00000000188978811887988107770777111111111111111119991111199911111111999100000000000000000000000000000000000000000000000000000000
00000000181881811818818177777777111111119999199919991999199911999911999100000000000000000000000000000000000000000000000000000000
00000000118888111188881100000000111111119999199919991999199919199191999100000000000000000000000000000000000000000000000000000000
00000000111111111111111100000000111111119999199919991999199919911991111100000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000009999999199919991111119911991999100000000000000000000000000000000000000000000000000000000
00000000117777110077077000770770007707709999999199919991199919199191999100000000000000000000000000000000000000000000000000000000
00000000177777710788788707887007070070079999999199919991199911999911999100000000000000000000000000000000000000000000000000000000
00000000177777710788888707888007070000071111111199919991199911111111999100000000000000000000000000000000000000000000000000000000
00000000177777710788888707888007070000079999199999911111199199999999199100000000000000000000000000000000000000000000000000000000
00000000177777710078887000788070007000709999199999919991191999999999919100000000000000000000000000000000000000000000000000000000
00000000117777110007870000078700000707009999199999919991119999999999991100000000000000000000000000000000000000000000000000000000
00000000111111110000700000007000000070001111111111119991111111111111111100000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000117777110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777710990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777719009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000171777719009999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000171777719009009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777710990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0033333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001b0701b070000000604006040060001a0701a070000000504005040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001a6201c62020620256202a6202f6203262034620376203862000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200001245012450000002145021450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000243502465015350156501a3001a3000160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003125031250000000000033250332500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
