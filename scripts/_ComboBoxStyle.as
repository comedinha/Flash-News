package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.ComboBoxArrowSkin;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
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
               this.leading = 0;
               this.paddingRight = 5;
               this.skin = ComboBoxArrowSkin;
               this.arrowButtonWidth = 22;
               this.disabledIconColor = 9542041;
               this.dropdownStyleName = "comboDropdown";
               this.paddingLeft = 5;
               this.fontWeight = "bold";
               this.cornerRadius = 5;
            };
         }
      }
   }
}
