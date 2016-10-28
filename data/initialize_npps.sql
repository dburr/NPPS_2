-- This file contains bunch of SQL statement to initialize private server environment for the first time.

CREATE TABLE `event_list` (
	event_id INTEGER PRIMARY KEY,						-- The event ID from event_common.db_
	start_time INTEGER NOT NULL DEFAULT 0,				-- Unix timestamp when the event start
	end_time INTEGER NOT NULL DEFAULT 2147483647,		-- When the event is end.
	close_time INTEGER NOT NULL DEFAULT 2147483647,		-- When the event page is closed.
	token_image TEXT,									-- The token note image or NULL if it's not token event. Format: <token name>:<token image path>
	easy_song_list TEXT,								-- The easy song list. For token, it's the event song. For SM/MedFes, the song that available in event. Comma separated
	normal_song_list TEXT,								-- Same as above, for normal
	hard_song_list TEXT,								-- Same as above, for hard
	expert_song_list TEXT,								-- Same as above, for expert. Note for x4 event song: use "!<live id>" instead.
	technical_song_list TEXT,							-- Same as above, for technical (EXR). Score match only.
	easy_lp INTEGER NOT NULL DEFAULT 5,					-- Needed LP to play easy song. Ignored if `easy_song_list` is NULL
	normal_lp INTEGER NOT NULL DEFAULT 10,				-- Same as above (normal)
	hard_lp INTEGER NOT NULL DEFAULT 15,				-- Same as above (hard)
	expert_lp INTEGER NOT NULL DEFAULT 25,				-- Same as above (expert)
	technical_lp INTEGER NOT NULL DEFAULT 25,			-- Same as above (technical)
	event_ranking_table TEXT NOT NULL,					-- The event player ranking list table.
	event_song_table TEXT DEFAULT NULL					-- The event song ranking list table for token event or NULL
);
CREATE TABLE `logged_in` (
	login_key TEXT,											-- The associated login key or NULL if stil in "authkey"
	login_pwd TEXT,											-- The associated login password or NULL if still in "authkey"
	token TEXT NOT NULL,									-- The token.
	time INTEGER NOT NULL,									-- Last activity time.
	pseudo_unit_own_id INTEGER NOT NULL DEFAULT 2147483647	-- Pseudo unit_owning_user_id to solve some problems related to unit.
);
CREATE TABLE `users` (
	user_id INTEGER PRIMARY KEY AUTO_INCREMENT,				-- The user ID
	login_key TEXT,											-- The associated login key
	login_pwd TEXT,											-- The associated login password
	passcode TEXT DEFAULT NULL,								-- The issued passcode in format <passcode>:<platform id>
	passcode_issue INTEGER DEFAULT NULL,					-- Unix timestamp when the passcode issued or NULL.
	platform_code TEXT DEFAULT NULL,						-- The platform token. For loading accounts with Google+/Game Center. In format <code>:<platform id>
	locked BOOL NOT NULL DEFAULT 0,							-- Is the account banned?
	tos_agree INTEGER NOT NULL DEFAULT 0,					-- Tos agree number.
	create_date INTEGER NOT NULL,							-- When this account is created
	first_choosen INTEGER NOT NULL DEFAULT 0,				-- The first choosen card ID in the game.
	name VARCHAR(10) NOT NULL DEFAULT "Null",				-- Nickname
	bio VARCHAR(105) NOT NULL DEFAULT "Hello!",				-- About me section.
	invite_code VARCHAR(9),									-- Friend ID
	last_active INTEGER NOT NULL,							-- Last active in unix timestamp
	login_count INTEGER NOT NULL DEFAULT 0,					-- Last lbonus/execute execution timestamp
	background_id INTEGER NOT NULL DEFAULT 1,				-- Set background
	badge_id INTEGER NOT NULL DEFAULT 1,					-- Set badge (titles)
	current_exp INTEGER NOT NULL DEFAULT 0,					-- Current EXP
	next_exp INTEGER NOT NULL, 								-- Next EXP before level up
	level INTEGER NOT NULL DEFAULT 1,						-- The player rank
	gold INTEGER NOT NULL DEFAULT 36400,					-- Gold amount
	friend_point INTEGER NOT NULL DEFAULT 5,				-- Friend Point amount
	paid_loveca INTEGER NOT NULL DEFAULT 0,					-- Amount of loveca that bought
	free_loveca INTEGER NOT NULL DEFAULT 0,					-- Amount of loveca that came in-game (not bought)
	max_lp INTEGER NOT NULL DEFAULT 25,						-- Maximum LP
	max_friend INTEGER NOT NULL DEFAULT 10,					-- Max friend
	overflow_lp INTEGER NOT NULL DEFAULT 0,					-- Amount of additional LP
	full_lp_recharge INTEGER NOT NULL DEFAULT 0,			-- Unix time before the LP fully recharged.
	max_unit INTEGER NOT NULL DEFAULT 90,					-- Maximum memberlist. Including the ones that increased with loveca.
	max_unit_loveca INTEGER NOT NULL DEFAULT 0,				-- Amount of "Increase Member Limit".
	main_deck INTEGER NOT NULL DEFAULT 1,					-- Which deck is set to "Main"?
	normal_sticker INTEGER NOT NULL DEFAULT 0,				-- R stickers
	silver_sticker INTEGER NOT NULL DEFAULT 0,				-- SR stickers
	gold_sticker INTEGER NOT NULL DEFAULT 0,				-- UR stickers
	tutorial_state INTEGER NOT NULL DEFAULT 0,				-- The tutorial state.
	latest_scenario DECIMAL(8,4) NOT NULL DEFAULT 3.3000,	-- Last unlocked scenario (integral part). The fraction part is story ID that haven't viewed.
	subscenario_tracking TEXT DEFAULT NULL,					-- Unlocked subscenario ID list. Add '!' to indicate it's already viewed. Comma separated (defaults to empty string)
	unlocked_badge TEXT NOT NULL,							-- Unlocked badge. Comma separated
	unlocked_background TEXT NOT NULL,						-- Unlocked background. Comma separated
	friend_list TEXT NOT NULL,								-- Friendlist in format <user ID>,<user ID>,...
	present_table TEXT NOT NULL,							-- The present box table name
	achievement_table TEXT NOT NULL,						-- The assignment table name
	item_table TEXT NOT NULL,								-- The items table name (add_type = 1000)
	live_table TEXT NOT NULL,								-- The live information table name
	unit_table TEXT NOT NULL,								-- Unit list table name
	deck_table TEXT NOT NULL,								-- Deck list table name
	sticker_table TEXT NOT NULL,							-- List of already exchanged seals (for item with limited amount)
	login_bonus_table TEXT NOT NULL,						-- Login bonus tracking.
	album_table TEXT NOT NULL								-- Album tracking.
);
CREATE TABLE `login_bonus` (
	month INTEGER NOT NULL,					-- The month number
	day INTEGER NOT NULL,					-- The day
	item_id INTEGER NOT NULL,				-- The item ID
	card_num INTEGER,						-- Card ID (not in album) or NULL
	amount INTEGER NOT NULL,				-- Item amout
	PRIMARY KEY(month, day)
);
-- The login bonus in-order: loveca(1), gold(3000), fp(500), repeat (every month)
CREATE TABLE `special_login_bonus` (
	login_bonus_id INTEGER PRIMARY KEY,				-- Login bonus ID. You should not use 0
	start_time INTEGER NOT NULL DEFAULT 0,			-- When the login bonus should start distributed
	end_time INTEGER NOT NULL DEFAULT 2147483647,	-- When the login bonus no longer distributed
	message TEXT NOT NULL,							-- Message to show in-game
	banner TEXT NOT NULL,							-- Banner to show in-game
	items TEXT NOT NULL								-- Items list. Format: <item ID>:<amount>[:<more ID>],<item ID>:<amount>[:<more ID>],... MAX 7.
);
CREATE TABLE `birthday_login_bonus` (
	date VARCHAR(5) NOT NULL,	-- In DD-MM format. Login bonus ID is "(day * 12 + (month - 1)) << 16" (used when sending response only)
	message TEXT NOT NULL,		-- Message to show in-game
	banner TEXT NOT NULL,		-- Banner to show in-game
	add_type INTEGER NOT NULL,	-- The add_type item ID
	item_id INTEGER,			-- Item ID or NULL.
	amount INTEGER NOT NULL		-- Item amout
);
CREATE TABLE `sticker_shop_item` (
	sticker_id INTEGER PRIMARY KEY AUTO_INCREMENT,	-- Sticker ID
	add_type INTEGER NOT NULL,						-- The add_type item ID
	item_id INTEGER,								-- Item ID or NULL.
	cost VARCHAR(10) NOT NULL,						-- The cost in format: <rarity lowercase>:<cost>. Example: ur:3
	max_amount INTEGER NOT NULL DEFAULT -1,			-- Maximum amount that can be exchanged (or -1 for unlimited)
	expire INTEGER DEFAULT NULL						-- Unix timestamp when the item no longer in sticker shop (or NULL for no expiration)
);
CREATE TABLE `wip_live` (
	user_id INTEGER NOT NULL,					-- User ID who do the live.
	live_difficulty_id INTEGER NOT NULL,		-- The live ID
	live_difficulty_id2 INTEGER DEFAULT NULL,	-- Second live ID (MedFes)
	live_difficulty_id3 INTEGER DEFAULT NULL,	-- Third live ID (MedFes)
	deck_num INTEGER NOT NULL,					-- Used deck in this live show
	event_id INTEGER DEFAULT NULL,				-- Event ID which starts this live show (like scorematch, medfes)
	guest_user_id INTEGER DEFAULT NULL,			-- Who is the guest? (non-event only)
	live_data TEXT DEFAULT NULL,				-- Live-specific related data
	started INTEGER NOT NULL					-- Used to prevent people from completing live too fast
);
CREATE TABLE `wip_scenario` (
	user_id INTEGER NOT NULL,				-- User ID who started the scenario/subscenario
	scenario_id INTEGER DEFAULT NULL,		-- Scenario ID or NULL if it's subscenario
	subscenario_id INTEGER DEFAULT NULL		-- Subscenario ID or NULL if it's scenario
);
CREATE TABLE `free_gacha_tracking` (
	user_id INTEGER NOT NULL PRIMARY KEY,	-- User ID who execute the free gacha
	next_free_gacha INTEGER NOT NULL		-- Unix timestamp when the next free gacha.
);
CREATE TABLE `notice_list` (
	notice_id INTEGER PRIMARY KEY AUTO_INCREMENT,	-- Notice ID. Auto increment.
	receiver_user_id INTEGER NOT NULL,				-- To user_id
	sender_user_id INTEGER NOT NULL,				-- From user_id/affector
	notice_filter INTEGER NOT NULL,					-- Notice filter ID
	message TEXT NOT NULL,							-- The message. Truncate to 15 character when sent to client
	is_new BOOL NOT NULL DEFAULT 1,					-- Is unread?
	is_pm BOOL NOT NULL DEFAULT 0,					-- Is private message?
	is_replied BOOL DEFAULT 0						-- Is player already replied to this message?
);
CREATE TABLE `b_side_schedule` (
	live_difficulty_id INTEGER NOT NULL PRIMARY KEY,			-- The live difficulty ID
	start_available_time INTEGER NOT NULL DEFAULT 0,			-- When it comes? (Unix timestamp) default to "already exists"
	end_available_time INTEGER NOT NULL DEFAULT 2147483647		-- When it leaves? (Unix timestamp) default to "never leaves"
);
CREATE TABLE `daily_rotation` (
	live_difficulty_id INTEGER NOT NULL,		-- The live ID
	daily_category INTEGER NOT NULL				-- The daily live categoy ID.
);
CREATE TABLE `secretbox_gauge` (
	user_id INTEGER NOT NULL PRIMARY KEY,		-- The user ID
	gauge INTEGER NOT NULL DEFAULT 0			-- The gauge. The value will be multiplied by 10 automatically
);
CREATE TABLE `personal_notice` (
	user_id INTEGER NOT NULL PRIMARY KEY,		-- The user ID who will receive it
	title TEXT,									-- The personal notice title
	contents TEXT								-- The personal notice text
);
/*
You may want to add 1 dummy user in your list first so that you can Live Show!
Table definition above is necessary for the server. Now the user-specific SQL structure is in initialize_user.sql

/*
The event ranking table definition file is:
Token event: initialize_event_marathon.sql
Scorematch event: initialize_event_battle.sql
MedFes event: initialize_event_festival.sql
ChaFes event: initialize_event_challenge.sql
*/

