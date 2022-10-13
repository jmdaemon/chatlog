package = "GModChatLog"
version = "0.1.0-1"
source = {
   url = "..." -- We don't have one yet
}
description = {
   summary = "Store player messages client side for Garry's Mod",
   detailed = [[
   ]],
   homepage = "http://...", -- We don't have one yet
   license = "MIT" -- or whatever you like
}
dependencies = {
   "lua >= 5.3",
   "f-strings >= 0.1"
   -- If you depend on other rocks, add them here
}
build = {
   -- We'll start here.
   type = "builtin",
  modules = {
      chatlog = "lua/autorun/client/chatlog.lua"
  }
}
