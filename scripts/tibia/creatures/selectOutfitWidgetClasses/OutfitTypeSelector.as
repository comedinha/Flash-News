package tibia.creatures.selectOutfitWidgetClasses
{
   import mx.containers.VBox;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.events.CollectionEvent;
   import mx.controls.Button;
   import flash.events.MouseEvent;
   import shared.controls.ShapeWrapper;
   import mx.containers.HBox;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   import shared.controls.CustomButton;
   import mx.controls.Label;
   import mx.collections.IList;
   import mx.core.EventPriority;
   import mx.events.PropertyChangeEvent;
   
   public class OutfitTypeSelector extends VBox
   {
      
      {
         s_InitializeStyle();
      }
      
      protected var m_UIButtonNext:Button = null;
      
      private var m_UncommittedNoOutfitLabel:Boolean = false;
      
      protected var m_UIAppearance:SimpleAppearanceRenderer = null;
      
      private var m_UncommittedAddons:Boolean = false;
      
      protected var m_Colours:Vector.<int>;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIButtonPrev:Button = null;
      
      protected var m_NoOutfitLabel:String = null;
      
      protected var m_UIName:Label = null;
      
      private var m_UncommittedColours:Boolean = false;
      
      protected var m_Outfits:IList = null;
      
      protected var m_Addons:int = 0;
      
      private var m_UncommittedType:Boolean = false;
      
      protected var m_Type:int = 0;
      
      private var m_UncommittedOutfits:Boolean = false;
      
      public function OutfitTypeSelector()
      {
         this.m_Colours = new Vector.<int>(4,true);
         super();
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = "OutfitTypeSelector";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.defaultFactory = function():void
         {
            this.verticalGap = 2;
            this.horizontalGap = 2;
            this.paddingLeft = 2;
            this.paddingRight = 2;
            this.paddingTop = 2;
            this.paddingBottom = 2;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      protected function onOutfitsChange(param1:CollectionEvent) : void
      {
         if(param1 != null)
         {
            this.m_UncommittedOutfits = true;
            invalidateProperties();
         }
      }
      
      protected function onButtonClick(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.currentTarget)
            {
               case this.m_UIButtonPrev:
                  this.cycleOutfitType(-1);
                  break;
               case this.m_UIButtonNext:
                  this.cycleOutfitType(1);
            }
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:ShapeWrapper = null;
         var _loc2_:HBox = null;
         var _loc3_:HBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new ShapeWrapper();
            _loc1_.width = 140;
            _loc1_.height = 140;
            _loc1_.setStyle("horizontalAlign","right");
            _loc1_.setStyle("verticalAlign","bottom");
            this.m_UIAppearance = new SimpleAppearanceRenderer();
            this.m_UIAppearance.scale = 2;
            _loc1_.addChild(this.m_UIAppearance);
            addChild(_loc1_);
            _loc2_ = new HBox();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.setStyle("horizontalAlign","center");
            _loc2_.setStyle("horizontalGap",2);
            _loc2_.setStyle("verticalAlign","middle");
            _loc2_.setStyle("verticalGap",2);
            this.m_UIButtonPrev = new CustomButton();
            this.m_UIButtonPrev.enabled = this.m_Outfits != null && this.m_Outfits.length > 0;
            this.m_UIButtonPrev.styleName = getStyle("prevButtonStyle");
            this.m_UIButtonPrev.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc2_.addChild(this.m_UIButtonPrev);
            _loc3_ = new HBox();
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            _loc3_.styleName = getStyle("nameLabelStyle");
            this.m_UIName = new Label();
            _loc3_.addChild(this.m_UIName);
            _loc2_.addChild(_loc3_);
            this.m_UIButtonNext = new CustomButton();
            this.m_UIButtonNext.enabled = this.m_Outfits != null && this.m_Outfits.length > 0;
            this.m_UIButtonNext.styleName = getStyle("nextButtonStyle");
            this.m_UIButtonNext.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc2_.addChild(this.m_UIButtonNext);
            addChild(_loc2_);
            this.m_UIConstructed = true;
         }
      }
      
      private function set _1106424112outfits(param1:IList) : void
      {
         if(this.m_Outfits != param1)
         {
            if(this.m_Outfits != null)
            {
               this.m_Outfits.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onOutfitsChange,false);
            }
            this.m_Outfits = param1;
            if(this.m_Outfits)
            {
               this.m_Outfits.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onOutfitsChange,false,EventPriority.DEFAULT,true);
            }
            this.m_UncommittedOutfits = true;
            invalidateProperties();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set outfits(param1:IList) : void
      {
         var _loc2_:Object = this.outfits;
         if(_loc2_ !== param1)
         {
            this._1106424112outfits = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outfits",_loc2_,param1));
         }
      }
      
      private function set _1422498253addons(param1:int) : void
      {
         if(this.m_Addons != param1 || param1 == 0)
         {
            this.m_Addons = param1;
            this.m_UncommittedAddons = true;
            invalidateProperties();
         }
      }
      
      private function set _3575610type(param1:int) : void
      {
         var _loc2_:Boolean = false;
         if(this.m_Outfits == null || this.m_Outfits.length < 1)
         {
            param1 = 0;
            _loc2_ = true;
         }
         else if(this.getOutfitIndex(param1) < 0)
         {
            param1 = this.m_Outfits.getItemAt(0).ID;
            _loc2_ = true;
         }
         if(this.m_Type != param1 || _loc2_)
         {
            this.m_Type = param1;
            this.m_UncommittedType = true;
            invalidateProperties();
         }
      }
      
      public function get colours() : Vector.<int>
      {
         return this.m_Colours;
      }
      
      public function get noOutfitLabel() : String
      {
         return this.m_NoOutfitLabel;
      }
      
      public function get addons() : int
      {
         return this.m_Addons;
      }
      
      public function get type() : int
      {
         return this.m_Type;
      }
      
      private function set _949550119colours(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         if(param1 != null && param1.length == this.m_Colours.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_Colours.length)
            {
               this.m_Colours[_loc2_] = param1[_loc2_];
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_Colours.length)
            {
               this.m_Colours[_loc2_] = 0;
               _loc2_++;
            }
         }
         this.m_UncommittedColours = true;
         invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      public function set colours(param1:*) : void
      {
         var _loc2_:Object = this.colours;
         if(_loc2_ !== param1)
         {
            this._949550119colours = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colours",_loc2_,param1));
         }
      }
      
      public function get outfits() : IList
      {
         return this.m_Outfits;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedOutfits)
         {
            _loc1_ = this.m_Outfits != null && this.m_Outfits.length > 0;
            this.m_UIButtonPrev.enabled = _loc1_;
            this.m_UIButtonNext.enabled = _loc1_;
            this.m_UncommittedType = true;
            this.m_UncommittedOutfits = false;
         }
         if(this.m_UncommittedColours)
         {
            this.m_UncommittedType = true;
            this.m_UncommittedColours = false;
         }
         if(this.m_UncommittedAddons)
         {
            this.m_UncommittedType = true;
            this.m_UncommittedAddons = false;
         }
         if(this.m_UncommittedType)
         {
            _loc2_ = this.getOutfitIndex(this.m_Type);
            if(_loc2_ > -1)
            {
               this.m_UIAppearance.appearance = Tibia.s_GetAppearanceStorage().createOutfitInstance(this.m_Outfits.getItemAt(_loc2_).ID,this.m_Colours[0],this.m_Colours[1],this.m_Colours[2],this.m_Colours[3],this.m_Addons);
               this.m_UIAppearance.patternX = 2;
               this.m_UIAppearance.patternY = 0;
               this.m_UIAppearance.patternZ = 0;
               this.m_UIName.text = this.m_Outfits.getItemAt(_loc2_).name;
            }
            else
            {
               this.m_UIAppearance.appearance = null;
               this.m_UIName.text = this.m_NoOutfitLabel;
            }
            ShapeWrapper(this.m_UIAppearance.parent).invalidateSize();
            ShapeWrapper(this.m_UIAppearance.parent).invalidateDisplayList();
            this.m_UncommittedType = false;
         }
      }
      
      private function cycleOutfitType(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(this.m_Outfits != null && this.m_Outfits.length > 0)
         {
            _loc2_ = this.getOutfitIndex(this.m_Type);
            _loc3_ = this.m_Outfits.length;
            _loc2_ = _loc2_ + param1 % _loc3_;
            if(_loc2_ < 0)
            {
               _loc2_ = _loc2_ + _loc3_;
            }
            if(_loc2_ >= _loc3_)
            {
               _loc2_ = _loc2_ - _loc3_;
            }
            _loc4_ = this.m_Outfits.getItemAt(_loc2_);
            if(_loc4_ != null)
            {
               this.type = _loc4_.ID;
               this.addons = _loc4_.addons;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set addons(param1:int) : void
      {
         var _loc2_:Object = this.addons;
         if(_loc2_ !== param1)
         {
            this._1422498253addons = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"addons",_loc2_,param1));
         }
      }
      
      public function set noOutfitLabel(param1:String) : void
      {
         if(this.m_NoOutfitLabel != param1)
         {
            this.m_NoOutfitLabel = param1;
            this.m_UncommittedNoOutfitLabel = true;
            invalidateProperties();
         }
      }
      
      private function getOutfitIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this.m_Outfits != null)
         {
            _loc2_ = this.m_Outfits.length - 1;
            while(_loc2_ >= 0)
            {
               if(this.m_Outfits.getItemAt(_loc2_).ID == param1)
               {
                  return _loc2_;
               }
               _loc2_--;
            }
         }
         return -1;
      }
      
      [Bindable(event="propertyChange")]
      public function set type(param1:int) : void
      {
         var _loc2_:Object = this.type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
         }
      }
   }
}
