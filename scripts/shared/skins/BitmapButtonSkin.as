package shared.skins
{
   public class BitmapButtonSkin extends BitmapButtonSkinBase
   {
       
      
      public function BitmapButtonSkin()
      {
         super();
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
