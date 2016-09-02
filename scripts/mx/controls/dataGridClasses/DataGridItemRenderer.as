package mx.controls.dataGridClasses
{
   import mx.core.UITextField;
   import mx.core.IDataRenderer;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.managers.ILayoutManagerClient;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.styles.IStyleClient;
   import mx.core.mx_internal;
   import mx.styles.CSSStyleDeclaration;
   import flash.utils.getQualifiedClassName;
   import mx.styles.StyleManager;
   import flash.utils.getQualifiedSuperclassName;
   import flash.utils.getDefinitionByName;
   import mx.core.UIComponentGlobals;
   import mx.events.ToolTipEvent;
   import flash.geom.Rectangle;
   import mx.events.InterManagerRequest;
   import mx.core.IToolTip;
   import mx.managers.ISystemManager;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.events.FlexEvent;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.DataGrid;
   import mx.core.IFlexDisplayObject;
   import mx.styles.StyleProtoChain;
   import mx.core.UIComponent;
   
   use namespace mx_internal;
   
   public class DataGridItemRenderer extends UITextField implements IDataRenderer, IDropInListItemRenderer, ILayoutManagerClient, IListItemRenderer, IStyleClient
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var invalidateSizeFlag:Boolean = false;
      
      private var _data:Object;
      
      private var _listData:mx.controls.dataGridClasses.DataGridListData;
      
      private var invalidatePropertiesFlag:Boolean = false;
      
      private var _styleDeclaration:CSSStyleDeclaration;
      
      public function DataGridItemRenderer()
      {
         super();
         tabEnabled = false;
         mouseWheelEnabled = false;
         ignorePadding = false;
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
         inheritingStyles = nonInheritingStyles = UIComponent.STYLE_UNINITIALIZED;
      }
      
      override public function initialize() : void
      {
         regenerateStyleCache(false);
      }
      
      public function validateDisplayList() : void
      {
         validateNow();
      }
      
      public function getClassStyleDeclarations() : Array
      {
         var s:CSSStyleDeclaration = null;
         var className:String = getQualifiedClassName(this);
         className = className.replace("::",".");
         var decls:Array = [];
         while(className != null && className != "mx.core.UIComponent" && className != "mx.core.UITextField")
         {
            s = StyleManager.getStyleDeclaration(className);
            if(s)
            {
               decls.unshift(s);
            }
            try
            {
               className = getQualifiedSuperclassName(getDefinitionByName(className));
               className = className.replace("::",".");
            }
            catch(e:ReferenceError)
            {
               className = null;
               continue;
            }
         }
         return decls;
      }
      
      public function notifyStyleChangeInChildren(param1:String, param2:Boolean) : void
      {
      }
      
      public function regenerateStyleCache(param1:Boolean) : void
      {
         initProtoChain();
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      public function get styleDeclaration() : CSSStyleDeclaration
      {
         return _styleDeclaration;
      }
      
      override public function set nestLevel(param1:int) : void
      {
         super.nestLevel = param1;
         UIComponentGlobals.layoutManager.invalidateProperties(this);
         invalidatePropertiesFlag = true;
         UIComponentGlobals.layoutManager.invalidateSize(this);
         invalidateSizeFlag = true;
      }
      
      public function validateSize(param1:Boolean = false) : void
      {
         invalidateSizeFlag = false;
         validateNow();
      }
      
      protected function toolTipShowHandler(param1:ToolTipEvent) : void
      {
         var _loc5_:Rectangle = null;
         var _loc8_:InterManagerRequest = null;
         var _loc2_:IToolTip = param1.toolTip;
         var _loc3_:ISystemManager = systemManager.topLevelSystemManager;
         var _loc4_:DisplayObject = _loc3_.getSandboxRoot();
         var _loc6_:Point = new Point(0,0);
         _loc6_ = localToGlobal(_loc6_);
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
      
      public function set styleDeclaration(param1:CSSStyleDeclaration) : void
      {
         _styleDeclaration = param1;
      }
      
      override public function validateNow() : void
      {
         var _loc1_:Number = NaN;
         if(data && parent)
         {
            if(DataGridBase(_listData.owner).isItemHighlighted(_listData.uid))
            {
               _loc1_ = getStyle("textRollOverColor");
            }
            else if(DataGridBase(_listData.owner).isItemSelected(_listData.uid))
            {
               _loc1_ = getStyle("textSelectedColor");
            }
            else
            {
               _loc1_ = getStyle("color");
            }
            if(_loc1_ != explicitColor)
            {
               styleChangedFlag = true;
               explicitColor = _loc1_;
               invalidateDisplayList();
            }
         }
         super.validateNow();
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function clearStyle(param1:String) : void
      {
         setStyle(param1,undefined);
      }
      
      public function registerEffects(param1:Array) : void
      {
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      public function validateProperties() : void
      {
         var _loc1_:DataGrid = null;
         var _loc2_:DataGridColumn = null;
         var _loc3_:Boolean = false;
         invalidatePropertiesFlag = false;
         if(_listData)
         {
            _loc1_ = DataGrid(_listData.owner);
            _loc2_ = _loc1_.columns[_listData.columnIndex];
            text = _listData.label;
            if(_data is DataGridColumn)
            {
               wordWrap = _loc1_.columnHeaderWordWrap(_loc2_);
            }
            else
            {
               wordWrap = _loc1_.columnWordWrap(_loc2_);
            }
            if(DataGrid(_listData.owner).variableRowHeight)
            {
               multiline = true;
            }
            _loc3_ = _loc1_.showDataTips;
            if(_loc2_.showDataTips == true)
            {
               _loc3_ = true;
            }
            if(_loc2_.showDataTips == false)
            {
               _loc3_ = false;
            }
            if(_loc3_)
            {
               if(!(_data is DataGridColumn) && (textWidth > width || _loc2_.dataTipFunction || _loc2_.dataTipField || _loc1_.dataTipFunction || _loc1_.dataTipField))
               {
                  toolTip = _loc2_.itemToDataTip(_data);
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
            text = " ";
            toolTip = null;
         }
      }
      
      public function set listData(param1:BaseListData) : void
      {
         _listData = DataGridListData(param1);
         if(nestLevel && !invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.invalidateProperties(this);
            invalidatePropertiesFlag = true;
            UIComponentGlobals.layoutManager.invalidateSize(this);
            invalidateSizeFlag = true;
         }
      }
      
      public function initProtoChain() : void
      {
         var _loc1_:CSSStyleDeclaration = null;
         var _loc7_:Object = null;
         var _loc8_:CSSStyleDeclaration = null;
         styleChangedFlag = true;
         if(styleName)
         {
            if(styleName is CSSStyleDeclaration)
            {
               _loc1_ = CSSStyleDeclaration(styleName);
            }
            else
            {
               if(styleName is IFlexDisplayObject)
               {
                  StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                  return;
               }
               if(styleName is String)
               {
                  _loc1_ = StyleManager.getStyleDeclaration("." + styleName);
               }
            }
         }
         var _loc2_:Object = StyleManager.stylesRoot;
         var _loc3_:IStyleClient = parent as IStyleClient;
         if(_loc3_)
         {
            _loc7_ = _loc3_.inheritingStyles;
            if(_loc7_ == UIComponent.STYLE_UNINITIALIZED)
            {
               _loc7_ = _loc2_;
            }
         }
         else
         {
            _loc7_ = StyleManager.stylesRoot;
         }
         var _loc4_:Array = getClassStyleDeclarations();
         var _loc5_:int = _loc4_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = _loc4_[_loc6_];
            _loc7_ = _loc8_.addStyleToProtoChain(_loc7_,this);
            _loc2_ = _loc8_.addStyleToProtoChain(_loc2_,this);
            _loc6_++;
         }
         if(_loc1_)
         {
            _loc7_ = _loc1_.addStyleToProtoChain(_loc7_,this);
            _loc2_ = _loc1_.addStyleToProtoChain(_loc2_,this);
         }
         inheritingStyles = !!styleDeclaration?styleDeclaration.addStyleToProtoChain(_loc7_,this):_loc7_;
         nonInheritingStyles = !!styleDeclaration?styleDeclaration.addStyleToProtoChain(_loc2_,this):_loc2_;
      }
      
      override public function getStyle(param1:String) : *
      {
         return !!StyleManager.inheritingStyles[param1]?inheritingStyles[param1]:nonInheritingStyles[param1];
      }
      
      override public function setStyle(param1:String, param2:*) : void
      {
         if(param1 == "styleName")
         {
            styleName = param2;
            return;
         }
         var _loc3_:Boolean = StyleManager.isInheritingStyle(param1);
         var _loc4_:* = inheritingStyles != UIComponent.STYLE_UNINITIALIZED;
         if(_loc3_)
         {
            if(getStyle(param1) == param2 && _loc4_)
            {
               return;
            }
            if(!styleDeclaration)
            {
               styleDeclaration = new CSSStyleDeclaration();
               styleDeclaration.setStyle(param1,param2);
               if(_loc4_)
               {
                  regenerateStyleCache(true);
               }
            }
            else
            {
               styleDeclaration.setStyle(param1,param2);
            }
         }
         else
         {
            if(getStyle(param1) == param2 && _loc4_)
            {
               return;
            }
            if(!styleDeclaration)
            {
               styleDeclaration = new CSSStyleDeclaration();
               styleDeclaration.setStyle(param1,param2);
               if(_loc4_)
               {
                  regenerateStyleCache(false);
               }
            }
            else
            {
               styleDeclaration.setStyle(param1,param2);
            }
         }
         if(_loc4_)
         {
            styleChanged(param1);
            notifyStyleChangeInChildren(param1,_loc3_);
         }
      }
   }
}
