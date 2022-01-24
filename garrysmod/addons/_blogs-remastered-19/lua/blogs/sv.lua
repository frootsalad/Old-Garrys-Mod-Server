local
_,a,b={_="Discord",a="Enabled",b="LicenseKey",c="Exists",d="MySQL",e="Config",f="Usergroups",g="Permissions",h="InGameConfig",i="SteamIDs",j="ServerID",k="TableToJSON",l="Modules",m="Colour",n="ConsoleLogLength",o="Database",p="General",q="ModulesDisabled",r="LoadAddonModules",s="DataFlows",t="Compress",u="WriteDouble",v="WriteData",w="insert",x="WriteString",y="FunctionMenuKey",z="PrintToConsole",A="GetIPAddress",B="LogsPerPage",C="IDColumn",D="module",E="player",F="ReadString",G="DefaultInGameConfig",H="ReadBool",I="DefaultPermissions"},nil
bLogs[_._]={}bLogs.Web={}bLogs[_._][_.a]=!1
bLogs.Web[_.a]=!1
local
c=0
local
function
d(a,b,d)c=c+1
local
e="blogs_module_load_"..math.random(1,9999)..c
timer.Create(e,1,0,function()if(d[_.a]==!!1)then
d[_.a]=!1
http.Post("https://license.gmodsto.re/1599/"..bLogs[_.b],{reason="bLogs "..b.." tamper check"})if
d[_.b]then
http.Post("https://license.gmodsto.re/"..a.."/"..d[_.b],{reason="bLogs "..b.." tamper check"})end
bLogs=nil
timer.Remove(e)end
end)end
if
file[_.c]("blogs_discord_config.lua","LUA")then
include"blogs_discord_config.lua"if(bLogs[_._][_.a]==!!1)then
bLogs[_._][_.a]=!1
bLogs:print"[Discord] Enabled. Checking license..."http.Fetch("https://license.gmodsto.re/5407/"..bLogs[_._][_.b],function(a,b,c,f)if(f==200)then
bLogs[_._][_.a]=!!1
bLogs:print("[Discord] License check success!","good")else
bLogs:print("[Discord] License check failed! HTTP "..f,"error")d(5407,"Discord",bLogs[_._])end
end,function(a)bLogs:print("[Discord] License check failed! "..a,"error")d(5407,"Discord",bLogs[_._])end)end
else
d(5407,"Discord",bLogs[_._])end
if
file[_.c]("blogs_web_config.lua","LUA")then
include"blogs_web_config.lua"if(bLogs.Web[_.a]==!!1)then
bLogs.Web[_.a]=!1
bLogs:print"[Web] Enabled. Checking license..."http.Fetch("https://license.gmodsto.re/5652/"..bLogs.Web[_.b],function(c,g,h,i)if(i==200)then
bLogs.Web[_.a]=!!1
bLogs:print("[Web] License check success!","good")if(bLogs[_.e][_.d][_.a]==!1)then
bLogs:print("[Web] MySQL is disabled, so bLogs Web is also disabled.","bad")else
local
function
c()b([[

							SHOW TABLES LIKE 'blogsweb_permissions';

						]],function(c)if(#c==0)then
bLogs:print("[Web] bLogs Web has not been set up on your webserver's database yet. Please install bLogs Web on your webserver and run the setup script.","bad")return
end
b("SELECT `var_str` FROM `blogs_vars` WHERE `var_name`='blogs_web_url'",function(c)if(#c==0)then
return
end
bLogs.Web.URL=c[1].var_str
end)local
c="TRUNCATE blogsweb_permissions;\n"for
g,h
in
pairs(table.Merge(bLogs[_.h][_.g][_.f],bLogs[_.h][_.g][_.i]))do
local
i=g
if(g:sub(1,1)=="S")then
i=util.SteamIDTo64(g)end
if
table.HasValue(bLogs[_.e].MaxPermitted,i)then
c=c.."INSERT INTO blogsweb_permissions (`server_id`, `value`, `open_menu`, `maxpermitted`, `ip_addresses`, `modules`) ".."VALUES('"..a(bLogs[_.j]).."','"..a(i).."','1','1','1','[]');\n"else
local
g,j,k={},0,0
for
l,m
in
pairs(h)do
if(m==!!1)then
if(l=="Menu")then
j=1
elseif(l=="IPAddresses")then
k=1
else
g[l]=!!1
end
end
end
g=util[_.k](g)if
g~="[]"||j==1||k==1
then
c=c.."INSERT INTO blogsweb_permissions (`server_id`, `value`, `open_menu`, `maxpermitted`, `ip_addresses`, `modules`) ".."VALUES('"..a(bLogs[_.j]).."','"..a(i).."','"..a(j).."','0','"..a(k).."','"..a(g).."');\n"end
end
end
b(c)local
c=""for
g,h
in
pairs(bLogs[_.l])do
local
g=math.floor(h[_.m].b+(h[_.m].g*256)+(h[_.m].r*65536))c=c.."INSERT IGNORE INTO blogsweb_modules (`category`,`module`,`color`) VALUES('"..a(h.Category).."','"..a(h.Name).."','"..a(g).."');\n"end
b(c)local
function
c()if
file[_.c]("console.log","GAME")then
local
c=file.Read("console.log","GAME")if(#c>bLogs.Web[_.n])then
c="..."..string.sub(c,#c-bLogs.Web[_.n]+3,#c)end
local
g=bLogs[_.o]:prepare"UPDATE blogsweb_console SET `console`=?"g:setString(1,c)g:start()end
end
timer.Create("blogs_console_stream",10,0,c)c()end)end
if
bLogs_FullyLoaded
then
c()else
bLogs:hook("bLogs_FullyLoaded","web_init",c)end
end
else
bLogs:print("[Web] License check failed! HTTP "..i,"error")d(5407,"Web",bLogs.Web)end
end,function(c)bLogs:print("[Web] License check failed! "..c,"error")d(5407,"Web",bLogs.Web)end)end
else
d(5407,"Web",bLogs.Web)end
if!bLogs_ReplacedServerLog
then
bLogs_ReplacedServerLog=ServerLog
function
ServerLog(...)if
bLogs[_.h]then
if(bLogs[_.h][_.p].DisableServerLog==!1)then
bLogs_ReplacedServerLog(...)end
end
end
end
bLogs:hook("canSeeLogMessage","HideLogMessages",function()if!DarkRP
then
bLogs:unhook("canSeeLogMessage","HideLogMessages")return
end
if
bLogs[_.h]then
if(bLogs[_.h][_.p].DisableDarkRPLog==!!1)then
return!1
end
end
end)function
bLogs.LoadAddonModules()local
a=file.Find("blogs/modules/addons/*.lua","LUA")for
a,b
in
pairs(a)do
include("blogs/modules/addons/"..b)end
for
a,b
in
pairs(bLogs[_.h][_.q])do
if!bLogs[_.l][b]then
continue
end
bLogs[_.l][b][_.a]=!1
for
a,b
in
pairs(bLogs[_.l][b].Hooks)do
hook.Remove(b[1],b[2])end
end
end
if(#player.GetAll()>0)then
bLogs[_.r]()else
hook.Add("PlayerInitialSpawn","blogs_load_addon_modules",function()bLogs[_.r]()hook.Remove("PlayerInitialSpawn","blogs_load_addon_modules")end)end
local
c={"OpenMenu","Send_Setup_Data","Permission_Failure","SelectLogs","GetOfflineName","AdvancedSelectLogs","start_data_flow","data","last_data","no_data","jump_to_date","completed","archive_logs","wipe_archive","reset_config","update_player_format","update_modules","permissions","permissions_update","permissions_delete","update_general_config","update_general_config_num","update_country","update_config_broadcast","send_log","playerlookup"}for
a,b
in
pairs(c)do
util.AddNetworkString("blogs_"..b)end
bLogs[_.s]={}bLogs.DataFlowing={}require"billyerror"local
function
c(a,b)b.bLogs_Creator=a
end
local
function
d(a,b,c)c.bLogs_Creator=a
end
bLogs:hook("PlayerSpawnedProp","attach_to_prop",d)bLogs:hook("PlayerSpawnedEffect","attach_to_effect",d)bLogs:hook("PlayerSpawnedRagdoll","attach_to_ragdoll",d)bLogs:hook("PlayerSpawnedNPC","attach_to_npc",c)bLogs:hook("PlayerSpawnedSENT","attach_to_sent",c)bLogs:hook("PlayerSpawnedSWEP","attach_to_swep",c)bLogs:hook("PlayerSpawnedVehicle","attach_to_vehicle",c)bLogs.Logs={}local
function
c()local
a=util[_.t](util[_.k](bLogs[_.h]))local
b=#a
bLogs:nets"update_config_broadcast"net[_.u](b)net[_.v](a,b)net.Broadcast()end
a=function(a)return
sql.SQLStr(a,!!1)end
b=function(a,b)if(type(a)=="table")then
local
c,d={},0
local
function
n(o,p,q,s)p=p+1
if
bLogs[_.e][_.d][_.a]then
local
t=bLogs[_.o]:query(o[p])t.onSuccess=function(t,u)table[_.w](q,u)if(p==#o)then
if
s
then
s(q)end
else
n(o,p,q,s)end
end
t.onError=function(t,v,w)bLogs:print("MySQL error!: "..v.."\n"..w,"bad")end
t:start()else
local
x=sql.Query(o[p])x=x||{}table[_.w](q,x)if(p==#o)then
if
s
then
s(q)end
else
n(o,p,q,s)end
end
end
n(a,d,c,b)else
if!bLogs[_.e]then
bLogs:print("You probably have a config error...","bad")return
end
if!bLogs[_.e][_.d]then
bLogs:print("You probably have a MySQL config error...","bad")return
end
if
bLogs[_.e][_.d][_.a]then
local
c=bLogs[_.o]:query(a)c.onSuccess=function(c,d)if
b
then
b(d)end
end
c.onError=function(c,d,y)bLogs:print("MySQL error!: "..d.."\n"..y,"bad")end
c:start()else
local
c=sql.Query(a)if
b
then
b(c||{})end
end
end
end
hook.Add("bLogs_FullyLoaded","blogs_insert_queued_logs",function()for
a,b
in
pairs(bLogs.QueuedLogs)do
bLogs:Log(unpack(b))end
bLogs.QueuedLogs={}end)local
function
d()if
bLogs[_.e][_.d][_.a]then
bLogs:print("MySQL Database initialised","good")else
bLogs:print("SQLite Database initialised","good")end
bLogs:netr("Send_Setup_Data",function(d)local
z,A=util[_.t](util[_.k](bLogs[_.l])),util[_.t](util[_.k](bLogs[_.h]))bLogs:nets"Send_Setup_Data"net[_.u](#z)net[_.v](z,#z)net[_.u](#A)net[_.v](A,#A)net.WriteBool(bLogs[_.o]~=nil)net[_.x](bLogs.Web.URL||"")net.Send(d)end)bLogs:hook("PlayerSay","chatcommand",function(d,B)if(B:lower()==bLogs[_.e].ChatCommand:lower())then
if
bLogs:HasAccess(d)then
bLogs:nets"OpenMenu"net.Send(d)else
bLogs:nets"permission_failure"net.Send(d)end
return""end
end)if
bLogs[_.e].AllowConsoleCommand
then
bLogs:netr("OpenMenu",function(d)if
bLogs:HasAccess(d)then
bLogs:nets"OpenMenu"net.Send(d)else
bLogs:nets"Permission_Failure"net.Send(d)end
end)end
if(bLogs[_.e][_.y]~=!1)then
local
d
if(bLogs[_.e][_.y]==1)then
d="ShowHelp"elseif(bLogs[_.e][_.y]==2)then
d="ShowTeam"elseif(bLogs[_.e][_.y]==3)then
d="ShowSpare1"elseif(bLogs[_.e][_.y]==4)then
d="ShowSpare2"end
bLogs:unhook("ShowHelp","functionmenukey")bLogs:unhook("ShowTeam","functionmenukey")bLogs:unhook("ShowSpare1","functionmenukey")bLogs:unhook("ShowSpare2","functionmenukey")bLogs:hook(d,"functionmenukey",function(d)if
bLogs:HasAccess(d)then
bLogs:nets"OpenMenu"net.Send(d)else
bLogs:nets"Permission_Failure"net.Send(d)end
end)end
function
bLogs:Log(d,C)if
bLogs[_.h][_.z]then
if
bLogs[_.h][_.z][d]then
for
D,E
in
pairs(player.GetHumans())do
if
bLogs:HasAccess(E,d)then
bLogs:nets"send_log"net[_.x](d)net[_.x](C)net.Send(E)end
end
end
end
local
function
F()if
bLogs[_.o]then
b("INSERT INTO `blogs` (`server_id`,`module`,`log`,`time`,`session`) VALUES('"..a(bLogs[_.j]).."','"..a(d).."','"..a(C).."',UNIX_TIMESTAMP(),'"..a(bLogs.Session).."')")else
b("INSERT INTO `blogs` (`module`,`log`,`time`) VALUES('"..a(d).."','"..a(C).."',strftime('%s','now'))")end
if
file[_.c]("blogs_discord_config.lua","LUA")&&bLogs[_._][_.a]==!!1&&bLogs[_.h].SendToDiscord[d]==!!1
then
local
F,G=bLogs[_.l][d],os.date"!%Y-%m-%dT%H:%M:%S+00:00"local
H,I,J,K,L,M,N=(F.Category.." · "..F.Name):gsub("\"","\\\""),math.floor(F[_.m].b+(F[_.m].g*256)+(F[_.m].r*65536)),bLogs[_._].ServerName.." · "..game[_.A]():gsub("\"","\\\""),"[",C,{},{["{#P%|(%d+)%|(.-)%|#}"]="**%2**",["{#V%|(.-)%|#}"]="`%1`",["{#E%|(.-)%|#}"]="`%1`",["{#$%|(.-)%|#}"]="%1",["{#H%|(.-)|#}"]="`%1`"}for
F,G
in
pairs(N)do
if(F=="{#P%|(%d+)%|(.-)%|#}")then
for
G,H
in
L:gmatch(F)do
K=K..'{"name":"'..H:gsub("\"","\\\"")..'","value":"'..util.SteamIDFrom64(G)..'","inline":true},'end
end
L=L:gsub(F,G)end
K=K:gsub(",$","").."]"HTTP{method="POST",url=bLogs[_._].Webhook,type="application/json",body='{"embeds":[{"timestamp":"'..G..'","title":"'..H..'","color":'..I..',"footer":{"text":"'..J..'"},"description":"'..L..'","fields":'..K..'}]}',success=function(F,G,H)if(tostring(H["X-RateLimit-Remaining"])=="0")then
bLogs:print("Couldn't send a log to Discord due to too many requests. Do not send spammy logs to Discord!","bad")end
end}end
end
if
C:find"{#P%|(%d+)%|#}"then
local
d={}for
O
in
C:gmatch"{#P%|(%d+)%|#}"do
table[_.w](d,O)end
local
function
P(Q)if!d[Q]then
F()return
end
bLogs:OfflineName(d[Q],function(R)C=C:gsub("{#P|"..d[Q].."|#}","{#P|"..d[Q].."|"..R.."|#}")P(Q+1)end)end
P(1)else
F()end
end
local
function
d(d,S,T)d="{"..d.."}"d=util.JSONToTable(d)if
d
then
local
U,V=bLogs[_.e][_.B]*S..","..bLogs[_.e][_.B],""local
function
W(U)if!bLogs[_.s][T]then
bLogs[_.s][T]={}end
local
W,X=table[_.w](bLogs[_.s][T],U),""if(V=="")then
if
d.archive
then
X="SELECT (`var_int` / "..bLogs[_.e][_.B]..") AS 'pages' FROM `blogs_vars` WHERE `var_name`='logs_archive'"else
X="SELECT (`var_int` / "..bLogs[_.e][_.B]..") AS 'pages' FROM `blogs_vars` WHERE `var_name`='logs'"end
else
if
d.archive
then
X="SELECT (COUNT(`"..bLogs[_.C].."`) / "..bLogs[_.e][_.B]..") AS 'pages' FROM `blogs_archive` WHERE "..V
else
X="SELECT (COUNT(`"..bLogs[_.C].."`) / "..bLogs[_.e][_.B]..") AS 'pages' FROM `blogs` WHERE "..V
end
end
b(X,function(X)if(#X==0)then
X[1]={pages=0}end
bLogs:nets"start_data_flow"net.WriteInt(tonumber(math.ceil(X[1].pages)),32)net.Send(T)coroutine.resume(coroutine.create(function(X,Y,Z)if(#Y==0)then
bLogs:nets"no_data"net.Send(Z)else
for
X,a_
in
pairs(Y)do
if!bLogs[_.s][Z]then
break
end
bLogs:nets"data"net[_.x](a_[_.D])net[_.x](a_.log)net.WriteInt(a_.time,32)net.Send(Z)end
bLogs:nets"last_data"net.Send(Z)end
end),W,U,T)end)end
local
aa={}if(type(d[_.D])=="string")then
table[_.w](aa,"`module`='"..a(d[_.D]).."'")end
if(type(d[_.D])=="table")then
if(#d[_.D]==1)then
table[_.w](aa,"`module`='"..a(d[_.D][1]).."'")else
local
U={}for
V,W
in
pairs(d[_.D])do
table[_.w](U,"`module`='"..a(W).."'")end
for
V,W
in
pairs(U)do
if(V==1)then
table[_.w](aa,"(")table[_.w](aa,W)elseif(V==#U)then
table[_.w](aa,W)table[_.w](aa,")")else
table[_.w](aa,"(")table[_.w](aa,W)end
end
end
end
if
d.search
then
table[_.w](aa,"`log` LIKE '%"..a(d.search):gsub("%%","\\%%").."%'")end
if(type(d[_.E])=="string")then
table[_.w](aa,"`log` LIKE '%{#P|"..a(d[_.E]):gsub("%%","\\%%").."%'")end
if(type(d[_.E])=="table")then
if(#d[_.E]==1)then
table[_.w](aa,"`log` LIKE '%{#P|"..a(d[_.E][1]):gsub("%%","\\%%").."%'")else
local
U={}for
V,W
in
pairs(d[_.E])do
table[_.w](U,"`log` LIKE '%{#P|"..a(W):gsub("%%","\\%%").."%'")end
for
V,W
in
pairs(U)do
if(V==1)then
table[_.w](aa,"(")table[_.w](aa,W)elseif(V==#U)then
table[_.w](aa,W)table[_.w](aa,")")else
table[_.w](aa,"(")table[_.w](aa,W)end
end
end
end
local
ab,ac=!1,0
for
U,W
in
pairs(aa)do
if(U==1)then
V=W
elseif(W=="(")then
V=V.." AND ("ab=!!1
elseif(W==")")then
V=V..")"ab=!1
ac=0
elseif
ab
then
ac=ac+1
if(ac==1)then
V=V..W
else
V=V.." OR "..W
end
else
V=V.." AND "..W
end
end
local
aa="blogs"if
d.archive
then
aa="blogs_archive"end
if(V=="")then
b("SELECT `module`,`log`,`time` FROM `"..aa.."` ORDER BY `time` DESC LIMIT "..U,W)else
b("SELECT `module`,`log`,`time` FROM `"..aa.."` WHERE "..V.." ORDER BY `time` DESC LIMIT "..U,W)end
end
end
bLogs:netr("AdvancedSelectLogs",function(ad)local
ae=net.ReadDouble()local
af,ag=net.ReadData(ae),net.ReadInt(32)-1
af=util.Decompress(af)d(af,ag,ad)end)bLogs:netr("SelectLogs",function(ah)local
ai,aj=net[_.F](),net.ReadInt(32)-1
d(ai,aj,ah)end)bLogs:netr("last_data",function(d)if!bLogs[_.s][d]then
return
end
bLogs[_.s][d]=nil
end)bLogs:netr("playerlookup",function(d)if!bLogs:HasAccess(d)then
return
end
local
ak=table.Copy(bLogs.PlayerLookup)if!bLogs:HasAccess(d,"IPAddresses")then
for
d
in
pairs(ak)do
ak[d].IP_Address=nil
end
end
ak=util[_.k](ak)ak=util[_.t](ak)local
al=#ak
bLogs:nets"playerlookup"net[_.u](al)net[_.v](ak,al)net.Send(d)end)bLogs:netr("jump_to_date",function(d)local
am=net[_.F]()am=util.JSONToTable(am)local
an="%s/%s/%s %s:%s"an=an:format(am.day,am.month,am.year,am.hour,am.min)b("SELECT (SELECT CEIL(`"..bLogs[_.C].."` / 60) AS `pages` FROM `blogs` ORDER BY `time` DESC LIMIT 1) - FLOOR(`"..bLogs[_.C].."` / 60) AS `page` FROM `blogs` WHERE `time` <= unix_timestamp(str_to_date('"..a(an).."','%d/%m/%Y %H:%i')) ORDER BY `time` DESC LIMIT 1",function(am)if(#am==0)then
bLogs:nets"no_data"net.Send(d)else
bLogs:nets"jump_to_date"net.WriteInt(am[1].page,32)net.Send(d)end
end)end)bLogs:netr("archive_logs",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
if
bLogs[_.o]then
b([[

				INSERT INTO `blogs_archive` (`module`,`log`,`time`) SELECT `module`,`log`,`time` FROM `blogs` ORDER BY `blogs`.`time` ASC;
				TRUNCATE `blogs`;
				UPDATE `blogs_vars` SET `var_int`=0 WHERE `var_name`='logs';
				UPDATE `blogs_vars` SET `var_int`=(SELECT COUNT(`id`) FROM `blogs_archive`) WHERE `var_name`='logs_archive';

			]],function()bLogs:nets"completed"net.Send(d)end)else
b([[

				INSERT INTO `blogs_archive` (`module`,`log`,`time`) SELECT `module`,`log`,`time` FROM `blogs` ORDER BY `blogs`.`time` ASC;
				DELETE FROM `blogs`; VACUUM;
				UPDATE `blogs_vars` SET `var_int`=0 WHERE `var_name`='logs';
				UPDATE `blogs_vars` SET `var_int`=(SELECT COUNT(`ROWID`) FROM `blogs_archive`) WHERE `var_name`='logs_archive';

			]],function()bLogs:nets"completed"net.Send(d)end)end
end)bLogs:netr("wipe_archive",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
if
bLogs[_.o]then
b([[

				TRUNCATE `blogs_archive`;

				UPDATE `blogs_vars` SET `var_int`=0 WHERE `var_name`='logs_archive';

			]],function()bLogs:nets"completed"net.Send(d)end)else
b([[

				DELETE FROM `blogs_archive`; VACUUM;

				UPDATE `blogs_vars` SET `var_int`=0 WHERE `var_name`='logs_archive';

			]],function()bLogs:nets"completed"net.Send(d)end)end
end)bLogs:netr("reset_config",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
bLogs[_.h]=bLogs[_.G]file.Write("blogs/config.txt",util[_.k](bLogs[_.G]))bLogs:nets"completed"net.Send(d)end)bLogs:netr("update_general_config",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
local
d,ao=net[_.F](),net[_.H]()bLogs[_.h][_.p][d]=ao
file.Write("blogs/config.txt",util[_.k](bLogs[_.h]))c()end)bLogs:netr("update_general_config_num",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
local
d,ap=net[_.F](),net.ReadInt(32)bLogs[_.h][_.p][d]=ap
file.Write("blogs/config.txt",util[_.k](bLogs[_.h]))c()end)bLogs:netr("update_player_format",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
local
d,aq=net[_.F](),net[_.H]()bLogs[_.h].Info[d]=aq
file.Write("blogs/config.txt",util[_.k](bLogs[_.h]))c()end)bLogs:netr("update_modules",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
local
d,ar,as,at=net[_.F](),net[_.H](),net[_.H](),net[_.H]()bLogs[_.h][_.q][d]=ar||nil
bLogs[_.h][_.z][d]=as||nil
bLogs[_.h].SendToDiscord[d]=at||nil
if
ar
then
for
ar,as
in
pairs(bLogs[_.l][d].Hooks)do
hook.Remove(as[1],as[2])end
else
include(bLogs[_.l][d].File)end
file.Write("blogs/config.txt",util[_.k](bLogs[_.h]))c()end)bLogs[_.I]={Menu=!1,IPAddresses=!1}bLogs:netr("permissions",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
local
au,av=net.ReadInt(16),net[_.F]()if(au==1)then
if!tonumber(av)then
bLogs:print("This shouldn't be happening! Please make a ticket and show this: "..tostring(av),"bad")end
av=tonumber(av)if
RPExtraTeams[av]then
av=RPExtraTeams[av].name
if!bLogs[_.h][_.g].Jobs[av]then
bLogs[_.h][_.g].Jobs[av]=table.Copy(bLogs[_.I])end
for
au
in
pairs(bLogs[_.l])do
if(bLogs[_.h][_.g].Jobs[av][au]==nil)then
bLogs[_.h][_.g].Jobs[av][au]=!1
end
end
for
au,aw
in
pairs(bLogs[_.I])do
if(bLogs[_.h][_.g].Jobs[av][au]==nil)then
bLogs[_.h][_.g].Jobs[av][au]=aw
end
end
local
au=util[_.t](util[_.k](bLogs[_.h][_.g].Jobs[av]))local
ax=#au
bLogs:nets"permissions"net[_.u](ax)net[_.v](au,ax)net.Send(d)end
elseif
au==2||au==4||au==5
then
if!bLogs[_.h][_.g][_.f][av]then
bLogs[_.h][_.g][_.f][av]=table.Copy(bLogs[_.I])end
for
au
in
pairs(bLogs[_.l])do
if(bLogs[_.h][_.g][_.f][av][au]==nil)then
bLogs[_.h][_.g][_.f][av][au]=!1
end
end
for
au,ay
in
pairs(bLogs[_.I])do
if(bLogs[_.h][_.g][_.f][av][au]==nil)then
bLogs[_.h][_.g][_.f][av][au]=ay
end
end
local
au=util[_.t](util[_.k](bLogs[_.h][_.g][_.f][av]))local
az=#au
bLogs:nets"permissions"net[_.u](az)net[_.v](au,az)net.Send(d)elseif
au==3||au==6&&av:find"^STEAM_%d:%d:%d+$"then
if!bLogs[_.h][_.g][_.i][av]then
bLogs[_.h][_.g][_.i][av]=table.Copy(bLogs[_.I])end
for
au
in
pairs(bLogs[_.l])do
if(bLogs[_.h][_.g][_.i][av][au]==nil)then
bLogs[_.h][_.g][_.i][av][au]=!1
end
end
for
au,aA
in
pairs(bLogs[_.I])do
if(bLogs[_.h][_.g][_.i][av][au]==nil)then
bLogs[_.h][_.g][_.i][av][au]=aA
end
end
local
au=util[_.t](util[_.k](bLogs[_.h][_.g][_.i][av]))local
aB=#au
bLogs:nets"permissions"net[_.u](aB)net[_.v](au,aB)net.Send(d)end
file.Write("blogs/config.txt",util[_.k](bLogs[_.h]))c()end)bLogs:netr("permissions_update",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
local
d,aC,aD=net[_.F](),net[_.F](),net[_.H]()aC=({["## Open Menu"]="Menu",["## See IP Addresses"]="IPAddresses"})[aC]||aC
if
aC:find"^.-: .-$"then
aC=aC:gsub("^(.-): (.-)$","%1_%2")end
if
d:sub(1,5)=="Job: "||d:sub(1,6)=="Team: "then
local
aE
if(d:sub(1,5)=="Job: ")then
aE=d:sub(6)else
aE=d:sub(7)end
for
aF,aG
in
pairs(RPExtraTeams)do
if(aG.name==aE)then
bLogs[_.h][_.g].Jobs[aG.name][aC]=aD
break
end
end
elseif(d:sub(1,6)=="CAMI: ")then
bLogs[_.h][_.g][_.f][d:sub(7)][aC]=aD
elseif(d:sub(1,9)=="SteamID: ")then
bLogs[_.h][_.g][_.i][d:sub(10)][aC]=aD
elseif(d:sub(1,11)=="Usergroup: ")then
bLogs[_.h][_.g][_.f][d:sub(12)][aC]=aD
end
file.Write("blogs/config.txt",util[_.k](bLogs[_.h]))c()end)bLogs:netr("permissions_delete",function(d)if!bLogs:IsMaxPermitted(d)then
return
end
local
d=net[_.F]()if
d:sub(1,5)=="Job: "||d:sub(1,6)=="Team: "then
local
aH
if(d:sub(1,5)=="Job: ")then
aH=d:sub(6)else
aH=d:sub(7)end
for
aI,aJ
in
pairs(RPExtraTeams)do
if(aJ.name==aH)then
bLogs[_.h][_.g].Jobs[aJ.name]=nil
break
end
end
elseif(d:sub(1,6)=="CAMI: ")then
bLogs[_.h][_.g][_.f][d:sub(7)]=nil
elseif(d:sub(1,9)=="SteamID: ")then
bLogs[_.h][_.g][_.i][d:sub(10)]=nil
elseif(d:sub(1,11)=="Usergroup: ")then
bLogs[_.h][_.g][_.f][d:sub(12)]=nil
end
file.Write("blogs/config.txt",util[_.k](bLogs[_.h]))c()end)bLogs_FullyLoaded=!!1
hook.Run"bLogs_FullyLoaded"end
include"blogs_mysql_config.lua"if
bLogs[_.e][_.d][_.a]then
if
system.IsWindows()then
if!file[_.c]("bin/gmsv_mysqloo_win32.dll","LUA")then
bLogs[_.e][_.d]=!1
if
file[_.c]("bin/gmsv_mysqloo_linux.dll","LUA")then
BillyError("bLogs","Why have you installed the Linux version of mysqloo when your server is running Windows?")else
BillyError("bLogs","You don't have mysqloo installed, but have MySQL enabled.")end
else
local
a,b=pcall(require,"mysqloo")if
a
then
require"mysqloo"elseif(b=="Couldn't load module library!")then
bLogs[_.e][_.d]=!1
BillyError("bLogs","You don't have libmysql.dll installed. https://facepunch.com/showthread.php?t=1515853")end
bLogs:print("Initialized mysqloo","good")end
end
if
system.IsLinux()then
if!file[_.c]("bin/gmsv_mysqloo_linux.dll","LUA")then
bLogs[_.e][_.d]=!1
if
file[_.c]("bin/gmsv_mysqloo_win32.dll","LUA")then
BillyError("bLogs","Why have you installed the Windows version of mysqloo when your server is running Linux?")else
BillyError("bLogs","You don't have mysqloo installed, but have MySQL enabled.")end
else
local
a,b=pcall(require,"mysqloo")if
a
then
require"mysqloo"elseif(b=="Couldn't load module library!")then
bLogs[_.e][_.d]=!1
BillyError("bLogs","You don't have libmysqlclient.so installed. https://facepunch.com/showthread.php?t=1515853")end
bLogs:print("Initialized mysqloo","good")end
end
end
if
bLogs[_.e][_.d][_.a]then
bLogs[_.C]="id"if
bLogs[_.e][_.d].Host
then
if(type(bLogs[_.e][_.d].Host)~="string")then
BillyError("bLogs","You have an error in your MySQL config related to config.Host.")end
else
BillyError("bLogs","You have an error in your MySQL config related to config.Host. It is not a string.")end
if
bLogs[_.e][_.d].Username
then
if(type(bLogs[_.e][_.d].Username)~="string")then
BillyError("bLogs","You have an error in your MySQL config related to config.Username.")end
else
BillyError("bLogs","You have an error in your MySQL config related to config.Username. It is not a string.")end
if
bLogs[_.e][_.d].Password
then
if(type(bLogs[_.e][_.d].Password)~="string")then
BillyError("bLogs","You have an error in your MySQL config related to config.Password.")end
else
BillyError("bLogs","You have an error in your MySQL config related to config.Password.")end
if
bLogs[_.e][_.d][_.o]then
if(type(bLogs[_.e][_.d][_.o])~="string")then
BillyError("bLogs","You have an error in your MySQL config related to config.Database. It is not a string.")end
else
BillyError("bLogs","You have an error in your MySQL config related to config.Database.")end
if
bLogs[_.e][_.d].Port
then
if(type(bLogs[_.e][_.d].Port)~="number")then
BillyError("bLogs","You have an error in your MySQL config related to config.Port. It is not a number.")end
else
BillyError("bLogs","You have an error in your MySQL config related to config.Port.")end
bLogs[_.o]=mysqloo.connect(bLogs[_.e][_.d].Host,bLogs[_.e][_.d].Username,bLogs[_.e][_.d].Password,bLogs[_.e][_.d][_.o],bLogs[_.e][_.d].Port)bLogs:print"Connecting to remote database..."bLogs[_.o].onConnectionFailed=function(c,aK)BillyError("bLogs","There was an error connecting to your MySQL server. The error was:\n\n"..aK.."\n\nThe script is still running but is not using MySQL.")bLogs[_.o]=nil
d()end
bLogs[_.o].onConnected=function()bLogs:print("Successfully connected to remote database on "..bLogs[_.e][_.d].Host..":"..bLogs[_.e][_.d].Port..".","good")local
c=[[

			CREATE TABLE IF NOT EXISTS `blogs_players` (
				`server_id` int(11) NOT NULL DEFAULT '1',
				`steamid64` varchar(191) NOT NULL,
				`name` varchar(191) CHARACTER SET utf8mb4 NOT NULL,
				`usergroup` varchar(191) CHARACTER SET utf8mb4 DEFAULT NULL,
				`ip_address` varchar(191) DEFAULT NULL,
				`last_updated` int(11) NOT NULL,
				PRIMARY KEY (`server_id`,`steamid64`)
			);

		]]b([[

			CREATE TABLE IF NOT EXISTS `blogs` (
				`id` int(11) NOT NULL AUTO_INCREMENT,
				`server_id` int(11) NOT NULL,
				`session` int(11) NOT NULL,
				`module` varchar(191) NOT NULL,
				`log` text CHARACTER SET utf8mb4 NOT NULL,
				`time` int(11) NOT NULL,
				PRIMARY KEY (`id`)
			);

			CREATE TABLE IF NOT EXISTS `blogs_archive` (
				`id` int(11) NOT NULL AUTO_INCREMENT,
				`server_id` int(11) NOT NULL,
				`module` varchar(191) NOT NULL,
				`log` text CHARACTER SET utf8mb4 NOT NULL,
				`time` int(11) NOT NULL,
				PRIMARY KEY (`id`)
			);

			CREATE TABLE IF NOT EXISTS `blogs_servers` (
				`id` varchar(191) CHARACTER SET utf8mb4 NOT NULL,
				`numeric_id` int(11) NOT NULL AUTO_INCREMENT,
				`hostname` varchar(191) CHARACTER SET utf8mb4 NOT NULL,
				`ip_address` varchar(191) NOT NULL,
				`last_updated` int(11) NOT NULL,
				`deleted` tinyint(4) NOT NULL DEFAULT '0',
				PRIMARY KEY (`id`),
				UNIQUE KEY `numeric_id` (`numeric_id`)
			);

			CREATE TABLE IF NOT EXISTS `blogs_vars` (
				`var_name` varchar(191) NOT NULL,
				`var_str` varchar(191) NOT NULL,
				`var_int` int(11) NOT NULL,
				PRIMARY KEY (`var_name`)
			);

			]]..c..[[

			INSERT IGNORE INTO `blogs_vars` (`var_name`,`var_str`,`var_int`) VALUES ('session','','0');
			INSERT IGNORE INTO `blogs_vars` (`var_name`,`var_str`,`var_int`) VALUES ('logs','','0');
			INSERT IGNORE INTO `blogs_vars` (`var_name`,`var_str`,`var_int`) VALUES ('logs_archive','','0');

			UPDATE `blogs_vars` SET `var_int`=`var_int` + 1 WHERE `var_name`='session';
			INSERT INTO `blogs_archive` (`server_id`,`module`,`log`,`time`) SELECT `server_id`,`module`,`log`,`time` FROM `blogs` WHERE `session` != (SELECT `var_int` FROM `blogs_vars` WHERE `var_name`='session') ORDER BY `blogs`.`time` ASC;
			TRUNCATE `blogs`;

		]],function()b("SHOW COLUMNS FROM `blogs_players` WHERE `Field`='usergroup'",function(aL)if(#aL==0)then
b("DROP TABLE `blogs_players`",function()b(c)end)else
b(c)end
end)if
bLogs[_.h][_.p].AutoDeleteEnabled
then
local
aM=bLogs[_.h][_.p].AutoDelete*86400
b("DELETE FROM `blogs_archive` WHERE `time` < (UNIX_TIMESTAMP() - "..aM..")")end
if
bLogs[_.h][_.p].VolatileLogs
then
b"TRUNCATE `blogs_archive`"end
b("INSERT INTO `blogs_servers` (`id`, `hostname`, `ip_address`, `last_updated`) VALUES('"..a(bLogs[_.e][_.d][_.j]).."','"..a((GetConVar"hostname"):GetString()).."','"..a(game[_.A]()).."','"..a(os.time()).."') ".."ON DUPLICATE KEY UPDATE `hostname`='"..a((GetConVar"hostname"):GetString()).."', `last_updated`='"..a(os.time()).."', `ip_address`='"..a(game[_.A]()).."'",function()b("SELECT `numeric_id` FROM `blogs_servers` WHERE `id`='"..a(bLogs[_.e][_.d][_.j]).."'",function(aN)bLogs[_.j]=aN[1]["numeric_id"]local
function
aN()local
aN=""for
aO,aP
in
pairs(player.GetHumans())do
aN=aN.."INSERT INTO `blogs_players` (`server_id`,`steamid64`,`usergroup`,`name`,`ip_address`,`last_updated`) VALUES('"..a(bLogs[_.j]).."','"..a(aP:SteamID64()).."','"..a(aP:GetUserGroup()).."','"..a(aP:Nick()).."','"..a(aP:IPAddress()).."','"..a(os.time()).."') ".."ON DUPLICATE KEY UPDATE `usergroup`='"..a(aP:GetUserGroup()).."', `name`='"..a(aP:Nick()).."', `ip_address`='"..a(aP:IPAddress()).."', `last_updated`='"..a(os.time()).."';\n"end
if(aN~="")then
b(aN)end
end
aN()timer.Create("blogs_update_players_tbl",60,0,aN)local
function
aN()b("SELECT COUNT(`id`) FROM `blogs`",function(aN)b("UPDATE `blogs_vars` SET `var_int`='"..a(aN[1]["COUNT(`id`)"]).."' WHERE `var_name`='logs'",function()b("SELECT COUNT(`id`) FROM `blogs_archive`",function(aN)b("UPDATE `blogs_vars` SET `var_int`='"..a(aN[1]["COUNT(`id`)"]).."' WHERE `var_name`='logs_archive'",function()b("SELECT `var_name`,`var_int` FROM `blogs_vars` WHERE `var_name`='session' OR `var_name`='logs' OR `var_name`='logs_archive'",function(aN)for
aN,aQ
in
pairs(aN)do
if(aQ.var_name=="session")then
bLogs.Session=aQ.var_int
bLogs:print("Session #    : "..aQ.var_int)elseif(aQ.var_name=="logs")then
bLogs:print("Active Logs  : "..aQ.var_int)elseif(aQ.var_name=="logs_archive")then
bLogs:print("Archived Logs: "..aQ.var_int)end
end
bLogs:print("Server ID    : "..bLogs[_.e][_.d][_.j])bLogs:print("Server #     : "..bLogs[_.j])d()end)end)end)end)end)end
aN()end)end)end)end
bLogs[_.o]:connect()else
bLogs[_.C]="ROWID"b({[[
			CREATE TABLE IF NOT EXISTS `blogs` (
				`module` varchar NOT NULL,
				`log` text NOT NULL,
				`time` int NOT NULL
			)
		]],[[
			CREATE TABLE IF NOT EXISTS `blogs_archive` (
				`module` varchar NOT NULL,
				`log` text NOT NULL,
				`time` int NOT NULL
			)
		]],[[
			CREATE TABLE IF NOT EXISTS `blogs_vars` (
				`var_name` varchar NOT NULL,
				`var_str` varchar NOT NULL,
				`var_int` int NOT NULL,
				PRIMARY KEY (`var_name`)
			)
		]],"INSERT OR IGNORE INTO `blogs_vars` (`var_name`,`var_str`,`var_int`) VALUES ('logs','','0')","INSERT OR IGNORE INTO `blogs_vars` (`var_name`,`var_str`,`var_int`) VALUES ('logs_archive','','0')",[[
			CREATE TABLE IF NOT EXISTS `blogs_players` (
				`steamid64`  NOT NULL,
				`name` NOT NULL,
				PRIMARY KEY (`steamid64`)
			)
		]],"DELETE FROM `blogs_archive`","VACUUM","INSERT INTO `blogs_archive` (`module`,`log`,`time`) SELECT `module`,`log`,`time` FROM `blogs` ORDER BY `blogs`.`time` ASC","UPDATE `blogs_vars` SET `var_int`=(SELECT COUNT(`ROWID`) FROM `blogs_archive`) WHERE `var_name`='logs_archive'","DELETE FROM `blogs`","VACUUM","CREATE TRIGGER IF NOT EXISTS lognum_add AFTER INSERT ON `blogs` FOR EACH ROW BEGIN UPDATE `blogs_vars` SET `var_int`=`var_int`+1 WHERE `var_name`='logs'; END","CREATE TRIGGER IF NOT EXISTS lognum_sub AFTER DELETE ON `blogs` FOR EACH ROW BEGIN UPDATE `blogs_vars` SET `var_int`=`var_int`-1 WHERE `var_name`='logs'; END"},function()d()end)end
concommand.Add("blogs_licensekey",function(a)a:PrintMessage(HUD_PRINTCONSOLE,bLogs[_.b])end)