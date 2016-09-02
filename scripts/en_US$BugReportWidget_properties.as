package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$BugReportWidget_properties extends ResourceBundle
   {
       
      
      public function en_US$BugReportWidget_properties()
      {
         super("en_US","BugReportWidget");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "BUG_CATEGORY_TECHNICAL":"Technical",
            "MSG_NOT_CONNECTED":"You can only send bug reports when you are online.",
            "BUG_CATEGORY_TYPO":"Typo",
            "BUG_CATEGORY_OTHER":"Other",
            "BUG_CATEGORY_MAP":"Map",
            "TITLE":"Report a Bug",
            "MSG_NOT_AUHTORIZED":"You are not authorised to send bug reports.",
            "PROMPT":"Please use this dialog only to report bugs. Do not report rule violations here!"
         };
         return _loc1_;
      }
   }
}
