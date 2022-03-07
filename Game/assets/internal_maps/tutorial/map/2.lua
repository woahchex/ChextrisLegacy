{
					{ -- INITIAL MAP DATA

						["name"] = "Tutorial",
						["artist"] = "chex",
						["difficulty"] = "Idiot",
						["id"] = 1002,
						["customBag"] = "ILJTSOZLJTSOZLIILJTSOZLJTSOZLI",
						["bgPointer"] = "background.png",
						["background"] = "/assets/internal_maps/tutorial/background.png",

						["gravity"] = 10,
						["lockTime"] = 1, 
						["flashTimes"] = {32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64},
						["beatmap"] = {2,3, 4,5, 6,7, 8,9, 10,11, 12,13, 14,15, 16, 16.5, 17, 17.5, 18, 18.5, 19, 19.5, 20, 20.5, 21, 21.5, 22, 22.5, 23, 23.5, 24, 24.5, 25, 25.5, 26, 26.5, 27, 27.5, 28, 28.5, 29, 29.5, 30, 30.5, 31, 31.5, 32.0, 32.5, 33.0, 33.5, 34.0, 34.5, 35.0, 35.5, 36.0, 36.5, 37.0, 37.5, 38.0, 38.5, 39.0, 39.5, 40.0, 40.5, 41.0, 41.5, 42.0, 42.5, 43.0, 43.5, 44.0, 44.5, 45.0, 45.5, 46.0, 46.5, 47.0, 47.5, 48.0, 48.5, 49.0, 49.5, 50.0, 50.5, 51.0, 51.5, 52.0, 52.5, 53.0, 53.5, 54.0, 54.5, 55.0, 55.5, 56.0, 56.5, 57.0, 57.5, 58.0, 58.5, 59.0, 59.5, 60.0, 60.5, 61.0, 61.5, 62.0, 62.5, 63.0, 63.5, 64.0},
						["approachRate"] = 1.5,
						["hpDrain"] = 0.15
					}, -- END INITIAL MAP DATA


					{ -- TIMESTAMP LIST
						{0, -- ts
							{ -- list of effects
								{ -- effect
									"MovingObjects",
									{ -- list of particles
										text1 = { -- first particle
											text = "Hey again",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.75,.75},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Hey again")*.75/2}
											--friction = {0,1.05},
											--velocity = {0,3}
										},
									}
								},
							}
						},

						{4, -- ts
							{ -- list of effects
								{ -- effect
									"MovingObjects",
									{ -- list of particles
										text2 = { -- first particle
											text = "This text is here to distract you",
											color = {1,1,0},
											position = {game.swidth/2, game.sheight/2 - 100},
											scale = {1.5,1.5},
											lifetime = 4,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("This text is here to distract you")*.75/2}
											--friction = {0,1.05},
											--velocity = {0,3}
										},
										text1 = {
											velocity = {0,0},
											acceleration = {0, -1}
										}
									}
								},
							}
						},

						{5,
							{
								{
									"MovingObjects",
									{
										countdown = {
											text = "3",
											color = {1,0,0},
											position = {game.swidth/2, game.sheight/2},
											scale = {2.5, 2.5},
											lifetime = 3,
											opacity = 1,
											scaleOffset = {10, 0}
										}
									}
								}
							}
						},

						{6,
							{
								{
									"MovingObjects",
									{
										countdown = {
											text = "2",
											color = {1,1,0},
										}
									}
								}
							}
						},

						{7,
							{
								{
									"MovingObjects",
									{
										countdown = {
											text = "1",
											color = {0,1,0}
										}
									}
								}
							}
						},

						{9,
							{
								{
									"MovingObjects",
									{
										text4 = { -- first particle
											text = "I'm assuming you're doing poorly",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.9,.9},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("I'm assuming you're doing poorly")*.75/2}
											--friction = {0,1.05},
											--velocity = {0,3}
										},
									}
								}
							}
						},

						{12, -- ts
							{ -- list of effects
								{ -- effect
									"MovingObjects",
									{ -- list of particles
										text2 = { -- first particle
											text = "Hold on the beat!",
											color = {1,1,0},
											position = {game.swidth/2, game.sheight/2 - 100},
											scale = {1.5,1.5},
											lifetime = 4,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Hold on the beat!")*.75/2}
											--friction = {0,1.05},
											--velocity = {0,3}
										},
										text4 = {
											velocity = {0,0},
											acceleration = {0,-1}
										}
									}
								},
							}
						},

						{13,
							{
								{
									"MovingObjects",
									{
										countdown = {
											text = "3",
											color = {1,0,0},
											position = {game.swidth/2, game.sheight/2},
											scale = {2.5, 2.5},
											lifetime = 3,
											opacity = 1,
											scaleOffset = {10, 0}
										}
									}
								}
							}
						},

						{14,
							{
								{
									"MovingObjects",
									{
										countdown = {
											text = "2",
											color = {1,1,0},
										}
									}
								}
							}
						},

						{15,
							{
								{
									"MovingObjects",
									{
										countdown = {
											text = "1",
											color = {0,1,0}
										}
									}
								}
							}
						},


						{17,
							{
								{
									"MovingObjects",
									{
										text5 = { -- first particle
											text = "Why didn't you hold on the beat :(",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.7,.7},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Why didn't you hold on the beat :(")*.75/2},
											--friction = {0,1.05},
											--velocity = {0,3}
											lifetimeMapping = {
												{1, -- when the object has 1 second of life left,
													{ -- update these values
														velocity = {0,0},
														acceleration = {0,-1}
													}
												}
											}
										},
									}
								}
							}
						},


						{26, -- first item: timestamp
							{ -- LIST OF EFFECTS AT TIMESTAMP




								{
									"MovingObjects",
									{
										text5 = { -- first particle
											text = "Well this is no fun",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.7,.7},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Well this is no fun")*.75/2},
											--friction = {0,1.05},
											--velocity = {0,3}
											lifetimeMapping = {
												{1, -- when the object has 1 second of life left,
													{ -- update these values
														velocity = {0,0},
														acceleration = {0,-1}
													}
												}
											}
										},
									}
								}
							}, -- END OF LIST OF EFFECTS AT TIMESTAMP
							0.125,
							4
						}, --end of first item: timestamp

						{47.5, -- ts
							{ -- list of effects
								{ -- effect
									"MovingObjects",
									{ -- list of particles
										text2 = { -- first particle
											text = "Drop!",
											color = {1,1,1},
											position = {game.swidth/2, game.sheight/2 - 100},
											scale = {2.5,2.5},
											lifetime = 1,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.08,
											scaleOffset = {love.graphics.getFont():getWidth("Hold!")*.75/2}
											--friction = {0,1.05},
											--velocity = {0,3}
										},
									}
								},
							}
						},

						{47.5, -- ts
							{ -- list of effects
								{ -- effect
									"MovingObjects",
									{ -- list of particles
										text2 = { -- first particle
											text = "STOP!!",
											color = {1,1,0},

										},
									}
								},
							}
						},

						{49,
							{
								{
									"MovingObjects",
									{
										text7 = { -- first particle
											text = "Damn dude",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.7,.7},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Damn dude")*.75/2},
											--friction = {0,1.05},
											--velocity = {0,3}
											lifetimeMapping = {
												{1, -- when the object has 1 second of life left,
													{ -- update these values
														velocity = {0,0},
														acceleration = {0,-1}
													}
												}
											}
										},
									}
								}
							}
						},

					}, -- END OF LIST OF EFFECTS AT TIMESTAMP


				}