package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _plainStyle
   {
       
      
      public function _plainStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".plain");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".plain",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.paddingBottom = 0;
               this.backgroundImage = "";
               this.horizontalAlign = "left";
               this.paddingRight = 0;
               this.paddingTop = 0;
               this.paddingLeft = 0;
            };
         }
      }
   }
}
