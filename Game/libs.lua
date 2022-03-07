f = {}

data = {}
-- TETRIS FUNCTIONS

function setup_board()

	game.flashPos = 1

	if game.beatmap then
		game.timeTilNextBeat = game.beatmap[1]
		game.totalBeatTime = game.beatmap[1]
	else
		game.timeTilNextBeat = 100000
	end

	movingObjects = {}
	game.white_screen = false
	game.flashLights = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		["a"] = 0,
		["b"] = 0,
		["c"] = 0,
		["d"] = 0,
		["e"] = 0,
		["f"] = 0,
		["g"] = 0
	}
		game.lastDropTime = 0
		game.hp = 0.75
		game.beatCount = 1
		game.missCount = 0
		game.niceCount = 0
		game.perfectCount = 0
		game.holdCount = 0

	for i = 1,20 do
		player_matrix[i] = {0,0,0,0,0,0,0,0,0,0}
	end

	--player_matrix[21] = {10,10,10,10,10,10,10,10,10,10}

	bag = game.customBag and game.customBag or generate_bag()..generate_bag()
	held_piece = false
end

--shuffles a string - used for 7bag randomization
function shuffle(str)
   local letters = {}
   for letter in str:gmatch'.[\128-\191]*' do
      table.insert(letters, {letter = letter, rnd = math.random()})
   end
   table.sort(letters, function(a, b) return a.rnd < b.rnd end)
   for i, v in ipairs(letters) do letters[i] = v.letter end
   return table.concat(letters)
end

function generate_bag()
	return shuffle("1234567")
end



--rotates a 2d table 90 degrees, for piece rotation. (too lazy to write myself - credit to woot3 on roblox)
function col(t)
	local i, h = 0, #t
	return function ()
		i = i + 1
		local column = {}
		for j = 1, h do
			local val = t[j][i]
			if not val then return end
			column[j] = val
		end
		return i, column
	end
end

function rev(t)
	local n = #t
	for i = 1, math.floor(n / 2) do
		local j = n - i + 1
		t[i], t[j] = t[j], t[i]
	end
	return t
end

function rotateCW(t)
	local t2 = {}
	for i, column in col(t) do
		t2[i] = rev(column)
	end
	return t2
end

function rotateCCW(t)
	local t2 = {}
	for i, column in col(t) do
		t2[i] = column
	end
	return rev(t2)
end

function make_garbage(pos)
	pos = pos and pos or math.random(1,10)
	local template = {8,8,8,8,8,8,8,8,8,8}
	template[pos] = 0
	return template
end

function check_tspin()
		local positions = {
			{0,0},
			{0,2},
			{2,0},
			{2,2}
		}
		
	local hits = 0
	for _, pos in pairs(positions) do
		local posToCheck = {active_piece.pos.x + pos[1], active_piece.pos.y + pos[2]}
		if not player_matrix[posToCheck[2]] or not player_matrix[posToCheck[2]][posToCheck[1]] or player_matrix[posToCheck[2]][posToCheck[1]] > 0 then
			hits = hits + 1
		end
	end

	return hits
end

