package shared.controls
{
   import mx.controls.tabBarClasses.Tab;
   
   public class SimpleTab extends Tab
   {
       
      
      public function SimpleTab()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(textField != null)
         {
            textField.styleName = this;
         }
         super.updateDisplayList(param1,param2);
         if(textField != null)
         {
            textField.setColor(!!selected?uint(getStyle("selectedTextColor")):uint(getStyle("defaultTextColor")));
         }
      }
   }
}
