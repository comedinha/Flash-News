package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$EditTextWidget_properties extends ResourceBundle
   {
       
      
      public function en_US$EditTextWidget_properties()
      {
         super("en_US","EditTextWidget");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "HEADING_RW":"It is currently empty.\nYou can enter new text.",
            "HEADING_RW_TEXT_AUTHOR_DATE":"You read the following, written by\n{0}\non {1}.\nYou can enter new text.",
            "HEADING_RO_TEXT_AUTHOR_DATE":"You read the following, written by\n{0}\non {1}.",
            "HEADING_RO_TEXT":"You read the following.",
            "HEADING_RO_TEXT_AUTHOR":"You read the following, written by\n{0}.",
            "HEADING_RO":"It is empty.",
            "TITLE":"Show Text",
            "HEADING_RW_TEXT":"You read the following.\nYou can enter new text.",
            "HEADING_RW_TEXT_AUTHOR":"You read the following, written by\n{0}.\nYou can enter new text.",
            "TITLE_EDIT":"Edit Text"
         };
         return _loc1_;
      }
   }
}
