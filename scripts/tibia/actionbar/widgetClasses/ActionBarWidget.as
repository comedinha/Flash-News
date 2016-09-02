package tibia.actionbar.widgetClasses
{
   import mx.core.Container;
   import tibia.actionbar.ActionBar;
   import mx.events.PropertyChangeEvent;
   import tibia.input.IAction;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import tibia.input.MouseRepeatEvent;
   import tibia.actionbar.ActionBarSet;
   import mx.core.IUIComponent;
   import flash.geom.Point;
   import shared.controls.CustomButton;
   import mx.events.DragEvent;
   import tibia.input.MappingSet;
   import tibia.input.mapping.Mapping;
   import tibia.input.mapping.Binding;
   import mx.core.DragSource;
   import mx.managers.DragManager;
   import tibia.options.OptionsStorage;
   import tibia.help.UIEffectsRetrieveComponentCommandEvent;
   import tibia.appearances.AppearanceType;
   import tibia.input.gameaction.UseAction;
   import tibia.input.gameaction.EquipAction;
   import mx.core.UIComponent;
   import mx.events.ToolTipEvent;
   import tibia.container.ContainerStorage;
   import mx.events.FlexEvent;
   import tibia.network.IServerConnection;
   import tibia.network.ConnectionEvent;
   import mx.core.EventPriority;
   import flash.display.DisplayObject;
   import mx.controls.Image;
   import flash.display.Bitmap;
   import mx.graphics.ImageSnapshot;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.AppearanceStorage;
   import tibia.network.Communication;
   import tibia.appearances.AppearanceTypeRef;
   import mx.core.EdgeMetrics;
   import mx.controls.Button;
   import mx.events.SandboxMouseEvent;
   import tibia.magic.Spell;
   import tibia.input.gameaction.SpellAction;
   import mx.core.mx_internal;
   import mx.core.IBorder;
   import mx.core.ScrollPolicy;
   import mx.states.State;
   
   public class ActionBarWidget extends Container
   {
      
      public static const BUNDLE:String = "ActionBarWidget";
      
      protected static const DRAG_TYPE_CHANNEL:String = "channel";
      
      public static const DIRECTION_HORIZONTAL:int = 0;
      
      protected static const DRAG_TYPE_STATUSWIDGET:String = "statusWidget";
      
      public static const DIRECTION_VERTICAL:int = 1;
      
      protected static const DRAG_TYPE_ACTION:String = "action";
      
      public static const STATE_OPEN:String = "open";
      
      protected static const DRAG_TYPE_OBJECT:String = "object";
      
      protected static const DRAG_OPACITY:Number = 0.75;
      
      public static const STATE_COLLAPSED:String = "collapsed";
      
      protected static const DRAG_TYPE_SPELL:String = "spell";
      
      protected static const DRAG_TYPE_WIDGETBASE:String = "widgetBase";
      
      private static const TOGGLE_BUTTON_FILTER_MAP:Object = {
         "toggleBackgroundImage":"borderBackgroundImage",
         "toggleDisabledImage":"borderDefaultDisabledImage",
         "toggleOutImage":"borderDefaultOutImage",
         "toggleOverImage":"borderDefaultOverImage",
         "toggleStyle":"borderStyle",
         "toggleSkin":"skin"
      };
       
      
      private var m_UncommittedScrollPosition:Boolean = false;
      
      private var m_UncommittedMaxScrollPosition:Boolean = false;
      
      protected var m_ActionBar:ActionBar = null;
      
      protected var m_Direction:int = 0;
      
      protected var m_MaxChildHeight:Number = 0;
      
      protected var m_MaxChildWidth:Number = 0;
      
      protected var m_MaxScrollPosition:int = 29.0;
      
      protected var m_Options:OptionsStorage = null;
      
      protected var m_ScrollPosition:int = 0;
      
      private var m_UncommittedCurrentState:Boolean = false;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_UIScrollUpButton:Button = null;
      
      private var m_UncommittedLocation:Boolean = false;
      
      protected var m_Location:int = 0;
      
      private var m_UncommittedContainerStorage:Boolean = false;
      
      protected var m_UIToggleButton:Button = null;
      
      private var m_UncommittedDirection:Boolean = false;
      
      protected var m_ContainerStorage:ContainerStorage = null;
      
      protected var m_UIScrollDownButton:Button = null;
      
      private var m_UncommittedActionBar:Boolean = false;
      
      public function ActionBarWidget(param1:int = 0)
      {
         super();
         this.m_Direction = param1;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         var _loc2_:State = new State();
         _loc2_.name = STATE_COLLAPSED;
         states.push(_loc2_);
         _loc2_ = new State();
         _loc2_.name = STATE_OPEN;
         states.push(_loc2_);
         this.currentState = STATE_COLLAPSED;
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      [Bindable(event="propertyChange")]
      public function set actionBar(param1:ActionBar) : void
      {
         var _loc2_:Object = this.actionBar;
         if(_loc2_ !== param1)
         {
            this._198267389actionBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"actionBar",_loc2_,param1));
         }
      }
      
      private function updateActions() : void
      {
         var _loc3_:IActionButton = null;
         var _loc1_:int = Math.min(ActionBar.NUM_ACTIONS,numChildren);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = getChildAt(_loc2_) as IActionButton;
            if(_loc3_ != null)
            {
               _loc3_.action = this.m_ActionBar != null?this.m_ActionBar.getAction(_loc2_):null;
            }
            _loc2_++;
         }
      }
      
      private function onButtonActionDragStop(param1:Event) : void
      {
         var _loc2_:IActionButton = null;
         if((_loc2_ = param1.currentTarget as IActionButton) != null)
         {
            this.updateButtonDragListeners(_loc2_,false);
         }
      }
      
      private function onButtonMouseDown(param1:MouseEvent) : void
      {
         if(param1 is MouseRepeatEvent)
         {
            MouseRepeatEvent(param1).repeatEnabled = true;
            MouseRepeatEvent(param1).repeatInterval = 200;
         }
         var _loc2_:IActionButton = param1.currentTarget as IActionButton;
         if((this.options == null || !this.options.generalActionBarsLock) && _loc2_ != null)
         {
            this.updateButtonDragListeners(_loc2_,_loc2_.action != null);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         layoutChrome(param1,param2);
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this.m_UIScrollUpButton != null)
         {
            this.m_UIScrollUpButton.visible = false;
         }
         if(this.m_UIScrollDownButton != null)
         {
            this.m_UIScrollDownButton.visible = false;
         }
         _loc7_ = 0;
         _loc8_ = numChildren;
         while(_loc7_ < _loc8_)
         {
            getChildAt(_loc7_).visible = false;
            _loc7_++;
         }
         _loc5_ = this.m_UIToggleButton.getExplicitOrMeasuredHeight();
         _loc6_ = this.m_UIToggleButton.getExplicitOrMeasuredWidth();
         if(this.m_Direction == DIRECTION_HORIZONTAL)
         {
            _loc3_ = (param1 - _loc6_) / 2;
            if(this.m_Location == ActionBarSet.LOCATION_BOTTOM)
            {
               _loc4_ = param2 - _loc5_;
            }
            else
            {
               _loc4_ = 0;
            }
         }
         else
         {
            _loc4_ = (param2 - _loc5_) / 2;
            if(this.m_Location == ActionBarSet.LOCATION_RIGHT)
            {
               _loc3_ = param1 - _loc6_;
            }
            else
            {
               _loc3_ = 0;
            }
         }
         this.m_UIToggleButton.visible = this.options != null && !this.options.generalActionBarsLock;
         this.m_UIToggleButton.move(_loc3_,_loc4_);
         this.m_UIToggleButton.setActualSize(_loc6_,_loc5_);
         rawChildren.setChildIndex(this.m_UIToggleButton,rawChildren.numChildren - 1);
         if(currentState != STATE_OPEN)
         {
            return;
         }
         var _loc9_:Number = this.m_Direction == DIRECTION_HORIZONTAL?Number(getStyle("horizontalGap")):Number(getStyle("verticalGap"));
         var _loc10_:Number = 0;
         var _loc11_:Number = _loc9_;
         var _loc12_:Number = -_loc9_;
         if(this.m_Direction == DIRECTION_HORIZONTAL)
         {
            _loc11_ = _loc11_ + (param1 - viewMetricsAndPadding.left - viewMetricsAndPadding.right);
         }
         else
         {
            _loc11_ = _loc11_ + (param2 - viewMetricsAndPadding.top - viewMetricsAndPadding.bottom);
         }
         _loc10_ = this.m_Direction == DIRECTION_HORIZONTAL?Number(this.m_UIScrollUpButton.getExplicitOrMeasuredWidth()):Number(this.m_UIScrollUpButton.getExplicitOrMeasuredHeight());
         _loc11_ = _loc11_ - (_loc10_ + _loc9_);
         _loc12_ = _loc12_ + (_loc10_ + _loc9_);
         _loc10_ = this.m_Direction == DIRECTION_HORIZONTAL?Number(this.m_UIScrollDownButton.getExplicitOrMeasuredWidth()):Number(this.m_UIScrollDownButton.getExplicitOrMeasuredHeight());
         _loc11_ = _loc11_ - (_loc10_ + _loc9_);
         _loc12_ = _loc12_ + (_loc10_ + _loc9_);
         var _loc13_:IUIComponent = null;
         var _loc14_:Vector.<Point> = new Vector.<Point>();
         var _loc15_:int = 0;
         _loc7_ = 0;
         _loc8_ = numChildren;
         while(_loc7_ < _loc8_)
         {
            if((_loc13_ = getChildAt(_loc7_) as IUIComponent) != null)
            {
               _loc5_ = _loc13_.getExplicitOrMeasuredHeight();
               _loc6_ = _loc13_.getExplicitOrMeasuredWidth();
               _loc14_.push(new Point(_loc6_,_loc5_));
               _loc10_ = this.m_Direction == DIRECTION_HORIZONTAL?Number(_loc6_):Number(_loc5_);
               if(_loc7_ >= this.m_ScrollPosition && _loc11_ >= _loc10_)
               {
                  _loc15_++;
                  _loc11_ = _loc11_ - (_loc10_ + _loc9_);
                  _loc12_ = _loc12_ + (_loc10_ + _loc9_);
               }
            }
            _loc7_++;
         }
         while(_loc11_ > 0 && this.m_ScrollPosition > 0)
         {
            _loc10_ = this.m_Direction == DIRECTION_HORIZONTAL?Number(_loc14_[this.m_ScrollPosition - 1].x):Number(_loc14_[this.m_ScrollPosition - 1].y);
            if(_loc11_ < _loc10_)
            {
               break;
            }
            this.m_ScrollPosition--;
            _loc15_++;
            _loc11_ = _loc11_ - (_loc10_ + _loc9_);
            _loc12_ = _loc12_ + (_loc10_ + _loc9_);
         }
         this.maxScrollPosition = ActionBar.NUM_ACTIONS - _loc15_;
         var _loc16_:Number = Math.floor(_loc11_ / 2);
         _loc6_ = this.m_UIScrollDownButton.getExplicitOrMeasuredWidth();
         _loc5_ = this.m_UIScrollDownButton.getExplicitOrMeasuredHeight();
         if(this.m_Direction == DIRECTION_HORIZONTAL)
         {
            _loc4_ = viewMetricsAndPadding.top + (this.m_MaxChildHeight - _loc5_) / 2;
            _loc3_ = viewMetricsAndPadding.left + _loc16_;
            _loc16_ = _loc16_ + (getStyle("paddingLeft") + _loc6_ + _loc9_);
         }
         else
         {
            _loc4_ = viewMetricsAndPadding.top + _loc16_;
            _loc3_ = viewMetricsAndPadding.left + (this.m_MaxChildWidth - _loc6_) / 2;
            _loc16_ = _loc16_ + (getStyle("paddingTop") + _loc5_ + _loc9_);
         }
         this.m_UIScrollDownButton.enabled = this.m_ScrollPosition > 0;
         this.m_UIScrollDownButton.visible = true;
         this.m_UIScrollDownButton.move(_loc3_,_loc4_);
         this.m_UIScrollDownButton.setActualSize(_loc6_,_loc5_);
         rawChildren.setChildIndex(this.m_UIScrollDownButton,rawChildren.numChildren - 2);
         _loc4_ = getStyle("paddingTop");
         _loc3_ = getStyle("paddingLeft");
         _loc7_ = 0;
         while(_loc7_ < _loc15_)
         {
            if((_loc13_ = getChildAt(this.m_ScrollPosition + _loc7_) as IUIComponent) != null)
            {
               _loc5_ = _loc14_[this.m_ScrollPosition + _loc7_].y;
               _loc6_ = _loc14_[this.m_ScrollPosition + _loc7_].x;
               if(this.m_Direction == DIRECTION_HORIZONTAL)
               {
                  _loc3_ = _loc16_;
                  _loc16_ = _loc16_ + (_loc6_ + _loc9_);
               }
               else
               {
                  _loc4_ = _loc16_;
                  _loc16_ = _loc16_ + (_loc5_ + _loc9_);
               }
               _loc13_.move(_loc3_,_loc4_);
               _loc13_.setActualSize(_loc6_,_loc5_);
               _loc13_.visible = true;
            }
            _loc7_++;
         }
         _loc5_ = this.m_UIScrollUpButton.getExplicitOrMeasuredHeight();
         _loc6_ = this.m_UIScrollUpButton.getExplicitOrMeasuredWidth();
         if(this.m_Direction == DIRECTION_HORIZONTAL)
         {
            _loc4_ = viewMetricsAndPadding.top + (this.m_MaxChildHeight - _loc5_) / 2;
            _loc3_ = this.m_UIScrollDownButton.x + _loc12_ - _loc6_;
         }
         else
         {
            _loc4_ = this.m_UIScrollDownButton.y + _loc12_ - _loc5_;
            _loc3_ = viewMetricsAndPadding.left + (this.m_MaxChildWidth - _loc6_) / 2;
         }
         this.m_UIScrollUpButton.enabled = this.m_ScrollPosition + _loc15_ < ActionBar.NUM_ACTIONS;
         this.m_UIScrollUpButton.visible = true;
         this.m_UIScrollUpButton.move(_loc3_,_loc4_);
         this.m_UIScrollUpButton.setActualSize(_loc6_,_loc5_);
         rawChildren.setChildIndex(this.m_UIScrollUpButton,rawChildren.numChildren - 3);
      }
      
      private function updateToggleButton() : void
      {
         if(this.m_UIToggleButton != null)
         {
            this.m_UIToggleButton.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
            rawChildren.removeChild(this.m_UIToggleButton);
         }
         this.m_UIToggleButton = new CustomButton();
         this.m_UIToggleButton.styleName = getStyle("toggleButtonStyle");
         this.m_UIToggleButton.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         rawChildren.addChild(this.m_UIToggleButton);
      }
      
      private function onButtonActionDragEvent(param1:DragEvent) : void
      {
         var _loc6_:IAction = null;
         var _loc7_:MappingSet = null;
         var _loc8_:Mapping = null;
         var _loc9_:IAction = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:IAction = null;
         var _loc14_:Array = null;
         var _loc15_:Binding = null;
         var _loc2_:IActionButton = null;
         var _loc3_:DragSource = null;
         var _loc4_:ActionBar = null;
         var _loc5_:int = -1;
         if((this.options == null || !this.options.generalActionBarsLock) && (_loc2_ = param1.currentTarget as IActionButton) != null && (_loc3_ = param1.dragSource) != null && _loc3_.hasFormat("dragType") && _loc3_.dataForFormat("dragType") == DRAG_TYPE_ACTION && _loc3_.hasFormat("dragActionBar") && (_loc4_ = _loc3_.dataForFormat("dragActionBar") as ActionBar) != null && _loc3_.hasFormat("dragActionPosition") && 0 <= (_loc5_ = int(_loc3_.dataForFormat("dragActionPosition"))) && _loc5_ <= ActionBar.NUM_ACTIONS && this.m_ActionBar != null)
         {
            if(param1.type == DragEvent.DRAG_DROP)
            {
               _loc6_ = _loc4_.getAction(_loc5_);
               _loc4_.setAction(_loc5_,this.m_ActionBar.getAction(_loc2_.position));
               this.m_ActionBar.setAction(_loc2_.position,_loc6_);
               _loc7_ = null;
               _loc8_ = null;
               if(param1.shiftKey && this.options != null && (_loc7_ = this.options.getMappingSet(this.options.generalInputSetID)) != null && (_loc8_ = this.options.generalInputSetMode == MappingSet.CHAT_MODE_OFF?_loc7_.chatModeOff:_loc7_.chatModeOn) != null)
               {
                  _loc9_ = _loc4_.getTrigger(_loc5_);
                  _loc10_ = _loc8_.getBindingsByAction(_loc9_);
                  _loc11_ = 0;
                  _loc12_ = 0;
                  _loc11_ = _loc10_.length;
                  _loc12_ = 0;
                  while(_loc12_ < _loc11_)
                  {
                     _loc8_.removeItem(_loc10_[_loc12_]);
                     _loc12_++;
                  }
                  _loc13_ = this.m_ActionBar.getTrigger(_loc2_.position);
                  _loc14_ = _loc8_.getBindingsByAction(_loc13_);
                  _loc11_ = _loc14_.length;
                  _loc12_ = 0;
                  while(_loc12_ < _loc11_)
                  {
                     _loc8_.removeItem(_loc14_[_loc12_]);
                     _loc12_++;
                  }
                  while(_loc10_.length < _loc14_.length)
                  {
                     _loc10_.push(new Binding(_loc9_,0,0,0,null,true));
                  }
                  while(_loc14_.length < _loc10_.length)
                  {
                     _loc14_.push(new Binding(_loc13_,0,0,0,null,true));
                  }
                  _loc11_ = _loc10_.length;
                  _loc12_ = 0;
                  while(_loc12_ < _loc11_)
                  {
                     if(!(!_loc10_[_loc12_].editable || !_loc14_[_loc12_].editable))
                     {
                        _loc15_ = _loc10_[_loc12_].clone();
                        _loc10_[_loc12_].update(_loc14_[_loc12_]);
                        _loc14_[_loc12_].update(_loc15_);
                        if(_loc10_[_loc12_].keyCode != 0)
                        {
                           _loc8_.addItem(_loc10_[_loc12_]);
                        }
                        if(_loc14_[_loc12_].keyCode != 0)
                        {
                           _loc8_.addItem(_loc14_[_loc12_]);
                        }
                     }
                     _loc12_++;
                  }
               }
            }
            else if(param1.type == DragEvent.DRAG_ENTER)
            {
               DragManager.acceptDragDrop(_loc2_);
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.updateActionButtons();
         this.updateScrollButtons();
         this.updateToggleButton();
      }
      
      private function set _198267389actionBar(param1:ActionBar) : void
      {
         if(this.m_ActionBar != param1)
         {
            if(this.m_ActionBar != null)
            {
               this.m_ActionBar.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onActionBarChange);
            }
            this.m_ActionBar = param1;
            if(this.m_ActionBar != null)
            {
               this.m_ActionBar.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onActionBarChange);
            }
            this.m_UncommittedActionBar = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      private function onUIEffectsCommandEvent(param1:UIEffectsRetrieveComponentCommandEvent) : void
      {
         var _loc2_:AppearanceType = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:IActionButton = null;
         var _loc6_:IAction = null;
         var _loc7_:int = 0;
         if(param1.type == UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT && param1.identifier == ActionBarWidget)
         {
            _loc2_ = param1.subIdentifier as AppearanceType;
            if(_loc2_ != null)
            {
               _loc3_ = Math.min(ActionBar.NUM_ACTIONS,numChildren);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = getChildAt(_loc4_) as IActionButton;
                  if(_loc5_ != null)
                  {
                     _loc6_ = _loc5_.action;
                     if(_loc6_ != null)
                     {
                        _loc7_ = -1;
                        if(_loc6_ is UseAction)
                        {
                           _loc7_ = UseAction(_loc6_).type.ID;
                        }
                        else if(_loc6_ is EquipAction)
                        {
                           _loc7_ = EquipAction(_loc6_).type.ID;
                        }
                        if(_loc7_ == _loc2_.ID)
                        {
                           param1.resultUIComponent = _loc5_ as UIComponent;
                        }
                     }
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      public function get scrollPosition() : int
      {
         return this.m_ScrollPosition;
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var a_Event:MouseEvent = param1;
         var Btn:IActionButton = null;
         if((Btn = a_Event.currentTarget as IActionButton) != null && this.m_ActionBar != null)
         {
            switch(a_Event.type)
            {
               case MouseEvent.RIGHT_CLICK:
                  new ActionButtonContextMenu(this.m_ActionBar,Btn.position).display(this,a_Event.stageX,a_Event.stageY);
                  break;
               case MouseRepeatEvent.REPEAT_MOUSE_DOWN:
                  this.updateButtonDragListeners(Btn,false);
               case MouseEvent.CLICK:
                  if(Btn.action != null)
                  {
                     try
                     {
                        Btn.action.perform(a_Event.type == MouseRepeatEvent.REPEAT_MOUSE_DOWN);
                     }
                     catch(e:*)
                     {
                     }
                  }
            }
         }
      }
      
      public function get maxScrollPosition() : int
      {
         return this.m_MaxScrollPosition;
      }
      
      private function updateScrollButtons() : void
      {
         if(this.m_UIScrollUpButton != null)
         {
            this.m_UIScrollUpButton.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
            this.m_UIScrollUpButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.m_UIScrollUpButton.removeEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onMouseClick);
            rawChildren.removeChild(this.m_UIScrollUpButton);
         }
         this.m_UIScrollUpButton = new CustomButton();
         this.m_UIScrollUpButton.styleName = getStyle("scrollUpButtonStyle");
         this.m_UIScrollUpButton.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.m_UIScrollUpButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.m_UIScrollUpButton.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onMouseClick);
         rawChildren.addChild(this.m_UIScrollUpButton);
         if(this.m_UIScrollDownButton != null)
         {
            this.m_UIScrollDownButton.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
            this.m_UIScrollDownButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.m_UIScrollDownButton.removeEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onMouseClick);
            rawChildren.removeChild(this.m_UIScrollDownButton);
         }
         this.m_UIScrollDownButton = new CustomButton();
         this.m_UIScrollDownButton.styleName = getStyle("scrollDownButtonStyle");
         this.m_UIScrollDownButton.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.m_UIScrollDownButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.m_UIScrollDownButton.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onMouseClick);
         rawChildren.addChild(this.m_UIScrollDownButton);
      }
      
      private function onActionBarChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "visible")
         {
            this.currentState = !!this.m_ActionBar.visible?STATE_OPEN:STATE_COLLAPSED;
         }
         else if(param1.property == "action")
         {
            this.updateActions();
            this.updateToolTips();
         }
      }
      
      override public function set currentState(param1:String) : void
      {
         if(param1 != STATE_COLLAPSED && param1 != STATE_OPEN)
         {
            param1 = STATE_OPEN;
         }
         if(currentState != param1)
         {
            super.currentState = param1;
            this.m_UncommittedCurrentState = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget == this.m_UIScrollDownButton)
         {
            this.scrollPosition = this.scrollPosition - (!!param1.shiftKey?10:1);
         }
         else if(param1.currentTarget == this.m_UIScrollUpButton)
         {
            this.scrollPosition = this.scrollPosition + (!!param1.shiftKey?10:1);
         }
         else if(param1.currentTarget == this.m_UIToggleButton)
         {
            if(this.m_ActionBar != null)
            {
               this.m_ActionBar.visible = !this.m_ActionBar.visible;
            }
         }
      }
      
      private function onButtonToolTip(param1:ToolTipEvent) : void
      {
         var _loc3_:ActionButtonToolTip = null;
         var _loc2_:IActionButton = null;
         if((_loc2_ = param1.currentTarget as IActionButton) != null)
         {
            _loc3_ = new ActionButtonToolTip();
            _loc3_.actionBar = this.actionBar;
            _loc3_.actionButton = _loc2_;
            param1.toolTip = _loc3_;
         }
      }
      
      public function set maxScrollPosition(param1:int) : void
      {
         param1 = Math.max(0,Math.min(param1,ActionBar.NUM_ACTIONS - 1));
         if(this.m_MaxScrollPosition != param1)
         {
            this.m_MaxScrollPosition = param1;
            this.m_UncommittedMaxScrollPosition = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function get location() : int
      {
         return this.m_Location;
      }
      
      private function onContainerChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:IActionButton = null;
         var _loc5_:IAction = null;
         if(param1.property == "playerInventory")
         {
            _loc2_ = Math.min(ActionBar.NUM_ACTIONS,numChildren);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = getChildAt(_loc3_) as IActionButton;
               _loc5_ = _loc4_ != null?_loc4_.action:null;
               if(_loc5_ is UseAction || _loc5_ is EquipAction)
               {
                  _loc4_.invalidateDisplayList();
               }
               _loc3_++;
            }
         }
      }
      
      public function get containerStorage() : ContainerStorage
      {
         return this.m_ContainerStorage;
      }
      
      public function set scrollPosition(param1:int) : void
      {
         param1 = Math.max(0,Math.min(param1,this.m_MaxScrollPosition,ActionBar.NUM_ACTIONS - 1));
         if(this.m_ScrollPosition != param1)
         {
            this.m_ScrollPosition = param1;
            this.m_UncommittedScrollPosition = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_UncommittedOptions = true;
            invalidateDisplayList();
            invalidateProperties();
            this.updateActionBar();
         }
      }
      
      private function onCreationComplete(param1:FlexEvent) : void
      {
         var _loc2_:IServerConnection = Tibia.s_GetConnection();
         if(_loc2_ != null)
         {
            _loc2_.addEventListener(ConnectionEvent.GAME,this.onConnectionEstablished,false,EventPriority.DEFAULT,true);
         }
         Tibia.s_GetUIEffectsManager().addEventListener(UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT,this.onUIEffectsCommandEvent);
      }
      
      private function onConnectionEstablished(param1:ConnectionEvent) : void
      {
         this.updateToolTips();
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "actionButton":
               this.updateActionButtons();
               break;
            case "toggleButton":
               this.updateToggleButton();
               break;
            case "scrollDownButton":
            case "scrollUpButton":
               this.updateScrollButtons();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      private function updateActionButtons() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:ActionButton = null;
         var _loc1_:int = 0;
         _loc1_ = numChildren - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = removeChildAt(_loc1_);
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onButtonMouseDown);
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc2_.removeEventListener(MouseEvent.RIGHT_CLICK,this.onButtonClick);
            _loc2_.removeEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
            _loc2_.removeEventListener(DragEvent.DRAG_DROP,this.onButtonActionDragEvent);
            _loc2_.removeEventListener(DragEvent.DRAG_ENTER,this.onButtonActionDragEvent);
            _loc2_.removeEventListener(DragEvent.DRAG_COMPLETE,this.onButtonActionDragStop);
            _loc2_.removeEventListener(DragEvent.DRAG_DROP,this.onButtonObjectDragEvent);
            _loc2_.removeEventListener(DragEvent.DRAG_ENTER,this.onButtonObjectDragEvent);
            _loc2_.removeEventListener(DragEvent.DRAG_DROP,this.onButtonSpellDragEvent);
            _loc2_.removeEventListener(DragEvent.DRAG_ENTER,this.onButtonSpellDragEvent);
            _loc2_.removeEventListener(ToolTipEvent.TOOL_TIP_CREATE,this.onButtonToolTip);
            _loc1_--;
         }
         _loc1_ = 0;
         while(_loc1_ < ActionBar.NUM_ACTIONS)
         {
            _loc3_ = new ActionButton();
            _loc3_.owner = this;
            _loc3_.position = _loc1_;
            _loc3_.styleName = "actionBarWidget";
            _loc3_.toolTip = " ";
            _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonMouseDown);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc3_.addEventListener(MouseEvent.RIGHT_CLICK,this.onButtonClick);
            _loc3_.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
            _loc3_.addEventListener(DragEvent.DRAG_DROP,this.onButtonActionDragEvent);
            _loc3_.addEventListener(DragEvent.DRAG_ENTER,this.onButtonActionDragEvent);
            _loc3_.addEventListener(DragEvent.DRAG_COMPLETE,this.onButtonActionDragStop);
            _loc3_.addEventListener(DragEvent.DRAG_DROP,this.onButtonObjectDragEvent);
            _loc3_.addEventListener(DragEvent.DRAG_ENTER,this.onButtonObjectDragEvent);
            _loc3_.addEventListener(DragEvent.DRAG_DROP,this.onButtonSpellDragEvent);
            _loc3_.addEventListener(DragEvent.DRAG_ENTER,this.onButtonSpellDragEvent);
            _loc3_.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,this.onButtonToolTip);
            addChild(_loc3_ as DisplayObject);
            _loc1_++;
         }
         this.updateActions();
      }
      
      private function onButtonActionDragStart(param1:MouseEvent) : void
      {
         var _loc3_:DragSource = null;
         var _loc4_:Image = null;
         var _loc2_:IActionButton = null;
         if((this.options == null || !this.options.generalActionBarsLock) && (_loc2_ = param1.currentTarget as IActionButton) != null)
         {
            _loc3_ = new DragSource();
            _loc3_.addData(DRAG_TYPE_ACTION,"dragType");
            _loc3_.addData(this.m_ActionBar,"dragActionBar");
            _loc3_.addData(_loc2_.position,"dragActionPosition");
            _loc4_ = new Image();
            _loc4_.source = new Bitmap(ImageSnapshot.captureBitmapData(_loc2_));
            DragManager.doDrag(_loc2_,_loc3_,param1,_loc4_,-param1.localX,-param1.localY,DRAG_OPACITY);
            this.updateButtonDragListeners(_loc2_,false);
         }
      }
      
      private function onButtonObjectDragEvent(param1:DragEvent) : void
      {
         var _loc6_:IAction = null;
         var _loc7_:int = 0;
         var _loc2_:IActionButton = null;
         var _loc3_:DragSource = null;
         var _loc4_:ObjectInstance = null;
         var _loc5_:AppearanceType = null;
         if((this.options == null || !this.options.generalActionBarsLock) && (_loc2_ = param1.currentTarget as IActionButton) != null && (_loc3_ = param1.dragSource) != null && _loc3_.hasFormat("dragType") && _loc3_.dataForFormat("dragType") == DRAG_TYPE_OBJECT && _loc3_.hasFormat("dragObject") && (_loc4_ = _loc3_.dataForFormat("dragObject") as ObjectInstance) != null && (_loc5_ = _loc4_.type) != null && _loc5_.isTakeable && this.m_ActionBar != null)
         {
            if(param1.type == DragEvent.DRAG_DROP)
            {
               _loc6_ = null;
               _loc7_ = _loc5_.isLiquidContainer || _loc5_.isLiquidPool?int(_loc4_.data):0;
               if(_loc5_.isCloth)
               {
                  _loc6_ = new EquipAction(_loc4_,_loc7_,EquipAction.TARGET_AUTO);
               }
               else
               {
                  _loc6_ = new UseAction(_loc4_,_loc7_,!!_loc5_.isMultiUse?int(UseAction.TARGET_CROSSHAIR):int(UseAction.TARGET_SELF));
               }
               this.m_ActionBar.setAction(_loc2_.position,_loc6_);
            }
            else if(param1.type == DragEvent.DRAG_ENTER)
            {
               DragManager.acceptDragDrop(_loc2_);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedDirection)
         {
            this.m_UncommittedDirection = false;
         }
         if(this.m_UncommittedActionBar)
         {
            this.updateActions();
            this.updateToolTips();
            if(this.m_ActionBar != null)
            {
               this.currentState = !!this.m_ActionBar.visible?STATE_OPEN:STATE_COLLAPSED;
            }
            else
            {
               this.currentState = STATE_COLLAPSED;
            }
            this.m_UncommittedActionBar = false;
         }
         if(this.m_UncommittedOptions)
         {
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedContainerStorage)
         {
            this.m_UncommittedContainerStorage = false;
         }
         if(this.m_UncommittedMaxScrollPosition)
         {
            this.scrollPosition = Math.max(0,Math.min(this.m_ScrollPosition,this.m_MaxScrollPosition));
            this.m_UncommittedMaxScrollPosition = false;
         }
         if(this.m_UncommittedScrollPosition)
         {
            this.m_UncommittedScrollPosition = false;
         }
         if(this.m_UncommittedLocation)
         {
            this.m_UncommittedLocation = false;
         }
         if(this.m_UncommittedCurrentState)
         {
            this.scrollPosition = 0;
            this.m_UIToggleButton.selected = currentState == STATE_OPEN;
            this.m_UncommittedCurrentState = false;
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(param1 is MouseRepeatEvent && (param1.currentTarget == this.m_UIScrollDownButton || param1.currentTarget == this.m_UIScrollUpButton))
         {
            MouseRepeatEvent(param1).repeatEnabled = true;
         }
      }
      
      private function updateToolTips() : void
      {
         var _loc8_:IAction = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(this.m_ActionBar == null || this.m_ActionBar.length < 1)
         {
            return;
         }
         var _loc1_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc1_ == null || _loc2_ == null || !_loc2_.isGameRunning)
         {
            return;
         }
         var _loc3_:Vector.<AppearanceTypeRef> = new Vector.<AppearanceTypeRef>();
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = 0;
         _loc7_ = this.m_ActionBar.size;
         while(_loc4_ < _loc7_)
         {
            _loc8_ = this.m_ActionBar.getAction(_loc4_);
            _loc9_ = -1;
            _loc10_ = -1;
            if(_loc8_ is UseAction)
            {
               _loc9_ = UseAction(_loc8_).type.ID;
               _loc10_ = UseAction(_loc8_).data;
            }
            else if(_loc8_ is EquipAction)
            {
               _loc9_ = EquipAction(_loc8_).type.ID;
               _loc10_ = EquipAction(_loc8_).data;
            }
            if(_loc9_ > -1 && _loc10_ > -1 && _loc1_.getCachedObjectTypeName(_loc9_,_loc10_) == null)
            {
               _loc3_.push(new AppearanceTypeRef(_loc9_,_loc10_));
            }
            _loc4_++;
         }
         _loc3_ = _loc3_.sort(AppearanceTypeRef.s_Compare);
         _loc7_ = _loc3_.length;
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc4_ < _loc7_)
         {
            while(_loc5_ < _loc7_ && _loc3_[_loc4_].equals(_loc3_[_loc5_]))
            {
               _loc5_++;
            }
            if(_loc5_ - _loc4_ > 1)
            {
               _loc6_ = _loc5_ - _loc4_ - 1;
               _loc7_ = _loc7_ - _loc6_;
               _loc5_ = _loc4_ + 1;
               while(_loc5_ < _loc7_)
               {
                  _loc3_[_loc5_] = _loc3_[_loc5_ + _loc6_];
                  _loc5_++;
               }
            }
            _loc4_++;
            _loc5_ = _loc4_;
         }
         _loc3_.length = _loc7_;
         _loc2_.sendCGETOBJECTINFO(_loc3_);
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.measure();
         _loc1_ = viewMetricsAndPadding;
         var _loc2_:Number = this.m_Direction == DIRECTION_HORIZONTAL?Number(getStyle("horizontalGap")):Number(getStyle("verticalGap"));
         var _loc3_:Number = this.m_UIToggleButton.getExplicitOrMeasuredHeight();
         var _loc4_:Number = this.m_UIToggleButton.getExplicitOrMeasuredWidth();
         _loc5_ = this.m_UIScrollUpButton.getExplicitOrMeasuredHeight() + this.m_UIScrollDownButton.getExplicitOrMeasuredHeight();
         _loc6_ = this.m_UIScrollUpButton.getExplicitOrMeasuredWidth() + this.m_UIScrollDownButton.getExplicitOrMeasuredWidth();
         var _loc7_:UIComponent = null;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc14_:int = 0;
         var _loc15_:int = numChildren;
         if(this.m_Direction == DIRECTION_HORIZONTAL)
         {
            _loc14_ = 0;
            while(_loc14_ < _loc15_)
            {
               _loc7_ = UIComponent(getChildAt(_loc14_));
               _loc10_ = _loc7_.getExplicitOrMeasuredWidth();
               _loc13_ = _loc7_.getExplicitOrMeasuredHeight();
               _loc8_ = Math.max(_loc8_,_loc13_);
               _loc11_ = Math.max(_loc11_,_loc10_);
               _loc12_ = _loc12_ + _loc10_;
               _loc14_++;
            }
            if(currentState == STATE_COLLAPSED && this.m_Location == ActionBarSet.LOCATION_TOP)
            {
               measuredMinHeight = measuredHeight = _loc1_.top;
            }
            else if(currentState == STATE_COLLAPSED && this.m_Location == ActionBarSet.LOCATION_BOTTOM)
            {
               measuredMinHeight = measuredHeight = _loc1_.bottom;
            }
            else
            {
               measuredMinHeight = measuredHeight = _loc1_.top + _loc8_ + _loc1_.bottom;
            }
            measuredMinWidth = _loc1_.left + _loc6_ + _loc11_ + 2 * _loc2_ + _loc1_.right;
            measuredWidth = _loc1_.left + _loc6_ + _loc12_ + (numChildren + 1) * _loc2_ + _loc1_.right;
         }
         else
         {
            _loc14_ = 0;
            while(_loc14_ < _loc15_)
            {
               _loc7_ = UIComponent(getChildAt(_loc14_));
               _loc13_ = _loc7_.getExplicitOrMeasuredHeight();
               _loc10_ = _loc7_.getExplicitOrMeasuredWidth();
               _loc11_ = Math.max(_loc11_,_loc10_);
               _loc8_ = Math.max(_loc8_,_loc13_);
               _loc9_ = _loc9_ + _loc13_;
               _loc14_++;
            }
            if(currentState == STATE_COLLAPSED && this.m_Location == ActionBarSet.LOCATION_LEFT)
            {
               measuredMinWidth = measuredWidth = _loc1_.left;
            }
            else if(currentState == STATE_COLLAPSED && this.m_Location == ActionBarSet.LOCATION_RIGHT)
            {
               measuredMinWidth = measuredWidth = _loc1_.right;
            }
            else
            {
               measuredMinWidth = measuredWidth = _loc1_.left + _loc11_ + _loc1_.right;
            }
            measuredMinHeight = _loc1_.top + _loc5_ + _loc8_ + 2 * _loc2_ + _loc1_.bottom;
            measuredHeight = _loc1_.top + _loc5_ + _loc9_ + (numChildren + 1) * _loc2_ + _loc1_.bottom;
         }
         this.m_MaxChildHeight = _loc8_;
         this.m_MaxChildWidth = _loc11_;
      }
      
      protected function updateActionBar() : void
      {
         var _loc2_:ActionBarSet = null;
         var _loc1_:ActionBar = null;
         if(this.m_Options != null)
         {
            _loc2_ = this.m_Options.getActionBarSet(this.m_Options.generalInputSetID);
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_.getActionBar(this.m_Location);
            }
         }
         this.actionBar = _loc1_;
      }
      
      private function updateButtonDragListeners(param1:IActionButton, param2:Boolean) : void
      {
         var _loc3_:DisplayObject = null;
         if(param1 != null && systemManager != null && (_loc3_ = systemManager.getSandboxRoot()) != null)
         {
            if(param2)
            {
               param1.addEventListener(MouseEvent.MOUSE_MOVE,this.onButtonActionDragStart);
               param1.addEventListener(MouseEvent.MOUSE_UP,this.onButtonActionDragStop);
               _loc3_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onButtonActionDragStop);
            }
            else
            {
               param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.onButtonActionDragStart);
               param1.removeEventListener(MouseEvent.MOUSE_UP,this.onButtonActionDragStop);
               _loc3_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onButtonActionDragStop);
            }
         }
      }
      
      public function set location(param1:int) : void
      {
         if(param1 != ActionBarSet.LOCATION_TOP && param1 != ActionBarSet.LOCATION_BOTTOM && param1 != ActionBarSet.LOCATION_LEFT && param1 != ActionBarSet.LOCATION_RIGHT)
         {
            throw new ArgumentError("ActionBarWidget.set location: Invalid value.");
         }
         if(this.m_Location != param1)
         {
            if(this.m_Direction == DIRECTION_HORIZONTAL && (param1 == ActionBarSet.LOCATION_TOP || param1 == ActionBarSet.LOCATION_BOTTOM))
            {
               this.m_Location = param1;
               this.m_UncommittedLocation = true;
            }
            if(this.m_Direction == DIRECTION_VERTICAL && (param1 == ActionBarSet.LOCATION_LEFT || param1 == ActionBarSet.LOCATION_RIGHT))
            {
               this.m_Location = param1;
               this.m_UncommittedLocation = true;
            }
            invalidateDisplayList();
            invalidateProperties();
            this.updateActionBar();
         }
      }
      
      private function onButtonSpellDragEvent(param1:DragEvent) : void
      {
         var _loc2_:IActionButton = null;
         var _loc3_:DragSource = null;
         var _loc4_:Spell = null;
         if((this.options == null || !this.options.generalActionBarsLock) && (_loc2_ = param1.currentTarget as IActionButton) != null && (_loc3_ = param1.dragSource) != null && _loc3_.hasFormat("dragType") && _loc3_.dataForFormat("dragType") == DRAG_TYPE_SPELL && _loc3_.hasFormat("dragSpell") && (_loc4_ = _loc3_.dataForFormat("dragSpell") as Spell) != null && this.m_ActionBar != null)
         {
            if(param1.type == DragEvent.DRAG_DROP)
            {
               this.m_ActionBar.setAction(_loc2_.position,new SpellAction(_loc4_,null));
            }
            else if(param1.type == DragEvent.DRAG_ENTER)
            {
               DragManager.acceptDragDrop(_loc2_);
            }
         }
      }
      
      public function set containerStorage(param1:ContainerStorage) : void
      {
         if(this.m_ContainerStorage != param1)
         {
            if(this.m_ContainerStorage != null)
            {
               this.m_ContainerStorage.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onContainerChange);
            }
            this.m_ContainerStorage = param1;
            if(this.m_ContainerStorage != null)
            {
               this.m_ContainerStorage.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onContainerChange);
            }
            this.m_UncommittedContainerStorage = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         this.scrollPosition = this.scrollPosition + -param1.delta / Math.abs(param1.delta) * (!!param1.shiftKey?10:1);
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         var _loc1_:IBorder = mx_internal::border as IBorder;
         if(_loc1_ != null)
         {
            return _loc1_.borderMetrics;
         }
         return EdgeMetrics.EMPTY;
      }
      
      private function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "generalInputSetID" || param1.property == "actionBarSet" || param1.property == "*")
         {
            invalidateDisplayList();
            this.updateActionBar();
         }
         if(param1.property == "generalActionBarsLock" || param1.property == "*")
         {
            invalidateDisplayList();
         }
      }
      
      public function get actionBar() : ActionBar
      {
         return this.m_ActionBar;
      }
      
      public function set direction(param1:int) : void
      {
         if(param1 != DIRECTION_HORIZONTAL && param1 != DIRECTION_VERTICAL)
         {
            throw new ArgumentError("ActionBarWidget.set direction: Invalid value.");
         }
         if(this.m_Direction != param1)
         {
            this.m_Direction = param1;
            this.m_UncommittedDirection = true;
            if(this.m_Direction == DIRECTION_HORIZONTAL && (this.m_Location != ActionBarSet.LOCATION_TOP && this.m_Location != ActionBarSet.LOCATION_BOTTOM))
            {
               this.m_Location == ActionBarSet.LOCATION_TOP;
               this.m_UncommittedLocation = true;
            }
            if(this.m_Direction == DIRECTION_VERTICAL && (this.m_Location != ActionBarSet.LOCATION_RIGHT && this.m_Location != ActionBarSet.LOCATION_RIGHT))
            {
               this.m_Location = ActionBarSet.LOCATION_LEFT;
               this.m_UncommittedLocation = true;
            }
            invalidateProperties();
            this.updateActionBar();
         }
      }
      
      public function get direction() : int
      {
         return this.m_Direction;
      }
   }
}
