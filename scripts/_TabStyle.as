package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.TabSkin;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _TabStyle
   {
       
      
      public function _TabStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("Tab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Tab",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.downSkin = null;
               this.upSkin = null;
               this.paddingBottom = 1;
               this.selectedDownSkin = null;
               this.overSkin = null;
               this.selectedUpSkin = null;
               this.skin = TabSkin;
               this.disabledSkin = null;
               this.selectedOverSkin = null;
               this.paddingTop = 1;
               this.selectedDisabledSkin = null;
            };
         }
      }
   }
}
