package shared.controls
{
   import mx.controls.Label;
   
   public class CustomLabel extends Label
   {
       
      
      public function CustomLabel()
      {
         super();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(truncateToFit)
         {
            measuredMinWidth = 0;
            measuredWidth = 0;
         }
      }
   }
}
