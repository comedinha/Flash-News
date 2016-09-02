package tibia.input
{
   public class InputEvent
   {
      
      public static const KEY_DOWN:uint = 2;
      
      public static const KEY_UP:uint = 1;
      
      public static const KEY_ANY:uint = KEY_UP | KEY_DOWN | KEY_REPEAT;
      
      public static const TEXT_ANY:uint = TEXT_INPUT;
      
      public static const KEY_REPEAT:uint = 4;
      
      public static const TEXT_INPUT:uint = 8;
       
      
      public function InputEvent()
      {
         super();
      }
   }
}
