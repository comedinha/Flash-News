package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.ComboBoxArrowSkin;
   
   public class _ComboBoxStyle
   {
       
      
      public function _ComboBoxStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("ComboBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ComboBox",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.fontWeight = "bold";
               this.disabledIconColor = 9542041;
               this.dropdownStyleName = "comboDropdown";
               this.leading = 0;
               this.arrowButtonWidth = 22;
               this.cornerRadius = 5;
               this.skin = ComboBoxArrowSkin;
               this.paddingLeft = 5;
               this.paddingRight = 5;
            };
         }
      }
   }
}