-- Insert birthday login bonus
INSERT INTO `birthday_login_bonus` VALUES("17-01", CONCAT("January 17 is Hanayo Koizumi's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_8_1.png", 3001, NULL, 5);	-- Hanayo
INSERT INTO `birthday_login_bonus` VALUES("15-03", CONCAT("March 15 is Umi Sonoda's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_9_1.png", 3001, NULL, 5);		-- Umi
INSERT INTO `birthday_login_bonus` VALUES("19-04", CONCAT("April 19 is Maki Nishikino's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_1_1.png", 3001, NULL, 5);		-- Maki
INSERT INTO `birthday_login_bonus` VALUES("09-06", CONCAT("June 9 is Nozomi Tojo's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_2_1.png", 3001, NULL, 5);	-- Nozomi
INSERT INTO `birthday_login_bonus` VALUES("22-07", CONCAT("July 22 is Nico Yazawa's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_3_1.png", 3001, NULL, 5);		-- Nico
INSERT INTO `birthday_login_bonus` VALUES("03-08", CONCAT("August 3 is Honoka Kosaka's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_4_1.png", 3001, NULL, 5);	-- Honoka
INSERT INTO `birthday_login_bonus` VALUES("12-09", CONCAT("September 12 is Kotori Minami's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_5_1.png", 3001, NULL, 5);	-- Kotori
INSERT INTO `birthday_login_bonus` VALUES("21-10", CONCAT("October 21 is Eli Ayase's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_6_1.png", 3001, NULL, 5);		-- Eli
INSERT INTO `birthday_login_bonus` VALUES("01-11", CONCAT("November 1 is Rin Hoshizora's birthday!", CHAR(10), "To celebrate the occasion, we are giving away 5 Love Gems", CHAR(10), "as a Login Bonus today."), "assets/image/ui/login_bonus_extra/birthday_7_1.png", 3001, NULL, 5);		-- Rin

-- Insert daily rotation songs
INSERT INTO `daily_rotation` VALUES (46, 1);	-- Mermaid Festa vol.2 Easy
INSERT INTO `daily_rotation` VALUES (47, 2);	-- Mermaid Festa vol.2 Normal
INSERT INTO `daily_rotation` VALUES (48, 3);	-- Mermaid Festa vol.2 Hard
INSERT INTO `daily_rotation` VALUES (458, 4);	-- Mermaid Festa vol.2 Expert
INSERT INTO `daily_rotation` VALUES (455, 5);	-- Nawatobi Easy
INSERT INTO `daily_rotation` VALUES (456, 6);	-- Nawatobi Normal
INSERT INTO `daily_rotation` VALUES (457, 7);	-- Nawatobi Hard
INSERT INTO `daily_rotation` VALUES (568, 8);	-- Nawatobi Expert
INSERT INTO `daily_rotation` VALUES (52, 1);	-- Kokuhaku Biyori, desu Easy
INSERT INTO `daily_rotation` VALUES (53, 2);	-- Kokuhaku Biyori, desu Normal
INSERT INTO `daily_rotation` VALUES (54, 3);	-- Kokuhaku Biyori, desu Hard
INSERT INTO `daily_rotation` VALUES (463, 4);	-- Kokuhaku Biyori, desu Expert
INSERT INTO `daily_rotation` VALUES (443, 5);	-- Anemone Heart Easy
INSERT INTO `daily_rotation` VALUES (444, 6);	-- Anemone Heart Normal
INSERT INTO `daily_rotation` VALUES (445, 7);	-- Anemone Heart Hard
INSERT INTO `daily_rotation` VALUES (567, 8);	-- Anemone Heart Expert
INSERT INTO `daily_rotation` VALUES (55, 1);	-- Soldier Game Easy
INSERT INTO `daily_rotation` VALUES (56, 2);	-- Soldier Game Normal
INSERT INTO `daily_rotation` VALUES (57, 3);	-- Soldier Game Hard
INSERT INTO `daily_rotation` VALUES (459, 4);	-- Soldier Game Expert
INSERT INTO `daily_rotation` VALUES (440, 5);	-- Yume naki Yume wa Yume jyanai Easy
INSERT INTO `daily_rotation` VALUES (441, 6);	-- Yume naki Yume wa Yume jyanai Normal
INSERT INTO `daily_rotation` VALUES (442, 7);	-- Yume naki Yume wa Yume jyanai Hard
INSERT INTO `daily_rotation` VALUES (566, 8);	-- Yume naki Yume wa Yume jyanai Expert
INSERT INTO `daily_rotation` VALUES (49, 1);	-- Otomeshiki Renai Juku Easy
INSERT INTO `daily_rotation` VALUES (50, 2);	-- Otomeshiki Renai Juku Normal
INSERT INTO `daily_rotation` VALUES (51, 3);	-- Otomeshiki Renai Juku Hard
INSERT INTO `daily_rotation` VALUES (446, 4);	-- Otomeshiki Renai Juku Expert
INSERT INTO `daily_rotation` VALUES (485, 5);	-- Garasu no Hanazono Easy
INSERT INTO `daily_rotation` VALUES (486, 6);	-- Garasy no Hanazono Normal
INSERT INTO `daily_rotation` VALUES (487, 7);	-- Garasu no Hanazono Hard
INSERT INTO `daily_rotation` VALUES (594, 8);	-- Garasu no Hanazono Expert
INSERT INTO `daily_rotation` VALUES (482, 5);	-- Nico Puri Easy
INSERT INTO `daily_rotation` VALUES (483, 6);	-- Nico Puri Normal
INSERT INTO `daily_rotation` VALUES (484, 7);	-- Nico Puri Hard
INSERT INTO `daily_rotation` VALUES (593, 8);	-- Nico Puri Expert
INSERT INTO `daily_rotation` VALUES (479, 5);	-- Beat in Angel Easy
INSERT INTO `daily_rotation` VALUES (480, 6);	-- Beat in Angel Normal
INSERT INTO `daily_rotation` VALUES (481, 7);	-- Beat in Angel Hard
INSERT INTO `daily_rotation` VALUES (569, 8);	-- Beat in Angel Expert