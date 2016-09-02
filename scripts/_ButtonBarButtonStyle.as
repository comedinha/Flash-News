package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.ButtonBarButtonSkin;
   
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
               this.upSkin = null;
               this.selectedDownSkin = null;
               this.overSkin = null;
               this.downSkin = null;
               this.selectedDisabledSkin = null;
               this.selectedUpSkin = null;
               this.disabledSkin = null;
               this.horizontalGap = 1;
               this.skin = ButtonBarButtonSkin;
               this.selectedOverSkin = null;
            };
         }
      }
   }
}
