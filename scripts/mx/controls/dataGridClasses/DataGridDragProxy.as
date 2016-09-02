package mx.controls.dataGridClasses
{
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.controls.listClasses.IListItemRenderer;
   import flash.geom.Point;
   import flash.display.DisplayObject;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.BaseListData;
   
   use namespace mx_internal;
   
   public class DataGridDragProxy extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function DataGridDragProxy()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         var _loc4_:IListItemRenderer = null;
         var _loc5_:UIComponent = null;
         var _loc6_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:DataGridColumn = null;
         var _loc11_:IListItemRenderer = null;
         var _loc12_:DataGridListData = null;
         var _loc13_:Point = null;
         super.createChildren();
         var _loc1_:Array = DataGridBase(owner).selectedItems;
         var _loc2_:int = _loc1_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = DataGridBase(owner).itemToItemRenderer(_loc1_[_loc3_]);
            if(_loc4_)
            {
               _loc6_ = _loc1_[_loc3_];
               _loc5_ = new UIComponent();
               addChild(DisplayObject(_loc5_));
               _loc7_ = 0;
               if(DataGridBase(owner).visibleLockedColumns)
               {
                  _loc8_ = DataGridBase(owner).visibleLockedColumns.length;
                  _loc9_ = 0;
                  while(_loc9_ < _loc8_)
                  {
                     _loc10_ = DataGridBase(owner).visibleLockedColumns[_loc9_];
                     _loc11_ = DataGridBase(owner).createColumnItemRenderer(_loc10_,false,_loc6_);
                     _loc12_ = new DataGridListData(_loc10_.itemToLabel(_loc6_),_loc10_.dataField,_loc10_.colNum,"",DataGridBase(owner));
                     _loc11_.styleName = DataGridBase(owner);
                     _loc5_.addChild(DisplayObject(_loc11_));
                     if(_loc11_ is IDropInListItemRenderer)
                     {
                        IDropInListItemRenderer(_loc11_).listData = !!_loc6_?_loc12_:null;
                     }
                     _loc11_.data = _loc6_;
                     _loc11_.visible = true;
                     _loc11_.setActualSize(_loc10_.width,_loc4_.height);
                     _loc11_.move(_loc7_,0);
                     _loc7_ = _loc7_ + _loc10_.width;
                     _loc9_++;
                  }
               }
               _loc8_ = DataGridBase(owner).visibleColumns.length;
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc10_ = DataGridBase(owner).visibleColumns[_loc9_];
                  _loc11_ = DataGridBase(owner).createColumnItemRenderer(_loc10_,false,_loc6_);
                  _loc12_ = new DataGridListData(_loc10_.itemToLabel(_loc6_),_loc10_.dataField,_loc10_.colNum,"",DataGridBase(owner));
                  _loc11_.styleName = DataGridBase(owner);
                  _loc5_.addChild(DisplayObject(_loc11_));
                  if(_loc11_ is IDropInListItemRenderer)
                  {
                     IDropInListItemRenderer(_loc11_).listData = !!_loc6_?_loc12_:null;
                  }
                  _loc11_.data = _loc6_;
                  _loc11_.visible = true;
                  _loc11_.setActualSize(_loc10_.width,_loc4_.height);
                  _loc11_.move(_loc7_,0);
                  _loc7_ = _loc7_ + _loc10_.width;
                  _loc9_++;
               }
               _loc5_.setActualSize(_loc7_,_loc4_.height);
               _loc13_ = new Point(0,0);
               _loc13_ = DisplayObject(_loc4_).localToGlobal(_loc13_);
               _loc13_ = DataGridBase(owner).globalToLocal(_loc13_);
               _loc5_.y = _loc13_.y;
               measuredHeight = _loc5_.y + _loc5_.height;
               measuredWidth = _loc7_;
            }
            _loc3_++;
         }
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         var _loc3_:UIComponent = null;
         super.measure();
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < numChildren)
         {
            _loc3_ = getChildAt(_loc4_) as UIComponent;
            if(_loc3_)
            {
               _loc1_ = Math.max(_loc1_,_loc3_.x + _loc3_.width);
               _loc2_ = Math.max(_loc2_,_loc3_.y + _loc3_.height);
            }
            _loc4_++;
         }
         measuredWidth = measuredMinWidth = _loc1_;
         measuredHeight = measuredMinHeight = _loc2_;
      }
   }
}
