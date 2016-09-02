package tibia.appearances.widgetClasses
{
   import mx.core.FlexShape;
   import mx.core.IFlexDisplayObject;
   import flash.geom.Rectangle;
   import flash.geom.Point;
   import shared.utility.TextFieldCache;
   import flash.geom.Matrix;
   import flash.display.BitmapData;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.FrameGroup;
   import tibia.appearances.OutfitInstance;
   import tibia.appearances.ObjectInstance;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SimpleAppearanceRenderer extends FlexShape implements IFlexDisplayObject
   {
      
      private static var s_Rect:Rectangle = new Rectangle();
      
      private static var s_ZeroPoint:Point = new Point(0,0);
      
      public static const ICON_SIZE:int = 32;
      
      private static var s_TextCache:TextFieldCache = new TextFieldCache(ICON_SIZE,TextFieldCache.DEFAULT_HEIGHT,100,true);
      
      private static var s_Trans:Matrix = new Matrix();
       
      
      private var m_Phase:int = -1;
      
      private var m_LocalAppearanceBitmapCache:BitmapData = null;
      
      private var m_HaveTimer:Boolean = false;
      
      private var m_Overlay:Boolean = true;
      
      private var m_PatternX:int = -1;
      
      private var m_PatternY:int = -1;
      
      private var m_PatternZ:int = -1;
      
      private var m_Appearance:AppearanceInstance = null;
      
      private var m_CacheDirty:Boolean = false;
      
      private var m_Size:int = 32;
      
      private var m_Smooth:Boolean = false;
      
      private var m_Scale:Number = NaN;
      
      public function SimpleAppearanceRenderer()
      {
         super();
      }
      
      public function get size() : int
      {
         return this.m_Size;
      }
      
      public function set size(param1:int) : void
      {
         if(this.m_Size != param1)
         {
            this.m_Size = param1;
            this.draw();
         }
      }
      
      public function get scale() : Number
      {
         return this.m_Scale;
      }
      
      public function get overlay() : Boolean
      {
         return this.m_Overlay;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         if(this.m_Smooth != param1)
         {
            this.m_Smooth = param1;
            this.draw();
         }
      }
      
      public function get appearance() : AppearanceInstance
      {
         return this.m_Appearance;
      }
      
      public function get cacheDirty() : Boolean
      {
         return this.m_CacheDirty;
      }
      
      public function draw() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:CachedSpriteInformation = null;
         var _loc5_:BitmapData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Rectangle = null;
         var _loc9_:int = 0;
         graphics.clear();
         var _loc1_:AppearanceType = null;
         if(this.m_Appearance != null && (_loc1_ = this.m_Appearance.type) != null)
         {
            _loc2_ = NaN;
            _loc3_ = NaN;
            if(isNaN(this.m_Scale))
            {
               _loc2_ = this.m_Size / _loc1_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize;
               _loc3_ = this.m_Size;
            }
            else
            {
               _loc2_ = this.m_Scale;
               _loc3_ = _loc1_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize * this.m_Scale;
            }
            _loc4_ = this.m_Appearance.getSprite(this.m_Phase,this.m_PatternX,this.m_PatternY,this.m_PatternZ);
            this.cacheDirty = _loc4_.cacheMiss;
            if(this.m_LocalAppearanceBitmapCache == null || this.m_LocalAppearanceBitmapCache.width < _loc4_.rectangle.width || this.m_LocalAppearanceBitmapCache.height < _loc4_.rectangle.height)
            {
               this.m_LocalAppearanceBitmapCache = new BitmapData(_loc4_.rectangle.width,_loc4_.rectangle.height);
            }
            this.m_LocalAppearanceBitmapCache.copyPixels(_loc4_.bitmapData,_loc4_.rectangle,s_ZeroPoint);
            _loc5_ = this.m_LocalAppearanceBitmapCache;
            s_Rect.setTo(0,0,_loc4_.rectangle.width,_loc4_.rectangle.height);
            if(_loc5_ != null)
            {
               _loc6_ = this.m_Appearance is OutfitInstance?int(_loc1_.displacementX):0;
               _loc7_ = this.m_Appearance is OutfitInstance?int(_loc1_.displacementY):0;
               s_Trans.a = _loc2_;
               s_Trans.d = _loc2_;
               s_Trans.tx = (-s_Rect.right + _loc1_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize - _loc6_) * _loc2_;
               s_Trans.ty = (-s_Rect.bottom + _loc1_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize - _loc7_) * _loc2_;
               s_Rect.width = Math.min(_loc3_,s_Rect.width * _loc2_);
               s_Rect.height = Math.min(_loc3_,s_Rect.height * _loc2_);
               s_Rect.x = _loc3_ - s_Rect.width - _loc6_ * _loc2_;
               s_Rect.y = _loc3_ - s_Rect.height - _loc7_ * _loc2_;
               graphics.beginBitmapFill(_loc5_,s_Trans,true,this.m_Smooth);
               graphics.drawRect(s_Rect.x,s_Rect.y,s_Rect.width,s_Rect.height);
            }
            if(this.m_Overlay && this.m_Appearance is ObjectInstance && _loc1_.isCumulative)
            {
               _loc8_ = null;
               _loc9_ = ObjectInstance(this.m_Appearance).data;
               if((_loc8_ = s_TextCache.getItem(_loc9_,String(_loc9_),4294967295)) != null)
               {
                  s_Rect.x = _loc3_ - _loc8_.width;
                  s_Rect.y = _loc3_ - _loc8_.height;
                  s_Trans.a = 1;
                  s_Trans.d = 1;
                  s_Trans.tx = -_loc8_.x + s_Rect.x;
                  s_Trans.ty = -_loc8_.y + s_Rect.y;
                  graphics.beginBitmapFill(s_TextCache,s_Trans,false,false);
                  graphics.drawRect(s_Rect.x,s_Rect.y,_loc8_.width,_loc8_.height);
               }
            }
            graphics.endFill();
         }
      }
      
      public function get phase() : int
      {
         return this.m_Phase;
      }
      
      public function set patternX(param1:int) : void
      {
         if(this.m_PatternX != param1)
         {
            this.m_PatternX = param1;
            this.draw();
         }
      }
      
      public function set patternY(param1:int) : void
      {
         if(this.m_PatternY != param1)
         {
            this.m_PatternY = param1;
            this.draw();
         }
      }
      
      public function set patternZ(param1:int) : void
      {
         if(this.m_PatternZ != param1)
         {
            this.m_PatternZ = param1;
            this.draw();
         }
      }
      
      public function get measuredHeight() : Number
      {
         return this.m_Size;
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         var _loc3_:Timer = null;
         var _loc2_:AppearanceType = null;
         if(this.m_Appearance != null && (_loc2_ = this.m_Appearance.type) != null && _loc2_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].isAnimation)
         {
            this.m_Appearance.animate(Tibia.s_FrameTibiaTimestamp);
         }
         else if(this.m_CacheDirty == false)
         {
            _loc3_ = Tibia.s_GetSecondaryTimer();
            _loc3_.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.m_HaveTimer = false;
         }
         this.draw();
      }
      
      public function set overlay(param1:Boolean) : void
      {
         if(this.m_Overlay != param1)
         {
            this.m_Overlay = param1;
            this.draw();
         }
      }
      
      public function set scale(param1:Number) : void
      {
         if(this.m_Scale != param1)
         {
            this.m_Scale = param1;
            this.draw();
         }
      }
      
      public function get smooth() : Boolean
      {
         return this.m_Smooth;
      }
      
      public function get measuredWidth() : Number
      {
         return this.m_Size;
      }
      
      public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      public function set appearance(param1:AppearanceInstance) : void
      {
         var _loc2_:AppearanceType = null;
         var _loc3_:Boolean = false;
         var _loc4_:Timer = null;
         if(this.m_Appearance != param1)
         {
            this.m_Appearance = param1;
            this.m_Phase = -1;
            this.m_PatternX = -1;
            this.m_PatternY = -1;
            this.m_PatternZ = -1;
            _loc2_ = null;
            _loc3_ = this.m_Appearance != null && (_loc2_ = this.m_Appearance.type) != null && _loc2_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].isAnimation;
            _loc4_ = Tibia.s_GetSecondaryTimer();
            if(_loc3_ && !this.m_HaveTimer)
            {
               _loc4_.addEventListener(TimerEvent.TIMER,this.onTimer);
               this.m_HaveTimer = true;
            }
            if(!_loc3_ && this.m_HaveTimer)
            {
               _loc4_.removeEventListener(TimerEvent.TIMER,this.onTimer);
               this.m_HaveTimer = false;
            }
            this.draw();
         }
      }
      
      public function get patternY() : int
      {
         return this.m_PatternY;
      }
      
      public function get patternZ() : int
      {
         return this.m_PatternZ;
      }
      
      public function get patternX() : int
      {
         return this.m_PatternX;
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         x = param1;
         y = param2;
      }
      
      public function set cacheDirty(param1:Boolean) : void
      {
         var _loc2_:Timer = null;
         this.m_CacheDirty = param1;
         if(this.m_CacheDirty && this.m_HaveTimer == false)
         {
            _loc2_ = Tibia.s_GetSecondaryTimer();
            _loc2_.addEventListener(TimerEvent.TIMER,this.onTimer);
            this.m_HaveTimer = true;
         }
      }
      
      public function set phase(param1:int) : void
      {
         if(this.m_Phase != param1)
         {
            this.m_Phase = param1;
            this.draw();
         }
      }
   }
}
