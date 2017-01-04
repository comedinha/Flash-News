package tibia.help
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import mx.core.UIComponent;
   import mx.effects.Effect;
   import mx.effects.Fade;
   import mx.effects.Move;
   import mx.effects.Parallel;
   import mx.effects.Pause;
   import mx.effects.Sequence;
   import mx.effects.SetPropertyAction;
   import mx.events.EffectEvent;
   import shared.utility.Colour;
   
   public class MouseButtonHint extends UIComponent
   {
      
      private static var SEMI_TRANSPARENT_MOUSE_BUTTON_BITMAP:BitmapData = null;
      
      public static const CROSSHAIR_LEFT_MOUSE_BUTTON:uint = 1;
      
      private static const MOUSE_CURSOR_OFFSET_X:int = -10;
      
      public static const DEFAULT_NO_MOUSE_BUTTON:uint = 2;
      
      public static const DEFAULT_LEFT_MOUSE_BUTTON:uint = 3;
      
      private static var s_TempColor:Colour = new Colour();
      
      private static const MOUSE_BUTTON_HINT_CLASS:Class = MouseButtonHint_MOUSE_BUTTON_HINT_CLASS;
      
      public static const CROSSHAIR_NO_MOUSE_BUTTON:uint = 0;
      
      private static const MOUSE_BUTTON_HINT:BitmapData = Bitmap(new MOUSE_BUTTON_HINT_CLASS()).bitmapData;
      
      private static const MOUSE_CURSOR_OFFSET_Y:int = -9;
      
      private static const PHASES:uint = 4;
       
      
      private var m_HintText:String = null;
      
      private var m_UITextField:TextField;
      
      private var m_GlowColor:uint = 3.00309533E9;
      
      private var m_MouseGraphicsRectangle:Rectangle = null;
      
      private var m_Sequence:Sequence = null;
      
      private var m_MouseButtonPhase:uint = 0;
      
      public function MouseButtonHint()
      {
         this.m_UITextField = new TextField();
         super();
         this.m_MouseGraphicsRectangle = new Rectangle(0,0,MOUSE_BUTTON_HINT.width / PHASES,MOUSE_BUTTON_HINT.height);
         if(SEMI_TRANSPARENT_MOUSE_BUTTON_BITMAP == null)
         {
            SEMI_TRANSPARENT_MOUSE_BUTTON_BITMAP = new BitmapData(MOUSE_BUTTON_HINT.width,MOUSE_BUTTON_HINT.height,true,0);
            SEMI_TRANSPARENT_MOUSE_BUTTON_BITMAP.merge(MOUSE_BUTTON_HINT,MOUSE_BUTTON_HINT.rect,MOUSE_BUTTON_HINT.rect.topLeft,255,255,255,255 * 0.7);
         }
         cacheAsBitmap = true;
         mouseFocusEnabled = false;
         mouseEnabled = false;
         mouseChildren = false;
         this.m_Sequence = new Sequence();
         this.m_Sequence.target = this;
      }
      
      public function get phase() : uint
      {
         return this.m_MouseButtonPhase;
      }
      
      public function get repeatCount() : uint
      {
         return this.m_Sequence.repeatCount;
      }
      
      public function show() : void
      {
         TransparentHintLayer.getInstance().addChild(this);
      }
      
      public function addFadeIn(param1:Number, param2:uint = 200) : void
      {
         var _loc3_:Fade = new Fade();
         _loc3_.alphaFrom = 0;
         _loc3_.alphaTo = param1;
         _loc3_.duration = param2;
         this.m_Sequence.addChild(_loc3_);
      }
      
      public function addFadeOut(param1:Number, param2:uint = 200) : void
      {
         var _loc3_:Fade = new Fade();
         _loc3_.alphaFrom = param1;
         _loc3_.alphaTo = 0;
         _loc3_.duration = param2;
         this.m_Sequence.addChild(_loc3_);
      }
      
      public function addMove(param1:Point, param2:Point, param3:uint) : void
      {
         var _loc4_:Move = new Move();
         _loc4_.xFrom = param1.x + MOUSE_CURSOR_OFFSET_X;
         _loc4_.yFrom = param1.y + MOUSE_CURSOR_OFFSET_Y;
         _loc4_.xTo = param2.x + MOUSE_CURSOR_OFFSET_X;
         _loc4_.yTo = param2.y + MOUSE_CURSOR_OFFSET_Y;
         _loc4_.duration = param3;
         this.m_Sequence.addChild(_loc4_);
      }
      
      public function get hintText() : String
      {
         return this.m_HintText;
      }
      
      public function addPause(param1:uint = 1000) : void
      {
         var _loc2_:Pause = new Pause();
         _loc2_.duration = param1;
         this.m_Sequence.addChild(_loc2_);
      }
      
      public function get glowColor() : uint
      {
         return this.m_GlowColor;
      }
      
      public function hide() : void
      {
         TransparentHintLayer.getInstance().removeChild(this);
      }
      
      override protected function createChildren() : void
      {
         this.m_UITextField.text = "";
         this.m_UITextField.x = 0;
         this.m_UITextField.y = this.m_MouseGraphicsRectangle.height;
         addChild(this.m_UITextField);
      }
      
      private function onMouseButtonHintEnd(param1:EffectEvent) : void
      {
         var _loc2_:Event = null;
         if(param1.currentTarget == this.m_Sequence)
         {
            _loc2_ = new Event(Event.COMPLETE);
            dispatchEvent(_loc2_);
         }
         else
         {
            param1.stopImmediatePropagation();
         }
      }
      
      public function addHintTextChange(param1:String, param2:uint = 0, param3:Boolean = false) : void
      {
         var _loc7_:Fade = null;
         var _loc4_:Parallel = new Parallel();
         _loc4_.duration = param2;
         var _loc5_:SetPropertyAction = null;
         _loc5_ = new SetPropertyAction();
         _loc5_.name = "hintText";
         _loc5_.value = param1;
         if(!param3)
         {
            _loc4_.addChild(_loc5_);
         }
         var _loc6_:Sequence = new Sequence();
         _loc4_.addChild(_loc6_);
         if(param2 > 0)
         {
            if(param3)
            {
               _loc7_ = new Fade();
               _loc7_.target = this.m_UITextField;
               _loc7_.duration = param2;
               _loc7_.alphaFrom = 1;
               _loc7_.alphaTo = 0.3;
               _loc7_.duration = param2 / 2;
               _loc6_.addChild(_loc5_);
               _loc7_ = new Fade();
               _loc7_.target = this.m_UITextField;
               _loc7_.duration = param2;
               _loc7_.alphaFrom = 0.3;
               _loc7_.alphaTo = 1;
               _loc7_.duration = param2 / 2;
               _loc6_.addChild(_loc7_);
            }
            else if(param1 != null && param1.length > 0)
            {
               _loc7_ = new Fade();
               _loc7_.target = this.m_UITextField;
               _loc7_.duration = param2;
               _loc7_.alphaFrom = 0;
               _loc7_.alphaTo = 1;
               _loc6_.addChild(_loc7_);
            }
            else
            {
               _loc7_ = new Fade();
               _loc7_.target = this.m_UITextField;
               _loc7_.duration = param2;
               _loc7_.alphaFrom = 1;
               _loc7_.alphaTo = 0;
               _loc6_.addChild(_loc7_);
            }
         }
         this.m_Sequence.addChild(_loc4_);
      }
      
      public function addMousePhaseChange(param1:uint) : void
      {
         var _loc2_:SetPropertyAction = null;
         _loc2_ = new SetPropertyAction();
         _loc2_.name = "phase";
         _loc2_.value = param1;
         this.m_Sequence.addChild(_loc2_);
         this.m_MouseButtonPhase = param1;
      }
      
      public function set hintText(param1:String) : void
      {
         this.m_HintText = param1;
         invalidateDisplayList();
      }
      
      public function end() : void
      {
         this.m_Sequence.removeEventListener(EffectEvent.EFFECT_END,this.onMouseButtonHintEnd);
         removeEventListener(EffectEvent.EFFECT_END,this.onMouseButtonHintEnd);
         this.m_Sequence.end();
      }
      
      public function updateMoveEffect(param1:Point, param2:Point, param3:uint = 0) : void
      {
         var _loc6_:Effect = null;
         var _loc7_:Move = null;
         var _loc4_:Boolean = this.m_Sequence.isPlaying;
         var _loc5_:uint = 0;
         for each(_loc6_ in this.m_Sequence.children)
         {
            if(_loc6_ is Move && _loc5_ == param3)
            {
               _loc7_ = _loc6_ as Move;
               if(_loc7_.xFrom != param1.x + MOUSE_CURSOR_OFFSET_X || _loc7_.yFrom != param1.y + MOUSE_CURSOR_OFFSET_Y || _loc7_.xTo != param2.x + MOUSE_CURSOR_OFFSET_X || _loc7_.yTo != param2.y + MOUSE_CURSOR_OFFSET_Y)
               {
                  if(_loc4_)
                  {
                     this.m_Sequence.end();
                  }
                  _loc7_.xFrom = param1.x + MOUSE_CURSOR_OFFSET_X;
                  _loc7_.yFrom = param1.y + MOUSE_CURSOR_OFFSET_Y;
                  _loc7_.xTo = param2.x + MOUSE_CURSOR_OFFSET_X;
                  _loc7_.yTo = param2.y + MOUSE_CURSOR_OFFSET_Y;
                  if(_loc4_)
                  {
                     this.m_Sequence.play();
                  }
               }
               break;
            }
            if(_loc6_ is Move)
            {
               _loc5_++;
            }
         }
      }
      
      public function set glowColor(param1:uint) : void
      {
         this.m_GlowColor = param1;
         invalidateDisplayList();
      }
      
      public function set repeatCount(param1:uint) : void
      {
         this.m_Sequence.repeatCount = param1;
      }
      
      public function play() : void
      {
         this.m_Sequence.addEventListener(EffectEvent.EFFECT_END,this.onMouseButtonHintEnd);
         addEventListener(EffectEvent.EFFECT_END,this.onMouseButtonHintEnd);
         this.m_Sequence.play();
      }
      
      public function set phase(param1:uint) : void
      {
         this.m_MouseButtonPhase = param1;
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         graphics.clear();
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(this.m_MouseButtonPhase * this.m_MouseGraphicsRectangle.width * -1,0);
         graphics.beginBitmapFill(SEMI_TRANSPARENT_MOUSE_BUTTON_BITMAP,_loc3_);
         graphics.drawRect(0,0,this.m_MouseGraphicsRectangle.width,this.m_MouseGraphicsRectangle.height);
         graphics.endFill();
         s_TempColor.ARGB = this.m_GlowColor;
         var _loc4_:GlowFilter = new GlowFilter();
         _loc4_.color = s_TempColor.RGB;
         _loc4_.alpha = s_TempColor.alphaFloat;
         _loc4_.blurX = 40;
         _loc4_.blurY = 40;
         _loc4_.strength = 10;
         _loc4_.quality = BitmapFilterQuality.MEDIUM;
         this.filters = [_loc4_];
         this.m_UITextField.text = this.m_HintText == null?"":this.m_HintText;
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.color = 16768894;
         _loc5_.font = "Verdana";
         _loc5_.size = 18;
         _loc4_ = new GlowFilter(0,0.5,2,2,10);
         _loc4_.quality = BitmapFilterQuality.MEDIUM;
         this.m_UITextField.filters = [_loc4_];
         this.m_UITextField.setTextFormat(_loc5_);
      }
   }
}
