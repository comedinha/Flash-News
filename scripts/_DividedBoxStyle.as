package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _DividedBoxStyle
   {
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_HBoxDivider_1837932102:Class = _DividedBoxStyle__embed_css_Assets_swf_mx_skins_cursor_HBoxDivider_1837932102;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_VBoxDivider_939671556:Class = _DividedBoxStyle__embed_css_Assets_swf_mx_skins_cursor_VBoxDivider_939671556;
      
      private static var _embed_css_Assets_swf_mx_skins_BoxDividerSkin_1406913505:Class = _DividedBoxStyle__embed_css_Assets_swf_mx_skins_BoxDividerSkin_1406913505;
       
      
      public function _DividedBoxStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DividedBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DividedBox",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.dividerAlpha = 0.75;
               this.dividerThickness = 3;
               this.horizontalGap = 10;
               this.dividerSkin = _embed_css_Assets_swf_mx_skins_BoxDividerSkin_1406913505;
               this.dividerAffordance = 6;
               this.verticalDividerCursor = _embed_css_Assets_swf_mx_skins_cursor_VBoxDivider_939671556;
               this.verticalGap = 10;
               this.horizontalDividerCursor = _embed_css_Assets_swf_mx_skins_cursor_HBoxDivider_1837932102;
               this.dividerColor = 7305079;
            };
         }
      }
   }
}
