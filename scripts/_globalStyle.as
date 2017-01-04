package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.HaloBorder;
   import mx.skins.halo.HaloFocusRect;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _globalStyle
   {
       
      
      public function _globalStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("global");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("global",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.shadowDistance = 2;
               this.borderColor = 12040892;
               this.kerning = false;
               this.selectionDuration = 250;
               this.leading = 2;
               this.fontAntiAliasType = "advanced";
               this.paddingRight = 0;
               this.borderSkin = HaloBorder;
               this.cornerRadius = 0;
               this.borderThickness = 1;
               this.fontFamily = "Verdana";
               this.indentation = 17;
               this.paddingBottom = 0;
               this.repeatInterval = 35;
               this.textSelectedColor = 2831164;
               this.borderStyle = "inset";
               this.disabledIconColor = 10066329;
               this.repeatDelay = 500;
               this.dropShadowColor = 0;
               this.shadowColor = 15658734;
               this.fontWeight = "normal";
               this.verticalAlign = "top";
               this.focusBlendMode = "normal";
               this.textAlign = "left";
               this.focusAlpha = 0.4;
               this.fontSharpness = 0;
               this.shadowCapColor = 14015965;
               this.textDecoration = "none";
               this.fontStyle = "normal";
               this.shadowDirection = "center";
               this.version = "3.0.0";
               this.indicatorGap = 14;
               this.borderCapColor = 9542041;
               this.focusThickness = 2;
               this.themeColor = 40447;
               this.verticalGridLineColor = 14015965;
               this.fontSize = 10;
               this.textRollOverColor = 2831164;
               this.fillAlphas = [0.6,0.4,0.75,0.65];
               this.paddingLeft = 0;
               this.horizontalGridLineColor = 16250871;
               this.selectionDisabledColor = 14540253;
               this.strokeWidth = 1;
               this.fontGridFitType = "pixel";
               this.errorColor = 16711680;
               this.useRollOver = true;
               this.borderSides = "left top right bottom";
               this.color = 734012;
               this.buttonColor = 7305079;
               this.backgroundAlpha = 1;
               this.dropShadowEnabled = false;
               this.fillColors = [16777215,13421772,16777215,15658734];
               this.textIndent = 0;
               this.verticalGap = 6;
               this.fontThickness = 0;
               this.closeDuration = 250;
               this.fillColor = 16777215;
               this.roundedBottomCorners = true;
               this.highlightAlphas = [0.3,0];
               this.horizontalAlign = "left";
               this.verticalGridLines = true;
               this.backgroundSize = "auto";
               this.horizontalGridLines = false;
               this.paddingTop = 0;
               this.focusRoundedCorners = "tl tr bl br";
               this.focusSkin = HaloFocusRect;
               this.letterSpacing = 0;
               this.borderAlpha = 1;
               this.filled = true;
               this.openDuration = 250;
               this.disabledColor = 11187123;
               this.bevel = true;
               this.modalTransparencyColor = 14540253;
               this.horizontalGap = 8;
               this.embedFonts = false;
               this.modalTransparencyBlur = 3;
               this.stroked = false;
               this.modalTransparencyDuration = 100;
               this.modalTransparency = 0.5;
               this.iconColor = 1118481;
            };
         }
      }
   }
}
