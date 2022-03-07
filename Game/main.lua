local STI = require("sti")
game_state = "Menu"
version = "0.7.2"


board_offset = {(275),50}


require"Tserial"

require"libs"
require"ext_data"
--require"maps"



resolutions = {
	{800,600},
	{1280, 720},
	{1920, 1080}
}

--love.window.setMode(1280, 720, false, false)
if love.system.getOS() ~= "Android" then
	love.window.setMode(resolutions[selected_resolution][1], resolutions[selected_resolution][2], {resizable=true, minwidth=800, minheight=600})
else
	--love.graphics.scale(0.5,0.5)
	love.window.setMode(1,2, {resizable = true})
end

love.graphics.setFont(love.graphics.newFont("/assets/skins/"..game.skin.."/font.ttf", 32))

game.font = love.graphics.font


menuItems = mainMenu

if not data.misc then data.misc = {} end

if not data.misc.viewedTutorial then
	menuItems = firstTimeMenu
	data.misc.viewedTutorial = true
	game.viewingTutorial = true
end

math.randomseed(os.time())

--create the player matrix
player_matrix = {}


--[[ PIECE TYPES:
1: I
2: J
3: L
4: S
5: Z
6: T
7: O


ACTIVE PIECE FORMATTING:
active_piece.matrix
active_piece.pos.x
active_piece.pos.y (x and y are matrix positioning, not pixel positioning)
active_piece.srsChecks (to be made: table of relative coordinates to set, per piece)
active_piece.rotation
active_piece.gravity
]]

function love.gamepadpressed( joystick, input )
	if game_state == "InGame" and not game.inReplay and input ~= "start" and not game.paused and game.buttonMappings[input] and game.buttonMappings[input][2] ~= key.left and game.buttonMappings[input][2] ~= key.right then



		table.insert(game.replayData.inputs, {
				total_time,
				game.buttonMappings[input][2],
				true,
				t = "i"
			
		})

	end
end

function love.gamepadreleased( joystick, input )
	if game_state == "InGame" and not game.inReplay and input ~= "start" and not game.paused then



		--[[table.insert(game.replayData.inputs, {
				total_time,
				game.buttonMappings[input][2],
				false
			
		})]]

	end
end

