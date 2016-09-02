package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$QuestLogWidget_properties extends ResourceBundle
   {
       
      
      public function en_US$QuestLogWidget_properties()
      {
         super("en_US","QuestLogWidget");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "BTN_CLOSE":"Close",
            "QUEST_LINE_COMPLETED_TAG":" (completed)",
            "TITLE_QUEST_LOG":"Quest Log",
            "BTN_SHOW":"Show",
            "TITLE_QUEST_LINE":"Quest Line"
         };
         return _loc1_;
      }
   }
}
