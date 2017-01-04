package
{
   import flash.net.getClassByAlias;
   import flash.net.registerClassAlias;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.graphics.ImageSnapshot;
   import mx.styles.StyleManager;
   import mx.utils.ObjectProxy;
   
   public class _Tibia_FlexInit
   {
       
      
      public function _Tibia_FlexInit()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         EffectManager.mx_internal::registerEffectTrigger("addedEffect","added");
         EffectManager.mx_internal::registerEffectTrigger("completeEffect","complete");
         EffectManager.mx_internal::registerEffectTrigger("creationCompleteEffect","creationComplete");
         EffectManager.mx_internal::registerEffectTrigger("focusInEffect","focusIn");
         EffectManager.mx_internal::registerEffectTrigger("focusOutEffect","focusOut");
         EffectManager.mx_internal::registerEffectTrigger("hideEffect","hide");
         EffectManager.mx_internal::registerEffectTrigger("itemsChangeEffect","itemsChange");
         EffectManager.mx_internal::registerEffectTrigger("mouseDownEffect","mouseDown");
         EffectManager.mx_internal::registerEffectTrigger("mouseUpEffect","mouseUp");
         EffectManager.mx_internal::registerEffectTrigger("moveEffect","move");
         EffectManager.mx_internal::registerEffectTrigger("removedEffect","removed");
         EffectManager.mx_internal::registerEffectTrigger("resizeEffect","resize");
         EffectManager.mx_internal::registerEffectTrigger("rollOutEffect","rollOut");
         EffectManager.mx_internal::registerEffectTrigger("rollOverEffect","rollOver");
         EffectManager.mx_internal::registerEffectTrigger("showEffect","show");
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayCollection") == null)
            {
               registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayList") == null)
            {
               registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
         }
         try
         {
            if(getClassByAlias("flex.graphics.ImageSnapshot") == null)
            {
               registerClassAlias("flex.graphics.ImageSnapshot",ImageSnapshot);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.graphics.ImageSnapshot",ImageSnapshot);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ObjectProxy") == null)
            {
               registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
         }
         var styleNames:Array = ["selectionDisabledColor","strokeWidth","horizontalGridLineColor","fontGridFitType","kerning","errorColor","color","alternatingItemColors","leading","fontAntiAliasType","backgroundDisabledColor","selectionColor","labelWidth","textIndent","barColor","fontThickness","fontFamily","textSelectedColor","disabledIconColor","strokeColor","dropShadowColor","shadowColor","fontWeight","dividerColor","dropdownBorderColor","textAlign","fontSharpness","depthColors","headerColors","letterSpacing","textDecoration","fontStyle","disabledColor","indicatorGap","modalTransparencyColor","rollOverColor","modalTransparencyBlur","themeColor","modalTransparencyDuration","verticalGridLineColor","modalTransparency","iconColor","fontSize","textRollOverColor"];
         var i:int = 0;
         while(i < styleNames.length)
         {
            StyleManager.registerInheritingStyle(styleNames[i]);
            i++;
         }
      }
   }
}
