package shared.skins
{
   import mx.styles.ISimpleStyleClient;
   import mx.core.IBorder;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import shared.utility.StringHelper;
   import mx.styles.IStyleClient;
   import mx.core.EdgeMetrics;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   
   public class BitmapGrid implements ISimpleStyleClient, IBorder
   {
       
      
      private var m_BitmapStyle:Vector.<Object>;
      
      private var m_Width:Number = 0;
      
      private var m_Height:Number = 0;
      
      private var m_BitmapCell:Vector.<BitmapGridCell>;
      
      private var m_StyleName:IStyleClient = null;
      
      private var m_MinBorder:EdgeMetrics;
      
      private var m_BitmapMask:uint = 0;
      
      private var m_StylePrefix:String = null;
      
      private var m_InvalidStyle:Boolean = false;
      
      private var m_MaxBorder:EdgeMetrics;
      
      public function BitmapGrid(param1:* = null, param2:String = null)
      {
         this.m_BitmapStyle = new Vector.<Object>(EBitmap.NUM_BITMAPS,true);
         this.m_BitmapCell = new Vector.<BitmapGridCell>(EBitmap.NUM_BITMAPS,true);
         this.m_MaxBorder = new EdgeMetrics();
         this.m_MinBorder = new EdgeMetrics();
         super();
         this.styleName = param1;
         this.stylePrefix = param2;
      }
      
      public function getStyle(param1:String) : *
      {
         return this.m_StyleName != null?this.m_StyleName.getStyle(param1):null;
      }
      
      public function styleChanged(param1:String) : void
      {
         this.m_InvalidStyle = true;
      }
      
      public function get stylePrefix() : String
      {
         return this.m_StylePrefix;
      }
      
      private function getDefaultReferenceCell(param1:int) : int
      {
         switch(param1)
         {
            case EBitmap.TOP:
            case EBitmap.LEFT:
            case EBitmap.BOTTOM:
            case EBitmap.RIGHT:
               return EBitmap.RIGHT;
            case EBitmap.TOP_LEFT:
            case EBitmap.BOTTOM_LEFT:
            case EBitmap.BOTTOM_RIGHT:
            case EBitmap.TOP_RIGHT:
               return EBitmap.TOP_RIGHT;
            default:
               return EBitmap.NONE;
         }
      }
      
      public function set stylePrefix(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         if(this.m_StylePrefix != param1)
         {
            this.m_StylePrefix = param1;
            this.m_InvalidStyle = true;
         }
      }
      
      private function getMinCellSize(... rest) : Point
      {
         var _loc2_:Point = new Point(Number.POSITIVE_INFINITY,Number.POSITIVE_INFINITY);
         var _loc3_:int = 0;
         var _loc4_:int = rest.length - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = rest[_loc4_];
            if(this.isCellVisible(_loc3_))
            {
               _loc2_.x = Math.min(_loc2_.x,this.m_BitmapCell[_loc3_].realWidth);
               _loc2_.y = Math.min(_loc2_.y,this.m_BitmapCell[_loc3_].realHeight);
            }
            _loc4_--;
         }
         if(!isFinite(_loc2_.x))
         {
            _loc2_.x = 0;
         }
         if(!isFinite(_loc2_.y))
         {
            _loc2_.y = 0;
         }
         return _loc2_;
      }
      
      private function getCellMask(param1:String) : uint
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:uint = 0;
         if(param1 != null)
         {
            _loc3_ = param1.split(/ +/);
            _loc4_ = 0;
            _loc5_ = _loc3_.length - 1;
            while(_loc5_ >= 0)
            {
               _loc4_ = EBitmap.s_ParseString(_loc3_[_loc5_]);
               if(_loc4_ == EBitmap.ALL)
               {
                  _loc2_ = _loc2_ | 4294967295;
               }
               else if(_loc4_ != EBitmap.NONE)
               {
                  _loc2_ = _loc2_ | 1 << _loc4_;
               }
               _loc5_--;
            }
         }
         return _loc2_;
      }
      
      public function validateStyle() : void
      {
         if(this.m_InvalidStyle)
         {
            this.doValidateStyle();
            this.m_InvalidStyle = false;
         }
      }
      
      private function getReferenceTransform(param1:int, param2:int) : Matrix
      {
         loop0:
         switch(param1)
         {
            case EBitmap.TOP:
               switch(param2)
               {
                  case EBitmap.TOP:
                     return new Matrix(1,0,0,1);
                  case EBitmap.LEFT:
                     return new Matrix(0,-1,1,0);
                  case EBitmap.BOTTOM:
                     return new Matrix(1,0,0,-1);
                  case EBitmap.RIGHT:
                     return new Matrix(0,1,-1,0);
                  default:
                     addr71:
                     switch(param2)
                     {
                        case EBitmap.TOP_LEFT:
                           return new Matrix(1,0,0,1);
                        case EBitmap.BOTTOM_LEFT:
                           return new Matrix(1,0,0,-1);
                        case EBitmap.BOTTOM_RIGHT:
                           return new Matrix(-1,0,0,-1);
                        case EBitmap.TOP_RIGHT:
                           return new Matrix(-1,0,0,1);
                        default:
                           addr139:
                           switch(param2)
                           {
                              case EBitmap.TOP:
                                 return new Matrix(0,1,-1,0);
                              case EBitmap.LEFT:
                                 return new Matrix(1,0,0,1);
                              case EBitmap.BOTTOM:
                                 return new Matrix(0,-1,1,0);
                              case EBitmap.RIGHT:
                                 return new Matrix(-1,0,0,1);
                              default:
                                 addr207:
                                 switch(param2)
                                 {
                                    case EBitmap.TOP_LEFT:
                                       return new Matrix(1,0,0,-1);
                                    case EBitmap.BOTTOM_LEFT:
                                       return new Matrix(1,0,0,1);
                                    case EBitmap.BOTTOM_RIGHT:
                                       return new Matrix(-1,0,0,1);
                                    case EBitmap.TOP_RIGHT:
                                       return new Matrix(-1,0,0,-1);
                                    default:
                                       addr275:
                                       switch(param2)
                                       {
                                          case EBitmap.TOP:
                                             return new Matrix(1,0,0,-1);
                                          case EBitmap.LEFT:
                                             return new Matrix(0,-1,1,0);
                                          case EBitmap.BOTTOM:
                                             return new Matrix(1,0,0,1);
                                          case EBitmap.RIGHT:
                                             return new Matrix(0,1,-1,0);
                                          default:
                                             addr343:
                                             switch(param2)
                                             {
                                                case EBitmap.TOP_LEFT:
                                                   return new Matrix(-1,0,0,-1);
                                                case EBitmap.BOTTOM_LEFT:
                                                   return new Matrix(-1,0,0,1);
                                                case EBitmap.BOTTOM_RIGHT:
                                                   return new Matrix(1,0,0,1);
                                                case EBitmap.TOP_RIGHT:
                                                   return new Matrix(1,0,0,-1);
                                                default:
                                                   addr411:
                                                   switch(param2)
                                                   {
                                                      case EBitmap.TOP:
                                                         return new Matrix(0,-1,1,0);
                                                      case EBitmap.LEFT:
                                                         return new Matrix(-1,0,0,1);
                                                      case EBitmap.BOTTOM:
                                                         return new Matrix(0,1,-1,0);
                                                      case EBitmap.RIGHT:
                                                         return new Matrix(1,0,0,1);
                                                      default:
                                                         addr479:
                                                         switch(param2)
                                                         {
                                                            case EBitmap.TOP_LEFT:
                                                               return new Matrix(-1,0,0,1);
                                                            case EBitmap.BOTTOM_LEFT:
                                                               return new Matrix(-1,0,0,-1);
                                                            case EBitmap.BOTTOM_RIGHT:
                                                               return new Matrix(1,0,0,-1);
                                                            case EBitmap.TOP_RIGHT:
                                                               return new Matrix(1,0,0,1);
                                                            default:
                                                               break loop0;
                                                         }
                                                   }
                                             }
                                       }
                                 }
                           }
                     }
               }
            case EBitmap.TOP_LEFT:
               §§goto(addr71);
            case EBitmap.LEFT:
               §§goto(addr139);
            case EBitmap.BOTTOM_LEFT:
               §§goto(addr207);
            case EBitmap.BOTTOM:
               §§goto(addr275);
            case EBitmap.BOTTOM_RIGHT:
               §§goto(addr343);
            case EBitmap.RIGHT:
               §§goto(addr411);
            case EBitmap.TOP_RIGHT:
               §§goto(addr479);
            default:
               §§goto(addr479);
         }
         return null;
      }
      
      public function get styleName() : Object
      {
         return this.m_StyleName;
      }
      
      private function isValidReferenceCell(param1:int, param2:int) : Boolean
      {
         if(param1 == EBitmap.NONE || param1 == EBitmap.CENTER || param2 == EBitmap.NONE || param2 == EBitmap.CENTER || param1 == param2)
         {
            return false;
         }
         var _loc3_:Boolean = param1 == EBitmap.TOP || param1 == EBitmap.LEFT || param1 == EBitmap.BOTTOM || param1 == EBitmap.RIGHT;
         var _loc4_:Boolean = param2 == EBitmap.TOP || param2 == EBitmap.LEFT || param2 == EBitmap.BOTTOM || param2 == EBitmap.RIGHT;
         return _loc4_ && _loc3_ || !_loc4_ && !_loc3_;
      }
      
      protected function getMaskStyleName() : String
      {
         return this.m_StylePrefix != null?this.m_StylePrefix + "Mask":"mask";
      }
      
      protected function getBitmapStyleName(param1:int) : String
      {
         return this.m_StylePrefix != null?this.m_StylePrefix + StringHelper.s_Capitalise(EBitmap.s_ToString(param1)) + "Image":EBitmap.s_ToString(param1) + "Image";
      }
      
      public function get measuredHeight() : Number
      {
         this.validateStyle();
         return this.m_Height;
      }
      
      private function isCellVisible(param1:int) : Boolean
      {
         return (this.m_BitmapMask & 1 << param1) > 0 && this.m_BitmapCell[param1] != null && this.m_BitmapCell[param1].bitmap != null;
      }
      
      public function get measuredWidth() : Number
      {
         this.validateStyle();
         return this.m_Width;
      }
      
      protected function getBorderStyleName(param1:String) : String
      {
         return this.m_StylePrefix != null?this.m_StylePrefix + StringHelper.s_Capitalise(param1):param1;
      }
      
      protected function doValidateStyle() : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:BitmapGridCell = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < EBitmap.NUM_BITMAPS)
         {
            _loc4_ = this.getStyle(this.getBitmapStyleName(_loc1_));
            _loc5_ = EBitmap.NONE;
            if(_loc4_ == null || _loc4_ is String || this.m_BitmapStyle[_loc1_] != _loc4_)
            {
               this.m_BitmapStyle[_loc1_] = _loc4_;
               this.m_BitmapCell[_loc1_] = null;
               if(_loc4_ is Class || _loc4_ is Bitmap)
               {
                  this.m_BitmapCell[_loc1_] = new BitmapGridCell(_loc1_,_loc4_);
               }
               else if(_loc4_ is String && (_loc5_ = EBitmap.s_ParseString(String(_loc4_))) != EBitmap.NONE && this.isValidReferenceCell(_loc5_,_loc1_))
               {
                  _loc3_.push({
                     "source":_loc5_,
                     "target":_loc1_
                  });
               }
               else if((_loc5_ = this.getDefaultReferenceCell(_loc1_)) != EBitmap.NONE)
               {
                  _loc3_.push({
                     "source":_loc5_,
                     "target":_loc1_
                  });
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         _loc2_ = _loc3_.length;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = _loc3_[_loc1_].source;
            _loc7_ = _loc3_[_loc1_].target;
            _loc8_ = null;
            if(this.m_BitmapCell[_loc6_] != null)
            {
               _loc8_ = new BitmapGridCell(_loc7_,this.m_BitmapCell[_loc6_].bitmap);
               _loc8_.matrix = this.getReferenceTransform(_loc6_,_loc7_);
               this.m_BitmapCell[_loc7_] = _loc8_;
            }
            _loc1_++;
         }
         if(this.getStyle(this.getMaskStyleName()) !== undefined)
         {
            this.m_BitmapMask = this.getCellMask(String(this.getStyle(this.getMaskStyleName())));
         }
         else
         {
            this.m_BitmapMask = 4294967295;
         }
         this.m_MaxBorder.bottom = this.getStyle(this.getBorderStyleName("bottom"));
         if(isNaN(this.m_MaxBorder.bottom))
         {
            this.m_MaxBorder.bottom = this.getMaxCellSize(EBitmap.BOTTOM_LEFT,EBitmap.BOTTOM,EBitmap.BOTTOM_RIGHT).y;
         }
         this.m_MaxBorder.left = this.getStyle(this.getBorderStyleName("left"));
         if(isNaN(this.m_MaxBorder.left))
         {
            this.m_MaxBorder.left = this.getMaxCellSize(EBitmap.TOP_LEFT,EBitmap.LEFT,EBitmap.BOTTOM_LEFT).x;
         }
         this.m_MaxBorder.right = this.getStyle(this.getBorderStyleName("right"));
         if(isNaN(this.m_MaxBorder.right))
         {
            this.m_MaxBorder.right = this.getMaxCellSize(EBitmap.TOP_RIGHT,EBitmap.RIGHT,EBitmap.BOTTOM_RIGHT).x;
         }
         this.m_MaxBorder.top = this.getStyle(this.getBorderStyleName("top"));
         if(isNaN(this.m_MaxBorder.top))
         {
            this.m_MaxBorder.top = this.getMaxCellSize(EBitmap.TOP_LEFT,EBitmap.TOP,EBitmap.TOP_RIGHT).y;
         }
         this.m_MinBorder.bottom = this.getMinCellSize(EBitmap.BOTTOM_LEFT,EBitmap.BOTTOM,EBitmap.BOTTOM_RIGHT).y;
         this.m_MinBorder.left = this.getMinCellSize(EBitmap.TOP_LEFT,EBitmap.LEFT,EBitmap.BOTTOM_LEFT).x;
         this.m_MinBorder.right = this.getMinCellSize(EBitmap.TOP_RIGHT,EBitmap.RIGHT,EBitmap.BOTTOM_RIGHT).x;
         this.m_MinBorder.top = this.getMinCellSize(EBitmap.TOP_LEFT,EBitmap.TOP,EBitmap.TOP_RIGHT).y;
         this.m_Height = this.m_MaxBorder.top + this.m_MaxBorder.bottom;
         this.m_Width = this.m_MaxBorder.left + this.m_MaxBorder.right;
         if(this.isCellVisible(EBitmap.CENTER))
         {
            this.m_Height = this.m_Height + this.getMaxCellSize(EBitmap.CENTER).y;
            this.m_Width = this.m_Width + this.getMaxCellSize(EBitmap.CENTER).x;
         }
         else
         {
            this.m_Height = this.m_Height + this.getMaxCellSize(EBitmap.LEFT,EBitmap.RIGHT).y;
            this.m_Width = this.m_Width + this.getMaxCellSize(EBitmap.TOP,EBitmap.BOTTOM).x;
         }
      }
      
      private function getMaxCellSize(... rest) : Point
      {
         var _loc2_:Point = new Point();
         var _loc3_:int = 0;
         var _loc4_:int = rest.length - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = rest[_loc4_];
            if(this.isCellVisible(_loc3_))
            {
               _loc2_.x = Math.max(_loc2_.x,this.m_BitmapCell[_loc3_].realWidth);
               _loc2_.y = Math.max(_loc2_.y,this.m_BitmapCell[_loc3_].realHeight);
            }
            _loc4_--;
         }
         return _loc2_;
      }
      
      public function invalidateStyle() : void
      {
         this.m_InvalidStyle = true;
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         this.validateStyle();
         return this.m_MaxBorder;
      }
      
      public function drawGrid(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         this.validateStyle();
         var _loc6_:Bitmap = null;
         var _loc7_:Matrix = null;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         if(this.isCellVisible(EBitmap.CENTER))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.CENTER].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.CENTER].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.CENTER].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.CENTER].realHeight;
            _loc7_.tx = param2 + this.m_MaxBorder.left;
            _loc7_.ty = param3 + this.m_MaxBorder.top;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,param4 - this.m_MaxBorder.left - this.m_MaxBorder.right,param5 - this.m_MaxBorder.top - this.m_MaxBorder.bottom);
         }
         else if(this.getStyle(this.getBackgroundColorStyleName()) !== undefined)
         {
            param1.beginFill(this.getStyle(this.getBackgroundColorStyleName()),this.getStyle(this.getBackgroundAlphaStyleName()));
            param1.drawRect(param2 + this.m_MaxBorder.left,param3 + this.m_MaxBorder.top,param4 - this.m_MaxBorder.left - this.m_MaxBorder.right,param5 - this.m_MaxBorder.top - this.m_MaxBorder.bottom);
         }
         if(this.isCellVisible(EBitmap.TOP))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.TOP].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.TOP].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.TOP].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.TOP].realHeight;
            _loc7_.tx = param2 + this.m_MinBorder.left;
            _loc7_.ty = param3;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,param4 - this.m_MinBorder.left - this.m_MinBorder.right,_loc9_);
         }
         if(this.isCellVisible(EBitmap.LEFT))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.LEFT].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.LEFT].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.LEFT].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.LEFT].realHeight;
            _loc7_.tx = param2;
            _loc7_.ty = param3 + this.m_MinBorder.top;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,_loc8_,param5 - this.m_MinBorder.top - this.m_MinBorder.bottom);
         }
         if(this.isCellVisible(EBitmap.BOTTOM))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.BOTTOM].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.BOTTOM].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.BOTTOM].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.BOTTOM].realHeight;
            _loc7_.tx = param2 + this.m_MinBorder.left;
            _loc7_.ty = param3 + param5 - _loc9_;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,param4 - this.m_MinBorder.left - this.m_MinBorder.right,_loc9_);
         }
         if(this.isCellVisible(EBitmap.RIGHT))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.RIGHT].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.RIGHT].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.RIGHT].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.RIGHT].realHeight;
            _loc7_.tx = param2 + param4 - _loc8_;
            _loc7_.ty = param3 + this.m_MinBorder.top;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,_loc8_,param5 - this.m_MinBorder.top - this.m_MinBorder.bottom);
         }
         if(this.isCellVisible(EBitmap.TOP_LEFT))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.TOP_LEFT].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.TOP_LEFT].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.TOP_LEFT].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.TOP_LEFT].realHeight;
            _loc7_.tx = param2;
            _loc7_.ty = param3;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,_loc8_,_loc9_);
         }
         if(this.isCellVisible(EBitmap.BOTTOM_LEFT))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.BOTTOM_LEFT].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.BOTTOM_LEFT].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.BOTTOM_LEFT].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.BOTTOM_LEFT].realHeight;
            _loc7_.tx = param2;
            _loc7_.ty = param3 + param5 - _loc9_;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,_loc8_,_loc9_);
         }
         if(this.isCellVisible(EBitmap.BOTTOM_RIGHT))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.BOTTOM_RIGHT].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.BOTTOM_RIGHT].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.BOTTOM_RIGHT].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.BOTTOM_RIGHT].realHeight;
            _loc7_.tx = param2 + param4 - _loc8_;
            _loc7_.ty = param3 + param5 - _loc9_;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,_loc8_,_loc9_);
         }
         if(this.isCellVisible(EBitmap.TOP_RIGHT))
         {
            _loc6_ = this.m_BitmapCell[EBitmap.TOP_RIGHT].bitmap;
            _loc7_ = this.m_BitmapCell[EBitmap.TOP_RIGHT].matrix;
            _loc8_ = this.m_BitmapCell[EBitmap.TOP_RIGHT].realWidth;
            _loc9_ = this.m_BitmapCell[EBitmap.TOP_RIGHT].realHeight;
            _loc7_.tx = param2 + param4 - _loc8_;
            _loc7_.ty = param3;
            param1.beginBitmapFill(_loc6_.bitmapData,_loc7_,true,false);
            param1.drawRect(_loc7_.tx,_loc7_.ty,_loc8_,_loc9_);
         }
      }
      
      protected function getBackgroundAlphaStyleName() : String
      {
         return this.m_StylePrefix != null?this.m_StylePrefix + "BackgroundAlpha":"backgroundAlpha";
      }
      
      protected function getBackgroundColorStyleName() : String
      {
         return this.m_StylePrefix != null?this.m_StylePrefix + "BackgroundColor":"backgroundColor";
      }
      
      public function set styleName(param1:Object) : void
      {
         if(this.m_StyleName != param1)
         {
            this.m_StyleName = param1 as IStyleClient;
            this.m_InvalidStyle = true;
         }
      }
   }
}

