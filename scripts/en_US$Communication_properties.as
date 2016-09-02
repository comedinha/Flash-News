package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$Communication_properties extends ResourceBundle
   {
       
      
      public function en_US$Communication_properties()
      {
         super("en_US","Communication");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "MSG_INTERNAL_ERROR":"An internal error has occurred (Code: {0}.{1}).",
            "MSG_USER_HAS_LOGGED_OUT_WHILE_PLAYING":"The Tibia Flash Client won\'t work correctly when you log out of the webpage while playing.",
            "MSG_LOST_CONNECTION":"Lost connection to the web server."
         };
         return _loc1_;
      }
   }
}
