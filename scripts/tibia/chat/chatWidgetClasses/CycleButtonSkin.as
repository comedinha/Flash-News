package tibia.chat.chatWidgetClasses
{
   import shared.skins.StyleSizedBitmapButtonSkin;
   
   public class CycleButtonSkin extends StyleSizedBitmapButtonSkin
   {
       
      
      public function CycleButtonSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = 0;
         switch(name)
         {
            case "disabledSkin":
            case "selectedDisabledSkin":
               _loc3_ = getStyle("disabledColor");
               break;
            case "downSkin":
            case "selectedDownSkin":
               _loc3_ = getStyle("textSelectedColor");
               break;
            case "overSkin":
            case "selectedOverSkin":
               _loc3_ = getStyle("textRollOverColor");
               break;
            case "upSkin":
            case "selectedUpSkin":
            default:
               _loc3_ = getStyle("color");
         }
         var _loc4_:Number = getStyle("arrowPadding");
         var _loc5_:Number = getStyle("arrowWidth");
         var _loc6_:Number = getStyle("arrowHeight");
         graphics.beginFill(_loc3_,1);
         graphics.moveTo(_loc4_,param2 / 2);
         graphics.lineTo(_loc4_ + _loc5_,(param2 - _loc6_) / 2);
         graphics.lineTo(_loc4_ + _loc5_,(param2 + _loc6_) / 2);
         graphics.endFill();
         graphics.beginFill(_loc3_,1);
         graphics.moveTo(param1 - _loc4_,param2 / 2);
         graphics.lineTo(param1 - _loc4_ - _loc5_,(param2 + _loc6_) / 2);
         graphics.lineTo(param1 - _loc4_ - _loc5_,(param2 - _loc6_) / 2);
         graphics.endFill();
      }
   }
}
