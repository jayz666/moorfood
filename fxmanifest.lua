fx_version 'cerulean'
game 'gta5'

author 'moorgaming'
version '1.0.0'
description 'The most advanced eating and drinking system for FiveM'

client_script 'client.lua'
server_script 'server.lua'

shared_script 'config.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

datafile 'INGAME_FOOD_INDEX' {
    'index.json'
}

datafile 'FOOD_ANIMS' {
    'animations.json'
}

-- dependencies {
--     'qbx_core'
-- }
