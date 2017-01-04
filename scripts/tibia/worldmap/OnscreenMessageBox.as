package tibia.worldmap
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import mx.collections.IList;
   import shared.utility.RingBuffer;
   import shared.utility.Vector3D;
   import tibia.chat.MessageMode;
   
   public class OnscreenMessageBox
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
      public static const FIXING_NONE:int = 0;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      public static const FIXING_Y:int = 2;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      public static const FIXING_BOTH:int = FIXING_X | FIXING_Y;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      public static const FIXING_X:int = 1;
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const GROUND_LAYER:int = 7;
       
      
      protected var m_Messages:RingBuffer = null;
      
      protected var m_X:Number = 0;
      
      protected var m_Visible:Boolean = true;
      
      protected var m_Speaker:String = null;
      
      protected var m_Width:Number = 0;
      
      protected var m_Mode:int = 0;
      
      protected var m_Y:Number = 0;
      
      protected var m_Height:Number = 0;
      
      protected var m_Position:Vector3D = null;
      
      protected var m_Fixing:int = 0;
      
      protected var m_VisibleMessages:int = 0;
      
      protected var m_SpeakerLevel:int = 0;
      
      public function OnscreenMessageBox(param1:Vector3D, param2:String, param3:int, param4:int, param5:int)
      {
         super();
         this.m_Position = param1;
         this.m_Speaker = param2;
         this.m_SpeakerLevel = param3;
         this.m_Mode = param4;
         this.m_Messages = new RingBuffer(param5);
         this.m_Visible = true;
      }
      
      function set y(param1:Number) : void
      {
         this.m_Y = param1;
      }
      
      public function removeMessages() : void
      {
         if(this.m_Messages != null)
         {
            this.m_Messages.removeAll();
         }
      }
      
      function get width() : Number
      {
         return this.m_Width;
      }
      
      public function expireMessages(param1:Number) : int
      {
         var _loc3_:int = 0;
         var _loc4_:OnscreenMessage = null;
         var _loc2_:int = 0;
         if(this.m_Visible)
         {
            _loc3_ = this.getFirstNonHeaderIndex();
            while(this.m_Messages.length > _loc3_)
            {
               _loc4_ = OnscreenMessage(this.m_Messages.getItemAt(_loc3_));
               if(_loc4_.visibleSince + _loc4_.TTL < param1)
               {
                  this.m_Messages.removeItemAt(_loc3_);
                  _loc2_++;
                  continue;
               }
               break;
            }
         }
         return _loc2_;
      }
      
      function get y() : Number
      {
         return this.m_Y;
      }
      
      function set x(param1:Number) : void
      {
         this.m_X = param1;
      }
      
      public function get messages() : IList
      {
         return this.m_Messages;
      }
      
      public function get empty() : Boolean
      {
         return this.m_Messages.length - this.getFirstNonHeaderIndex() <= 0;
      }
      
      public function get speakerLevel() : int
      {
         return this.m_SpeakerLevel;
      }
      
      function get visibleMessages() : int
      {
         return !!this.m_Visible?int(this.m_VisibleMessages):0;
      }
      
      function set fixing(param1:int) : void
      {
         this.m_Fixing = param1;
      }
      
      function getCacheBitmap(param1:int, param2:Rectangle) : BitmapData
      {
         return OnscreenMessage(this.m_Messages.getItemAt(param1)).getCacheBitmap(param2);
      }
      
      public function get mode() : int
      {
         return this.m_Mode;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this.m_Visible = param1;
      }
      
      public function appendMessage(param1:OnscreenMessage) : void
      {
         if(this.m_Messages.length >= this.m_Messages.size)
         {
            this.m_Messages.removeItemAt(this.getFirstNonHeaderIndex());
         }
         this.m_Messages.addItem(param1);
      }
      
      public function get minExpirationTime() : Number
      {
         var _loc4_:OnscreenMessage = null;
         var _loc1_:Number = Number.POSITIVE_INFINITY;
         var _loc2_:int = this.getFirstNonHeaderIndex();
         var _loc3_:int = this.m_Messages.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = OnscreenMessage(this.m_Messages.getItemAt(_loc2_));
            if(_loc4_.visibleSince < Number.POSITIVE_INFINITY)
            {
               _loc1_ = Math.min(_loc4_.visibleSince + _loc4_.TTL,_loc1_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      function get height() : Number
      {
         return this.m_Height;
      }
      
      public function get position() : Vector3D
      {
         return this.m_Position;
      }
      
      function get fixing() : int
      {
         return this.m_Fixing;
      }
      
      public function expireOldestMessage() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         if(this.m_Visible)
         {
            _loc2_ = this.getFirstNonHeaderIndex();
            if(this.m_Messages.length > _loc2_)
            {
               this.m_Messages.removeItemAt(_loc2_);
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function getFirstNonHeaderIndex() : int
      {
         var _loc2_:OnscreenMessage = null;
         var _loc1_:int = 0;
         while(this.m_Messages.length > _loc1_)
         {
            _loc2_ = OnscreenMessage(this.m_Messages.getItemAt(_loc1_));
            if(_loc2_.TTL < Number.POSITIVE_INFINITY)
            {
               break;
            }
            _loc1_++;
         }
         return _loc1_;
      }
      
      function get x() : Number
      {
         return this.m_X;
      }
      
      public function get visible() : Boolean
      {
         return this.m_Visible;
      }
      
      function arrangeMessages() : void
      {
         var _loc1_:OnscreenMessage = null;
         var _loc2_:Rectangle = null;
         this.m_VisibleMessages = 0;
         this.m_Width = 0;
         this.m_Height = 0;
         if(this.m_Visible)
         {
            _loc1_ = null;
            _loc2_ = null;
            switch(this.m_Mode)
            {
               case MessageMode.MESSAGE_SAY:
               case MessageMode.MESSAGE_WHISPER:
               case MessageMode.MESSAGE_YELL:
               case MessageMode.MESSAGE_SPELL:
               case MessageMode.MESSAGE_NPC_FROM:
               case MessageMode.MESSAGE_BARK_LOW:
               case MessageMode.MESSAGE_BARK_LOUD:
                  while(this.m_VisibleMessages < this.m_Messages.length)
                  {
                     _loc1_ = OnscreenMessage(this.m_Messages.getItemAt(this.m_VisibleMessages));
                     _loc2_ = _loc1_.size;
                     if(this.m_Height + _loc2_.height <= ONSCREEN_MESSAGE_HEIGHT)
                     {
                        this.m_VisibleMessages++;
                        this.m_Width = Math.max(this.m_Width,_loc2_.width);
                        this.m_Height = this.m_Height + _loc2_.height;
                        _loc1_.visibleSince = Math.min(Tibia.s_FrameTibiaTimestamp,_loc1_.visibleSince);
                        continue;
                     }
                     break;
                  }
                  break;
               default:
                  if(this.m_Messages.length > 0)
                  {
                     _loc1_ = OnscreenMessage(this.m_Messages.getItemAt(0));
                     _loc2_ = _loc1_.size;
                     this.m_VisibleMessages = 1;
                     this.m_Width = _loc2_.width;
                     this.m_Height = _loc2_.height;
                     _loc1_.visibleSince = Math.min(Tibia.s_FrameTibiaTimestamp,_loc1_.visibleSince);
                  }
            }
         }
      }
      
      public function get speaker() : String
      {
         return this.m_Speaker;
      }
   }
}
