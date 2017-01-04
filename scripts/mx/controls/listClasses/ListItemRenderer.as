package mx.controls.listClasses
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.ToolTipEvent;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   public class ListItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _listData:ListData;
      
      private var _data:Object;
      
      protected var label:IUITextField;
      
      private var listOwner:ListBase;
      
      protected var icon:IFlexDisplayObject;
      
      public function ListItemRenderer()
      {
         super();
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      mx_internal function getLabel() : IUITextField
      {
         return label;
      }
      
      override protected function commitProperties() : void
      {
         var _loc2_:Class = null;
         super.commitProperties();
         var _loc1_:int = -1;
         if(hasFontContextChanged() && label != null)
         {
            _loc1_ = getChildIndex(DisplayObject(label));
            removeChild(DisplayObject(label));
            label = null;
         }
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
            if(_loc1_ == -1)
            {
               addChild(DisplayObject(label));
            }
            else
            {
               addChildAt(DisplayObject(label),_loc1_);
            }
         }
         if(icon)
         {
            removeChild(DisplayObject(icon));
            icon = null;
         }
         if(_data != null)
         {
            listOwner = ListBase(_listData.owner);
            if(_listData.icon)
            {
               _loc2_ = _listData.icon;
               icon = new _loc2_();
               addChild(DisplayObject(icon));
            }
            label.text = !!_listData.label?_listData.label:" ";
            label.multiline = listOwner.variableRowHeight;
            label.wordWrap = listOwner.wordWrap;
            if(listOwner.showDataTips)
            {
               if(label.textWidth > label.width || listOwner.dataTipFunction != null)
               {
                  toolTip = listOwner.itemToDataTip(_data);
               }
               else
               {
                  toolTip = null;
               }
            }
            else
            {
               toolTip = null;
            }
         }
         else
         {
            label.text = " ";
            toolTip = null;
         }
      }
      
      protected function toolTipShowHandler(param1:ToolTipEvent) : void
      {
         var _loc5_:Rectangle = null;
         var _loc8_:InterManagerRequest = null;
         var _loc2_:IToolTip = param1.toolTip;
         var _loc3_:ISystemManager = systemManager.topLevelSystemManager;
         var _loc4_:DisplayObject = _loc3_.getSandboxRoot();
         var _loc6_:Point = new Point(0,0);
         _loc6_ = label.localToGlobal(_loc6_);
         _loc6_ = _loc4_.globalToLocal(_loc6_);
         _loc2_.move(_loc6_.x,_loc6_.y + (height - _loc2_.height) / 2);
         if(_loc3_ != _loc4_)
         {
            _loc8_ = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
            _loc4_.dispatchEvent(_loc8_);
            _loc5_ = Rectangle(_loc8_.value);
         }
         else
         {
            _loc5_ = _loc3_.getVisibleApplicationRect();
         }
         var _loc7_:Number = _loc5_.x + _loc5_.width;
         _loc6_.x = _loc2_.x;
         _loc6_.y = _loc2_.y;
         _loc6_ = _loc4_.localToGlobal(_loc6_);
         if(_loc6_.x + _loc2_.width > _loc7_)
         {
            _loc2_.move(_loc2_.x - (_loc6_.x + _loc2_.width - _loc7_),_loc2_.y);
         }
      }
      
      public function set listData(param1:BaseListData) : void
      {
         _listData = ListData(param1);
         invalidateProperties();
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            if(!label)
            {
               return 0;
            }
            return label.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return label.y + label.baselinePosition;
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         super.measure();
         _loc1_ = 0;
         if(icon)
         {
            _loc1_ = icon.measuredWidth;
         }
         if(label.width < 4 || label.height < 4)
         {
            label.width = 4;
            label.height = 16;
         }
         if(isNaN(explicitWidth))
         {
            _loc1_ = _loc1_ + label.getExplicitOrMeasuredWidth();
            measuredWidth = _loc1_;
            measuredHeight = label.getExplicitOrMeasuredHeight();
         }
         else
         {
            measuredWidth = explicitWidth;
            label.setActualSize(Math.max(explicitWidth - _loc1_,4),label.height);
            measuredHeight = label.getExplicitOrMeasuredHeight();
            if(icon && icon.measuredHeight > measuredHeight)
            {
               measuredHeight = icon.measuredHeight;
            }
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
            addChild(DisplayObject(label));
         }
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = 0;
         if(icon)
         {
            icon.x = _loc3_;
            _loc3_ = icon.x + icon.measuredWidth;
            icon.setActualSize(icon.measuredWidth,icon.measuredHeight);
         }
         label.x = _loc3_;
         label.setActualSize(param1 - _loc3_,measuredHeight);
         var _loc4_:String = getStyle("verticalAlign");
         if(_loc4_ == "top")
         {
            label.y = 0;
            if(icon)
            {
               icon.y = 0;
            }
         }
         else if(_loc4_ == "bottom")
         {
            label.y = param2 - label.height + 2;
            if(icon)
            {
               icon.y = param2 - icon.height;
            }
         }
         else
         {
            label.y = (param2 - label.height) / 2;
            if(icon)
            {
               icon.y = (param2 - icon.height) / 2;
            }
         }
         if(data && parent)
         {
            if(!enabled)
            {
               _loc5_ = getStyle("disabledColor");
            }
            else if(listOwner.isItemHighlighted(listData.uid))
            {
               _loc5_ = getStyle("textRollOverColor");
            }
            else if(listOwner.isItemSelected(listData.uid))
            {
               _loc5_ = getStyle("textSelectedColor");
            }
            else
            {
               _loc5_ = getStyle("color");
            }
            label.setColor(_loc5_);
         }
      }
   }
}
