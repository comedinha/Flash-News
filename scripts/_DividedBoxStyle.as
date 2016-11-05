package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _DividedBoxStyle
   {
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_HBoxDivider_769095364:Class = _DividedBoxStyle__embed_css_Assets_swf_mx_skins_cursor_HBoxDivider_769095364;
      
      private static var _embed_css_Assets_swf_mx_skins_cursor_VBoxDivider_1617517722:Class = _DividedBoxStyle__embed_css_Assets_swf_mx_skins_cursor_VBoxDivider_1617517722;
      
      private static var _embed_css_Assets_swf_mx_skins_BoxDividerSkin_2063647417:Class = _DividedBoxStyle__embed_css_Assets_swf_mx_skins_BoxDividerSkin_2063647417;
       
      
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
               this.dividerSkin = _embed_css_Assets_swf_mx_skins_BoxDividerSkin_2063647417;
               this.dividerAffordance = 6;
               this.verticalDividerCursor = _embed_css_Assets_swf_mx_skins_cursor_VBoxDivider_1617517722;
               this.verticalGap = 10;
               this.horizontalDividerCursor = _embed_css_Assets_swf_mx_skins_cursor_HBoxDivider_769095364;
               this.dividerColor = 7305079;
            };
         }
      }
   }
}
