package tibia.help
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.UIComponent;
   import mx.effects.Fade;
   import mx.effects.Move;
   import mx.effects.Pause;
   import mx.effects.Sequence;
   import mx.events.EffectEvent;
   import shared.utility.Colour;
   
   public class ArrowHint extends UIComponent
   {
      
      private static const ARROW_OFFSET_Y:int = -75;
      
      private static const ARROW_HINT:BitmapData = Bitmap(new ARROW_HINT_CLASS()).bitmapData;
      
      public static const ARROW_RIGHT:uint = 2;
      
      private static const MOVE_DISTANCE:uint = 30;
      
      private static const ARROW_OFFSET_X:int = -75;
      
      public static const ARROW_UP:uint = 1;
      
      private static var s_TempColor:Colour = new Colour();
      
      private static const ARROW_HINT_CLASS:Class = ArrowHint_ARROW_HINT_CLASS;
      
      public static const ARROW_DOWN:uint = 3;
      
      public static const ARROW_LEFT:uint = 0;
      
      private static const PHASES:uint = 4;
       
      
      private var m_CurrentArrow:uint = 0;
      
      private var m_MoveBack:Move = null;
      
      private var m_ArrowGraphicsRectangle:Rectangle = null;
      
      private var m_MoveAway:Move = null;
      
      private var m_Position:Point = null;
      
      private var m_GlowColor:uint = 1998756351;
      
      private var m_Sequence:Sequence = null;
      
      public function ArrowHint(param1:Point)
      {
         super();
         this.m_Position = param1;
         this.initializeMoveSequence();
         this.m_ArrowGraphicsRectangle = new Rectangle(0,0,ARROW_HINT.width / PHASES,ARROW_HINT.height);
         cacheAsBitmap = true;
         mouseFocusEnabled = false;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function get arrow() : uint
      {
         return this.m_CurrentArrow;
      }
      
      public function updateArrowPosition(param1:Point) : void
      {
         var _loc2_:Boolean = this.m_Sequence.isPlaying;
         if(this.m_MoveAway.xFrom != param1.x + ARROW_OFFSET_X || this.m_MoveAway.yFrom != param1.y + ARROW_OFFSET_Y)
         {
            if(_loc2_)
            {
               this.m_Sequence.end();
            }
            this.m_MoveAway.xFrom = param1.x + ARROW_OFFSET_X;
            this.m_MoveAway.yFrom = param1.y + ARROW_OFFSET_Y;
            this.m_MoveAway.xTo = this.m_MoveAway.xFrom + MOVE_DISTANCE;
            this.m_MoveAway.yTo = this.m_MoveAway.yFrom;
            this.m_MoveBack.xFrom = this.m_MoveAway.xTo;
            this.m_MoveBack.yFrom = this.m_MoveAway.yTo;
            this.m_MoveBack.xTo = this.m_MoveAway.xFrom;
            this.m_MoveBack.yTo = this.m_MoveAway.yFrom;
            if(_loc2_)
            {
               this.m_Sequence.play();
            }
         }
      }
      
      public function set arrow(param1:uint) : void
      {
         this.m_CurrentArrow = param1;
         invalidateDisplayList();
      }
      
      public function get glowColor() : uint
      {
         return this.m_GlowColor;
      }
      
      public function set repeatCount(param1:uint) : void
      {
         this.m_Sequence.repeatCount = param1;
      }
      
      private function initializeMoveSequence() : void
      {
         this.m_Sequence = new Sequence();
         this.m_Sequence.target = this;
         this.m_MoveAway = new Move();
         this.m_MoveAway.duration = 500;
         this.m_Sequence.addChild(this.m_MoveAway);
         var _loc1_:Pause = new Pause();
         _loc1_.duration = 200;
         this.m_Sequence.addChild(_loc1_);
         this.m_MoveBack = new Move();
         this.m_MoveBack.duration = 500;
         this.m_Sequence.addChild(this.m_MoveBack);
         this.updateArrowPosition(this.m_Position);
         this.m_Sequence.repeatCount = int.MAX_VALUE;
      }
      
      public function set glowColor(param1:uint) : void
      {
         this.m_GlowColor = param1;
         invalidateDisplayList();
      }
      
      public function hide() : void
      {
         var Me:ArrowHint = null;
         Me = this;
         this.m_Sequence.end();
         var FadeEffect:Fade = new Fade();
         FadeEffect.alphaFrom = this.alpha;
         FadeEffect.alphaTo = 0;
         FadeEffect.duration = 500;
         FadeEffect.play([this]);
         FadeEffect.addEventListener(EffectEvent.EFFECT_END,function(param1:Event):void
         {
            TransparentHintLayer.getInstance().removeChild(Me);
            EventDispatcher(param1.target).removeEventListener(param1.type,arguments.callee);
         });
      }
      
      public function get repeatCount() : uint
      {
         return this.m_Sequence.repeatCount;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         graphics.clear();
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(this.m_CurrentArrow * this.m_ArrowGraphicsRectangle.width * -1,0);
         graphics.beginBitmapFill(ARROW_HINT,_loc3_);
         graphics.drawRect(0,0,this.m_ArrowGraphicsRectangle.width,this.m_ArrowGraphicsRectangle.height);
         graphics.endFill();
         s_TempColor.ARGB = this.m_GlowColor;
         var _loc4_:GlowFilter = new GlowFilter();
         _loc4_.color = s_TempColor.RGB;
         _loc4_.alpha = s_TempColor.alphaFloat;
         _loc4_.blurX = 40;
         _loc4_.blurY = 40;
         _loc4_.strength = 5;
         _loc4_.quality = BitmapFilterQuality.HIGH;
         this.filters = [_loc4_];
      }
      
      public function show() : void
      {
         this.alpha = 0;
         TransparentHintLayer.getInstance().addChild(this);
         var _loc1_:Fade = new Fade();
         _loc1_.alphaFrom = this.alpha;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 500;
         _loc1_.play([this]);
         this.m_Sequence.play();
      }
   }
}
