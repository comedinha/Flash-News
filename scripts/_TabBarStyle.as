package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _TabBarStyle
   {
       
      
      public function _TabBarStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("TabBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TabBar",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.verticalAlign = "top";
               this.horizontalGap = -1;
               this.textAlign = "center";
               this.horizontalAlign = "left";
               this.verticalGap = -1;
               this.selectedTabTextStyleName = "activeTabStyle";
            };
         }
      }
   }
}
