package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$UnjustPointsWidget_properties extends ResourceBundle
   {
       
      
      public function en_US$UnjustPointsWidget_properties()
      {
         super("en_US","UnjustPointsWidget");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "TOOLTIP_UNJUST_POINTS_7D":"UPs gained in 7 days. You have {0} full kill{1} left.",
            "TOOLTIP_UNJUST_POINTS_30D":"UPs gained in 30 days. You have {0} full kill{1} left.",
            "LABEL_OPEN_SITUATIONS":"Open:{0}",
            "TITLE":"Unjustified Points",
            "TOOLTIP_UNJUST_POINTS_24H":"UPs gained in 24 hours. You have {0} full kill{1} left.",
            "TOOLTIP_REMAINING_SKULLS":"Remaining skull time",
            "BUTTON_SHOW_MORE":"More",
            "LABEL_REMAINING_SKULLS":"{0}d",
            "TOOLTIP_OPEN_SITUATIONS":"Open PvP situations",
            "BUTTON_SHOW_LESS":"Less"
         };
         return _loc1_;
      }
   }
}
