package mx.controls
{
   import mx.controls.sliderClasses.Slider;
   import mx.core.mx_internal;
   import mx.controls.sliderClasses.SliderDirection;
   
   use namespace mx_internal;
   
   public class HSlider extends Slider
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function HSlider()
      {
         super();
         direction = SliderDirection.HORIZONTAL;
      }
   }
}
