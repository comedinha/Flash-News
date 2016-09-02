package mx.controls
{
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.mx_internal;
   import flash.ui.Keyboard;
   import mx.controls.scrollClasses.ScrollBarDirection;
   
   use namespace mx_internal;
   
   public class HScrollBar extends ScrollBar
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function HScrollBar()
      {
         super();
         super.direction = ScrollBarDirection.HORIZONTAL;
         scaleX = -1;
         rotation = -90;
      }
      
      override mx_internal function get virtualHeight() : Number
      {
         return unscaledWidth;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = _minHeight;
         measuredHeight = _minWidth;
      }
      
      override public function get minHeight() : Number
      {
         return _minWidth;
      }
      
      override mx_internal function get virtualWidth() : Number
      {
         return unscaledHeight;
      }
      
      override public function get minWidth() : Number
      {
         return _minHeight;
      }
      
      override mx_internal function isScrollBarKey(param1:uint) : Boolean
      {
         if(param1 == Keyboard.LEFT)
         {
            lineScroll(-1);
            return true;
         }
         if(param1 == Keyboard.RIGHT)
         {
            lineScroll(1);
            return true;
         }
         return super.isScrollBarKey(param1);
      }
      
      override public function set direction(param1:String) : void
      {
      }
   }
}
