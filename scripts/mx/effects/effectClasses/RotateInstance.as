package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   
   use namespace mx_internal;
   
   public class RotateInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var originX:Number;
      
      public var originY:Number;
      
      private var centerX:Number;
      
      private var centerY:Number;
      
      public var angleTo:Number = 360;
      
      private var originalOffsetX:Number;
      
      private var originalOffsetY:Number;
      
      private var newX:Number;
      
      private var newY:Number;
      
      public var angleFrom:Number = 0;
      
      public function RotateInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function onTweenUpdate(param1:Object) : void
      {
         if(Math.abs(newX - target.x) > 0.1)
         {
            centerX = target.x + originalOffsetX;
         }
         if(Math.abs(newY - target.y) > 0.1)
         {
            centerY = target.y + originalOffsetY;
         }
         var _loc2_:Number = Number(param1);
         var _loc3_:Number = Math.PI * _loc2_ / 180;
         EffectManager.suspendEventHandling();
         target.rotation = _loc2_;
         newX = centerX - originX * Math.cos(_loc3_) + originY * Math.sin(_loc3_);
         newY = centerY - originX * Math.sin(_loc3_) - originY * Math.cos(_loc3_);
         newX = Number(newX.toFixed(1));
         newY = Number(newY.toFixed(1));
         target.move(newX,newY);
         EffectManager.resumeEventHandling();
      }
      
      override public function play() : void
      {
         super.play();
         var _loc1_:Number = Math.PI * target.rotation / 180;
         if(isNaN(originX))
         {
            originX = target.width / 2;
         }
         if(isNaN(originY))
         {
            originY = target.height / 2;
         }
         centerX = target.x + originX * Math.cos(_loc1_) - originY * Math.sin(_loc1_);
         centerY = target.y + originX * Math.sin(_loc1_) + originY * Math.cos(_loc1_);
         if(isNaN(angleFrom))
         {
            angleFrom = target.rotation;
         }
         if(isNaN(angleTo))
         {
            angleTo = target.rotation == 0?angleFrom > 180?Number(360):Number(0):Number(target.rotation);
         }
         tween = createTween(this,angleFrom,angleTo,duration);
         target.rotation = angleFrom;
         _loc1_ = Math.PI * angleFrom / 180;
         EffectManager.suspendEventHandling();
         originalOffsetX = originX * Math.cos(_loc1_) - originY * Math.sin(_loc1_);
         originalOffsetY = originX * Math.sin(_loc1_) + originY * Math.cos(_loc1_);
         newX = Number((centerX - originalOffsetX).toFixed(1));
         newY = Number((centerY - originalOffsetY).toFixed(1));
         target.move(newX,newY);
         EffectManager.resumeEventHandling();
      }
   }
}
