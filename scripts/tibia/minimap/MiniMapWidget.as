package tibia.minimap
{
   import tibia.sidebar.Widget;
   import mx.events.PropertyChangeEvent;
   import tibia.minimap.miniMapWidgetClasses.MiniMapWidgetView;
   import flash.events.Event;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   
   public class MiniMapWidget extends Widget
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const MM_SECTOR_SIZE:int = 256;
      
      protected static const MM_IE_TIMEOUT:Number = 50;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const MM_IO_TIMEOUT:Number = 500;
      
      protected static const MM_SIDEBAR_ZOOM_MIN:int = -1;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const MM_COLOUR_DEFAULT:uint = 0;
      
      protected static const MM_STORAGE_MIN_VERSION:int = 1;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const MM_SIDEBAR_ZOOM_MAX:int = 2;
      
      protected static const MM_SIDEBAR_HIGHLIGHT_DURATION:Number = 10000;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const MM_CACHE_SIZE:int = 48;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MM_STORAGE_MAX_VERSION:int = 1;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MM_SIDEBAR_VIEW_HEIGHT:int = 106;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const MM_SIDEBAR_VIEW_WIDTH:int = 106;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
       
      
      protected var m_HighlightEnd:Number = 0;
      
      protected var m_Zoom:int = 0;
      
      protected var m_PositionX:int = 0;
      
      protected var m_PositionY:int = 0;
      
      protected var m_MiniMapStorage:tibia.minimap.MiniMapStorage = null;
      
      protected var m_PositionZ:int = 0;
      
      public function MiniMapWidget()
      {
         super();
      }
      
      override public function releaseViewInstance() : void
      {
         this.miniMapStorage = null;
         super.releaseViewInstance();
      }
      
      public function get highlightEnd() : Number
      {
         return this.m_HighlightEnd;
      }
      
      protected function onMiniMapStorageChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "position":
                  this.centerPosition();
            }
         }
      }
      
      public function set highlightEnd(param1:Number) : void
      {
         if(this.m_HighlightEnd != param1)
         {
            this.m_HighlightEnd = param1;
            if(m_ViewInstance is MiniMapWidgetView)
            {
               MiniMapWidgetView(m_ViewInstance).highlightEnd = this.m_HighlightEnd;
            }
         }
      }
      
      public function get positionX() : int
      {
         return this.m_PositionX;
      }
      
      public function get positionZ() : int
      {
         return this.m_PositionZ;
      }
      
      public function get zoom() : int
      {
         return this.m_Zoom;
      }
      
      override public function marshall() : XML
      {
         var _loc1_:XML = super.marshall();
         _loc1_.@zoom = this.m_Zoom;
         return _loc1_;
      }
      
      public function translatePosition(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:int = 3 * Math.pow(2,MM_SIDEBAR_ZOOM_MAX - this.m_Zoom);
         this.setPosition(this.m_PositionX + _loc4_ * param1,this.m_PositionY + _loc4_ * param2,this.m_PositionZ + param3);
      }
      
      public function centerPosition() : void
      {
         if(this.m_MiniMapStorage != null)
         {
            this.setPosition(this.m_MiniMapStorage.getPositionX(),this.m_MiniMapStorage.getPositionY(),this.m_MiniMapStorage.getPositionZ());
         }
         else
         {
            this.setPosition(0,0,0);
         }
      }
      
      public function get positionY() : int
      {
         return this.m_PositionY;
      }
      
      public function set zoom(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Event = null;
         param1 = Math.max(MM_SIDEBAR_ZOOM_MIN,Math.min(param1,MM_SIDEBAR_ZOOM_MAX));
         if(this.m_Zoom != param1)
         {
            _loc2_ = this.m_Zoom;
            this.m_Zoom = param1;
            _loc3_ = new Event(Widget.EVENT_OPTIONS_CHANGE);
            dispatchEvent(_loc3_);
            if(_loc3_.cancelable && _loc3_.isDefaultPrevented())
            {
               this.m_Zoom = _loc2_;
            }
            if(m_ViewInstance is MiniMapWidgetView)
            {
               MiniMapWidgetView(m_ViewInstance).zoom = this.m_Zoom;
            }
         }
      }
      
      override public function unmarshall(param1:XML, param2:int) : void
      {
         super.unmarshall(param1,param2);
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@zoom) != null && _loc3_.length() == 1)
         {
            this.zoom = parseInt(_loc3_[0].toString());
         }
      }
      
      public function setPosition(param1:int, param2:int, param3:int) : void
      {
         param1 = Math.max(MAP_MIN_X,Math.min(param1,MAP_MAX_X));
         param2 = Math.max(MAP_MIN_Y,Math.min(param2,MAP_MAX_Y));
         param3 = Math.max(MAP_MIN_Z,Math.min(param3,MAP_MAX_Z));
         if(this.m_PositionX != param1 || this.m_PositionY != param2 || this.m_PositionZ != param3)
         {
            this.m_PositionX = param1;
            this.m_PositionY = param2;
            this.m_PositionZ = param3;
            if(m_ViewInstance is MiniMapWidgetView)
            {
               MiniMapWidgetView(m_ViewInstance).setPosition(this.m_PositionX,this.m_PositionY,this.m_PositionZ);
            }
         }
      }
      
      public function set miniMapStorage(param1:tibia.minimap.MiniMapStorage) : void
      {
         if(this.m_MiniMapStorage != param1)
         {
            if(this.m_MiniMapStorage != null)
            {
               this.m_MiniMapStorage.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMiniMapStorageChange);
               this.m_MiniMapStorage.removeEventListener(tibia.minimap.MiniMapStorage.EVENT_HIGHLIGHT_MARKS,this.onMiniMapStorageEvent);
            }
            this.m_MiniMapStorage = param1;
            if(this.m_MiniMapStorage != null)
            {
               this.m_MiniMapStorage.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMiniMapStorageChange);
               this.m_MiniMapStorage.addEventListener(tibia.minimap.MiniMapStorage.EVENT_HIGHLIGHT_MARKS,this.onMiniMapStorageEvent);
            }
            if(m_ViewInstance is MiniMapWidgetView)
            {
               MiniMapWidgetView(m_ViewInstance).miniMapStorage = this.m_MiniMapStorage;
            }
            this.centerPosition();
         }
      }
      
      public function startHighlight() : void
      {
         this.highlightEnd = Tibia.s_FrameTibiaTimestamp + MM_SIDEBAR_HIGHLIGHT_DURATION;
      }
      
      protected function onMiniMapStorageEvent(param1:Event) : void
      {
         if(param1 != null)
         {
            switch(param1.type)
            {
               case tibia.minimap.MiniMapStorage.EVENT_HIGHLIGHT_MARKS:
                  this.startHighlight();
            }
         }
      }
      
      public function get miniMapStorage() : tibia.minimap.MiniMapStorage
      {
         return this.m_MiniMapStorage;
      }
      
      override public function acquireViewInstance(param1:Boolean = true) : WidgetView
      {
         options = Tibia.s_GetOptions();
         this.miniMapStorage = Tibia.s_GetMiniMapStorage();
         var _loc2_:MiniMapWidgetView = super.acquireViewInstance(param1) as MiniMapWidgetView;
         if(_loc2_ != null)
         {
            _loc2_.options = options;
            _loc2_.highlightEnd = this.m_HighlightEnd;
            _loc2_.miniMapStorage = this.m_MiniMapStorage;
            _loc2_.zoom = this.m_Zoom;
            _loc2_.setPosition(this.m_PositionX,this.m_PositionY,this.m_PositionZ);
         }
         return _loc2_;
      }
   }
}
