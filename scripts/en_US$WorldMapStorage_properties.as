package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$WorldMapStorage_properties extends ResourceBundle
   {
       
      
      public function en_US$WorldMapStorage_properties()
      {
         super("en_US","WorldMapStorage");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "MSG_PATH_GO_UPSTAIRS":"First go upstairs.",
            "LATENCY_TOOTLIP_LOW":"Low lag",
            "LATENCY_TOOTLIP_NO_CONNECTION":"Not connected",
            "MSG_NPC_TOO_FAR":"You are too far away.",
            "MSG_PATH_UNREACHABLE":"There is no way.",
            "LATENCY_TOOTLIP_MEDIUM":"Medium lag",
            "MSG_PATH_GO_DOWNSTAIRS":"First go downstairs.",
            "MSG_PATH_TOO_FAR":"Destination is out of range.",
            "MSG_SORRY_NOT_POSSIBLE":"Sorry, not possible.",
            "LATENCY_TOOTLIP_HIGH":"Heavy lag"
         };
         return _loc1_;
      }
   }
}
