{
					{ -- INITIAL MAP DATA

						["name"] = "Tutorial",
						["artist"] = "chex",
						["difficulty"] = "Easy",
						["id"] = 1002,
						["customBag"] = "ILJTSOZLJTSOZLIILJTSOZLJTSOZLI",
						["bgPointer"] = "background.png",
						["background"] = "/assets/internal_maps/tutorial/background.png",

						["gravity"] = 10,
						["lockTime"] = 1, 
						["flashTimes"] = {32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64},
						["beatmap"] = {8, 16, 24, 32, 36, 40, 44, 47.5, 48, 56, 60, 63.5, 64},
						["approachRate"] = 4,
						["hpDrain"] = 0.05
					}, -- END INITIAL MAP DATA


					{ -- TIMESTAMP LIST
						{0, -- ts
							{ -- list of effects
								{ -- effect
									"MovingObjects",
									{ -- list of particles
										text1 = { -- first particle
											text = "Let's go over some gameplay basics!",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.75,.75},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Let's go over some gameplay basics!")*.75/2}
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
											text = "Hard drop on the beat!",
											color = {1,1,0},
											position = {game.swidth/2, game.sheight/2 - 100},
											scale = {1.5,1.5},
											lifetime = 4,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Hard drop on the beat!")*.75/2}
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
											text = "You can also hold on beats! Give it a try!",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.9,.9},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("You can also hold on beats! Give it a try!")*.75/2}
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
											text = "The right bar indicates when beats are approaching.",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.7,.7},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("The right bar indicates when beats are approaching.")*.75/2},
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

						{24.5,
							{
								{
									"NewBoard",
									fresh_board()
								},
							}
						},

						{26, -- first item: timestamp
							{ -- LIST OF EFFECTS AT TIMESTAMP



								{ -- SECOND EFFECT: Garbage Add
									"Garbage",
									{make_garbage(10)}
								}, -- END SECOND EFFECT: Gravity Change

								{
									"NewPieces",
									"1"
								},

								{
									"MovingObjects",
									{
										text5 = { -- first particle
											text = "Do moves like quads on-beat to get lots of points!",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.7,.7},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Do moves like quads on-beat to get lots of points!")*.75/2},
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
											text = "Hold!",
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
											text = "Hit beats to keep up your HP and accuracy!",
											color = {1,1,.5},
											position = {game.swidth/2, game.bumpy + 15},
											scale = {.7,.7},
											lifetime = 7,
											opacity = 0,
											layer = 3,
											opacityDelta = 0.02,
											scaleOffset = {love.graphics.getFont():getWidth("Hit beats to keep up your HP and accuracy!")*.75/2},
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