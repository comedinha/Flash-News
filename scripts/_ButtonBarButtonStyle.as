package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.ButtonBarButtonSkin;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _ButtonBarButtonStyle
   {
       
      
      public function _ButtonBarButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("ButtonBarButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ButtonBarButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.downSkin = null;
               this.upSkin = null;
               this.horizontalGap = 1;
               this.selectedDownSkin = null;
               this.overSkin = null;
               this.selectedUpSkin = null;
               this.skin = ButtonBarButtonSkin;
               this.disabledSkin = null;
               this.selectedOverSkin = null;
               this.selectedDisabledSkin = null;
            };
         }
      }
   }
}
