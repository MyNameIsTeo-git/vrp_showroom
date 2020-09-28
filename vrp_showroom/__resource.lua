description "vRP showroom"
dependency "vrp"

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}

client_scripts{ 
  "lib/Proxy.lua",
  'config.lua',
  "client.lua"
}