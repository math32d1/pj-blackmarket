fx_version "cerulean"
game "gta5"
lua54 'yes'

version '1.0.3'

description "PJ-Blackmarket for VRP"

author "PJ-Scripts x Dallefar"

ui_page 'https://pj-blackmarket.vercel.app'

dependencies {
    'vrp',
    'HT_base'
}

server_scripts {
	"@vrp/lib/utils.lua",
	'config.lua',
	'server/*.lua',
}

client_scripts {
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
	"client/cl_config.lua",
	'client/client.lua',
	'client/functions.lua'
}

shared_scripts {
	'strings.lua',
}



