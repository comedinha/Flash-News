package tibia.input.staticaction
{
   import flash.ui.Keyboard;
   import tibia.chat.ChatWidget;
   
   public class ChatEditText extends StaticAction
   {
       
      
      public function ChatEditText(param1:int, param2:String, param3:uint, param4:Boolean)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         throw new Error("ChatEditText.perform: Do not call perform.");
      }
      
      override function textCallback(param1:uint, param2:String) : void
      {
         var _loc3_:ChatWidget = Tibia.s_GetChatWidget();
         if(_loc3_ != null)
         {
            _loc3_.onChatText(param1,param2);
         }
      }
      
      override function keyCallback(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:Boolean) : void
      {
         var _loc7_:ChatWidget = Tibia.s_GetChatWidget();
         if(_loc7_ != null)
         {
            if(!param4 && !param5 && !param6 && (param3 == Keyboard.BACKSPACE || param3 == Keyboard.DELETE || param3 == Keyboard.HOME || param3 == Keyboard.END))
            {
               _loc7_.onChatEdit(param1,param2,param3,false,false,false);
            }
            else if(!param4 && param5 && !param6 && (param3 == Keyboard.A || param3 == Keyboard.C || param3 == Keyboard.V || param3 == Keyboard.X))
            {
               _loc7_.onChatCopyPaste(param1,param2,param3,false,true,false);
            }
            else if(!param4 && !param5 && param6 && (param3 == Keyboard.LEFT || param3 == Keyboard.RIGHT))
            {
               _loc7_.onChatEdit(param1,param2,param3,false,false,false);
            }
            else if(!param4 && !param5 && param6 && (param3 == Keyboard.UP || param3 == Keyboard.DOWN))
            {
               _loc7_.onChatHistory(param3 == Keyboard.UP?-1:1);
            }
         }
      }
   }
}
