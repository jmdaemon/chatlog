-- TODO: Make variable to check if directory has been initialized

PLAYER_LOGS_DIR = 'player/logs'
LOG_FORMAT = '%Y-%m-%d-chat.txt'

-- Create the log directory to store player chats
function init_log_dir()
 file.CreateDir(PLAYER_LOGS_DIR)
end

-- Creates the timestamp for the chatlog file
-- E.g 2022-10-11-chat.txt
function log_timestamp()
    local ctime = os.time()
    --local cdate = os.date(LOG_FORMAT, ctime)
    --return cdate
    local log_name = os.date(LOG_FORMAT, ctime)
    return log_name
end

function log_msg(line)
    local log_name = log_timestamp()
    if (not file.Exists(log_name)) then
        init_log_dir()
    end
    file.Append(log_name, line)
end

hook.Add('OnPlayerChat', 'LogChat', function(player, text, bTeam, bDead)
    log_msg(text)
end)

    --if (player != LocalPlayer() ) then return end
    

    --strText = string.lower( strText ) -- make the string lower case

	--if ( strText == '/hello' ) then -- if the player typed /hello then
		--print( 'Hello world!' ) -- print Hello world to the console
		--return true -- this suppresses the message from being shown
	--end
