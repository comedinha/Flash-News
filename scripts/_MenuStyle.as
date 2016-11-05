package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.ListDropIndicator;
   
   public class _MenuStyle
   {
      
      private static var _embed_css_Assets_swf_MenuSeparator_722247079:Class = _MenuStyle__embed_css_Assets_swf_MenuSeparator_722247079;
      
      private static var _embed_css_Assets_swf_MenuCheckEnabled_1860024709:Class = _MenuStyle__embed_css_Assets_swf_MenuCheckEnabled_1860024709;
      
      private static var _embed_css_Assets_swf_MenuRadioEnabled_321847576:Class = _MenuStyle__embed_css_Assets_swf_MenuRadioEnabled_321847576;
      
      private static var _embed_css_Assets_swf_MenuBranchDisabled_1969289088:Class = _MenuStyle__embed_css_Assets_swf_MenuBranchDisabled_1969289088;
      
      private static var _embed_css_Assets_swf_MenuCheckDisabled_1943007896:Class = _MenuStyle__embed_css_Assets_swf_MenuCheckDisabled_1943007896;
      
      private static var _embed_css_Assets_swf_MenuBranchEnabled_6478451:Class = _MenuStyle__embed_css_Assets_swf_MenuBranchEnabled_6478451;
      
      private static var _embed_css_Assets_swf_MenuRadioDisabled_1323786661:Class = _MenuStyle__embed_css_Assets_swf_MenuRadioDisabled_1323786661;
       
      
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
               this.separatorSkin = _embed_css_Assets_swf_MenuSeparator_722247079;
               this.dropShadowEnabled = true;
               this.leftIconGap = 18;
               this.rightIconGap = 15;
               this.radioDisabledIcon = _embed_css_Assets_swf_MenuRadioDisabled_1323786661;
               this.horizontalGap = 6;
               this.radioIcon = _embed_css_Assets_swf_MenuRadioEnabled_321847576;
               this.branchDisabledIcon = _embed_css_Assets_swf_MenuBranchDisabled_1969289088;
               this.paddingBottom = 1;
               this.branchIcon = _embed_css_Assets_swf_MenuBranchEnabled_6478451;
               this.checkDisabledIcon = _embed_css_Assets_swf_MenuCheckDisabled_1943007896;
               this.paddingTop = 1;
               this.borderStyle = "menuBorder";
               this.checkIcon = _embed_css_Assets_swf_MenuCheckEnabled_1860024709;
               this.paddingLeft = 1;
            };
         }
      }
   }
}
