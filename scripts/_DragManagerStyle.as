package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.DefaultDragImage;
   
   public class _DragManagerStyle
   {
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragCopy_2126518529:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragCopy_2126518529;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragMove_2128395685:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragMove_2128395685;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragReject_1855271461:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragReject_1855271461;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragLink_2128353680:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragLink_2128353680;
       
      
      public function _DragManagerStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DragManager");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DragManager",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.copyCursor = _embed_css_Assets_swf_mx_skins_cursor_DragCopy_2126518529;
               this.moveCursor = _embed_css_Assets_swf_mx_skins_cursor_DragMove_2128395685;
               this.rejectCursor = _embed_css_Assets_swf_mx_skins_cursor_DragReject_1855271461;
               this.linkCursor = _embed_css_Assets_swf_mx_skins_cursor_DragLink_2128353680;
               this.defaultDragImageSkin = DefaultDragImage;
            };
         }
      }
   }
}
