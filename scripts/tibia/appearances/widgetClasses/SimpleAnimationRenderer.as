package tibia.appearances.widgetClasses
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import mx.core.FlexSprite;
   import mx.core.IFlexDisplayObject;
   import tibia.appearances.AppearanceAnimator;
   
   public class SimpleAnimationRenderer extends FlexSprite implements IFlexDisplayObject
   {
      
      private static var s_Rect:Rectangle = new Rectangle();
      
      private static var s_ZeroPoint:Point = new Point(0,0);
       
      
      private var m_Animation:AppearanceAnimator;
      
      private var m_BitmapData:BitmapData;
      
      private var m_Size:int;
      
      private var m_HaveTimer:Boolean = false;
      
      private var m_LocalBitmapCache:BitmapData = null;
      
      private var m_MoveTarget:DisplayObject;
      
      public function SimpleAnimationRenderer()
      {
         super();
      }
      
      public function set size(param1:int) : void
      {
         if(this.m_Size != param1)
         {
            this.m_Size = param1;
            this.draw();
         }
      }
      
      public function set moveTarget(param1:DisplayObject) : void
      {
         if(param1 != this.m_MoveTarget)
         {
            this.m_MoveTarget = param1;
            this.draw();
         }
      }
      
      public function get size() : int
      {
         return this.m_Size;
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         x = param1;
         y = param2;
      }
      
      public function get measuredWidth() : Number
      {
         return this.m_Size;
      }
      
      public function get measuredHeight() : Number
      {
         return this.m_Size;
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         if(this.m_BitmapData != null && this.m_Animation != null)
         {
            this.m_Animation.animate(Tibia.s_FrameTibiaTimestamp);
         }
         this.draw();
      }
      
      public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      public function draw() : void
      {
         var _loc1_:Number = NaN;
         graphics.clear();
         if(this.m_MoveTarget)
         {
            this.move(this.m_MoveTarget.x,this.m_MoveTarget.y);
         }
         if(this.m_BitmapData != null && this.m_Animation != null)
         {
            _loc1_ = this.m_Size;
            s_Rect.width = _loc1_;
            s_Rect.height = _loc1_;
            s_Rect.x = this.m_Animation.phase * _loc1_;
            s_Rect.y = 0;
            this.m_LocalBitmapCache.copyPixels(this.m_BitmapData,s_Rect,s_ZeroPoint);
            graphics.beginBitmapFill(this.m_LocalBitmapCache,null,false,false);
            graphics.drawRect(0,0,_loc1_,_loc1_);
            graphics.endFill();
         }
      }
      
      public function setAnimation(param1:BitmapData, param2:uint, param3:AppearanceAnimator) : void
      {
         this.m_BitmapData = param1;
         this.m_Size = param2;
         this.m_Animation = param3;
         this.m_LocalBitmapCache = new BitmapData(this.m_Size,this.m_Size);
         var _loc4_:Boolean = this.m_BitmapData != null && this.m_Animation != null;
         var _loc5_:Timer = Tibia.s_GetSecondaryTimer();
         if(_loc4_ && !this.m_HaveTimer)
         {
            _loc5_.addEventListener(TimerEvent.TIMER,this.onTimer);
            this.m_HaveTimer = true;
         }
         if(!_loc4_ && this.m_HaveTimer)
         {
            _loc5_.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.m_HaveTimer = false;
         }
         this.draw();
      }
   }
}
