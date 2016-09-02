package mx.controls
{
   import flash.events.EventDispatcher;
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   import flash.events.Event;
   import mx.events.FlexEvent;
   import mx.core.IFlexDisplayObject;
   import mx.core.Application;
   
   use namespace mx_internal;
   
   public class RadioButtonGroup extends EventDispatcher implements IMXMLObject
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var radioButtons:Array;
      
      private var _selection:mx.controls.RadioButton;
      
      private var _selectedValue:Object;
      
      private var document:IFlexDisplayObject;
      
      private var _labelPlacement:String = "right";
      
      private var indexNumber:int = 0;
      
      public function RadioButtonGroup(param1:IFlexDisplayObject = null)
      {
         radioButtons = [];
         super();
      }
      
      [Bindable("enabledChanged")]
      public function get enabled() : Boolean
      {
         var _loc1_:Number = 0;
         var _loc2_:int = numRadioButtons;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _loc1_ + getRadioButtonAt(_loc3_).enabled;
            _loc3_++;
         }
         if(_loc1_ == 0)
         {
            return false;
         }
         if(_loc1_ == _loc2_)
         {
            return true;
         }
         return false;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:int = numRadioButtons;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            getRadioButtonAt(_loc3_).enabled = param1;
            _loc3_++;
         }
         dispatchEvent(new Event("enabledChanged"));
      }
      
      private function radioButton_removedHandler(param1:Event) : void
      {
         var _loc2_:mx.controls.RadioButton = param1.target as mx.controls.RadioButton;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.REMOVED,radioButton_removedHandler);
            removeInstance(RadioButton(param1.target));
         }
      }
      
      public function set selectedValue(param1:Object) : void
      {
         var _loc4_:mx.controls.RadioButton = null;
         _selectedValue = param1;
         var _loc2_:int = numRadioButtons;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = getRadioButtonAt(_loc3_);
            if(_loc4_.value == param1 || _loc4_.label == param1)
            {
               changeSelection(_loc3_,false);
               break;
            }
            _loc3_++;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      private function getValue() : String
      {
         if(selection)
         {
            return selection.value && selection.value is String && String(selection.value).length != 0?String(selection.value):selection.label;
         }
         return null;
      }
      
      [Bindable("labelPlacementChanged")]
      public function get labelPlacement() : String
      {
         return _labelPlacement;
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selection() : mx.controls.RadioButton
      {
         return _selection;
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedValue() : Object
      {
         if(selection)
         {
            return selection.value != null?selection.value:selection.label;
         }
         return null;
      }
      
      public function set selection(param1:mx.controls.RadioButton) : void
      {
         setSelection(param1,false);
      }
      
      mx_internal function setSelection(param1:mx.controls.RadioButton, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == null && _selection != null)
         {
            _selection.selected = false;
            _selection = null;
            if(param2)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
         else
         {
            _loc3_ = numRadioButtons;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(param1 == getRadioButtonAt(_loc4_))
               {
                  changeSelection(_loc4_,param2);
                  break;
               }
               _loc4_++;
            }
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
         this.document = !!param1?IFlexDisplayObject(param1):IFlexDisplayObject(Application.application);
      }
      
      mx_internal function addInstance(param1:mx.controls.RadioButton) : void
      {
         param1.indexNumber = indexNumber++;
         param1.addEventListener(Event.REMOVED,radioButton_removedHandler);
         radioButtons.push(param1);
         if(_selectedValue != null)
         {
            selectedValue = _selectedValue;
         }
         dispatchEvent(new Event("numRadioButtonsChanged"));
      }
      
      public function set labelPlacement(param1:String) : void
      {
         _labelPlacement = param1;
         var _loc2_:int = numRadioButtons;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            getRadioButtonAt(_loc3_).labelPlacement = param1;
            _loc3_++;
         }
      }
      
      [Bindable("numRadioButtonsChanged")]
      public function get numRadioButtons() : int
      {
         return radioButtons.length;
      }
      
      public function getRadioButtonAt(param1:int) : mx.controls.RadioButton
      {
         return RadioButton(radioButtons[param1]);
      }
      
      mx_internal function removeInstance(param1:mx.controls.RadioButton) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:mx.controls.RadioButton = null;
         if(param1)
         {
            _loc2_ = false;
            _loc3_ = 0;
            while(_loc3_ < numRadioButtons)
            {
               _loc4_ = getRadioButtonAt(_loc3_);
               if(_loc2_)
               {
                  _loc4_.indexNumber--;
               }
               else if(_loc4_ == param1)
               {
                  _loc4_.group = null;
                  if(param1 == _selection)
                  {
                     _selection = null;
                  }
                  radioButtons.splice(_loc3_,1);
                  _loc2_ = true;
                  indexNumber--;
                  _loc3_--;
               }
               _loc3_++;
            }
            if(_loc2_)
            {
               dispatchEvent(new Event("numRadioButtonsChanged"));
            }
         }
      }
      
      private function changeSelection(param1:int, param2:Boolean = true) : void
      {
         if(getRadioButtonAt(param1))
         {
            if(selection)
            {
               selection.selected = false;
            }
            _selection = getRadioButtonAt(param1);
            _selection.selected = true;
            if(param2)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
   }
}
