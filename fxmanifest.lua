fx_version 'cerulean'
lua54 'yes'
game 'gta5' 
shared_scripts {
    '@ox_lib/init.lua',
	'config.lua',
}
ui_page {
    'data/index.html',
}
client_scripts {
	'bridge/framework/client/*.lua',
	'bridge/inventory/client/*.lua',
	'bridge/target/*.lua',
	'bridge/zones.lua',
	'client/main.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'bridge/framework/server/*.lua',
	'bridge/inventory/server/*.lua',
	'server/main.lua'
}

files {
	'data/image/*.png',
	'data/index.html',
	'data/script.js',
	'data/audio/door.mp4',
	'data/audio/door.ogg',
	'stream/starter_shells_k4mb1.ytyp'
}
data_file 'DLC_ITYP_REQUEST' 'starter_shells_k4mb1.ytyp'
