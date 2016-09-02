package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _TabNavigatorStyle
   {
       
      
      public function _TabNavigatorStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("TabNavigator");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TabNavigator",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.borderColor = 11187123;
               this.horizontalGap = -1;
               this.horizontalAlign = "left";
               this.paddingTop = 10;
               this.tabOffset = 0;
               this.borderStyle = "solid";
            };
         }
      }
   }
}
