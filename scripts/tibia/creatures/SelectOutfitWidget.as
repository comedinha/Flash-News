package tibia.creatures
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.IList;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.events.PropertyChangeEvent;
   import shared.controls.SimpleTabNavigator;
   import tibia.creatures.selectOutfitWidgetClasses.OutfitColourSelector;
   import tibia.creatures.selectOutfitWidgetClasses.OutfitTypeSelector;
   import tibia.game.PopUpBase;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopProduct;
   import tibia.network.Communication;
   
   public class SelectOutfitWidget extends PopUpBase
   {
      
      private static const BUNDLE:String = "SelectOutfitWidget";
      
      private static const BODY_PARTS:Array = ["LABEL_COLOUR_HEAD","LABEL_COLOUR_PRIMARY","LABEL_COLOUR_SECONDARY","LABEL_COLOUR_DETAIL"];
       
      
      protected var m_UIPlayerColours:Vector.<OutfitColourSelector>;
      
      protected var m_MountType:int = -1;
      
      protected var m_UIMountOutfit:OutfitTypeSelector = null;
      
      protected var m_PlayerColours:Vector.<int>;
      
      private var m_UncommittedPlayerOutfits:Boolean = true;
      
      private var m_UncommittedPlayerAddons:Boolean = false;
      
      protected var m_PlayerAddons:int = 0;
      
      protected var m_UIOpenStoreMountsCategory:Button = null;
      
      private var m_UncommittedPlayerType:Boolean = false;
      
      private var m_UncommittedMountOutfits:Boolean = true;
      
      protected var m_MountOutfits:IList = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIPlayerAddons:Vector.<CheckBox>;
      
      protected var m_PlayerOutfits:IList = null;
      
      private var m_UncommittedMountType:Boolean = false;
      
      protected var m_UIPlayerBody:SimpleTabNavigator = null;
      
      protected var m_PlayerType:int = -1;
      
      protected var m_UIPlayerOutift:OutfitTypeSelector = null;
      
      private var m_UncommittedPlayerColours:Boolean = false;
      
      protected var m_UIOpenStoreOutfitsCategory:Button = null;
      
      public function SelectOutfitWidget()
      {
         this.m_PlayerColours = new Vector.<int>(4,true);
         this.m_UIPlayerColours = new Vector.<OutfitColourSelector>(4,true);
         this.m_UIPlayerAddons = new Vector.<CheckBox>(3,true);
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
      }
      
      protected function onPlayerAddonsChange(param1:Event) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc2_ = 0;
            _loc3_ = this.m_UIPlayerAddons.length - 1;
            while(_loc3_ >= 0)
            {
               if(this.m_UIPlayerAddons[_loc3_].enabled && this.m_UIPlayerAddons[_loc3_].selected)
               {
                  _loc2_ = _loc2_ | int(this.m_UIPlayerAddons[_loc3_].data);
               }
               _loc3_--;
            }
            this.playerAddons = _loc2_;
         }
      }
      
      public function get playerColours() : *
      {
         return this.m_PlayerColours;
      }
      
      public function set playerColours(... rest) : void
      {
         var _loc2_:int = 0;
         if(rest.length == this.m_PlayerColours.length)
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this.m_PlayerColours[_loc2_] = int(rest[_loc2_]);
               _loc2_++;
            }
         }
         else if(rest.length == 1 && rest[0] is Vector.<int> && Vector.<int>(rest[0]).length == this.m_PlayerColours.length)
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this.m_PlayerColours[_loc2_] = Vector.<int>(rest[0])[_loc2_];
               _loc2_++;
            }
         }
         else if(rest.length == 1 && rest[0] is Array && rest[0].length == this.m_PlayerColours.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_PlayerColours.length)
            {
               this.m_PlayerColours[_loc2_] = rest[0][_loc2_];
               _loc2_++;
            }
         }
         else
         {
            throw new ArgumentError("SelectOutfitWidget.setPlayerColours: Invalid overload.");
         }
         this.m_UncommittedPlayerColours = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedPlayerOutfits)
         {
            this.m_UIPlayerOutift.outfits = this.m_PlayerOutfits;
            this.m_UIPlayerOutift.type = this.m_PlayerType;
            this.updateCheckboxAddonsPlayer();
            this.m_UncommittedPlayerOutfits = false;
         }
         if(this.m_UncommittedPlayerType)
         {
            this.m_UIPlayerOutift.type = this.m_PlayerType;
            this.updateCheckboxAddonsPlayer();
            this.m_UncommittedPlayerType = false;
         }
         if(this.m_UncommittedPlayerAddons)
         {
            this.m_UIPlayerOutift.addons = this.m_PlayerAddons;
            this.updateCheckboxAddonsPlayer();
            this.m_UncommittedPlayerAddons = false;
         }
         if(this.m_UncommittedPlayerColours)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_PlayerColours.length)
            {
               if(this.m_UIPlayerColours[_loc1_] != null)
               {
                  this.m_UIPlayerColours[_loc1_].HSI = this.m_PlayerColours[_loc1_];
               }
               _loc1_++;
            }
            this.m_UIPlayerOutift.colours = this.m_PlayerColours;
            this.m_UncommittedPlayerColours = false;
         }
         if(this.m_UncommittedMountOutfits)
         {
            this.m_UIMountOutfit.enabled = this.m_MountOutfits != null && this.m_MountOutfits.length > 0;
            this.m_UIMountOutfit.outfits = this.m_MountOutfits;
            this.m_UIMountOutfit.type = this.m_MountType;
            this.m_UncommittedMountOutfits = false;
         }
         if(this.m_UncommittedMountType)
         {
            this.m_UIMountOutfit.type = this.m_MountType;
            this.m_UncommittedMountType = false;
         }
      }
      
      protected function onOpenStoreMountsCategoryClick(param1:MouseEvent) : void
      {
         IngameShopManager.getInstance().openShopWindow(true,IngameShopProduct.SERVICE_TYPE_MOUNTS);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:Canvas = null;
         var _loc3_:Canvas = null;
         var _loc4_:int = 0;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new HBox();
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc1_.setStyle("horizontalGap",2);
            _loc2_ = new Canvas();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 50;
            _loc3_ = new Canvas();
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 50;
            this.m_UIPlayerOutift = new OutfitTypeSelector();
            this.m_UIPlayerOutift.addons = this.m_PlayerAddons;
            this.m_UIPlayerOutift.colours = this.m_PlayerColours;
            this.m_UIPlayerOutift.noOutfitLabel = resourceManager.getString(BUNDLE,"LABEL_NO_OUTFIT");
            this.m_UIPlayerOutift.outfits = this.m_PlayerOutfits;
            this.m_UIPlayerOutift.percentHeight = NaN;
            this.m_UIPlayerOutift.percentWidth = 50;
            this.m_UIPlayerOutift.type = this.m_PlayerType;
            this.m_UIPlayerOutift.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerTypeChange);
            _loc2_.addChild(this.m_UIPlayerOutift);
            this.m_UIOpenStoreOutfitsCategory = new Button();
            this.m_UIOpenStoreOutfitsCategory.styleName = getStyle("outfitDialogOpenStoreButtonStyle");
            this.m_UIOpenStoreOutfitsCategory.setConstraintValue("right",2);
            this.m_UIOpenStoreOutfitsCategory.setConstraintValue("top",2);
            this.m_UIOpenStoreOutfitsCategory.addEventListener(MouseEvent.CLICK,this.onOpenStoreOutfitsCategoryClick);
            this.m_UIOpenStoreOutfitsCategory.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_STORE");
            _loc2_.addChild(this.m_UIOpenStoreOutfitsCategory);
            this.m_UIMountOutfit = new OutfitTypeSelector();
            this.m_UIMountOutfit.enabled = this.m_MountOutfits != null && this.m_MountOutfits.length > 0;
            this.m_UIMountOutfit.noOutfitLabel = resourceManager.getString(BUNDLE,"LABEL_NO_MOUNT");
            this.m_UIMountOutfit.outfits = this.m_MountOutfits;
            this.m_UIMountOutfit.percentHeight = NaN;
            this.m_UIMountOutfit.percentWidth = 50;
            this.m_UIMountOutfit.type = this.m_MountType;
            this.m_UIMountOutfit.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMountTypeChange);
            _loc3_.addChild(this.m_UIMountOutfit);
            this.m_UIOpenStoreMountsCategory = new Button();
            this.m_UIOpenStoreMountsCategory.styleName = getStyle("outfitDialogOpenStoreButtonStyle");
            this.m_UIOpenStoreMountsCategory.setConstraintValue("right",2);
            this.m_UIOpenStoreMountsCategory.setConstraintValue("top",2);
            this.m_UIOpenStoreMountsCategory.addEventListener(MouseEvent.CLICK,this.onOpenStoreMountsCategoryClick);
            this.m_UIOpenStoreMountsCategory.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_STORE");
            _loc3_.addChild(this.m_UIOpenStoreMountsCategory);
            _loc1_.addChild(_loc2_);
            _loc1_.addChild(_loc3_);
            addChild(_loc1_);
            _loc1_ = new HBox();
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc4_ = 0;
            while(_loc4_ < this.m_UIPlayerAddons.length)
            {
               this.m_UIPlayerAddons[_loc4_] = new CheckBox();
               this.m_UIPlayerAddons[_loc4_].data = 1 << _loc4_;
               this.m_UIPlayerAddons[_loc4_].label = resourceManager.getString(BUNDLE,"CHECK_OUTFIT_ADDON",[_loc4_ + 1]);
               this.m_UIPlayerAddons[_loc4_].percentHeight = NaN;
               this.m_UIPlayerAddons[_loc4_].percentWidth = 33;
               this.m_UIPlayerAddons[_loc4_].styleName = this;
               this.m_UIPlayerAddons[_loc4_].addEventListener(Event.CHANGE,this.onPlayerAddonsChange);
               _loc1_.addChild(this.m_UIPlayerAddons[_loc4_]);
               _loc4_++;
            }
            addChild(_loc1_);
            this.m_UIPlayerBody = new SimpleTabNavigator();
            this.m_UIPlayerBody.percentHeight = NaN;
            this.m_UIPlayerBody.percentWidth = 100;
            this.m_UIPlayerBody.styleName = "selectOutfitTabNavigator";
            _loc4_ = 0;
            while(_loc4_ < this.m_UIPlayerColours.length)
            {
               _loc1_ = new HBox();
               _loc1_.label = resourceManager.getString(BUNDLE,BODY_PARTS[_loc4_]);
               _loc1_.percentHeight = 100;
               _loc1_.percentWidth = 100;
               _loc1_.styleName = "selectOutfitTabContainer";
               this.m_UIPlayerColours[_loc4_] = new OutfitColourSelector();
               this.m_UIPlayerColours[_loc4_].HSI = this.m_PlayerColours[_loc4_];
               this.m_UIPlayerColours[_loc4_].addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerColoursChange);
               _loc1_.addChild(this.m_UIPlayerColours[_loc4_]);
               this.m_UIPlayerBody.addChild(_loc1_);
               _loc4_++;
            }
            addChild(this.m_UIPlayerBody);
            this.m_UIConstructed = true;
         }
      }
      
      protected function onMountTypeChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "type":
                  this.mountType = this.m_UIMountOutfit.type;
            }
         }
      }
      
      public function get playerOutfits() : IList
      {
         return this.m_PlayerOutfits;
      }
      
      public function get playerType() : int
      {
         return this.m_PlayerType;
      }
      
      protected function updateCheckboxAddonsPlayer() : void
      {
         var _loc5_:Object = null;
         var _loc1_:int = this.getOutfitIndex(this.m_PlayerOutfits,this.m_PlayerType);
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         if(_loc1_ > -1)
         {
            _loc5_ = this.m_PlayerOutfits.getItemAt(_loc1_);
            _loc2_ = _loc5_.addons;
            _loc3_ = this.m_PlayerAddons & _loc5_.addons;
         }
         var _loc4_:int = this.m_UIPlayerAddons.length - 1;
         while(_loc4_ >= 0)
         {
            this.m_UIPlayerAddons[_loc4_].enabled = (int(this.m_UIPlayerAddons[_loc4_].data) & _loc2_) != 0;
            this.m_UIPlayerAddons[_loc4_].selected = (int(this.m_UIPlayerAddons[_loc4_].data) & _loc3_) != 0;
            _loc4_--;
         }
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc2_:Communication = null;
         if(param1 && (_loc2_ = Tibia.s_GetCommunication()) != null)
         {
            _loc2_.sendCSETOUTFIT(this.m_PlayerType,this.m_PlayerColours[0],this.m_PlayerColours[1],this.m_PlayerColours[2],this.m_PlayerColours[3],this.m_PlayerAddons,this.m_MountType);
         }
         super.hide(param1);
      }
      
      protected function onPlayerTypeChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "type":
                  this.playerType = this.m_UIPlayerOutift.type;
                  break;
               case "addons":
                  this.playerAddons = this.m_UIPlayerOutift.addons;
            }
         }
      }
      
      public function set playerOutfits(param1:IList) : void
      {
         if(this.m_PlayerOutfits != param1)
         {
            this.m_PlayerOutfits = param1;
            this.m_UncommittedPlayerOutfits = true;
            invalidateProperties();
         }
      }
      
      public function set mountType(param1:int) : void
      {
         if(this.m_MountType != param1)
         {
            this.m_MountType = param1;
            this.m_UncommittedMountType = true;
            invalidateProperties();
         }
      }
      
      public function set playerAddons(param1:int) : void
      {
         if(this.m_PlayerAddons != param1)
         {
            this.m_PlayerAddons = param1;
            this.m_UncommittedPlayerAddons = true;
            invalidateProperties();
         }
      }
      
      public function set mountOutfits(param1:IList) : void
      {
         if(this.m_MountOutfits != param1)
         {
            this.m_MountOutfits = param1;
            this.m_UncommittedMountOutfits = true;
            invalidateProperties();
         }
      }
      
      private function getOutfitIndex(param1:IList, param2:int) : int
      {
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc3_ = param1.length - 1;
            while(_loc3_ >= 0)
            {
               if(param1.getItemAt(_loc3_).ID == param2)
               {
                  return _loc3_;
               }
               _loc3_--;
            }
         }
         return -1;
      }
      
      protected function onOpenStoreOutfitsCategoryClick(param1:MouseEvent) : void
      {
         IngameShopManager.getInstance().openShopWindow(true,IngameShopProduct.SERVICE_TYPE_OUTFITS);
      }
      
      public function get mountType() : int
      {
         return this.m_MountType;
      }
      
      public function get playerAddons() : int
      {
         return this.m_PlayerAddons;
      }
      
      public function set playerType(param1:int) : void
      {
         if(this.m_PlayerType != param1)
         {
            this.m_PlayerType = param1;
            this.m_UncommittedPlayerType = true;
            invalidateProperties();
         }
      }
      
      public function get mountOutfits() : IList
      {
         return this.m_MountOutfits;
      }
      
      protected function onPlayerColoursChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "HSI":
                  _loc2_ = this.m_UIPlayerBody.selectedIndex;
                  this.m_PlayerColours[_loc2_] = this.m_UIPlayerColours[_loc2_].HSI;
                  this.m_UncommittedPlayerColours = true;
                  invalidateProperties();
            }
         }
      }
   }
}
