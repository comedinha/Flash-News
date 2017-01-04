package tibia.input.gameaction
{
   import mx.events.CloseEvent;
   import mx.resources.ResourceManager;
   import tibia.chat.ChatStorage;
   import tibia.chat.MessageMode;
   import tibia.game.BugReportWidget;
   import tibia.input.IActionImpl;
   import tibia.network.Communication;
   import tibia.worldmap.WorldMapStorage;
   
   public class SendBugReportActionImpl implements IActionImpl
   {
      
      private static const BUNDLE:String = "BugReportWidget";
       
      
      protected var m_BugCategory:int;
      
      protected var m_SystemMessage = null;
      
      protected var m_UserMessage:String = null;
      
      protected var m_Callback:Function = null;
      
      public function SendBugReportActionImpl(param1:String = null, param2:* = null, param3:Function = null, param4:int = -1)
      {
         this.m_BugCategory = BugReportWidget.BUG_CATEGORY_OTHER;
         super();
         this.m_UserMessage = param1;
         this.m_SystemMessage = param2;
         this.m_Callback = param3;
         if(param4 > -1)
         {
            this.m_BugCategory = param4;
         }
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc3_:BugReportWidget = null;
         var _loc4_:String = null;
         var _loc5_:WorldMapStorage = null;
         var _loc6_:ChatStorage = null;
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && _loc2_.allowBugreports && _loc2_.isGameRunning)
         {
            _loc3_ = new BugReportWidget();
            _loc3_.userMessage = this.m_UserMessage;
            _loc3_.bugInformation = this.m_SystemMessage;
            _loc3_.category = this.m_BugCategory;
            if(this.m_Callback != null)
            {
               _loc3_.addEventListener(CloseEvent.CLOSE,this.m_Callback);
            }
            _loc3_.show();
         }
         else
         {
            _loc4_ = null;
            if(_loc2_ != null && !_loc2_.allowBugreports && _loc2_.isGameRunning)
            {
               _loc4_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_NOT_AUHTORIZED");
            }
            else
            {
               _loc4_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_NOT_CONNECTED");
            }
            _loc5_ = Tibia.s_GetWorldMapStorage();
            if(_loc5_ != null)
            {
               _loc5_.addOnscreenMessage(MessageMode.MESSAGE_FAILURE,_loc4_);
            }
            _loc6_ = Tibia.s_GetChatStorage();
            if(_loc6_ != null)
            {
               _loc6_.addChannelMessage(-1,-1,null,0,MessageMode.MESSAGE_FAILURE,_loc4_);
            }
         }
      }
   }
}
