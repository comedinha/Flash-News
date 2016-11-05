package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.DefaultDragImage;
   
   public class _DragManagerStyle
   {
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragMove_1350139645:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragMove_1350139645;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragCopy_1348850521:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragCopy_1348850521;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragReject_137392381:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragReject_137392381;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_DragLink_1350161110:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragLink_1350161110;
       
      
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
               this.linkCursor = _embed_css_Assets_swf_mx_skins_cursor_DragLink_1350161110;
               this.rejectCursor = _embed_css_Assets_swf_mx_skins_cursor_DragReject_137392381;
               this.copyCursor = _embed_css_Assets_swf_mx_skins_cursor_DragCopy_1348850521;
               this.moveCursor = _embed_css_Assets_swf_mx_skins_cursor_DragMove_1350139645;
               this.defaultDragImageSkin = DefaultDragImage;
            };
         }
      }
   }
}
