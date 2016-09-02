package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import flash.events.Event;
   import mx.styles.StyleManager;
   import mx.core.Application;
   import flash.filters.GlowFilter;
   
   use namespace mx_internal;
   
   public class GlowInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var strength:Number;
      
      public var inner:Boolean;
      
      public var blurXFrom:Number;
      
      public var blurYFrom:Number;
      
      public var color:uint = 4.294967295E9;
      
      public var alphaFrom:Number;
      
      public var blurYTo:Number;
      
      public var blurXTo:Number;
      
      public var alphaTo:Number;
      
      public var knockout:Boolean;
      
      public function GlowInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function initEffect(param1:Event) : void
      {
         super.initEffect(param1);
      }
      
      override public function play() : void
      {
         super.play();
         if(isNaN(alphaFrom))
         {
            alphaFrom = 1;
         }
         if(isNaN(alphaTo))
         {
            alphaTo = 0;
         }
         if(isNaN(blurXFrom))
         {
            blurXFrom = 5;
         }
         if(isNaN(blurXTo))
         {
            blurXTo = 0;
         }
         if(isNaN(blurYFrom))
         {
            blurYFrom = 5;
         }
         if(isNaN(blurYTo))
         {
            blurYTo = 0;
         }
         if(color == StyleManager.NOT_A_COLOR)
         {
            color = Application.application.getStyle("themeColor");
         }
         if(isNaN(strength))
         {
            strength = 2;
         }
         tween = createTween(this,[color,alphaFrom,blurXFrom,blurYFrom],[color,alphaTo,blurXTo,blurYTo],duration);
      }
      
      private function setGlowFilter(param1:uint, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Array = target.filters;
         var _loc6_:int = _loc5_.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            if(_loc5_[_loc7_] is GlowFilter)
            {
               _loc5_.splice(_loc7_,1);
            }
            _loc7_++;
         }
         if(param3 || param4 || param2)
         {
            _loc5_.push(new GlowFilter(param1,param2,param3,param4,strength,1,inner,knockout));
         }
         target.filters = _loc5_;
      }
      
      override public function onTweenEnd(param1:Object) : void
      {
         setGlowFilter(param1[0],param1[1],param1[2],param1[3]);
         super.onTweenEnd(param1);
      }
      
      override public function onTweenUpdate(param1:Object) : void
      {
         setGlowFilter(param1[0],param1[1],param1[2],param1[3]);
      }
   }
}
