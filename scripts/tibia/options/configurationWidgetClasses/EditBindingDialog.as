package tibia.options.configurationWidgetClasses
{
   import shared.controls.EmbeddedDialog;
   import tibia.input.mapping.Binding;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import mx.events.CloseEvent;
   import mx.containers.Box;
   import mx.controls.Text;
   import mx.containers.HBox;
   import flash.events.FocusEvent;
   import flash.events.Event;
   import mx.core.EventPriority;
   
   public class EditBindingDialog extends EmbeddedDialog
   {
      
      private static const BUNDLE:String = "OptionsConfigurationWidget";
       
      
      private var m_LastKeyCode:uint = 0;
      
      private var m_LastCharCode:uint = 0;
      
      private var m_LastModifierCode:uint = 0;
      
      private var m_OldBinding:Binding = null;
      
      private var m_LastText:String = null;
      
      private var m_UIFooter:Text = null;
      
      private var m_Mapping:Array = null;
      
      private var m_NewBinding:Binding = null;
      
      private var m_UIBinding:Text = null;
      
      public function EditBindingDialog()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddRemove);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onAddRemove);
         addEventListener(CloseEvent.CLOSE,this.onClose);
      }
      
      public function get binding() : Binding
      {
         return this.m_OldBinding;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         this.m_LastCharCode = 0;
         this.m_LastKeyCode = 0;
         this.m_LastModifierCode = 0;
         this.m_LastText = null;
         if(Binding.isBindable(param1.keyCode,param1.altKey,param1.ctrlKey,param1.shiftKey))
         {
            this.m_LastCharCode = param1.charCode;
            this.m_LastKeyCode = param1.keyCode;
            this.m_LastModifierCode = Binding.toModifierCode(param1.altKey,param1.ctrlKey,param1.shiftKey);
            this.m_LastText = "";
         }
      }
      
      public function set binding(param1:Binding) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("EditBindingDialog.set binding: Invalid binding.");
         }
         if(this.m_OldBinding != param1)
         {
            this.m_OldBinding = param1;
            this.m_NewBinding = this.m_OldBinding.clone();
            invalidateProperties();
         }
      }
      
      private function onTextInput(param1:TextEvent) : void
      {
         this.m_LastText = param1.text;
      }
      
      public function get mapping() : Array
      {
         return this.m_Mapping;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = undefined;
         var _loc3_:* = false;
         var _loc4_:Binding = null;
         if(this.m_OldBinding != null && this.m_NewBinding != null && this.m_Mapping != null)
         {
            _loc1_ = false;
            _loc2_ = null;
            for each(_loc2_ in this.m_Mapping)
            {
               if(this.m_OldBinding == _loc2_.firstBinding || this.m_OldBinding == _loc2_.secondBinding)
               {
                  _loc1_ = true;
                  break;
               }
            }
            _loc3_ = this.m_NewBinding.keyCode != 0;
            _loc4_ = null;
            if(_loc3_)
            {
               for each(_loc2_ in this.m_Mapping)
               {
                  if(this.m_OldBinding != _loc2_.firstBinding && this.m_NewBinding.conflicts(_loc2_.firstBinding))
                  {
                     _loc4_ = Binding(_loc2_.firstBinding);
                     break;
                  }
                  if(this.m_OldBinding != _loc2_.secondBinding && this.m_NewBinding.conflicts(_loc2_.secondBinding))
                  {
                     _loc4_ = Binding(_loc2_.secondBinding);
                     break;
                  }
               }
               if(_loc4_ != null)
               {
                  _loc3_ = Boolean(_loc4_.editable && !_loc4_.action.equals(this.m_NewBinding.action));
               }
            }
            buttonFlags = EmbeddedDialog.CANCEL | (!!_loc1_?EmbeddedDialog.CLEAR:0) | (!!_loc3_?EmbeddedDialog.OKAY:0);
            title = resourceManager.getString(BUNDLE,"HOTKEY_DLG_EDIT_TITLE",[this.m_NewBinding.action]);
            this.m_UIBinding.text = this.m_NewBinding.toString();
            if(this.m_NewBinding.keyCode == 0)
            {
               this.m_UIBinding.setStyle("color",undefined);
               this.m_UIFooter.text = null;
            }
            else if(_loc4_ != null && _loc4_.action.equals(this.m_NewBinding.action))
            {
               this.m_UIBinding.setStyle("color",16711680);
               this.m_UIFooter.text = resourceManager.getString(BUNDLE,"HOTKEY_DLG_EDIT_SELF",[_loc4_.action]);
            }
            else if(_loc4_ != null && !_loc4_.editable)
            {
               this.m_UIBinding.setStyle("color",16711680);
               this.m_UIFooter.text = resourceManager.getString(BUNDLE,"HOTKEY_DLG_EDIT_STATIC",[_loc4_.action]);
            }
            else if(_loc4_ != null)
            {
               this.m_UIBinding.setStyle("color",16776960);
               this.m_UIFooter.text = resourceManager.getString(BUNDLE,"HOTKEY_DLG_EDIT_DYNAMIC",[_loc4_.action,this.m_NewBinding.action]);
            }
            else
            {
               this.m_UIBinding.setStyle("color",undefined);
               this.m_UIFooter.text = resourceManager.getString(BUNDLE,"HOTKEY_DLG_EDIT_DEFAULT");
            }
            if(_loc1_)
            {
               this.m_UIFooter.text = this.m_UIFooter.text + resourceManager.getString(BUNDLE,"HOTKEY_DLG_EDIT_CLEAR",[this.m_NewBinding.action]);
            }
         }
         else
         {
            buttonFlags = EmbeddedDialog.CANCEL;
            title = null;
            this.m_UIBinding.text = null;
            this.m_UIFooter.text = null;
         }
         super.commitProperties();
      }
      
      private function onClose(param1:CloseEvent) : void
      {
         removeEventListener(CloseEvent.CLOSE,this.onClose);
         if(param1.detail == EmbeddedDialog.CLEAR)
         {
            this.updateBinding(this.m_Mapping,this.m_OldBinding,null);
         }
         else if(param1.detail == EmbeddedDialog.OKAY)
         {
            this.updateBinding(this.m_Mapping,this.m_OldBinding,this.m_NewBinding);
         }
      }
      
      public function set mapping(param1:Array) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("EditBindingDialog.set mapping: Invalid mapping.");
         }
         if(this.m_Mapping != param1)
         {
            this.m_Mapping = param1;
            invalidateProperties();
         }
      }
      
      override protected function createContent(param1:Box) : void
      {
         this.m_UIBinding = new Text();
         this.m_UIBinding.styleName = getStyle("textStyle");
         this.m_UIBinding.setStyle("fontSize",16);
         this.m_UIBinding.setStyle("fontWeight","bold");
         var _loc2_:HBox = new HBox();
         _loc2_.percentWidth = 100;
         _loc2_.setStyle("horizontalAlign","center");
         _loc2_.addChild(this.m_UIBinding);
         param1.addChild(_loc2_);
         this.m_UIFooter = new Text();
         this.m_UIFooter.percentWidth = 100;
         this.m_UIFooter.styleName = getStyle("textStyle");
         param1.addChild(this.m_UIFooter);
         param1.minHeight = 77;
         param1.setStyle("verticalAlign","top");
      }
      
      private function onFocusOut(param1:FocusEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         setFocus();
      }
      
      private function onAddRemove(param1:Event) : void
      {
         if(param1.type == Event.ADDED_TO_STAGE)
         {
            addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,EventPriority.DEFAULT + 1,false);
            addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            addEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
         }
         else
         {
            removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            removeEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(this.m_LastKeyCode != 0)
         {
            this.m_NewBinding.update(this.m_LastCharCode,this.m_LastKeyCode,this.m_LastModifierCode,this.m_LastText);
            invalidateProperties();
         }
         this.m_LastCharCode = 0;
         this.m_LastKeyCode = 0;
         this.m_LastModifierCode = 0;
         this.m_LastText = null;
      }
      
      private function updateBinding(param1:Array, param2:Binding, param3:Binding) : void
      {
         var _loc5_:Boolean = false;
         var _loc4_:Object = null;
         for each(_loc4_ in param1)
         {
            if(param2 != _loc4_.firstBinding && param3 != null && param3.conflicts(_loc4_.firstBinding) || param2 == _loc4_.firstBinding && param3 == null)
            {
               _loc4_.firstBinding = _loc4_.secondBinding;
               _loc4_.secondBinding = null;
            }
            if(param2 != _loc4_.secondBinding && param3 != null && param3.conflicts(_loc4_.secondBinding) || param2 == _loc4_.secondBinding && param3 == null)
            {
               _loc4_.secondBinding = null;
            }
         }
         if(param3 == null)
         {
            return;
         }
         param2.update(param3);
         for each(_loc4_ in param1)
         {
            _loc5_ = param2.action.equals(_loc4_.action);
            if(param2 == _loc4_.firstBinding || _loc5_ && _loc4_.firstBinding == null)
            {
               _loc4_.firstBinding = param2;
               break;
            }
            if(param2 == _loc4_.secondBinding || _loc5_ && _loc4_.secondBinding == null)
            {
               _loc4_.secondBinding = param2;
               break;
            }
         }
      }
   }
}
