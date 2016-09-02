package tibia.worldmap
{
   import shared.utility.BitmapCache;
   import tibia.worldmap.widgetClasses.OnscreenMessageCache;
   import flash.geom.Rectangle;
   import shared.utility.StringHelper;
   import tibia.chat.MessageMode;
   import flash.display.BitmapData;
   
   public class OnscreenMessage
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const MAP_WIDTH:int = 15;
      
      private static var s_CacheBitmap:BitmapCache = new OnscreenMessageCache(ONSCREEN_MESSAGE_WIDTH,ONSCREEN_MESSAGE_HEIGHT,8 * NUM_ONSCREEN_MESSAGES);
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      private static var s_NextID:int = 0;
      
      protected static const GROUND_LAYER:int = 7;
       
      
      protected var m_TTL:Number = NaN;
      
      protected var m_Speaker:String = null;
      
      protected var m_Mode:int;
      
      protected var m_CacheText:String = null;
      
      protected var m_Text:String = null;
      
      protected var m_VisibleSince:Number = NaN;
      
      protected var m_ID:int = 0;
      
      protected var m_CacheSize:Rectangle = null;
      
      protected var m_SpeakerLevel:int = 0;
      
      public function OnscreenMessage(param1:int, param2:String, param3:int, param4:int, param5:String)
      {
         this.m_Mode = MessageMode.MESSAGE_NONE;
         super();
         if(param1 <= 0)
         {
            this.m_ID = --s_NextID;
         }
         else
         {
            this.m_ID = param1;
         }
         this.m_Speaker = param2;
         this.m_SpeakerLevel = param3;
         this.m_Mode = param4;
         this.m_Text = param5;
         this.m_VisibleSince = Number.POSITIVE_INFINITY;
         this.m_TTL = (30 + this.m_Text.length / 3) * 100;
      }
      
      public function get speakerLevel() : int
      {
         return this.m_SpeakerLevel;
      }
      
      function get size() : Rectangle
      {
         return this.m_CacheSize;
      }
      
      function get TTL() : Number
      {
         return this.m_TTL;
      }
      
      public function formatMessage(param1:String, param2:uint, param3:uint) : void
      {
         this.m_CacheText = StringHelper.s_HTMLSpecialChars(this.m_Text);
         if(this.m_Mode == MessageMode.MESSAGE_NPC_FROM)
         {
            this.m_CacheText = StringHelper.s_HilightToHTML(this.m_CacheText,param3);
         }
         if(param1 != null)
         {
            this.m_CacheText = param1 + this.m_CacheText;
         }
         this.m_CacheText = "<p align=\"center\">" + "<font color=\"#" + (param2 & 16777215).toString(16) + "\">" + this.m_CacheText + "</font>" + "</p>";
         this.m_CacheSize = s_CacheBitmap.getItem(this.m_ID,this.m_CacheText);
      }
      
      function set visibleSince(param1:Number) : void
      {
         this.m_VisibleSince = param1;
      }
      
      function set TTL(param1:Number) : void
      {
         this.m_TTL = param1;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function get mode() : int
      {
         return this.m_Mode;
      }
      
      function get visibleSince() : Number
      {
         return this.m_VisibleSince;
      }
      
      public function get text() : String
      {
         return this.m_Text;
      }
      
      function getCacheBitmap(param1:Rectangle) : BitmapData
      {
         if(this.m_CacheText != null)
         {
            param1.copyFrom(s_CacheBitmap.getItem(this.m_ID,this.m_CacheText));
            return s_CacheBitmap;
         }
         return null;
      }
      
      public function get speaker() : String
      {
         return this.m_Speaker;
      }
   }
}
