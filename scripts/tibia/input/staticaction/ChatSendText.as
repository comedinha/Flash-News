package tibia.input.staticaction
{
   import tibia.input.MappingSet;
   import tibia.options.OptionsStorage;
   
   public class ChatSendText extends StaticAction
   {
       
      
      public function ChatSendText(param1:int, param2:String, param3:uint, param4:Boolean)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.generalInputSetMode == MappingSet.CHAT_MODE_OFF)
         {
            _loc2_.generalInputSetMode = MappingSet.CHAT_MODE_TEMPORARY;
         }
         else
         {
            Tibia.s_GameActionFactory.createTalkAction(null,true).perform();
            if(_loc2_.generalInputSetMode == MappingSet.CHAT_MODE_TEMPORARY)
            {
               _loc2_.generalInputSetMode = MappingSet.CHAT_MODE_OFF;
            }
         }
      }
   }
}
