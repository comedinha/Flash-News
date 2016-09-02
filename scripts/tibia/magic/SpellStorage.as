package tibia.magic
{
   import flash.geom.Point;
   import tibia.game.Delay;
   
   public class SpellStorage
   {
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      protected static const PK_REVENGE:int = 6;
      
      protected static const SKILL_FIGHTCLUB:int = 10;
      
      protected static const NPC_SPEECH_TRAVEL:uint = 5;
      
      protected static const RISKINESS_DANGEROUS:int = 1;
      
      protected static const NUM_PVP_HELPERS_FOR_RISKINESS_DANGEROUS:uint = 5;
      
      protected static const PK_PARTYMODE:int = 2;
      
      protected static const RISKINESS_NONE:int = 0;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const GROUP_ATTACK:int = 1;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      protected static const TYPE_SUMMON_OTHERS:int = 4;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const SKILL_STAMINA:int = 17;
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const STATE_NONE:int = -1;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_GUILTY:int = 7;
      
      protected static const SKILL_FIGHTSHIELD:int = 8;
      
      protected static const SKILL_MANA_LEECH_CHANCE:int = 23;
      
      protected static const SKILL_FIGHTDISTANCE:int = 9;
      
      protected static const PK_EXCPLAYERKILLER:int = 5;
      
      public static const RUNES:Array = [new Rune(3152,GROUP_HEALING,GROUP_NONE,4,15,1,PROFESSION_MASK_ANY,0,1000,1000,0),new Rune(3160,GROUP_HEALING,GROUP_NONE,5,24,4,PROFESSION_MASK_ANY,0,1000,1000,0),new Rune(3174,GROUP_ATTACK,GROUP_NONE,7,15,0,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3198,GROUP_ATTACK,GROUP_NONE,7,25,3,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3177,GROUP_SUPPORT,GROUP_NONE,12,16,5,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3178,GROUP_SUPPORT,GROUP_NONE,14,27,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3189,GROUP_ATTACK,GROUP_NONE,15,27,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3191,GROUP_ATTACK,GROUP_NONE,16,30,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3192,GROUP_ATTACK,GROUP_NONE,17,27,5,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3200,GROUP_ATTACK,GROUP_NONE,18,31,6,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3155,GROUP_ATTACK,GROUP_NONE,21,45,15,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3188,GROUP_ATTACK,GROUP_NONE,25,15,1,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3172,GROUP_ATTACK,GROUP_NONE,26,14,0,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3164,GROUP_ATTACK,GROUP_NONE,27,18,3,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3190,GROUP_ATTACK,GROUP_NONE,28,33,6,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3148,GROUP_SUPPORT,GROUP_NONE,30,17,3,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3153,GROUP_HEALING,GROUP_NONE,31,15,0,PROFESSION_MASK_ANY,0,1000,1000,0),new Rune(3176,GROUP_ATTACK,GROUP_NONE,32,29,5,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3166,GROUP_ATTACK,GROUP_NONE,32,41,9,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3195,GROUP_ATTACK,GROUP_NONE,50,27,7,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3165,GROUP_ATTACK,GROUP_NONE,54,54,18,PROFESSION_MASK_ANY,1400,2000,2000,0),new Rune(3149,GROUP_ATTACK,GROUP_NONE,55,37,10,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3179,GROUP_ATTACK,GROUP_NONE,77,24,3,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3197,GROUP_SUPPORT,GROUP_NONE,78,21,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3203,GROUP_SUPPORT,GROUP_NONE,83,27,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3180,GROUP_ATTACK,GROUP_NONE,86,32,9,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3173,GROUP_ATTACK,GROUP_NONE,91,25,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3156,GROUP_ATTACK,GROUP_NONE,94,27,8,PROFESSION_MASK_DRUID,0,2000,2000,0),new Rune(3158,GROUP_ATTACK,GROUP_NONE,114,28,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3161,GROUP_ATTACK,GROUP_NONE,115,30,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3175,GROUP_ATTACK,GROUP_NONE,116,28,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3202,GROUP_ATTACK,GROUP_NONE,117,28,4,PROFESSION_MASK_ANY,0,2000,2000,0),new Rune(3182,GROUP_ATTACK,GROUP_NONE,130,27,4,PROFESSION_MASK_PALADIN,0,2000,2000,0),new Rune(17512,GROUP_ATTACK,GROUP_NONE,168,1,0,PROFESSION_MASK_NONE,0,2000,2000,0),new Rune(21352,GROUP_ATTACK,GROUP_NONE,179,1,0,PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER | PROFESSION_MASK_DRUID,0,2000,2000,0),new Rune(21351,GROUP_ATTACK,GROUP_NONE,180,1,0,PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER | PROFESSION_MASK_DRUID,0,2000,2000,0)].sortOn("ID",Array.NUMERIC);
      
      protected static const NUM_CREATURES:int = 1300;
      
      protected static const NUM_TRAPPERS:int = 8;
      
      protected static const SKILL_FED:int = 15;
      
      protected static const SKILL_MAGLEVEL:int = 2;
      
      protected static const SKILL_FISHING:int = 14;
      
      protected static const GROUP_POWERSTRIKES:int = 4;
      
      public static const SPELLS:Array = [new Spell(1,"Light Healing","exura",GROUP_HEALING,GROUP_NONE,new Point(160,0),0,TYPE_INSTANT,8,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER,20,0,1000,1000,0),new Spell(2,"Intense Healing","exura gran",GROUP_HEALING,GROUP_NONE,new Point(192,0),350,TYPE_INSTANT,20,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER,70,0,1000,1000,0),new Spell(3,"Ultimate Healing","exura vita",GROUP_HEALING,GROUP_NONE,new Point(0,0),1000,TYPE_INSTANT,30,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,160,0,1000,1000,0),new Spell(4,"Intense Healing Rune","adura gran",GROUP_SUPPORT,GROUP_NONE,new Point(32,192),600,TYPE_RUNE,15,false,PROFESSION_MASK_DRUID,120,2,2000,2000,0),new Spell(5,"Ultimate Healing Rune","adura vita",GROUP_SUPPORT,GROUP_NONE,new Point(32,160),1500,TYPE_RUNE,24,false,PROFESSION_MASK_DRUID,400,3,2000,2000,0),new Spell(6,"Haste","utani hur",GROUP_SUPPORT,GROUP_NONE,new Point(128,256),600,TYPE_INSTANT,14,true,PROFESSION_MASK_ANY,60,0,2000,2000,0),new Spell(7,"Light Magic Missile Rune","adori min vis",GROUP_SUPPORT,GROUP_NONE,new Point(0,192),500,TYPE_RUNE,15,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,120,1,2000,2000,0),new Spell(8,"Heavy Magic Missile Rune","adori vis",GROUP_SUPPORT,GROUP_NONE,new Point(128,192),1500,TYPE_RUNE,25,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,350,2,2000,2000,0),new Spell(9,"Summon Creature","utevo res {0:-creature}",GROUP_SUPPORT,GROUP_NONE,new Point(288,288),2000,TYPE_INSTANT,25,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,0,0,2000,2000,0),new Spell(10,"Light","utevo lux",GROUP_SUPPORT,GROUP_NONE,new Point(256,288),100,TYPE_INSTANT,8,false,PROFESSION_MASK_ANY,20,0,2000,2000,0),new Spell(11,"Great Light","utevo gran lux",GROUP_SUPPORT,GROUP_NONE,new Point(224,288),500,TYPE_INSTANT,13,false,PROFESSION_MASK_ANY,60,0,2000,2000,0),new Spell(12,"Convince Creature Rune","adeta sio",GROUP_SUPPORT,GROUP_NONE,new Point(160,224),800,TYPE_RUNE,16,false,PROFESSION_MASK_DRUID,200,3,2000,2000,0),new Spell(13,"Energy Wave","exevo vis hur",GROUP_ATTACK,GROUP_NONE,new Point(192,96),2500,TYPE_INSTANT,38,false,PROFESSION_MASK_SORCERER,170,0,8000,2000,0),new Spell(14,"Chameleon Rune","adevo ina",GROUP_SUPPORT,GROUP_NONE,new Point(192,224),1300,TYPE_RUNE,27,false,PROFESSION_MASK_DRUID,600,3,2000,2000,0),new Spell(15,"Fireball Rune","adori flam",GROUP_SUPPORT,GROUP_NONE,new Point(192,192),1600,TYPE_RUNE,27,true,PROFESSION_MASK_SORCERER,460,3,2000,2000,0),new Spell(16,"Great Fireball Rune","adori mas flam",GROUP_SUPPORT,GROUP_NONE,new Point(160,192),1200,TYPE_RUNE,30,false,PROFESSION_MASK_SORCERER,530,3,2000,2000,0),new Spell(17,"Fire Bomb Rune","adevo mas flam",GROUP_SUPPORT,GROUP_NONE,new Point(288,192),1500,TYPE_RUNE,27,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,600,4,2000,2000,0),new Spell(18,"Explosion Rune","adevo mas hur",GROUP_SUPPORT,GROUP_NONE,new Point(320,192),1800,TYPE_RUNE,31,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,570,4,2000,2000,0),new Spell(19,"Fire Wave","exevo flam hur",GROUP_ATTACK,GROUP_NONE,new Point(224,96),850,TYPE_INSTANT,18,false,PROFESSION_MASK_SORCERER,25,0,4000,2000,0),new Spell(20,"Find Person","exiva {0:-name}",GROUP_SUPPORT,GROUP_NONE,new Point(160,288),80,TYPE_INSTANT,8,false,PROFESSION_MASK_ANY,20,0,2000,2000,0),new Spell(21,"Sudden Death Rune","adori gran mort",GROUP_SUPPORT,GROUP_NONE,new Point(96,160),3000,TYPE_RUNE,45,false,PROFESSION_MASK_SORCERER,985,5,2000,2000,0),new Spell(22,"Energy Beam","exevo vis lux",GROUP_ATTACK,GROUP_NONE,new Point(128,96),1000,TYPE_INSTANT,23,false,PROFESSION_MASK_SORCERER,40,0,4000,2000,0),new Spell(23,"Great Energy Beam","exevo gran vis lux",GROUP_ATTACK,GROUP_NONE,new Point(160,96),1800,TYPE_INSTANT,29,false,PROFESSION_MASK_SORCERER,110,0,6000,2000,0),new Spell(24,"Hell\'s Core","exevo gran mas flam",GROUP_ATTACK,GROUP_NONE,new Point(0,128),8000,TYPE_INSTANT,60,true,PROFESSION_MASK_SORCERER,1100,0,40000,4000,0),new Spell(25,"Fire Field Rune","adevo grav flam",GROUP_SUPPORT,GROUP_NONE,new Point(256,192),500,TYPE_RUNE,15,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,240,1,2000,2000,0),new Spell(26,"Poison Field Rune","adevo grav pox",GROUP_SUPPORT,GROUP_NONE,new Point(256,160),300,TYPE_RUNE,14,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,200,1,2000,2000,0),new Spell(27,"Energy Field Rune","adevo grav vis",GROUP_SUPPORT,GROUP_NONE,new Point(0,224),700,TYPE_RUNE,18,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,320,2,2000,2000,0),new Spell(28,"Fire Wall Rune","adevo mas grav flam",GROUP_SUPPORT,GROUP_NONE,new Point(224,192),2000,TYPE_RUNE,33,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,780,4,2000,2000,0),new Spell(29,"Cure Poison","exana pox",GROUP_HEALING,GROUP_NONE,new Point(288,0),150,TYPE_INSTANT,10,false,PROFESSION_MASK_ANY,30,0,6000,1000,0),new Spell(30,"Destroy Field Rune","adito grav",GROUP_SUPPORT,GROUP_NONE,new Point(64,224),700,TYPE_RUNE,17,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER,120,2,2000,2000,0),new Spell(31,"Cure Poison Rune","adana pox",GROUP_SUPPORT,GROUP_NONE,new Point(128,224),600,TYPE_RUNE,15,false,PROFESSION_MASK_DRUID,200,1,2000,2000,0),new Spell(32,"Poison Wall Rune","adevo mas grav pox",GROUP_SUPPORT,GROUP_NONE,new Point(224,160),1600,TYPE_RUNE,29,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,640,3,2000,2000,0),new Spell(33,"Energy Wall Rune","adevo mas grav vis",GROUP_SUPPORT,GROUP_NONE,new Point(352,192),2500,TYPE_RUNE,41,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,1000,5,2000,2000,0),new Spell(36,"Salvation","exura gran san",GROUP_HEALING,GROUP_NONE,new Point(352,128),8000,TYPE_INSTANT,60,true,PROFESSION_MASK_PALADIN,210,0,1000,1000,0),new Spell(38,"Creature Illusion","utevo res ina {0:-creature}",GROUP_SUPPORT,GROUP_NONE,new Point(96,256),1000,TYPE_INSTANT,23,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,100,0,2000,2000,0),new Spell(39,"Strong Haste","utani gran hur",GROUP_SUPPORT,GROUP_NONE,new Point(160,256),1300,TYPE_INSTANT,20,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,100,0,2000,2000,0),new Spell(42,"Food","exevo pan",GROUP_SUPPORT,GROUP_NONE,new Point(64,256),300,TYPE_INSTANT,14,false,PROFESSION_MASK_DRUID,120,1,2000,2000,0),new Spell(43,"Strong Ice Wave","exevo gran frigo hur",GROUP_ATTACK,GROUP_NONE,new Point(288,96),7500,TYPE_INSTANT,40,true,PROFESSION_MASK_DRUID,170,0,8000,2000,0),new Spell(44,"Magic Shield","utamo vita",GROUP_SUPPORT,GROUP_NONE,new Point(96,320),450,TYPE_INSTANT,14,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,50,0,2000,2000,0),new Spell(45,"Invisible","utana vid",GROUP_SUPPORT,GROUP_NONE,new Point(288,224),2000,TYPE_INSTANT,35,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,440,0,2000,2000,0),new Spell(48,"Conjure Poisoned Arrow","exevo con pox",GROUP_SUPPORT,GROUP_NONE,new Point(64,288),700,TYPE_INSTANT,16,false,PROFESSION_MASK_PALADIN,130,2,2000,2000,0),new Spell(49,"Conjure Explosive Arrow","exevo con flam",GROUP_SUPPORT,GROUP_NONE,new Point(0,288),1000,TYPE_INSTANT,25,false,PROFESSION_MASK_PALADIN,290,3,2000,2000,0),new Spell(50,"Soulfire Rune","adevo res flam",GROUP_SUPPORT,GROUP_NONE,new Point(192,160),1800,TYPE_RUNE,27,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,420,3,2000,2000,0),new Spell(51,"Conjure Arrow","exevo con",GROUP_SUPPORT,GROUP_NONE,new Point(288,256),450,TYPE_INSTANT,13,false,PROFESSION_MASK_PALADIN,100,1,2000,2000,0),new Spell(54,"Paralyse Rune","adana ani",GROUP_SUPPORT,GROUP_NONE,new Point(320,160),1900,TYPE_RUNE,54,true,PROFESSION_MASK_DRUID,1400,3,2000,2000,0),new Spell(55,"Energy Bomb Rune","adevo mas vis",GROUP_SUPPORT,GROUP_NONE,new Point(32,224),2300,TYPE_RUNE,37,true,PROFESSION_MASK_SORCERER,880,5,2000,2000,0),new Spell(56,"Wrath of Nature","exevo gran mas tera",GROUP_ATTACK,GROUP_NONE,new Point(352,96),6000,TYPE_INSTANT,55,true,PROFESSION_MASK_DRUID,700,0,40000,4000,0),new Spell(57,"Strong Ethereal Spear","exori gran con",GROUP_ATTACK,GROUP_NONE,new Point(320,128),10000,TYPE_INSTANT,90,true,PROFESSION_MASK_PALADIN,55,0,8000,2000,0),new Spell(59,"Front Sweep","exori min",GROUP_ATTACK,GROUP_NONE,new Point(224,32),4000,TYPE_INSTANT,70,true,PROFESSION_MASK_KNIGHT,200,0,6000,2000,0),new Spell(61,"Brutal Strike","exori ico",GROUP_ATTACK,GROUP_NONE,new Point(320,32),1000,TYPE_INSTANT,16,true,PROFESSION_MASK_KNIGHT,30,0,6000,2000,0),new Spell(62,"Annihilation","exori gran ico",GROUP_ATTACK,GROUP_NONE,new Point(352,32),20000,TYPE_INSTANT,110,true,PROFESSION_MASK_KNIGHT,300,0,30000,4000,0),new Spell(75,"Ultimate Light","utevo vis lux",GROUP_SUPPORT,GROUP_NONE,new Point(192,288),1600,TYPE_INSTANT,26,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,140,0,2000,2000,0),new Spell(76,"Magic Rope","exani tera",GROUP_SUPPORT,GROUP_NONE,new Point(256,256),200,TYPE_INSTANT,9,true,PROFESSION_MASK_ANY,20,0,2000,2000,0),new Spell(77,"Stalagmite Rune","adori tera",GROUP_SUPPORT,GROUP_NONE,new Point(160,160),1400,TYPE_RUNE,24,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,350,2,2000,2000,0),new Spell(78,"Disintegrate Rune","adito tera",GROUP_SUPPORT,GROUP_NONE,new Point(96,224),900,TYPE_RUNE,21,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER,200,3,2000,2000,0),new Spell(79,"Conjure Bolt","exevo con mort",GROUP_SUPPORT,GROUP_NONE,new Point(320,256),750,TYPE_INSTANT,17,true,PROFESSION_MASK_PALADIN,140,2,2000,2000,0),new Spell(80,"Berserk","exori",GROUP_ATTACK,GROUP_NONE,new Point(256,32),2500,TYPE_INSTANT,35,true,PROFESSION_MASK_KNIGHT,115,0,4000,2000,0),new Spell(81,"Levitate","exani hur {0:-up|down}",GROUP_SUPPORT,GROUP_NONE,new Point(128,320),500,TYPE_INSTANT,12,true,PROFESSION_MASK_ANY,50,0,2000,2000,0),new Spell(82,"Mass Healing","exura gran mas res",GROUP_HEALING,GROUP_NONE,new Point(256,0),2200,TYPE_INSTANT,36,true,PROFESSION_MASK_DRUID,150,0,2000,1000,0),new Spell(83,"Animate Dead Rune","adana mort",GROUP_SUPPORT,GROUP_NONE,new Point(256,224),1200,TYPE_RUNE,27,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,600,5,2000,2000,0),new Spell(84,"Heal Friend","exura sio {0:-name}",GROUP_HEALING,GROUP_NONE,new Point(224,0),800,TYPE_INSTANT,18,true,PROFESSION_MASK_DRUID,140,0,1000,1000,0),new Spell(86,"Magic Wall Rune","adevo grav tera",GROUP_SUPPORT,GROUP_NONE,new Point(352,160),2100,TYPE_RUNE,32,true,PROFESSION_MASK_SORCERER,750,5,2000,2000,0),new Spell(87,"Death Strike","exori mort",GROUP_ATTACK,GROUP_NONE,new Point(32,96),800,TYPE_INSTANT,16,true,PROFESSION_MASK_SORCERER,20,0,2000,2000,0),new Spell(88,"Energy Strike","exori vis",GROUP_ATTACK,GROUP_NONE,new Point(128,64),800,TYPE_INSTANT,12,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,20,0,2000,2000,0),new Spell(89,"Flame Strike","exori flam",GROUP_ATTACK,GROUP_NONE,new Point(32,64),800,TYPE_INSTANT,14,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,20,0,2000,2000,0),new Spell(90,"Cancel Invisibility","exana ina",GROUP_SUPPORT,GROUP_NONE,new Point(320,224),1600,TYPE_INSTANT,26,true,PROFESSION_MASK_PALADIN,200,0,2000,2000,0),new Spell(91,"Poison Bomb Rune","adevo mas pox",GROUP_SUPPORT,GROUP_NONE,new Point(288,160),1000,TYPE_RUNE,25,true,PROFESSION_MASK_DRUID,520,2,2000,2000,0),new Spell(92,"Enchant Staff","exeta vis",GROUP_SUPPORT,GROUP_NONE,new Point(192,256),2000,TYPE_INSTANT,41,true,PROFESSION_MASK_SORCERER,80,0,2000,2000,0),new Spell(93,"Challenge","exeta res",GROUP_SUPPORT,GROUP_NONE,new Point(0,256),2000,TYPE_INSTANT,20,true,PROFESSION_MASK_KNIGHT,30,0,2000,2000,0),new Spell(94,"Wild Growth Rune","adevo grav vita",GROUP_SUPPORT,GROUP_NONE,new Point(0,160),2000,TYPE_RUNE,27,true,PROFESSION_MASK_DRUID,600,5,2000,2000,0),new Spell(95,"Conjure Power Bolt","exevo con vis",GROUP_SUPPORT,GROUP_NONE,new Point(352,256),2000,TYPE_INSTANT,59,true,PROFESSION_MASK_PALADIN,700,4,2000,2000,0),new Spell(105,"Fierce Berserk","exori gran",GROUP_ATTACK,GROUP_NONE,new Point(288,32),7500,TYPE_INSTANT,90,true,PROFESSION_MASK_KNIGHT,340,0,6000,2000,0),new Spell(106,"Groundshaker","exori mas",GROUP_ATTACK,GROUP_NONE,new Point(0,64),1500,TYPE_INSTANT,33,true,PROFESSION_MASK_KNIGHT,160,0,8000,2000,0),new Spell(107,"Whirlwind Throw","exori hur",GROUP_ATTACK,GROUP_NONE,new Point(192,32),1500,TYPE_INSTANT,28,true,PROFESSION_MASK_KNIGHT,40,0,6000,2000,0),new Spell(108,"Conjure Sniper Arrow","exevo con hur",GROUP_SUPPORT,GROUP_NONE,new Point(96,288),800,TYPE_INSTANT,24,true,PROFESSION_MASK_PALADIN,160,3,2000,2000,0),new Spell(109,"Conjure Piercing Bolt","exevo con grav",GROUP_SUPPORT,GROUP_NONE,new Point(32,288),850,TYPE_INSTANT,33,true,PROFESSION_MASK_PALADIN,180,3,2000,2000,0),new Spell(110,"Enchant Spear","exeta con",GROUP_SUPPORT,GROUP_NONE,new Point(224,256),2000,TYPE_INSTANT,45,true,PROFESSION_MASK_PALADIN,350,3,2000,2000,0),new Spell(111,"Ethereal Spear","exori con",GROUP_ATTACK,GROUP_NONE,new Point(160,32),1100,TYPE_INSTANT,23,true,PROFESSION_MASK_PALADIN,25,0,2000,2000,0),new Spell(112,"Ice Strike","exori frigo",GROUP_ATTACK,GROUP_NONE,new Point(224,64),800,TYPE_INSTANT,15,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,20,0,2000,2000,0),new Spell(113,"Terra Strike","exori tera",GROUP_ATTACK,GROUP_NONE,new Point(320,64),800,TYPE_INSTANT,13,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,20,0,2000,2000,0),new Spell(114,"Icicle Rune","adori frigo",GROUP_SUPPORT,GROUP_NONE,new Point(64,192),1700,TYPE_RUNE,28,true,PROFESSION_MASK_DRUID,460,3,2000,2000,0),new Spell(115,"Avalanche Rune","adori mas frigo",GROUP_SUPPORT,GROUP_NONE,new Point(224,224),1200,TYPE_RUNE,30,false,PROFESSION_MASK_DRUID,530,3,2000,2000,0),new Spell(116,"Stone Shower Rune","adori mas tera",GROUP_SUPPORT,GROUP_NONE,new Point(128,160),1100,TYPE_RUNE,28,true,PROFESSION_MASK_DRUID,430,3,2000,2000,0),new Spell(117,"Thunderstorm Rune","adori mas vis",GROUP_SUPPORT,GROUP_NONE,new Point(64,160),1100,TYPE_RUNE,28,true,PROFESSION_MASK_SORCERER,430,3,2000,2000,0),new Spell(118,"Eternal Winter","exevo gran mas frigo",GROUP_ATTACK,GROUP_NONE,new Point(32,128),8000,TYPE_INSTANT,60,true,PROFESSION_MASK_DRUID,1050,0,40000,4000,0),new Spell(119,"Rage of the Skies","exevo gran mas vis",GROUP_ATTACK,GROUP_NONE,new Point(96,128),6000,TYPE_INSTANT,55,true,PROFESSION_MASK_SORCERER,600,0,40000,4000,0),new Spell(120,"Terra Wave","exevo tera hur",GROUP_ATTACK,GROUP_NONE,new Point(320,96),2500,TYPE_INSTANT,38,false,PROFESSION_MASK_DRUID,210,0,4000,2000,0),new Spell(121,"Ice Wave","exevo frigo hur",GROUP_ATTACK,GROUP_NONE,new Point(256,96),850,TYPE_INSTANT,18,false,PROFESSION_MASK_DRUID,25,0,4000,2000,0),new Spell(122,"Divine Missile","exori san",GROUP_ATTACK,GROUP_NONE,new Point(64,96),1800,TYPE_INSTANT,40,true,PROFESSION_MASK_PALADIN,20,0,2000,2000,0),new Spell(123,"Wound Cleansing","exura ico",GROUP_HEALING,GROUP_NONE,new Point(64,0),0,TYPE_INSTANT,8,false,PROFESSION_MASK_KNIGHT,40,0,1000,1000,0),new Spell(124,"Divine Caldera","exevo mas san",GROUP_ATTACK,GROUP_NONE,new Point(96,96),3000,TYPE_INSTANT,50,true,PROFESSION_MASK_PALADIN,160,0,4000,2000,0),new Spell(125,"Divine Healing","exura san",GROUP_HEALING,GROUP_NONE,new Point(32,0),3000,TYPE_INSTANT,35,false,PROFESSION_MASK_PALADIN,160,0,1000,1000,0),new Spell(126,"Train Party","utito mas sio",GROUP_SUPPORT,GROUP_NONE,new Point(352,288),4000,TYPE_INSTANT,32,true,PROFESSION_MASK_KNIGHT,0,0,2000,2000,0),new Spell(127,"Protect Party","utamo mas sio",GROUP_SUPPORT,GROUP_NONE,new Point(64,320),4000,TYPE_INSTANT,32,true,PROFESSION_MASK_PALADIN,0,0,2000,2000,0),new Spell(128,"Heal Party","utura mas sio",GROUP_SUPPORT,GROUP_NONE,new Point(160,320),4000,TYPE_INSTANT,32,true,PROFESSION_MASK_DRUID,0,0,2000,2000,0),new Spell(129,"Enchant Party","utori mas sio",GROUP_SUPPORT,GROUP_NONE,new Point(128,288),4000,TYPE_INSTANT,32,true,PROFESSION_MASK_SORCERER,0,0,2000,2000,0),new Spell(130,"Holy Missile Rune","adori san",GROUP_SUPPORT,GROUP_NONE,new Point(96,192),1600,TYPE_RUNE,27,true,PROFESSION_MASK_PALADIN,300,3,2000,2000,0),new Spell(131,"Charge","utani tempo hur",GROUP_SUPPORT,GROUP_NONE,new Point(32,256),1300,TYPE_INSTANT,25,true,PROFESSION_MASK_KNIGHT,100,0,2000,2000,0),new Spell(132,"Protector","utamo tempo",GROUP_SUPPORT,GROUP_NONE,new Point(32,320),6000,TYPE_INSTANT,55,true,PROFESSION_MASK_KNIGHT,200,0,2000,2000,0),new Spell(133,"Blood Rage","utito tempo",GROUP_SUPPORT,GROUP_NONE,new Point(352,224),8000,TYPE_INSTANT,60,true,PROFESSION_MASK_KNIGHT,290,0,2000,2000,0),new Spell(134,"Swift Foot","utamo tempo san",GROUP_SUPPORT,GROUP_NONE,new Point(320,288),6000,TYPE_INSTANT,55,true,PROFESSION_MASK_PALADIN,400,0,2000,2000,0),new Spell(135,"Sharpshooter","utito tempo san",GROUP_SUPPORT,GROUP_NONE,new Point(0,320),8000,TYPE_INSTANT,60,true,PROFESSION_MASK_PALADIN,450,0,2000,2000,0),new Spell(138,"Ignite","utori flam",GROUP_ATTACK,GROUP_NONE,new Point(192,128),1500,TYPE_INSTANT,26,true,PROFESSION_MASK_SORCERER,30,0,30000,2000,0),new Spell(139,"Curse","utori mort",GROUP_ATTACK,GROUP_NONE,new Point(160,128),6000,TYPE_INSTANT,75,true,PROFESSION_MASK_SORCERER,30,0,50000,2000,0),new Spell(140,"Electrify","utori vis",GROUP_ATTACK,GROUP_NONE,new Point(224,128),2500,TYPE_INSTANT,34,true,PROFESSION_MASK_SORCERER,30,0,30000,2000,0),new Spell(141,"Inflict Wound","utori kor",GROUP_ATTACK,GROUP_NONE,new Point(256,128),2500,TYPE_INSTANT,40,true,PROFESSION_MASK_KNIGHT,30,0,30000,2000,0),new Spell(142,"Envenom","utori pox",GROUP_ATTACK,GROUP_NONE,new Point(288,128),6000,TYPE_INSTANT,50,true,PROFESSION_MASK_DRUID,30,0,40000,2000,0),new Spell(143,"Holy Flash","utori san",GROUP_ATTACK,GROUP_NONE,new Point(128,128),7500,TYPE_INSTANT,70,true,PROFESSION_MASK_PALADIN,30,0,40000,2000,0),new Spell(144,"Cure Bleeding","exana kor",GROUP_HEALING,GROUP_NONE,new Point(352,0),2500,TYPE_INSTANT,45,true,PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT,30,0,6000,1000,0),new Spell(145,"Cure Burning","exana flam",GROUP_HEALING,GROUP_NONE,new Point(0,32),2000,TYPE_INSTANT,30,true,PROFESSION_MASK_DRUID,30,0,6000,1000,0),new Spell(146,"Cure Electrification","exana vis",GROUP_HEALING,GROUP_NONE,new Point(32,32),1000,TYPE_INSTANT,22,true,PROFESSION_MASK_DRUID,30,0,6000,1000,0),new Spell(147,"Cure Curse","exana mort",GROUP_HEALING,GROUP_NONE,new Point(320,0),6000,TYPE_INSTANT,80,true,PROFESSION_MASK_PALADIN,40,0,6000,1000,0),new Spell(148,"Physical Strike","exori moe ico",GROUP_ATTACK,GROUP_NONE,new Point(128,32),800,TYPE_INSTANT,16,true,PROFESSION_MASK_DRUID,20,0,2000,2000,0),new Spell(149,"Lightning","exori amp vis",GROUP_ATTACK,GROUP_POWERSTRIKES,new Point(64,128),5000,TYPE_INSTANT,55,true,PROFESSION_MASK_SORCERER,60,0,8000,2000,8000),new Spell(150,"Strong Flame Strike","exori gran flam",GROUP_ATTACK,GROUP_POWERSTRIKES,new Point(64,64),6000,TYPE_INSTANT,70,true,PROFESSION_MASK_SORCERER,60,0,8000,2000,8000),new Spell(151,"Strong Energy Strike","exori gran vis",GROUP_ATTACK,GROUP_POWERSTRIKES,new Point(160,64),7500,TYPE_INSTANT,80,true,PROFESSION_MASK_SORCERER,60,0,8000,2000,8000),new Spell(152,"Strong Ice Strike","exori gran frigo",GROUP_ATTACK,GROUP_POWERSTRIKES,new Point(256,64),6000,TYPE_INSTANT,80,true,PROFESSION_MASK_DRUID,60,0,8000,2000,8000),new Spell(153,"Strong Terra Strike","exori gran tera",GROUP_ATTACK,GROUP_POWERSTRIKES,new Point(352,64),6000,TYPE_INSTANT,70,true,PROFESSION_MASK_DRUID,60,0,8000,2000,8000),new Spell(154,"Ultimate Flame Strike","exori max flam",GROUP_ATTACK,GROUP_NONE,new Point(96,64),15000,TYPE_INSTANT,90,true,PROFESSION_MASK_SORCERER,100,0,30000,4000,0),new Spell(155,"Ultimate Energy Strike","exori max vis",GROUP_ATTACK,GROUP_NONE,new Point(192,64),15000,TYPE_INSTANT,100,true,PROFESSION_MASK_SORCERER,100,0,30000,4000,0),new Spell(156,"Ultimate Ice Strike","exori max frigo",GROUP_ATTACK,GROUP_NONE,new Point(288,64),15000,TYPE_INSTANT,100,true,PROFESSION_MASK_DRUID,100,0,30000,4000,0),new Spell(157,"Ultimate Terra Strike","exori max tera",GROUP_ATTACK,GROUP_NONE,new Point(0,96),15000,TYPE_INSTANT,90,true,PROFESSION_MASK_DRUID,100,0,30000,4000,0),new Spell(158,"Intense Wound Cleansing","exura gran ico",GROUP_HEALING,GROUP_NONE,new Point(96,0),6000,TYPE_INSTANT,80,true,PROFESSION_MASK_KNIGHT,200,0,600000,1000,0),new Spell(159,"Recovery","utura",GROUP_HEALING,GROUP_NONE,new Point(64,32),4000,TYPE_INSTANT,50,true,PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN,75,0,60000,1000,0),new Spell(160,"Intense Recovery","utura gran",GROUP_HEALING,GROUP_NONE,new Point(96,32),10000,TYPE_INSTANT,100,true,PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN,165,0,60000,1000,0),new Spell(166,"Practise Healing","exura dis",GROUP_HEALING,GROUP_NONE,new Point(224,320),0,TYPE_INSTANT,1,false,PROFESSION_MASK_NONE,5,0,1000,1000,0),new Spell(167,"Practise Fire Wave","exevo dis flam hur",GROUP_ATTACK,GROUP_NONE,new Point(256,320),0,TYPE_INSTANT,1,false,PROFESSION_MASK_NONE,5,0,4000,2000,0),new Spell(168,"Practise Magic Missile Rune","adori dis min vis",GROUP_SUPPORT,GROUP_NONE,new Point(288,320),0,TYPE_RUNE,1,false,PROFESSION_MASK_NONE,5,0,2000,2000,0),new Spell(169,"Apprentice\'s Strike","exori min flam",GROUP_ATTACK,GROUP_NONE,new Point(192,320),0,TYPE_INSTANT,8,false,PROFESSION_MASK_DRUID | PROFESSION_MASK_SORCERER,6,0,2000,2000,0),new Spell(172,"Mud Attack","exori infir tera",GROUP_ATTACK,GROUP_NONE,new Point(128,352),0,TYPE_INSTANT,1,false,PROFESSION_MASK_DRUID,6,0,2000,2000,0),new Spell(173,"Chill Out","exevo infir frigo hur",GROUP_ATTACK,GROUP_NONE,new Point(96,352),0,TYPE_INSTANT,1,false,PROFESSION_MASK_DRUID,8,0,4000,2000,0),new Spell(174,"Magic Patch","exura infir",GROUP_HEALING,GROUP_NONE,new Point(32,352),0,TYPE_INSTANT,1,false,PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER | PROFESSION_MASK_DRUID,6,0,1000,1000,0),new Spell(175,"Bruise Bane","exura infir ico",GROUP_HEALING,GROUP_NONE,new Point(64,352),0,TYPE_INSTANT,1,false,PROFESSION_MASK_KNIGHT,10,0,1000,1000,0),new Spell(176,"Arrow Call","exevo infir con",GROUP_SUPPORT,GROUP_NONE,new Point(160,352),0,TYPE_INSTANT,1,false,PROFESSION_MASK_PALADIN,10,1,2000,2000,0),new Spell(177,"Buzz","exori infir vis",GROUP_ATTACK,GROUP_NONE,new Point(0,352),0,TYPE_INSTANT,1,false,PROFESSION_MASK_SORCERER,6,0,2000,2000,0),new Spell(178,"Scorch","exevo infir flam hur",GROUP_ATTACK,GROUP_NONE,new Point(352,320),0,TYPE_INSTANT,1,false,PROFESSION_MASK_SORCERER,8,0,4000,2000,0)].sortOn("ID",Array.NUMERIC);
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const PARTY_LEADER:int = 1;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      public static const MIN_SPELL_DELAY:int = 1000;
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:int = 9;
      
      protected static const GUILD_WAR_ALLY:int = 1;
      
      protected static const PK_NONE:int = 0;
      
      protected static const GROUP_HEALING:int = 2;
      
      protected static const PROFESSION_SORCERER:int = 3;
      
      protected static const STATE_SLOW:int = 5;
      
      protected static const PARTY_NONE:int = 0;
      
      protected static const SKILL_CRITICAL_HIT_CHANCE:int = 19;
      
      protected static const SUMMON_OWN:int = 1;
      
      protected static const GROUP_NONE:int = 0;
      
      protected static const TYPE_NONE:int = 0;
      
      protected static const TYPE_RUNE:int = 2;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const TYPE_SUMMON_OWN:int = 3;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_FIRE_OF_SUNS << 1;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
      protected static const STATE_FAST:int = 6;
      
      protected static const BLESSING_NONE:int = 0;
      
      protected static const GUILD_OTHER:int = 5;
      
      protected static const TYPE_PLAYER:int = 0;
      
      protected static const SKILL_HITPOINTS:int = 4;
      
      protected static const SKILL_OFFLINETRAINING:int = 18;
      
      protected static const STATE_MANA_SHIELD:int = 4;
      
      protected static const SKILL_MANA:int = 5;
      
      protected static const PROFESSION_MASK_PALADIN:int = 1 << PROFESSION_PALADIN;
      
      protected static const STATE_CURSED:int = 11;
      
      protected static const BLESSING_ADVENTURER:int = 1;
      
      protected static const STATE_FREEZING:int = 9;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      protected static const TYPE_MONSTER:int = 1;
      
      protected static const TYPE_INSTANT:int = 1;
      
      protected static const STATE_BURNING:int = 1;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
      protected static const GROUP_SUPPORT:int = 3;
      
      protected static const PK_AGGRESSOR:int = 3;
      
      protected static const GUILD_WAR_ENEMY:int = 2;
      
      protected static const SKILL_LEVEL:int = 1;
      
      protected static const STATE_STRENGTHENED:int = 12;
      
      protected static const STATE_HUNGRY:int = 31;
      
      protected static const PROFESSION_MASK_ANY:int = PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER;
      
      protected static const SUMMON_NONE:int = 0;
      
      protected static const PROFESSION_DRUID:int = 4;
      
      protected static const STATE_FIGHTING:int = 7;
      
      protected static const NPC_SPEECH_QUEST:uint = 3;
      
      protected static const NPC_SPEECH_NORMAL:uint = 1;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_ADVENTURER << 1;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
       
      
      protected var m_SpellGroupDelay:Vector.<SpellDelay>;
      
      protected var m_SpellDelay:Vector.<SpellDelay>;
      
      public function SpellStorage()
      {
         this.m_SpellDelay = new Vector.<SpellDelay>();
         this.m_SpellGroupDelay = new Vector.<SpellDelay>();
         super();
      }
      
      public static function checkRune(param1:int) : Boolean
      {
         return getRune(param1) != null;
      }
      
      public static function checkSpell(param1:int) : Boolean
      {
         return getSpell(param1) != null;
      }
      
      public static function getSpell(param1:int) : Spell
      {
         var _loc5_:Spell = null;
         var _loc2_:int = 0;
         var _loc3_:int = SPELLS.length - 1;
         var _loc4_:int = 0;
         while(_loc2_ <= _loc3_)
         {
            _loc4_ = _loc2_ + _loc3_ >>> 1;
            _loc5_ = SPELLS[_loc4_];
            if(_loc5_.ID < param1)
            {
               _loc2_ = _loc4_ + 1;
               continue;
            }
            if(_loc5_.ID > param1)
            {
               _loc3_ = _loc4_ - 1;
               continue;
            }
            return _loc5_;
         }
         return null;
      }
      
      public static function getRune(param1:int) : Rune
      {
         var _loc5_:Rune = null;
         var _loc2_:int = 0;
         var _loc3_:int = RUNES.length - 1;
         var _loc4_:int = 0;
         while(_loc2_ <= _loc3_)
         {
            _loc4_ = _loc2_ + _loc3_ >>> 1;
            _loc5_ = RUNES[_loc4_];
            if(_loc5_.ID < param1)
            {
               _loc2_ = _loc4_ + 1;
               continue;
            }
            if(_loc5_.ID > param1)
            {
               _loc3_ = _loc4_ - 1;
               continue;
            }
            return _loc5_;
         }
         return null;
      }
      
      private function setDelay(param1:Vector.<SpellDelay>, param2:int, param3:Number, param4:Number) : Object
      {
         var _loc5_:int = 0;
         var _loc6_:int = param1.length - 1;
         var _loc7_:int = 0;
         var _loc8_:SpellDelay = null;
         while(_loc5_ <= _loc6_)
         {
            _loc7_ = _loc5_ + _loc6_ >>> 1;
            _loc8_ = param1[_loc7_];
            if(_loc8_.ID < param2)
            {
               _loc5_ = _loc7_ + 1;
               continue;
            }
            if(_loc8_.ID > param2)
            {
               _loc6_ = _loc7_ - 1;
               continue;
            }
            break;
         }
         if(_loc8_ == null || _loc8_.ID != param2)
         {
            _loc8_ = new SpellDelay(param2,0,0);
            param1.splice(_loc5_,0,_loc8_);
         }
         _loc8_.start = param3;
         _loc8_.end = param3 + param4;
         return _loc8_;
      }
      
      public function setSpellGroupDelay(param1:int, param2:Number) : void
      {
         this.setDelay(this.m_SpellGroupDelay,param1,Tibia.s_FrameTibiaTimestamp,param2);
      }
      
      private function getDelay(param1:Vector.<SpellDelay>, param2:int) : SpellDelay
      {
         var _loc3_:int = 0;
         var _loc4_:int = param1.length - 1;
         var _loc5_:int = 0;
         var _loc6_:SpellDelay = null;
         while(_loc3_ <= _loc4_)
         {
            _loc5_ = _loc3_ + _loc4_ >>> 1;
            _loc6_ = param1[_loc5_];
            if(_loc6_.ID < param2)
            {
               _loc3_ = _loc5_ + 1;
               continue;
            }
            if(_loc6_.ID > param2)
            {
               _loc4_ = _loc5_ - 1;
               continue;
            }
            return _loc6_;
         }
         return null;
      }
      
      public function reset() : void
      {
         this.m_SpellDelay.length = 0;
         this.m_SpellGroupDelay.length = 0;
      }
      
      public function getSpellDelay(param1:int) : Delay
      {
         var _loc3_:Delay = null;
         var _loc2_:Spell = getSpell(param1);
         if(_loc2_ != null)
         {
            _loc3_ = this.getDelay(this.m_SpellDelay,_loc2_.ID);
            _loc3_ = Delay.merge(_loc3_,this.getDelay(this.m_SpellGroupDelay,_loc2_.groupPrimary));
            _loc3_ = Delay.merge(_loc3_,this.getDelay(this.m_SpellGroupDelay,_loc2_.groupSecondary));
            return _loc3_;
         }
         return null;
      }
      
      public function getRuneDelay(param1:int) : Delay
      {
         var _loc3_:Delay = null;
         var _loc2_:Rune = getRune(param1);
         if(_loc2_ != null)
         {
            _loc3_ = Delay.merge(this.getDelay(this.m_SpellGroupDelay,_loc2_.groupPrimary),this.getDelay(this.m_SpellGroupDelay,_loc2_.groupSecondary));
            return _loc3_;
         }
         return null;
      }
      
      public function getSpellGroupDelay(param1:int) : Delay
      {
         var _loc2_:Delay = this.getDelay(this.m_SpellGroupDelay,param1);
         if(_loc2_ != null)
         {
            return _loc2_.clone();
         }
         return null;
      }
      
      public function setSpellDelay(param1:int, param2:Number) : void
      {
         this.setDelay(this.m_SpellDelay,param1,Tibia.s_FrameTibiaTimestamp,param2);
      }
   }
}

import tibia.game.Delay;

class SpellDelay extends Delay
{
    
   
   public var ID:int = 0;
   
   function SpellDelay(param1:int, param2:Number, param3:Number)
   {
      super(param2,param3);
      this.ID = param1;
   }
   
   override public function clone() : Delay
   {
      return new SpellDelay(this.ID,start,end);
   }
}
