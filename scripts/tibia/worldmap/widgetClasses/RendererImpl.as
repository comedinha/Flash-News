package tibia.worldmap.widgetClasses
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.GraphicsPathCommand;
   import flash.display3D.Context3DRenderMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import shared.stage3D.Camera2D;
   import shared.stage3D.Tibia3D;
   import shared.utility.Colour;
   import shared.utility.IPerformanceCounter;
   import shared.utility.SlidingWindowPerformanceCounter;
   import shared.utility.TextFieldCache;
   import shared.utility.Vector3D;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.FrameGroup;
   import tibia.appearances.Marks;
   import tibia.appearances.MissileInstance;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.TextualEffectInstance;
   import tibia.appearances.widgetClasses.MarksView;
   import tibia.creatures.Creature;
   import tibia.creatures.CreatureStorage;
   import tibia.creatures.Player;
   import tibia.options.OptionsStorage;
   import tibia.worldmap.Field;
   import tibia.worldmap.OnscreenMessageBox;
   import tibia.worldmap.WorldMapStorage;
   
   public class RendererImpl extends UIComponent
   {
      
      protected static const PATH_MATRIX_CENTER:int = PATH_MAX_DISTANCE;
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      private static const TILE_CURSOR:BitmapData = Bitmap(new TILE_CURSOR_CLASS()).bitmapData;
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const HUD_ARC_ORIENTATION_LEFT:int = 0;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      protected static const PK_REVENGE:int = 6;
      
      protected static const SKILL_FIGHTCLUB:int = 10;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const RISKINESS_DANGEROUS:int = 1;
      
      protected static const NUM_PVP_HELPERS_FOR_RISKINESS_DANGEROUS:uint = 5;
      
      protected static const NPC_SPEECH_TRAVEL:uint = 5;
      
      private static const OBJECT_CURSOR_COLOR:uint = 16769335;
      
      public static const COLOUR_ABOVE_GROUND:Colour = new Colour(200,200,255);
      
      protected static const PATH_COST_OBSTACLE:int = 255;
      
      protected static const RISKINESS_NONE:int = 0;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      private static var CREATURE_FLAGS_BITMAP_CACHE_SIZE:uint = 100;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      protected static const PK_PARTYMODE:int = 2;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const SKILL_STAMINA:int = 17;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const PATH_NORTH:int = 3;
      
      protected static const SKILL_MANA_LEECH_CHANCE:int = 23;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_GUILTY:int = 7;
      
      protected static const STATE_NONE:int = -1;
      
      protected static const SKILL_FIGHTDISTANCE:int = 9;
      
      public static const STATUS_STYLE_CLASSIC:int = 1;
      
      protected static const SKILL_FIGHTSHIELD:int = 8;
      
      protected static const NUM_CREATURES:int = 1300;
      
      protected static const NUM_TRAPPERS:int = 8;
      
      protected static const SKILL_FED:int = 15;
      
      protected static const SKILL_MAGLEVEL:int = 2;
      
      protected static const SKILL_FISHING:int = 14;
      
      protected static const PK_EXCPLAYERKILLER:int = 5;
      
      protected static const PATH_MAX_DISTANCE:int = 110;
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const HUD_ARC_ORIENTATION_RIGHT:int = 1;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      private static const s_TempMouseMoveEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_MOVE);
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const PATH_ERROR_INTERNAL:int = -5;
      
      protected static const PATH_EMPTY:int = 0;
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PATH_COST_UNDEFINED:int = 254;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      protected static const BLESSING_BLOOD_OF_THE_MOUNTAIN:int = BLESSING_HEART_OF_THE_MOUNTAIN << 1;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const HUD_ARC_STYLE_HORIZONTAL:int = 1;
      
      protected static const PARTY_LEADER:int = 1;
      
      protected static const PATH_MATRIX_SIZE:int = 2 * PATH_MAX_DISTANCE + 1;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const PATH_ERROR_GO_UPSTAIRS:int = -2;
      
      protected static const PATH_COST_MAX:int = 250;
      
      private static var s_CreatureMarksView:MarksView = null;
      
      protected static const PATH_MAX_STEPS:int = 128;
      
      protected static const HUD_ARC_STYLE_POINTY:int = 0;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      private static const HIGHLIGHT_MAX_OPACITY:Number = 0.8;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const HUD_ARC_TOTAL_WIDTH:Number = 10;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const BLESSING_HEART_OF_THE_MOUNTAIN:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      protected static const HUD_ARC_LOWER_LIMIT:Number = 45;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:int = 9;
      
      protected static const GUILD_WAR_ALLY:int = 1;
      
      protected static const PK_NONE:int = 0;
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const PROFESSION_SORCERER:int = 3;
      
      protected static const COUNTER_WINDOW_SIZE:int = 50;
      
      protected static const STATE_SLOW:int = 5;
      
      protected static const PARTY_NONE:int = 0;
      
      protected static const PATH_SOUTH:int = 7;
      
      protected static const SUMMON_OWN:int = 1;
      
      protected static const SKILL_CRITICAL_HIT_CHANCE:int = 19;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      public static const COLOUR_BELOW_GROUND:Colour = new Colour(255,255,255);
      
      protected static const PATH_NORTH_WEST:int = 4;
      
      private static const TILE_CURSOR_CLASS:Class = RendererImpl_TILE_CURSOR_CLASS;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      public static const STATUS_STYLE_HUD:int = 2;
      
      protected static const SKILL_EXPERIENCE_GAIN:int = -2;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const ONSCREEN_MESSAGE_GAP:Number = 10;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_TWIST_OF_FATE << 1;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const PATH_ERROR_UNREACHABLE:int = -4;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const HUD_ARC_BORDER_WIDTH:Number = 1;
      
      protected static const PATH_SOUTH_WEST:int = 6;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const STATE_FAST:int = 6;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
      protected static const PATH_NORTH_EAST:int = 2;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const PATH_ERROR_TOO_FAR:int = -3;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_ADVENTURER << 1;
      
      protected static const BLESSING_NONE:int = 0;
      
      protected static const GUILD_OTHER:int = 5;
      
      protected static const TYPE_PLAYER:int = 0;
      
      protected static const SKILL_HITPOINTS:int = 4;
      
      protected static const PATH_WEST:int = 5;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const SKILL_OFFLINETRAINING:int = 18;
      
      protected static const SKILL_MANA:int = 5;
      
      protected static const HUD_ARC_ALPHA:Number = 0.75;
      
      protected static const STATE_MANA_SHIELD:int = 4;
      
      public static const STATUS_STYLE_OFF:int = 0;
      
      protected static const BLESSING_ADVENTURER:int = 1;
      
      protected static const STATE_FREEZING:int = 9;
      
      protected static const STATE_CURSED:int = 11;
      
      protected static const PATH_SOUTH_EAST:int = 8;
      
      protected static const PROFESSION_MASK_PALADIN:int = 1 << PROFESSION_PALADIN;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const PATH_EXISTS:int = 1;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      protected static const TYPE_MONSTER:int = 1;
      
      protected static const HUD_ARC_RADIUS:Number = 75;
      
      protected static const HUD_ARC_UPPER_LIMIT:Number = -45;
      
      private static const HIGHLIGHT_MIN_OPACITY:Number = 0.5;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const STATE_BURNING:int = 1;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
      protected static const PK_AGGRESSOR:int = 3;
      
      protected static const GUILD_WAR_ENEMY:int = 2;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const STATE_HUNGRY:int = 31;
      
      protected static const PROFESSION_MASK_ANY:int = PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER;
      
      protected static const SKILL_LEVEL:int = 1;
      
      protected static const PATH_EAST:int = 1;
      
      protected static const PROFESSION_DRUID:int = 4;
      
      protected static const STATE_FIGHTING:int = 7;
      
      protected static const SUMMON_NONE:int = 0;
      
      protected static const STATE_STRENGTHENED:int = 12;
      
      protected static const TYPE_PLAYERSUMMON:int = 3;
      
      protected static const HUD_ARC_STYLE_RADIAL:int = 2;
      
      protected static const NPC_SPEECH_QUEST:uint = 3;
      
      protected static const NPC_SPEECH_NORMAL:uint = 1;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_FIRE_OF_SUNS << 1;
      
      protected static const PATH_ERROR_GO_DOWNSTAIRS:int = -1;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      {
         s_InitialiseMarksViews(true);
      }
      
      protected var m_ClipRect:Rectangle = null;
      
      protected var m_Transform:Matrix = null;
      
      protected var m_LightTranslate:Matrix = null;
      
      protected var m_HangPatternX:int = 0;
      
      protected var m_HangPatternY:int = 0;
      
      protected var m_HangPatternZ:int = 0;
      
      protected var m_Player:Player = null;
      
      private var m_StopwatchShowFrame:IPerformanceCounter;
      
      private var m_HighlightTile:Vector3D = null;
      
      protected var m_LightClipRect:Rectangle = null;
      
      private const m_TempManaColour:Colour = new Colour(0,0,0);
      
      protected var m_MaxZPlane:int = 0;
      
      private var m_OptionsLightEnabled:Boolean = false;
      
      private var m_ObjectCursor:ObjectCursor = null;
      
      private var m_HighlightObject = null;
      
      protected var m_HUDArcScale:Number = NaN;
      
      private var m_HelperCreatureFlagsBitmapData:BitmapData = null;
      
      protected var m_CreatureStorage:CreatureStorage = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_HUDArcPoints:Vector.<Number> = null;
      
      protected var m_AtmosphereLayer:BitmapData = null;
      
      private var m_CursorOverRenderer:Boolean = false;
      
      private var m_UncommittedWorldMapStorage:Boolean = false;
      
      private var m_OptionsHighlight:Number = NaN;
      
      private var m_StopwatchEnterFrame:IPerformanceCounter;
      
      private const m_TempColor:Colour = new Colour(0,0,0);
      
      private const m_TempCreatureColor:Colour = new Colour(0,0,0);
      
      protected var m_HelperCoordinate:Vector3D = null;
      
      protected var m_MinZPlane:Vector.<int> = null;
      
      private var m_OptionsScaleMap:Boolean = true;
      
      protected var m_DrawnTextualEffectsCount:int = 0;
      
      protected var m_CreatureField:Vector.<Vector.<RenderAtom>> = null;
      
      protected var m_TiledLightmapRenderer:TiledLightmapRenderer = null;
      
      protected var m_HelperPoint:Point = null;
      
      private var m_CreatureFlagsBitmapCache:Dictionary = null;
      
      protected var m_CreatureCount:Vector.<int> = null;
      
      private var m_OptionsFrameRate:Number = NaN;
      
      protected var m_HelperPoint2:Point = null;
      
      protected var m_HUDArcStyle:int = 2;
      
      private var m_OptionsLevelSeparator:Number = NaN;
      
      protected var m_MainLayer:BitmapData = null;
      
      protected var m_HelperTrans:Matrix = null;
      
      protected var m_Tibia3D:Tibia3D = null;
      
      protected var m_DrawnCreaturesCount:int = 0;
      
      protected var m_PreviousHang:ObjectInstance = null;
      
      protected var m_DrawnCreatures:Vector.<RenderAtom> = null;
      
      private var m_OptionsAmbientBrightness:Number = NaN;
      
      private var m_WorldMapStorage:WorldMapStorage = null;
      
      private var m_OptionsAntialiasing:Boolean = false;
      
      protected var m_CreatureNameCache:TextFieldCache = null;
      
      protected var m_DrawnTextualEffects:Vector.<RenderAtom> = null;
      
      protected var m_HelperRect2:Rectangle = null;
      
      protected var m_HangPixelX:int = 0;
      
      protected var m_HangPixelY:int = 0;
      
      private var m_Options:OptionsStorage = null;
      
      private var m_TileCursor:TileCursor = null;
      
      protected var m_HelperRect:Rectangle = null;
      
      private const m_TempEffectColor:Colour = new Colour(0,0,0);
      
      private const m_TempHealthColour:Colour = new Colour(0,0,0);
      
      protected var m_PlayerZPlane:int = 0;
      
      protected var m_Rectangle:Rectangle = null;
      
      private const m_TempObjectColor:Colour = new Colour(0,0,0);
      
      public function RendererImpl()
      {
         this.m_StopwatchEnterFrame = new SlidingWindowPerformanceCounter(COUNTER_WINDOW_SIZE);
         this.m_StopwatchShowFrame = new SlidingWindowPerformanceCounter(COUNTER_WINDOW_SIZE);
         super();
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.m_MaxZPlane = MAPSIZE_Z - 1;
         this.m_MinZPlane = new Vector.<int>(MAPSIZE_X * MAPSIZE_Y);
         this.m_Rectangle = new Rectangle(0,0,MAPSIZE_X * FIELD_SIZE,MAPSIZE_Y * FIELD_SIZE);
         this.m_MainLayer = new BitmapData(this.m_Rectangle.width,this.m_Rectangle.height,true,0);
         this.m_AtmosphereLayer = new BitmapData(this.m_Rectangle.width,this.m_Rectangle.height,true,0);
         this.m_MainLayer.lock();
         this.m_AtmosphereLayer.lock();
         this.m_ClipRect = new Rectangle(0,0,MAP_WIDTH * FIELD_SIZE,MAP_HEIGHT * FIELD_SIZE);
         this.m_Transform = new Matrix();
         var _loc3_:int = MAPSIZE_X * MAPSIZE_Y;
         this.m_CreatureField = new Vector.<Vector.<RenderAtom>>(_loc3_,true);
         this.m_CreatureCount = new Vector.<int>(_loc3_,true);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this.m_CreatureField[_loc1_] = new Vector.<RenderAtom>(MAPSIZE_W,true);
            _loc2_ = 0;
            while(_loc2_ < MAPSIZE_W)
            {
               this.m_CreatureField[_loc1_][_loc2_] = new RenderAtom();
               _loc2_++;
            }
            this.m_CreatureCount[_loc1_] = 0;
            _loc1_++;
         }
         this.m_DrawnCreatures = new Vector.<RenderAtom>(_loc3_ * MAPSIZE_W,true);
         _loc1_ = 0;
         while(_loc1_ < _loc3_ * MAPSIZE_W)
         {
            this.m_DrawnCreatures[_loc1_] = new RenderAtom();
            _loc1_++;
         }
         this.m_DrawnCreaturesCount = 0;
         this.m_CreatureNameCache = new TextFieldCache(300,TextFieldCache.DEFAULT_HEIGHT,MAPSIZE_X * MAPSIZE_Y * 3,false);
         this.m_DrawnTextualEffects = new Vector.<RenderAtom>(NUM_EFFECTS);
         _loc1_ = 0;
         while(_loc1_ < this.m_DrawnTextualEffects.length)
         {
            this.m_DrawnTextualEffects[_loc1_] = new RenderAtom();
            _loc1_++;
         }
         this.m_ObjectCursor = ObjectCursor.createFromColor(OBJECT_CURSOR_COLOR,HIGHLIGHT_MIN_OPACITY,HIGHLIGHT_MAX_OPACITY,8,3 * FIELD_SIZE,100);
         this.m_TileCursor = new TileCursor();
         this.m_TileCursor.bitmapData = TILE_CURSOR;
         this.m_TileCursor.frameDuration = 100;
         this.m_HelperCoordinate = new Vector3D();
         this.m_HelperPoint = new Point();
         this.m_HelperPoint2 = new Point();
         this.m_HelperTrans = new Matrix();
         this.m_HelperRect = new Rectangle();
         this.m_HelperRect2 = new Rectangle();
         this.m_HelperCreatureFlagsBitmapData = new BitmapData(3 * CreatureStorage.STATE_FLAG_SIZE + 2 * CreatureStorage.STATE_FLAG_GAP,3 * CreatureStorage.STATE_FLAG_SIZE + 2 * CreatureStorage.STATE_FLAG_GAP);
         this.m_CreatureFlagsBitmapCache = new Dictionary();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private static function s_InitialiseMarksViews(param1:Boolean) : void
      {
         s_CreatureMarksView = new MarksView(0);
         s_CreatureMarksView.addMarkToView(Marks.MARK_TYPE_CLIENT_MAPWINDOW,MarksView.MARK_THICKNESS_BOLD);
         if(param1)
         {
            s_CreatureMarksView.addMarkToView(Marks.MARK_TYPE_PERMANENT,MarksView.MARK_THICKNESS_BOLD);
         }
         s_CreatureMarksView.addMarkToView(Marks.MARK_TYPE_ONE_SECOND_TEMP,MarksView.MARK_THICKNESS_BOLD);
      }
      
      private function drawField(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:Boolean) : void
      {
         var _loc10_:Field = null;
         var _loc12_:int = 0;
         var _loc31_:int = 0;
         _loc10_ = this.m_WorldMapStorage.getField(param6,param7,param8);
         var _loc11_:int = _loc10_.m_ObjectsCount;
         _loc12_ = param7 * MAPSIZE_X + param6;
         var _loc13_:Boolean = param8 >= this.m_MinZPlane[_loc12_] || (param6 == 0 || param8 >= this.m_MinZPlane[_loc12_ - 1]) || (param7 == 0 || param8 >= this.m_MinZPlane[_loc12_ - MAPSIZE_X]) || (param6 == 0 && param7 == 0 || param8 >= this.m_MinZPlane[_loc12_ - MAPSIZE_X - 1]);
         var _loc14_:ObjectInstance = null;
         var _loc15_:ObjectInstance = null;
         var _loc16_:Boolean = false;
         var _loc17_:int = 0;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         var _loc20_:Number = 0;
         var _loc21_:Number = 0;
         if(param9 && _loc11_ > 0 && _loc13_)
         {
            if(_loc10_.m_CacheObjectsCount > 0)
            {
               this.m_HelperPoint.x = param1 - FIELD_CACHESIZE;
               this.m_HelperPoint.y = param2 - FIELD_CACHESIZE;
               this.m_MainLayer.copyPixels(Field.s_CacheBitmap,_loc10_.m_CacheRectangle,this.m_HelperPoint,null,null,true);
               _loc17_ = _loc10_.m_CacheObjectsHeight;
            }
            _loc12_ = _loc10_.m_CacheObjectsCount;
            while(_loc12_ < _loc11_)
            {
               if((_loc14_ = _loc10_.m_ObjectsRenderer[_loc12_]) == null || _loc14_.m_ID == AppearanceInstance.CREATURE || _loc14_.m_Type.isTop)
               {
                  break;
               }
               if(this.m_OptionsLightEnabled && _loc14_.m_Type.isLight)
               {
                  _loc20_ = (param1 - _loc17_ - _loc14_.m_Type.displacementX) / FIELD_SIZE;
                  _loc21_ = (param2 - _loc17_ - _loc14_.m_Type.displacementY) / FIELD_SIZE;
                  this.m_TempObjectColor.eightBit = _loc14_.m_Type.lightColour;
                  this.m_TiledLightmapRenderer.setLightSource(_loc20_,_loc21_,param8,_loc14_.m_Type.brightness,this.m_TempObjectColor);
               }
               _loc14_.drawTo(this.m_MainLayer,param1 - _loc17_,param2 - _loc17_,param3,param4,param5);
               if(_loc14_ == this.m_HighlightObject)
               {
                  this.m_ObjectCursor.drawTo(this.m_MainLayer,param1 - _loc17_,param2 - _loc17_,Tibia.s_FrameTibiaTimestamp);
               }
               _loc16_ = _loc16_ || _loc14_.m_Type.isLyingObject;
               if(_loc14_.m_Type.isHangable && _loc14_.hang == AppearanceStorage.FLAG_HOOKSOUTH)
               {
                  _loc15_ = _loc14_;
               }
               _loc17_ = _loc17_ + _loc14_.m_Type.elevation;
               if(_loc17_ > FIELD_HEIGHT)
               {
                  _loc17_ = FIELD_HEIGHT;
               }
               _loc12_++;
            }
            if(_loc16_ || _loc10_.m_CacheLyingObject)
            {
               if(param6 > 0 && param7 > 0)
               {
                  this.drawField(param1 - FIELD_SIZE,param2 - FIELD_SIZE,param3 - 1,param4 - 1,param5,param6 - 1,param7 - 1,param8,false);
               }
               if(param6 > 0)
               {
                  this.drawField(param1 - FIELD_SIZE,param2,param3 - 1,param4,param5,param6 - 1,param7,param8,false);
               }
               if(param7 > 0)
               {
                  this.drawField(param1,param2 - FIELD_SIZE,param3,param4 - 1,param5,param6,param7 - 1,param8,false);
               }
            }
            if(this.m_PreviousHang != null)
            {
               this.m_PreviousHang.drawTo(this.m_MainLayer,this.m_HangPixelX,this.m_HangPixelY,this.m_HangPatternX,this.m_HangPatternY,this.m_HangPatternZ);
               if(this.m_PreviousHang == this.m_HighlightObject)
               {
                  this.m_ObjectCursor.drawTo(this.m_MainLayer,this.m_HangPixelX,this.m_HangPixelY,Tibia.s_FrameTibiaTimestamp);
               }
               this.m_PreviousHang = null;
            }
            if(_loc15_ != null)
            {
               this.m_PreviousHang = _loc15_;
               this.m_HangPixelX = param1;
               this.m_HangPixelY = param2;
               this.m_HangPatternX = param3;
               this.m_HangPatternY = param4;
               this.m_HangPatternZ = param5;
            }
         }
         var _loc22_:RenderAtom = null;
         var _loc23_:Vector.<RenderAtom> = this.m_CreatureField[param7 * MAPSIZE_X + param6];
         var _loc24_:int = this.m_CreatureCount[param7 * MAPSIZE_X + param6];
         var _loc25_:BitmapData = null;
         var _loc26_:Creature = null;
         _loc12_ = 0;
         while(_loc12_ < _loc24_)
         {
            if(!((_loc22_ = _loc23_[_loc12_]) == null || (_loc26_ = _loc23_[_loc12_].object as Creature) == null || _loc26_.outfit == null))
            {
               if(param9)
               {
                  _loc22_.x = _loc22_.x - _loc17_;
                  _loc22_.y = _loc22_.y - _loc17_;
               }
               this.m_HelperPoint.x = _loc22_.x - FIELD_SIZE;
               this.m_HelperPoint.y = _loc22_.y - FIELD_SIZE;
               _loc25_ = s_CreatureMarksView.getMarksBitmap(_loc26_.marks,this.m_HelperRect);
               this.m_MainLayer.copyPixels(_loc25_,this.m_HelperRect,this.m_HelperPoint,null,null,true);
               _loc18_ = 0;
               _loc19_ = 0;
               if(_loc13_ && _loc26_.mountOutfit != null)
               {
                  _loc18_ = _loc26_.mountOutfit.m_Type.displacementX;
                  _loc19_ = _loc26_.mountOutfit.m_Type.displacementY;
                  _loc26_.mountOutfit.drawTo(this.m_MainLayer,_loc22_.x + _loc18_,_loc22_.y + _loc19_,_loc26_.direction,0,0);
               }
               if(_loc13_)
               {
                  _loc18_ = _loc18_ + _loc26_.outfit.m_Type.displacementX;
                  _loc19_ = _loc19_ + _loc26_.outfit.m_Type.displacementY;
                  _loc26_.outfit.drawTo(this.m_MainLayer,_loc22_.x + _loc18_,_loc22_.y + _loc19_,_loc26_.direction,0,_loc26_.mountOutfit != null?1:0);
               }
               if(_loc13_ && this.m_HighlightObject != null && (this.m_HighlightObject is ObjectInstance && _loc26_.ID == ObjectInstance(this.m_HighlightObject).data || this.m_HighlightObject is Creature && _loc26_ == this.m_HighlightObject))
               {
                  this.m_ObjectCursor.drawTo(this.m_MainLayer,_loc22_.x + _loc18_,_loc22_.y + _loc19_,Tibia.s_FrameTibiaTimestamp);
               }
               if(param8 == this.m_PlayerZPlane && (this.m_CreatureStorage.isOpponent(_loc26_) || _loc26_.ID == this.m_Player.ID))
               {
                  this.m_DrawnCreatures[this.m_DrawnCreaturesCount].assign(_loc22_);
                  this.m_DrawnCreaturesCount++;
               }
               if(_loc13_ && param9 && this.m_OptionsLightEnabled)
               {
                  _loc20_ = _loc22_.x / FIELD_SIZE;
                  _loc21_ = _loc22_.y / FIELD_SIZE;
                  this.m_TiledLightmapRenderer.setLightSource(_loc20_,_loc21_,param8,_loc26_.brightness,_loc26_.lightColour);
                  if(_loc26_.mountOutfit != null && _loc26_.mountOutfit.m_Type.isLight)
                  {
                     this.m_TempCreatureColor.eightBit = _loc26_.mountOutfit.m_Type.lightColour;
                     this.m_TiledLightmapRenderer.setLightSource(_loc20_,_loc21_,param8,_loc26_.mountOutfit.m_Type.brightness,this.m_TempCreatureColor);
                  }
                  if(_loc26_.outfit.m_Type.isLight)
                  {
                     this.m_TempCreatureColor.eightBit = _loc26_.outfit.m_Type.lightColour;
                     this.m_TiledLightmapRenderer.setLightSource(_loc20_,_loc21_,param8,_loc26_.outfit.m_Type.brightness,this.m_TempCreatureColor);
                  }
                  if(_loc26_.ID == this.m_Player.ID && _loc26_.brightness < 2)
                  {
                     this.m_TempCreatureColor.setChannels(255,255,255);
                     this.m_TiledLightmapRenderer.setLightSource(_loc20_,_loc21_,param8,2,this.m_TempCreatureColor);
                  }
               }
            }
            _loc12_++;
         }
         var _loc27_:int = _loc10_.m_EffectsCount;
         var _loc28_:AppearanceInstance = null;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         _loc18_ = param1 - _loc17_;
         _loc19_ = param2 - _loc17_;
         _loc20_ = _loc18_ / FIELD_SIZE;
         _loc21_ = _loc19_ / FIELD_SIZE;
         _loc12_ = _loc10_.m_EffectsCount - 1;
         while(_loc12_ >= 0)
         {
            if((_loc28_ = _loc10_.m_Effects[_loc12_]) != null)
            {
               if(_loc28_ is TextualEffectInstance)
               {
                  if(param9)
                  {
                     _loc22_ = this.m_DrawnTextualEffects[this.m_DrawnTextualEffectsCount];
                     _loc22_.update(_loc28_,_loc18_ - FIELD_SIZE / 2 + _loc29_,_loc19_ - FIELD_SIZE - 2 * _loc28_.phase,0);
                     if(_loc22_.y + TextualEffectInstance(_loc28_).height > _loc30_)
                     {
                        _loc29_ = _loc29_ + TextualEffectInstance(_loc28_).width;
                     }
                     if(_loc29_ < 2 * FIELD_SIZE)
                     {
                        this.m_DrawnTextualEffectsCount++;
                        _loc30_ = _loc22_.y;
                     }
                  }
               }
               else if(_loc28_ is MissileInstance)
               {
                  _loc28_.drawTo(this.m_MainLayer,_loc18_ + MissileInstance(_loc28_).animationDelta.x,_loc19_ + MissileInstance(_loc28_).animationDelta.y,param3,param4,param5);
                  if(param9 && this.m_OptionsLightEnabled && _loc28_.m_Type.isLight)
                  {
                     this.m_TempEffectColor.eightBit = _loc28_.m_Type.lightColour;
                     this.m_TiledLightmapRenderer.setLightSource(_loc20_,_loc21_,param8,_loc28_.m_Type.brightness,this.m_TempEffectColor);
                  }
               }
               else
               {
                  _loc28_.drawTo(this.m_MainLayer,_loc18_,_loc19_,param3,param4,param5);
                  if(param9 && this.m_OptionsLightEnabled && _loc28_.m_Type.isLight)
                  {
                     _loc31_ = int((Math.min(_loc28_.phase,_loc28_.m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].phases + 1 - _loc28_.phase) * _loc28_.m_Type.brightness + 2) / 3);
                     this.m_TempEffectColor.eightBit = _loc28_.m_Type.lightColour;
                     this.m_TiledLightmapRenderer.setLightSource(_loc20_,_loc21_,param8,Math.min(_loc31_,_loc28_.m_Type.brightness),this.m_TempEffectColor);
                  }
               }
            }
            _loc12_--;
         }
         if(_loc10_.m_Environment != null)
         {
            if(_loc10_.m_Environment.data == 1)
            {
               if(param9)
               {
                  _loc10_.m_Environment.drawTo(this.m_AtmosphereLayer,param1,param2,param3,param4,param5);
               }
            }
            else
            {
               _loc10_.m_Environment.drawTo(this.m_MainLayer,param1,param2,param3,param4,param5);
            }
         }
         if(param9 && _loc11_ > 0 && (_loc14_ = _loc10_.m_ObjectsRenderer[_loc11_ - 1]) != null && _loc14_.m_Type.isTop)
         {
            _loc14_.drawTo(this.m_MainLayer,param1,param2,param3,param4,param5);
            if(_loc14_ == this.m_HighlightObject)
            {
               this.m_ObjectCursor.drawTo(this.m_MainLayer,param1,param2,Tibia.s_FrameTibiaTimestamp);
            }
         }
      }
      
      public function get highlightObject() : *
      {
         return this.m_HighlightObject;
      }
      
      public function set highlightObject(param1:*) : void
      {
         this.m_HighlightObject = param1;
         invalidateDisplayList();
      }
      
      public function set highlightTile(param1:Vector3D) : void
      {
         this.m_HighlightTile = param1;
         invalidateDisplayList();
      }
      
      function pointToMap(param1:Number, param2:Number, param3:Boolean, param4:Vector3D = null) : Vector3D
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Field = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:AppearanceType = null;
         if(this.m_WorldMapStorage != null && (!param3 || this.m_Player != null))
         {
            _loc5_ = int((param1 - this.m_Transform.tx) / this.m_Transform.a / FIELD_SIZE);
            if(_loc5_ < 1 || _loc5_ > MAPSIZE_X - 3)
            {
               return null;
            }
            _loc6_ = int((param2 - this.m_Transform.ty) / this.m_Transform.d / FIELD_SIZE);
            if(_loc6_ < 1 || _loc6_ > MAPSIZE_Y - 3)
            {
               return null;
            }
            _loc7_ = -1;
            if(param3)
            {
               this.m_WorldMapStorage.toMap(this.m_Player.position,this.m_HelperCoordinate);
               _loc7_ = this.m_HelperCoordinate.z;
            }
            else
            {
               _loc8_ = this.m_MinZPlane[_loc6_ * MAPSIZE_X + _loc5_];
               _loc7_ = this.m_MaxZPlane;
               while(_loc7_ >= _loc8_)
               {
                  _loc9_ = this.m_WorldMapStorage.getField(_loc5_,_loc6_,_loc7_);
                  _loc10_ = 0;
                  _loc11_ = _loc9_.m_ObjectsCount;
                  while(_loc10_ < _loc11_)
                  {
                     _loc12_ = _loc9_.m_ObjectsRenderer[_loc10_].m_Type;
                     if((_loc12_.isBank || _loc12_.isBottom) && !_loc12_.isIgnoreLook)
                     {
                        _loc8_ = -1;
                        break;
                     }
                     _loc10_++;
                  }
                  if(_loc8_ < 0)
                  {
                     break;
                  }
                  _loc7_--;
               }
            }
            if(_loc7_ < 0 || _loc7_ >= MAPSIZE_Z)
            {
               return null;
            }
            if(param4 == null)
            {
               param4 = new Vector3D(_loc5_,_loc6_,_loc7_);
            }
            else
            {
               param4.setComponents(_loc5_,_loc6_,_loc7_);
            }
            return param4;
         }
         return null;
      }
      
      private function drawHUDArc(param1:Number, param2:Number, param3:int, param4:int, param5:uint) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:Point = null;
         param3 = Math.max(HUD_ARC_ORIENTATION_LEFT,Math.min(param3,HUD_ARC_ORIENTATION_RIGHT));
         param4 = Math.max(0,Math.min(param4,100));
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.m_HUDArcPoints == null || this.m_HUDArcScale != this.m_Transform.a)
         {
            this.m_HUDArcPoints = new Vector.<Number>(2 * 202,true);
            this.m_HUDArcScale = this.m_Transform.a;
            _loc6_ = 0;
            _loc7_ = 201;
            while(_loc6_ <= 100)
            {
               _loc12_ = (HUD_ARC_LOWER_LIMIT - _loc6_ / 100 * (HUD_ARC_LOWER_LIMIT - HUD_ARC_UPPER_LIMIT)) * (Math.PI / 180);
               _loc13_ = Point.polar(this.m_HUDArcScale * HUD_ARC_RADIUS,_loc12_);
               this.m_HUDArcPoints[2 * _loc6_ + 0] = _loc13_.x;
               this.m_HUDArcPoints[2 * _loc6_ + 1] = _loc13_.y;
               switch(this.m_HUDArcStyle)
               {
                  case HUD_ARC_STYLE_POINTY:
                     this.m_HUDArcPoints[2 * _loc7_ + 0] = _loc13_.x + (-0.0004 * _loc6_ * _loc6_ + 0.04 * _loc6_) * this.m_HUDArcScale * HUD_ARC_TOTAL_WIDTH;
                     this.m_HUDArcPoints[2 * _loc7_ + 1] = _loc13_.y;
                     break;
                  case HUD_ARC_STYLE_HORIZONTAL:
                     this.m_HUDArcPoints[2 * _loc7_ + 0] = _loc13_.x + this.m_HUDArcScale * HUD_ARC_TOTAL_WIDTH;
                     this.m_HUDArcPoints[2 * _loc7_ + 1] = _loc13_.y;
                     break;
                  case HUD_ARC_STYLE_RADIAL:
                     _loc13_ = Point.polar(this.m_Transform.a * HUD_ARC_RADIUS + this.m_HUDArcScale * HUD_ARC_TOTAL_WIDTH,_loc12_);
                     this.m_HUDArcPoints[2 * _loc7_ + 0] = _loc13_.x;
                     this.m_HUDArcPoints[2 * _loc7_ + 1] = _loc13_.y;
               }
               _loc6_++;
               _loc7_--;
            }
         }
         var _loc10_:Vector.<Number> = null;
         var _loc11_:Vector.<int> = null;
         if(param3 == HUD_ARC_ORIENTATION_LEFT)
         {
            _loc9_ = -1;
            param1 = param1 + Math.sin(HUD_ARC_LOWER_LIMIT * (Math.PI / 180)) * this.m_HUDArcScale * HUD_ARC_RADIUS;
         }
         else
         {
            _loc9_ = 1;
            param1 = param1 - Math.sin(HUD_ARC_LOWER_LIMIT * (Math.PI / 180)) * this.m_HUDArcScale * HUD_ARC_RADIUS;
         }
         if(param4 < 100)
         {
            _loc8_ = 2 * (100 - param4 + 1);
            _loc10_ = new Vector.<Number>(2 * (_loc8_ + 1),true);
            _loc6_ = 0;
            _loc7_ = param4;
            while(_loc6_ < _loc8_)
            {
               _loc10_[2 * _loc6_ + 0] = param1 + _loc9_ * this.m_HUDArcPoints[2 * _loc7_ + 0];
               _loc10_[2 * _loc6_ + 1] = param2 + this.m_HUDArcPoints[2 * _loc7_ + 1];
               _loc6_++;
               _loc7_++;
            }
            _loc10_[2 * _loc6_ + 0] = _loc10_[0];
            _loc10_[2 * _loc6_ + 1] = _loc10_[1];
            _loc11_ = new Vector.<int>(_loc8_ + 1,true);
            _loc11_[0] = GraphicsPathCommand.MOVE_TO;
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc11_[_loc6_ + 1] = GraphicsPathCommand.LINE_TO;
               _loc6_++;
            }
            graphics.lineStyle(NaN,0,NaN);
            graphics.beginFill(0,0.33 * HUD_ARC_ALPHA);
            graphics.drawPath(_loc11_,_loc10_);
         }
         if(param4 > 0)
         {
            _loc8_ = 2 * (param4 + 1);
            _loc10_ = new Vector.<Number>(2 * (_loc8_ + 1),true);
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc6_ < param4 + 1)
            {
               _loc10_[2 * _loc6_ + 0] = param1 + _loc9_ * this.m_HUDArcPoints[2 * _loc7_ + 0];
               _loc10_[2 * _loc6_ + 1] = param2 + this.m_HUDArcPoints[2 * _loc7_ + 1];
               _loc6_++;
               _loc7_++;
            }
            _loc6_ = param4 + 1;
            _loc7_ = 202 - _loc6_;
            while(_loc6_ < _loc8_)
            {
               _loc10_[2 * _loc6_ + 0] = param1 + _loc9_ * this.m_HUDArcPoints[2 * _loc7_ + 0];
               _loc10_[2 * _loc6_ + 1] = param2 + this.m_HUDArcPoints[2 * _loc7_ + 1];
               _loc6_++;
               _loc7_++;
            }
            _loc10_[2 * _loc6_ + 0] = _loc10_[0];
            _loc10_[2 * _loc6_ + 1] = _loc10_[1];
            _loc11_ = new Vector.<int>(_loc8_ + 1,true);
            _loc11_[0] = GraphicsPathCommand.MOVE_TO;
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc11_[_loc6_ + 1] = GraphicsPathCommand.LINE_TO;
               _loc6_++;
            }
            graphics.lineStyle(NaN,0,NaN);
            graphics.beginFill(param5,HUD_ARC_ALPHA);
            graphics.drawPath(_loc11_,_loc10_);
         }
         _loc8_ = 2 * (100 + 1);
         _loc10_ = new Vector.<Number>(2 * (_loc8_ + 1),true);
         _loc6_ = 0;
         _loc7_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc10_[2 * _loc6_ + 0] = param1 + _loc9_ * this.m_HUDArcPoints[2 * _loc7_ + 0];
            _loc10_[2 * _loc6_ + 1] = param2 + this.m_HUDArcPoints[2 * _loc7_ + 1];
            _loc6_++;
            _loc7_++;
         }
         _loc10_[2 * _loc6_ + 0] = _loc10_[0];
         _loc10_[2 * _loc6_ + 1] = _loc10_[1];
         _loc11_ = new Vector.<int>(_loc8_ + 1,true);
         _loc11_[0] = GraphicsPathCommand.MOVE_TO;
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc11_[_loc6_ + 1] = GraphicsPathCommand.LINE_TO;
            _loc6_++;
         }
         graphics.lineStyle(HUD_ARC_BORDER_WIDTH,0,1);
         graphics.beginFill(0,NaN);
         graphics.drawPath(_loc11_,_loc10_);
         graphics.lineStyle(NaN,0,NaN);
         graphics.beginFill(0,NaN);
         graphics.endFill();
      }
      
      public function get creatureStorage() : CreatureStorage
      {
         return this.m_CreatureStorage;
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_UncommittedOptions = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function reset() : void
      {
         this.m_StopwatchEnterFrame.reset();
         this.m_StopwatchShowFrame.reset();
      }
      
      private function drawCreatureStatusHUD(param1:Creature, param2:int, param3:int, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:Rectangle = null;
         var _loc9_:* = param1.ID == this.m_Player.ID;
         if(param4)
         {
            this.m_TempHealthColour.ARGB = Creature.s_GetHealthColourARGB(param1.hitpointsPercent);
            this.m_TempManaColour.setChannels(0,0,255);
         }
         else
         {
            this.m_TempHealthColour.setChannels(192,192,192);
            this.m_TempManaColour.setChannels(192,192,192);
         }
         if(this.m_OptionsLightEnabled)
         {
            _loc12_ = this.m_TiledLightmapRenderer.calculateCreatureHudBrightnessFactor(param1,_loc9_);
            this.m_TempHealthColour.mulFloatToSelf(_loc12_,false);
            this.m_TempManaColour.mulFloatToSelf(_loc12_,false);
         }
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         if(param1.mountOutfit != null)
         {
            _loc10_ = param2 - param1.mountOutfit.m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize / 2;
            _loc11_ = param3 - param1.mountOutfit.m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize / 2;
         }
         else if(param1.outfit != null)
         {
            _loc10_ = param2 - param1.outfit.m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize / 2;
            _loc11_ = param3 - param1.outfit.m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize / 2;
         }
         if((_loc9_ || param4) && param6)
         {
            this.m_HelperPoint.x = _loc10_ - 3 * FIELD_SIZE / 2;
            this.m_HelperPoint.y = _loc11_;
            this.m_HelperPoint = this.m_Transform.transformPoint(this.m_HelperPoint);
            this.drawHUDArc(this.m_HelperPoint.x,this.m_HelperPoint.y,HUD_ARC_ORIENTATION_LEFT,param1.hitpointsPercent,this.m_TempHealthColour.RGB);
         }
         if((_loc9_ || param4) && param7)
         {
            this.m_HelperPoint.x = _loc10_ + 3 * FIELD_SIZE / 2;
            this.m_HelperPoint.y = _loc11_;
            this.m_HelperPoint = this.m_Transform.transformPoint(this.m_HelperPoint);
            this.drawHUDArc(this.m_HelperPoint.x,this.m_HelperPoint.y,HUD_ARC_ORIENTATION_RIGHT,param1.manaPercent,this.m_TempManaColour.RGB);
         }
         if(param5)
         {
            _loc13_ = this.m_CreatureNameCache.getItem(param1.name + this.m_TempHealthColour.toString(),param1.name,this.m_TempHealthColour.RGB);
            this.m_HelperPoint.x = param2 - FIELD_SIZE / 2;
            this.m_HelperPoint.y = param3 - FIELD_SIZE;
            this.m_HelperPoint = this.m_Transform.transformPoint(this.m_HelperPoint);
            this.m_HelperPoint.x = Math.max(0,Math.min(this.m_HelperPoint.x - _loc13_.width / 2,unscaledWidth - _loc13_.width));
            this.m_HelperPoint.y = Math.max(0,Math.min(this.m_HelperPoint.y - _loc13_.height,unscaledHeight - _loc13_.height));
            this.m_HelperTrans.tx = this.m_HelperPoint.x - _loc13_.x;
            this.m_HelperTrans.ty = this.m_HelperPoint.y - _loc13_.y;
            graphics.beginBitmapFill(this.m_CreatureNameCache,this.m_HelperTrans,false,false);
            graphics.drawRect(this.m_HelperPoint.x,this.m_HelperPoint.y,_loc13_.width,_loc13_.height);
            graphics.endFill();
         }
         if(param8)
         {
            this.drawCreatureFlags(param1,param2 - FIELD_SIZE / 2,param3 - FIELD_SIZE,param4);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = RENDERER_MIN_WIDTH;
         measuredMinHeight = RENDERER_MIN_HEIGHT;
         measuredWidth = RENDERER_DEFAULT_WIDTH;
         measuredHeight = RENDERER_DEFAULT_HEIGHT;
      }
      
      public function set worldMapStorage(param1:WorldMapStorage) : void
      {
         if(this.m_WorldMapStorage != param1)
         {
            this.m_WorldMapStorage = param1;
            this.m_UncommittedWorldMapStorage = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      private function drawCreatureStatusClassic(param1:Creature, param2:int, param3:int, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean) : void
      {
         var _loc14_:Number = NaN;
         var _loc10_:* = param1.ID == this.m_Player.ID;
         if(param4)
         {
            this.m_TempHealthColour.ARGB = Creature.s_GetHealthColourARGB(param1.hitpointsPercent);
            this.m_TempManaColour.setChannels(0,0,255);
         }
         else
         {
            this.m_TempHealthColour.setChannels(192,192,192);
            this.m_TempManaColour.setChannels(192,192,192);
         }
         if(this.m_OptionsLightEnabled)
         {
            _loc14_ = this.m_TiledLightmapRenderer.calculateCreatureHudBrightnessFactor(param1,_loc10_);
            this.m_TempHealthColour.mulFloatToSelf(_loc14_,false);
            this.m_TempManaColour.mulFloatToSelf(_loc14_,false);
         }
         var _loc11_:Number = 0;
         var _loc12_:Number = -1;
         var _loc13_:Rectangle = null;
         if(param5)
         {
            _loc13_ = this.m_CreatureNameCache.getItem(param1.name + this.m_TempHealthColour.toString(),param1.name,this.m_TempHealthColour.RGB);
            _loc12_ = _loc12_ + (_loc13_.height + 1);
         }
         if(param6)
         {
            _loc12_ = _loc12_ + (4 + 1);
         }
         if(param7)
         {
            _loc12_ = _loc12_ + (4 + 1);
         }
         this.m_HelperPoint.x = param2 - FIELD_SIZE / 2;
         this.m_HelperPoint.y = param3 - FIELD_SIZE;
         this.m_HelperPoint = this.m_Transform.transformPoint(this.m_HelperPoint);
         this.m_HelperPoint.y = Math.max(0,Math.min(this.m_HelperPoint.y - _loc12_,unscaledHeight - _loc12_));
         if(param5)
         {
            _loc11_ = Math.max(1,Math.min(this.m_HelperPoint.x - _loc13_.width / 2,unscaledWidth - _loc13_.width - 1));
            _loc12_ = this.m_HelperPoint.y;
            this.m_HelperTrans.tx = _loc11_ - _loc13_.x;
            this.m_HelperTrans.ty = _loc12_ - _loc13_.y;
            graphics.beginBitmapFill(this.m_CreatureNameCache,this.m_HelperTrans,false,false);
            graphics.drawRect(_loc11_,_loc12_,_loc13_.width,_loc13_.height);
            this.m_HelperPoint.y = this.m_HelperPoint.y + (_loc13_.height + 1);
         }
         if(param6)
         {
            _loc11_ = Math.max(1,Math.min(this.m_HelperPoint.x - 14,unscaledWidth - 27 - 1));
            _loc12_ = this.m_HelperPoint.y;
            graphics.beginFill(0,1);
            graphics.drawRect(_loc11_,_loc12_,27,4);
            graphics.beginFill(this.m_TempHealthColour.RGB,1);
            graphics.drawRect(_loc11_ + 1,_loc12_ + 1,param1.hitpointsPercent / 4,2);
            this.m_HelperPoint.y = this.m_HelperPoint.y + (4 + 1);
         }
         if(param7)
         {
            _loc11_ = Math.max(1,Math.min(this.m_HelperPoint.x - 14,unscaledWidth - 27 - 1));
            _loc12_ = this.m_HelperPoint.y;
            graphics.beginFill(0,1);
            graphics.drawRect(_loc11_,_loc12_,27,4);
            graphics.beginFill(this.m_TempManaColour.RGB,1);
            graphics.drawRect(_loc11_ + 1,_loc12_ + 1,param1.manaPercent / 4,2);
            this.m_HelperPoint.y = this.m_HelperPoint.y + (4 + 1);
         }
         if(param8 && !param1.isNPC || param9 && param1.isNPC)
         {
            this.drawCreatureFlags(param1,param2 - FIELD_SIZE / 2,param3 - FIELD_SIZE,param4);
         }
         graphics.endFill();
      }
      
      function absoluteToRect(param1:Vector3D) : Rectangle
      {
         var _loc2_:Rectangle = new Rectangle();
         param1.z = this.m_Player.position.z;
         var _loc3_:Vector3D = this.m_WorldMapStorage.toMap(param1);
         var _loc4_:int = _loc3_.x * FIELD_SIZE * this.m_Transform.a + this.m_Transform.tx;
         var _loc5_:int = _loc3_.y * FIELD_SIZE * this.m_Transform.d + this.m_Transform.ty;
         _loc2_.setTo(_loc4_,_loc5_,FIELD_SIZE * this.m_Transform.a,FIELD_SIZE * this.m_Transform.d);
         return _loc2_;
      }
      
      private function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         switch(param1.property)
         {
            case "rendererAmbientBrightness":
            case "rendererHighlight":
            case "rendererLevelSeparator":
            case "rendererLightEnabled":
            case "rendererMaxFrameRate":
            case "rendererScaleMap":
            case "*":
               invalidateDisplayList();
               this.updateOptions();
         }
      }
      
      private function drawCreatureStatus() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = false;
         var _loc1_:Creature = null;
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_DrawnCreaturesCount)
         {
            _loc1_ = this.m_DrawnCreatures[_loc4_].object as Creature;
            if(_loc1_ != null)
            {
               if(_loc1_ == this.m_Player)
               {
                  _loc2_ = _loc4_;
               }
               else
               {
                  _loc5_ = int(this.m_DrawnCreatures[_loc4_].x / FIELD_SIZE);
                  _loc6_ = int(this.m_DrawnCreatures[_loc4_].y / FIELD_SIZE);
                  _loc7_ = this.m_DrawnCreatures[_loc4_].z >= this.m_MinZPlane[_loc6_ * MAPSIZE_X + _loc5_];
                  _loc3_ = this.m_Options != null?int(this.m_Options.statusCreatureStyle):int(STATUS_STYLE_OFF);
                  switch(_loc3_)
                  {
                     case STATUS_STYLE_OFF:
                        break;
                     case STATUS_STYLE_HUD:
                        this.drawCreatureStatusHUD(_loc1_,this.m_DrawnCreatures[_loc4_].x,this.m_DrawnCreatures[_loc4_].y,_loc7_,this.m_Options.statusCreatureName,this.m_Options.statusCreatureHealth && !_loc1_.isNPC,false,this.m_Options.statusCreatureFlags);
                        break;
                     case STATUS_STYLE_CLASSIC:
                        this.drawCreatureStatusClassic(_loc1_,this.m_DrawnCreatures[_loc4_].x,this.m_DrawnCreatures[_loc4_].y,_loc7_,this.m_Options.statusCreatureName,this.m_Options.statusCreatureHealth && !_loc1_.isNPC,false,this.m_Options.statusCreatureFlags,this.m_Options.statusCreatureIcons);
                  }
               }
            }
            _loc4_++;
         }
         if(_loc2_ > -1)
         {
            _loc1_ = this.m_DrawnCreatures[_loc2_].object as Creature;
            _loc3_ = this.m_Options != null?int(this.m_Options.statusPlayerStyle):int(STATUS_STYLE_OFF);
            switch(_loc3_)
            {
               case STATUS_STYLE_OFF:
                  break;
               case STATUS_STYLE_HUD:
                  this.drawCreatureStatusHUD(_loc1_,this.m_DrawnCreatures[_loc2_].x,this.m_DrawnCreatures[_loc2_].y,true,this.m_Options.statusPlayerName,this.m_Options.statusPlayerHealth,this.m_Options.statusPlayerMana,this.m_Options.statusPlayerFlags);
                  break;
               case STATUS_STYLE_CLASSIC:
                  this.drawCreatureStatusClassic(_loc1_,this.m_DrawnCreatures[_loc2_].x,this.m_DrawnCreatures[_loc2_].y,true,this.m_Options.statusPlayerName,this.m_Options.statusPlayerHealth,this.m_Options.statusPlayerMana,this.m_Options.statusPlayerFlags,false);
            }
         }
      }
      
      public function set creatureStorage(param1:CreatureStorage) : void
      {
         if(this.m_CreatureStorage != param1)
         {
            this.m_CreatureStorage = param1;
            invalidateDisplayList();
         }
      }
      
      function pointToCreature(param1:Number, param2:Number, param3:Boolean) : Creature
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Creature = null;
         var _loc11_:Vector3D = null;
         var _loc12_:Vector3D = null;
         if(this.m_WorldMapStorage != null && (!param3 || this.m_Player != null))
         {
            _loc4_ = int(param1 - this.m_Transform.tx) / this.m_Transform.a;
            _loc5_ = int(param2 - this.m_Transform.ty) / this.m_Transform.d;
            _loc6_ = this.m_MinZPlane[int(_loc5_ / FIELD_SIZE) * MAPSIZE_X + int(_loc4_ / FIELD_SIZE)];
            if(param3)
            {
               this.m_WorldMapStorage.toMap(this.m_Player.position,this.m_HelperCoordinate);
               _loc6_ = this.m_HelperCoordinate.z;
            }
            _loc7_ = 0;
            while(_loc7_ < this.m_DrawnCreaturesCount)
            {
               if(this.m_DrawnCreatures[_loc7_] != null)
               {
                  _loc8_ = this.m_DrawnCreatures[_loc7_].x - FIELD_SIZE / 2;
                  _loc9_ = this.m_DrawnCreatures[_loc7_].y - FIELD_SIZE / 2;
                  if(!(Math.abs(_loc8_ - _loc4_) > FIELD_SIZE / 2 || Math.abs(_loc9_ - _loc5_) > FIELD_SIZE / 2))
                  {
                     _loc10_ = Creature(this.m_DrawnCreatures[_loc7_].object);
                     if(_loc10_ != null)
                     {
                        _loc11_ = _loc10_.position;
                        if(this.m_WorldMapStorage.isVisible(_loc11_.x,_loc11_.y,_loc11_.z,true))
                        {
                           _loc12_ = this.m_WorldMapStorage.toMap(_loc11_);
                           if(_loc12_.z >= _loc6_)
                           {
                              return _loc10_;
                           }
                        }
                     }
                  }
               }
               _loc7_++;
            }
         }
         return null;
      }
      
      public function get highlightTile() : Vector3D
      {
         return this.m_HighlightTile;
      }
      
      private function updateOptions() : void
      {
         var _loc1_:Number = NaN;
         if(this.options != null)
         {
            this.m_OptionsAmbientBrightness = this.options.rendererAmbientBrightness;
            this.m_OptionsFrameRate = this.options.rendererMaxFrameRate;
            this.m_OptionsHighlight = this.options.rendererHighlight;
            this.m_OptionsLevelSeparator = this.options.rendererLevelSeparator;
            this.m_OptionsLightEnabled = this.options.rendererLightEnabled;
            this.m_OptionsScaleMap = this.options.rendererScaleMap;
            this.m_OptionsAntialiasing = this.options.rendererAntialiasing;
            s_InitialiseMarksViews(this.options.statusCreaturePvpFrames);
         }
         else
         {
            this.m_OptionsAmbientBrightness = NaN;
            this.m_OptionsFrameRate = NaN;
            this.m_OptionsHighlight = NaN;
            this.m_OptionsLevelSeparator = NaN;
            this.m_OptionsLightEnabled = false;
            this.m_OptionsScaleMap = true;
            this.m_OptionsAntialiasing = false;
            s_InitialiseMarksViews(true);
         }
         if(stage != null && !isNaN(this.m_OptionsFrameRate))
         {
            stage.frameRate = this.m_OptionsFrameRate;
         }
         if(!isNaN(this.m_OptionsHighlight))
         {
            _loc1_ = this.m_OptionsHighlight * HIGHLIGHT_MAX_OPACITY + (1 - this.m_OptionsHighlight) * HIGHLIGHT_MIN_OPACITY;
            this.m_ObjectCursor.opacity = _loc1_;
            this.m_TileCursor.opacity = _loc1_;
         }
         else
         {
            this.m_ObjectCursor.opacity = HIGHLIGHT_MIN_OPACITY;
            this.m_TileCursor.opacity = HIGHLIGHT_MIN_OPACITY;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.initialize3DObjects();
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function get worldMapStorage() : WorldMapStorage
      {
         return this.m_WorldMapStorage;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         invalidateDisplayList();
      }
      
      private function layoutOnscreenMessages() : void
      {
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<OnscreenMessageBox> = this.m_WorldMapStorage.m_MessageBoxes;
         _loc1_ = _loc3_.length - 1;
         while(_loc1_ >= 0)
         {
            if(_loc3_[_loc1_] != null && _loc3_[_loc1_].visible && !_loc3_[_loc1_].empty)
            {
               _loc3_[_loc1_].arrangeMessages();
            }
            _loc1_--;
         }
         var _loc4_:Rectangle = new Rectangle(0,0,FIELD_SIZE * this.m_Transform.a,FIELD_SIZE * this.m_Transform.a);
         var _loc5_:Vector.<Rectangle> = new Vector.<Rectangle>(_loc3_.length,true);
         var _loc6_:Vector.<Rectangle> = new Vector.<Rectangle>(_loc3_.length,true);
         var _loc7_:Vector.<Point> = new Vector.<Point>(_loc3_.length,true);
         _loc1_ = _loc3_.length - 1;
         while(_loc1_ >= WorldMapStorage.ONSCREEN_TARGET_BOX_LOW)
         {
            if(_loc3_[_loc1_] != null && _loc3_[_loc1_].visible && !_loc3_[_loc1_].empty)
            {
               switch(_loc1_)
               {
                  case WorldMapStorage.ONSCREEN_TARGET_BOX_LOW:
                     _loc3_[_loc1_].fixing = OnscreenMessageBox.FIXING_BOTH;
                     this.m_HelperPoint.x = unscaledWidth / 2;
                     this.m_HelperPoint.y = (unscaledHeight + _loc4_.height + _loc3_[_loc1_].height + ONSCREEN_MESSAGE_GAP) / 2;
                     break;
                  case WorldMapStorage.ONSCREEN_TARGET_BOX_HIGH:
                     _loc3_[_loc1_].fixing = OnscreenMessageBox.FIXING_BOTH;
                     this.m_HelperPoint.x = unscaledWidth / 2;
                     this.m_HelperPoint.y = (unscaledHeight + _loc4_.height - _loc3_[_loc1_].height - ONSCREEN_MESSAGE_GAP) / 2;
                     break;
                  case WorldMapStorage.ONSCREEN_TARGET_BOX_TOP:
                     _loc3_[_loc1_].fixing = OnscreenMessageBox.FIXING_BOTH;
                     this.m_HelperPoint.x = unscaledWidth / 2;
                     this.m_HelperPoint.y = unscaledHeight / 4;
                     break;
                  default:
                     _loc3_[_loc1_].fixing = OnscreenMessageBox.FIXING_NONE;
                     this.m_WorldMapStorage.toMapClosest(_loc3_[_loc1_].position,this.m_HelperCoordinate);
                     this.m_HelperPoint.x = (this.m_HelperCoordinate.x - 1) * _loc4_.width + _loc4_.width / 2;
                     this.m_HelperPoint.y = (this.m_HelperCoordinate.y - 1) * _loc4_.height - _loc3_[_loc1_].height / 2;
                     if(!this.m_OptionsScaleMap)
                     {
                        this.m_HelperPoint.x = this.m_HelperPoint.x - Math.max(0,MAP_WIDTH * FIELD_SIZE - unscaledWidth) / 2;
                        this.m_HelperPoint.y = this.m_HelperPoint.y - Math.max(0,MAP_HEIGHT * FIELD_SIZE - unscaledHeight) / 2;
                     }
               }
               _loc7_[_loc1_] = new Point();
               _loc5_[_loc1_] = new Rectangle();
               _loc5_[_loc1_].x = this.m_HelperPoint.x - (_loc3_[_loc1_].width + ONSCREEN_MESSAGE_GAP) / 2;
               _loc5_[_loc1_].y = this.m_HelperPoint.y - (_loc3_[_loc1_].height + ONSCREEN_MESSAGE_GAP) / 2;
               _loc5_[_loc1_].width = _loc3_[_loc1_].width + ONSCREEN_MESSAGE_GAP;
               _loc5_[_loc1_].height = _loc3_[_loc1_].height + ONSCREEN_MESSAGE_GAP;
               _loc6_[_loc1_] = new Rectangle();
               _loc6_[_loc1_].x = _loc5_[_loc1_].x - _loc5_[_loc1_].width / 2;
               _loc6_[_loc1_].y = _loc5_[_loc1_].y - _loc5_[_loc1_].height / 2;
               _loc6_[_loc1_].width = _loc5_[_loc1_].width;
               _loc6_[_loc1_].height = _loc5_[_loc1_].height;
            }
            _loc1_--;
         }
         var _loc8_:Number = Number.POSITIVE_INFINITY;
         var _loc9_:Number = 0;
         do
         {
            _loc9_ = _loc8_;
            _loc8_ = 0;
            _loc1_ = _loc5_.length - 1;
            while(_loc1_ >= 0)
            {
               if(_loc5_[_loc1_] != null)
               {
                  _loc7_[_loc1_].x = 0;
                  _loc7_[_loc1_].y = 0;
                  _loc10_ = Math.sqrt(_loc5_[_loc1_].width * _loc5_[_loc1_].width + _loc5_[_loc1_].height * _loc5_[_loc1_].height);
                  _loc2_ = _loc5_.length - 1;
                  while(_loc2_ >= 0)
                  {
                     if(_loc1_ != _loc2_ && _loc5_[_loc2_] != null)
                     {
                        _loc11_ = _loc5_[_loc1_].intersection(_loc5_[_loc2_]);
                        if(!_loc11_.isEmpty())
                        {
                           this.m_HelperPoint.x = Math.floor(_loc5_[_loc1_].x + _loc5_[_loc1_].width / 2) - Math.floor(_loc5_[_loc2_].x + _loc5_[_loc2_].width / 2);
                           this.m_HelperPoint.y = Math.floor(_loc5_[_loc1_].y + _loc5_[_loc1_].height / 2) - Math.floor(_loc5_[_loc2_].y + _loc5_[_loc2_].height / 2);
                           _loc8_ = _loc8_ + _loc11_.width * _loc11_.height * Math.pow(0.5,this.m_HelperPoint.length / _loc10_ - 1);
                           if(this.m_HelperPoint.x < 0)
                           {
                              _loc7_[_loc1_].x = _loc7_[_loc1_].x - _loc11_.width;
                           }
                           else if(this.m_HelperPoint.x > 0)
                           {
                              _loc7_[_loc1_].x = _loc7_[_loc1_].x + _loc11_.width;
                           }
                           if(this.m_HelperPoint.y < 0)
                           {
                              _loc7_[_loc1_].y = _loc7_[_loc1_].y - _loc11_.height;
                           }
                           else if(this.m_HelperPoint.y > 0)
                           {
                              _loc7_[_loc1_].y = _loc7_[_loc1_].y + _loc11_.height;
                           }
                           if(this.m_HelperPoint.x == 0 && this.m_HelperPoint.y == 0 && _loc2_ == _loc5_.length - 1)
                           {
                              _loc7_[_loc1_].x = _loc7_[_loc1_].x + (_loc1_ - _loc2_);
                           }
                        }
                     }
                     _loc2_--;
                  }
               }
               _loc1_--;
            }
            _loc1_ = _loc5_.length - 1;
            while(_loc1_ >= 0)
            {
               if(_loc5_[_loc1_] != null)
               {
                  if(_loc7_[_loc1_].x > 0)
                  {
                     _loc5_[_loc1_].x = Math.max(_loc6_[_loc1_].left,Math.min(_loc5_[_loc1_].x + 1,_loc6_[_loc1_].right));
                  }
                  else if(_loc7_[_loc1_].x < 0)
                  {
                     _loc5_[_loc1_].x = Math.max(_loc6_[_loc1_].left,Math.min(_loc5_[_loc1_].x - 1,_loc6_[_loc1_].right));
                  }
                  if(_loc7_[_loc1_].y > 0)
                  {
                     _loc5_[_loc1_].y = Math.max(_loc6_[_loc1_].top,Math.min(_loc5_[_loc1_].y + 1,_loc6_[_loc1_].bottom));
                  }
                  else if(_loc7_[_loc1_].y < 0)
                  {
                     _loc5_[_loc1_].y = Math.max(_loc6_[_loc1_].top,Math.min(_loc5_[_loc1_].y - 1,_loc6_[_loc1_].bottom));
                  }
               }
               _loc1_--;
            }
         }
         while(_loc8_ < _loc9_);
         
         _loc1_ = _loc3_.length - 1;
         while(_loc1_ >= WorldMapStorage.ONSCREEN_TARGET_BOX_LOW)
         {
            if(_loc3_[_loc1_] != null && _loc3_[_loc1_].visible && !_loc3_[_loc1_].empty)
            {
               _loc3_[_loc1_].x = Math.max(_loc6_[_loc1_].left,Math.min(_loc5_[_loc1_].x,_loc6_[_loc1_].right)) + ONSCREEN_MESSAGE_GAP / 2;
               _loc3_[_loc1_].y = Math.max(_loc6_[_loc1_].top,Math.min(_loc5_[_loc1_].y,_loc6_[_loc1_].bottom)) + ONSCREEN_MESSAGE_GAP / 2;
            }
            _loc1_--;
         }
      }
      
      public function set player(param1:Player) : void
      {
         if(this.m_Player != param1)
         {
            this.m_Player = param1;
            invalidateDisplayList();
         }
      }
      
      function pointToAbsolute(param1:Number, param2:Number, param3:Boolean, param4:Vector3D = null) : Vector3D
      {
         var _loc5_:Vector3D = this.pointToMap(param1,param2,param3,param4);
         if(_loc5_ != null)
         {
            return this.m_WorldMapStorage.toAbsolute(_loc5_,_loc5_);
         }
         return null;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            this.updateOptions();
            this.m_TiledLightmapRenderer.options = this.options;
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedWorldMapStorage)
         {
            this.m_TiledLightmapRenderer.worldMapStorage = this.worldMapStorage;
            this.m_UncommittedWorldMapStorage = false;
         }
      }
      
      private function drawCreatureFlags(param1:Creature, param2:int, param3:int, param4:Boolean) : void
      {
         if(!(param1.isHuman || param1.isSummon || param1.isNPC))
         {
            return;
         }
         if(param1.hasFlag == false)
         {
            return;
         }
         var _loc5_:BitmapData = this.getCreatureFlagsCachedBitmap(param1);
         this.m_HelperPoint.setTo(param2,param3);
         this.m_HelperPoint = this.m_Transform.transformPoint(this.m_HelperPoint);
         this.m_HelperPoint.setTo(Math.max(0,this.m_HelperPoint.x + 16 - CreatureStorage.STATE_FLAG_SIZE + 4),Math.max(0,this.m_HelperPoint.y + 1));
         this.m_HelperTrans.setTo(1,0,0,1,this.m_HelperPoint.x,this.m_HelperPoint.y);
         graphics.beginBitmapFill(_loc5_,this.m_HelperTrans,false,false);
         graphics.drawRect(this.m_HelperPoint.x,this.m_HelperPoint.y,_loc5_.width,_loc5_.height);
         graphics.endFill();
      }
      
      protected function initialize3DObjects() : void
      {
         var _loc1_:Rectangle = new Rectangle(0,0,100,100);
         this.m_Tibia3D = new Tibia3D(this.stage.stage3Ds[0],_loc1_,Context3DRenderMode.AUTO);
         this.m_Tibia3D.visible = false;
         var _loc2_:Camera2D = new Camera2D(_loc1_.width,_loc1_.height);
         this.m_Tibia3D.camera = _loc2_;
         if(this.m_TiledLightmapRenderer == null)
         {
            this.m_TiledLightmapRenderer = new TiledLightmapRenderer();
         }
         this.m_LightTranslate = new Matrix();
         this.m_LightTranslate.scale(TiledLightmapRenderer.LIGHTMAP_SHRINK_FACTOR,TiledLightmapRenderer.LIGHTMAP_SHRINK_FACTOR);
         this.m_LightTranslate.translate(-FIELD_SIZE / 2,-FIELD_SIZE / 2);
         this.m_LightClipRect = new Rectangle(0,0,(MAP_WIDTH + 2) * FIELD_SIZE,(MAP_HEIGHT + 2) * FIELD_SIZE);
      }
      
      private function drawTextualEffects() : void
      {
         var _loc2_:TextualEffectInstance = null;
         this.m_HelperTrans.a = 1;
         this.m_HelperTrans.d = 1;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_DrawnTextualEffectsCount)
         {
            _loc2_ = this.m_DrawnTextualEffects[_loc1_].object as TextualEffectInstance;
            if(_loc2_ != null)
            {
               this.m_HelperPoint.x = this.m_DrawnTextualEffects[_loc1_].x - _loc2_.width / 2;
               this.m_HelperPoint.y = this.m_DrawnTextualEffects[_loc1_].y;
               this.m_HelperPoint = this.m_Transform.transformPoint(this.m_HelperPoint);
               if(this.m_HelperPoint.x < 0)
               {
                  this.m_HelperPoint.x = 0;
               }
               if(this.m_HelperPoint.x + _loc2_.width > unscaledWidth)
               {
                  this.m_HelperPoint.x = unscaledWidth - _loc2_.width;
               }
               if(this.m_HelperPoint.y < 0)
               {
                  this.m_HelperPoint.y = 0;
               }
               if(this.m_HelperPoint.y + _loc2_.height > unscaledHeight)
               {
                  this.m_HelperPoint.y = unscaledHeight - _loc2_.height;
               }
               this.m_HelperTrans.tx = this.m_HelperPoint.x;
               this.m_HelperTrans.ty = this.m_HelperPoint.y;
               graphics.beginBitmapFill(_loc2_.m_InstanceBitmap,this.m_HelperTrans,false,false);
               graphics.drawRect(this.m_HelperPoint.x,this.m_HelperPoint.y,_loc2_.width,_loc2_.height);
            }
            _loc1_++;
         }
         graphics.endFill();
      }
      
      private function drawOnscreenMessages() : void
      {
         var _loc8_:OnscreenMessageBox = null;
         if(this.m_WorldMapStorage.m_LayoutOnscreenMessages)
         {
            this.layoutOnscreenMessages();
            this.m_WorldMapStorage.m_LayoutOnscreenMessages = false;
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         if(this.m_Player != null)
         {
            _loc1_ = this.m_Player.animationDelta.x * this.m_Transform.a;
            _loc2_ = this.m_Player.animationDelta.y * this.m_Transform.d;
         }
         var _loc3_:Vector.<OnscreenMessageBox> = this.m_WorldMapStorage.m_MessageBoxes;
         var _loc4_:Number = 0;
         if((_loc8_ = _loc3_[WorldMapStorage.ONSCREEN_TARGET_BOX_BOTTOM]) != null && _loc8_.visible && !_loc8_.empty)
         {
            _loc4_ = _loc8_.height;
         }
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc8_ = null;
         var _loc9_:BitmapData = null;
         this.m_HelperTrans.a = 1;
         this.m_HelperTrans.d = 1;
         _loc5_ = _loc3_.length - 1;
         while(_loc5_ >= WorldMapStorage.ONSCREEN_TARGET_BOX_LOW)
         {
            if((_loc8_ = _loc3_[_loc5_]) != null && _loc8_.visible && !_loc8_.empty)
            {
               this.m_HelperPoint.x = _loc8_.x;
               this.m_HelperPoint.y = _loc8_.y;
               if((_loc8_.fixing & OnscreenMessageBox.FIXING_X) == 0)
               {
                  this.m_HelperPoint.x = this.m_HelperPoint.x - _loc1_;
               }
               if((_loc8_.fixing & OnscreenMessageBox.FIXING_Y) == 0)
               {
                  this.m_HelperPoint.y = this.m_HelperPoint.y - _loc2_;
               }
               this.m_HelperPoint.x = Math.max(0,Math.min(this.m_HelperPoint.x,unscaledWidth - _loc8_.width));
               this.m_HelperPoint.y = Math.max(0,Math.min(this.m_HelperPoint.y,unscaledHeight - _loc4_ - _loc8_.height));
               _loc6_ = 0;
               _loc7_ = _loc8_.visibleMessages;
               while(_loc6_ < _loc7_)
               {
                  _loc9_ = _loc8_.getCacheBitmap(_loc6_,this.m_HelperRect);
                  this.m_HelperTrans.tx = -this.m_HelperRect.x + this.m_HelperPoint.x + (_loc8_.width - this.m_HelperRect.width) / 2;
                  this.m_HelperTrans.ty = -this.m_HelperRect.y + this.m_HelperPoint.y;
                  graphics.beginBitmapFill(_loc9_,this.m_HelperTrans,false,false);
                  graphics.drawRect(this.m_HelperPoint.x + (_loc8_.width - this.m_HelperRect.width) / 2,this.m_HelperPoint.y,this.m_HelperRect.width,this.m_HelperRect.height);
                  this.m_HelperPoint.y = this.m_HelperPoint.y + this.m_HelperRect.height;
                  _loc6_++;
               }
            }
            _loc5_--;
         }
         if((_loc8_ = _loc3_[WorldMapStorage.ONSCREEN_TARGET_BOX_BOTTOM]) != null && _loc8_.visible && !_loc8_.empty)
         {
            _loc9_ = _loc8_.getCacheBitmap(0,this.m_HelperRect);
            this.m_HelperPoint.x = (unscaledWidth - this.m_HelperRect.width) / 2;
            this.m_HelperPoint.y = unscaledHeight - this.m_HelperRect.height;
            this.m_HelperTrans.tx = -this.m_HelperRect.x + this.m_HelperPoint.x;
            this.m_HelperTrans.ty = -this.m_HelperRect.y + this.m_HelperPoint.y;
            graphics.beginBitmapFill(_loc9_,this.m_HelperTrans,false,false);
            graphics.drawRect(this.m_HelperPoint.x,this.m_HelperPoint.y,this.m_HelperRect.width,this.m_HelperRect.height);
         }
      }
      
      public function get player() : Player
      {
         return this.m_Player;
      }
      
      private function getCreatureFlagsCachedBitmap(param1:Creature) : BitmapData
      {
         var _loc9_:Object = null;
         var _loc10_:Rectangle = null;
         var _loc11_:Rectangle = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Point = null;
         var _loc15_:BitmapData = null;
         var _loc16_:BitmapData = null;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:uint = 0;
         var _loc20_:* = null;
         var _loc21_:Object = null;
         var _loc2_:uint = param1.pkFlag;
         var _loc3_:uint = param1.partyFlag;
         var _loc4_:uint = param1.summonFlag;
         var _loc5_:uint = param1.guildFlag;
         var _loc6_:uint = param1.riskinessFlag;
         var _loc7_:uint = param1.speechCategory;
         if(_loc7_ == NPC_SPEECH_QUESTTRADER)
         {
            _loc7_ = getTimer() % 2048 > 1024?uint(NPC_SPEECH_TRADER):uint(NPC_SPEECH_QUEST);
         }
         var _loc8_:Object = _loc2_ + "," + _loc3_ + "," + _loc4_ + "," + _loc5_ + "," + _loc6_ + "," + _loc7_;
         if(this.m_CreatureFlagsBitmapCache.hasOwnProperty(_loc8_))
         {
            _loc9_ = this.m_CreatureFlagsBitmapCache[_loc8_];
            _loc9_["lastAccess"] = getTimer();
            return _loc9_["bitmap"];
         }
         _loc10_ = this.m_HelperRect;
         _loc11_ = this.m_HelperRect2;
         this.m_HelperCreatureFlagsBitmapData.fillRect(this.m_HelperCreatureFlagsBitmapData.rect,0);
         _loc12_ = -2;
         _loc13_ = -2;
         _loc14_ = new Point(0,0);
         _loc10_.setTo(0,0,-CreatureStorage.STATE_FLAG_GAP,-CreatureStorage.STATE_FLAG_GAP);
         _loc15_ = null;
         if(_loc3_ > PARTY_NONE)
         {
            _loc15_ = CreatureStorage.s_GetPartyFlag(param1.partyFlag,_loc11_);
            this.m_HelperCreatureFlagsBitmapData.copyPixels(_loc15_,_loc11_,_loc14_);
            _loc14_.x = _loc14_.x + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.width = _loc10_.width + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
         }
         if(param1.pkFlag > PK_NONE)
         {
            _loc15_ = CreatureStorage.s_GetPKFlag(param1.pkFlag,_loc11_);
            this.m_HelperCreatureFlagsBitmapData.copyPixels(_loc15_,_loc11_,_loc14_);
            _loc14_.x = _loc14_.x + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.width = _loc10_.width + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
         }
         if(param1.summonFlag > SUMMON_NONE)
         {
            _loc15_ = CreatureStorage.s_GetSummonFlag(param1.summonFlag,_loc11_);
            this.m_HelperCreatureFlagsBitmapData.copyPixels(_loc15_,_loc11_,_loc14_);
            _loc14_.x = _loc14_.x + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.width = _loc10_.width + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
         }
         if(_loc7_ > NPC_SPEECH_NONE)
         {
            _loc15_ = CreatureStorage.s_GetNpcSpeechFlag(_loc7_,_loc11_);
            this.m_HelperCreatureFlagsBitmapData.copyPixels(_loc15_,_loc11_,_loc14_);
            _loc14_.x = _loc14_.x + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.width = _loc10_.width + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.SPEECH_FLAG_SIZE);
            _loc10_.height = _loc10_.height + CreatureStorage.SPEECH_FLAG_SIZE;
         }
         if(_loc14_.x > 0)
         {
            _loc14_.x = _loc14_.x / 2 - CreatureStorage.STATE_FLAG_SIZE / 2;
            _loc14_.y = _loc14_.y + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.height = _loc10_.height + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
         }
         if(param1.guildFlag > GUILD_NONE)
         {
            _loc15_ = CreatureStorage.s_GetGuildFlag(param1.guildFlag,_loc11_);
            this.m_HelperCreatureFlagsBitmapData.copyPixels(_loc15_,_loc11_,_loc14_);
            _loc14_.y = _loc14_.y + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.height = _loc10_.height + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.width = Math.max(_loc10_.width,CreatureStorage.STATE_FLAG_SIZE);
         }
         if(param1.riskinessFlag > RISKINESS_NONE)
         {
            _loc15_ = CreatureStorage.s_GetRiskinessFlag(param1.riskinessFlag,_loc11_);
            this.m_HelperCreatureFlagsBitmapData.copyPixels(_loc15_,_loc11_,_loc14_);
            _loc14_.y = _loc14_.y + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.height = _loc10_.height + (CreatureStorage.STATE_FLAG_GAP + CreatureStorage.STATE_FLAG_SIZE);
            _loc10_.width = Math.max(_loc10_.width,CreatureStorage.STATE_FLAG_SIZE);
         }
         _loc16_ = new BitmapData(_loc10_.width,_loc10_.height);
         this.m_HelperPoint.setTo(0,0);
         _loc16_.copyPixels(this.m_HelperCreatureFlagsBitmapData,_loc10_,this.m_HelperPoint);
         _loc17_ = null;
         _loc18_ = null;
         _loc19_ = 0;
         for(_loc20_ in this.m_CreatureFlagsBitmapCache)
         {
            _loc21_ = this.m_CreatureFlagsBitmapCache[_loc20_];
            if(_loc17_ == null || _loc21_["lastAccess"] < _loc17_["lastAccess"])
            {
               _loc17_ = _loc21_;
               _loc18_ = _loc20_;
            }
            _loc19_++;
         }
         if(_loc19_ > CREATURE_FLAGS_BITMAP_CACHE_SIZE)
         {
            delete this.m_CreatureFlagsBitmapCache[_loc18_];
         }
         _loc17_ = {
            "lastAccess":getTimer(),
            "bitmap":_loc16_
         };
         this.m_CreatureFlagsBitmapCache[_loc8_] = _loc17_;
         return _loc17_["bitmap"];
      }
      
      public function get fps() : Number
      {
         var _loc1_:Number = this.m_StopwatchShowFrame.average;
         if(_loc1_ > 0)
         {
            return Math.round(1000 / _loc1_);
         }
         return 0;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc14_:uint = 0;
         var _loc15_:Number = NaN;
         var _loc16_:* = false;
         var _loc17_:Number = NaN;
         var _loc18_:Creature = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Field = null;
         var _loc22_:Creature = null;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:Vector.<RenderAtom> = null;
         var _loc34_:int = 0;
         var _loc35_:RenderAtom = null;
         var _loc36_:ObjectInstance = null;
         this.m_StopwatchEnterFrame.stop();
         this.m_StopwatchEnterFrame.start();
         var _loc3_:Colour = null;
         _loc4_ = Tibia.s_GetTibiaTimer();
         var _loc5_:Number = _loc4_ - Tibia.s_FrameTibiaTimestamp;
         Tibia.s_FrameRealTimestamp = getTimer();
         if(Math.floor(this.m_StopwatchEnterFrame.average) > Math.max(Math.ceil(1000 / this.m_OptionsFrameRate),_loc5_) || this.m_CreatureStorage == null || this.m_Options == null || this.m_Player == null || this.m_WorldMapStorage == null || !this.m_WorldMapStorage.valid)
         {
            return;
         }
         this.m_StopwatchShowFrame.stop();
         this.m_StopwatchShowFrame.start();
         this.m_MainLayer.fillRect(this.m_Rectangle,4278190080);
         this.m_AtmosphereLayer.fillRect(this.m_Rectangle,0);
         this.m_DrawnCreaturesCount = 0;
         this.m_DrawnTextualEffectsCount = 0;
         Tibia.s_FrameTibiaTimestamp = _loc4_;
         this.m_WorldMapStorage.animate();
         this.m_CreatureStorage.animate();
         this.m_MaxZPlane = MAPSIZE_Z - 1;
         this.m_WorldMapStorage.toMap(this.m_Player.position,this.m_HelperCoordinate);
         this.m_PlayerZPlane = this.m_HelperCoordinate.z;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         while(this.m_MaxZPlane > this.m_PlayerZPlane && this.m_WorldMapStorage.getObjectPerLayer(this.m_MaxZPlane) <= 0)
         {
            this.m_MaxZPlane--;
         }
         var _loc11_:ObjectInstance = null;
         var _loc12_:AppearanceType = null;
         _loc8_ = PLAYER_OFFSET_X - 1;
         while(_loc8_ <= PLAYER_OFFSET_X + 1)
         {
            _loc9_ = PLAYER_OFFSET_Y - 1;
            while(_loc9_ <= PLAYER_OFFSET_Y + 1)
            {
               if(!(_loc8_ != PLAYER_OFFSET_X && _loc9_ != PLAYER_OFFSET_Y || !this.m_WorldMapStorage.isLookPossible(_loc8_,_loc9_,this.m_PlayerZPlane)))
               {
                  _loc10_ = this.m_PlayerZPlane + 1;
                  while(_loc10_ - 1 < this.m_MaxZPlane && _loc8_ + this.m_PlayerZPlane - _loc10_ >= 0 && _loc9_ + this.m_PlayerZPlane - _loc10_ >= 0)
                  {
                     if((_loc11_ = this.m_WorldMapStorage.getObject(_loc8_ + this.m_PlayerZPlane - _loc10_,_loc9_ + this.m_PlayerZPlane - _loc10_,_loc10_,0)) != null && (_loc12_ = _loc11_.type) != null && _loc12_.isBank && !_loc12_.isDonthide)
                     {
                        this.m_MaxZPlane = _loc10_ - 1;
                     }
                     else if((_loc11_ = this.m_WorldMapStorage.getObject(_loc8_,_loc9_,_loc10_,0)) != null && (_loc12_ = _loc11_.type) != null && (_loc12_.isBank || _loc12_.isBottom) && !_loc12_.isDonthide)
                     {
                        this.m_MaxZPlane = _loc10_ - 1;
                     }
                     _loc10_++;
                  }
               }
               _loc9_++;
            }
            _loc8_++;
         }
         if(!this.m_WorldMapStorage.m_CacheFullbank)
         {
            _loc9_ = 0;
            while(_loc9_ < MAPSIZE_Y)
            {
               _loc8_ = 0;
               while(_loc8_ < MAPSIZE_X)
               {
                  _loc6_ = _loc9_ * MAPSIZE_X + _loc8_;
                  this.m_MinZPlane[_loc6_] = 0;
                  _loc10_ = this.m_MaxZPlane;
                  while(_loc10_ >= 0)
                  {
                     if((_loc11_ = this.m_WorldMapStorage.getObject(_loc8_,_loc9_,_loc10_,0)) != null && (_loc12_ = _loc11_.type) != null && _loc12_.isFullBank)
                     {
                        this.m_MinZPlane[_loc6_] = _loc10_;
                        break;
                     }
                     _loc10_--;
                  }
                  _loc8_++;
               }
               _loc9_++;
            }
            this.m_WorldMapStorage.m_CacheFullbank = true;
         }
         if(this.m_OptionsScaleMap)
         {
            this.m_ClipRect.width = MAP_WIDTH * FIELD_SIZE;
            this.m_ClipRect.height = MAP_HEIGHT * FIELD_SIZE;
            this.m_ClipRect.x = FIELD_SIZE + this.m_Player.animationDelta.x;
            this.m_ClipRect.y = FIELD_SIZE + this.m_Player.animationDelta.y;
            this.m_Transform.a = unscaledWidth / this.m_ClipRect.width;
            this.m_Transform.d = unscaledHeight / this.m_ClipRect.height;
            this.m_Transform.tx = -this.m_ClipRect.x * this.m_Transform.a;
            this.m_Transform.ty = -this.m_ClipRect.y * this.m_Transform.d;
         }
         else
         {
            this.m_ClipRect.width = Math.min(MAP_WIDTH * FIELD_SIZE,unscaledWidth);
            this.m_ClipRect.height = Math.min(MAP_HEIGHT * FIELD_SIZE,unscaledHeight);
            this.m_ClipRect.x = (MAP_WIDTH * FIELD_SIZE - this.m_ClipRect.width) / 2 + FIELD_SIZE + this.m_Player.animationDelta.x;
            this.m_ClipRect.y = (MAP_HEIGHT * FIELD_SIZE - this.m_ClipRect.height) / 2 + FIELD_SIZE + this.m_Player.animationDelta.y;
            this.m_Transform.a = 1;
            this.m_Transform.d = 1;
            this.m_Transform.tx = -this.m_ClipRect.x;
            this.m_Transform.ty = -this.m_ClipRect.y;
         }
         var _loc13_:ByteArray = this.m_TiledLightmapRenderer.rawColorData;
         _loc10_ = 0;
         while(_loc10_ <= this.m_MaxZPlane)
         {
            _loc14_ = this.m_WorldMapStorage.getAmbientBrightness();
            _loc15_ = this.m_OptionsLevelSeparator;
            _loc16_ = this.m_Player.position.z <= 7;
            _loc17_ = !!_loc16_?Number(_loc14_):Number(0);
            _loc6_ = this.m_CreatureCount.length - 1;
            while(_loc6_ >= 0)
            {
               this.m_CreatureCount[_loc6_] = 0;
               _loc6_--;
            }
            _loc8_ = 0;
            while(_loc8_ < MAPSIZE_X)
            {
               _loc9_ = 0;
               while(_loc9_ < MAPSIZE_Y)
               {
                  _loc21_ = this.m_WorldMapStorage.getField(_loc8_,_loc9_,_loc10_);
                  if(this.m_OptionsLightEnabled)
                  {
                     _loc6_ = this.m_TiledLightmapRenderer.toColorIndexRed(_loc8_,_loc9_);
                     if(_loc10_ == this.m_PlayerZPlane && _loc10_ > 0)
                     {
                        _loc13_[_loc6_] = _loc13_[_loc6_] * this.m_OptionsLevelSeparator;
                        _loc13_[_loc6_ + 1] = _loc13_[_loc6_ + 1] * this.m_OptionsLevelSeparator;
                        _loc13_[_loc6_ + 2] = _loc13_[_loc6_ + 2] * this.m_OptionsLevelSeparator;
                     }
                     if(_loc10_ == 0 || (_loc11_ = _loc21_.m_ObjectsRenderer[0]) != null && _loc11_.m_Type.isBank)
                     {
                        _loc23_ = _loc13_[_loc6_];
                        _loc24_ = _loc13_[_loc6_ + 1];
                        _loc25_ = _loc13_[_loc6_ + 2];
                        this.m_TiledLightmapRenderer.setFieldBrightness(_loc8_,_loc9_,_loc17_,_loc16_);
                        if(_loc10_ > 0 && _loc21_.m_CacheTranslucent)
                        {
                           _loc23_ = _loc23_ * this.m_OptionsLevelSeparator;
                           _loc24_ = _loc24_ * this.m_OptionsLevelSeparator;
                           _loc25_ = _loc25_ * this.m_OptionsLevelSeparator;
                           if(_loc23_ > _loc13_[_loc6_])
                           {
                              _loc13_[_loc6_] = _loc23_;
                           }
                           if(_loc24_ > _loc13_[_loc6_ + 1])
                           {
                              _loc13_[_loc6_ + 1] = _loc24_;
                           }
                           if(_loc25_ > _loc13_[_loc6_ + 2])
                           {
                              _loc13_[_loc6_ + 2] = _loc25_;
                           }
                        }
                     }
                     if(_loc8_ > 0 && _loc9_ > 0 && _loc10_ < 7 && _loc10_ == this.m_PlayerZPlane + this.m_WorldMapStorage.m_Position.z - 8 && this.m_WorldMapStorage.isTranslucent(_loc8_ - 1,_loc9_ - 1,_loc10_ + 1))
                     {
                        this.m_TiledLightmapRenderer.setFieldBrightness(_loc8_,_loc9_,_loc14_,_loc16_);
                     }
                  }
                  _loc22_ = null;
                  _loc6_ = _loc21_.m_ObjectsCount - 1;
                  while(_loc6_ >= _loc21_.m_CacheObjectsCount)
                  {
                     if(!((_loc11_ = _loc21_.m_ObjectsRenderer[_loc6_]) == null || _loc11_.ID != AppearanceInstance.CREATURE || (_loc22_ = this.m_CreatureStorage.getCreature(_loc11_.data)) == null))
                     {
                        _loc26_ = 0;
                        _loc27_ = 0;
                        if(_loc22_.mountOutfit != null)
                        {
                           _loc26_ = _loc22_.mountOutfit.type.displacementX;
                           _loc27_ = _loc22_.mountOutfit.type.displacementY;
                        }
                        else if(_loc22_.outfit != null)
                        {
                           _loc26_ = _loc22_.outfit.type.displacementX;
                           _loc27_ = _loc22_.outfit.type.displacementY;
                        }
                        _loc28_ = (_loc8_ + 1) * FIELD_SIZE + _loc22_.animationDelta.x - _loc26_;
                        _loc29_ = (_loc9_ + 1) * FIELD_SIZE + _loc22_.animationDelta.y - _loc27_;
                        _loc30_ = int((_loc28_ - 1) / FIELD_SIZE);
                        _loc31_ = int((_loc29_ - 1) / FIELD_SIZE);
                        _loc32_ = _loc31_ * MAPSIZE_X + _loc30_;
                        if(!(_loc32_ < 0 || _loc32_ >= MAPSIZE_X * MAPSIZE_Y))
                        {
                           _loc33_ = this.m_CreatureField[_loc32_];
                           _loc34_ = 0;
                           while(_loc34_ < this.m_CreatureCount[_loc32_] && (_loc35_ = _loc33_[_loc34_]) != null && (_loc35_.y < _loc29_ || _loc35_.y == _loc29_ && _loc35_.x <= _loc28_))
                           {
                              _loc34_++;
                           }
                           if(_loc34_ < MAPSIZE_W)
                           {
                              if(this.m_CreatureCount[_loc32_] < MAPSIZE_W)
                              {
                                 this.m_CreatureCount[_loc32_]++;
                              }
                              _loc35_ = _loc33_[this.m_CreatureCount[_loc32_] - 1];
                              _loc7_ = this.m_CreatureCount[_loc32_] - 1;
                              while(_loc7_ > _loc34_)
                              {
                                 _loc33_[_loc7_] = _loc33_[_loc7_ - 1];
                                 _loc7_--;
                              }
                              _loc33_[_loc34_] = _loc35_;
                              _loc35_.update(_loc22_,_loc28_,_loc29_,_loc10_);
                           }
                        }
                     }
                     _loc6_--;
                  }
                  _loc9_++;
               }
               _loc8_++;
            }
            _loc18_ = null;
            if(this.m_HighlightObject is Creature)
            {
               _loc18_ = this.m_HighlightObject as Creature;
               this.m_ObjectCursor.copyMaskFromCreature(_loc18_);
            }
            else if(this.m_OptionsHighlight > 0 && this.m_HighlightTile != null && this.m_HighlightTile.z == _loc10_)
            {
               if(this.m_HighlightObject != null && this.m_HighlightObject is ObjectInstance)
               {
                  _loc36_ = this.m_HighlightObject as ObjectInstance;
                  if(_loc36_.isCreature)
                  {
                     this.m_ObjectCursor.copyMaskFromCreature(this.m_CreatureStorage.getCreature(_loc36_.data));
                  }
                  else
                  {
                     this.m_WorldMapStorage.toAbsolute(this.m_HighlightTile,this.m_HelperCoordinate);
                     this.m_ObjectCursor.copyMaskFromAppearance(_loc36_,this.m_HelperCoordinate.x,this.m_HelperCoordinate.y,this.m_HelperCoordinate.z);
                  }
               }
               else if(this.m_HighlightObject is Creature)
               {
                  _loc18_ = this.m_HighlightObject as Creature;
                  this.m_ObjectCursor.copyMaskFromCreature(_loc18_);
               }
            }
            else
            {
               this.m_ObjectCursor.clearMask();
            }
            this.m_HelperCoordinate.setComponents(0,0,_loc10_);
            this.m_WorldMapStorage.toAbsolute(this.m_HelperCoordinate,this.m_HelperCoordinate);
            _loc19_ = 0;
            _loc20_ = MAPSIZE_X + MAPSIZE_Y;
            _loc19_ = 0;
            while(_loc19_ < _loc20_)
            {
               _loc9_ = Math.max(_loc19_ - MAPSIZE_X + 1,0);
               _loc8_ = Math.min(_loc19_,MAPSIZE_X - 1);
               while(_loc8_ >= 0 && _loc9_ < MAPSIZE_Y)
               {
                  this.drawField((_loc8_ + 1) * FIELD_SIZE,(_loc9_ + 1) * FIELD_SIZE,this.m_HelperCoordinate.x + _loc8_,this.m_HelperCoordinate.y + _loc9_,this.m_HelperCoordinate.z,_loc8_,_loc9_,_loc10_,true);
                  _loc8_--;
                  _loc9_++;
               }
               _loc19_++;
            }
            if(this.m_OptionsHighlight > 0 && this.m_HighlightTile != null && this.m_HighlightTile.z == _loc10_)
            {
               this.m_TileCursor.drawTo(this.m_MainLayer,(this.m_HighlightTile.x + 1) * FIELD_SIZE,(this.m_HighlightTile.y + 1) * FIELD_SIZE,Tibia.s_FrameTibiaTimestamp);
            }
            _loc10_++;
         }
         this.m_HelperPoint.setTo(0,0);
         this.m_MainLayer.copyPixels(this.m_AtmosphereLayer,this.m_Rectangle,this.m_HelperPoint,null,null,true);
         if(this.m_OptionsLightEnabled && Tibia3D.isReady)
         {
            this.m_TiledLightmapRenderer.createLightmap();
            this.m_MainLayer.draw(this.m_TiledLightmapRenderer.lightmapBitmap,this.m_LightTranslate,null,BlendMode.MULTIPLY,this.m_LightClipRect,true);
         }
         graphics.clear();
         graphics.beginBitmapFill(this.m_MainLayer,this.m_Transform,false,this.m_OptionsAntialiasing);
         graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
         graphics.endFill();
         this.drawCreatureStatus();
         this.drawTextualEffects();
         this.drawOnscreenMessages();
         if(Tibia3D.isReady)
         {
            Tibia3D.context3D.present();
         }
      }
   }
}
