package tibia.options.configurationWidgetClasses
{
   import flash.events.Event;
   import mx.containers.Form;
   import mx.containers.FormHeading;
   import mx.containers.FormItem;
   import mx.containers.VBox;
   import mx.controls.CheckBox;
   import mx.core.IContainer;
   import mx.events.SliderEvent;
   import tibia.controls.CustomSlider;
   import tibia.options.ConfigurationWidget;
   import tibia.options.OptionsStorage;
   
   public class RendererOptions extends VBox implements IOptionsEditor
   {
       
      
      private var m_UIAmbientBrightness:CustomSlider = null;
      
      private var m_UILevelSeparator:CustomSlider = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      private var m_UILightEnabled:CheckBox = null;
      
      private var m_UncommittedValues:Boolean = true;
      
      private var m_UIShowFrameRate:CheckBox = null;
      
      protected var m_Options:OptionsStorage = null;
      
      private var m_UIHighlight:CustomSlider = null;
      
      private var m_UIMaxFrameRate:CustomSlider = null;
      
      private var m_UIScaleMap:CheckBox = null;
      
      private var m_UIAntialiasing:CheckBox = null;
      
      public function RendererOptions()
      {
         super();
         label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_LABEL");
      }
      
      private function onValueChange(param1:Event) : void
      {
         var _loc2_:OptionsEditorEvent = null;
         if(param1 != null)
         {
            _loc2_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc2_);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            if(this.options != null)
            {
               this.m_UIAmbientBrightness.value = 100 * this.options.rendererAmbientBrightness;
               this.m_UIHighlight.value = 100 * this.options.rendererHighlight;
               this.m_UILevelSeparator.value = 100 * this.options.rendererLevelSeparator;
               this.m_UILightEnabled.selected = this.options.rendererLightEnabled;
               this.m_UIMaxFrameRate.value = this.options.rendererMaxFrameRate;
               this.m_UIScaleMap.selected = this.options.rendererScaleMap;
               this.m_UIAntialiasing.selected = this.options.rendererAntialiasing;
               this.m_UIShowFrameRate.selected = this.options.rendererShowFrameRate;
            }
            else
            {
               this.m_UIAmbientBrightness.value = 0;
               this.m_UIHighlight.value = 0;
               this.m_UILevelSeparator.value = 0;
               this.m_UILightEnabled.selected = false;
               this.m_UIMaxFrameRate.value = 0;
               this.m_UIScaleMap.selected = false;
               this.m_UIAntialiasing.selected = false;
               this.m_UIShowFrameRate.selected = false;
            }
            IContainer(this.m_UIAmbientBrightness.parent).enabled = this.m_UILightEnabled.selected;
            IContainer(this.m_UILevelSeparator.parent).enabled = this.m_UILightEnabled.selected;
            this.m_UncommittedOptions = false;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var Frm:Form = new Form();
         Frm.styleName = "optionsConfigurationWidgetRootContainer";
         var Heading:FormHeading = new FormHeading();
         Heading.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_LIGHT_HEADING");
         Heading.percentHeight = NaN;
         Heading.percentWidth = 100;
         Frm.addChild(Heading);
         var Item:FormItem = new FormItem();
         Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_LIGHT_ENABLED");
         Item.percentHeight = NaN;
         Item.percentWidth = 100;
         this.m_UILightEnabled = new CheckBox();
         this.m_UILightEnabled.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            IContainer(m_UIAmbientBrightness.parent).enabled = m_UILightEnabled.selected;
            IContainer(m_UILevelSeparator.parent).enabled = m_UILightEnabled.selected;
         });
         this.m_UILightEnabled.addEventListener(Event.CHANGE,this.onValueChange);
         Item.addChild(this.m_UILightEnabled);
         Frm.addChild(Item);
         Item = new FormItem();
         Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_LIGHT_AMBIENT_BRIGHTNESS");
         Item.percentHeight = NaN;
         Item.percentWidth = 100;
         this.m_UIAmbientBrightness = new CustomSlider();
         this.m_UIAmbientBrightness.minimum = 0;
         this.m_UIAmbientBrightness.maximum = 100;
         this.m_UIAmbientBrightness.snapInterval = 1;
         this.m_UIAmbientBrightness.percentWidth = 100;
         this.m_UIAmbientBrightness.addEventListener(SliderEvent.CHANGE,this.onValueChange);
         Item.addChild(this.m_UIAmbientBrightness);
         Item.setStyle("disabledOverlayAlpha",0);
         Frm.addChild(Item);
         Item = new FormItem();
         Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_LIGHT_LEVEL_SEPARATOR");
         Item.percentHeight = NaN;
         Item.percentWidth = 100;
         this.m_UILevelSeparator = new CustomSlider();
         this.m_UILevelSeparator.minimum = 0;
         this.m_UILevelSeparator.maximum = 100;
         this.m_UILevelSeparator.snapInterval = 1;
         this.m_UILevelSeparator.percentWidth = 100;
         this.m_UILevelSeparator.addEventListener(SliderEvent.CHANGE,this.onValueChange);
         Item.addChild(this.m_UILevelSeparator);
         Item.setStyle("disabledOverlayAlpha",0);
         Frm.addChild(Item);
         Heading = new FormHeading();
         Heading.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_MAP_HEADING");
         Heading.percentHeight = NaN;
         Heading.percentWidth = 100;
         Frm.addChild(Heading);
         Item = new FormItem();
         Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_MAP_HIGHLIGHT");
         Item.percentHeight = NaN;
         Item.percentWidth = 100;
         this.m_UIHighlight = new CustomSlider();
         this.m_UIHighlight.minimum = 0;
         this.m_UIHighlight.maximum = 100;
         this.m_UIHighlight.snapInterval = 1;
         this.m_UIHighlight.percentWidth = 100;
         this.m_UIHighlight.addEventListener(SliderEvent.CHANGE,this.onValueChange);
         Item.addChild(this.m_UIHighlight);
         Frm.addChild(Item);
         Item = new FormItem();
         Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_MAP_SCALE_MAP");
         Item.percentHeight = NaN;
         Item.percentWidth = 100;
         this.m_UIScaleMap = new CheckBox();
         this.m_UIScaleMap.addEventListener(Event.CHANGE,this.onValueChange);
         Item.addChild(this.m_UIScaleMap);
         Frm.addChild(Item);
         Item = new FormItem();
         Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_MAP_ANTIALIASING");
         Item.percentHeight = NaN;
         Item.percentWidth = 100;
         this.m_UIAntialiasing = new CheckBox();
         this.m_UIAntialiasing.addEventListener(Event.CHANGE,this.onValueChange);
         Item.addChild(this.m_UIAntialiasing);
         Frm.addChild(Item);
         Heading = new FormHeading();
         Heading.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_PERF_HEADING");
         Heading.percentHeight = NaN;
         Heading.percentWidth = 100;
         Frm.addChild(Heading);
         Item = new FormItem();
         Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_PERF_MAX_FPS");
         Item.percentHeight = NaN;
         Item.percentWidth = 100;
         this.m_UIMaxFrameRate = new CustomSlider();
         this.m_UIMaxFrameRate.minimum = 10;
         this.m_UIMaxFrameRate.maximum = 60;
         this.m_UIMaxFrameRate.snapInterval = 1;
         this.m_UIMaxFrameRate.liveDragging = true;
         this.m_UIMaxFrameRate.percentWidth = 100;
         this.m_UIMaxFrameRate.addEventListener(SliderEvent.CHANGE,this.onValueChange);
         Item.addChild(this.m_UIMaxFrameRate);
         Frm.addChild(Item);
         Item = new FormItem();
         Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"RENDERER_PERF_SHOW_FPS");
         Item.percentHeight = NaN;
         Item.percentWidth = 100;
         this.m_UIShowFrameRate = new CheckBox();
         this.m_UIShowFrameRate.addEventListener(Event.CHANGE,this.onValueChange);
         Item.addChild(this.m_UIShowFrameRate);
         Frm.addChild(Item);
         addChild(Frm);
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         this.m_Options = param1;
         this.m_UncommittedOptions = true;
         invalidateProperties();
      }
      
      public function close(param1:Boolean = false) : void
      {
         if(this.options != null && param1 && this.m_UncommittedValues)
         {
            this.options.rendererAmbientBrightness = this.m_UIAmbientBrightness.value / 100;
            this.options.rendererHighlight = this.m_UIHighlight.value / 100;
            this.options.rendererLevelSeparator = this.m_UILevelSeparator.value / 100;
            this.options.rendererLightEnabled = this.m_UILightEnabled.selected;
            this.options.rendererMaxFrameRate = this.m_UIMaxFrameRate.value;
            this.options.rendererScaleMap = this.m_UIScaleMap.selected;
            this.options.rendererAntialiasing = this.m_UIAntialiasing.selected;
            this.options.rendererShowFrameRate = this.m_UIShowFrameRate.selected;
            this.m_UncommittedValues = false;
         }
      }
   }
}