function love.wheelmoved(x, y)
	if game_state == "NewMapSelect" then
		if y > 0 then
			game.selectedMap = game.selectedMap - 1
			playSFX(harddrop_snd)
		elseif y < 0 then
			game.selectedMap = game.selectedMap + 1
			playSFX(harddrop_snd)
		end
		game.updateDelay = 0.5
		game.selectedMap = math.clamp(game.selectedMap, 1, #game.mapListing)
	end

	if game_state == "Menu" then
		if y > 0 then
			checkForInput("right")
		elseif y < 0 then
			checkForInput("left")
		end		
	end
end

function love.keypressed( input )

	checkForInput(input, false, true)


	if game_state == "InGame" and not game.inReplay and input ~= "escape" and input ~= key.restart and not game.paused and (input == key.harddrop or input == key.hold or input == key.cwrotate or input == key.ccwrotate or input == key.rotate180) then
		table.insert(game.replayData.inputs, {
			total_time,
				input,
				true,
				t = "i"
		})
	end


end



function love.keyreleased(input)

	if game_state == "InGame" and not game.inReplay and input ~= "escape" and input ~= key.restart and not game.paused then
		--[[table.insert(game.replayData.inputs, {
			total_time,
				input,
				false
			})]]
	end

end



local lastFrameDir = 0
function love.update(dt)

	if game.updateDelay then
		game.updateDelay = game.updateDelay - dt
		print("ah")
		if game.updateDelay < 0 then

			table.insert(movingObjects, {
				img = flashmino_img,
				position = {0,0},
				layer = 2,
				scale = {200,200},
				acceleration = {0,0},
				opacity = 1,
				opacityDelta = -0.05,
				velocity = {0,0},
				color = {0,0,0},
				lifetime = 1
			})

			changeMapSelectSong()
			game.menuFlashPos = 1

			game.mapBg = game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].selectionBg and love.graphics.newImage(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].selectionBg) or love.graphics.newImage(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].background)

			game.updateDelay = false
		end
	end

	if game.decorScale and game.decorScale > 1 then
		game.decorScale = game.decorScale - (dt/12)
	end

	if game_state ~= "InGame" and not game.replayTransition then
		game.inReplay = false
	end

	if game_state == "MapSelect" and not movingObjects["transition"] then
		game.replayTransition = false
	end

	if game.transitionTime and game.transitionTime > 0 and song and song:isPlaying() and song:tell() < 5 then
		song:stop()
	end

	if game_state == "MapSelect" and song and song:isPlaying() then
		song:stop()
	end

	for index, object in pairs(movingObjects) do
		if (not game.paused) or (game.paused and object.ignorePause) then
			if object.velocity and object.position and object.position[1] and object.position[2] then
				object.position[1] = object.position[1] + (object.velocity[1] * 60 * game.dt)
				object.position[2] = object.position[2] + (object.velocity[2] * 60 * game.dt)
			end

			object.scale = object.scale and object.scale or {1,1} 


			if object.rotVelocity then
				object.rotation = object.rotation + (object.rotVelocity * 60 * game.dt)
			end

			if object.opacityDelta then
				object.opacity = object.opacity + (object.opacityDelta * 60 * game.dt)
			end

			if object.acceleration then
				object.velocity[1] = object.velocity[1] + object.acceleration[1]
				object.velocity[2] = object.velocity[2] + object.acceleration[2]
			end

			if object.scaleDelta then
				object.scale[1] = object.scale[1] + (object.scaleDelta[1] * 60 * game.dt)
				object.scale[2] = object.scale[2] + (object.scaleDelta[2] * 60 * game.dt)
			end

			if object.scale[1] < 0 then object.scale[1] = 0 end
			if object.scale[2] < 0 then object.scale[2] = 0 end


			if object.lifetime then
				local oldLifetime = object.lifetime
				object.lifetime = object.lifetime - game.dt

				if object.lifetimeMapping then
					for _, item in pairs(object.lifetimeMapping) do
						local time = item[1]

						if oldLifetime >= time and object.lifetime < time then
							for ind, val in pairs(item[2]) do
								object[ind] = val
							end
						end
					end
				end

				if object.lifetime < 0 then
					movingObjects[index] = nil
				end
			end
		end
	end

	game.dt = dt

	if game_state ~= "InGame" and game.paused then
		game.paused = 0
	end






	if game.transitionTime > 0 then
		if game.transitionTime < 0.3 and not game.transitionFlag then
			game.transitionFrame = true
			game.transitionFlag = true
			game_state = game.transitionGoal
			game.transitionTime = 0
			movingObjects = {}
			movingObjects["transition"] = {
				img = flashmino_img,
				scale = {250,250},
				position = {0,0},
				layer = 3,
				color = {0,0,0},
				lifetime = 1,
				opacity = 1,
				velocity = {0,0},
				
				--opacityDelta = 0.05,
			}		
			movingObjects["transition"].opacityDelta = -0.05

			if game.transitionGoal == "Menu" then
				love.graphics.setFont(love.graphics.newFont("/assets/skins/"..game.skin.."/font.ttf", 32))			
			elseif love.filesystem.getInfo("/assets/skins/"..game.skin.."/font.png") then
				love.graphics.setFont(love.graphics.newImageFont("/assets/skins/"..game.skin.."/font.png", 
				    " abcdefghijklmnopqrstuvwxyz" ..
				    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
				    "123456789.,!?-+/():;%&`'*#=[]\""
				))
			else
				love.graphics.setFont(love.graphics.newFont("/assets/skins/"..game.skin.."/font.ttf", 32))			
			end

			--game.font = love.graphics.getFont
		end

		game.transitionTime = game.transitionTime - game.dt
		if not game.transitionFrame then return end
	else
		game.transitionFlag = false
	end

	if song then song:setVolume(data.volume.music * 0.65) end
	if game.mapSelectSong then game.mapSelectSong:setVolume(data.volume.music * 0.65) end

	if data and data.volume and data.volume.master then
		love.audio.setVolume(data.volume.master)
	end



	for i, item in pairs(game.songFadeOut) do
		item:setVolume(item:getVolume() - (game.musicVolume/30*60*game.dt))
		--print(item:getVolume())
		if item:getVolume() - (game.musicVolume/50*60*game.dt) <= 0.05 then
			item:stop()
			item:release()
			game.songFadeOut[i] = nil
		end


	end

	if game.mapSelectSong and game_state ~= "MapSelect" and game.mapSelectSong:isPlaying() then

		
	end

	if game.paused and song and song:isPlaying() then
		song:pause()
	end

	if game_state == "InGame" and active_piece and not game.paused then

		game.replayData.CPcountdown = game.replayData.CPcountdown and game.replayData.CPcountdown or data.misc.cpAccuracy

		if not data.misc.cpAccuracy then data.misc.cpAccuracy = 0.5 end

		if not game.replayData.checkpoints then
			game.replayData.checkpoints = {}
		end

		if not game.inReplay and game.replayData.CPcountdown then
			game.replayData.CPcountdown = game.replayData.CPcountdown - dt

			if game.replayData.CPcountdown < 0 then
				game.replayData.CPcountdown = game.replayData.CPcountdown + 1
				table.insert(game.replayData.inputs, {total_time, clone(player_matrix), bag, {score, game.missCount, game.niceCount, game.perfectCount}, t = "c"})
				print("checkpoint recorded")
			end
		end

		if song and song:isPlaying() then
			game.replayTransition = false
		end

		--print(game.startOffset)
		--if song and song:tell() < 120 then song:seek(120) end

		if game.startOffset <= -3 and song and (not song:isPlaying() or total_time >= game.endTime) then
			love.timer.sleep(.5)
			if not game.inReplay then 
				save({
					score = score,
					accuracy = game.accuracy,
					rank = generate_rank(mode),
					mapID = game.mapID,
					difficulty = game.songDifficulty
				})

				game.replayData.accuracy = game.accuracy
				game.replayData.score = score
			end

			game.accuracy = game.replayData.accuracy
			score = game.replayData.score and game.replayData.score or score
			transition("Results")
		end

		game.startOffset = game.startOffset - game.dt

		if game.startOffset >= 0 then
			
		elseif song and not song:isPlaying() then
			song:play()
			if game.video then game.video:play() end
		end

		local canTopOut = (not game.inReplay) or (not game.replayData.inputs[game.replayData.position+1])

		if (not check_collision() or game.hp <= 0 or game.deathTransition) and canTopOut then
			if not game.deathTransition then game.song_pitch = 1 game.boardVelocity = 0 end

			game.deathTransition = true
			

			if ((song and song:getPitch() < 0.1) or (not song)) and canTopOut then
				if not game.inReplay then 
					save({
						score = score,
						accuracy = game.accuracy,
						rank = "F",
						mapID = game.mapID,
						difficulty = game.songDifficulty
					})

					game.replayData.accuracy = game.accuracy
					game.replayData.score = score
				end	 

				game.accuracy = game.replayData.accuracy
				score = game.replayData.score
				
				top_out()

			end

		end

		if game.deathTransition and game.song_pitch then
			board_offset[2] = board_offset[2] + game.boardVelocity
			game.boardVelocity = game.boardVelocity + 0.2*60*dt
			game.song_pitch = game.song_pitch - 0.01*60*dt
			if game.song_pitch < 0.01 then game.song_pitch = 0.0001 end
			if song then song:setPitch(game.song_pitch) end
			return
		end

		game.board_live_offset[1] = game.board_live_offset[1] / 1.1
		game.board_live_offset[2] = game.board_live_offset[2] / 1.1

		game.timeSinceBeat = game.timeSinceBeat + dt
		game.accuracy = (game.perfectCount + (game.niceCount * 0.7) + (game.holdCount * 0.5)) / (game.beatCount - 1)

		if game.beatCount - 1 < 1 then
			game.accuracy = 0
		end

		if game.hp > 1 then game.hp = 1 end

		--print(total_time.. " : " ..song:tell())

		if not auto_drop then
			autodrop_skip = false
			auto_drop_wait = false
		end


		if game.beatmap and game.timeTilNextBeat then
			game.timeTilNextBeat = game.timeTilNextBeat - dt
			if game.timeTilNextBeat < 0 then
				game.timeTilNextBeat = 0 

			end
		end



		lm_timer = lm_timer - (0.005 * 60 * dt)

		if lm_timer < 0 then lm_timer = 0 end

		if repeat_table and repeat_progress > 0 then
			
			for _, item in pairs(repeat_table[2]) do 
				if item[1] == "AutoDrop" and repeat_progress > 1 then
					auto_drop = true
				end
			end

			if total_time >= repeat_table[3] + repeat_table[1] then
				start_position_r = total_time
				repeat_progress = repeat_progress - 1

				repeat_table[3] = repeat_table[3] + repeat_table[1]
				affect_board(repeat_table[2])
			end
		end

		if song then
			total_time = song:tell()
		elseif game.startOffset <= 0 then
			total_time = total_time + (dt * game.replayPlaybackRate)
		end

		if game.goToResults then
			transition("Results")
		end

		--total_time = total_time + dt

		if old_time == total_time and total_time > 0 then

		end
		--print(total_time)

		gravity_prog = gravity_prog + dt

		local canMove = true
		if not game.replayData.keysDown then print("WHOOPS") game.replayData.keysDown = {} end

		local frameInputs = {
			softdrop = love.keyboard.isDown(key.softdrop) or game.gamepadButtons[data.gamepadControls.softdrop] or game.replayData.keysDown[key.softdrop],
			left = love.keyboard.isDown(key.left) or game.gamepadButtons[data.gamepadControls.left] or game.replayData.keysDown[key.left],
			right = love.keyboard.isDown(key.right) or game.gamepadButtons[data.gamepadControls.right] or game.replayData.keysDown[key.right],
			harddrop = love.keyboard.isDown(key.harddrop) or game.gamepadButtons[data.gamepadControls.harddrop] or game.replayData.keysDown[key.harddrop],
			cwrotate = love.keyboard.isDown(key.cwrotate) or game.gamepadButtons[data.gamepadControls.cwrotate] or game.replayData.keysDown[key.cwrotate],
			ccwrotate = love.keyboard.isDown(key.ccwrotate) or game.gamepadButtons[data.gamepadControls.ccwrotate] or game.replayData.keysDown[key.ccwrotate],
		}

		--print(frameInputs.softdrop)

		if game.startOffset < 1.5 and game.oldStartOffset >= 1.5 then
			table.insert(movingObjects,{
				img = game.countdown3_img,
				position = {game.swidth/2, game.sheight/2},
				scale = {250/game.countdown3_img:getWidth()/2, 250/game.countdown3_img:getHeight()/2},
				scaleOffset = {game.countdown3_img:getWidth()/2, game.countdown3_img:getHeight()/2},
				layer = 3,
				lifetime = 0.5,
				opacityDelta = -0.025,
				velocity = {1,-2},
				acceleration = {0,0.2},
				rotVelocity = 0.025,
				scaleDelta = {-0.015 * (game.countdown3_img:getWidth()/250), -0.015 * (game.countdown3_img:getHeight()/250)}
			})
			playSFX(hold_snd)
		end


		if game.startOffset < 1 and game.oldStartOffset >= 1 then
			table.insert(movingObjects,{
				img = game.countdown2_img,
				position = {game.swidth/2, game.sheight/2},
				scale = {250/game.countdown2_img:getWidth()/2, 250/game.countdown2_img:getHeight()/2},
				scaleOffset = {game.countdown2_img:getWidth()/2, game.countdown2_img:getHeight()/2},
				layer = 3,
				lifetime = 0.5,
				opacityDelta = -0.025,
				velocity = {-1,-2},
				acceleration = {0,0.2},
				rotVelocity = -0.025,
				scaleDelta = {-0.015 * (game.countdown2_img:getWidth()/250), -0.015 * (game.countdown2_img:getHeight()/250)}
			})
			playSFX(hold_snd)
		end

		if game.startOffset < .5 and game.oldStartOffset >= .5 then
			table.insert(movingObjects,{
				img = game.countdown1_img,
				position = {game.swidth/2, game.sheight/2},
				scale = {250/game.countdown1_img:getWidth()/2, 250/game.countdown1_img:getHeight()/2},
				scaleOffset = {game.countdown1_img:getWidth()/2, game.countdown1_img:getHeight()/2},
				layer = 3,
				lifetime = 0.5,
				opacityDelta = -0.025,
				velocity = {0,-2},
				acceleration = {0,0.2},
				rotVelocity = 0.01,
				scaleDelta = {-0.015 * (game.countdown1_img:getWidth()/250), -0.015 * (game.countdown1_img:getHeight()/250)}
			})
			playSFX(hold_snd)
		end

		if game.startOffset < 0 and game.oldStartOffset >= 0 then
			playSFX(lineclear_snd)
			gravity = map_data[1].gravity and map_data[1].gravity or 1
		end

		if (song and (not song:isPlaying() or total_time < 0.1)) or game.startOffset > 0 then
			canMove = false
			gravity = 9999999
		elseif gravity == 9999999 then
			gravity = game.initGravity
		end

		if song then
			if game.inReplay and frameInputs.left and song then
				song:setPitch(0.5)
				game.replayPlaybackRate = 0.5
			elseif game.inReplay and frameInputs.right and song then
				song:setPitch(2)
				game.replayPlaybackRate = 2
			else
				song:setPitch(1)
				game.replayPlaybackRate = 1	
			end
		end

		if game.inReplay then
			frameInputs = {
				softdrop = game.replayData.keysDown[key.softdrop],
				left = game.replayData.keysDown[key.left],
				right = game.replayData.keysDown[key.right],
				harddrop = game.replayData.keysDown[key.harddrop],
				cwrotate = game.replayData.keysDown[key.cwrotate],
				ccwrotate = game.replayData.keysDown[key.ccwrotate],				
			}
		end

		if not auto_drop then auto_drop_wait = false end

		if canMove and frameInputs.softdrop and gravity_prog < gravity - (gravity / handling.sdr) then
			gravity_prog = gravity - (gravity / handling.sdr)

			local fail = 0
			
			if handling.sdr == 60 then
				while check_collision() and fail < 30 do
					fail = fail + 1
					active_piece.pos.y = active_piece.pos.y + 1
				end

				active_piece.pos.y = active_piece.pos.y - 1
			end
		end
		--print(lastFrameDir)




		if canMove and (frameInputs.left and lastFrameDir == 1) or (frameInputs.right and lastFrameDir == -1) then
			das_prog = 0
		end

		if canMove and (not frameInputs.left) and lastFrameDir == -1 then
			das_prog = 0
			arr_prog = 0 
		end


		if canMove and (not frameInputs.right) and lastFrameDir == 1 then
			das_prog = 0
			arr_prog = 0 
		end

		if map_position then
			--print(total_time)
			if map_data[2][map_position] then
				--print("next timestamp: " .. tonumber(map_data[2][map_position][1]))
				--print(total_time)
				
				--print(map_data[2][map_position][1])
				if total_time >= map_data[2][map_position][1] and (game.startOffset <= 0) then
					repeat_table = false
					auto_drop = false
					if map_data[2][map_position][3] then
						print("repeating")
						repeat_table = {map_data[2][map_position][3], map_data[2][map_position][2], total_time}
						start_position_r = total_time
						if map_data[2][map_position][4] then
							repeat_progress = map_data[2][map_position][4] - 1
						else
							repeat_progress = 99999999999
						end

					else
						repeat_progress = 0
						repeat_table = false
					end
					
					-- check next map position: is it an auto-drop?

					if map_data[2][map_position+1] and map_data[2][map_position+1] == "AutoDrop" then
						auto_drop = true
					end

					affect_board(map_data[2][map_position][2])
					start_position = map_data[2][map_position][1]
					map_position = map_position + 1
				end
			end
		end


		active_piece.pos.y = active_piece.pos.y + 1
		if not check_collision() then
			active_piece.lockProgress = active_piece.lockProgress + dt
		end

		active_piece.pos.y = active_piece.pos.y - 1

		if active_piece.lockProgress >= lockTime then
			lock_piece()
		end

		if canMove and not frameInputs.left and not frameInputs.right then
			lastFrameDir = 0
		end

		if frameInputs.left or frameInputs.right then
			das_prog = das_prog + dt
			arr_prog = arr_prog + dt
		end
		print(canMove)
		if canMove and frameInputs.left then


			lastFrameDir = -1

			if canMove and das_prog >= handling.das and not frameInputs.right then
				
				--print(handling.arr)
				if handling.arr == 0 then
					local n = 0
					repeat active_piece.pos.x = active_piece.pos.x -1; n = n + 1 until not check_collision() or n > 30
					if n > 2 then
						game.board_live_offset[1] = game.board_live_offset[1] - 2 
					end
					active_piece.pos.x = active_piece.pos.x + 1
				end
				--print(arr_prog)
				if arr_prog >= handling.arr and handling.arr > 0 then
					repeat arr_prog = arr_prog - handling.arr until arr_prog < handling.arr
					--arr_prog = 0
					active_piece.pos.x = active_piece.pos.x - 1
					if not check_collision() then
						active_piece.pos.x = active_piece.pos.x + 1
					else
						move_snd:play()
					end
				end
			end
		end
		if canMove and frameInputs.right then

			lastFrameDir = 1
			if canMove and das_prog >= handling.das and not frameInputs.left then
				if handling.arr == 0 then
					local n = 0
					repeat active_piece.pos.x = active_piece.pos.x +1; n = n + 1; until not check_collision() or n > 30
					if n > 2 then
						game.board_live_offset[1] = game.board_live_offset[1] + 2
					end
					active_piece.pos.x = active_piece.pos.x - 1
				end
				if arr_prog >= handling.arr then

					arr_prog = 0
					active_piece.pos.x = active_piece.pos.x + 1
					if not check_collision() then
						active_piece.pos.x = active_piece.pos.x - 1
					else
						move_snd:play()
					end
				end
			end
		end
		if canMove and not frameInputs.left and not frameInputs.right then
			das_prog = 0
			arr_prog = 0
		end



		if active_piece then
			

			if gravity_prog >= gravity then
				print("gravity")
				gravity_prog = 0 
				active_piece.pos.y = active_piece.pos.y + 1
				if not check_collision() then
					active_piece.pos.y = active_piece.pos.y - 1
				end
			end
		end

		if active_piece then
			if game.oldPieceX ~= active_piece.pos.x or game.oldPieceY ~= active_piece.pos.y then
				table.insert(game.replayData.inputs, {total_time, active_piece.pos.x, active_piece.pos.y, t="u"})
				print("update processed")
			end
		end

		old_time = total_time
		game.oldPieceX = active_piece and active_piece.pos.x or false
		game.oldPieceY = active_piece and active_piece.pos.y or false

		game.oldStartOffset = game.startOffset

	elseif game_state == "Menu" and game.swidth then

	local sc = math.random(1,4)/5

	local x = math.random(2,6)/10
	
	table.insert(movingObjects, {
		["img"] =game.sparkle_img,
		["velocity"] = {0,0},
		["position"] = {math.random(1,game.swidth), math.random(1,game.sheight)},
		["acceleration"] = {0,0.01},
		["type"] = "misc",
		["layer"] = 2,
		["scale"] = {x,x},
		["scaleDelta"] = {-0.01 * sc, -0.01 * sc},
		["lifetime"] = 3,
		["opacity"] = 0,
		["opacityDelta"] = 0.01,
		["color"] = {1,1,1},

		lifetimeMapping = {
			{1,
				{
					opacityDelta = -0.02
				}
			}
		}
	})
	--[[if math.random(1,3) == 2 and game.swidth then
		table.insert(movingObjects, {
			["img"] =flashmino_img,
			["velocity"] = {math.random(-1,1)/math.random(2,4), 1 * (math.random(3))},
			["position"] = {math.random(1, game.swidth), -20},
			["rotation"] = math.random(1,3),
			["rotVelocity"] = 0.01,
			["acceleration"] = {math.random(-1,1)/25,0.05},
			["type"] = "misc",
			["layer"] = 2,
			["scale"] = {1 * sc, 1 * sc},
			["scaleDelta"] = {-0.001 * sc, -0.001 * sc},
			["lifetime"] = 5,
			["opacity"] = 1,
			["opacityDelta"] = -0.002,
			["color"] = {1 / math.random(2),1 / math.random(2),1 / math.random(2)},
		})
	end]]



	elseif game_state == "MapSelect" or game_state == "NewMapSelect" then

		if game.viewingTutorial then
			game.viewingTutorial = false
			menuItems = mainMenu
		end
		


		if game.transitionFrame then
			game.mapListing = generateMapList(maps)
			changeMapSelectSong()
			game.mapBg = game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].selectionBg and love.graphics.newImage(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].selectionBg) or love.graphics.newImage(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].background)
		end

		if game.mapSelectSong and game.mapSelectSong:getVolume() < game.musicVolume and (data.volume.music and data.volume.music ~= 0) then
			game.mapSelectSong:setVolume(game.mapSelectSong:getVolume() + (game.musicVolume/100*60*game.dt))			
		end

		local songTime = game.mapSelectSong and game.mapSelectSong:tell() or false
		if songTime and game.mapListing[game.selectedMap].flash_table then
			local submitted = false
			for i = game.menuFlashPos - 1, #game.mapListing[game.selectedMap].flash_table do
				if game.mapListing[game.selectedMap].flash_table[i] and songTime >= game.mapListing[game.selectedMap].flash_table[i] and game.menuFlashPos < i then
					game.menuFlashPos = i
					print("flash")
					game.decorScale = 1.1
						if not submitted then
							table.insert(movingObjects,{
							img = flashmino_img,
							position = {0,0},
							scale = {200,200},
							lifetime = .5,
							color = {1,1,1},
							opacity = 0.1,
							opacityDelta = -0.0075,
							layer = 2
						})
						submitted = true

						for i = 1, 12 do
							local sc = math.random(1,4)/5

							if sc > 0.6 then
								table.insert(movingObjects, {
									["img"] =flashmino_img,
									["velocity"] = {math.random(-1,1)/math.random(2,4), 1 * (math.random(3))},
									["position"] = {math.random(1,game.swidth), -20},
									["rotation"] = math.random(1,3),
									["rotVelocity"] = 0.01,
									["acceleration"] = {math.random(-1,1)/25,0.05},
									["type"] = "misc",
									["layer"] = 2,
									["scale"] = {1 * sc/2, 1 * sc/2},
									["scaleDelta"] = {-0.001 * sc, -0.001 * sc},
									["lifetime"] = 5,
									["opacity"] = 1,
									["opacityDelta"] = -0.002,
									["color"] = {1 / math.random(2),1 / math.random(2),1 / math.random(2)},
								})
							end

							local x = math.random(2,6)/10

							table.insert(movingObjects, {
								["img"] =game.sparkle_img,
								["velocity"] = {0,0},
								["position"] = {math.random(1,game.swidth), math.random(1,game.sheight)},
								["acceleration"] = {0,0.01},
								["type"] = "misc",
								["layer"] = 2,
								["scale"] = {x,x},
								["scaleDelta"] = {-0.01 * sc, -0.01 * sc},
								["lifetime"] = 3,
								["opacity"] = 1,
								["opacityDelta"] = -0.01,
								["color"] = {1,1,1},
							})
						end
					end
				end
			end

		elseif game_state == "Results" then

		end




	end -- END GAMEPLAY LOOP

	if game_state == "NewMapSelect" then
		--
		if game.transitionFrame then
			print("transition")
			
			--changeMapSelectSong()
		end

		game.selectedMap = game.selectedMap and game.selectedMap or 1
		game.selectedDifficulty = game.selectedDifficulty and game.selectedDifficulty or 1

		if not game.mapListing then
			game.mapListing = generateMapList(maps)
			print(game.mapListing)
		elseif not game.mapBg and game.mapListing[game.selectedMap] and game.mapListing[game.selectedMap].mappings[game.selectedDifficulty] and game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1] then
			game.mapBg = game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].selectionBg and love.graphics.newImage(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].selectionBg) or love.graphics.newImage(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].background)
		end
		
		

	end

	 -- check gamepad inputs
	 if love.joystick.getJoystickCount() > 0 and data.gamepadControls then
	 	local Joystick
		local joysticks = love.joystick.getJoysticks()
		for i, joystick in ipairs(joysticks) do
			Joystick = joystick
		end

	 	game.buttonMappings = {
	 		[data.gamepadControls.ccwrotate] = {data.gamepadControls.ccwrotate, key.ccwrotate, "return"},
	 		[data.gamepadControls.cwrotate] = {data.gamepadControls.cwrotate, key.cwrotate, "escape"},
	 		[data.gamepadControls.harddrop] = {data.gamepadControls.harddrop, key.harddrop, "up"},
	 		[data.gamepadControls.softdrop] = {data.gamepadControls.softdrop, key.softdrop, "down"},
	 		[data.gamepadControls.left] = {data.gamepadControls.left, key.left, "left"},
	 		[data.gamepadControls.right] = {data.gamepadControls.right, key.right, "right"},
	 		[data.gamepadControls.hold] = {data.gamepadControls.hold, key.hold, "lshift"},
	 		--{data.gamepadControls.hold, key.hold, key.hold},
	 		[data.gamepadControls.rotate180] = {data.gamepadControls.rotate180, key.rotate180, "p"},
	 		{"start", "escape"},

	 	}

	 	local menuMappings = {
	 		{"a", "return"},
	 		{"b", "escape"},
	 		{"dpup", "up"},
	 		{"dpdown", "down"},
	 		{"dpleft", "left"},
	 		{"dpright", "right"},
	 		{"leftshoulder", "r"},
	 		{"rightshoulder", "r"}
	 	}

		 if not waitingForInput then

		 	if game_state == "InGame" and not game.paused then

				for i, item in pairs(game.songFadeOut) do
					item:stop()
					item:release()
					game.songFadeOut[i] = nil
				end

			if game.mapSelectSong then game.mapSelectSong:stop() end

			 	for _, inp in pairs(game.buttonMappings) do

				 	if Joystick:isGamepadDown(inp[1]) and not game.gamepadButtons[inp[1]] then
				 			checkForInput((game_state == "InGame" and not game.paused) and inp[2] or inp[3], true, true)




				 			print("FLAG")

				 		
				 		game.gamepadButtons[inp[1]] = true
				 	elseif not Joystick:isGamepadDown(inp[1]) then
				 		game.gamepadButtons[inp[1]] = false	 		
				 	end
			 	end
			 else
			 	for _, inp in pairs(menuMappings) do
			 		if Joystick:isGamepadDown(inp[1]) and not game.gamepadButtons[inp[1]] then
			 			checkForInput(inp[2], true, true)
				 		game.gamepadButtons[inp[1]] = true
				 	elseif not Joystick:isGamepadDown(inp[1]) then
				 		game.gamepadButtons[inp[1]] = false	 					 			
			 		end
			 	end
			end
		 else
 			 local buttonsToCheck = {
 				"a",
 				"b",
 				"x",
 				"y",
 				"dpup",
 				"dpdown",
 				"dpleft",
 				"dpright",
 				"back",
 				"guide",
 				"leftstick",
 				"rightstick",
 				"leftshoulder",
 				"rightshoulder",
 			}
 			for _, item in pairs(buttonsToCheck) do
 				if Joystick:isGamepadDown(item) and not game.gamepadButtons[item] then
 					checkForInput(item, true, true)
 					game.gamepadButtons[item] = true
 				elseif not Joystick:isGamepadDown(item) then
 					game.gamepadButtons[item] = false
 				end
 			end
		 end
	 end

	game.transitionFrame = false


	if game.paused then
		game.pauseOpacity = (game.pauseOpacity * 6 + 0.5)/7
	else
		game.pauseOpacity = 0
	end

