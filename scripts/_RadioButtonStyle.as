package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.RadioButtonIcon;
   
   public class _RadioButtonStyle
   {
       
      
      public function _RadioButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("RadioButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("RadioButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.upSkin = null;
               this.paddingRight = 0;
               this.upIcon = null;
               this.icon = RadioButtonIcon;
               this.skin = null;
               this.cornerRadius = 7;
               this.fontWeight = "normal";
               this.textAlign = "left";
               this.selectedUpIcon = null;
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
               this.selectedDownIcon = null;
            };
         }
      }
   }
}