function affect_board(ef)


					for _, effect in pairs(ef) do
						
						if effect[1] == "Gravity" then
							gravity = effect[2]
						end

						if effect[1] == "MovingObjects" then
							for index, object in pairs(effect[2]) do
								if type(index) == "string" then
									if not movingObjects[index] then
										movingObjects[index] = object
									else
										for i, v in pairs(object) do
											movingObjects[index][i] = v
											print("woot")
										end
									end
								else
									table.insert(movingObjects, object)
								end
							end
						end

						if effect[1] == "WhiteScreen" then
							game.white_screen = effect[2]
						end

						if effect[1] == "AutoDrop" then
							if autodrop_skip then
								autodrop_skip = false
							else
								force_hard_drop()
							end
							
						end

						if effect[1] == "Garbage" then
							local garbageToAdd = effect[2]

							local rep = effect[3] and effect[3] or 1
							local random = math.random(1,10)

							local randomPick = {8,8,8,8,8,8,8,8,8,8}

							randomPick[random] = 0

							while rep > 0 do
								rep = rep - 1

								for i = 1, #garbageToAdd do
									for v = 2, 20 do
										player_matrix[v - 1] = player_matrix[v]
									end
								end

								for x, line in pairs(garbageToAdd) do
									if line == "RND" then line = randomPick end
									player_matrix[20 - (#garbageToAdd - x)] = clone(line)
								end
								if #garbageToAdd > 3 then game.board_live_offset[2] = game.board_live_offset[2] - 10 end
								local x = active_piece.pos.x

								active_piece.pos.y = active_piece.pos.y - #garbageToAdd
								active_piece.pos.y = active_piece.pos.y < 1 and 1 or active_piece.pos.y

								active_piece.pos.x = x
							end
						end

						if effect[1] == "NewBoard" then
							player_matrix = clone(effect[2])
							local x = active_piece.pos.x
							spawn_piece(active_piece.id)
							active_piece.pos.x = x		
							if not check_collision() then
								active_piece.pos.x = 4
							end
							--if effect[3] then playSFX(newboard_snd) end
		

							for y, row in pairs(player_matrix) do
								local test = ""
								for x, val in pairs(row) do
									if val > 0 then
										table.insert(flash_minos, {
											{x,y}, -- x and y matrix positioning
											.5, -- starting opacity
											0.0225 -- decay rate
										})										
									end
								end
								--print(test)
							end

						end

						if effect[1] == "NewPieces" then
							local pieces = effect[2]
							local translatedPieces = ""
							local translations = {
								["I"] = "1",
								["J"] = "2",
								["L"] = "3",
								["S"] = "4",
								["Z"] = "5",
								["T"] = "6",
								["O"] = "7",
							}
							if tonumber(pieces) == nil then
								for i = 1, #pieces do
									translatedPieces = translatedPieces .. translations[string.sub(pieces, i, i)]
								end
							else
								translatedPieces = pieces
							end

							if effect[3] then
								if effect[3].cleanBag == true or effect[3][2] == true then
									bag = translatedPieces
								else
									bag = translatedPieces .. bag
								end

								if effect[3].replaceActivePiece ~= true and effect[3][1] ~= true then
									nextPiece()
								end
							else
								bag = translatedPieces .. bag
								nextPiece()
							end
						end

						if effect[1] == "RandomGarbage" then
							local garbageToAdd = effect[2]
							game.board_live_offset[2] = game.board_live_offset[2] - 3
							for i = 1, garbageToAdd do
								for v = 2, 20 do
									player_matrix[v - 1] = player_matrix[v]
								end
							end

							for x = 20 - garbageToAdd + 1, 20 do
								player_matrix[x] = random_garbage_line()
							end

							if garbageToAdd > 3 then garbage_snd:play() end
							local x = active_piece.pos.x

							active_piece.pos.y = active_piece.pos.y - garbageToAdd
							active_piece.pos.y = active_piece.pos.y < 1 and 1 or active_piece.pos.y

							active_piece.pos.x = x
						end

						if effect[1] == "HardGarbage" then
							local garbageToAdd = effect[2]

							for i = 1, garbageToAdd do
								for v = 2, 20 do
									player_matrix[v - 1] = player_matrix[v]
								end
							end

							for x = 20 - garbageToAdd + 1, 20 do
								player_matrix[x] = {10,10,10,10,10,10,10,10,10,10}
							end
							if garbageToAdd > 3 and effect[3] then playSFX(garbage_snd) end
							local x = active_piece.pos.x

							active_piece.pos.y = active_piece.pos.y - garbageToAdd
							active_piece.pos.y = active_piece.pos.y < 1 and 1 or active_piece.pos.y

							active_piece.pos.x = x
						end
					end
end

function spawn_piece(id)
	local pieceToDraw = pieces[id]
	active_piece = {}
	game.replayData.pieceList = game.replayData.pieceList .. tostring(id)
	gravity_prog = 0
	active_piece.rotationGrace = .5
	active_piece.lockProgress = 0
	active_piece.id = id
	active_piece.matrix = pieceToDraw
	active_piece.pos = {}
	active_piece.pos.x = 4
	active_piece.pos.y = 1

	if #pieceToDraw == 2 then
	active_piece.pos.x = 5
	end

	active_piece.srsChecks = (id == 1 and wallKickI) or (id == 7 and wallKickO) or wallKickDefault
	active_piece.rotation = 0

	game.tweenPieceX = active_piece.pos.x
	game.tweenPieceY = active_piece.pos.y

end

function check_collision(rot, self)
	if not active_piece or not active_piece.matrix then return true end
	rot = false
	local offset = {active_piece.pos.x, active_piece.pos.y}

	local minXPos = 5
	local maxXPos = 5
	local c = false

	for y, row in pairs(active_piece.matrix) do
		for x, val in pairs(row) do
			if val > 0 then
				
				local posToCheck = get_actual_position({offset[1], offset[2]}, {x,y})

				-- this check SHOULD work but doesn't always for some reason,
				if posToCheck[1] > 10 or posToCheck[1] < 1 then
					return false
				end

				--[[if (offset[2] + (y-1)) > 20 then
					print("here's ur issue")
					return false
				end]]

				--print(offset[1] + (x-1))

				if (not player_matrix[offset[2] + (y-1)]) and y > 0 then
					return false
				end

				if y > 0 and player_matrix[offset[2] + (y-1)][offset[1] + (x-1)] > 0 then
					return false
				end
			end
		end
	end
	
	--print(minXPos .. " " .. tostring(c))

	if c then

		if minXPos == 0 then

			active_piece.pos.x = active_piece.pos.x + 1
			return check_collision()

		elseif maxXPos == 11 then
			active_piece.pos.x = active_piece.pos.x - 1
			return check_collision()
		else
			return false
		end

	end

	return true
end

function nextPiece()
	next_piece = tonumber(string.sub(bag,1,1)) == tonumber(string.sub(bag,1,1)) and tonumber(string.sub(bag,1,1)) or string.sub(bag,1,1)
	bag = string.sub(bag, 2, #bag)
	if #bag < 14 then bag = bag .. generate_bag() end
	spawn_piece(next_piece) 
	total_pieces = total_pieces + 1

	if game.beatmap and game.hpDrain and game.hpDrain > 0 and (game.maxPPS - game.avgPPS) > 1 then
		local triminos = {"a", "b", "c", "d","e","f","g"}
		local dominos = {"A"}

		local i = game.beatCount + 4
		local totalTime = (game.beatmap[i+1]) and game.beatmap[i+1] - game.beatmap[i] or 0
		local beats = 1
		local rate = beats/totalTime
		print(game.dominoThreshold..":"..rate)

		if rate >= 9999 then
			--bag = string.sub(bag, 1, 4) .. dominos[math.random(1,#dominos)] .. string.sub(bag, 6, #bag)
		elseif rate >= game.dominoThreshold then
			--bag = string.sub(bag, 1, 4) .. triminos[math.random(1,#triminos)] .. string.sub(bag, 6, #bag)
		end
	end

end

function lock_piece()

	if active_piece then
		local tspin = false
		held = false
		local offset = {active_piece.pos.x, active_piece.pos.y}
		--print(offset[2])
		for y, row in pairs(active_piece.matrix) do
			for x, val in pairs(row) do
				if val > 0 and player_matrix[offset[2] + (y-1)] then
					player_matrix[offset[2] + (y-1)][offset[1] + (x-1)] = val
				end
			end
		end	


		for y, row in pairs(player_matrix) do
			local test = ""
			for x, val in pairs(row) do
				test = test .. " " .. tostring(val)
			end
			--print(test)
		end


		if active_piece.id == 6 and last_input == "rotate" then
			local hits = check_tspin()

			if distance_dropped > 0 then
				hits = 0
			end

			if hits >= 3 then
				tspin = true
			end
		end

		distance_dropped = 0
		local back_to_back = false

		local scoring_table = {
			10,
			40,
			80,
			150
		}
		local lines = 0
		local total_lines = 0
		local add_combo = false
		local fail = 0
		repeat
			lines = 0
			fail = fail + 1
			 for i = 20, 1, -1 do
			 	local count = 0
			 	local hard = false
			 	for x, val in pairs(player_matrix[i]) do
			 		if val > 0 then count = count + 1 end
			 		if val == 10 then hard = true end
			 	end

			 	if count >= 10 and not hard then
			 		add_combo = true

			 		for v = 1, 10 do
			 			local col = game.white_screen and 0 or 1
			 			local pos = pl(v, i)
			 			table.insert(movingObjects,{
			 				img = love.graphics.newImage("/assets/flash_mino.png"),
			 				["position"] = {pos[1] + game.bumpx, pos[2] + game.bumpy},
			 				["lifetime"] = 1,
			 				["scale"] = {1,1},
			 				["opacity"] = 1,
			 				["color"] = {col, col, col},
			 				["rotation"] = 0,
			 				["velocity"] = {math.random(-3,3)/2,-1 * math.random(3)},
			 				["acceleration"] = {0,0.25},
			 				["rotVelocity"] = math.random(-1,-1) / 50,
			 				["scaleDelta"] = {-0.05, -0.05},
			 				["opacityDelta"] = -0.03
			 			})
			 		end

			 		for v = i, 2, -1 do
			 			player_matrix[v] = player_matrix[v - 1]
			 		end
			 		total_lines = total_lines + 1
			 		lines = lines + 1
			 		player_matrix[1] = {0,0,0,0,0,0,0,0,0,0}
			 	end
			 end
		until lines == 0 or fail >= 30
		game.hpFactor = (game.hpDrain/0.1)

		local line_effect = total_lines + 1
		game.hp = game.hp + 0.01 * game.hpFactor
		game.hp = game.hp + (total_lines * 0.02) * game.hpFactor
		local scoreToAdd = 0
		if total_lines == 0 and tspin then
			scoreToAdd = scoreToAdd + 50
			--play tspin sound
			playSFX(tspin_none_snd)

		end

		if total_lines == 1 and tspin then
			last_move = "T-SPIN SINGLE"
			lm_timer = 1
			scoreToAdd = scoreToAdd + 100
			stats["tspin singles"] = stats["tspin singles"] + 1
			game.hp = game.hp + 0.025 * game.hpFactor
		end

		if total_lines == 2 and tspin then
			last_move = "T-SPIN DOUBLE"
			lm_timer = 1
			scoreToAdd = scoreToAdd + 150
			stats["tspin doubles"] = stats["tspin doubles"] + 1
			game.hp = game.hp + 0.1 * game.hpFactor
		end

		if total_lines == 3 and tspin then
			last_move = "T-SPIN TRIPLE"
			lm_timer = 1
			scoreToAdd = scoreToAdd + 300
			stats["tspin triples"] = stats["tspin triples"] + 1

			playSFX(tspin_none_snd)

			game.hp = game.hp + 0.15 * game.hpFactor

		end

		if total_lines > 0 and tspin then
			playSFX(tspin_snd)


			b2b = b2b + 1
			back_to_back = true
		end

		if total_lines > 0 and total_lines < 4 and not tspin then
			b2b = -1
		end


		game_lines = game_lines + total_lines

		if mode == "Sprint" and game_lines >= lines_goal then
			game.replayPlaybackRate = 0
			game.goToResults = true
		end

		if total_lines >= 1 then

			scoreToAdd = scoreToAdd + (scoring_table[total_lines] + (10*combo))
			playSFX(lineclear_snd)


			if combo > 0 and combo <= 6 then
				playSFX(combo_sounds[combo])
			elseif combo > 6 then
				local n = math.random(3,6)
				playSFX(combo_sounds[n])

			end
			combo = combo + 1
		else
			combo = 0
		end

		if combo - 1 > stats["max combo"] then
			stats["max combo"] = combo - 1
		end

		if total_lines >= 4 then
			line_effect = line_effect + 2
			stats["tetrises"] = stats["tetrises"] + 1
			last_move = "QUAD"
			b2b = b2b + 1
			back_to_back = true
			lm_timer = 1
			game.hp = game.hp + 0.1 * game.hpFactor
			playSFX(quad_snd)

			game.board_live_offset[2] = game.board_live_offset[2] + 6
		end

		if game.beatmap and (total_time - game.lastDropTime) > 0.15 then



			for index, time in pairs(game.beatmap) do
				local accuracy = math.abs(time - total_time)
				if accuracy < game.perfectThreshold then
					game.hp = game.hp + 0.025 * game.hpFactor

					if total_lines >= 4 then
						scoreToAdd = scoreToAdd + 700
						last_move = "PERFECT QUAD"
						game.hp = game.hp + 0.2 * game.hpFactor
					elseif tspin and  total_lines == 3 then
						last_move = "PERFECT TST"
						game.hp = game.hp + 0.35 * game.hpFactor
						scoreToAdd = scoreToAdd + 1200
					elseif tspin and total_lines == 2 then
						last_move = "PERFECT TSD"
						scoreToAdd = scoreToAdd + 600
						game.hp = game.hp + 0.2 * game.hpFactor
					elseif tspin and total_lines == 1 then
						last_move = "PERFECT TSS"
						game.hp = game.hp + 0.125 * game.hpFactor
						scoreToAdd = scoreToAdd + 250
					end

					game.perfectCount = game.perfectCount + 1
					table.insert(movingObjects,{
						img = game.perfect_img,
						position = {550 + game.bumpx,500 + game.bumpy},
						scale = {220/game.perfect_img:getWidth(),24/game.perfect_img:getHeight()},
						rotation = 0,
						opacity = 1,
						opacityDelta = -0.05,
						velocity = {0,0},
						acceleration = {0,-0.2},
						lifetime = 1,
						color = {1,1,1}
					})

					scoreToAdd = scoreToAdd + 300

				elseif accuracy < game.niceThreshold then
					game.hp = game.hp + 0.0125 * game.hpFactor

					if total_lines >= 4 then
						scoreToAdd = scoreToAdd + 350
						last_move = "NICE QUAD"
						game.hp = game.hp + 0.125 * game.hpFactor
					elseif tspin and  total_lines == 3 then
						last_move = "NICE TST"
						scoreToAdd = scoreToAdd + 600
						game.hp = game.hp + 0.25 * game.hpFactor
					elseif tspin and total_lines == 2 then
						last_move = "NICE TSD"
						scoreToAdd = scoreToAdd + 350
						game.ho = game.hp + 0.125 * game.hpFactor
					elseif tspin and total_lines == 1 then
						last_move = "NICE TSS"
						scoreToAdd = scoreToAdd + 150
						game.hp = game.hp + 0.15/2 * game.hpFactor
					end

					game.niceCount = game.niceCount + 1
					table.insert(movingObjects,{
						img = game.nice_img,
						position = {600 + game.bumpx,500 + game.bumpy},
						scale = {220/game.nice_img:getWidth(),24/game.nice_img:getHeight()},
						rotation = 0,
						opacity = 1,
						opacityDelta = -0.05,
						velocity = {0,0},
						acceleration = {0,-0.2},
						lifetime = 1,
						color = {1,1,1}
					})


					scoreToAdd = scoreToAdd + 100
				end

				if accuracy < game.niceThreshold then
						local range_start = total_time - .5
						local range_end = total_time + .5
						local goal = range_end - total_time + 0.5
						local progress = time - range_start
						local ratio = progress/goal
						local x = board_offset[1] - 20 - (250*ratio)
						local y = board_offset[2] + 330
						table.insert(movingObjects, {
							img = love.graphics.newImage("/assets/skins/"..game.skin.."/beatFlash.png"),
							position = {x + game.bumpx,y + game.bumpy},
							scale = {1,1},
							color = {1,1,1},
							rotation = 0,
							velocity = {0,0},
							acceleration = {0,-0.3},
							lifetime = 5,
							opacityDelta = -0.05,
							opacity = 1,
						})

						game.beatmap[index] = nil
						game.beatCount = game.beatCount + 1
					end
			end
		end

		if b2b > 0 and back_to_back then
			line_effect = line_effect + b2b
			stats["b2bs"] = stats["b2bs"] + 1
			scoreToAdd = scoreToAdd * (3/2)
		end

		if line_effect > 25 then line_effect = 10 end
		for z = 1, line_effect do
		local scale = math.random(2,8)/2
		local offset = math.random(1,10)
			table.insert(movingObjects,{
				img = game.falling_star_img,
				scale = {1/scale/1.5, 1/(scale/2)/1.5},
				position = {math.random(0, swidth), -(75 * (scale == 1 and 3 or scale == 3 and 1 or 2))},
				rotation = 0,
				opacity = 1,
				velocity = {0, 1/(scale) - (offset/5)},
				color = {1,1,1},
				layer = 2,
				lifetime = 3/(scale == 1 and 3 or scale == 3 and 1 or 2),
				acceleration = {0,0.3 * (scale == 1 and 5 or scale == 3 and 0.7 or 1.5)},
				--scaleDelta = {-0.0005*scale, 0}
			})
		end
		score = score + scoreToAdd
		game.lastDropTime = total_time
	end

	nextPiece()
	--print(bag)
end

function restart()
	--[[total_time = 0
	if song then song:seek(0) end
	auto_drop = false
	auto_drop_wait = false
	autodrop_skip = false
	total_pieces = -1
	stats = clone(startStats)
	game.timeTilNextBeat = 100000
	score = 0
	b2b = -1
	game_lines = 0
	repeat_table = false
 	map_position = 1
 	total_time = 0
 	active_piece = false
 	start_position = 0
 	start_position_r = 0
	setup_board()
	nextPiece()]]
	if song then song:stop() song:setPitch(1) end
	if video then video:stop() end

	initGame(game.mapStuff.music, game.mapStuff.map, true)
end

function initGame(music, map, restart) -- takes song filepath (string) and map (data table)
	quad_snd:play()
	auto_drop = false
	auto_drop_wait = false
	autodrop_skip = false
	game.paused = false
	held_piece = false
	held = false
	game.goToResults = false
	board_offset = {(275),50}
	game.deathTransition = false
	game.hpBar = 0
	game.halfBeatTracker = {}
	map_data = map
	game.customDraw = map_data[1]["customDraw"]




	game.replayData.keysDown = {}
	if game.inReplay then
		--map_data[1].customBag = game.replayData.pieceList
		math.randomseed(game.replayData.seed)
		game.replayData.updatePos = 1
		game.replayData.currentCP = 1
		game.replayData.position = 1
	else
		game.replayData = {}
		game.replayData.checkpoints = {}
		game.replayData.CPcountdown = 1
		game.replayData.updatePos = 1
		game.replayData.songID = map_data[1].id
		game.replayData.songName = map_data[1].name
		game.replayData.difficulty = map_data[1].difficulty
		game.replayData.inputs = {}
		game.replayData.updates = {}
		game.replayData.pieceList = ""
		game.replayData.seed = math.random(1,999999999)
		math.randomseed(game.replayData.seed)
	end

	game.replayPlaybackRate = 1
	total_pieces = -1
	stats = clone(startStats)
	game.mapStuff = {music = music, map = map}
	if game.mapSelectSong then game.mapSelectSong:stop() end

	if mode == "Sprint" then lines_goal = 40 end

	-- beatmap analysis
	local beatmap = map_data[1].beatmap

	if beatmap then

		lengthToCheck = 1
		local maxPPS = 0
		local avgPPS = 0
		for i = 1, #beatmap - lengthToCheck do
			local totalTime = beatmap[i+lengthToCheck] - beatmap[i]
			local beats = lengthToCheck
			avgPPS = avgPPS + (beats/totalTime)
			if (beats/totalTime) >= maxPPS then maxPPS = (beats/totalTime) end
		end

		avgPPS = avgPPS / #beatmap
		game.avgPPS = avgPPS
		game.maxPPS = maxPPS

		game.dominoThreshold = maxPPS - 0.25
		game.triminoThreshold = (avgPPS + maxPPS)/2
		--return false
	end

	game.mapID = map_data[1]["id"]
	game.songName = map_data[1]["name"]
	game.songDifficulty = map_data[1]["difficulty"]

	if not restart then
		game.video = map_data[1].video and love.graphics.newVideo(map_data[1].video) or nil
		if music then song = love.audio.newSource(music, "stream") else song = false end



	 	bg_img = map_data[1]["background"] and love.graphics.newImage(map_data[1]["background"]) or game.defaultBG_img

	else
		if game.video then 
			game.video:pause()
			game.video:seek(0)
		end
		if song then song:stop() end
	end



	score = 0
	b2b = -1
	game_lines = 0
	game.bgOpacity = map_data[1].bgOpacity and map_data[1].bgOpacity or 0.5
	repeat_table = false
	movingObjects = {}
	game.flashTimes = map_data[1]["flashTimes"]
	game.hpDrain = map_data[1]["hpDrain"] and map_data[1]["hpDrain"] or 0.1
 	gravity = map_data[1]["gravity"] and map_data[1]["gravity"] or 1
 	game.initGravity = map_data[1]["gravity"] and map_data[1]["gravity"] or 1
 	lockTime = map_data[1]["lockTime"] and map_data[1]["lockTime"] or 1


 	if song then
		mode = "Map"

		game.endTime = map_data[1].endTime and map_data[1].endTime or song:getDuration()
		if map_data[1].startTime then
			song:seek(map_data[1].startTime)

			if map_data[1].beatmap then
				for index, item in pairs(map_data[1].beatmap) do
					if item <= map_data[1].startTime then
						map_data[1].beatmap[index] = nil
					end
				end

				map_data[1].beatmap = clean_table(map_data[1].beatmap)
			end

			for index, item in pairs(map_data[2]) do
				if item[1] < map_data[1].startTime then
					map_data[2][index] = nil
				end
			end

			map_data[2] = clean_table(map_data[2])
		end
	end
 	

 	game.beatmap = clone(map_data[1]["beatmap"])

 	if map_data[1]["customBag"] then
 		local tbag = map_data[1]["customBag"]
 		local newbag = ""
 		local translate = {
 			I = "1",
 			J = "2",
 			L = "3",
 			S = "4",
 			Z = "5",
 			T = "6",
 			O = "7",
 		}
 		for i = 1, #tbag do
 			if translate[string.sub(tbag, i, i)] then
 				newbag = newbag .. translate[string.sub(tbag, i, i)]
 			else
 				newbag = newbag .. string.sub(tbag,i,i)
 			end
 		end
 		game.customBag = newbag
 	else
 		game.customBag = false
 	end

 	game.origBeatmap = clone(game.beatmap)
 	game.totalBeats = map_data[1]["beatmap"] and #map_data[1]["beatmap"] or 0
 	game.approachTime = map_data[1]["approachRate"] and map_data[1]["approachRate"] or 1
 	--handling = defaultHandling
 	--if map_data[1]["handling"] then handling = map_data[1]["handling"] end
 	map_position = 1
 	total_time = 0
 	active_piece = false
 	start_position = 0
 	start_position_r = 0

 	game.startOffset = 2

 	if song then
	 	song:setVolume(game.musicVolume)
		--song:play()
		--if game.video then game.video:play() end
 	end

	setup_board()
	lock_piece()
	auto_drop = false
	flash_minos = {}
	transition("InGame")


	end

--translates locations on matrix (ex: [1,5] and converts them to an exact location onscreen)
function pl(ox,oy)
	if not ox then
		return oy*25 - 25 + board_offset[2]
	elseif not oy then
		return ox*25 - 25 + board_offset[1]
	end
	return {ox*25 - 25 + board_offset[1], oy*25 - 25 + board_offset[2]}
end


--takes two arguments: player matrix position and the position on the active piece matrix we're checking (both {x,y})
function get_actual_position(piecePos, minoPos)
	--board matrix x positions range from 1-10; y positions range from 1-20
	--mino positions in the active piece range from 1-3 or 1-4 on both axes.

	--if a mino is at (1,1) and the active piece is at (1,1) as well, we should be returning
	--board position (1,1). offsetting the mino position by (-1,-1) is necessary for this

	minoPos[1] = minoPos[1] - 1
	minoPos[2] = minoPos[2] - 1

	--after this, it should be as simple as sending the offset matrix position plus the mino offset.

	return {piecePos[1] + minoPos[1], piecePos[2] + minoPos[2]}
end

function force_hard_drop()
	local collide = false
	local distance = 0
	local fail = 0
	repeat
		fail = fail + 1
		distance_dropped = distance_dropped + 1
		active_piece.pos.y = active_piece.pos.y + 1
		collide = check_collision()
		if collide then
			distance = distance + 0.04
			for y, row in pairs(active_piece.matrix) do
				for x, val in pairs(row) do
					if val > 0 then
						local realPositions = get_actual_position({active_piece.pos.x, active_piece.pos.y}, {x,y})

						local start_opacity = distance > .75 and .75 or distance
						if piece_flash then
							table.insert(flash_minos, {
								realPositions, -- x and y matrix positioning
								start_opacity, -- starting opacity
								0.0275 -- decay rate
							})
						end
					end	
				end
			end
		end
	until not collide or fail > 30
		active_piece.pos.y = active_piece.pos.y - 1
		distance_dropped = distance_dropped - 1
	for y, row in pairs(active_piece.matrix) do
		for x, val in pairs(row) do
			if val > 0 then
				local realPositions = get_actual_position({active_piece.pos.x, active_piece.pos.y}, {x,y})
				table.insert(flash_minos, {
					realPositions, -- x and y matrix positioning
					1, -- starting opacity
					0.05 -- decay rate
				})
			end	
		end
	end

	game.board_live_offset[2] = game.board_live_offset[2] + 3
	auto_drop_wait = false
	lock_piece()

	playSFX(harddrop_snd)
	playSFX(lock_snd)

	if math.random(1,1000000) == 5 then
		playSFX(game.legend_snd)
	end

end

function top_out()
	
	movingObjects = {}
	if song then song:stop() end
		playSFX(topout_snd)
	transition("Results")
end

last_random_line_pos = 1
function random_garbage_line()
	local line = {8,8,8,8,8,8,8,8,8,8}
	local pick = math.random(1,10)
	if math.random(1,3) == 3 then
		pick = last_random_line_pos
	end

	line[pick] = 0
	last_random_line_pos = pick
	return line
end


order = {
		"D",
		"C",
		"B",
		"A",
		"S",
		"SS",
		"X"
	}

function generate_rank(type, gameScore, gameTime)
	rank_data = {
		["Sprint"] = {
			"time",
			{
				180, -- D
				150, -- C
				120, -- B
				90, --  A
				60, --  S
				45, --  SS
				30 --   X
			}
		},

		["Map"] = {
			"accuracy",
			{
				.5,  -- D
				.6,  -- C
				.7,  -- B
				.8, -- A
				.9, -- S
				.95, -- SS
				1    -- X
			}
		}

	}


	local rank = "?"
	local game_rank_data = rank_data[type]


	--print(tostring(game_rank_data))
	if game_rank_data then
			local scoreTable = game_rank_data[2]

		if game_rank_data[1] == "time" then
			rank = "E"
			for i = 1, #scoreTable do
				if total_time <= scoreTable[i] then
					rank = order[i]
				end
			end
		end

		if game_rank_data[1] == "accuracy" then

			rank = "E"

			if game.accuracy == 0 then rank = "?" end

			for i = 1, #scoreTable do
				if game.accuracy >= scoreTable[i] then
					rank = order[i]
				end
			end
		end

		if game_rank_data[1] == "score" then
			rank = "E"
			for i = 1, #scoreTable do
				if gameScore >= scoreTable[i] then
					rank = order[i]
				end
			end
		end		
	end

	if rank == "SS" and game.missCount > 0 then
		rank = "S"
	end

	if game.hpDrain == 0 then rank = "P" end

	if game.deathTransition then rank = "F" end

	return rank
end







function playSFX(sound)
	if type(sound) == "string" then sound = love.audio.newSource(sound) end

	sound:setVolume(data.volume.sfx)

	sound:stop()
	sound:play()

end

local lfs = love.filesystem



local function enu(folder, saveDir)
	local filesTable = lfs.getDirectoryItems(folder)
	if saveDir ~= "" and not lfs.getInfo(saveDir).type == "directory" then lfs.createDirectory(saveDir) end
   


	for i,v in ipairs(filesTable) do
		local file = folder.."/"..v
		local saveFile = saveDir.."/"..v
		if saveDir == "" then saveFile = v end
      
		if lfs.getInfo(file).type == "directory" then
			lfs.createDirectory(saveFile)
			enu(file, saveFile)
		else
			lfs.write(saveFile, tostring(lfs.read(file)))
		end
	end
end

function extractZIP(file, dir, delete)
	local dir = dir or ""
	local temp = tostring(math.random(1000, 2000))
	success = lfs.mount(file, temp)
		if success then enu(temp, dir) end
	lfs.unmount(file)
	if delete then lfs.remove(file) end
end


--[[
scoreData: {
	[mapID],
	[score],
	[rank],
	[accuracy]
}
]]
function save(pass, pass2)
	local d = create_data(pass, pass2)

	d.controls = clone(key)
	d.handling = clone(handling)

	love.filesystem.write(dataName, TSerial.pack(d, {}, true))
	last_data = clone(data)
	print("saving")
end

function updateRecords(scoreData)
	local scoreExists = data.scores[scoreData.mapID]

	if not scoreExists or scoreExists.score <= scoreData.score then
		data[scoreData.mapID] = clone(scoreData)

		playSFX(highScore_snd)
		game.highScore = true
	else
		game.highScore = false
	end

	save()
end

function cleanString(str)
	str = str:gsub('[%p%c%s]', '')
	return str
end

function changeMapSelectSong()
	local clonedSong = game.mapSelectSong and game.mapSelectSong:clone() or nil
	if clonedSong then
		clonedSong:seek(game.mapSelectSong:tell()) 
		clonedSong:setVolume(game.mapSelectSong:getVolume())
		clonedSong:play() 
	end
	if game.mapSelectSong then game.mapSelectSong:stop() game.mapSelectSong:release() end
	if clonedSong then table.insert(game.songFadeOut, clonedSong) end
	if game.mapListing[game.selectedMap].mappings[game.selectedDifficulty] then
		game.mapSelectSong = love.audio.newSource(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].song, "stream")
		game.mapSelectSong:setVolume(0)
		local previewTime = game.mapListing[game.selectedMap].mappings[1][1].previewTime and game.mapListing[game.selectedMap].mappings[1][1].previewTime or game.mapSelectSong:getDuration()/2

		game.mapSelectSong:seek(previewTime)

		game.mapSelectSong:play()
	end

	--if game.transitionTime <= 0 then game.mapSelectSong:play() end
end

		
function transition(goal)
	if goal == "Menu" or goal == "MapSelect" or goal == "NewMapSelect" then data = TSerial.unpack(love.filesystem.read(dataName)) end

	if game_state == "Menu" then
		maps = collectMaps({"maps", "assets/internal_maps"})
	end

	game.updateDelay = false

	game.mapSelectSong = nil
	game.menuFlashPos = 1
	game.selectedResultsItem = 2
	game.transitionGoal = goal
	game.transitionTime = .7
	movingObjects["transition"] = { --fine
		img = flashmino_img,
		scale = {250,250},
		position = {0,game.sheight},
		layer = 3,
		color = {0,0,0},
		lifetime = 1,
		opacity = 1,
		velocity = {0,0},
		acceleration = {0,-3}
		--opacityDelta = 0.05,
	}	

	for i, item in pairs(game.songFadeOut) do
		item:stop()
		item:release()
		game.songFadeOut[i] = nil
	end

	if game.mapSelectSong then game.mapSelectSong:stop() end


	if song and song:tell() < 5 then song:stop() end


	if game.mapSelectSong and goal == "InGame" then game.mapSelectSong:stop() end
end

--[[ map list struct
		
	{
		{
			name = MapName,
			artist = ArtistName,
			length = SongLength,
			high_score = HighScore,
			map_id = MapID,
			mappings = {
				"Easy" = map,
				"Normal" = map, 
				etc.
			}
		}
	}
]]

function generateMapList(source)
	local idList = {}
	local returnTable = {}
	for _, map in ipairs(source) do
		local mapData = map[1]

		if not idList[mapData.id] then
			table.insert(returnTable,{
				name = mapData.name,
				artist = mapData.artist,
				length = mapData.length,
				map_id = mapData.id,
				mappings = {
					map
				},
				flash_table = mapData.flashTimes,
				hpDrain = mapData.hpDrain and mapData.hpDrain or 0.1,
				previewTime = mapData.previewTime
			})
		

			idList[mapData.id] = #returnTable
		else
			table.insert(returnTable[idList[mapData.id] ].mappings, map)
		end

	end

	return returnTable
end

function sum(t)
    local sum = 0
    for k,v in pairs(t) do
        sum = sum + v
    end

    return sum
end

function drawMovingObjects(layer)
	local cnt = 0
	for index, object in pairs(movingObjects) do
		cnt = cnt + 1
		local bx = 0
		local by = 0
		if object.bumpPosition then
			bx = game.bumpx
			by = game.bumpy
		end

		if not object.scaleOffset then
			object.scaleOffset = {0,0}
		end

		if not object.color then
			object.color = {1,1,1}
		end

		if not object.position then 
			object.position = {0,0}
		end

		if not object.scale then
			object.scale = {1,1}
		end

		if not object.rotation then
			object.rotation = 0
		end

		if not object.opacity then
			object.opacity = 1
		end

		if object.friction and object.velocity then
			object.velocity[1] = object.velocity[1] / (object.friction[1] * 60 * game.dt)
			object.velocity[2] = object.velocity[2] / (object.friction[2] * 60 * game.dt)

		end

		if (not object.layer and layer == 3) or object.layer == layer then
			love.graphics.push()
			love.graphics.setColor(object.color[1], object.color[2], object.color[3], object.opacity)
			if object.img then
				love.graphics.draw(object.img, object.position[1] + bx, object.position[2] + by, object.rotation, object.scale[1], object.scale[2], object.scaleOffset[1], object.scaleOffset[2])
			elseif object.text then
				love.graphics.print(object.text, object.position[1] + bx, object.position[2] + by, object.rotation, object.scale[1], object.scale[2], object.scaleOffset[1], object.scaleOffset[2])
				
			end
			love.graphics.pop()
		end
	end
end

function clone( Table, Cache ) -- Makes a deep copy of a table. 
    if type( Table ) ~= 'table' then
        return Table
    end

    Cache = Cache or {}
    if Cache[Table] then
        return Cache[Table]
    end

    local New = {}
    Cache[Table] = New
    for Key, Value in pairs( Table ) do
        New[clone( Key, Cache)] = clone( Value, Cache )
    end

    return New
end


selected_resolution = false
fullscreen = false
function toggleFull()
	if fullscreen then
		love.window.setFullscreen(false)
		love.window.setMode(resolutions[selected_resolution][1], resolutions[selected_resolution][2], {resizable=true, minwidth=800, minheight=600})
	else

		--love.window.setMode(1280, 720)
		love.window.setFullscreen(true, "desktop")
	end
	
	fullscreen = not fullscreen
end

function clean_table(tab)
	local tab2 = {}

	for _, item in pairs(tab) do
		table.insert(tab2, item)
	end

	return tab2
end

function f.generate_timestamp(input)
	local minutes = 0
	local seconds = math.floor(input)
	local ms = input - math.floor(input)

	while seconds > 59 do
		seconds = seconds - 60
		minutes = minutes + 1
	end

	if minutes < 10 then
		minutes = "0" .. tostring(minutes)
	end

	if seconds < 10 then
		seconds = "0" .. tostring(seconds)
	end

	ms = math.floor(ms*100)/100

	if string.len(ms) == 3 then
		ms = string.sub(tostring(ms), 2,#tostring(ms)) .. "0"
	else
		ms = string.sub(tostring(ms), 2,#tostring(ms))
	end
	return minutes..":"..seconds..ms
end


























function math.clamp(val, min, max)
    return math.min(math.max(val, min), max)
end

function pause()
	playSFX(hold_snd)
	game.pauseFrame = true
	game.paused = not game.paused
	game.pauseItem = 1
	if song then
		if game.paused then
			song:pause()
			game.pauseOpacity = 0
		else
			song:play()
		end
	end

	print(game.paused)
end

function checkForInput(input, gamepad, realInput)


	if love.keyboard.isDown("lctrl") and love.keyboard.isDown("lalt") and love.keyboard.isDown("e") then
			game_state = "Editor"
	end

	game.pauseFrame = false 

	if game.transitionTime > 0 then return end

	if input == "f11" then
		toggleFull()
	end

	if game_state == "InGame" and game.paused then

		if input == "escape" then
			pause()
			
		end



		if input == "up" or input == "w" then
			game.pauseItem = game.pauseItem - 1
			playSFX(tclick_snd)
		end

		if input == "down" or input == "s" then
			game.pauseItem = game.pauseItem + 1
			playSFX(tclick_snd)
		end

		if input == "return" then
			playSFX(harddrop_snd)

			if game.pauseOptions[game.pauseItem] == "Resume" then
				pause()
			end

			if game.pauseOptions[game.pauseItem] == "Restart" then
				restart()
			end

			if game.pauseOptions[game.pauseItem] == "Return to Menu" then
				pause()
				if song then song:stop() end
				transition(mode == "Map" and "NewMapSelect" or "Menu")

				playSFX(quad_snd)
			end		


		end

		game.pauseItem = math.clamp(game.pauseItem, 1, #game.pauseOptions)

	end

	if game_state == "InGame" and not game.paused then
		if game.deathTransition then return end

		if input == key.restart then
			restart()
		end

		if input == "escape" and not game.pauseFrame then
			pause()

		end

		if (song and not song:isPlaying()) or (game.inReplay and realInput) or game.startOffset > 0 then -- don't allow input if playing a replay
			return
		end

		if input == key.harddrop then
			
			if auto_drop then

				if not auto_drop_wait and total_time - start_position_r > 0.2 then
					local fail = 0
					repeat
						fail = fail + 1
						active_piece.pos.y = active_piece.pos.y + 1
					until not check_collision() or fail > 30
					
					active_piece.pos.y = active_piece.pos.y - 1
					playSFX(lockwait_sound)
					--auto_drop_wait = true
				end
				
			else
				force_hard_drop()
			end

			last_input = "harddrop"

		end


		if input == key.hold and not held and not auto_drop_wait then
			held = true
			if not auto_drop or (total_time - start_position_r) > 0.075 then

				if auto_drop then
					if (map_data[2][map_position-1][3]) - (total_time - start_position_r) < 0.15 then
						autodrop_skip = true
					end
				end

			if game.beatmap and (total_time - game.lastDropTime) > 0.15 then
				for index, time in pairs(game.beatmap) do
					local accuracy = math.abs(time - total_time)

					if accuracy < game.perfectThreshold then
						playSFX(game.holdSave_snd)
						game.perfectCount = game.perfectCount + 1

						table.insert(movingObjects,{
							img = game.perfect_img,
							position = {600 + game.bumpx,500 + game.bumpy},
							scale = {220/game.perfect_img:getWidth(),24/game.perfect_img:getHeight()},
							rotation = 0,
							opacity = 1,
							opacityDelta = -0.05,
							velocity = {0,0},
							acceleration = {0,-0.2},
							lifetime = 1,
							color = {1,1,1}
						})

						game.beatmap[index] = nil
						game.beatCount = game.beatCount + 1			
						score = score + 150

					elseif accuracy < game.niceThreshold then
						playSFX(game.holdSave_snd)
						game.niceCount = game.niceCount + 1

						table.insert(movingObjects,{
							img = game.nice_img,
							position = {600 + game.bumpx,500 + game.bumpy},
							scale = {220/game.nice_img:getWidth(),24/game.nice_img:getHeight()},
							rotation = 0,
							opacity = 1,
							opacityDelta = -0.05,
							velocity = {0,0},
							acceleration = {0,-0.2},
							lifetime = 1,
							color = {1,1,1}
						})
						local range_start = total_time - .5
						local range_end = total_time + .5
						local goal = range_end - total_time + 0.5
						local progress = time - range_start
						local ratio = progress/goal
						local x = board_offset[1] - 20 - (250*ratio)
						local y = board_offset[2] + 330
						table.insert(movingObjects, {
							img = love.graphics.newImage("/assets/skins/"..game.skin.."/beatFlash.png"),
							position = {x + game.bumpx,y + game.bumpy},
							scale = {1,1},
							color = {1,1,1},
							rotation = 0,
							velocity = {0,0},
							acceleration = {0,-0.3},
							lifetime = 5,
							opacityDelta = -0.05,
							opacity = 1,
						})

						game.beatmap[index] = nil
						game.beatCount = game.beatCount + 1		
						score = score + 75	
					end


				end
			end
				
				if not held_piece then
					held_piece = active_piece.id
					nextPiece()
				else
					local p = active_piece.id
					spawn_piece(held_piece)
					held_piece = p
				end

				playSFX(hold_snd)
			end


		end



		if input == key.cwrotate and not auto_drop_wait then
			active_piece.matrix = rotateCW(active_piece.matrix)


			local success = false
			local kickList = {{0,0}}
			local originalPos = {active_piece.pos.x, active_piece.pos.y}

			if active_piece.rotation == 1 then
				kickList = active_piece.srsChecks[3]
			elseif active_piece.rotation == 2 then
				kickList = active_piece.srsChecks[5]
			elseif active_piece.rotation == 3 then
				kickList = active_piece.srsChecks[7]
			elseif active_piece.rotation == 0 then
				kickList = active_piece.srsChecks[1]
			end
			
			for _, kickOffset in pairs(kickList) do
				if not success then
					--print("checking collision for " .. tostring(kickOffset[1]) .. ", " .. tostring(kickOffset[2]))
					active_piece.pos.x = originalPos[1] + kickOffset[1]
					active_piece.pos.y = originalPos[2] - kickOffset[2]
					success = check_collision(true)
				end
			end

			if success then
				last_input = "rotate"

				if active_piece.id == 6 and check_tspin() > 2 then
					playSFX(tclick_snd)
				end
			end
			if not check_collision() then
				active_piece.matrix = rotateCCW(active_piece.matrix)
				active_piece.pos.x = originalPos[1]
				active_piece.pos.y = originalPos[2]
			else
				active_piece.lockProgress = active_piece.lockProgress - active_piece.rotationGrace
				if active_piece.lockProgress == 0 then active_piece.lockProgress = 0 end

				active_piece.rotationGrace = active_piece.rotationGrace * 0.7
				playSFX(rotate_snd)
				active_piece.rotation = active_piece.rotation + 1
				if active_piece.rotation > 3 then
					active_piece.rotation = 0
				end
			end

		elseif input == key.ccwrotate and not auto_drop_wait then
			active_piece.matrix = rotateCCW(active_piece.matrix)

			local success = false
			local kickList = {{0,0}}
			local originalPos = {active_piece.pos.x, active_piece.pos.y}

			if active_piece.rotation == 1 then
				kickList = active_piece.srsChecks[2]
			elseif active_piece.rotation == 2 then
				kickList = active_piece.srsChecks[4]
			elseif active_piece.rotation == 3 then
				kickList = active_piece.srsChecks[6]
			elseif active_piece.rotation == 0 then
				kickList = active_piece.srsChecks[8]
			end
			
			for _, kickOffset in pairs(kickList) do
				if not success then
					active_piece.pos.x = originalPos[1] + kickOffset[1]
					active_piece.pos.y = originalPos[2] - kickOffset[2]
					success = check_collision(true)
				end
			end

			if success then
				last_input = "rotate"

				if active_piece.id == 6 and check_tspin() > 2 then
					playSFX(tclick_snd)
				end
			end

			if not check_collision() then
				active_piece.matrix = rotateCW(active_piece.matrix)
				active_piece.pos.x = originalPos[1]
				active_piece.pos.y = originalPos[2]
			else
				playSFX(rotate_snd)
				active_piece.rotation = active_piece.rotation - 1
				if active_piece.rotation < 0 then
					active_piece.rotation = 3
				end

			end

		elseif input == key.rotate180 and not auto_drop_wait then

			active_piece.matrix = rotateCCW(rotateCCW(active_piece.matrix))

			local success = false
			local kickList = {{0,0}}
			local originalPos = {active_piece.pos.x, active_piece.pos.y}

			if active_piece.rotation == 1 then
				kickList = active_piece.srsChecks[2]
			elseif active_piece.rotation == 2 then
				kickList = active_piece.srsChecks[4]
			elseif active_piece.rotation == 3 then
				kickList = active_piece.srsChecks[6]
			elseif active_piece.rotation == 0 then
				kickList = active_piece.srsChecks[8]
			end
			
			for _, kickOffset in pairs(kickList) do
				if not success then
					active_piece.pos.x = originalPos[1] + kickOffset[1]
					active_piece.pos.y = originalPos[2] - kickOffset[2]
					success = check_collision(true)
				end
			end

			if success then
				last_input = "rotate"

				if active_piece.id == 6 and check_tspin() > 2 then
					playSFX(tclick_snd)
				end
			end

			if not check_collision() then
				active_piece.matrix = rotateCW(rotateCW(active_piece.matrix))
				active_piece.pos.x = originalPos[1]
				active_piece.pos.y = originalPos[2]
			else
				playSFX(rotate_snd)
				active_piece.rotation = active_piece.rotation + 2
				if active_piece.rotation > 3 then
					active_piece.rotation = active_piece.rotation - 4
				end

			end
		end

		if (input == key.rotate180) or (input == key.cwrotate) or (input == key.ccwrotate) then
			game.tweenPieceX = active_piece.pos.x
			game.tweenPieceY = active_piece.pos.y
		end
		--[[if (input == key.rotate180) and not auto_drop_wait then

		local gotAny = false
		local originalPos = {active_piece.pos.x, active_piece.pos.y}

			active_piece.matrix = rotateCW(rotateCW(active_piece.matrix))

			local success = false
			local kickList = {{0,0}}

			if active_piece.rotation == 1 then
				kickList = active_piece.srsChecks[3]
			elseif active_piece.rotation == 2 then
				kickList = active_piece.srsChecks[5]
			elseif active_piece.rotation == 3 then
				kickList = active_piece.srsChecks[7]
			elseif active_piece.rotation == 0 then
				kickList = active_piece.srsChecks[1]
			end
			
			for _, kickOffset in pairs(kickList) do
				if not success then
					--print("checking collision for " .. tostring(kickOffset[1]) .. ", " .. tostring(kickOffset[2]))
					active_piece.pos.x = originalPos[1] + kickOffset[1]
					active_piece.pos.y = originalPos[2] - kickOffset[2]
					success = check_collision(true)
					if success then gotAny = true end
				end
			end


		

			if success then
				last_input = "rotate"

				if active_piece.id == 6 and check_tspin() > 2 then
					playSFX(tclick_snd)
				end
			end

			if not check_collision() then
				active_piece.matrix = rotateCCW(rotateCCW(active_piece.matrix))
				active_piece.pos.x = originalPos[1]
				active_piece.pos.y = originalPos[2]
			else
				active_piece.lockProgress = active_piece.lockProgress - active_piece.rotationGrace
				if active_piece.lockProgress == 0 then active_piece.lockProgress = 0 end

				active_piece.rotationGrace = active_piece.rotationGrace * 0.7
				playSFX(rotate_snd)

				active_piece.rotation = active_piece.rotation + 2
				if active_piece.rotation == 4 then
					active_piece.rotation = 0
				elseif active_piece.rotation == 5 then
					active_piece.rotation = 1
				end
			end
		end]]

		if input == key.left and not auto_drop_wait then
			das_prog = 0
			active_piece.pos.x = active_piece.pos.x - 1
			if not check_collision() then
				active_piece.pos.x = active_piece.pos.x + 1
			else
				last_input = "move"
				playSFX(move_snd)
			end
		end

		if input == key.right and not auto_drop_wait then
			das_prog = 0
			active_piece.pos.x = active_piece.pos.x + 1
			if not check_collision() then
				active_piece.pos.x = active_piece.pos.x - 1
			else
				last_input = "move"
				playSFX(move_snd)
			end
		end


	elseif game_state == "Menu" then
		mode = "Standard"
		if (input == "w" or input == "up") and not waitingForInput then
			selected_menu_item = selected_menu_item - 1
			playSFX(tclick_snd)
		end

		if (input == "s" or input == "down") and not waitingForInput then
			playSFX(tclick_snd)
			selected_menu_item = selected_menu_item + 1
		end

		if (input == "a" or input == "d" or input == "left" or input == "right") and not waitingForInput then
			if input == "a" or input == "left" then
				input = key.left
			end
			playSFX(harddrop_snd)

			if menuItems[selected_menu_item] == "Delayed Auto Shift" then
				handling.das = handling.das + 0.01 * (input == key.left and -1 or 1)
				if (handling.das * 1000) < 10 then
					handling.das = 0
				end
			end

			if menuItems[selected_menu_item] == "Background Opacity" then
				data.bgOpacity = data.bgOpacity + (0.05 * (input == key.left and -1 or 1))
				if data.bgOpacity < 0.025 then
					data.bgOpacity = 0
				end

				if data.bgOpacity > 0.975 then
					data.bgOpacity = 1
				end
			end

			if menuItems[selected_menu_item] == "Piece Flash" then
				piece_flash = not piece_flash
			end



			if menuItems[selected_menu_item] == "-Song Offset:" then
				game.mapGen.offset = game.mapGen.offset + (0.1 * (input == key.left and -1 or 1))

				if game.songSample then game.mapGen.offset = math.clamp(game.mapGen.offset, 0, game.songSample:getDuration()) end
			end

			if menuItems[selected_menu_item] == "-Song BPM:" then
				game.mapGen.bpm = game.mapGen.bpm + (0.5 * (input == key.left and -1 or 1))

			end

			if menuItems[selected_menu_item] == "-Song Start Time:" then
				game.mapGen.startTime = game.mapGen.startTime + (0.5 * (input == key.left and -1 or 1))

				if game.songSample then game.mapGen.startTime = math.clamp(game.mapGen.startTime, 0, game.songSample:getDuration()) end
			end

			if menuItems[selected_menu_item] == "-Song End Time:" then
				game.mapGen.endTime = game.mapGen.endTime + (1 * (input == key.left and -1 or 1))

				if game.songSample then game.mapGen.endTime = math.clamp(game.mapGen.endTime, 0, game.songSample:getDuration()) end

			end

			if menuItems[selected_menu_item] == "-Song Preview Time:" then
				game.mapGen.previewTime = game.mapGen.previewTime + (0.5 * (input == key.left and -1 or 1))
				if game.songSample then game.mapGen.previewTime = math.clamp(game.mapGen.previewTime, 0, game.songSample:getDuration()) end

			end



			if menuItems[selected_menu_item] == "Active Piece Movement" then
				data.misc.smoothMovement = data.misc.smoothMovement + (1 * (input == key.left and -1 or 1))

				if data.misc.smoothMovement > 2 then data.misc.smoothMovement = 2 end
				if data.misc.smoothMovement < 0 then data.misc.smoothMovement = 0 end 
			end

			if menuItems[selected_menu_item] == "Approach Piece Location" then
				data.approachMinoPos = data.approachMinoPos + (1 * (input == key.left and -1 or 1))

				if data.approachMinoPos > 2 then data.approachMinoPos = 2 end
				if data.approachMinoPos < 0 then data.approachMinoPos = 0 end 
			end

			if menuItems[selected_menu_item] == "Screen Zoom" then
				data.boardZoom = data.boardZoom + (1 * (input == key.left and -1 or 1))

				if data.boardZoom > 5 then data.boardZoom = 5 end
				if data.boardZoom < 1 then data.boardZoom = 1 end 
			end

			if menuItems[selected_menu_item] == "Board Background" then
				bg_color = bg_color + (1 * (input == key.left and -1 or 1))

				if bg_color > 3 then bg_color = 1 end
				if bg_color < 1 then bg_color = 3 end
			end

			if menuItems[selected_menu_item] == "Master Volume" then
				data.volume.master = data.volume.master + (.05 * (input == key.left and -1 or 1))

				if data.volume.master > 1 then data.volume.master = 1 end
				if data.volume.master < 0 then data.volume.master = 0 end
			end

			if menuItems[selected_menu_item] == "Music Volume" then
				data.volume.music = data.volume.music + (.05 * (input == key.left and -1 or 1))

				if data.volume.music > 1 then data.volume.music = 1 end
				if data.volume.music < 0 then data.volume.music = 0 end
			end

			if menuItems[selected_menu_item] == "SFX Volume" then
				data.volume.sfx = data.volume.sfx + (.05 * (input == key.left and -1 or 1))

				if data.volume.sfx > 1 then data.volume.sfx = 1 end
				if data.volume.sfx < 0 then data.volume.sfx = 0 end
			end

			if menuItems[selected_menu_item] == "Tetromino Design" then
				selected_mino = selected_mino + 1 * (input == key.left and -1 or 1)
				if selected_mino > mino_skin_counter then
					selected_mino = 1
				elseif selected_mino < 1 then
					selected_mino = mino_skin_counter
				end

				mino_img = love.graphics.newImage("/assets/skins/"..game.skin.."/minos/"..selected_mino..".png")
			end

			if menuItems[selected_menu_item] == "Set Resolution" and not fullscreen then
				selected_resolution = selected_resolution + (1 * (input == key.left and -1 or 1))
				if selected_resolution > #resolutions then
					selected_resolution = 1
				elseif selected_resolution < 1 then
					selected_resolution = #resolutions
				end

				love.window.setMode(resolutions[selected_resolution][1], resolutions[selected_resolution][2])
			end

			if menuItems[selected_menu_item] == "Automatic Repeat Rate" then
				local workValue = 1/handling.arr
				print(workValue)
				if handling.arr == 0 and input == key.left then
					workValue = 55
				end	
				workValue = workValue + (5 * (input == key.left and -1 or 1))
				if workValue < 5 then workValue = 1 end
				if workValue == 6 then workValue = 5 end
				handling.arr = 1/workValue

				if workValue > 50 then
					handling.arr = 0
				end
			end

			if menuItems[selected_menu_item] == "Soft Drop Rate" then
				handling.sdr = handling.sdr + 2 * (input == key.left and -1 or 1)
				if (handling.sdr) > 60 then
					handling.sdr = 60
				end
				if handling.sdr < 2 then
					handling.sdr = 2
				end
			end
		end

		if selected_menu_item > #menuItems then
			selected_menu_item = 1
		end

		if selected_menu_item < 1 then
			selected_menu_item = #menuItems
		end

		if input == "delete" and not waitingForInput then
			key =clone(defaultControls)
		end

		if input == "delete" and waitingForInput then
			waitingForInput = false
		end

		local waitedForInput = false
		if waitingForInput then
			local setting = menuItems[selected_menu_item]
			print(setting)
			if not gamepad then
				if setting == "Move Piece Left"  then
					key.left = input
				end	

				if setting == "Move Piece Right" then
					key.right = input
				end	

				if setting == "Soft Drop" then
					key.softdrop = input
				end	

				if setting == "Hard Drop" then
					key.harddrop = input
				end	

				if setting == "Rotate CW (Right)" then
					key.cwrotate = input
				end	

				if setting == "Rotate CCW (Left)" then
					key.ccwrotate = input
				end	

				if setting == "Rotate 180 Degrees" then
					key.rotate180 = input
				end	

				if setting == "Hold Piece" then
					key.hold = input
				end	

				if setting == "Quick Restart" then
					key.restart = input
				end
	 		else
				if setting == "-Move Piece Left" then
					data.gamepadControls.left = input
				end	

				if setting == "-Move Piece Right" then
					data.gamepadControls.right = input
				end	

				if setting == "-Soft Drop" then
					data.gamepadControls.softdrop = input
				end	

				if setting == "-Hard Drop" then
					data.gamepadControls.harddrop = input
				end	

				if setting == "-Rotate CW (Right)" then
					data.gamepadControls.cwrotate = input
				end	

				if setting == "-Rotate CCW (Left)" then
					data.gamepadControls.ccwrotate = input
				end	

				if setting == "-Rotate 180 Degrees" then
					data.gamepadControls.rotate180 = input
				end	

				if setting == "-Hold Piece" then
					data.gamepadControls.hold = input
				end	
			end
			
			waitingForInput = false
			print("waitingForInput ".. tostring(waitingForInput))
			waitedForInput = true
		end
		print(input)
		print("waitedForInput "..tostring(waitedForInput))
		if input == "return" and not waitingForInput and not waitedForInput then
			save(nil, true)
			

			selectedLevel = menuItems[selected_menu_item]

			if selectedLevel == "PLAY" or selectedLevel == "Back to Mode Select" then
				playSFX(lineclear_snd)

				transition("NewMapSelect")
				

				--game_state = "MapSelect"
			end

			if selectedLevel == "Set up controls" then
				menuItems = setupControlsMenu
			end

			if selectedLevel == "-Test Beatmap" then
				menuItems = testMapMenu				
			end

			if selectedLevel == "-Start Test" then
				
				newMap = {
								{
									["name"] = "Test Map",
									["artist"] = "???",
									["difficulty"] = "Normal",
									["id"] = -99999999999,
									["gravity"] = 1,
									["lockTime"] = 1, 
									["beatmap"] = {},
									["flashTimes"] = {},
								},
								{

								}
							}

				local c = 1
				for i = game.mapGen.offset + (60/game.mapGen.bpm * 4 * (1/game.mapGen.speed)), game.songSample:getDuration(), 60/game.mapGen.bpm * 4 * (1/game.mapGen.speed) do
					newMap[1].beatmap[c] = i
					c=c+1
					--print("inserting")
					if math.floor(c/4) == c/4 then
						newMap[1].flashTimes[c] = i
					end
				end 

				local file = love.filesystem.newFile("temp/map.lua", "w")

				file:write(TSerial.pack(newMap, {}, true))

				file:close()


				initGame("temp/song.mp3", clone(newMap))

			end

			if selectedLevel == "-Keyboard Controls" then
				menuItems = firstControlsMenu
			end

			if selectedLevel == "-Gamepad Controls" then
				menuItems = firstGamepadMenu
			end			

			if selectedLevel == "Use default controls (guideline)" or selectedLevel == "Let's go!" then
				initGame("assets/internal_maps/tutorial/song.mp3",TSerial.unpack(love.filesystem.read("/assets/internal_maps/tutorial/map/1.lua")))
			end

			if selectedLevel == "QUIT" then
				love.event.quit()
			end

			if selectedLevel == "OPTIONS" or selectedLevel == "Back to Options" or selectedLevel == "Return to Options" then
				menuItems = optionsMenu
			end

			if selectedLevel == "HANDLING" or selectedLevel == "Back to Gameplay Options" then
				menuItems = handlingMenu
			end

			if selectedLevel == "KEYBOARD CONTROLS" then
				menuItems = controlsMenu
			end

			if selectedLevel == "GAMEPAD CONTROLS" then
				menuItems = gamepadMenu
			end

			if selectedLevel == "GAMEPLAY" then
				menuItems = gameplayMenu
			end

			if selectedLevel == "PRESET: Default" then
				handling = clone(defaultHandling)
			end

			if selectedLevel == "PRESET: Slow" then
				handling = clone(slowHandling)
			end

			if selectedLevel == "40 Line Sprint" then
				mode = "Sprint"
				initGame(false, game.sprintMap)
			end

			if selectedLevel == "Basic Beatmap Generator" or selectedLevel == "Back to Map Generator" then
				menuItems = beatmapGenMenu
			end

			if selectedLevel == "Free Play" then
				mode = "Freeplay"
				initGame(false, game.sprintMap)
			end

			if selectedLevel == "PRESET: Quick" then
				handling = clone(fastHandling)
			end

			if selectedLevel == "CAMPAIGN" then
				menuItems = levelSelectMenu
			end	

			if selectedLevel == "CLASSIC" or selectedLevel == "Back to Classic Modes" then
				menuItems = classicModes
			end				

			if selectedLevel == "EXTRAS" or selectedLevel == "Back to Extras" then
				menuItems = extrasMenu
			end				

			if selectedLevel == "VIDEO" then
				menuItems = videoSettings
			end

			if selectedLevel == "SOUND" then
				menuItems = soundMenu
			end

				

			if not waitedForInput then
				local checks = {
					"Move Piece Left",
					"Move Piece Right",
					"Soft Drop",
					"Hard Drop",
					"Rotate CW (Right)",
					"Rotate CCW (Left)",
					"Rotate 180 Degrees",
					"Hold Piece",
					"Quick Restart"
				}
				for _, check in pairs(checks) do
					if selectedLevel == check then
						waitingForInput = true
						game.controllerInput = false
					end

					if selectedLevel == "-"..check then
						waitingForInput = true
						game.controllerInput = true
					end
				end
			end

			if selectedLevel == "Toggle Fullscreen" then
				toggleFull()
			end

			if selectedLevel == "Back to Main Menu" then
				menuItems = mainMenu
			end

			if not waitingForInput then selected_menu_item = 1 end

			playSFX(hold_snd)

		end

		--print(input)
	elseif game_state == "Results" then

		if input == "r" then

		end

		if input == "left" or input == "a" then
			game.selectedResultsItem = game.selectedResultsItem - 1
			playSFX(tclick_snd)
		end

		if input == "right" or input == "d" then
			game.selectedResultsItem = game.selectedResultsItem + 1
			playSFX(tclick_snd)
		end

		game.selectedResultsItem = math.clamp(game.selectedResultsItem, 1, 3)

		if input == "return" then
			playSFX(hold_snd)



			if game.viewingTutorial == true then
				menuItems = mainMenu
			end

			if game.selectedResultsItem == 2 then
				transition((mode == "Map" and not game.viewingTutorial) and "NewMapSelect" or "Menu")
			elseif game.selectedResultsItem == 1 then
				game.inReplay = true
				game.replayTransition = true
				restart()
			else
				game.inReplay = false
				game.replayTransition = false
				restart()
			end
		end

	elseif game_state == "Editor" then

		print(input)

		if input == "kp+" or input == "kp-" then
			local amount = 0.1
			if love.keyboard.isDown("lshift") then amount = 0.01 end

			if love.keyboard.isDown("lctrl") then
				for i, item in pairs(editor.timestamps) do
					editor.timestamps[i][1] = editor.timestamps[i][1] + amount * (input == "kp+" and 1 or -1)
				end
			elseif editor.timestamps and editor.timestamps[editor.selectedBeat] then
				editor.timestamps[editor.selectedBeat][1] = editor.timestamps[editor.selectedBeat][1] + amount * (input == "kp+" and 1 or -1)
			end
		end

		if input == "up" or input == "down" then
			editor.selectedBeat = editor.selectedBeat + (1 * (input == "down" and 1 or -1))
		end

		if input == "left" or input == "right" then
			editor.selectedBeat = editor.selectedBeat + (32 * (input == "right" and 1 or -1))
		end



		if input == "g" then
			if editor.state == "neutral" or editor.song:getDuration() == 0 then
				editor.state = "playingSong"
				editor.song:play()

				editor.currentBeat = 1
				for i, item in pairs(editor.timestamps) do
					if item[1] < editor.song:tell() then
						editor.currentBeat = i
					end
				end
			else
				editor.song:pause()
				editor.state = "neutral"
			end
		end

		if input == "backspace" then
			editor.timestamps[editor.selectedBeat] = nil
			editor.timestamps = clean_table(editor.timestamps)
		end

		if editor.selectedBeat < 1 then editor.selectedBeat = 1 end
		if editor.selectedBeat > #editor.timestamps then editor.selectedBeat = #editor.timestamps end

		if input == "c" then
			editor.song:seek(0)
		end

		if input == "v" then
			if editor.song:tell() - editor.song:getDuration()/50 > 0 then
				editor.song:seek(editor.song:tell() - editor.song:getDuration()/50)
			else
				editor.song:seek(0)
			end
		end

		if input == "b" then
			editor.song:seek(editor.song:tell() + editor.song:getDuration()/50)
		end		

		if input == "n" then
			editor.song:seek(editor.song:getDuration() - 1)

		end

		if not editor.song:isPlaying() then
				editor.currentBeat = 1
				for i, item in pairs(editor.timestamps) do
					if item[1] < editor.song:tell() then
						editor.currentBeat = i
					end
				end
		end

		if input == "p" then
			local t = ""
			for i = 1, #editor.timestamps do
				t = t .. string.sub(tostring(editor.timestamps[i][1]),1,4 + #tostring(math.floor(editor.timestamps[i][1]))) ..", "
			end
			print(t)
		end

		if input == "t" then
			if editor.state == "playingSong" then
				editor.add_beat()
			end
		end

		if input == "r" then
			if editor.state == "playingSong" then
				editor.add_beat("red")
			end
		end

		if input == "e" then
			if editor.state == "playingSong" then
				editor.add_beat("green")
			end
		end

	elseif game_state == "MapSelect" or game_state == "NewMapSelect" then
		if input == "return" then
			if game.mapSelectSong then game.mapSelectSong:stop() end
			initGame(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].song, game.mapListing[game.selectedMap].mappings[game.selectedDifficulty])
		end

		if input == "escape" then
			playSFX(hold_snd)

		if game.mapSelectSong then table.insert(game.songFadeOut, game.mapSelectSong) end

			transition("Menu")
		end

		if input == "d" or input == "right" then
			game.selectedDifficulty = game.selectedDifficulty + 1
			playSFX(tclick_snd)

		end

		if input == "r" and not movingObjects["transition"] then

			-- check for replay
			local d = love.filesystem.read("replays/"..tostring(game.mapListing[game.selectedMap].map_id).."/"..cleanString(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].difficulty).."/replay.chr")

			if d then
				game.replayData = TSerial.unpack(d)
				if game.mapSelectSong then game.mapSelectSong:stop() end
				game.inReplay = true
				game.replayTransition = true
				initGame(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].song, game.mapListing[game.selectedMap].mappings[game.selectedDifficulty])

			end
		end

		if input == "a" or input == "left" then
			game.selectedDifficulty = game.selectedDifficulty - 1
			playSFX(tclick_snd)

		end

		if input == "w" or input == "up" then
			playSFX(harddrop_snd)

			game.menuFlashPos = 1

			game.selectedMap = game.selectedMap - 1
			if game.selectedMap < 1 then 
				game.selectedMap = 1 
			else
				game.updateDelay = 0.3
			end


		end

		--print(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].song)
		if input == "s" or input == "down" then
			playSFX(harddrop_snd)

			game.menuFlashPos = 1

			game.selectedMap = game.selectedMap + 1
			if game.selectedMap > #game.mapListing then 
				game.selectedMap = #game.mapListing 
			else
				game.updateDelay = 0.5
			end
		end

		

		if game.selectedDifficulty < 1 then game.selectedDifficulty = #game.mapListing[game.selectedMap].mappings end
		if game.selectedDifficulty > #game.mapListing[game.selectedMap].mappings then game.selectedDifficulty = 1 end

		--game.mapBg = game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].selectionBg and love.graphics.newImage(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].selectionBg) or love.graphics.newImage(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].background)
	end
end


function unpack_osz(osz, dontPrune)
	local m = math.random(1,1000)
	local defaultID = math.random(10000,1000000)
	love.filesystem.createDirectory("/maps/" .. tostring(defaultID))
	extractZIP(osz, "/maps/" .. tostring(defaultID), true)
	local files = love.filesystem.getDirectoryItems("/maps/" .. tostring(defaultID))
	local songPath = false
	local bgPath = false
	--love.timer.sleep( 2 )

	for _, file in ipairs(files) do
		if string.sub(file, #file-3, #file) == ".mp3" then
			print(love.filesystem.getInfo(file))
		end
	end

	for _, file in ipairs(files) do

		if string.sub(file, #file-3, #file) == ".osu" then
			local path = "/maps/" .. tostring(defaultID) .. "/" .. file
			local final = {}
			local flashes = {}
			local state = "waitForHit"
			local data = love.filesystem.newFileData(path):getString()
			local pos
			local mapData = {}
			mapData.id = defaultID

			for i = 1, #data do
				
				if string.sub(data, i, i + 5) == "Title:" then
					local newLine = string.find(data, "\n", i)-1
					mapData.title = string.sub(data, i+6, newLine)
					
				end

				if string.sub(data, i, i + 7) == "Version:" then
					local newLine = string.find(data, "\n", i)-1
					mapData.version = string.sub(data, i+8, newLine)
					
				end

				if string.sub(data, i, i + 6) == "Artist:" then
					local newLine = string.find(data, "\n", i)
					mapData.artist = string.sub(data, i+7, newLine)
					
				end

				if string.sub(data, i, i + 12) == "BeatmapSetID:" then
					local newLine = string.find(data, "\n", i)
					--mapData.id = tonumber(string.sub(data, i+13, newLine))
					
				end

				if string.sub(data, i, i + 13) == "AudioFilename:" then
					local newLine = string.find(data, "\n", i)
					mapData.songPath = string.sub(data, i+15, newLine-2)
					--songPath = "/temp/" .. tostring(m) .. "/" .. songPath
				end

				if string.sub(data, i, i + 11) == "[HitObjects]" then
					state = "waitForNewline"
					pos = string.find(data, "\n", i)
				end

				if string.sub(data, i, i + 7) == "[Events]" and string.find(data, '"', i) then
					local firstPos = string.find(data, '"', i)+1
					local lastPos = string.find(data, '"', firstPos+1)-1
					mapData.bgPath = string.sub(data, firstPos, lastPos)
					--bgPath = "/temp/" .. tostring(m) .. "/" .. bgPath
				end

				--print(i..":"..tostring(pos))
				if state == "waitForNewline" and pos and i >= pos then
					state = "waitForComma1"

				end

				local c1 = false
				if state == "waitForComma1" and string.sub(data,i,i) == "," then
					state = "waitForComma2"
					c1 = true
				end

				if state == "waitForComma2" and string.sub(data,i,i) == "," and not c1 then
					local nextPos = string.find(data, ",", i+1)-1
					local time = tonumber(string.sub(data, i+1, nextPos))
					local time = time and time/1000 or false
					--print(string.sub(data, i+1, nextPos))
					pos = string.find(data, "\n", i)
					if (time and #final == 0) or (time and final[#final] ~= time and (time - final[#final]) > 0.3) then 
						table.insert(final, time) 
					end
					table.insert(flashes, time)
					state = "waitForNewline"

				end
			end

			local beatmap = final

			if beatmap then
				local lengthToCheck = 1
				local maxPPS = 0
				local avgPPS = 0
				for i = 1, #beatmap - lengthToCheck do
					local totalTime = beatmap[i+lengthToCheck] - beatmap[i]
					local beats = lengthToCheck
					avgPPS = avgPPS + (beats/totalTime)
					if (beats/totalTime) >= maxPPS then maxPPS = (beats/totalTime) end
				end

				avgPPS = avgPPS / #beatmap

				local deletionThreshold = (avgPPS*.8 + maxPPS*.2)


				for i = 1, #beatmap - lengthToCheck, 2 do
					local totalTime = beatmap[i+lengthToCheck] - beatmap[i]
					local beats = lengthToCheck
					if (beats/totalTime) >= deletionThreshold and not dontPrune then beatmap[i] = nil end

				end		

				beatmap = clean_table(beatmap)

				--[[for i = 1, #beatmap - lengthToCheck, 2 do
					local totalTime = beatmap[i+lengthToCheck] - beatmap[i]
					local beats = lengthToCheck
					if (beats/totalTime) >= deletionThreshold then beatmap[i] = nil end

				end]]		
			end

			beatmap = clean_table(beatmap)

			if #beatmap > 0 then
				mapData.title = mapData.title and mapData.title or "Unknown Title"
				mapData.artist = mapData.artist and mapData.artist or "Unknown Artist"
				mapData.beatmap = beatmap
				mapData.id = mapData.id or defaultID

				if not love.filesystem.getInfo("/maps/"..mapData.id.."/map") then
					love.filesystem.createDirectory("/maps/"..mapData.id.."/map")
					love.filesystem.createDirectory("/maps/"..mapData.id.."/rejectedMap")
					--local finalSong = love.filesystem.newFile( "/maps/"..mapData.id .. "/song.mp3")



					--local realSongDir = love.filesystem.getRealDirectory("/")..songPath
					--print(realSongDir)
					--local f = assert(io.open(realSongDir, "r"))
					--local oldSong = love.filesystem.read(songPath)


					--local oldSong = f:read("*a")
					--print(oldSong)
					--love.audio.newSource(songPath, "stream"):play()
					--finalSong:open("w")
					--finalSong:write(oldSong)
					--finalSong:flush()
					--finalSong:close()

					--local bg_extension = string.sub(bgPath, #bgPath-3, #bgPath)
					--local finalBG = love.filesystem.newFile( "/maps/"..mapData.id .. "/background"..bg_extension)
					--local oldBG = love.filesystem.read(bgPath)

					--print(oldBG)
					--finalBG:open("w")
					--finalBG:write(oldBG)
					--finalBG:flush()
					--finalBG:close()	


				end

					local injectMapData = {
						{
							name = mapData.title,
							artist = mapData.artist,
							beatmap = mapData.beatmap,
							flashTimes = flashes,
							approachRate = 1.5,
							difficulty = mapData.version,

							gravity = 0.5,
							lockTime = 1,
							id = mapData.id,

							songPointer = mapData.songPath,
							bgPointer = mapData.bgPath
						},

						{

						}
					}

					if dontPrune then
						mapData.beatmap = flashes
					end
					--local finalSong = love.filesystem.newFile( "/maps/"..mapData.id .. "/"..tostring(math.random(1,1000))..".lua")

					love.filesystem.write("/maps/"..mapData.id .. "/map/"..tostring(math.random(1,1000))..".lua", TSerial.pack(injectMapData, {}, true))


			end

		end
	end

end