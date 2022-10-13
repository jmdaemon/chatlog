-- Imports
--local f = require("F")
--include("F.lua")
/*
function f(str)
    local outer_env = _ENV
    return (str:gsub("%b{}", function(block)
       local code = block:match("{(.*)}")
       local exp_env = {}
       setmetatable(exp_env, { __index = function(_, k)
          local stack_level = 5
          while debug.getinfo(stack_level, "") ~= nil do
             local i = 1
             repeat
                local name, value = debug.getlocal(stack_level, i)
                if name == k then
                   return value
                end
                i = i + 1
             until name == nil
             stack_level = stack_level + 1
          end
          return rawget(outer_env, k)
       end })
       local fn, err = load("return "..code, "expression `"..code.."`", "t", exp_env)
       if fn then
          return tostring(fn())
       else
          error(err, 0)
       end
    end))
 end
*/

-- Constants
SCRIPT_NAME = 'gmodchatlog'
PLAYER_LOGS_DIR = SCRIPT_NAME .. '/player/logs'
LOG_DATE_FORMAT = "%Y-%m-%d"
--LOG_FORMAT = "-chat.txt"

-- Create the log directory to store player chats
local function init_log_dir()
   file.CreateDir(PLAYER_LOGS_DIR)
end

-- Creates the timestamp for the chatlog file
-- E.g 2022-10-11-chat.txt
function log_timestamp()
   local ctime = os.time()
   -- print(ctime)
   --local log_name = os.date(LOG_FORMAT, ctime)
   local cdate = os.date(LOG_DATE_FORMAT, ctime)
   -- print(cdate)
   local log_name = cdate .. "-chat.txt"
   return log_name
end

function log_msg(line)
   local log_name = log_timestamp()
   /*
   if not file.Exists('data' .. PLAYER_LOGS_DIR, log_name) then
      log_plugin_msg('Created ' .. 'data' .. PLAYER_LOGS_DIR .. '/' ..  log_name)
      file.Write()
   end
   */
   file.Append(PLAYER_LOGS_DIR .. '/' .. log_name, line)
end

-- Developer Functions

-- Outputs a message to the console
function log_plugin_msg(msg)
   print('[' .. SCRIPT_NAME .. '] ' .. msg)
end

function log_chat(ply, text, bTeam, bDead)
   --if (ply != LocalPlayer() ) then return end
   --print(text)
   local line = text .. '\r'
   log_plugin_msg('Message: ' .. text)
   log_msg(line)
   -- Client side code
   -- return false

   if CLIENT == true then
      return false
   elseif SERVER == true then
      return text
   end
end

-- Client side
if CLIENT == true then
   if not file.Exists('data', PLAYER_LOGS_DIR) then
      init_log_dir()
      log_plugin_msg('Created ' .. PLAYER_LOGS_DIR)
   end

   /*
   hook.Add( "OnPlayerChat", "LogChat", function(ply, text, bTeam, bDead)
      print(text)
      log_msg(text)
      return false
   end )
   */

   hook.Add('OnPlayerChat', 'LogChat', log_chat)
   log_plugin_msg('Initialized LogChat hook')
   --log_msg("Test")
end

-- Local Server
if SERVER == true then 
   if not file.Exists('data', PLAYER_LOGS_DIR) then
      init_log_dir()
      log_plugin_msg('Created ' .. PLAYER_LOGS_DIR)
   end

   /*
   hook.Add( "OnPlayerChat", "LogChat", function(ply, text, bTeam, bDead)
      print(text)
      log_msg(text)
      return false
   end )
   */

   hook.Add('PlayerSay', 'LogChat', log_chat)
   log_plugin_msg('Initialized LogChat hook')
   --log_msg("Test")
end