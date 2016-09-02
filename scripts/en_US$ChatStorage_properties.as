package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$ChatStorage_properties extends ResourceBundle
   {
       
      
      public function en_US$ChatStorage_properties()
      {
         super("en_US","ChatStorage");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "MSG_CHANNEL_CLOSED":"The channel has been closed. You need to re-join the channel if you get invited.",
            "MSG_UNIGNORE":"You are no longer ignoring player {0}.",
            "LBL_SERVER_CHANNEL":"Server Log",
            "MSG_HELP_CHANNEL_INFO":"Welcome to the help channel. In this channel you can ask questions about Tibia. Experienced players will gladly help you to the best of their knowledge. If their answer was helpful, reward them with a \"Thank You!\" which you can select by right-clicking on their statement. For detailed information about quests and other game content, please take a look at our supported fansites in the community section of the official Tibia website.",
            "MSG_CHANNEL_NO_ANONYMOUS":"This is not a chat channel. ",
            "MSG_ADVERTISING_CHANNEL_INFO":"Here you can advertise all kinds of things. Among others, you can trade Tibia items, advertise ingame events, seek characters for a quest or a hunting group, find members for your guild or look for somebody to help you with something. It goes without saying that all advertisements must conform to the Tibia Rules. Keep in mind that it is illegal to advertise trades including real money or Tibia characters.",
            "MSG_CHANNEL_TO_SELF":"You cannot set up a private message channel with yourself.",
            "LBL_SESSIONDUMP_CHANNEL":"Sessiondump",
            "MSG_IGNORE":"You are now ignoring player {0}.",
            "LBL_NPC_CHANNEL":"NPCs",
            "LBL_LOCAL_CHANNEL":"Local Chat",
            "LBL_DEBUG_CHANNEL":"Debug"
         };
         return _loc1_;
      }
   }
}
