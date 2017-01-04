package tibia.options
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import mx.containers.TabNavigator;
   import mx.core.ContainerCreationPolicy;
   import shared.controls.SimpleTabNavigator;
   import tibia.game.PopUpBase;
   import tibia.options.configurationWidgetClasses.GeneralOptions;
   import tibia.options.configurationWidgetClasses.HotkeyOptions;
   import tibia.options.configurationWidgetClasses.IOptionsEditor;
   import tibia.options.configurationWidgetClasses.MessageOptions;
   import tibia.options.configurationWidgetClasses.MouseControlOptions;
   import tibia.options.configurationWidgetClasses.NameFilterOptions;
   import tibia.options.configurationWidgetClasses.OptionsEditorEvent;
   import tibia.options.configurationWidgetClasses.RendererOptions;
   import tibia.options.configurationWidgetClasses.StatusOptions;
   import tibia.§options:ns_options_internal§.BUNDLE;
   
   public class ConfigurationWidget extends PopUpBase
   {
      
      public static const RENDERER:int = 1;
      
      public static const MOUSE:int = 4;
      
      public static const MESSAGE:int = 3;
      
      public static const GENERAL:int = 0;
      
      static const BUNDLE:String = "OptionsConfigurationWidget";
      
      public static const NAME_FILTER:int = 6;
      
      public static const HOTKEY:int = 5;
      
      public static const STATUS:int = 2;
       
      
      protected var m_SelectedIndex:int = 0;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_UINavigator:TabNavigator = null;
      
      protected var m_UIOptionsEditor:Vector.<IOptionsEditor> = null;
      
      private var m_UncommittedSelectedIndex:Boolean = false;
      
      protected var m_EventHandlerActive:Boolean = false;
      
      protected var m_Options:OptionsStorage = null;
      
      private var m_UIConstructed:Boolean = false;
      
      public function ConfigurationWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
         width = 512;
         height = 532;
         this.m_UIOptionsEditor = new Vector.<IOptionsEditor>();
         this.m_UIOptionsEditor[GENERAL] = new GeneralOptions();
         this.m_UIOptionsEditor[RENDERER] = new RendererOptions();
         this.m_UIOptionsEditor[STATUS] = new StatusOptions();
         this.m_UIOptionsEditor[MESSAGE] = new MessageOptions();
         this.m_UIOptionsEditor[MOUSE] = new MouseControlOptions();
         this.m_UIOptionsEditor[HOTKEY] = new HotkeyOptions();
         this.m_UIOptionsEditor[NAME_FILTER] = new NameFilterOptions();
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_UIOptionsEditor.length)
            {
               this.m_UIOptionsEditor[_loc2_].close(param1);
               _loc2_++;
            }
            Tibia.s_SetOptions(this.options);
         }
         super.hide(param1);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         if(this.m_UncommittedOptions)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_UIOptionsEditor.length)
            {
               this.m_UIOptionsEditor[_loc1_].options = this.m_Options;
               _loc1_++;
            }
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedSelectedIndex)
         {
            if(this.m_UINavigator != null)
            {
               this.m_UINavigator.selectedIndex = this.m_SelectedIndex;
            }
            this.m_UncommittedSelectedIndex = false;
         }
         super.commitProperties();
      }
      
      override protected function get focusRoot() : DisplayObjectContainer
      {
         return this.m_UINavigator.selectedChild;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:int = 0;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UINavigator = new SimpleTabNavigator();
            this.m_UINavigator.percentHeight = 100;
            this.m_UINavigator.percentWidth = 100;
            this.m_UINavigator.styleName = "optionsConfigurationWidgetTabNavigator";
            addChild(this.m_UINavigator);
            _loc1_ = 0;
            while(_loc1_ < this.m_UIOptionsEditor.length)
            {
               this.m_UIOptionsEditor[_loc1_].creationPolicy = ContainerCreationPolicy.NONE;
               this.m_UIOptionsEditor[_loc1_].options = this.m_Options;
               this.m_UIOptionsEditor[_loc1_].percentHeight = 100;
               this.m_UIOptionsEditor[_loc1_].percentWidth = 100;
               this.m_UIOptionsEditor[_loc1_].styleName = "optionsConfigurationWidgetTabContainer";
               this.m_UIOptionsEditor[_loc1_].addEventListener(OptionsEditorEvent.VALUE_CHANGE,this.onValueChange);
               this.m_UINavigator.addChild(this.m_UIOptionsEditor[_loc1_] as DisplayObject);
               _loc1_++;
            }
            this.m_UIConstructed = true;
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function getEditor(param1:int) : IOptionsEditor
      {
         return this.m_UIOptionsEditor[param1];
      }
      
      protected function onValueChange(param1:OptionsEditorEvent) : void
      {
         if(this.m_EventHandlerActive)
         {
            return;
         }
         this.m_EventHandlerActive = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_UIOptionsEditor.length)
         {
            if(param1 != null && param1.currentTarget != this.m_UIOptionsEditor[_loc2_])
            {
               this.m_UIOptionsEditor[_loc2_].dispatchEvent(param1.clone());
            }
            _loc2_++;
         }
         this.m_EventHandlerActive = false;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         param1 = Math.max(0,Math.min(param1,this.m_UIOptionsEditor.length - 1));
         if(this.m_SelectedIndex != param1)
         {
            this.m_SelectedIndex = param1;
            this.m_UncommittedSelectedIndex = true;
            invalidateProperties();
            invalidateFocus();
         }
      }
      
      public function get selectedIndex() : int
      {
         return this.m_SelectedIndex;
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         this.m_Options = param1;
         this.m_UncommittedOptions = true;
         invalidateProperties();
      }
      
      override public function show() : void
      {
         this.options = Tibia.s_GetOptions().clone();
         super.show();
      }
   }
}
