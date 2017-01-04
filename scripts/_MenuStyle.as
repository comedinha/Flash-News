package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.ListDropIndicator;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _MenuStyle
   {
      
      private static var _embed_css_Assets_swf_MenuCheckEnabled_910602333:Class = _MenuStyle__embed_css_Assets_swf_MenuCheckEnabled_910602333;
      
      private static var _embed_css_Assets_swf_MenuCheckDisabled_732240386:Class = _MenuStyle__embed_css_Assets_swf_MenuCheckDisabled_732240386;
      
      private static var _embed_css_Assets_swf_MenuSeparator_1251447871:Class = _MenuStyle__embed_css_Assets_swf_MenuSeparator_1251447871;
      
      private static var _embed_css_Assets_swf_MenuRadioEnabled_1271141506:Class = _MenuStyle__embed_css_Assets_swf_MenuRadioEnabled_1271141506;
      
      private static var _embed_css_Assets_swf_MenuBranchDisabled_1017897974:Class = _MenuStyle__embed_css_Assets_swf_MenuBranchDisabled_1017897974;
      
      private static var _embed_css_Assets_swf_MenuRadioDisabled_372013117:Class = _MenuStyle__embed_css_Assets_swf_MenuRadioDisabled_372013117;
      
      private static var _embed_css_Assets_swf_MenuBranchEnabled_1492763579:Class = _MenuStyle__embed_css_Assets_swf_MenuBranchEnabled_1492763579;
       
      
      public function _MenuStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("Menu");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Menu",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.verticalAlign = "middle";
               this.paddingRight = 0;
               this.dropIndicatorSkin = ListDropIndicator;
               this.separatorSkin = _embed_css_Assets_swf_MenuSeparator_1251447871;
               this.dropShadowEnabled = true;
               this.leftIconGap = 18;
               this.rightIconGap = 15;
               this.radioDisabledIcon = _embed_css_Assets_swf_MenuRadioDisabled_372013117;
               this.horizontalGap = 6;
               this.radioIcon = _embed_css_Assets_swf_MenuRadioEnabled_1271141506;
               this.branchDisabledIcon = _embed_css_Assets_swf_MenuBranchDisabled_1017897974;
               this.paddingBottom = 1;
               this.branchIcon = _embed_css_Assets_swf_MenuBranchEnabled_1492763579;
               this.checkDisabledIcon = _embed_css_Assets_swf_MenuCheckDisabled_732240386;
               this.paddingTop = 1;
               this.borderStyle = "menuBorder";
               this.checkIcon = _embed_css_Assets_swf_MenuCheckEnabled_910602333;
               this.paddingLeft = 1;
            };
         }
      }
   }
}
