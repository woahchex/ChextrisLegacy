
function love.conf(t)
    t.title = "Chextris"                  -- The title of the window the game is in (string)
    t.version = "11.4"                    -- The LÖVE version this game was made for (string)
    t.console = false                     -- Attach a console (boolean, Windows only)
    t.window.width = 1280                 -- The window width (number)
    t.window.height = 720                 -- The window height (number)
    t.window.icon = "assets/icon.png"

    t.modules.physics = false
    t.modules.timer = true              -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update

end
