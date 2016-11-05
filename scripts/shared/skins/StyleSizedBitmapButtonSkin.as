package shared.skins
{
   public class StyleSizedBitmapButtonSkin extends BitmapButtonSkinBase
   {
       
      
      public function StyleSizedBitmapButtonSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         var _loc1_:Number = super.measuredWidth;
         var _loc2_:* = getStyle("width");
         if(_loc2_)
         {
            return _loc2_;
         }
         return _loc1_;
      }
      
      override public function get measuredHeight() : Number
      {
         var _loc1_:Number = super.measuredHeight;
         var _loc2_:* = getStyle("height");
         if(_loc2_)
         {
            return _loc2_;
         }
         return _loc1_;
      }
      
      override protected function doValidateStyle() : void
      {
         super.doValidateStyle();
         switch(name)
         {
            case "disabledSkin":
               stylePrefix = "defaultDisabled";
               break;
            case "downSkin":
               stylePrefix = "defaultDown";
               break;
            case "upSkin":
               stylePrefix = "defaultUp";
               break;
            case "overSkin":
               stylePrefix = "defaultOver";
               break;
            case "selectedDisabledSkin":
               stylePrefix = "selectedDisabled";
               break;
            case "selectedDownSkin":
               stylePrefix = "selectedDown";
               break;
            case "selectedUpSkin":
               stylePrefix = "selectedUp";
               break;
            case "selectedOverSkin":
               stylePrefix = "selectedOver";
               break;
            default:
               stylePrefix = null;
         }
      }
   }
}
