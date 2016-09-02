package shared.skins
{
   public class BitmapButtonIcon extends BitmapButtonSkinBase
   {
       
      
      public function BitmapButtonIcon()
      {
         super();
      }
      
      override protected function doValidateStyle() : void
      {
         super.doValidateStyle();
         switch(name)
         {
            case "disabledIcon":
               stylePrefix = "iconDefaultDisabled";
               break;
            case "downIcon":
               stylePrefix = "iconDefaultDown";
               break;
            case "upIcon":
               stylePrefix = "iconDefaultUp";
               break;
            case "overIcon":
               stylePrefix = "iconDefaultOver";
               break;
            case "selectedDisabledIcon":
               stylePrefix = "iconSelectedDisabled";
               break;
            case "selectedDownIcon":
               stylePrefix = "iconSelectedDown";
               break;
            case "selectedUpIcon":
               stylePrefix = "iconSelectedUp";
               break;
            case "selectedOverIcon":
               stylePrefix = "iconSelectedOver";
               break;
            default:
               stylePrefix = null;
         }
      }
   }
}
