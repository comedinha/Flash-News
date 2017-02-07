package tibia.game
{
   import flash.text.StyleSheet;
   import shared.utility.StringHelper;
   
   public class Tibia11NagWidget extends MessageWidget
   {
      
      private static const TEXT_STYLESHEET:StyleSheet = new StyleSheet();
      
      {
         s_InitialiseStyleSheet();
      }
      
      public function Tibia11NagWidget()
      {
         super();
         buttonFlags = PopUpBase.BUTTON_OKAY;
         message = resourceManager.getString("Tibia","DLG_TIBIA11_ONLY_TEXT",[StringHelper.s_HilightToHTML(resourceManager.getString("Tibia","DLG_TIBIA11_ONLY_LINK"),255)]);
         title = resourceManager.getString("Tibia","DLG_TIBIA11_ONLY_TITLE");
      }
      
      private static function s_InitialiseStyleSheet() : void
      {
         TEXT_STYLESHEET.parseCSS("p {" + "font-family: Verdana;" + "font-size: 10;" + "margin-left: 15;" + "text-indent: -15;" + "color: #C9BDAB;" + "}" + "a {" + "color:#36b0d9;" + "font-weight:bold;" + "}" + "a:hover {" + "text-decoration:underline;" + "}");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         m_UIMessage.styleSheet = TEXT_STYLESHEET;
      }
   }
}
