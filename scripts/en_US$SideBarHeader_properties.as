package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$SideBarHeader_properties extends ResourceBundle
   {
       
      
      public function en_US$SideBarHeader_properties()
      {
         super("en_US","SideBarHeader");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "TIP_UNJUSTPOINTS":"Unjustified Points",
            "TIP_BODY":"Inventory",
            "TIP_BATTLELIST":"Battle List",
            "TIP_GENERAL":"General Controls",
            "TIP_TRADE":"Trades",
            "TIP_MINIMAP":"Minimap",
            "TIP_CONTAINER":"Containers",
            "TIP_BUDDYLIST":"VIP List",
            "TIP_COMBAT":"Combat Controls"
         };
         return _loc1_;
      }
   }
}