import flash.display.Bitmap;
import flash.geom.Matrix;
import shared.skins.EBitmap;

class BitmapGridCell
{
    
   
   private var m_Bitmap:Bitmap = null;
   
   private var m_ID:int;
   
   private var m_Matrix:Matrix = null;
   
   private var m_Width:Number = 0;
   
   private var m_Height:Number = 0;
   
   function BitmapGridCell(param1:int, param2:*)
   {
      var _loc3_:Class = null;
      this.m_ID = EBitmap.NONE;
      super();
      this.m_ID = param1;
      if(param2 is Bitmap)
      {
         this.m_Bitmap = Bitmap(param2);
      }
      else if(param2 is Class)
      {
         _loc3_ = Class(param2);
         this.m_Bitmap = Bitmap(new _loc3_());
      }
      this.matrix = new Matrix();
   }
   
   public function get realHeight() : Number
   {
      return this.m_Height;
   }
   
   public function get bitmap() : Bitmap
   {
      return this.m_Bitmap;
   }
   
   public function get matrix() : Matrix
   {
      return this.m_Matrix;
   }
   
   public function set matrix(param1:Matrix) : void
   {
      if(param1 == null)
      {
         param1 = new Matrix();
      }
      this.m_Matrix = param1;
      if(this.m_Bitmap != null)
      {
         this.m_Height = Math.abs(this.m_Matrix.c * this.m_Bitmap.width + this.m_Matrix.d * this.m_Bitmap.height);
         this.m_Width = Math.abs(this.m_Matrix.a * this.m_Bitmap.width + this.m_Matrix.b * this.m_Bitmap.height);
      }
      else
      {
         this.m_Height = 0;
         this.m_Width = 0;
      }
   }
   
   public function get realWidth() : Number
   {
      return this.m_Width;
   }
   
   public function get ID() : int
   {
      return this.m_ID;
   }
}
