package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.CheckBoxIcon;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _CheckBoxStyle
   {
       
      
      public function _CheckBoxStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("CheckBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CheckBox",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.upSkin = null;
               this.textAlign = "left";
               this.paddingRight = 0;
               this.upIcon = null;
               this.icon = CheckBoxIcon;
               this.selectedUpIcon = null;
               this.skin = null;
               this.overIcon = null;
               this.selectedOverIcon = null;
               this.disabledSkin = null;
               this.selectedDisabledIcon = null;
               this.selectedOverSkin = null;
               this.selectedDisabledSkin = null;
               this.downSkin = null;
               this.downIcon = null;
               this.horizontalGap = 5;
               this.selectedDownSkin = null;
               this.iconColor = 2831164;
               this.overSkin = null;
               this.selectedUpSkin = null;
               this.disabledIcon = null;
               this.paddingLeft = 0;
               this.fontWeight = "normal";
               this.selectedDownIcon = null;
            };
         }
      }
   }
}
