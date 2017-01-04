package tibia.minimap.miniMapWidgetClasses
{
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import mx.controls.ToolTip;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.ToolTipManager;
   import shared.utility.Vector3D;
   import tibia.minimap.MiniMapSector;
   import tibia.minimap.MiniMapStorage;
   
   public class MiniMapRenderer extends UIComponent
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
      
      protected static const CROSS_POINTS:Array = [-1,-1,-3,-1,-3,1,-1,1,-1,3,1,3,1,1,3,1,3,-1,1,-1,1,-3,-1,-3,-1,-1];
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const MM_SIDEBAR_VIEW_WIDTH:int = 106;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
       
      
      private var m_UncommittedZoom:Boolean = false;
      
      protected var m_Zoom:int = -2.147483648E9;
      
      private var m_UncommittedMiniMapStorage:Boolean = false;
      
      protected var m_ToolTipInstance:ToolTip = null;
      
      protected var m_HighlightToggle:Boolean = false;
      
      private var m_UncommittedHighlightEnd:Boolean = false;
      
      protected var m_HighlightEnd:Number = 0;
      
      protected var m_ToolTipPosition:Point = null;
      
      protected var m_HighlightListenerRegistered:Boolean = false;
      
      protected var m_ZoomScale:Number = 1.0;
      
      protected var m_ToolTipTimer:Timer = null;
      
      private var m_UncommittedPosition:Boolean = false;
      
      protected var m_PositionX:int = -1;
      
      protected var m_PositionY:int = -1;
      
      protected var m_PositionRect:Rectangle = null;
      
      protected var m_PositionZ:int = -1;
      
      protected var m_MiniMapStorage:MiniMapStorage;
      
      public function MiniMapRenderer()
      {
         super();
         this.m_PositionRect = new Rectangle(0,0,0,0);
         this.m_ToolTipPosition = new Point();
         this.m_ToolTipTimer = new Timer(0,1);
         this.m_ToolTipTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onToolTip);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onToolTip);
         addEventListener(MouseEvent.MOUSE_OUT,this.onToolTip);
      }
      
      public function get highlightEnd() : Number
      {
         return this.m_HighlightEnd;
      }
      
      protected function onToolTip(param1:Event) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         if(param1 != null)
         {
            this.hideToolTip();
            switch(param1.type)
            {
               case MouseEvent.MOUSE_MOVE:
                  this.m_ToolTipPosition.x = (param1 as MouseEvent).stageX;
                  this.m_ToolTipPosition.y = (param1 as MouseEvent).stageY;
                  this.m_ToolTipTimer.delay = ToolTipManager.showDelay;
                  this.m_ToolTipTimer.start();
                  break;
               case MouseEvent.MOUSE_OUT:
                  this.m_ToolTipTimer.delay = 0;
                  this.m_ToolTipTimer.stop();
                  break;
               case TimerEvent.TIMER_COMPLETE:
                  _loc2_ = globalToLocal(this.m_ToolTipPosition);
                  _loc3_ = this.pointToMark(_loc2_.x,_loc2_.y);
                  _loc4_ = null;
                  if(_loc3_ != null && (_loc4_ = _loc3_.text) != null && _loc4_.length > 0)
                  {
                     this.m_ToolTipInstance = ToolTipManager.createToolTip(_loc4_,this.m_ToolTipPosition.x + 10,this.m_ToolTipPosition.y + 10) as ToolTip;
                  }
            }
         }
      }
      
      protected function onMiniMapStorageChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property as String)
            {
               case "sector":
                  invalidateDisplayList();
            }
         }
      }
      
      public function set highlightEnd(param1:Number) : void
      {
         if(this.m_HighlightEnd != param1)
         {
            this.m_HighlightEnd = param1;
            this.m_UncommittedHighlightEnd = true;
            invalidateProperties();
         }
      }
      
      public function pointToMark(param1:Number, param2:Number) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc7_:Vector.<MiniMapSector> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:MiniMapSector = null;
         var _loc12_:Array = null;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         if(this.m_PositionRect != null && !this.m_PositionRect.isEmpty() && this.m_ZoomScale > 0 && this.m_MiniMapStorage != null)
         {
            _loc3_ = Math.ceil(MiniMapStorage.MARK_ICON_SIZE / 2);
            _loc4_ = 0;
            _loc5_ = Number.POSITIVE_INFINITY;
            _loc6_ = null;
            _loc7_ = new Vector.<MiniMapSector>();
            _loc8_ = 0;
            while(_loc8_ < 4)
            {
               _loc9_ = this.m_PositionRect.x + _loc8_ % 2 * this.m_PositionRect.width;
               _loc10_ = this.m_PositionRect.y + int(_loc8_ / 2) * this.m_PositionRect.height;
               _loc11_ = this.m_MiniMapStorage.acquireSector(_loc9_,_loc10_,this.m_PositionZ,false);
               if(!(_loc11_ == null || _loc7_.indexOf(_loc11_) > -1))
               {
                  _loc12_ = _loc11_.marks;
                  _loc13_ = 0;
                  _loc14_ = _loc12_.length - 1;
                  while(_loc14_ >= 0)
                  {
                     if((_loc13_ = _loc12_[_loc14_]) != null)
                     {
                        _loc4_ = Math.max(Math.abs((_loc13_.x - this.m_PositionRect.x) * this.m_ZoomScale - param1),Math.abs((_loc13_.y - this.m_PositionRect.y) * this.m_ZoomScale - param2));
                        if(_loc4_ < _loc3_ && _loc4_ < _loc5_)
                        {
                           _loc5_ = _loc4_;
                           _loc6_ = _loc13_;
                        }
                     }
                     _loc14_--;
                  }
                  _loc7_.push(_loc11_);
               }
               _loc8_++;
            }
            return _loc6_;
         }
         return null;
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         if(param1 != null)
         {
            if(Tibia.s_FrameTibiaTimestamp >= this.m_HighlightEnd)
            {
               this.m_HighlightEnd = 0;
               this.m_UncommittedHighlightEnd = true;
               invalidateProperties();
               this.m_HighlightToggle = false;
               invalidateDisplayList();
            }
            else if(this.m_HighlightToggle != Tibia.s_GetFrameFlash())
            {
               this.m_HighlightToggle = Tibia.s_GetFrameFlash();
               invalidateDisplayList();
            }
         }
      }
      
      public function setPosition(param1:int, param2:int, param3:int) : void
      {
         if(this.m_PositionX != param1 || this.m_PositionY != param2 || this.m_PositionZ != param3)
         {
            this.m_PositionX = param1;
            this.m_PositionY = param2;
            this.m_PositionZ = param3;
            this.m_UncommittedPosition = true;
            invalidateProperties();
            this.m_PositionRect.setEmpty();
         }
      }
      
      public function set zoom(param1:int) : void
      {
         if(this.m_Zoom != param1)
         {
            this.m_Zoom = param1;
            this.m_UncommittedZoom = true;
            invalidateProperties();
            this.m_ZoomScale = Math.pow(2,this.m_Zoom);
            this.m_PositionRect.setEmpty();
         }
      }
      
      public function get miniMapStorage() : MiniMapStorage
      {
         return this.m_MiniMapStorage;
      }
      
      protected function hideToolTip() : void
      {
         if(this.m_ToolTipInstance != null)
         {
            ToolTipManager.destroyToolTip(this.m_ToolTipInstance);
            this.m_ToolTipInstance = null;
         }
      }
      
      public function pointToAbsolute(param1:Number, param2:Number, param3:Vector3D = null) : Vector3D
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.m_PositionRect != null && !this.m_PositionRect.isEmpty())
         {
            _loc4_ = this.m_PositionRect.x + param1 / this.m_ZoomScale;
            _loc5_ = this.m_PositionRect.y + param2 / this.m_ZoomScale;
            _loc6_ = this.m_PositionZ;
            if(param3 == null)
            {
               param3 = new Vector3D(_loc4_,_loc5_,_loc6_);
            }
            else
            {
               param3.x = _loc4_;
               param3.y = _loc5_;
               param3.z = _loc6_;
            }
            return param3;
         }
         return null;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Timer = null;
         super.commitProperties();
         if(this.m_UncommittedMiniMapStorage)
         {
            this.hideToolTip();
            invalidateDisplayList();
            this.m_UncommittedMiniMapStorage = false;
         }
         if(this.m_UncommittedZoom)
         {
            this.hideToolTip();
            invalidateDisplayList();
            this.m_UncommittedZoom = false;
         }
         if(this.m_UncommittedPosition)
         {
            this.hideToolTip();
            invalidateDisplayList();
            this.m_UncommittedPosition = false;
         }
         if(this.m_UncommittedHighlightEnd)
         {
            _loc1_ = Tibia.s_GetSecondaryTimer();
            if(Tibia.s_FrameTibiaTimestamp < this.m_HighlightEnd)
            {
               if(!this.m_HighlightListenerRegistered)
               {
                  _loc1_.addEventListener(TimerEvent.TIMER,this.onTimer);
                  this.m_HighlightListenerRegistered = true;
               }
            }
            else if(this.m_HighlightListenerRegistered)
            {
               _loc1_.removeEventListener(TimerEvent.TIMER,this.onTimer);
               this.m_HighlightListenerRegistered = false;
            }
            invalidateDisplayList();
            this.m_UncommittedHighlightEnd = false;
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
      
      public function get positionY() : int
      {
         return this.m_PositionY;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = MM_SIDEBAR_VIEW_WIDTH;
         measuredWidth = MM_SIDEBAR_VIEW_WIDTH;
         measuredMinHeight = MM_SIDEBAR_VIEW_HEIGHT;
         measuredHeight = MM_SIDEBAR_VIEW_HEIGHT;
      }
      
      public function set miniMapStorage(param1:MiniMapStorage) : void
      {
         if(this.m_MiniMapStorage != param1)
         {
            if(this.m_MiniMapStorage != null)
            {
               this.m_MiniMapStorage.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMiniMapStorageChange);
            }
            this.m_MiniMapStorage = param1;
            if(this.m_MiniMapStorage != null)
            {
               this.m_MiniMapStorage.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMiniMapStorageChange);
            }
            this.m_UncommittedMiniMapStorage = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Matrix = null;
         var _loc6_:Vector.<MiniMapSector> = null;
         var _loc7_:MiniMapSector = null;
         var _loc8_:Vector3D = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:BitmapData = null;
         var _loc15_:Rectangle = null;
         var _loc16_:Rectangle = null;
         var _loc17_:Rectangle = null;
         var _loc18_:uint = 0;
         var _loc19_:Array = null;
         var _loc20_:Object = null;
         this.m_PositionRect.setEmpty();
         graphics.clear();
         graphics.beginFill(MM_COLOUR_DEFAULT,1);
         graphics.drawRect(0,0,MM_SIDEBAR_VIEW_WIDTH,MM_SIDEBAR_VIEW_HEIGHT);
         if(this.m_MiniMapStorage != null && (this.m_PositionX >= MAP_MIN_X && this.m_PositionX <= MAP_MAX_X) && (this.m_PositionY >= MAP_MIN_Y && this.m_PositionY <= MAP_MAX_Y) && (this.m_PositionZ >= MAP_MIN_Z && this.m_PositionZ <= MAP_MAX_Z))
         {
            _loc3_ = MM_SIDEBAR_VIEW_WIDTH / this.m_ZoomScale;
            _loc4_ = MM_SIDEBAR_VIEW_HEIGHT / this.m_ZoomScale;
            this.m_PositionRect.x = this.m_PositionX - _loc3_ / 2;
            this.m_PositionRect.y = this.m_PositionY - _loc4_ / 2;
            this.m_PositionRect.width = _loc3_;
            this.m_PositionRect.height = _loc4_;
            _loc5_ = new Matrix(this.m_ZoomScale,0,0,this.m_ZoomScale,0,0);
            _loc6_ = new Vector.<MiniMapSector>();
            _loc7_ = null;
            _loc8_ = new Vector3D();
            _loc9_ = 0;
            _loc10_ = 0;
            _loc11_ = 0;
            _loc9_ = 0;
            while(_loc9_ < 4)
            {
               _loc8_.x = this.m_PositionRect.x + _loc9_ % 2 * this.m_PositionRect.width;
               _loc8_.y = this.m_PositionRect.y + int(_loc9_ / 2) * this.m_PositionRect.height;
               _loc8_.z = this.m_PositionZ;
               _loc7_ = this.m_MiniMapStorage.acquireSector(_loc8_.x,_loc8_.y,_loc8_.z,false);
               if(_loc6_.indexOf(_loc7_) <= -1)
               {
                  _loc6_.push(_loc7_);
                  _loc16_ = new Rectangle(_loc7_.getSectorX(),_loc7_.getSectorY(),MM_SECTOR_SIZE,MM_SECTOR_SIZE);
                  _loc17_ = this.m_PositionRect.intersection(_loc16_);
                  _loc5_.tx = (_loc16_.x - this.m_PositionRect.x) * this.m_ZoomScale;
                  _loc5_.ty = (_loc16_.y - this.m_PositionRect.y) * this.m_ZoomScale;
                  graphics.beginBitmapFill(_loc7_.bitmapData,_loc5_,false,false);
                  graphics.drawRect((_loc17_.x - this.m_PositionRect.x) * this.m_ZoomScale,(_loc17_.y - this.m_PositionRect.y) * this.m_ZoomScale,_loc17_.width * this.m_ZoomScale,_loc17_.height * this.m_ZoomScale);
               }
               _loc9_++;
            }
            _loc12_ = 0;
            _loc13_ = 0;
            _loc8_.setComponents(this.m_MiniMapStorage.getPositionX(),this.m_MiniMapStorage.getPositionY(),this.m_MiniMapStorage.getPositionZ());
            if(this.m_PositionRect.left <= _loc8_.x && _loc8_.x <= this.m_PositionRect.right && this.m_PositionRect.top <= _loc8_.y && _loc8_.y <= this.m_PositionRect.bottom && this.m_PositionZ == _loc8_.z)
            {
               _loc18_ = this.m_MiniMapStorage.getFieldColour(_loc8_.x,_loc8_.y,_loc8_.z);
               if((_loc18_ & 65280) == 65280)
               {
                  _loc18_ = 0;
               }
               else
               {
                  _loc18_ = 16777215;
               }
               _loc12_ = (_loc8_.x - this.m_PositionRect.left) * this.m_ZoomScale;
               _loc13_ = (_loc8_.y - this.m_PositionRect.top) * this.m_ZoomScale;
               graphics.beginFill(_loc18_,1);
               graphics.moveTo(_loc12_ + CROSS_POINTS[0],_loc13_ + CROSS_POINTS[1]);
               _loc9_ = 2;
               _loc10_ = CROSS_POINTS.length;
               while(_loc9_ < _loc10_)
               {
                  graphics.lineTo(Math.max(0,Math.min(_loc12_ + CROSS_POINTS[_loc9_ + 0])),Math.max(0,Math.min(_loc13_ + CROSS_POINTS[_loc9_ + 1])));
                  _loc9_ = _loc9_ + 2;
               }
            }
            _loc14_ = null;
            _loc15_ = new Rectangle();
            _loc5_.a = 1;
            _loc5_.d = 1;
            _loc9_ = _loc6_.length - 1;
            while(_loc9_ >= 0)
            {
               _loc19_ = _loc6_[_loc9_].marks;
               _loc20_ = null;
               _loc10_ = 0;
               _loc11_ = _loc19_.length;
               while(_loc10_ < _loc11_)
               {
                  if((_loc20_ = _loc19_[_loc10_]) != null && this.m_PositionRect.left <= _loc20_.x && _loc20_.x <= this.m_PositionRect.right && this.m_PositionRect.top <= _loc20_.y && _loc20_.y <= this.m_PositionRect.bottom && 0 <= _loc20_.icon && _loc20_.icon < MiniMapStorage.MARK_ICON_COUNT)
                  {
                     _loc14_ = MiniMapStorage.s_GetMarkIcon(_loc20_.icon,this.m_HighlightToggle,_loc15_);
                     _loc12_ = (_loc20_.x - this.m_PositionRect.left) * this.m_ZoomScale - int(_loc15_.width / 2);
                     _loc13_ = (_loc20_.y - this.m_PositionRect.top) * this.m_ZoomScale - int(_loc15_.height / 2);
                     _loc5_.tx = -_loc15_.x + _loc12_;
                     _loc5_.ty = -_loc15_.y + _loc13_;
                     if(_loc12_ < 0)
                     {
                        _loc15_.width = _loc15_.width + _loc12_;
                        _loc12_ = 0;
                     }
                     else
                     {
                        _loc15_.width = Math.min(MM_SIDEBAR_VIEW_WIDTH - _loc12_,_loc15_.width);
                     }
                     if(_loc13_ < 0)
                     {
                        _loc15_.height = _loc15_.height + _loc13_;
                        _loc13_ = 0;
                     }
                     else
                     {
                        _loc15_.height = Math.min(MM_SIDEBAR_VIEW_HEIGHT - _loc13_,_loc15_.height);
                     }
                     graphics.beginBitmapFill(_loc14_,_loc5_,false,false);
                     graphics.drawRect(_loc12_,_loc13_,_loc15_.width,_loc15_.height);
                  }
                  _loc10_++;
               }
               _loc9_--;
            }
         }
         graphics.endFill();
      }
   }
}
