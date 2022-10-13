-- Constants
SCRIPT_NAME = 'gmodchatlog'
CURRENT_SERVER_IP = game.GetIPAddress()
PLAYER_LOGS_DIR = SCRIPT_NAME .. '/player/logs/' .. CURRENT_SERVER_IP
LOG_DATE_FORMAT = '%Y-%m-%d'
LOG_DATE_TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

-- General purpose helper functions
function format_msg(ply, text)
   local datetime = os.date(LOG_DATE_TIME_FORMAT, os.time())
   local name = ply:Name()
   local steamid64 = ply:OwnerSteamID64()
   local msg = '[' .. datetime .. '] ' .. name .. ' (' .. steamid64 .. ')' .. ': ' .. text
   return msg
end

-- Outputs a message to the console with [ plugin_name ]
function log_console_msg(plugin_name, msg)
   print('[' .. plugin_name .. '] ' .. msg)
end

-- GModChatLog specific

-- Create the log directory to store player chats
function log_dir_init()
   file.CreateDir(PLAYER_LOGS_DIR)
end

-- Creates the timestamp for the chatlog file
-- E.g 2022-10-11-chat.txt
function log_timestamp()
   local ctime = os.time()
   local cdate = os.date(LOG_DATE_FORMAT, ctime)
   local log_name = cdate .. '-chat.txt'
   return log_name
end

function log_msg(ply, line)
   local log_name = log_timestamp()
   file.Append(PLAYER_LOGS_DIR .. '/' .. log_name, format_msg(ply, line))
end

function gmodchat_log_console_msg(msg)
   log_console_msg(SCRIPT_NAME, msg)
end

function log_chat(ply, text, bTeam, bDead)
   local line = text .. '\r'
   log_msg(ply, line)
   gmodchat_log_console_msg('Message: ' .. text)

   if CLIENT == true then
      return false
   elseif SERVER == true then
      return text
   end
end

-- Client side
if CLIENT == true then
   if not file.Exists('data', PLAYER_LOGS_DIR) then
      log_dir_init()
      log_plugin_msg('Created ' .. PLAYER_LOGS_DIR)
   end

   hook.Add('OnPlayerChat', 'LogChat', log_chat)
   gmodchat_log_console_msg('Initialized LogChat hook')
end

-- Local Server
if SERVER == true then 
   if not file.Exists('data', PLAYER_LOGS_DIR) then
      log_dir_init()
      log_plugin_msg('Created ' .. PLAYER_LOGS_DIR)
   end

   hook.Add('PlayerSay', 'LogChat', log_chat)
   gmodchat_log_console_msg('Initialized LogChat hook')
end
