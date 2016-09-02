package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.ListDropIndicator;
   
   public class _MenuStyle
   {
      
      private static var _embed_css_Assets_swf_MenuSeparator_229201407:Class = _MenuStyle__embed_css_Assets_swf_MenuSeparator_229201407;
      
      private static var _embed_css_Assets_swf_MenuCheckEnabled_1090021853:Class = _MenuStyle__embed_css_Assets_swf_MenuCheckEnabled_1090021853;
      
      private static var _embed_css_Assets_swf_MenuBranchDisabled_2051719078:Class = _MenuStyle__embed_css_Assets_swf_MenuBranchDisabled_2051719078;
      
      private static var _embed_css_Assets_swf_MenuRadioEnabled_1023758274:Class = _MenuStyle__embed_css_Assets_swf_MenuRadioEnabled_1023758274;
      
      private static var _embed_css_Assets_swf_MenuBranchEnabled_247927339:Class = _MenuStyle__embed_css_Assets_swf_MenuBranchEnabled_247927339;
      
      private static var _embed_css_Assets_swf_MenuCheckDisabled_493500994:Class = _MenuStyle__embed_css_Assets_swf_MenuCheckDisabled_493500994;
      
      private static var _embed_css_Assets_swf_MenuRadioDisabled_1597890051:Class = _MenuStyle__embed_css_Assets_swf_MenuRadioDisabled_1597890051;
       
      
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
               this.radioIcon = _embed_css_Assets_swf_MenuRadioEnabled_1023758274;
               this.borderStyle = "menuBorder";
               this.paddingTop = 1;
               this.rightIconGap = 15;
               this.branchIcon = _embed_css_Assets_swf_MenuBranchEnabled_247927339;
               this.checkDisabledIcon = _embed_css_Assets_swf_MenuCheckDisabled_493500994;
               this.verticalAlign = "middle";
               this.paddingLeft = 1;
               this.paddingRight = 0;
               this.checkIcon = _embed_css_Assets_swf_MenuCheckEnabled_1090021853;
               this.radioDisabledIcon = _embed_css_Assets_swf_MenuRadioDisabled_1597890051;
               this.dropShadowEnabled = true;
               this.branchDisabledIcon = _embed_css_Assets_swf_MenuBranchDisabled_2051719078;
               this.dropIndicatorSkin = ListDropIndicator;
               this.separatorSkin = _embed_css_Assets_swf_MenuSeparator_229201407;
               this.horizontalGap = 6;
               this.leftIconGap = 18;
               this.paddingBottom = 1;
            };
         }
      }
   }
}