end



function love.draw()


	swidth, sheight = love.graphics.getDimensions()
	game.swidth = swidth
	game.sheight = sheight
	bumpx = (swidth-800)/2
	bumpy = (sheight-600)/2

	game.bumpx = bumpx
	game.bumpy = bumpy

	if love.system.getOS() == "Android" then
		local scale = love.graphics.getDPIScale()
		love.graphics.scale(1/scale,1/scale)
		--love.graphics.translate(0,25)
		swidth = swidth * scale
		sheight = sheight * scale
	end

	if not data.boardZoom then data.boardZoom = 1 end

	if data.boardZoom == 1 and game_state ~= "Editor" then
		local ratio
		if swidth > sheight then
			ratio = (sheight/600)
		else
			ratio = (swidth/800)
		end
		local wr = (ratio)-1
		local translateX = -(swidth/(1/wr)/2)
		local translateY = -(sheight/(1/wr)/2)
		
		love.graphics.translate(translateX, translateY)
		love.graphics.scale(ratio,ratio)		
	end

	if data.boardZoom == 3 then
		love.graphics.translate(-(swidth/8), -(sheight/8))
		love.graphics.scale(1.25,1.25)
	elseif data.boardZoom == 4 then
		love.graphics.translate(-(swidth/4), -(sheight/4))
		love.graphics.scale(1.5,1.5)	
	elseif data.boardZoom == 5 then
		love.graphics.translate(-(swidth/2), -(sheight/2))
		love.graphics.scale(2,2)	
	end





	drawMovingObjects(1)


	if game_state == "InGame" then
		if song then total_time = song:tell() end

		if game.inReplay then
			print("inputs")
			while not game.replayData.inputs[game.replayData.position] or total_time > game.replayData.inputs[game.replayData.position][1] do
				if not game.replayData.inputs[game.replayData.position] then break end

				if game.replayData.inputs[game.replayData.position].t == "i" then


					if game.replayData.inputs[game.replayData.position][3] then
						checkForInput(game.replayData.inputs[game.replayData.position][2])
					end

					game.replayData.keysDown[game.replayData.inputs[game.replayData.position][2]] = game.replayData.inputs[game.replayData.position][3]
				elseif game.replayData.inputs[game.replayData.position].t == "u" then

					active_piece.pos.x = game.replayData.inputs[game.replayData.position][2]
					active_piece.pos.y = game.replayData.inputs[game.replayData.position][3]
					print("update loaded")
				elseif game.replayData.inputs[game.replayData.position].t == "c" then
					player_matrix = clone(game.replayData.inputs[game.replayData.position][2])
					bag = game.replayData.inputs[game.replayData.position][3]
					--print("loaded cp")



					score = game.replayData.inputs[game.replayData.position][4][1] and game.replayData.inputs[game.replayData.position][4][1] or score

					game.missCount = game.replayData.inputs[game.replayData.position][4][2]
					game.niceCount = game.replayData.inputs[game.replayData.position][4][3]
					game.perfectCount = game.replayData.inputs[game.replayData.position][4][4]
				end

				game.replayData.position = game.replayData.position + 1
			end

			--[[game.replayData.updatePos = game.replayData.currentCP and game.replayData.updatePos or 1

			print("updates")

			while not game.replayData.updates[game.replayData.updatePos] or total_time > game.replayData.updates[game.replayData.updatePos][1] do
				
				if not game.replayData.updates[game.replayData.updatePos] then break end

				active_piece.pos.x = game.replayData.updates[game.replayData.updatePos][2]
				active_piece.pos.y = game.replayData.updates[game.replayData.updatePos][3]
				print("update loaded")
				game.replayData.updatePos = game.replayData.updatePos + 1
			end]]

			game.replayData.currentCP = game.replayData.currentCP and game.replayData.currentCP or 1

			print("checkpoints")
			while not game.replayData.checkpoints[game.replayData.currentCP] or total_time > game.replayData.checkpoints[game.replayData.currentCP][1] do
				
				if not game.replayData.checkpoints[game.replayData.currentCP] then break end

				player_matrix = clone(game.replayData.checkpoints[game.replayData.currentCP][2])
				bag = game.replayData.checkpoints[game.replayData.currentCP][3]
				--print("loaded cp")

				--active_piece.pos.x = game.replayData.checkpoints[game.replayData.currentCP][4][1]
				--active_piece.pos.x = game.replayData.checkpoints[game.replayData.currentCP][4][2]
				--game.accuracy = game.replayData.checkpoints[game.replayData.currentCP][4][1]

				score = game.replayData.checkpoints[game.replayData.currentCP][4][1] and game.replayData.checkpoints[game.replayData.currentCP][4][1] or score

				game.missCount = game.replayData.checkpoints[game.replayData.currentCP][4][2]
				game.niceCount = game.replayData.checkpoints[game.replayData.currentCP][4][3]
				game.perfectCount = game.replayData.checkpoints[game.replayData.currentCP][4][4]

				game.replayData.currentCP = game.replayData.currentCP + 1
			end
			--print(game.replayData.position)
			--game.replayData.position = game.replayData.position - 1
		end



		print("flashTimes")

		if game.flashTimes then
			if game.flashTimes[game.flashPos] and total_time > game.flashTimes[game.flashPos] then
				game.flashPos = game.flashPos + 1
				local tries = 0
				local num 
				repeat 
					num = math.random(1,7)
					tries = tries + 1
				until tries > 20 or game.flashLights[num] == 0
				game.flashLights[num] = 1
				game.timeSinceBeat = 0
			end

			local decay = 0.025
			for i, item in pairs(game.flashLights) do
				if item > 0 then
					game.flashLights[i] = item - (decay * game.dt * 60)
				else
					game.flashLights[i] = 0
				end
			end
		end

		--draw the background

		local opacity_addition =  0.15 - game.timeSinceBeat
		local board_surround_scale = (0.5 - game.timeSinceBeat) * 10

		if opacity_addition < 0 then opacity_addition = 0 end
		if board_surround_scale < 0 then board_surround_scale = 0 end

		love.graphics.push()
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(bg_img, game.swidth/2, game.sheight/2, 0, game.swidth/bg_img:getWidth(), game.sheight/bg_img:getHeight(), bg_img:getWidth()/2, bg_img:getHeight()/2)
		if game.video then 
			love.graphics.draw(game.video, 0, 0, 0, swidth/800, swidth/800)
		end
		love.graphics.pop()

		love.graphics.push()
		if data.bgOpacity == 0 then opacity_addition = 0 end
		love.graphics.setColor(0,0,0, (1-data.bgOpacity) - opacity_addition)
		love.graphics.rectangle("fill", 0, 0, game.swidth, game.sheight)
		love.graphics.pop()

		drawMovingObjects(2)

		if game.hp < 0.3 then
			game.dangerFlashO = game.dangerFlashO + 0.008 * 60 * game.dt
			if game.dangerFlashO > 1 then game.dangerFlashO = 1 end
		else
			game.dangerFlashO = game.dangerFlashO - 0.008 * 60 * game.dt
			if game.dangerFlashO < 0 then game.dangerFlashO = 0 end
		end

		love.graphics.push()
		love.graphics.setColor(1,1,1,game.dangerFlashO)
		love.graphics.draw(game.dangerFlash_img, 0, 0, 0, game.swidth/800, game.sheight/600)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(1,1,1,1)
		--love.graphics.scale(1 + (board_surround_scale/200), 1 + (board_surround_scale/200))
		love.graphics.draw(aroundboard_img, board_offset[1] - 10 + bumpx, board_offset[2] - 10  + bumpy)
		love.graphics.pop()

		--love.graphics.scale(1,1)
		--draw the board at 50% opacity

		if bg_color == 2 then
		love.graphics.push()
		love.graphics.setColor(0,0,0,1)
		love.graphics.draw(boardbg_img, board_offset[1] + bumpx + game.board_live_offset[1], board_offset[2] + bumpy + game.board_live_offset[2])
		love.graphics.pop()			
		end

		if bg_color == 3 or game.white_screen then
		love.graphics.push()
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(boardbg_img, board_offset[1] + bumpx + game.board_live_offset[1], board_offset[2] + bumpy + game.board_live_offset[2])
		love.graphics.pop()			
		end

		love.graphics.push()
		love.graphics.setColor(1,1,1,0.5)
		if bg_color == 3 or game.white_screen then love.graphics.setColor(0,0,0,0.5) end
		love.graphics.draw(board_img, board_offset[1] + bumpx + game.board_live_offset[1], board_offset[2] + bumpy + game.board_live_offset[2])
		love.graphics.draw(next_img, 550 + bumpx, board_offset[2] + bumpy)
		love.graphics.pop()

		game.accuracy = game.accuracy and game.accuracy or 0

		local acc_str = game.accuracy and string.sub(tostring(game.accuracy*100), 1, 4) or "0"

		love.graphics.push()

		love.graphics.setColor(1,1,1,1)

		if mode ~= "Freeplay" then
			love.graphics.draw(game.rankLetters[generate_rank(mode)], board_offset[1] - 160 + bumpx, board_offset[2] + 240 + bumpy, 0, 85/game.rankLetters[generate_rank(mode)]:getWidth(), 85/game.rankLetters[generate_rank(mode)]:getHeight())
		end

		if game.beatCount > 0 and game.hpDrain > 0 and game.accuracy and game.accuracy > 0 then
			love.graphics.print(acc_str .. "%", board_offset[1] - 265 + bumpx, board_offset[2] + 280 + bumpy, 0, 1, 1)
		end

		love.graphics.pop()

		game.hpBar = (game.hpBar*3 + game.hp)/4


		if game.hpDrain > 0 then
			love.graphics.push()
			love.graphics.setColor(1,1,1,1)
			love.graphics.print("HP", board_offset[1] - 70 + bumpx, board_offset[2] + 100 + bumpy, 0, 0.6, 0.6)
			love.graphics.pop()

			love.graphics.push()
			love.graphics.setColor(0,0,0,1)
			love.graphics.rectangle("fill", board_offset[1] - 66 + bumpx, board_offset[2] + 124 + bumpy, 22, 202)
			love.graphics.pop()

			love.graphics.push()
			love.graphics.setColor(1,1,1,0.5)
			love.graphics.rectangle("fill", board_offset[1] - 65 + bumpx, board_offset[2] + 125 + bumpy, 20, 200)
			love.graphics.pop()

			love.graphics.push()
			love.graphics.setColor(1,1,1,1)
			love.graphics.rectangle("fill", board_offset[1] - 65 + bumpx, board_offset[2] + 125 + bumpy + 200 - (200 * game.hpBar), 20, 200 - (200 * (1-game.hpBar)))
			love.graphics.pop()
		end
		--print(song:tell("seconds"))
		--draw the next queue if there's a bag


		-- draw the song progress bar

		if song then
			love.graphics.push()
			love.graphics.setColor(1,1,1)
			love.graphics.rectangle("fill", game.bumpx, game.bumpy, 800 * (total_time/song:getDuration()), 10)
			love.graphics.pop()

			love.graphics.push()
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("line", game.bumpx, game.bumpy, 800, 10)
			love.graphics.pop()
		end

		if bag and #bag > 4 and not game.paused then
			love.graphics.push()
			for i = 1, 4 do
				local pieceToDraw = tonumber(string.sub(bag,i,i)) == tonumber(string.sub(bag,i,i)) and tonumber(string.sub(bag,i,i)) or string.sub(bag,i,i)
				local origin = {575,board_offset[2] - 75 + (90 * i)}
				local matrix = pieces[pieceToDraw]

				local ofs = 12
				local yofs = 0

				if pieceToDraw ~= 1 and pieceToDraw ~= 7 then
					ofs = 0
				end

				if #matrix == 2 then
					matrix = {
						{0,0,0,0},
						{0,matrix[1][1], matrix[1][2],0},
						{0,matrix[2][1], matrix[2][2],0},
						{0,0,0,0}
					}
				end

				if pieceToDraw == 7 then
					yofs = 25
				end

				for y, row in pairs(matrix) do
					for x, val in pairs(row) do
						if val > 0 then
							pixel_position = {origin[1] + (25 * (x-1)) - ofs, origin[2] + (25 * (y-1)) - yofs}

							love.graphics.push()
							love.graphics.setColor(1,1,1)
							love.graphics.draw(flashmino_img, pixel_position[1] + bumpx, pixel_position[2] + bumpy, 0, 1, 1)
							love.graphics.pop()
							love.graphics.push()
							love.graphics.setColor(piece_colors[pieceToDraw][1],piece_colors[pieceToDraw][2],piece_colors[pieceToDraw][3],1)
							love.graphics.draw(mino_img, pixel_position[1] + bumpx, pixel_position[2] + bumpy, 0, 25/mino_img:getWidth(), 25/mino_img:getHeight())
							love.graphics.pop()
						end
					end
				end			
			end

			love.graphics.pop()
		end

		love.graphics.push()
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.draw(score_img, 7 + bumpx, board_offset[2] + 500 - 146 + bumpy)
		love.graphics.pop()



		score = score and score or 0
		love.graphics.push()
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("SCORE:", 15 + bumpx, board_offset[2] + bumpy + 380, 0, 0.5, 0.5)
		love.graphics.print(score, 15 + bumpx, board_offset[2] + 400 + bumpy, 0, 0.5, 0.5)		
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("TIME:", 150 + bumpx, board_offset[2] + bumpy + 380, 0, 0.5, 0.5)
		love.graphics.print(f.generate_timestamp(total_time), 150 + bumpx, board_offset[2] + bumpy + 400, 0, 0.5, 0.5)		
		love.graphics.pop()



		if combo -1 > 0 then
			love.graphics.push()
			love.graphics.setColor(1,1,1,1)
			love.graphics.print("COMBO:", 15 + bumpx, board_offset[2] + bumpy + 440, 0, 0.5, 0.5)
			love.graphics.print(combo - 1, 15 + bumpx, board_offset[2] + bumpy + 460, 0, 0.5, 0.5)		
			love.graphics.pop()
		end


		if b2b > 0 then
			love.graphics.push()
			love.graphics.setColor(1,1,0,1)
			love.graphics.print("B2B", 175 + bumpx, board_offset[2] + bumpy + 440, 0, 0.5, 0.5)
			love.graphics.print("x" .. b2b, 175 + bumpx, board_offset[2] + bumpy + 460, 0, 0.5, 0.5)		
			love.graphics.pop()
		end

		if lm_timer > 0 then
			love.graphics.push()
			love.graphics.setColor(1,1,1,lm_timer)
			love.graphics.print(last_move, 15 + bumpx, board_offset[2] + bumpy + 490, 0, 0.65, 0.65)		
			love.graphics.pop()		
		end

		if mode == "Sprint" then
			love.graphics.push()
			love.graphics.setColor(1,1,1,1)
			love.graphics.print("LINES:", 550 + bumpx, board_offset[2] + bumpy + 400, 0,.5 , .5)
			love.graphics.print(game_lines, 550 + bumpx, board_offset[2] + 425 + bumpy, 0, 1, 1)
			love.graphics.print("/" .. lines_goal, 630 + bumpx, board_offset[2] + 440 + bumpy, 0, .5, .5)		
			love.graphics.pop()		

			love.graphics.push()
			love.graphics.setColor(1,1,1,1)
			love.graphics.print("P/s:", 550 + bumpx, board_offset[2] + bumpy + 475, 0,.5 , .5)
			love.graphics.print(string.sub(tostring(total_pieces/total_time),1,4), 550 + bumpx, board_offset[2] + 500 + bumpy, 0, 1, 1)
			love.graphics.pop()		

			love.graphics.push()
			love.graphics.setColor(0,.9,0,1)
			local ratio = game_lines/lines_goal
			love.graphics.rectangle("fill", board_offset[1] - 20 + bumpx, board_offset[2] + bumpy, 10, (500 * ratio))
			love.graphics.pop()	
		end

		if map_position then
			--print(total_time)
			if map_data[2][map_position] then
				love.graphics.push()
				local ratio = (total_time - start_position)/(map_data[2][map_position][1] - start_position)
				love.graphics.setColor(0,.9,0,1)
				love.graphics.rectangle("fill", board_offset[1] - 20 + bumpx + game.board_live_offset[1], board_offset[2] + bumpy + game.board_live_offset[2], 10, (500 * ratio))
				love.graphics.pop()

				for i = 1, #map_data[2][map_position][2] do
					if map_data[2][map_position][2][i][1] == "NewBoard" then
						love.graphics.push()
						if map_data[2][map_position][2][i][3] == false then break end
						local approachTime = type(map_data[2][map_position][2][i][3]) == "number" and map_data[2][map_position][2][i][3] or game.approachRate
						local ratio = 1 - ((map_data[2][map_position][1] - total_time)/approachTime)
						love.graphics.setColor(1,1,1,math.clamp(ratio - 0.2, 0, 1))
						for y, row in pairs(map_data[2][map_position][2][i][2]) do
							for x, val in pairs(row) do
								--map_data[2][map_position][2][i][1]
								if val ~= 0 then
									
									local pos = pl(x,y)

									love.graphics.draw(flashmino_img, pos[1] + bumpx + game.board_live_offset[1], pos[2] + bumpy + game.board_live_offset[2], 0, 1, 1)


									
								end
							end
						end

						love.graphics.pop()
					end
				end

				if map_data[2][map_position][1] == "NewBoard" then
					print("woah")
				end



			end
		end

		if not autodrop_skip and map_data[2][map_position-1] and repeat_table and repeat_progress > 0 and (map_data[2][map_position-1][3]) and (map_data[2][map_position-1][3]) > 0.2 then
			local ratio = (total_time - start_position_r)/(map_data[2][map_position-1][3])

			love.graphics.push()
			love.graphics.setColor(1,ratio,ratio,1)
			love.graphics.rectangle("fill", board_offset[1] + bumpx + game.board_live_offset[1], board_offset[2] + bumpy + game.board_live_offset[2] - 20, (250 * ratio), 10)
			love.graphics.pop()
		end

		if auto_drop then
			love.graphics.push()
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(autodrop_img, 13 + bumpx + game.board_live_offset[1], board_offset[2] + game.board_live_offset[2] + 50 + bumpy)
			love.graphics.pop()
		end	


		--draw the held piece
		if held_piece and not game.paused then
			local ofs = 0
			local yofs = 0
			local origin = {120,board_offset[2] - 20}
			local matrix = pieces[held_piece]
			for y, row in pairs(matrix) do
				for x, val in pairs(row) do
					if val > 0 then
						pixel_position = {origin[1] + (25 * (x-1)) - ofs, origin[2] + (25 * (y-1)) - yofs}

						love.graphics.push()
						love.graphics.setColor(1,1,1)
						love.graphics.draw(flashmino_img, pixel_position[1] + bumpx, pixel_position[2] + bumpy, 0, 1, 1)
						love.graphics.pop()

						love.graphics.push()
						love.graphics.setColor(piece_colors[held_piece][1],piece_colors[held_piece][2],piece_colors[held_piece][3],1)
						love.graphics.draw(mino_img, pixel_position[1] + bumpx, pixel_position[2] + bumpy, 0, 25/mino_img:getWidth(), 25/mino_img:getHeight())
						love.graphics.pop()
					end
				end
			end	
		end

		if(active_piece) and not game.paused then
			local matrix = active_piece.matrix

			local beatProgress = game.totalBeatTime and 1 - (game.timeTilNextBeat/game.totalBeatTime) or 0

			if data.misc.smoothMovement == 1 and game.tweenPieceY then -- snappy
				game.tweenPieceX = (game.tweenPieceX + active_piece.pos.x)/2
				game.tweenPieceY = (game.tweenPieceY + active_piece.pos.y)/2
			elseif data.misc.smoothMovement == 2 and game.tweenPieceY then -- smooth
				game.tweenPieceX = (game.tweenPieceX*4 + active_piece.pos.x)/5
				game.tweenPieceY = (game.tweenPieceY*4 + active_piece.pos.y)/5			
			end


			for y, row in pairs(matrix) do
				for x, val in pairs(row) do
					if val > 0 then
						 --data.misc.smoothMovement = true
						if data.misc.smoothMovement > 0 and game.tweenPieceY then
							pixel_position = pl(game.tweenPieceX + (x-1), game.tweenPieceY + (y-1))
						else
							pixel_position = pl(active_piece.pos.x + (x-1), active_piece.pos.y + (y-1))							
						end

						love.graphics.push()
						love.graphics.setColor(1,1,1)
						love.graphics.draw(flashmino_img, pixel_position[1] + bumpx + game.board_live_offset[1], pixel_position[2] + bumpy + game.board_live_offset[2], 0, 1, 1)
						love.graphics.pop()

						love.graphics.push()
						love.graphics.setColor(piece_colors[val][1],piece_colors[val][2],piece_colors[val][3],1)

						if auto_drop_wait then
							love.graphics.setColor(1,1,1)
						end

						if game.white_screen then
							love.graphics.setColor(0,0,0)
						end

						love.graphics.draw(mino_img, pixel_position[1] + bumpx + game.board_live_offset[1], pixel_position[2] + bumpy + game.board_live_offset[2], 0, 25/mino_img:getWidth(), 25/mino_img:getHeight())
						love.graphics.pop()


						--[[if game.timeTilNextBeat and game.timeTilNextBeat < game.approachRate and game.timeTilNextBeat > 0 then
							local ratio = game.approachRate/game.timeTilNextBeat
							love.graphics.push()
							love.graphics.setColor(1,1,1, (beatProgress - 0.5) * 2)
							love.graphics.draw(flashmino_img, pixel_position[1] + bumpx + game.board_live_offset[1], pixel_position[2] + bumpy + game.board_live_offset[2])							
							love.graphics.pop()
						end]]
					end
				end
			end

			local originalPos = {active_piece.pos.x, active_piece.pos.y}
			local fail = 0
			repeat
				fail = fail + 1
				active_piece.pos.y = active_piece.pos.y + 1
			until not check_collision() or fail > 30
				active_piece.pos.y = active_piece.pos.y - 1
				game.ghostY = active_piece.pos.y
			


			for y, row in pairs(matrix) do -- draw ghost piece
				for x, val in pairs(row) do
					if val > 0 then
						pixel_position = pl(active_piece.pos.x + (x-1), active_piece.pos.y + (y-1))
						love.graphics.push()
						local t = 0.5

						if active_piece.lockProgress > 0 then
							t = 1 - (active_piece.lockProgress/lockTime)
						end
						love.graphics.setColor(piece_colors[val][1] + .25 + game.flashLights[val], piece_colors[val][2] + .25 + game.flashLights[val], piece_colors[val][3] + .25 + game.flashLights[val], t)
						if bg_color == 3 then
						love.graphics.setColor(piece_colors[val][1] - .5 + game.flashLights[val], piece_colors[val][2] - .5 + game.flashLights[val] ,piece_colors[val][3] - .5 + game.flashLights[val] , t)							
						end
						if game.white_screen then
							love.graphics.setColor(0,0,0,t)
						end
						love.graphics.draw(flashmino_img, pixel_position[1] + bumpx + game.board_live_offset[1], pixel_position[2] + bumpy + game.board_live_offset[2])
						love.graphics.pop()
					end
				end
			end

			love.graphics.push()

			local translationFactor = game.approachPieces[active_piece.id]:getWidth()/2
			love.graphics.setColor(piece_colors[active_piece.id][1] + .25 + game.flashLights[active_piece.id], piece_colors[active_piece.id][2] + .25 + game.flashLights[active_piece.id], piece_colors[active_piece.id][3] + .25 + game.flashLights[active_piece.id], t)
			if bg_color == 3 then
				love.graphics.setColor(piece_colors[val][1] - .5 + game.flashLights[val], piece_colors[val][2] - .5 + game.flashLights[val] ,piece_colors[val][3] - .5 + game.flashLights[val] , t)							
			end
			love.graphics.draw(game.approachPieces[active_piece.id], pl(active_piece.pos.x)+translationFactor+bumpx, pl(nil,game.ghostY)+translationFactor+bumpy, math.rad(90)*active_piece.rotation, 1, 1, translationFactor, translationFactor)
			love.graphics.pop()

			active_piece.pos.x = originalPos[1]
			active_piece.pos.y = originalPos[2]


		end


		if not game.paused then
			for y, row in pairs(player_matrix) do
				for x, val in pairs(row) do
					pos = pl(x, y)
					if val > 0 then
						love.graphics.push()
						love.graphics.setColor(1,1,1)
						love.graphics.draw(flashmino_img, pos[1] + bumpx + game.board_live_offset[1], pos[2] + bumpy + game.board_live_offset[2], 0, 1, 1)
						love.graphics.pop()
						love.graphics.push()
						love.graphics.setColor(piece_colors[val][1] + game.flashLights[val], piece_colors[val][2] + game.flashLights[val], piece_colors[val][3] + game.flashLights[val], 1)
						if game.white_screen then
							love.graphics.setColor(game.flashLights[val],game.flashLights[val],game.flashLights[val],1)
						end
						
						love.graphics.draw(mino_img, pos[1] + bumpx + game.board_live_offset[1], pos[2] + bumpy + game.board_live_offset[2], 0, 25/mino_img:getWidth(), 25/mino_img:getHeight())
						love.graphics.pop()
					end
				end
			end
		end

		if game.customDraw ~= nil then
			game.customDraw(total_time, game.beatCount)
		end

		-- draw the beatmapping if there is one
		if game.beatmap then

			love.graphics.push()
			love.graphics.setColor(1,.5,.5,.75)
			love.graphics.rectangle("fill", board_offset[1] + bumpx - 270, board_offset[2] + bumpy + 335, 250, 5)
			love.graphics.pop()

			love.graphics.push()
			love.graphics.setColor(.75,1,.75,1)
			love.graphics.rectangle("fill", board_offset[1] + bumpx + - 175, board_offset[2] + bumpy + 335, 60, 5)
			love.graphics.pop()

			love.graphics.push()
			love.graphics.setColor(0,.75,0,1)
			love.graphics.rectangle("fill", board_offset[1] + bumpx - 155, board_offset[2] + bumpy + 335, 20, 5)
			love.graphics.pop()



			local range_start = total_time - .5
			local range_end = total_time + .5

			if game.timeTilNextBeat and game.timeTilNextBeat < game.approachTime then
				game.approachRatio = 1 - (game.timeTilNextBeat/game.approachTime)
			else
				game.approachRatio = 0
			end

			--print(#game.beatmap)

			local length = 400

			game.switch = false
			if game.approachRatio > 0 then


				local lookingAhead = -1
				for index, time in pairs(game.beatmap) do


					if total_time < time and (time - total_time) < game.approachTime then 
						lookingAhead = lookingAhead + 1
						local ratio = 1 - ((time - total_time)/game.approachTime)
						love.graphics.push()
						--love.graphics.setColor(255/255, 153/255, 64/255)

						--game.switch = not game.switch

						game.switch = (index / 2 ~= math.floor(index / 2) and true or false)



						if game.switch then
							love.graphics.setColor(1,153/255,64/255)
						else
							love.graphics.setColor(52/255, 140/255, 235/255)
						end

						--love.graphics.setColor(1,(1-ratio)*(153/255) + (ratio),(1-ratio)*(64/255) + (1-ratio))
						if game.timeTilNextBeat < 0.1 then
							if game.switch then
								love.graphics.setColor(1,153/255 + 0.5,64/255 + 0.5)
							else
								love.graphics.setColor(1, 43/255 + 0.5, 139/255 + 0.5)
							end						
						end


						
						local offset = 5
						local fin = length*ratio + offset
						if fin > length then fin = length end
						game.ghostY = game.ghostY and game.ghostY or 19




						love.graphics.rectangle("fill", board_offset[1] + bumpx + 250, board_offset[2] + bumpy, 20, fin)
						--love.graphics.rectangle("fill", board_offset[1] + bumpx + 250, board_offset[2] + bumpy + 500, 20, -fin)				
						love.graphics.pop()

						love.graphics.push()

						for i = 1,1 do
							ratio = (ratio - 0.5)
							if ratio < 0 then ratio = 0 end
							ratio = ratio * 2
						end

						local initScale = 3
						local scale = (1 * ratio) + (initScale * (1 - ratio))
						local translationFactor = game.approachPieces[active_piece.id]:getWidth()/2



						data.approachMinoPos = data.approachMinoPos and data.approachMinoPos or 1


						if lookingAhead == 0 then
							--love.graphics.setColor(piece_colors[active_piece.id][1], piece_colors[active_piece.id][2], piece_colors[active_piece.id][3], ratio)
							love.graphics.setColor(1,1,1, ratio/1.45)
						else

							local pieceToCheck = string.sub(bag, lookingAhead, lookingAhead)
							pieceToCheck = tonumber(pieceToCheck) == tonumber(pieceToCheck) and tonumber(pieceToCheck) or pieceToCheck
							love.graphics.setColor(piece_colors[pieceToCheck][1] + .25, piece_colors[pieceToCheck][2] + .25, piece_colors[pieceToCheck][3] + .25, ratio/2)
						end

						if data.approachMinoPos ~= 0 and game.hpDrain ~= 0 then
							love.graphics.draw(game.approachPieces[active_piece.id], pl(active_piece.pos.x)+translationFactor+bumpx, pl(nil,(data.approachMinoPos == 1 and game.ghostY or active_piece.pos.y))+translationFactor+bumpy, math.rad(90)*active_piece.rotation, scale, scale, translationFactor, translationFactor)
						end

						love.graphics.pop()

						love.graphics.push()
						love.graphics.setColor(0,0,0,1)
						love.graphics.rectangle("line", board_offset[1] + bumpx + 250, board_offset[2] + bumpy, 20, fin)
						love.graphics.rectangle("line", board_offset[1] + bumpx + 250-1, board_offset[2] + bumpy, 20,fin + 2)
						--love.graphics.rectangle("line", board_offset[1] + bumpx + 250, board_offset[2] + bumpy + 500, 20, -fin)
						--love.graphics.rectangle("line", board_offset[1] + bumpx + 250-1, board_offset[2] + bumpy + 500, 20, -fin - 2)
						love.graphics.pop()


						--love.graphics.push()
	
						--love.graphics.rectangle("fill", board_offset[1] + bumpx, (board_offset[2] + bumpy)*ratio - 5 - 10, 250, 7*ratio)
						--love.graphics.rectangle("fill", board_offset[1] + bumpx, game.sheight - ((board_offset[2] + bumpy)*ratio - 5) + 20, 250, 7*ratio)
						--love.graphics.pop()



					end
				end
			end

			love.graphics.push()


			love.graphics.setColor(.5,.5,.5,1)
			love.graphics.rectangle("fill", board_offset[1] + bumpx + 245, board_offset[2] + bumpy+length, 30, (500-length))
			love.graphics.pop()

			love.graphics.push()
			love.graphics.setColor(1,1,1,1)
			love.graphics.rectangle("fill", board_offset[1] + bumpx + 245, board_offset[2] + bumpy+length, 30, 5)
			love.graphics.pop()



			love.graphics.push()
			love.graphics.setColor(1,1,1,1)

			local caught = false
			local printedGoal = false


			for index, time in pairs(game.origBeatmap) do
				if game.origBeatmap[index+1] and total_time < game.origBeatmap[index+1] then -- looking at the NEXT beat
					local startTime = game.origBeatmap[index] and game.origBeatmap[index] or 0
					local endTime = game.origBeatmap[index+1]

					if endTime then
						local goalTime = (startTime+endTime)/2
						--if not printedGoal then print(goalTime) printedGoal = true end
						if total_time >= goalTime and not game.halfBeatTracker[index] then
							game.halfBeatTracker[index] = true
							--playSFX(halfBeat_snd)		
							print("hit")					
						end
					end
				end
			end

			for index, i in pairs(game.beatmap) do
				local time = i




				--[[if game.beatmap[index+1] and total_time < game.beatmap[index+1] then
					local startTime = game.beatmap[index-1] and game.beatmap[index-1] or 0
					local endTime = game.beatmap[index-1]

					if endTime and startTime then
						local goalTime = (startTime+endTime)/2
						if not printedGoal then print(goalTime) printedGoal = true end
						if total_time >= goalTime and not game.halfBeatTracker[index-1] then
							game.halfBeatTracker[index-1] = true
							playSFX(halfBeat_snd)		
							print("hit")					
						end
					end					
				end]]

				--[[if total_time < time and index <= game.beatCount + 5 then
					local startTime = game.beatmap[index]
					local endTime = game.beatmap[index+1]
					if endTime and startTime then
						local goalTime = (startTime+endTime)/2

						local goal = endTime - startTime
						local progress = startTime - total_time

						local ratio = 1-(progress/goal)
						print(goalTime)
						if total_time >= goalTime and not game.halfBeatTracker[index-1] then
							game.halfBeatTracker[index-1] = true
							playSFX(halfBeat_snd)
						end	
					end
				end]]

				local accuracy = math.abs(i - total_time)

				if accuracy < game.approachTime and total_time < i and not caught then
					caught = true
					game.timeTilNextBeat = i - total_time
				end

				if i < range_start then
					game.hp = game.hp - game.hpDrain
					game.beatmap[index] = nil
					game.beatCount = game.beatCount + 1
					game.missCount = game.missCount + 1

					if game.hpDrain > 0 then
						table.insert(movingObjects,{
							img = game.miss_img,
							position = {550 + game.bumpx,500 + game.bumpy},
							scale = {220/game.miss_img:getWidth(),24/game.miss_img:getHeight()},
							rotation = 0,
							rotVelocity = 0.1,
							opacity = 1,
							opacityDelta = -0.05,
							velocity = {0,0},
							acceleration = {0,0.5},
							lifetime = 1,
							color = {1,1,1},
							layer = 2
						})
					end
				end

				if i > range_start and i < range_end then

					local goal = range_end - total_time + 0.5
					local progress = i - range_start
					local ratio = progress/goal
					local x = board_offset[1] - 20 - (250*ratio)
					local y = board_offset[2] + 330
					love.graphics.rectangle("line", x + bumpx, y + bumpy, 5, 15)
				end
			end

			if not caught then game.timeTilNextBeat = 1000 end
			love.graphics.pop()
		end


		for index, item in pairs(flash_minos) do
			local matrixPosition = item[1]
			local opacity = item[2]
			local decay = item[3]

			local realPosition = pl(matrixPosition[1],matrixPosition[2])

			love.graphics.push()
			love.graphics.setColor(1, 1, 1, opacity)
			love.graphics.draw(flashmino_img, realPosition[1] + bumpx, realPosition[2] + bumpy)
			love.graphics.pop()

			item[2] = item[2] - decay

			if item[2] <= 0 then
				flash_minos[index] = nil
			end
		end

		if game.pauseOpacity > 0 then -- draw the pause menu
			print(game.pauseOpacity)
			love.graphics.push()
			love.graphics.setColor(0,0,0,game.pauseOpacity)
			love.graphics.draw(flashmino_img, 0, 0, 0, 500, 500)
			love.graphics.pop()

			local ofs = 150
			for index, item in pairs(game.pauseOptions) do
				love.graphics.push()
				if game.pauseItem ~= index then
					love.graphics.setColor(.85,.85,.85)
				else
					game.pauseParticleSwitch = not game.pauseParticleSwitch
					if game.pauseParticleSwitch then 
						table.insert(movingObjects, {
							img = game.pauseParticle,
							position = {150 + bumpx, 125 + bumpy + ofs},
							ignorePause = true,
							velocity = {(math.random(-4,4)/8),-0.2},
							acceleration = {0,0.125},
							lifetime = 0.5,
							opacity = 1,
							opacityDelta = -0.025,
							scale = {game.pauseParticle:getWidth()/50,game.pauseParticle:getHeight()/50},
							scaleDelta = {-0.025, -0.025},
							layer = 3,
							color = {1,1,1},
							scaleOffset = {25, 25}
						})
					end

					love.graphics.setColor(1,1,0.2)
				end



				love.graphics.print(item, 200 + bumpx, 100 + bumpy + ofs)
				ofs = ofs + 50
				love.graphics.pop()
			end
		end

	elseif game_state == "Menu" then


		love.graphics.push()
		love.graphics.draw(menu_bg, game.swidth/2, game.sheight/2, 0, game.swidth/menu_bg:getWidth(), game.sheight/menu_bg:getHeight(), menu_bg:getWidth()/2, menu_bg:getHeight()/2)
		love.graphics.print(version, game.bumpx + 10, game.bumpy + 580, 0, 0.5, 0.5)
		love.graphics.pop()



		drawMovingObjects(2)


		


		love.graphics.push()
		love.graphics.setColor(0.2,0,0.3, 1)
		love.graphics.draw(menu_ui, (800-654)/2 + 25 + bumpx, 150 + 25 + bumpy)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		love.graphics.draw(menu_ui, (800-654)/2 + bumpx, 150 + bumpy)
		love.graphics.pop()

		for n, text in pairs (menuItems) do
			love.graphics.push()

			local add = 0

			if string.sub(text, 1, 5) == "Back " or string.sub(text, 3, 7) == "Back " or text == "Back" then
				add = 25
			end

			love.graphics.setColor(0,0,0,1)
			love.graphics.print(text, 93 + bumpx, 153 + bumpy + add + 25 * n, 0, .6, .6)

			love.graphics.pop()
			love.graphics.push()

			love.graphics.setColor(1,1,1, 1)

			local t = {"Auto","1x","1.25x","1.5x","2x"}
			if text == "Screen Zoom" or text == "> Screen Zoom" then
				love.graphics.print(t[data.boardZoom], 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if n == selected_menu_item then
				love.graphics.setColor(1,1,0, 1)
				text = "> "..text
			else
				love.graphics.setColor(.8,.8,.8,1)
			end
			love.graphics.print(text, 90 + bumpx, 150 + bumpy + add + 25 * n, 0, .6, .6)

			if text == "Move Piece Left" or text == "> Move Piece Left" then
				love.graphics.print(string.upper(key.left) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "-Move Piece Left" or text == "> -Move Piece Left" then
				love.graphics.print(string.upper(data.gamepadControls.left) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Move Piece Right" or text == "> Move Piece Right" then
				love.graphics.print(string.upper(key.right) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "-Move Piece Right" or text == "> -Move Piece Right" then
				love.graphics.print(string.upper(data.gamepadControls.right) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Soft Drop" or text == "> Soft Drop" then
				love.graphics.print(string.upper(key.softdrop) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "-Soft Drop" or text == "> -Soft Drop" then
				love.graphics.print(string.upper(data.gamepadControls.softdrop) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Rotate 180 Degrees" or text == "> Rotate 180 Degrees" then
				love.graphics.print(string.upper(key.rotate180) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "-Rotate 180 Degrees" or text == "> -Rotate 180 Degrees" then
				love.graphics.print(string.upper(data.gamepadControls.rotate180) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Hard Drop" or text == "> Hard Drop" then
				love.graphics.print(string.upper(key.harddrop) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "-Hard Drop" or text == "> -Hard Drop" then
				love.graphics.print(string.upper(data.gamepadControls.harddrop) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Rotate CW (Right)" or text == "> Rotate CW (Right)" then
				love.graphics.print(string.upper(key.cwrotate) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "-Rotate CW (Right)" or text == "> -Rotate CW (Right)" then
				love.graphics.print(string.upper(data.gamepadControls.cwrotate) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Rotate CCW (Left)" or text == "> Rotate CCW (Left)" then
				love.graphics.print(string.upper(key.ccwrotate) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "-Rotate CCW (Left)" or text == "> -Rotate CCW (Left)" then
				love.graphics.print(string.upper(data.gamepadControls.ccwrotate) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Hold Piece" or text == "> Hold Piece" then
				love.graphics.print(string.upper(key.hold) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Quick Restart" or text == "> Quick Restart" then
				love.graphics.print(string.upper(key.restart) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "-Hold Piece" or text == "> -Hold Piece" then
				love.graphics.print(string.upper(data.gamepadControls.hold) .. "", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if (text == "-Song:" or text == "> -Song:") and not game.songDataName then
				love.graphics.print("(Drag and drop a .mp3 file for generation!)", 250 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end

			if (text == "-Song:" or text == "> -Song:") and game.songDataName then
				love.graphics.print(game.songDataName, 250 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end

			if text == "-Song Start Time:" or text == "> -Song Start Time:" then
				love.graphics.print( "< " .. f.generate_timestamp(game.mapGen.startTime).." >", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end

			if text == "-Song End Time:" or text == "> -Song End Time:" then
				love.graphics.print( "< " .. f.generate_timestamp(game.mapGen.endTime).." >", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end

			if text == "-Song Preview Time:" or text == "> -Song Preview Time:" then
				love.graphics.print( "< " .. f.generate_timestamp(game.mapGen.previewTime).." >", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end

			if text == "-Song Offset:" or text == "> -Song Offset:" then
				love.graphics.print( "< " .. f.generate_timestamp(game.mapGen.offset).." >", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end

			if text == "-Song BPM:" or text == "> -Song BPM:" then
				love.graphics.print("< "..game.mapGen.bpm.." BPM >", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end

			if text == "Board Background" then
				love.graphics.print(bg_color == 1 and "TRANSPARENT" or bg_color == 2 and "BLACK" or bg_color == 3 and "WHITE", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end

			if text == "> Board Background" then
				love.graphics.print("<"..(bg_color == 1 and "TRANSPARENT" or bg_color == 2 and "BLACK" or bg_color == 3 and "WHITE")..">", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end


			if text == "Master Volume" then
				love.graphics.print((data.volume.master * 100) .. "%", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end		

			if text == "> Master Volume" then
				love.graphics.print("<"..(data.volume.master * 100) .. "%>", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end		

			if text == "Music Volume" then
				love.graphics.print((data.volume.music * 100) .. "%", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end		

			if text == "> Music Volume" then
				love.graphics.print("<"..(data.volume.music * 100) .. "%>", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end		

			if text == "SFX Volume" then
				love.graphics.print((data.volume.sfx * 100) .. "%", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end		

			if text == "> SFX Volume" then
				love.graphics.print("<"..(data.volume.sfx * 100) .. "%>", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)								
			end		

			if text == "Tetromino Design" then
				love.graphics.draw(flashmino_img, 515 + bumpx, 147 + bumpy + 25 * n, 0,  1, 1)
				love.graphics.draw(mino_img, 515 + bumpx, 147 + bumpy + 25 * n, 0, 25/mino_img:getWidth(), 25/mino_img:getHeight())
			end

			if text == "> Tetromino Design" then
				love.graphics.draw(flashmino_img, 515 + bumpx, 147 + bumpy + 25 * n, 0, 1, 1)
				love.graphics.draw(mino_img, 515 + bumpx, 147 + bumpy + 25 * n, 0, 25/mino_img:getWidth(), 25/mino_img:getHeight())
				love.graphics.print("<", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
				love.graphics.print("> ("..selected_mino..")", 546 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)

			end
			
			if text == "Piece Flash" then
				love.graphics.print(piece_flash == true and "ON" or "OFF", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)				
			end

			if text == "Active Piece Movement" or text == "> Active Piece Movement" then
				love.graphics.print(data.misc.smoothMovement == 1 and "Snappy" or data.misc.smoothMovement == 2 and "Smooth" or "Classic", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)				
			end
			approachPieceOptions = {
				[0] = "None",
				[1] = "Ghost Piece",
				[2] = "Active Piece"
			}
			if text == "Approach Piece Location" or text == "> Approach Piece Location" then
				love.graphics.print(approachPieceOptions[data.approachMinoPos], 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)				
			end

			if text == "> Piece Flash" then
				love.graphics.print("<"..(piece_flash == true and "ON" or "OFF")..">", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)				
			end

			if text == "Set Resolution" then
				love.graphics.print(resolutions[selected_resolution][1].."x"..resolutions[selected_resolution][2], 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "> Set Resolution" then
				love.graphics.print("<"..resolutions[selected_resolution][1].."x"..resolutions[selected_resolution][2]..">", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end


			if text == "Background Opacity" then
				if not data.bgOpacity then data.bgOpacity = 0.5 end

				love.graphics.print(data.bgOpacity * 100 .. "%", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "> Background Opacity" then
				love.graphics.print("<"..data.bgOpacity * 100 .. "%>", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "> Delayed Auto Shift" then
				love.graphics.print("<" ..handling.das * 1000 .. " ms>", 490 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Automatic Repeat Rate" then
				love.graphics.print(1/handling.arr .. "/s", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "> Automatic Repeat Rate" then
				love.graphics.print("<" ..1/handling.arr .. "/s>", 490 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "Soft Drop Rate" then
				love.graphics.print((handling.sdr == 60 and "inf" or (handling.sdr .. "x")) , 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			if text == "> Soft Drop Rate" then
				love.graphics.print("<"..(handling.sdr == 60 and "inf" or (handling.sdr .. "x")) .. ">", 500 + bumpx, 150 + bumpy + 25 * n, 0, .6, .6)
			end

			love.graphics.pop()
		end

		if waitingForInput then
			love.graphics.print("Waiting for input - Press DELETE to cancel", (800-654)/2 + bumpx, 125 + bumpy, 0, 0.6, 0.6)
		elseif menuItems == controlsMenu then
			love.graphics.print("(Press DELETE to reset controls to default)", (800-654)/2 + bumpx, 125 + bumpy, 0, 0.6, 0.6)			
		end
		love.graphics.push()
		love.graphics.setColor(1,1,1, 1)
		love.graphics.draw(logo_img, 125 + bumpx, 10 + bumpy, 0, 550/logo_img:getWidth(), 125/logo_img:getHeight())
		love.graphics.pop()

	elseif game_state == "Results" then


			
		


		if song and song:tell() < 5 then song:stop() end

		love.graphics.push()
		love.graphics.draw(menu_bg, 0, 0, 0, swidth/800, swidth/800)	
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(0.2,0,0.3)
		love.graphics.draw(menu_ui, (800-654)/2 + 25 + bumpx, 150 + 25 + bumpy)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		love.graphics.draw(menu_ui, (800-654)/2 + bumpx, 150 + bumpy)
		love.graphics.pop()		

		love.graphics.push()
		love.graphics.setColor(1,1,.5, 1)
		love.graphics.print("RESULTS", 75 + bumpx, 100 + bumpy, 0, 1.5, 1.5)
		love.graphics.pop()

		local menu = {
			"Watch Replay",
			"Exit",
			"Try Again",
		}

		local ofs = 115
		local rate = 250
		for i = 1, #menu do
			love.graphics.push()

			if i == game.selectedResultsItem then
				love.graphics.setColor(1,1,0)
			else
				love.graphics.setColor(1,1,1)
			end

			love.graphics.print(menu[i], ofs + bumpx, 500 + bumpy, 0, 0.8, 0.8)
			ofs = ofs + rate
			rate = rate - 125
			love.graphics.pop()
		end

		love.graphics.push()
		love.graphics.setColor(1,1,1, 1)
		love.graphics.print(game.songName, 400 + bumpx, 100 + bumpy, 0, .6, .6)
		love.graphics.print("["..game.songDifficulty.."]", 400 + bumpx, 125 + bumpy, 0, .6, .6)		
		love.graphics.pop()


		local modes = {
			["Sprint"] = "40 Line Sprint",
			["Marathon"] = "Marathon"
		}

		love.graphics.push()
		love.graphics.setColor(1,1,game.highScore and 0 or 1)
		love.graphics.print("Score:", 115 + bumpx, 200 + bumpy, 0, 0.6, 0.6)
		love.graphics.print(score, 115 + bumpx, 225 + bumpy, 0, 0.8, 0.8)
		love.graphics.pop()				


		love.graphics.push()
		love.graphics.setColor(1,1,1)
		if mode == "Map" and game.hpDrain > 0 then
			love.graphics.print("Accuracy:", 555 + bumpx, 200 + bumpy, 0, 0.6, 0.6)
			love.graphics.print(string.sub(tostring(game.accuracy * 100), 1, 5) .. "%", 555 + bumpx, 225 + bumpy, 0, 0.8, 0.8)			
		else
			love.graphics.print("Time:", 555 + bumpx, 200 + bumpy, 0, 0.6, 0.6)
			love.graphics.print(f.generate_timestamp(total_time), 555 + bumpx, 225 + bumpy, 0, 0.8, 0.8)
		end
		love.graphics.pop()	

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		love.graphics.print("Lines:", 115 + bumpx, 320 + bumpy, 0, 0.6, 0.6)
		love.graphics.print(game_lines, 115 + bumpx, 345 + bumpy, 0, 0.8, 0.8)
		love.graphics.pop()		

		local rank = generate_rank(mode, score, total_time)

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		love.graphics.print("Rank:", 250 + bumpx, 175 + bumpy, 0, 0.6, 0.6)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		---love.graphics.setFont(love.graphics.newFont("/assets/skins/"..game.skin.."/font.ttf", 102))

		love.graphics.draw(game.rankLetters[rank], 345 + bumpx, 190 + bumpy, 0, 85/game.rankLetters[rank]:getWidth(), 85/game.rankLetters[rank]:getHeight())
		love.graphics.pop()	

		---love.graphics.setFont(love.graphics.newFont("/assets/skins/"..game.skin.."/font.ttf", 32))

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		if mode == "Map" then
			love.graphics.print("Perfect Hits: "..game.perfectCount, 245 + bumpx, 320 + bumpy, 0, 0.6, 0.6)
			love.graphics.print("Nice Hits: "..game.niceCount, 245 + bumpx, 350 + bumpy, 0, 0.6, 0.6)
			if game.hpDrain > 0 then
				love.graphics.print("Misses: "..game.missCount, 245 + bumpx, 380 + bumpy, 0, 0.6, 0.6)
			end
		else
			love.graphics.print("T-Spin Singles: "..stats["tspin singles"], 245 + bumpx, 320 + bumpy, 0, 0.6, 0.6)
			love.graphics.print("T-Spin Doubles: "..stats["tspin doubles"], 245 + bumpx, 350 + bumpy, 0, 0.6, 0.6)
			love.graphics.print("T-Spin Triples: "..stats["tspin triples"], 245 + bumpx, 380 + bumpy, 0, 0.6, 0.6)
		end
		love.graphics.pop()	

		love.graphics.push()
		love.graphics.setColor(1,1,0)
		love.graphics.print("B2Bs:", 550 + bumpx, 300 + bumpy, 0, 0.6, 0.6)
		love.graphics.print(stats["b2bs"], 550 + bumpx, 325 + bumpy, 0, 0.8, 0.8)
		love.graphics.pop()		

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		love.graphics.print("Quads:", 550 + bumpx, 360 + bumpy, 0, 0.6, 0.6)
		love.graphics.print(stats["tetrises"], 550 + bumpx, 385 + bumpy, 0, 0.8, 0.8)
		love.graphics.pop()		

		--love.graphics.push()
		--love.graphics.setColor(1,1,1,1)
		--love.graphics.print("PRESS ENTER TO RETURN", 150 + bumpx, 460 + bumpy, 0, 0.6, 0.6)
		--love.graphics.pop()

		if modes[mode] then

		end


		love.graphics.setColor(1,1,1)

	elseif game_state == "Editor" then
		love.graphics.push()
		love.graphics.setColor(0,.25,0)
		love.graphics.rectangle("fill", 100 + bumpx, 500 + bumpy, 600, 5)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		love.graphics.print(f.generate_timestamp(0), 90 + bumpx, 510 + bumpy, 0, 0.5, 0.5)
		love.graphics.print(f.generate_timestamp(editor.song:getDuration()), 665 + bumpx, 510 + bumpy, 0, 0.5, 0.5)
		love.graphics.print(f.generate_timestamp(editor.song:tell()), 370 + bumpx, 550 + bumpy, 0, 0.75, 0.75)
		love.graphics.pop()

		if editor.timestamps[editor.currentBeat+1] and editor.timestamps[editor.currentBeat+1][1] <= editor.song:tell() then
			editor.currentBeat = editor.currentBeat + 1
			playSFX(hold_snd)
		end

		for i, item in pairs(editor.timestamps) do
			love.graphics.push()



			if item[3] == "red" then
				love.graphics.setColor(1,0.5,0.5)
			elseif item[3] == "green" then
				love.graphics.setColor(0.5,1,0.5)
			else
				love.graphics.setColor(.5,.5,.5)
			end


			love.graphics.rectangle("fill", 100 + bumpx + (600*item[1]/editor.song:getDuration()), 490 + bumpy, 5, 20)	
	
			love.graphics.pop()

		end

		love.graphics.push()
		
		for i, item in pairs(editor.timestamps) do
			if item[3] == "red" then
				love.graphics.setColor(1,0.5,0.5)
			elseif item[3] == "green" then
				love.graphics.setColor(0.5,1,0.5)
			else
				love.graphics.setColor(.5,.5,.5)
			end



			if i == editor.currentBeat then
				love.graphics.setColor(1,1,1,1)
			end

			if i == editor.selectedBeat then
				love.graphics.setColor(1,1,0)
			end

			love.graphics.print((i-1)..": "..string.sub(item[1],1,5), (110 * math.floor((i-1)/32)) + bumpx - 200, bumpy + (15 * (i-1)) - (math.floor((i-1)/32)* (15*32)), 0, 0.3, 0.3)
		end
		love.graphics.pop()

		if love.keyboard.isDown("space") then
			editor.song:setPitch(0.5)
		else
			editor.song:setPitch(1)
		end

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		love.graphics.rectangle("fill", 100 + bumpx + (600*editor.song:tell()/editor.song:getDuration()), 490 + bumpy, 5, 20)
		love.graphics.pop()


	elseif game_state == "MapSelect" then
		-----------------------------------------------------------------------------------------------
		if not game.mapListing then game.mapListing = generateMapList(maps) end



		if game.mapBg then
			love.graphics.push()
			love.graphics.setColor(1,1,1)
			love.graphics.draw(game.mapBg, game.swidth/2, game.sheight/2, 0, game.swidth/game.mapBg:getWidth(), game.swidth/game.mapBg:getWidth(), game.mapBg:getWidth()/2, game.mapBg:getHeight()/2)
			love.graphics.pop()
		end


		drawMovingObjects(2)

		love.graphics.push()
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(mapselect_overlay_img, 0, 0, 0, game.swidth/800, game.sheight/600)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(1,1,1,1)
		love.graphics.printf(game.mapListing[game.selectedMap].name, 0, game.bumpy + 125, game.swidth, "center")
		love.graphics.printf(game.mapListing[game.selectedMap].artist, 0, game.bumpy + 165, game.swidth*2, "center", 0, 0.5, 0.5)

		print()

		for i, v in pairs(game.mapListing[game.selectedMap].mappings) do
			--print(i..": "..tostring(v))
		end

		--print(game.mapListing[game.selectedMap].mappings[game.selectedDifficulty])

		if data.scores[game.mapListing[game.selectedMap].map_id] and data.scores[game.mapListing[game.selectedMap].map_id][cleanString(game.songDifficulty)] then
			game.mapScoreData = data.scores[game.mapListing[game.selectedMap].map_id][cleanString(game.songDifficulty)]
		else
			game.mapScoreData = {
				score = 0,
				rank = "?",
				accuracy = 0,
				hpDrain = 0
			}
		end

		love.graphics.print("Escape - Back", game.bumpx + 10, game.bumpy + 10, 0, 0.5, 0.5)



		love.graphics.pop()

		if game.mapScoreData and game.mapListing[game.selectedMap].mappings[game.selectedDifficulty] then

			love.graphics.push()
			love.graphics.draw(game.hsContain_img, game.bumpx + 280 - 20, game.bumpy + 450 - 50, 0, .8, .8)
			love.graphics.print("HIGH SCORE:", game.bumpx + 280, game.bumpy + 450 - 30, 0, .7, .7)
			love.graphics.print(game.mapScoreData.score, game.bumpx + 280, game.bumpy + 450, 0, 1, 1)
			love.graphics.draw(game.rankLetters[game.mapScoreData.rank], game.bumpx + 280 + 160, game.bumpy + 450 - 15, 0, 1, 1)
			love.graphics.pop()

			if not game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].hpDrain or game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].hpDrain > 0 then
				love.graphics.push()
				love.graphics.setColor(.8,.8,1,1)
				love.graphics.print(string.sub(tostring(game.mapScoreData.accuracy * 100), 1, 5) .. "%", game.bumpx + 280, game.bumpy + 450 + 35, 0, 1, 1)			
				love.graphics.pop()
			end
		end


		love.graphics.push()
		love.graphics.setColor(.5,.5,.5,1)

		if game.mapListing[game.selectedMap - 1] then
			love.graphics.printf(game.mapListing[game.selectedMap-1].name, game.bumpx + 70, game.bumpy + 75, 500, "left", 0, 0.75, 0.75)			
		end

		if game.mapListing[game.selectedMap + 1] then
			love.graphics.printf(game.mapListing[game.selectedMap+1].name, game.bumpx + 525, game.bumpy + 75, 500, "left", 0, 0.75, 0.75)			
		end

		love.graphics.pop()



		local ofs = 0
		local index = game.selectedDifficulty
		local item = game.mapListing[game.selectedMap].mappings[index]
		--for index, item in pairs(game.mapListing[game.selectedMap].mappings) do
			love.graphics.push()

			if index == game.selectedDifficulty then
				love.graphics.setColor(1,1,0)

				game.songDifficulty = item[1].difficulty
			else
				love.graphics.setColor(.6,.6,.6)
			end

			

			if #item[1].beatmap > 10 then

				local lengthToCheck = math.floor(#item[1].beatmap/20)
				local maxPPS = 0
				for i = 1, #item[1].beatmap - lengthToCheck do
					local totalTime = item[1].beatmap[i+lengthToCheck] - item[1].beatmap[i]
					local beats = lengthToCheck
					if (beats/totalTime) >= maxPPS then maxPPS = (beats/totalTime) end
				end

				local res1 = maxPPS

				lengthToCheck = 5
				local maxPPS = 0
				for i = 1, #item[1].beatmap - lengthToCheck do
					local totalTime = item[1].beatmap[i+lengthToCheck] - item[1].beatmap[i]
					local beats = lengthToCheck
					if (beats/totalTime) >= maxPPS then maxPPS = (beats/totalTime) end
				end

				local res2 = maxPPS

				local final_weighted = ((res1 * 0.6) + (res2 * 0.4)) * 3.5
				pps = string.sub(tostring(final_weighted),1,4)
			else
				pps = "???"
			end


			local totalTime 
			
			if item[1].beatmap and item[1].beatmap[1] then
				totalTime = item[1].beatmap[#item[1].beatmap] - item[1].beatmap[1]
			else
				totalTime = 0
			end

			local pps_string = " ("..pps.."*)"

			love.graphics.printf(item[1].difficulty, 0, game.bumpy + 220 + ofs, game.swidth*(1/0.7), "center", 0, 0.7, 0.7)
			love.graphics.printf("UP/DOWN: Change difficulty", 0, game.bumpy + 250 + ofs, game.swidth*(1/0.5), "center", 0, 0.5, 0.5)

			if not item[1].hpDrain or item[1].hpDrain > 0 then
				local f = love.graphics.getFont()
				local ofz = f:getWidth(item[1].difficulty)*0.7/2 + 75
				love.graphics.printf(pps_string, 0, game.bumpy + 200 + ofs, game.swidth*(1/0.5), "center", 0, 0.5, 0.5)
			end

			ofs = ofs + 30

			love.graphics.pop()
		--end	
	
	end

	if game_state == "NewMapSelect" then
		if not game.mapListing then game.mapListing = generateMapList(maps) print(game.mapListing) end

		if game.mapBg then
			love.graphics.push()
			love.graphics.setColor(1,1,1)
			love.graphics.draw(game.mapBg, game.swidth/2, game.sheight/2, 0, game.swidth/game.mapBg:getWidth(), game.swidth/game.mapBg:getWidth(), game.mapBg:getWidth()/2, game.mapBg:getHeight()/2)
			love.graphics.pop()
		end

		if game.mapBg then
			love.graphics.push()
			love.graphics.setColor(1,1,1)
			love.graphics.draw(game.mapBg, game.swidth/2, game.sheight/2, 0, game.swidth/game.mapBg:getWidth(), game.swidth/game.mapBg:getWidth(), game.mapBg:getWidth()/2, game.mapBg:getHeight()/2)
			love.graphics.pop()
		end


		drawMovingObjects(2)

		love.graphics.push()
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(mapselect_overlay_img, 0, 0, 0, game.swidth/800, game.sheight/600)
		love.graphics.pop()	

		love.graphics.push()
		love.graphics.draw(game.mapSelectOverlay_img, game.bumpx + 450, game.bumpy - 25, 0, game.mapSelectOverlay_img:getWidth()/360* 3, game.mapSelectOverlay_img:getHeight()/511 * 1.5, game.mapSelectOverlay_img:getWidth(), 0)
		love.graphics.pop()

		
		--local offset
		--local offset = 40
		if game.selectedMap then
			--local distance = 35
			local distance = 35
			offset = offset and offset or #game.mapListing * distance

			local oldOfs = offset
			realOffset = game.selectedMap * distance

			offset = ((offset * 9) + (realOffset))/10

			local deltaOfs = math.abs(offset - oldOfs)

			local position = 400
			for index, item in pairs(game.mapListing) do
				
				local y = game.bumpy + position - offset

				local distFromCenter = (y - (game.bumpy + 360))

				local rot = distFromCenter / 300

				local back = math.abs(distFromCenter / 27)^2 * 1.25



				if not game.font then game.font = love.graphics:getFont() end

				local width = game.font:getWidth(item.name) * 0.75
				local scale = 0.75

				if width > 300 then
					scale = .75 * (300/width)
				end

				local width = game.font:getWidth(item.name) * scale

				--scale = scale * (300/width)		

				--scale = scale + (distFromCenter/600)

				love.graphics.push()
				love.graphics.setColor(0,0,0,1)
				love.graphics.print(item.name, game.bumpx + 125 - back, y+4, rot, scale, scale)

				love.graphics.pop()

				love.graphics.push()
				if index == game.selectedMap then
					love.graphics.setColor(1,1,.5,1)
				else
					love.graphics.setColor(.5,.5,.5,1)
				end

				love.graphics.print(item.name, game.bumpx + 125 - back, y, rot, scale, scale)

				love.graphics.pop()



				position = position + distance
			end
		end

		love.graphics.push()
		love.graphics.setColor(1,1,1)

		game.decorScale = game.decorScale and game.decorScale or 1
		love.graphics.draw(game.menuBeatCircle_img, game.bumpx - 150, game.bumpy + 355, 0, 250/game.menuBeatCircle_img:getWidth() * 2 * game.decorScale, 250/game.menuBeatCircle_img:getHeight() * 2 * game.decorScale, game.menuBeatCircle_img:getHeight()/2, game.menuBeatCircle_img:getHeight()/2)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(0,0,0)

		love.graphics.print("#" .. tostring(game.selectedMap), game.bumpx + 25, game.bumpy + 344, rot, 1, 1)
		love.graphics.print("/" .. tostring(#game.mapListing), game.bumpx + 25, game.bumpy + 374, rot, 0.5, 0.5)


		love.graphics.print("Difficulty (left/right)", game.bumpx + 475, game.bumpy + 152.25, 0, 0.6, 0.6)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(.6,.6,.6)

		--love.graphics.print("#" .. tostring(game.selectedMap), game.bumpx + 27, game.bumpy + 340, rot, 1, 1)
		--love.graphics.print("/" .. tostring(#game.mapListing), game.bumpx + 27, game.bumpy + 370, rot, 0.5, 0.5)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(1,1,1)
		love.graphics.print("Difficulty (left/right)", game.bumpx + 475, game.bumpy + 150, 0, 0.6, 0.6)
		love.graphics.pop()



		local ofs = 180

		for index, map in pairs(game.mapListing[game.selectedMap].mappings) do

			love.graphics.push()
			love.graphics.setColor(0,0,0)
			love.graphics.print(map[1].difficulty, game.bumpx + 525, game.bumpy + ofs + 2.25, 0, 0.6, 0.6)

			love.graphics.pop()

			love.graphics.push()

			if map[1].difficulty == game.songDifficulty then
				love.graphics.setColor(1,1,0.5)
			else
				love.graphics.setColor(.5,.5,.5)
			end

			love.graphics.print(map[1].difficulty, game.bumpx + 525, game.bumpy + ofs, 0, 0.6, 0.6)
			ofs = ofs + 30
			love.graphics.pop()
		end

		if not game.mapListing[game.selectedMap].mappings[game.selectedDifficulty] then
			game.selectedDifficulty = #game.mapListing[game.selectedMap].mappings
		end

		local ofs = 0
		local index = game.selectedDifficulty
		local item = game.mapListing[game.selectedMap].mappings[index]

		if item then
			if index == game.selectedDifficulty then
				love.graphics.setColor(1,1,0)

				game.songDifficulty = item[1].difficulty
			else
				love.graphics.setColor(.6,.6,.6)
			end
		end



		if game.mapListing[game.selectedMap].mappings[game.selectedDifficulty] then
			love.graphics.push()
			local artist = game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].artist and game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].artist or "???" 
			local mapper = game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].mapper and game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].mapper or "???" 
			local beats = game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].beatmap and #game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].beatmap or 0
			local pps 
			local length = game.mapSelectSong and f.generate_timestamp(game.mapSelectSong:getDuration()) or "???"

			if beats then
				local lengthToCheck = math.floor(#item[1].beatmap/20)
				local maxPPS = 0
				for i = 1, #item[1].beatmap - lengthToCheck do
					local totalTime = item[1].beatmap[i+lengthToCheck] - item[1].beatmap[i]
					local beats = lengthToCheck
					if (beats/totalTime) >= maxPPS then maxPPS = (beats/totalTime) end
				end

				pps = string.sub(tostring(maxPPS), 1, 4)
			else
				pps = "?"
			end

			love.graphics.setColor(1,1,1,0.9)

			love.graphics.print("Artist: ".. artist, game.bumpx + 480, game.bumpy + 25, 0, 0.5, 0.5)
			love.graphics.print("Mapper: ".. mapper, game.bumpx + 480, game.bumpy + 50, 0, 0.5, 0.5)
			love.graphics.print("Beats: ".. tostring(beats) .. " (" .. pps .. "pps) ", game.bumpx + 480, game.bumpy + 75, 0, 0.5, 0.5)
			love.graphics.print("Length: ".. length, game.bumpx + 480, game.bumpy + 100, 0, 0.5, 0.5)

			love.graphics.pop()
		end

		if data.scores[game.mapListing[game.selectedMap].map_id] and data.scores[game.mapListing[game.selectedMap].map_id][cleanString(game.songDifficulty)] then
			game.mapScoreData = data.scores[game.mapListing[game.selectedMap].map_id][cleanString(game.songDifficulty)]
		else
			game.mapScoreData = {
				score = 0,
				rank = "?",
				accuracy = 0,
				hpDrain = 0
			}
		end

		if game.mapScoreData and game.mapListing[game.selectedMap].mappings[game.selectedDifficulty] then


			love.graphics.push()
			love.graphics.setColor(0,0,0,0.6)
			love.graphics.draw(game.rankLetters[game.mapScoreData.rank], game.bumpx + 500 + 160 + 10, game.bumpy + 480 - 23 + 10, 0, 85/game.rankLetters[game.mapScoreData.rank]:getWidth(), 85/game.rankLetters[game.mapScoreData.rank]:getHeight())

			love.graphics.pop()

			love.graphics.push()
			love.graphics.setColor(1,1,1)
			love.graphics.draw(game.hsContain_img, game.bumpx + 500 - 20, game.bumpy + 480 - 50, 0, .8, .8)
			love.graphics.print("HIGH SCORE:", game.bumpx + 500, game.bumpy + 480 - 30, 0, .7, .7)
			love.graphics.print(game.mapScoreData.score, game.bumpx + 500, game.bumpy + 480, 0, 1, 1)
			love.graphics.draw(game.rankLetters[game.mapScoreData.rank], game.bumpx + 500 + 160, game.bumpy + 480 - 23, 0, 85/game.rankLetters[game.mapScoreData.rank]:getWidth(), 85/game.rankLetters[game.mapScoreData.rank]:getHeight())

			if game.mapScoreData.rank ~= "?" then
				love.graphics.print("Press R to replay", game.bumpx + 500, game.bumpy + 430 - 30, 0, .7, .7)
			end

			love.graphics.pop()

			if not game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].hpDrain or game.mapListing[game.selectedMap].mappings[game.selectedDifficulty][1].hpDrain > 0 then
				love.graphics.push()
				love.graphics.setColor(.8,.8,1,1)
				love.graphics.print(string.sub(tostring(game.mapScoreData.accuracy * 100), 1, 5) .. "%", game.bumpx + 500, game.bumpy + 480 + 35, 0, 1, 1)			
				love.graphics.pop()
			end
		end

	end






	drawMovingObjects(3)
	love.graphics.setColor(1,1,1)
end






function love.load()

	-- files = love.filesystem.getDirectoryItems("osuMaps")

end


function love.filedropped( file )
	file:open("r")

	if string.sub(file:getFilename(), #file:getFilename()-3, #file:getFilename()) == ".mp3" then
		success = love.filesystem.createDirectory("/temp/")
		file:open("r")
		game.songDataName = string.sub(file:getFilename(), 1, #file:getFilename()-4)

		local startPos = 0

		for i = 1, #game.songDataName do
			if string.sub(game.songDataName, i, i) == "/" or string.sub(game.songDataName, i, i) == [[\]] then
				startPos = i
			end 
		end



		game.songDataName = string.sub(game.songDataName, startPos+1, #game.songDataName)

		--game.songData = file:read()

		local tempSong = love.filesystem.newFile("/temp/song.mp3", "w")
		tempSong:write(file:read())
		tempSong:close()

		game.songSample = love.audio.newSource("/temp/song.mp3", "stream")

		editor.song = game.songSample

		game.mapGen.previewTime = game.songSample:getDuration()/2
		game.mapGen.endTime = game.songSample:getDuration()

		-- game.songSample:play()


	end

	if string.sub(file:getFilename(), #file:getFilename()-4, #file:getFilename()) == ".chex" then
		--if tonumber(string.sub(file:getFilename(), 1, #file:getFilename()-5)) == tonumber(string.sub(file:getFilename(), 1, #file:getFilename()-5)) then
		local mapID = string.sub(file:getFilename(), 1, #file:getFilename()-5)

		local startPos = 0

		for i = 1, #mapID do
			if string.sub(mapID, i, i) == "/" or string.sub(mapID, i, i) == [[\]] then
				startPos = i
			end 
		end

		mapID = string.sub(mapID, startPos+1, #mapID)
		--end
		print(mapID)

		if not love.filesystem.getInfo("/maps/"..mapID) then
			
			success = love.filesystem.createDirectory("/maps/"..mapID)
		else
			mapID = mapID .. tostring(math.random(1000,9999))
			success = love.filesystem.createDirectory("/maps/"..mapID)
		end
		--local mapID = tostring(math.random(1000000,9999999))
		extractZIP(file:getFilename(), "/maps/"..mapID)
	end

	if string.sub(file:getFilename(), #file:getFilename()-3, #file:getFilename()) == ".osz" then
		unpack_osz(file:getFilename())
	end

	if string.sub(file:getFilename(), #file:getFilename()-3, #file:getFilename()) == ".osc" then
		unpack_osz(file:getFilename(), true)
	end
end