package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.BusyCursor;
   
   public class _CursorManagerStyle
   {
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_BusyCursor_1272652271:Class = _CursorManagerStyle__embed_css_Assets_swf_mx_skins_cursor_BusyCursor_1272652271;
       
      
      public function _CursorManagerStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("CursorManager");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CursorManager",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.busyCursor = BusyCursor;
               this.busyCursorBackground = _embed_css_Assets_swf_mx_skins_cursor_BusyCursor_1272652271;
            };
         }
      }
   }
}
