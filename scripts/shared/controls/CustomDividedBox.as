package shared.controls
{
   import mx.containers.DividedBox;
   
   public class CustomDividedBox extends DividedBox
   {
       
      
      public function CustomDividedBox()
      {
         super();
         dividerClass = CustomBoxDivider;
      }
   }
}
