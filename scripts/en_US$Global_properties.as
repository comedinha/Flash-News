package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$Global_properties extends ResourceBundle
   {
       
      
      public function en_US$Global_properties()
      {
         super("en_US","Global");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "CTX_CUT":"Cut",
            "DATE_FORMAT":"YYYY-MM-DD JJ:NN:SS",
            "BTN_OKAY":"Okay",
            "TIMESTRING_COMPACT_WITH_HOURS":"{0}h {1}min",
            "MSG_CLICK_TO_ACTIVATE":"Click to activate",
            "NUMBER_FORMAT_THOUSANDS_SEPARATOR":",",
            "BTN_NO":"No",
            "TIMESTRING_COMPACT_MINUTES":"{0} minutes",
            "CTX_COPY":"Copy",
            "TIME_FORMAT":"JJ:NN",
            "BTN_CANCEL":"Cancel",
            "CTX_DELETE":"Delete",
            "BTN_ABORT":"Abort",
            "DATE_FORMAT_FILENAME":"YYYY-MM-DD - HH-NN",
            "CTX_PASTE":"Paste",
            "BTN_YES":"Yes",
            "TIMESTRING_COMPACT_WITH_DAYS":"{0}d {1}h {2}min",
            "BTN_CLOSE":"Close",
            "NUMBER_FORMAT_DECIMAL_SEPARATOR":".",
            "CTX_SELECT_ALL":"Select All",
            "BTN_CLEAR":"Clear"
         };
         return _loc1_;
      }
   }
}
