return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            dashboard = {
                enabled = true,
                preset = {
                    pick = function(cmd, opts)
                        return LazyVim.pick(cmd, opts)()
                    end,
                    -- https://patorjk.com/software/taag/#p=display&f=Fraktur&t=HackerMan
                    header = [[
   _______           _______ _________ _______  _______   _________          _______    _______  _______          _________ _______  _______ _________ _______ 
  (       )|\     /|(  ____ \\__   __/(  ____ \(  ____ )  \__   __/|\     /|(  ____ \  (  ____ )(  ___  )|\     /|\__   __/(  ____ )(  ____ )\__   __/(       )
  | () () || )   ( || (    \/   ) (   | (    \/| (    )|     ) (   | )   ( || (    \/  | (    )|| (   ) || )   ( |   ) (   | (    )|| (    )|   ) (   | () () |
  | || || || |   | || (_____    | |   | (__    | (____)|     | |   | (___) || (__      | (____)|| |   | || (___) |   | |   | (____)|| (____)|   | |   | || || |
  | |(_)| || |   | |(_____  )   | |   |  __)   |     __)     | |   |  ___  ||  __)     |     __)| |   | ||  ___  |   | |   |     __)|     __)   | |   | |(_)| |
  | |   | || |   | |      ) |   | |   | (      | (\ (        | |   | (   ) || (        | (\ (   | |   | || (   ) |   | |   | (\ (   | (\ (      | |   | |   | |
  | )   ( || (___) |/\____) |   | |   | (____/\| ) \ \__     | |   | )   ( || (____/\  | ) \ \__| (___) || )   ( |___) (___| ) \ \__| ) \ \_____) (___| )   ( |
  |/     \|(_______)\_______)   )_(   (_______/|/   \__/     )_(   |/     \|(_______/  |/   \__/(_______)|/     \|\_______/|/   \__/|/   \__/\_______/|/     \|
 
                       ____                                     ____                                     ____                                    ____                     
                   []|    (______                           []|    (______                           []|    (______                          []|    (______              
                   []|__ / ROHAN \                          []|__ / ROHAN \                          []|__ / ROHAN \                         []|__ / ROHAN \             
                   ||   \________/                          ||   \________/                          ||   \________/                         ||   \________/             
                   ||      ___                              ||      ___                              ||      ___                             ||      ___                 
                   ||     /_  )__                           ||     /_  )__                           ||     /_  )__                          ||     /_  )__              
        __|\/)     ||   _/_ \____)               __|\/)     ||   _/_ \____)               __|\/)     ||   _/_ \____)              __|\/)     ||   _/_ \____)             
  ,----`     \     ||  />=o)               ,----`     \     ||  />=o)               ,----`     \     ||  />=o)              ,----`     \     ||  />=o)                   
  \_____      \    ||  \]__\               \_____      \    ||  \]__\               \_____      \    ||  \]__\              \_____      \    ||  \]__\                   
        `--,_/U\  B|\__/===\                     `--,_/U\  B|\__/===\                     `--,_/U\  B|\__/===\                    `--,_/U\  B|\__/===\                   
           |UUUU\  ||_ _|_\_ \                      |UUUU\  ||_ _|_\_ \                      |UUUU\  ||_ _|_\_ \                     |UUUU\  ||_ _|_\_ \                 
           |UUUUU\_|[,`_|__|_)                      |UUUUU\_|[,`_|__|_)                      |UUUUU\_|[,`_|__|_)                     |UUUUU\_|[,`_|__|_)                 
           |UUUUUU\||__/_ __|                       |UUUUUU\||__/_ __|                       |UUUUUU\||__/_ __|                      |UUUUUU\||__/_ __|                  
           |UUUUUU/-(_\_____/-------,               |UUUUUU/-(_\_____/-------,               |UUUUUU/-(_\_____/-------,              |UUUUUU/-(_\_____/-------,          
           /UU/    |H\__\    HHHH|   \\             /UU/    |H\__\    HHHH|   \\             /UU/    |H\__\    HHHH|   \\            /UU/    |H\__\    HHHH|   \\        
           |UU/    |H\  |HHHHHHH|    |\\\           |UU/    |H\  |HHHHHHH|    |\\\           |UU/    |H\  |HHHHHHH|    |\\\          |UU/    |H\  |HHHHHHH|    |\\\      
           UU      |HH\ \HHHHHHH|    | \\\          UU      |HH\ \HHHHHHH|    | \\\          UU      |HH\ \HHHHHHH|    | \\\         UU      |HH\ \HHHHHHH|    | \\\     
           U       |<_\,_\HHHHHH|   /  \\\          U       |<_\,_\HHHHHH|   /  \\\          U       |<_\,_\HHHHHH|   /  \\\         U       |<_\,_\HHHHHH|   /  \\\     
            \ (    |HHHHHHHHHHHHH   /  \\\\          \ (    |HHHHHHHHHHHHH   /  \\\\          \ (    |HHHHHHHHHHHHH   /  \\\\         \ (    |HHHHHHHHHHHHH   /  \\\\    
             \ \   |=============  /    \\\\\         \ \   |=============  /    \\\\\         \ \   |=============  /    \\\\\        \ \   |=============  /    \\\\\  
                \ |             | |                      \ |             | |                      \ |             | |                     \ |             | |            
                                                                                                                                                                         
]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
                },
            },
        },
    },
}
