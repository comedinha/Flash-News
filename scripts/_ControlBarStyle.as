package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _ControlBarStyle
   {
       
      
      public function _ControlBarStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("ControlBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ControlBar",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.verticalAlign = "middle";
               this.paddingBottom = 10;
               this.paddingRight = 10;
               this.disabledOverlayAlpha = 0;
               this.paddingTop = 10;
               this.borderStyle = "controlBar";
               this.paddingLeft = 10;
            };
         }
      }
   }
}
