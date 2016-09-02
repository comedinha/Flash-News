package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.ActivatorSkin;
   import mx.skins.halo.MenuBarBackgroundSkin;
   
   public class _MenuBarStyle
   {
       
      
      public function _MenuBarStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MenuBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("MenuBar",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.itemSkin = ActivatorSkin;
               this.backgroundSkin = MenuBarBackgroundSkin;
               this.translucent = false;
            };
         }
      }
   }
}
