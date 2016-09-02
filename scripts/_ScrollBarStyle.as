package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.ScrollThumbSkin;
   import mx.skins.halo.ScrollTrackSkin;
   import mx.skins.halo.ScrollArrowSkin;
   
   public class _ScrollBarStyle
   {
       
      
      public function _ScrollBarStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("ScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ScrollBar",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.thumbSkin = ScrollThumbSkin;
               this.borderColor = 12040892;
               this.paddingBottom = 0;
               this.thumbOffset = 0;
               this.paddingRight = 0;
               this.trackSkin = ScrollTrackSkin;
               this.downArrowSkin = ScrollArrowSkin;
               this.upArrowSkin = ScrollArrowSkin;
               this.paddingTop = 0;
               this.paddingLeft = 0;
               this.trackColors = [9738651,15198183];
               this.cornerRadius = 4;
            };
         }
      }
   }
}
