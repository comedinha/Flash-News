package tibia.market.marketWidgetClasses
{
   import flash.events.Event;
   import mx.collections.ArrayCollection;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.ComboBox;
   import mx.core.ClassFactory;
   import mx.core.EventPriority;
   import mx.events.DropdownEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import shared.controls.CustomButton;
   import shared.controls.CustomList;
   import shared.utility.ArrayHelper;
   import shared.utility.closure;
   import tibia.appearances.AppearanceType;
   import tibia.container.BodyContainerView;
   import tibia.creatures.Player;
   import tibia.market.MarketWidget;
   import tibia.options.OptionsStorage;
   
   class AppearanceTypeCategoryFilterEditor extends VBox implements IAppearanceTypeFilterEditor
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_UIWeaponCategory:ComboBox = null;
      
      private var m_UIProfession:Button = null;
      
      private var m_Level:Boolean = false;
      
      private var m_UIPrimaryCategory:ComboBox = null;
      
      private var m_UncommittedBodyPosition:Boolean = true;
      
      private var m_BodyPosition:int = -1;
      
      private var m_FilterFunction:Function = null;
      
      private var m_UncommittedProfession:Boolean = true;
      
      private var m_Profession:Boolean = false;
      
      private var m_UncommittedCategory:Boolean = true;
      
      private var m_Category:int = 2;
      
      private var m_UIBodyPosition:ComboBox = null;
      
      private var m_UncommittedLevel:Boolean = true;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UILevel:Button = null;
      
      function AppearanceTypeCategoryFilterEditor()
      {
         super();
         label = resourceManager.getString(BUNDLE,"CATEGORY_FILTER_EDITOR_LABEL");
         var _loc1_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc1_ != null)
         {
            this.filterCategory = _loc1_.marketBrowserCategory;
            this.filterLevel = _loc1_.marketBrowserLevel;
            this.filterProfession = _loc1_.marketBrowserProfession;
            this.filterBodyPosition = _loc1_.marketBrowserBodyPosition;
         }
         var _loc2_:Player = Tibia.s_GetPlayer();
         if(_loc2_ != null)
         {
            _loc2_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange,false,EventPriority.DEFAULT,true);
         }
      }
      
      private function get filterBodyPosition() : int
      {
         return this.m_BodyPosition;
      }
      
      private function set filterBodyPosition(param1:int) : void
      {
         if(param1 != BodyContainerView.BOTH_HANDS && param1 != BodyContainerView.LEFT_HAND)
         {
            param1 = -1;
         }
         if(this.m_BodyPosition != param1)
         {
            this.m_BodyPosition = param1;
            this.m_UncommittedBodyPosition = true;
            this.invalidateFilterFunction();
            invalidateProperties();
         }
      }
      
      private function onCategoryCange(param1:Event) : void
      {
         var _loc2_:ComboBox = null;
         if(param1 != null && (_loc2_ = param1.currentTarget as ComboBox) != null && _loc2_.enabled)
         {
            switch(_loc2_)
            {
               case this.m_UIPrimaryCategory:
                  if(this.m_UIPrimaryCategory.selectedItem.value != MarketWidget.CATEGORY_META_WEAPONS)
                  {
                     this.filterCategory = this.m_UIPrimaryCategory.selectedItem.value;
                  }
                  else
                  {
                     this.filterBodyPosition = -1;
                     this.filterCategory = this.m_UIWeaponCategory.selectedItem.value;
                  }
                  break;
               case this.m_UIWeaponCategory:
                  this.filterCategory = this.m_UIWeaponCategory.selectedItem.value;
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:OptionsStorage = Tibia.s_GetOptions();
         if(this.m_UncommittedCategory)
         {
            if(_loc1_ != null)
            {
               _loc1_.marketBrowserCategory = this.filterCategory;
            }
            if(this.filterCategory == MarketWidget.CATEGORY_AMMUNITION || this.filterCategory == MarketWidget.CATEGORY_AXES || this.filterCategory == MarketWidget.CATEGORY_CLUBS || this.filterCategory == MarketWidget.CATEGORY_DISTANCE_WEAPONS || this.filterCategory == MarketWidget.CATEGORY_SWORDS || this.filterCategory == MarketWidget.CATEGORY_WANDS_RODS)
            {
               this.m_UIPrimaryCategory.selectedIndex = this.getValueIndex(this.m_UIPrimaryCategory,MarketWidget.CATEGORY_META_WEAPONS);
               this.m_UIWeaponCategory.enabled = true;
               this.m_UIWeaponCategory.selectedIndex = this.getValueIndex(this.m_UIWeaponCategory,this.filterCategory);
               this.m_UIBodyPosition.enabled = this.filterCategory != MarketWidget.CATEGORY_AMMUNITION;
            }
            else
            {
               this.m_UIPrimaryCategory.selectedIndex = this.getValueIndex(this.m_UIPrimaryCategory,this.filterCategory);
               this.m_UIWeaponCategory.enabled = false;
               this.m_UIWeaponCategory.selectedIndex = 0;
               this.m_UIBodyPosition.enabled = false;
            }
            this.m_UncommittedCategory = false;
         }
         if(this.m_UncommittedLevel)
         {
            if(_loc1_ != null)
            {
               _loc1_.marketBrowserLevel = this.filterLevel;
            }
            this.m_UILevel.selected = this.filterLevel;
            this.m_UncommittedLevel = false;
         }
         if(this.m_UncommittedProfession)
         {
            if(_loc1_ != null)
            {
               _loc1_.marketBrowserProfession = this.filterProfession;
            }
            this.m_UIProfession.selected = this.filterProfession;
            this.m_UncommittedProfession = false;
         }
         if(this.m_UncommittedBodyPosition)
         {
            if(_loc1_ != null)
            {
               _loc1_.marketBrowserBodyPosition = this.filterBodyPosition;
            }
            this.m_UIBodyPosition.selectedIndex = this.getValueIndex(this.m_UIBodyPosition,this.filterBodyPosition);
            this.m_UncommittedBodyPosition = false;
         }
      }
      
      private function onBodyPositionChange(param1:Event) : void
      {
         var _loc2_:ComboBox = null;
         if(param1 != null && (_loc2_ = param1.currentTarget as ComboBox) != null && _loc2_.enabled)
         {
            this.filterBodyPosition = _loc2_.selectedItem.value;
         }
      }
      
      public function invalidateFilterFunction() : void
      {
         this.m_FilterFunction = null;
         dispatchEvent(new Event(AppearanceTypeBrowser.FILTER_CHANGE));
      }
      
      private function get filterProfession() : Boolean
      {
         return this.m_Profession;
      }
      
      private function get filterCategory() : int
      {
         return this.m_Category;
      }
      
      private function getValueIndex(param1:ComboBox, param2:int) : int
      {
         var _loc3_:ArrayCollection = null;
         if(param1 != null)
         {
            _loc3_ = param1.dataProvider as ArrayCollection;
            if(_loc3_ != null)
            {
               return ArrayHelper.s_IndexOf(_loc3_.source,"value",param2);
            }
         }
         return -1;
      }
      
      private function set filterLevel(param1:Boolean) : void
      {
         if(this.m_Level != param1)
         {
            this.m_Level = param1;
            this.m_UncommittedLevel = true;
            this.invalidateFilterFunction();
            invalidateProperties();
         }
      }
      
      override protected function createChildren() : void
      {
         var _Box:HBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIPrimaryCategory = new ComboBox();
            this.m_UIPrimaryCategory.dataProvider = [{
               "value":MarketWidget.CATEGORY_AMULETS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_AMULETS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_ARMORS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_ARMORS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_BOOTS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_BOOTS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_CONTAINERS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_CONTAINERS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_DECORATION,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_DECORATION_LABEL")
            },{
               "value":MarketWidget.CATEGORY_FOOD,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_FOOD_LABEL")
            },{
               "value":MarketWidget.CATEGORY_HELMETS_HATS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_HELMETS_HATS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_LEGS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_LEGS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_OTHERS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_OTHERS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_POTIONS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_POTIONS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_RINGS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_RINGS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_RUNES,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_RUNES_LABEL")
            },{
               "value":MarketWidget.CATEGORY_SHIELDS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_SHIELDS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_TIBIA_COINS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_TIBIA_COINS")
            },{
               "value":MarketWidget.CATEGORY_TOOLS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_TOOLS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_VALUABLES,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_VALUABLES_LABEL")
            },{
               "value":MarketWidget.CATEGORY_META_WEAPONS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_META_WEAPONS_LABEL")
            }];
            this.m_UIPrimaryCategory.dropdownFactory = new ClassFactory(CustomList);
            this.m_UIPrimaryCategory.labelField = "label";
            this.m_UIPrimaryCategory.percentHeight = NaN;
            this.m_UIPrimaryCategory.percentWidth = 100;
            this.m_UIPrimaryCategory.addEventListener(DropdownEvent.CLOSE,this.onCategoryCange);
            this.m_UIPrimaryCategory.addEventListener(ListEvent.CHANGE,this.onCategoryCange);
            addChild(this.m_UIPrimaryCategory);
            this.m_UIWeaponCategory = new ComboBox();
            this.m_UIWeaponCategory.dataProvider = [{
               "value":MarketWidget.CATEGORY_AMMUNITION,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_AMMUNITION_LABEL")
            },{
               "value":MarketWidget.CATEGORY_AXES,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_AXES_LABEL")
            },{
               "value":MarketWidget.CATEGORY_CLUBS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_CLUBS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_DISTANCE_WEAPONS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_DISTANCE_WEAPONS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_SWORDS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_SWORDS_LABEL")
            },{
               "value":MarketWidget.CATEGORY_WANDS_RODS,
               "label":resourceManager.getString(BUNDLE,"CATEGORY_WANDS_RODS_LABEL")
            }];
            this.m_UIWeaponCategory.dropdownFactory = new ClassFactory(CustomList);
            this.m_UIWeaponCategory.enabled = false;
            this.m_UIWeaponCategory.labelField = "label";
            this.m_UIWeaponCategory.percentHeight = NaN;
            this.m_UIWeaponCategory.percentWidth = 100;
            this.m_UIWeaponCategory.addEventListener(DropdownEvent.CLOSE,this.onCategoryCange);
            this.m_UIWeaponCategory.addEventListener(ListEvent.CHANGE,this.onCategoryCange);
            addChild(this.m_UIWeaponCategory);
            _Box = new HBox();
            _Box.percentHeight = NaN;
            _Box.percentWidth = 100;
            _Box.setStyle("horizontalAlign","center");
            _Box.setStyle("horizontalGap",1);
            _Box.setStyle("verticalAlign","middle");
            this.m_UILevel = new CustomButton();
            this.m_UILevel.label = resourceManager.getString(BUNDLE,"RESTRICT_LEVEL_LABEL");
            this.m_UILevel.toggle = true;
            this.m_UILevel.toolTip = resourceManager.getString(BUNDLE,"RESTRICT_LEVEL_TOOLTIP");
            this.m_UILevel.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               filterLevel = m_UILevel.selected;
            });
            this.m_UILevel.setStyle("fontSize",9);
            this.m_UILevel.setStyle("paddingLeft",0);
            this.m_UILevel.setStyle("paddingRight",0);
            this.m_UILevel.percentWidth = 50;
            _Box.addChild(this.m_UILevel);
            this.m_UIProfession = new CustomButton();
            this.m_UIProfession.label = resourceManager.getString(BUNDLE,"RESTRICT_PROFESSION_LABEL");
            this.m_UIProfession.toggle = true;
            this.m_UIProfession.toolTip = resourceManager.getString(BUNDLE,"RESTRICT_PROFESSION_TOOLTIP");
            this.m_UIProfession.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               filterProfession = m_UIProfession.selected;
            });
            this.m_UIProfession.setStyle("fontSize",9);
            this.m_UIProfession.setStyle("paddingLeft",0);
            this.m_UIProfession.setStyle("paddingRight",0);
            this.m_UIProfession.percentWidth = 50;
            _Box.addChild(this.m_UIProfession);
            this.m_UIBodyPosition = new ComboBox();
            this.m_UIBodyPosition.dataProvider = [{
               "value":-1,
               "label":resourceManager.getString(BUNDLE,"RESTRICT_ANY_HAND_LABEL")
            },{
               "value":BodyContainerView.LEFT_HAND,
               "label":resourceManager.getString(BUNDLE,"RESTRICT_ONE_HANDED_LABEL")
            },{
               "value":BodyContainerView.BOTH_HANDS,
               "label":resourceManager.getString(BUNDLE,"RESTRICT_TWO_HANDED_LABEL")
            }];
            this.m_UIBodyPosition.dropdownFactory = new ClassFactory(CustomList);
            this.m_UIBodyPosition.enabled = false;
            this.m_UIBodyPosition.labelField = "label";
            this.m_UIBodyPosition.addEventListener(DropdownEvent.CLOSE,this.onBodyPositionChange);
            this.m_UIBodyPosition.addEventListener(ListEvent.CHANGE,this.onBodyPositionChange);
            this.m_UIBodyPosition.setStyle("fontSize",9);
            this.m_UIBodyPosition.setStyle("paddingLeft",0);
            this.m_UIBodyPosition.setStyle("paddingRight",0);
            _Box.addChild(this.m_UIBodyPosition);
            addChild(_Box);
            this.m_UIConstructed = true;
         }
      }
      
      public function adjustFilterFunction(param1:AppearanceType) : void
      {
         if(param1 == null || !param1.isMarket)
         {
            return;
         }
         this.filterCategory = param1.marketCategory;
         var _loc2_:Player = Tibia.s_GetPlayer();
         if(_loc2_ != null)
         {
            this.filterLevel = this.filterLevel && _loc2_.level >= param1.marketRestrictLevel;
            this.filterProfession = this.filterProfession && (1 << _loc2_.profession & param1.marketRestrictProfession) != 0;
         }
         else
         {
            this.filterLevel = false;
            this.filterProfession = false;
         }
         if(param1.marketCategory == MarketWidget.CATEGORY_AXES || param1.marketCategory == MarketWidget.CATEGORY_CLUBS || param1.marketCategory == MarketWidget.CATEGORY_DISTANCE_WEAPONS || param1.marketCategory == MarketWidget.CATEGORY_SWORDS || param1.marketCategory == MarketWidget.CATEGORY_WANDS_RODS)
         {
            this.filterBodyPosition = param1.clothSlot;
         }
         else
         {
            this.filterBodyPosition = -1;
         }
      }
      
      private function set filterProfession(param1:Boolean) : void
      {
         if(this.m_Profession != param1)
         {
            this.m_Profession = param1;
            this.m_UncommittedProfession = true;
            this.invalidateFilterFunction();
            invalidateProperties();
         }
      }
      
      private function set filterCategory(param1:int) : void
      {
         if(!MarketWidget.isValidCategoryID(param1))
         {
            param1 = MarketWidget.CATEGORY_AMULETS;
         }
         if(this.m_Category != param1)
         {
            this.m_Category = param1;
            this.m_UncommittedCategory = true;
            this.invalidateFilterFunction();
            invalidateProperties();
            if(this.m_Category != MarketWidget.CATEGORY_AXES && this.m_Category != MarketWidget.CATEGORY_CLUBS && this.m_Category != MarketWidget.CATEGORY_DISTANCE_WEAPONS && this.m_Category != MarketWidget.CATEGORY_SWORDS && this.m_Category != MarketWidget.CATEGORY_WANDS_RODS)
            {
               this.filterBodyPosition = -1;
            }
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "level":
               case "profession":
               case "*":
                  this.invalidateFilterFunction();
            }
         }
      }
      
      private function get filterLevel() : Boolean
      {
         return this.m_Level;
      }
      
      public function get filterFunction() : Function
      {
         var Level:int = 0;
         var Profession:int = 0;
         var _Player:Player = null;
         if(this.m_FilterFunction == null)
         {
            Level = -1;
            Profession = -1;
            _Player = Tibia.s_GetPlayer();
            if(_Player != null)
            {
               if(this.filterLevel)
               {
                  Level = _Player.level;
               }
               if(this.filterProfession)
               {
                  Profession = 1 << _Player.profession;
               }
            }
            this.m_FilterFunction = closure({
               "category":this.filterCategory,
               "level":Level,
               "profession":Profession,
               "bodyPosition":this.filterBodyPosition
            },function(param1:AppearanceType):Boolean
            {
               return param1 != null && param1.isMarket && (this["category"] < 0 || this["category"] == param1.marketCategory) && (this["level"] < 0 || this["level"] >= param1.marketRestrictLevel) && (this["profession"] < 0 || param1.marketRestrictProfession == 0 || (this["profession"] & param1.marketRestrictProfession) != 0) && (this["bodyPosition"] < 0 || this["bodyPosition"] == param1.clothSlot);
            });
         }
         return this.m_FilterFunction;
      }
   }
}
