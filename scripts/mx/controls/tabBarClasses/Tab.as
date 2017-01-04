package mx.controls.tabBarClasses
{
   import flash.display.DisplayObject;
   import flash.text.TextLineMetrics;
   import mx.controls.Button;
   import mx.core.IFlexDisplayObject;
   import mx.core.IProgrammaticSkin;
   import mx.core.IStateClient;
   import mx.core.mx_internal;
   import mx.styles.ISimpleStyleClient;
   
   use namespace mx_internal;
   
   public class Tab extends Button
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var focusSkin:IFlexDisplayObject;
      
      public function Tab()
      {
         super();
         focusEnabled = false;
      }
      
      override public function drawFocus(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Class = null;
         if(param1 && !selected && !isEffectStarted)
         {
            if(!focusSkin)
            {
               _loc2_ = false;
               _loc3_ = getStyle(overSkinName);
               if(!_loc3_)
               {
                  _loc3_ = getStyle(skinName);
                  _loc2_ = true;
               }
               if(_loc3_)
               {
                  focusSkin = new _loc3_();
                  DisplayObject(focusSkin).name = overSkinName;
                  if(focusSkin is ISimpleStyleClient)
                  {
                     ISimpleStyleClient(focusSkin).styleName = this;
                  }
                  addChild(DisplayObject(focusSkin));
                  if(_loc2_ && !(focusSkin is IProgrammaticSkin) && focusSkin is IStateClient)
                  {
                     IStateClient(focusSkin).currentState = "over";
                  }
               }
            }
            invalidateDisplayList();
            validateNow();
         }
         else if(focusSkin)
         {
            removeChild(DisplayObject(focusSkin));
            focusSkin = null;
         }
      }
      
      override mx_internal function layoutContents(param1:Number, param2:Number, param3:Boolean) : void
      {
         super.layoutContents(param1,param2,param3);
         if(selected)
         {
            textField.y++;
            if(currentIcon)
            {
               currentIcon.y++;
            }
         }
         if(currentSkin)
         {
            setChildIndex(DisplayObject(currentSkin),numChildren - 1);
         }
         if(focusSkin && !selected)
         {
            focusSkin.setActualSize(param1,param2);
            setChildIndex(DisplayObject(focusSkin),numChildren - 1);
         }
         if(currentIcon)
         {
            setChildIndex(DisplayObject(currentIcon),numChildren - 1);
         }
         if(textField)
         {
            setChildIndex(DisplayObject(textField),numChildren - 1);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(currentIcon)
         {
            currentIcon.scaleX = 1;
            currentIcon.scaleY = 1;
         }
         viewIcon();
      }
      
      override public function measureText(param1:String) : TextLineMetrics
      {
         return textField.styleName == this?super.measureText(param1):textField.getUITextFormat().measureText(param1);
      }
      
      override mx_internal function viewIcon() : void
      {
         var _loc1_:Number = NaN;
         super.viewIcon();
         if(currentIcon)
         {
            if(height != 0 && currentIcon.height > height - 4)
            {
               _loc1_ = (height - 4) / currentIcon.height;
               currentIcon.scaleX = _loc1_;
               currentIcon.scaleY = _loc1_;
               invalidateSize();
               if(height > 0)
               {
                  layoutContents(width,height,false);
               }
            }
         }
      }
   }
}
