package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import flash.events.Event;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   public class FadeInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var alphaFrom:Number;
      
      private var restoreAlpha:Boolean;
      
      public var alphaTo:Number;
      
      private var origAlpha:Number = NaN;
      
      public function FadeInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function initEffect(param1:Event) : void
      {
         super.initEffect(param1);
         switch(param1.type)
         {
            case "childrenCreationComplete":
            case FlexEvent.CREATION_COMPLETE:
            case FlexEvent.SHOW:
            case Event.ADDED:
            case "resizeEnd":
               if(isNaN(alphaFrom))
               {
                  alphaFrom = 0;
               }
               if(isNaN(alphaTo))
               {
                  alphaTo = target.alpha;
               }
               break;
            case FlexEvent.HIDE:
            case Event.REMOVED:
            case "resizeStart":
               restoreAlpha = true;
               if(isNaN(alphaFrom))
               {
                  alphaFrom = target.alpha;
               }
               if(isNaN(alphaTo))
               {
                  alphaTo = 0;
               }
         }
      }
      
      override public function onTweenEnd(param1:Object) : void
      {
         super.onTweenEnd(param1);
         if(mx_internal::hideOnEffectEnd || restoreAlpha)
         {
            target.alpha = origAlpha;
         }
      }
      
      override public function play() : void
      {
         super.play();
         origAlpha = target.alpha;
         var _loc1_:PropertyChanges = propertyChanges;
         if(isNaN(alphaFrom) && isNaN(alphaTo))
         {
            if(_loc1_ && _loc1_.end["alpha"] !== undefined)
            {
               alphaFrom = origAlpha;
               alphaTo = _loc1_.end["alpha"];
            }
            else if(_loc1_ && _loc1_.end["visible"] !== undefined)
            {
               alphaFrom = !!_loc1_.start["visible"]?Number(origAlpha):Number(0);
               alphaTo = !!_loc1_.end["visible"]?Number(origAlpha):Number(0);
            }
            else
            {
               alphaFrom = 0;
               alphaTo = origAlpha;
            }
         }
         else if(isNaN(alphaFrom))
         {
            alphaFrom = alphaTo == 0?Number(origAlpha):Number(0);
         }
         else if(isNaN(alphaTo))
         {
            if(_loc1_ && _loc1_.end["alpha"] !== undefined)
            {
               alphaTo = _loc1_.end["alpha"];
            }
            else
            {
               alphaTo = alphaFrom == 0?Number(origAlpha):Number(0);
            }
         }
         tween = createTween(this,alphaFrom,alphaTo,duration);
         target.alpha = tween.mx_internal::getCurrentValue(0);
      }
      
      override public function onTweenUpdate(param1:Object) : void
      {
         target.alpha = param1;
      }
   }
}
