package tibia.help
{
   import mx.core.UIComponent;
   import shared.utility.Colour;
   import mx.effects.Fade;
   import flash.text.TextField;
   import mx.events.EffectEvent;
   import flash.events.Event;
   import mx.effects.Pause;
   import flash.geom.Point;
   import mx.effects.Parallel;
   import mx.effects.SetPropertyAction;
   import mx.effects.Sequence;
   import flash.text.TextFieldAutoSize;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   import flash.text.TextFormat;
   
   public class TextHint extends UIComponent
   {
      
      private static var s_TempColor:Colour = new Colour();
       
      
      private var m_HintText:String = null;
      
      private var m_UITextField:TextField;
      
      private var m_Position:Point = null;
      
      private var m_GlowColor:uint = 3.00309533E9;
      
      private var m_Sequence:Sequence = null;
      
      public function TextHint(param1:Point)
      {
         this.m_UITextField = new TextField();
         super();
         this.m_Position = param1;
         cacheAsBitmap = true;
         mouseFocusEnabled = false;
         mouseEnabled = false;
         mouseChildren = false;
         this.m_Sequence = new Sequence();
         this.m_Sequence.target = this;
      }
      
      public function addFadeIn(param1:Number, param2:uint = 200) : void
      {
         var _loc3_:Fade = new Fade();
         _loc3_.alphaFrom = 0;
         _loc3_.alphaTo = param1;
         _loc3_.duration = param2;
         this.m_Sequence.addChild(_loc3_);
      }
      
      private function onTextHintEnd(param1:EffectEvent) : void
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
      
      public function hide() : void
      {
         TransparentHintLayer.getInstance().removeChild(this);
      }
      
      public function addFadeOut(param1:Number, param2:uint = 200) : void
      {
         var _loc3_:Fade = new Fade();
         _loc3_.alphaFrom = param1;
         _loc3_.alphaTo = 0;
         _loc3_.duration = param2;
         this.m_Sequence.addChild(_loc3_);
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
      
      public function updateTextPosition(param1:Point) : void
      {
         this.m_Position = param1;
         invalidateDisplayList();
      }
      
      public function end() : void
      {
         this.m_Sequence.removeEventListener(EffectEvent.EFFECT_END,this.onTextHintEnd);
         removeEventListener(EffectEvent.EFFECT_END,this.onTextHintEnd);
         this.m_Sequence.end();
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
      
      public function set hintText(param1:String) : void
      {
         this.m_HintText = param1;
         invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         this.m_UITextField.autoSize = TextFieldAutoSize.LEFT;
         this.m_UITextField.mouseEnabled = false;
         addChild(this.m_UITextField);
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
         this.m_Sequence.addEventListener(EffectEvent.EFFECT_END,this.onTextHintEnd);
         addEventListener(EffectEvent.EFFECT_END,this.onTextHintEnd);
         this.m_Sequence.play();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         graphics.clear();
         s_TempColor.ARGB = this.m_GlowColor;
         var _loc3_:GlowFilter = new GlowFilter();
         _loc3_.color = s_TempColor.RGB;
         _loc3_.alpha = s_TempColor.alphaFloat;
         _loc3_.blurX = 40;
         _loc3_.blurY = 40;
         _loc3_.strength = 10;
         _loc3_.quality = BitmapFilterQuality.MEDIUM;
         this.filters = [_loc3_];
         this.m_UITextField.text = this.m_HintText == null?"":this.m_HintText;
         var _loc4_:TextFormat = new TextFormat();
         _loc4_.color = 16768894;
         _loc4_.font = "Verdana";
         _loc4_.size = 18;
         this.m_UITextField.x = this.m_Position.x;
         this.m_UITextField.y = this.m_Position.y;
         _loc3_ = new GlowFilter(0,0.5,2,2,10);
         _loc3_.quality = BitmapFilterQuality.MEDIUM;
         this.m_UITextField.filters = [_loc3_];
         this.m_UITextField.setTextFormat(_loc4_);
      }
      
      public function get repeatCount() : uint
      {
         return this.m_Sequence.repeatCount;
      }
      
      public function show() : void
      {
         TransparentHintLayer.getInstance().addChild(this);
      }
   }
}
