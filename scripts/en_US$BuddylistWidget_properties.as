package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$BuddylistWidget_properties extends ResourceBundle
   {
       
      
      public function en_US$BuddylistWidget_properties()
      {
         super("en_US","BuddylistWidget");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "ASK_NAME_PROMPT":"Please enter a character name:",
            "CTX_OPEN_MESSAGE_CHANNEL":"Message to {0}",
            "CTX_COPY_NAME":"Copy Name",
            "CTX_SORT_ICON":"Sort by Icon",
            "CTX_EDIT_BUDDY":"Edit {0}",
            "CTX_ADD_BUDDY":"Add new VIP",
            "CTX_SORT_STATUS":"Sort by Status",
            "DEFAULT_GROUP_NAME":"Group {0}",
            "ASK_NAME_TITLE":"Add new VIP",
            "NOTIFICATION_MESSAGE":"{0} has logged in.",
            "TITLE":"VIP List",
            "CTX_SORT_NAME":"Sort by Name",
            "CTX_HIDE_OFFLINE":"Hide Offline VIPs",
            "CTX_REPORT_NAME":"Report Name",
            "CTX_REMOVE_BUDDY":"Remove {0}",
            "CTX_SHOW_OFFLINE":"Show Offline VIPs"
         };
         return _loc1_;
      }
   }
}
