//#define TESTING
#if DM_VERSION < 506
#warn This compiler is out of date. You may experience issues with projectile animations.
#endif


// Items that ask to be called every cycle.
var/global/datum/datacore/data_core = null
var/global/list/all_areas                = list()
var/global/list/machines                 = list()
var/global/list/processing_objects       = list()
var/global/list/processing_modifiers     = list()
var/global/list/processing_power_items   = list()
var/global/list/active_diseases          = list()
var/global/list/med_hud_users            = list() // List of all entities using a medical HUD.
var/global/list/sec_hud_users            = list() // List of all entities using a security HUD.
var/global/list/hud_icon_reference       = list()


var/global/list/global_mutations  = list() // List of hidden mutation things.

var/global/datum/universal_state/universe = new

var/global/list/global_map = null

// Noises made when hit while typing.
var/list/hit_appends = list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF")


var/diary               = null
var/diary_runtime  = null
var/diary_date_string = null
var/href_logfile        = null
var/station_name        = "NSS Exodus"
var/station_short       = "Exodus"
var/const/dock_name     = "NTCC Odin"
var/const/boss_name     = "Central Command"
var/const/boss_short    = "Centcomm"
var/const/company_name  = "NanoTrasen"
var/const/company_short = "NT"
var/game_version        = "Baystation12"
var/changelog_hash      = ""
var/game_year           = (text2num(time2text(world.realtime, "YYYY")) + 544)

var/round_progressing = 1
var/master_mode       = "extended" // "extended"
var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed

var/list/jobMax        = list()
var/list/bombers       = list()
var/list/admin_log     = list()
var/list/lastsignalers = list() // Keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
var/list/lawchanges    = list() // Stores who uploaded laws to which silicon-based lifeform, and what the law was.
var/list/reg_dna       = list()

var/list/monkeystart     = list()
var/list/wizardstart     = list()
var/list/newplayer_start = list()

//Spawnpoints.
var/list/latejoin         = list()
var/list/latejoin_gateway = list()
var/list/latejoin_cryo    = list()
var/list/latejoin_cyborg  = list()

var/list/prisonwarp         = list() // Prisoners go to these
var/list/holdingfacility    = list() // Captured people go here
var/list/xeno_spawn         = list() // Aliens spawn at at these.
var/list/tdome1             = list()
var/list/tdome2             = list()
var/list/tdomeobserve       = list()
var/list/tdomeadmin         = list()
var/list/prisonsecuritywarp = list() // Prison security goes to these.
var/list/prisonwarped       = list() // List of players already warped.
var/list/ninjastart         = list()

var/list/cardinal    = list(NORTH, SOUTH, EAST, WEST)
var/list/cornerdirs  = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/alldirs     = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/reverse_dir = list( // reverse_dir[dir] = reverse of dir
	 2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)

var/datum/configuration/config      = null
var/datum/sun/sun                   = null

var/list/combatlog = list()
var/list/IClog     = list()
var/list/OOClog    = list()
var/list/adminlog  = list()

var/list/powernets = list()

var/Debug2 = 0
var/datum/debug/debugobj

var/datum/moduletypes/mods = new()

var/gravity_is_on = 1

var/datum/server_greeting/server_greeting = null
var/forceblob = 0

var/datum/nanomanager/nanomanager		= new() // NanoManager, the manager for Nano UIs.
var/datum/event_manager/event_manager	= new() // Event Manager, the manager for events.

var/list/awaydestinations = list() // Away missions. A list of landmarks that the warpgate can take you to.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

// Database connections. A connection is established along with /hook/startup/proc/load_databases().
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/DBConnection/dbcon

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
/var/list/tagger_locations = list()

// Added for Xenoarchaeology, might be useful for other stuff.
var/global/list/alphabet_uppercase = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")

// Used by robots and robot preferences.
var/list/robot_module_types = list(
	"Standard", "Engineering", "Construction", "Medical",  "Rescue",
	"Miner",    "Custodial",     "Service",      "Clerical", "Security",
	"Research"
)

// Some scary sounds.
var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
)

// Bomb cap!
var/max_explosion_range = 14

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
var/global/obj/item/device/radio/intercom/global_announcer = new(null)

var/list/station_departments = list("Command", "Medical", "Engineering", "Science", "Security", "Cargo", "Civilian")

var/global/const/TICKS_IN_DAY = 864000
var/global/const/TICKS_IN_HOUR = 36000
var/global/const/TICKS_IN_SECOND = 10
