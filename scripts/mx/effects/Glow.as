package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.GlowInstance;
   
   use namespace mx_internal;
   
   public class Glow extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var AFFECTED_PROPERTIES:Array = ["filters"];
       
      
      public var knockout:Boolean;
      
      public var color:uint = 4.294967295E9;
      
      public var alphaFrom:Number;
      
      public var blurXTo:Number;
      
      public var blurYTo:Number;
      
      public var strength:Number;
      
      public var alphaTo:Number;
      
      public var blurXFrom:Number;
      
      public var blurYFrom:Number;
      
      public var inner:Boolean;
      
      public function Glow(param1:Object = null)
      {
         super(param1);
         instanceClass = GlowInstance;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         var _loc2_:GlowInstance = null;
         super.initInstance(param1);
         _loc2_ = GlowInstance(param1);
         _loc2_.alphaFrom = alphaFrom;
         _loc2_.alphaTo = alphaTo;
         _loc2_.blurXFrom = blurXFrom;
         _loc2_.blurXTo = blurXTo;
         _loc2_.blurYFrom = blurYFrom;
         _loc2_.blurYTo = blurYTo;
         _loc2_.color = color;
         _loc2_.inner = inner;
         _loc2_.knockout = knockout;
         _loc2_.strength = strength;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
   }
}
