package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _comboDropdownStyle
   {
       
      
      public function _comboDropdownStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".comboDropdown");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".comboDropdown",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.shadowDistance = 1;
               this.borderThickness = 0;
               this.backgroundColor = 16777215;
               this.leading = 0;
               this.paddingRight = 5;
               this.dropShadowEnabled = true;
               this.shadowDirection = "center";
               this.paddingLeft = 5;
               this.fontWeight = "normal";
               this.cornerRadius = 0;
            };
         }
      }
   }
}
