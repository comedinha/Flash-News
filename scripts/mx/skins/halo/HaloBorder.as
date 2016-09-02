package mx.skins.halo
{
   import mx.skins.RectangularBorder;
   import mx.core.mx_internal;
   import mx.core.IContainer;
   import mx.core.EdgeMetrics;
   import flash.display.Graphics;
   import mx.utils.ColorUtil;
   import mx.core.FlexVersion;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   import flash.display.GradientType;
   import mx.graphics.RectangularDropShadow;
   import mx.core.IUIComponent;
   
   use namespace mx_internal;
   
   public class HaloBorder extends RectangularBorder
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var BORDER_WIDTHS:Object = {
         "none":0,
         "solid":1,
         "inset":2,
         "outset":2,
         "alert":3,
         "dropdown":2,
         "menuBorder":1,
         "comboNonEdit":2
      };
       
      
      mx_internal var radiusObj:Object;
      
      mx_internal var backgroundHole:Object;
      
      mx_internal var radius:Number;
      
      mx_internal var bRoundedCorners:Boolean;
      
      mx_internal var backgroundColor:Object;
      
      private var dropShadow:RectangularDropShadow;
      
      protected var _borderMetrics:EdgeMetrics;
      
      mx_internal var backgroundAlphaName:String;
      
      public function HaloBorder()
      {
         super();
         BORDER_WIDTHS["default"] = 3;
      }
      
      override public function styleChanged(param1:String) : void
      {
         if(param1 == null || param1 == "styleName" || param1 == "borderStyle" || param1 == "borderThickness" || param1 == "borderSides")
         {
            _borderMetrics = null;
         }
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(isNaN(param1) || isNaN(param2))
         {
            return;
         }
         super.updateDisplayList(param1,param2);
         backgroundColor = getBackgroundColor();
         bRoundedCorners = false;
         backgroundAlphaName = "backgroundAlpha";
         backgroundHole = null;
         radius = 0;
         radiusObj = null;
         drawBorder(param1,param2);
         drawBackground(param1,param2);
      }
      
      mx_internal function drawBorder(param1:Number, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:uint = 0;
         var _loc11_:Boolean = false;
         var _loc12_:uint = 0;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:Boolean = false;
         var _loc20_:Object = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Object = null;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:IContainer = null;
         var _loc30_:EdgeMetrics = null;
         var _loc31_:* = false;
         var _loc32_:Number = NaN;
         var _loc33_:Array = null;
         var _loc34_:uint = 0;
         var _loc35_:Boolean = false;
         var _loc36_:Number = NaN;
         var _loc3_:String = getStyle("borderStyle");
         var _loc4_:Array = getStyle("highlightAlphas");
         var _loc21_:Boolean = false;
         var _loc26_:Graphics = graphics;
         _loc26_.clear();
         if(_loc3_)
         {
            switch(_loc3_)
            {
               case "none":
                  break;
               case "inset":
                  _loc7_ = getStyle("borderColor");
                  _loc22_ = ColorUtil.adjustBrightness2(_loc7_,-40);
                  _loc23_ = ColorUtil.adjustBrightness2(_loc7_,25);
                  _loc24_ = ColorUtil.adjustBrightness2(_loc7_,40);
                  _loc25_ = backgroundColor;
                  if(_loc25_ === null || _loc25_ === "")
                  {
                     _loc25_ = _loc7_;
                  }
                  draw3dBorder(_loc23_,_loc22_,_loc24_,Number(_loc25_),Number(_loc25_),Number(_loc25_));
                  break;
               case "outset":
                  _loc7_ = getStyle("borderColor");
                  _loc22_ = ColorUtil.adjustBrightness2(_loc7_,-40);
                  _loc23_ = ColorUtil.adjustBrightness2(_loc7_,-25);
                  _loc24_ = ColorUtil.adjustBrightness2(_loc7_,40);
                  _loc25_ = backgroundColor;
                  if(_loc25_ === null || _loc25_ === "")
                  {
                     _loc25_ = _loc7_;
                  }
                  draw3dBorder(_loc23_,_loc24_,_loc22_,Number(_loc25_),Number(_loc25_),Number(_loc25_));
                  break;
               case "alert":
               case "default":
                  if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
                  {
                     _loc27_ = getStyle("backgroundAlpha");
                     _loc5_ = getStyle("borderAlpha");
                     backgroundAlphaName = "borderAlpha";
                     radius = getStyle("cornerRadius");
                     bRoundedCorners = getStyle("roundedBottomCorners").toString().toLowerCase() == "true";
                     _loc28_ = !!bRoundedCorners?Number(radius):Number(0);
                     drawDropShadow(0,0,param1,param2,radius,radius,_loc28_,_loc28_);
                     if(!bRoundedCorners)
                     {
                        radiusObj = {};
                     }
                     _loc29_ = parent as IContainer;
                     if(_loc29_)
                     {
                        _loc30_ = _loc29_.viewMetrics;
                        backgroundHole = {
                           "x":_loc30_.left,
                           "y":_loc30_.top,
                           "w":Math.max(0,param1 - _loc30_.left - _loc30_.right),
                           "h":Math.max(0,param2 - _loc30_.top - _loc30_.bottom),
                           "r":0
                        };
                        if(backgroundHole.w > 0 && backgroundHole.h > 0)
                        {
                           if(_loc27_ != _loc5_)
                           {
                              drawDropShadow(backgroundHole.x,backgroundHole.y,backgroundHole.w,backgroundHole.h,0,0,0,0);
                           }
                           _loc26_.beginFill(Number(backgroundColor),_loc27_);
                           _loc26_.drawRect(backgroundHole.x,backgroundHole.y,backgroundHole.w,backgroundHole.h);
                           _loc26_.endFill();
                        }
                     }
                     backgroundColor = getStyle("borderColor");
                  }
                  break;
               case "dropdown":
                  _loc12_ = getStyle("dropdownBorderColor");
                  drawDropShadow(0,0,param1,param2,4,0,0,4);
                  drawRoundRect(0,0,param1,param2,{
                     "tl":4,
                     "tr":0,
                     "br":0,
                     "bl":4
                  },5068126,1);
                  drawRoundRect(0,0,param1,param2,{
                     "tl":4,
                     "tr":0,
                     "br":0,
                     "bl":4
                  },[16777215,16777215],[0.7,0],verticalGradientMatrix(0,0,param1,param2));
                  drawRoundRect(1,1,param1 - 1,param2 - 2,{
                     "tl":3,
                     "tr":0,
                     "br":0,
                     "bl":3
                  },16777215,1);
                  drawRoundRect(1,2,param1 - 1,param2 - 3,{
                     "tl":3,
                     "tr":0,
                     "br":0,
                     "bl":3
                  },[15658734,16777215],1,verticalGradientMatrix(0,0,param1 - 1,param2 - 3));
                  if(!isNaN(_loc12_))
                  {
                     drawRoundRect(0,0,param1 + 1,param2,{
                        "tl":4,
                        "tr":0,
                        "br":0,
                        "bl":4
                     },_loc12_,0.5);
                     drawRoundRect(1,1,param1 - 1,param2 - 2,{
                        "tl":3,
                        "tr":0,
                        "br":0,
                        "bl":3
                     },16777215,1);
                     drawRoundRect(1,2,param1 - 1,param2 - 3,{
                        "tl":3,
                        "tr":0,
                        "br":0,
                        "bl":3
                     },[15658734,16777215],1,verticalGradientMatrix(0,0,param1 - 1,param2 - 3));
                  }
                  backgroundColor = null;
                  break;
               case "menuBorder":
                  _loc7_ = getStyle("borderColor");
                  drawRoundRect(0,0,param1,param2,0,_loc7_,1);
                  drawDropShadow(1,1,param1 - 2,param2 - 2,0,0,0,0);
                  break;
               case "comboNonEdit":
                  break;
               case "controlBar":
                  if(param1 == 0 || param2 == 0)
                  {
                     backgroundColor = null;
                     break;
                  }
                  _loc14_ = getStyle("footerColors");
                  _loc31_ = _loc14_ != null;
                  _loc32_ = getStyle("borderAlpha");
                  if(_loc31_)
                  {
                     _loc26_.lineStyle(0,_loc14_.length > 0?uint(_loc14_[1]):uint(_loc14_[0]),_loc32_);
                     _loc26_.moveTo(0,0);
                     _loc26_.lineTo(param1,0);
                     _loc26_.lineStyle(0,0,0);
                     if(parent && parent.parent && parent.parent is IStyleClient)
                     {
                        radius = IStyleClient(parent.parent).getStyle("cornerRadius");
                        _loc32_ = IStyleClient(parent.parent).getStyle("borderAlpha");
                     }
                     if(isNaN(radius))
                     {
                        radius = 0;
                     }
                     if(IStyleClient(parent.parent).getStyle("roundedBottomCorners").toString().toLowerCase() != "true")
                     {
                        radius = 0;
                     }
                     drawRoundRect(0,1,param1,param2 - 1,{
                        "tl":0,
                        "tr":0,
                        "bl":radius,
                        "br":radius
                     },_loc14_,_loc32_,verticalGradientMatrix(0,0,param1,param2));
                     if(_loc14_.length > 1 && _loc14_[0] != _loc14_[1])
                     {
                        drawRoundRect(0,1,param1,param2 - 1,{
                           "tl":0,
                           "tr":0,
                           "bl":radius,
                           "br":radius
                        },[16777215,16777215],_loc4_,verticalGradientMatrix(0,0,param1,param2));
                        drawRoundRect(1,2,param1 - 2,param2 - 3,{
                           "tl":0,
                           "tr":0,
                           "bl":radius - 1,
                           "br":radius - 1
                        },_loc14_,_loc32_,verticalGradientMatrix(0,0,param1,param2));
                     }
                  }
                  backgroundColor = null;
                  break;
               case "applicationControlBar":
                  _loc13_ = getStyle("fillColors");
                  _loc5_ = getStyle("backgroundAlpha");
                  _loc4_ = getStyle("highlightAlphas");
                  _loc33_ = getStyle("fillAlphas");
                  _loc11_ = getStyle("docked");
                  _loc34_ = uint(backgroundColor);
                  radius = getStyle("cornerRadius");
                  if(!radius)
                  {
                     radius = 0;
                  }
                  drawDropShadow(0,1,param1,param2 - 1,radius,radius,radius,radius);
                  if(backgroundColor !== null && StyleManager.isValidStyleValue(backgroundColor))
                  {
                     drawRoundRect(0,1,param1,param2 - 1,radius,_loc34_,_loc5_,verticalGradientMatrix(0,0,param1,param2));
                  }
                  drawRoundRect(0,1,param1,param2 - 1,radius,_loc13_,_loc33_,verticalGradientMatrix(0,0,param1,param2));
                  drawRoundRect(0,1,param1,param2 / 2 - 1,{
                     "tl":radius,
                     "tr":radius,
                     "bl":0,
                     "br":0
                  },[16777215,16777215],_loc4_,verticalGradientMatrix(0,0,param1,param2 / 2 - 1));
                  drawRoundRect(0,1,param1,param2 - 1,{
                     "tl":radius,
                     "tr":radius,
                     "bl":0,
                     "br":0
                  },16777215,0.3,null,GradientType.LINEAR,null,{
                     "x":0,
                     "y":2,
                     "w":param1,
                     "h":param2 - 2,
                     "r":{
                        "tl":radius,
                        "tr":radius,
                        "bl":0,
                        "br":0
                     }
                  });
                  backgroundColor = null;
                  break;
               default:
                  _loc7_ = getStyle("borderColor");
                  _loc9_ = getStyle("borderThickness");
                  _loc8_ = getStyle("borderSides");
                  _loc35_ = true;
                  radius = getStyle("cornerRadius");
                  bRoundedCorners = getStyle("roundedBottomCorners").toString().toLowerCase() == "true";
                  _loc36_ = Math.max(radius - _loc9_,0);
                  _loc20_ = {
                     "x":_loc9_,
                     "y":_loc9_,
                     "w":param1 - _loc9_ * 2,
                     "h":param2 - _loc9_ * 2,
                     "r":_loc36_
                  };
                  if(!bRoundedCorners)
                  {
                     radiusObj = {
                        "tl":radius,
                        "tr":radius,
                        "bl":0,
                        "br":0
                     };
                     _loc20_.r = {
                        "tl":_loc36_,
                        "tr":_loc36_,
                        "bl":0,
                        "br":0
                     };
                  }
                  if(_loc8_ != "left top right bottom")
                  {
                     _loc20_.r = {
                        "tl":_loc36_,
                        "tr":_loc36_,
                        "bl":(!!bRoundedCorners?_loc36_:0),
                        "br":(!!bRoundedCorners?_loc36_:0)
                     };
                     radiusObj = {
                        "tl":radius,
                        "tr":radius,
                        "bl":(!!bRoundedCorners?radius:0),
                        "br":(!!bRoundedCorners?radius:0)
                     };
                     _loc8_ = _loc8_.toLowerCase();
                     if(_loc8_.indexOf("left") == -1)
                     {
                        _loc20_.x = 0;
                        _loc20_.w = _loc20_.w + _loc9_;
                        _loc20_.r.tl = 0;
                        _loc20_.r.bl = 0;
                        radiusObj.tl = 0;
                        radiusObj.bl = 0;
                        _loc35_ = false;
                     }
                     if(_loc8_.indexOf("top") == -1)
                     {
                        _loc20_.y = 0;
                        _loc20_.h = _loc20_.h + _loc9_;
                        _loc20_.r.tl = 0;
                        _loc20_.r.tr = 0;
                        radiusObj.tl = 0;
                        radiusObj.tr = 0;
                        _loc35_ = false;
                     }
                     if(_loc8_.indexOf("right") == -1)
                     {
                        _loc20_.w = _loc20_.w + _loc9_;
                        _loc20_.r.tr = 0;
                        _loc20_.r.br = 0;
                        radiusObj.tr = 0;
                        radiusObj.br = 0;
                        _loc35_ = false;
                     }
                     if(_loc8_.indexOf("bottom") == -1)
                     {
                        _loc20_.h = _loc20_.h + _loc9_;
                        _loc20_.r.bl = 0;
                        _loc20_.r.br = 0;
                        radiusObj.bl = 0;
                        radiusObj.br = 0;
                        _loc35_ = false;
                     }
                  }
                  if(radius == 0 && _loc35_)
                  {
                     drawDropShadow(0,0,param1,param2,0,0,0,0);
                     _loc26_.beginFill(_loc7_);
                     _loc26_.drawRect(0,0,param1,param2);
                     _loc26_.drawRect(_loc9_,_loc9_,param1 - 2 * _loc9_,param2 - 2 * _loc9_);
                     _loc26_.endFill();
                  }
                  else if(radiusObj)
                  {
                     drawDropShadow(0,0,param1,param2,radiusObj.tl,radiusObj.tr,radiusObj.br,radiusObj.bl);
                     drawRoundRect(0,0,param1,param2,radiusObj,_loc7_,1,null,null,null,_loc20_);
                     radiusObj.tl = Math.max(radius - _loc9_,0);
                     radiusObj.tr = Math.max(radius - _loc9_,0);
                     radiusObj.bl = !!bRoundedCorners?Math.max(radius - _loc9_,0):0;
                     radiusObj.br = !!bRoundedCorners?Math.max(radius - _loc9_,0):0;
                  }
                  else
                  {
                     drawDropShadow(0,0,param1,param2,radius,radius,radius,radius);
                     drawRoundRect(0,0,param1,param2,radius,_loc7_,1,null,null,null,_loc20_);
                     radius = Math.max(getStyle("cornerRadius") - _loc9_,0);
                  }
            }
         }
      }
      
      mx_internal function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:EdgeMetrics = null;
         var _loc7_:Graphics = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         if(backgroundColor !== null && backgroundColor !== "" || getStyle("mouseShield") || getStyle("mouseShieldChildren"))
         {
            _loc4_ = Number(backgroundColor);
            _loc5_ = 1;
            _loc6_ = getBackgroundColorMetrics();
            _loc7_ = graphics;
            if(isNaN(_loc4_) || backgroundColor === "" || backgroundColor === null)
            {
               _loc5_ = 0;
               _loc4_ = 16777215;
            }
            else
            {
               _loc5_ = getStyle(backgroundAlphaName);
            }
            if(radius != 0 || backgroundHole)
            {
               _loc8_ = _loc6_.bottom;
               if(radiusObj)
               {
                  _loc9_ = Math.max(radius - Math.max(_loc6_.top,_loc6_.left,_loc6_.right),0);
                  _loc10_ = !!bRoundedCorners?Number(Math.max(radius - Math.max(_loc6_.bottom,_loc6_.left,_loc6_.right),0)):Number(0);
                  radiusObj = {
                     "tl":_loc9_,
                     "tr":_loc9_,
                     "bl":_loc10_,
                     "br":_loc10_
                  };
                  drawRoundRect(_loc6_.left,_loc6_.top,width - (_loc6_.left + _loc6_.right),height - (_loc6_.top + _loc8_),radiusObj,_loc4_,_loc5_,null,GradientType.LINEAR,null,backgroundHole);
               }
               else
               {
                  drawRoundRect(_loc6_.left,_loc6_.top,width - (_loc6_.left + _loc6_.right),height - (_loc6_.top + _loc8_),radius,_loc4_,_loc5_,null,GradientType.LINEAR,null,backgroundHole);
               }
            }
            else
            {
               _loc7_.beginFill(_loc4_,_loc5_);
               _loc7_.drawRect(_loc6_.left,_loc6_.top,param1 - _loc6_.right - _loc6_.left,param2 - _loc6_.bottom - _loc6_.top);
               _loc7_.endFill();
            }
         }
         var _loc3_:String = getStyle("borderStyle");
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 && (_loc3_ == "alert" || _loc3_ == "default") && getStyle("headerColors") == null)
         {
            _loc11_ = getStyle("highlightAlphas");
            _loc12_ = !!_loc11_?Number(_loc11_[0]):Number(0.3);
            drawRoundRect(0,0,param1,param2,{
               "tl":radius,
               "tr":radius,
               "bl":0,
               "br":0
            },16777215,_loc12_,null,GradientType.LINEAR,null,{
               "x":0,
               "y":1,
               "w":param1,
               "h":param2 - 1,
               "r":{
                  "tl":radius,
                  "tr":radius,
                  "bl":0,
                  "br":0
               }
            });
         }
      }
      
      mx_internal function drawDropShadow(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Boolean = false;
         if(getStyle("dropShadowEnabled") == false || getStyle("dropShadowEnabled") == "false" || param3 == 0 || param4 == 0)
         {
            return;
         }
         var _loc9_:Number = getStyle("shadowDistance");
         var _loc10_:String = getStyle("shadowDirection");
         if(getStyle("borderStyle") == "applicationControlBar")
         {
            _loc12_ = getStyle("docked");
            _loc11_ = !!_loc12_?Number(90):Number(getDropShadowAngle(_loc9_,_loc10_));
            _loc9_ = Math.abs(_loc9_);
         }
         else
         {
            _loc11_ = getDropShadowAngle(_loc9_,_loc10_);
            _loc9_ = Math.abs(_loc9_) + 2;
         }
         if(!dropShadow)
         {
            dropShadow = new RectangularDropShadow();
         }
         dropShadow.distance = _loc9_;
         dropShadow.angle = _loc11_;
         dropShadow.color = getStyle("dropShadowColor");
         dropShadow.alpha = 0.4;
         dropShadow.tlRadius = param5;
         dropShadow.trRadius = param6;
         dropShadow.blRadius = param8;
         dropShadow.brRadius = param7;
         dropShadow.drawShadow(graphics,param1,param2,param3,param4);
      }
      
      mx_internal function getBackgroundColor() : Object
      {
         var _loc2_:Object = null;
         var _loc1_:IUIComponent = parent as IUIComponent;
         if(_loc1_ && !_loc1_.enabled)
         {
            _loc2_ = getStyle("backgroundDisabledColor");
            if(_loc2_ !== null && StyleManager.isValidStyleValue(_loc2_))
            {
               return _loc2_;
            }
         }
         return getStyle("backgroundColor");
      }
      
      mx_internal function draw3dBorder(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc7_:Number = width;
         var _loc8_:Number = height;
         drawDropShadow(0,0,width,height,0,0,0,0);
         var _loc9_:Graphics = graphics;
         _loc9_.beginFill(param1);
         _loc9_.drawRect(0,0,_loc7_,_loc8_);
         _loc9_.drawRect(1,0,_loc7_ - 2,_loc8_);
         _loc9_.endFill();
         _loc9_.beginFill(param2);
         _loc9_.drawRect(1,0,_loc7_ - 2,1);
         _loc9_.endFill();
         _loc9_.beginFill(param3);
         _loc9_.drawRect(1,_loc8_ - 1,_loc7_ - 2,1);
         _loc9_.endFill();
         _loc9_.beginFill(param4);
         _loc9_.drawRect(1,1,_loc7_ - 2,1);
         _loc9_.endFill();
         _loc9_.beginFill(param5);
         _loc9_.drawRect(1,_loc8_ - 2,_loc7_ - 2,1);
         _loc9_.endFill();
         _loc9_.beginFill(param6);
         _loc9_.drawRect(1,2,_loc7_ - 2,_loc8_ - 4);
         _loc9_.drawRect(2,2,_loc7_ - 4,_loc8_ - 4);
         _loc9_.endFill();
      }
      
      mx_internal function getBackgroundColorMetrics() : EdgeMetrics
      {
         return borderMetrics;
      }
      
      mx_internal function getDropShadowAngle(param1:Number, param2:String) : Number
      {
         if(param2 == "left")
         {
            return param1 >= 0?Number(135):Number(225);
         }
         if(param2 == "right")
         {
            return param1 >= 0?Number(45):Number(315);
         }
         return param1 >= 0?Number(90):Number(270);
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         var _loc1_:Number = NaN;
         var _loc3_:String = null;
         if(_borderMetrics)
         {
            return _borderMetrics;
         }
         var _loc2_:String = getStyle("borderStyle");
         if(_loc2_ == "default" || _loc2_ == "alert")
         {
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               _borderMetrics = new EdgeMetrics(0,0,0,0);
            }
            else
            {
               return EdgeMetrics.EMPTY;
            }
         }
         else if(_loc2_ == "controlBar" || _loc2_ == "applicationControlBar")
         {
            _borderMetrics = new EdgeMetrics(1,1,1,1);
         }
         else if(_loc2_ == "solid")
         {
            _loc1_ = getStyle("borderThickness");
            if(isNaN(_loc1_))
            {
               _loc1_ = 0;
            }
            _borderMetrics = new EdgeMetrics(_loc1_,_loc1_,_loc1_,_loc1_);
            _loc3_ = getStyle("borderSides");
            if(_loc3_ != "left top right bottom")
            {
               if(_loc3_.indexOf("left") == -1)
               {
                  _borderMetrics.left = 0;
               }
               if(_loc3_.indexOf("top") == -1)
               {
                  _borderMetrics.top = 0;
               }
               if(_loc3_.indexOf("right") == -1)
               {
                  _borderMetrics.right = 0;
               }
               if(_loc3_.indexOf("bottom") == -1)
               {
                  _borderMetrics.bottom = 0;
               }
            }
         }
         else
         {
            _loc1_ = BORDER_WIDTHS[_loc2_];
            if(isNaN(_loc1_))
            {
               _loc1_ = 0;
            }
            _borderMetrics = new EdgeMetrics(_loc1_,_loc1_,_loc1_,_loc1_);
         }
         return _borderMetrics;
      }
   }
}
