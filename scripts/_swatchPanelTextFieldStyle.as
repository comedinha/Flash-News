package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _swatchPanelTextFieldStyle
   {
       
      
      public function _swatchPanelTextFieldStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".swatchPanelTextField");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".swatchPanelTextField",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.highlightColor = 12897484;
               this.backgroundColor = 16777215;
               this.borderColor = 14015965;
               this.borderCapColor = 9542041;
               this.buttonColor = 7305079;
               this.shadowCapColor = 14015965;
               this.paddingRight = 5;
               this.borderStyle = "inset";
               this.paddingLeft = 5;
               this.shadowColor = 14015965;
            };
         }
      }
   }
}
