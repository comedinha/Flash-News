package tibia.input.staticaction
{
   import mx.collections.IList;
   import tibia.chat.Channel;
   import tibia.chat.ChatStorage;
   import tibia.chat.ChatWidget;
   
   public class ChatTabCycle extends StaticAction
   {
      
      public static const NEXT:int = 1;
      
      public static const PREV:int = -1;
       
      
      protected var m_Direction:int = 1;
      
      public function ChatTabCycle(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 != NEXT && param4 != PREV)
         {
            throw new ArgumentError("ChatTabCycle.ChatTabCycle: Invalid direction: " + param4);
         }
         this.m_Direction = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc2_:ChatStorage = Tibia.s_GetChatStorage();
         var _loc3_:ChatWidget = Tibia.s_GetChatWidget();
         var _loc4_:IList = null;
         if(_loc2_ != null && (_loc4_ = _loc2_.channels) != null && _loc3_ != null && _loc3_.leftChannel != null)
         {
            _loc5_ = _loc4_.getItemIndex(_loc3_.leftChannel) + this.m_Direction;
            if(_loc5_ >= _loc4_.length)
            {
               _loc5_ = _loc5_ - _loc4_.length;
            }
            if(_loc5_ < 0)
            {
               _loc5_ = _loc5_ + _loc4_.length;
            }
            _loc3_.leftChannel = _loc4_.getItemAt(_loc5_) as Channel;
         }
      }
   }
}
