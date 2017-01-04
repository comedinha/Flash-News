package mx.controls
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IToggleButton;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ItemClickEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerGroup;
   
   use namespace mx_internal;
   
   public class RadioButton extends Button implements IFocusManagerGroup, IToggleButton
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      mx_internal static var createAccessibilityImplementation:Function;
       
      
      private var _group:RadioButtonGroup;
      
      mx_internal var _groupName:String;
      
      private var _value:Object;
      
      private var groupChanged:Boolean = false;
      
      mx_internal var indexNumber:int = 0;
      
      public function RadioButton()
      {
         super();
         _labelPlacement = "";
         _toggle = true;
         groupName = "radioGroup";
         addEventListener(FlexEvent.ADD,addHandler);
         centerContent = false;
         extraSpacing = 8;
      }
      
      private function addHandler(param1:FlexEvent) : void
      {
         if(!_group && initialized)
         {
            addToGroup();
         }
      }
      
      private function setNext(param1:Boolean = true) : void
      {
         var _loc5_:RadioButton = null;
         var _loc2_:RadioButtonGroup = group;
         var _loc3_:IFocusManager = focusManager;
         if(_loc3_)
         {
            _loc3_.showFocusIndicator = true;
         }
         var _loc4_:int = indexNumber + 1;
         while(_loc4_ < _loc2_.numRadioButtons)
         {
            _loc5_ = _loc2_.getRadioButtonAt(_loc4_);
            if(_loc5_ && _loc5_.enabled)
            {
               if(param1)
               {
                  _loc2_.setSelection(_loc5_);
               }
               _loc5_.setFocus();
               return;
            }
            _loc4_++;
         }
         if(param1 && _loc2_.getRadioButtonAt(indexNumber) != _loc2_.selection)
         {
            _loc2_.setSelection(this);
         }
         this.drawFocus(true);
      }
      
      private function addToGroup() : Object
      {
         var _loc1_:RadioButtonGroup = group;
         if(_loc1_)
         {
            _loc1_.addInstance(this);
         }
         return _loc1_;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(groupChanged)
         {
            addToGroup();
            groupChanged = false;
         }
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         if(!enabled || selected)
         {
            return;
         }
         if(!_group)
         {
            addToGroup();
         }
         super.clickHandler(param1);
         group.setSelection(this);
         var _loc2_:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         _loc2_.label = label;
         _loc2_.index = indexNumber;
         _loc2_.relatedObject = this;
         _loc2_.item = value;
         group.dispatchEvent(_loc2_);
      }
      
      override protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         super.keyUpHandler(param1);
         if(param1.keyCode == Keyboard.SPACE && !_toggle)
         {
            _toggle = true;
         }
      }
      
      [Bindable("labelPlacementChanged")]
      override public function get labelPlacement() : String
      {
         var _loc1_:String = ButtonLabelPlacement.RIGHT;
         if(_labelPlacement != "")
         {
            _loc1_ = _labelPlacement;
         }
         else if(_group && _group.labelPlacement != "")
         {
            _loc1_ = _group.labelPlacement;
         }
         return _loc1_;
      }
      
      public function set groupName(param1:String) : void
      {
         if(!param1 || param1 == "")
         {
            return;
         }
         deleteGroup();
         _groupName = param1;
         groupChanged = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new Event("groupNameChanged"));
      }
      
      override protected function initializeAccessibility() : void
      {
         if(RadioButton.createAccessibilityImplementation != null)
         {
            RadioButton.createAccessibilityImplementation(this);
         }
      }
      
      private function setThis() : void
      {
         if(!_group)
         {
            addToGroup();
         }
         var _loc1_:RadioButtonGroup = group;
         if(_loc1_.selection != this)
         {
            _loc1_.setSelection(this);
         }
      }
      
      override public function get emphasized() : Boolean
      {
         return false;
      }
      
      override public function get toggle() : Boolean
      {
         return super.toggle;
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.measure();
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            _loc1_ = measureText(label).height;
            _loc2_ = !!currentIcon?Number(currentIcon.height):Number(0);
            if(labelPlacement == ButtonLabelPlacement.LEFT || labelPlacement == ButtonLabelPlacement.RIGHT)
            {
               _loc3_ = Math.max(_loc1_,_loc2_);
            }
            else
            {
               _loc3_ = _loc1_ + _loc2_;
               _loc4_ = getStyle("verticalGap");
               if(_loc2_ != 0 && !isNaN(_loc4_))
               {
                  _loc3_ = _loc3_ + _loc4_;
               }
            }
            measuredMinHeight = measuredHeight = Math.max(_loc3_,18);
         }
      }
      
      override public function set toggle(param1:Boolean) : void
      {
      }
      
      mx_internal function deleteGroup() : void
      {
         try
         {
            if(document[groupName])
            {
               delete document[groupName];
            }
            return;
         }
         catch(e:Error)
         {
            try
            {
               if(document.automaticRadioButtonGroups[groupName])
               {
                  delete document.automaticRadioButtonGroups[groupName];
               }
            }
            catch(e1:Error)
            {
            }
            return;
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case Keyboard.DOWN:
               setNext(!param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.UP:
               setPrev(!param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.LEFT:
               setPrev(!param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.RIGHT:
               setNext(!param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.SPACE:
               setThis();
               _toggle = false;
            default:
               super.keyDownHandler(param1);
         }
      }
      
      [Bindable("groupNameChanged")]
      public function get groupName() : String
      {
         return _groupName;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(groupChanged)
         {
            addToGroup();
            groupChanged = false;
         }
         if(_group && _selected && _group.selection != this)
         {
            group.setSelection(this,false);
         }
      }
      
      [Bindable("valueChanged")]
      public function get value() : Object
      {
         return _value;
      }
      
      public function set value(param1:Object) : void
      {
         _value = param1;
         dispatchEvent(new Event("valueChanged"));
         if(selected && group)
         {
            group.dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      private function setPrev(param1:Boolean = true) : void
      {
         var _loc5_:RadioButton = null;
         var _loc2_:RadioButtonGroup = group;
         var _loc3_:IFocusManager = focusManager;
         if(_loc3_)
         {
            _loc3_.showFocusIndicator = true;
         }
         var _loc4_:int = 1;
         while(_loc4_ <= indexNumber)
         {
            _loc5_ = _loc2_.getRadioButtonAt(indexNumber - _loc4_);
            if(_loc5_ && _loc5_.enabled)
            {
               if(param1)
               {
                  _loc2_.setSelection(_loc5_);
               }
               _loc5_.setFocus();
               return;
            }
            _loc4_++;
         }
         if(param1 && _loc2_.getRadioButtonAt(indexNumber) != _loc2_.selection)
         {
            _loc2_.setSelection(this);
         }
         this.drawFocus(true);
      }
      
      public function set group(param1:RadioButtonGroup) : void
      {
         _group = param1;
      }
      
      public function get group() : RadioButtonGroup
      {
         var g:RadioButtonGroup = null;
         if(!document)
         {
            return _group;
         }
         if(!_group)
         {
            if(groupName && groupName != "")
            {
               try
               {
                  g = RadioButtonGroup(document[groupName]);
               }
               catch(e:Error)
               {
                  if(document.automaticRadioButtonGroups && document.automaticRadioButtonGroups[groupName])
                  {
                     g = RadioButtonGroup(document.automaticRadioButtonGroups[groupName]);
                  }
               }
               if(!g)
               {
                  g = new RadioButtonGroup(IFlexDisplayObject(document));
                  if(!document.automaticRadioButtonGroups)
                  {
                     document.automaticRadioButtonGroups = {};
                  }
                  document.automaticRadioButtonGroups[groupName] = g;
               }
               else if(!(g is RadioButtonGroup))
               {
                  return null;
               }
               _group = g;
            }
         }
         return _group;
      }
   }
}
