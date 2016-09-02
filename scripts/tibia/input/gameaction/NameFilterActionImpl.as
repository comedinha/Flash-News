package tibia.input.gameaction
{
   import tibia.input.IActionImpl;
   import tibia.options.OptionsStorage;
   import tibia.chat.NameFilterSet;
   import tibia.chat.ChatStorage;
   import tibia.chat.MessageMode;
   import mx.resources.ResourceManager;
   
   public class NameFilterActionImpl implements IActionImpl
   {
      
      public static const IGNORE:int = 0;
      
      private static const BUNDLE:String = "ChatStorage";
      
      public static const UNIGNORE:int = 1;
       
      
      private var m_Type:int = -1;
      
      private var m_Name:String = null;
      
      public function NameFilterActionImpl(param1:int, param2:String)
      {
         super();
         if(param1 != IGNORE && param1 != UNIGNORE)
         {
            throw new ArgumentError("NameFilterActionImpl.NameFilterActionImpl: Invalid type: " + param1 + ".");
         }
         if(param2 == null)
         {
            throw new ArgumentError("NameFilterActionImpl.NameFilterActionImpl: Invalid player name.");
         }
         this.m_Type = param1;
         this.m_Name = param2;
      }
      
      public static function s_IsBlacklisted(param1:String) : Boolean
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:NameFilterSet = null;
         return _loc2_ != null && (_loc3_ = _loc2_.getNameFilterSet(NameFilterSet.DEFAULT_SET)) != null && _loc3_.isBlacklisted(param1);
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc2_:ChatStorage = Tibia.s_GetChatStorage();
         var _loc3_:OptionsStorage = Tibia.s_GetOptions();
         var _loc4_:NameFilterSet = null;
         if(_loc2_ != null && _loc3_ != null && (_loc4_ = _loc3_.getNameFilterSet(NameFilterSet.DEFAULT_SET)) != null)
         {
            switch(this.m_Type)
            {
               case IGNORE:
                  _loc4_.addBlacklist(this.m_Name,false);
                  _loc2_.addChannelMessage(ChatStorage.SERVER_CHANNEL_ID,-1,null,0,MessageMode.MESSAGE_STATUS,ResourceManager.getInstance().getString(BUNDLE,"MSG_IGNORE",[this.m_Name]));
                  break;
               case UNIGNORE:
                  _loc4_.removeBlacklist(this.m_Name);
                  _loc2_.addChannelMessage(ChatStorage.SERVER_CHANNEL_ID,-1,null,0,MessageMode.MESSAGE_STATUS,ResourceManager.getInstance().getString(BUNDLE,"MSG_UNIGNORE",[this.m_Name]));
            }
         }
      }
   }
}
