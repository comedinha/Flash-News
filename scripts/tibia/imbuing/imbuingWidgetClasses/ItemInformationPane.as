package tibia.imbuing.imbuingWidgetClasses
{
   import flash.events.MouseEvent;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import shared.controls.ShapeWrapper;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   import tibia.game.ExtendedTooltipEvent;
   import tibia.imbuing.ImbuingEvent;
   
   public class ItemInformationPane extends HBox
   {
      
      private static const BUNDLE:String = "ImbuingWidget";
       
      
      private var m_UncommittedImbuementSlotMouseAction:Boolean = false;
      
      private var m_AppearanceTypeID:uint = 0;
      
      private var m_ImbuingSlotImages:Vector.<int>;
      
      private var m_UncommittedImbuingImages:Boolean = false;
      
      private var m_UIImbuingItemAppearance:SimpleAppearanceRenderer = null;
      
      private var m_TooltipText:String = "";
      
      private var m_ImbuementSlots:Vector.<ImbuementSlotWidget>;
      
      private var m_SelectedExistingImbuementIndex:int = -1;
      
      private var m_CurrentlyHoveredImbuementSlotIndex:int = -1;
      
      private var m_UncommittedType:Boolean = false;
      
      public function ItemInformationPane()
      {
         this.m_ImbuingSlotImages = new Vector.<int>();
         this.m_ImbuementSlots = new Vector.<ImbuementSlotWidget>();
         super();
      }
      
      public function get imbuingSlotImages() : Vector.<int>
      {
         return this.m_ImbuingSlotImages;
      }
      
      private function onImbuementSlotMouseEvent(param1:MouseEvent) : void
      {
         var _loc5_:ImbuingEvent = null;
         var _loc2_:ImbuementSlotWidget = null;
         var _loc3_:int = -1;
         var _loc4_:uint = 0;
         while(_loc4_ < this.m_ImbuementSlots.length)
         {
            if(this.m_ImbuementSlots[_loc4_] == param1.currentTarget)
            {
               _loc3_ = _loc4_;
               _loc2_ = this.m_ImbuementSlots[_loc4_];
               break;
            }
            _loc4_++;
         }
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            if(_loc3_ < this.m_ImbuingSlotImages.length)
            {
               this.m_CurrentlyHoveredImbuementSlotIndex = _loc3_;
               this.m_UncommittedImbuementSlotMouseAction = true;
               invalidateProperties();
               this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_IMBUING_SLOT_AVAILABLE"));
            }
            else
            {
               this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_IMBUING_SLOT_LOCKED"));
            }
         }
         else if(param1.type == MouseEvent.MOUSE_OUT)
         {
            if(this.m_CurrentlyHoveredImbuementSlotIndex == _loc3_)
            {
               this.m_CurrentlyHoveredImbuementSlotIndex = -1;
               this.m_UncommittedImbuementSlotMouseAction = true;
               invalidateProperties();
            }
            this.sendTooltipEvent(null);
         }
         else if(param1.type == MouseEvent.CLICK)
         {
            if(_loc3_ < this.m_ImbuingSlotImages.length && this.m_SelectedExistingImbuementIndex != _loc3_)
            {
               this.m_SelectedExistingImbuementIndex = _loc3_;
               this.m_UncommittedImbuementSlotMouseAction = true;
               invalidateProperties();
               _loc5_ = new ImbuingEvent(ImbuingEvent.IMBUEMENT_SLOT_SELECTED);
               dispatchEvent(_loc5_);
            }
         }
      }
      
      public function set imbuingSlotImages(param1:Vector.<int>) : void
      {
         if(param1 != this.m_ImbuingSlotImages)
         {
            this.m_ImbuingSlotImages = param1;
            this.m_UncommittedImbuingImages = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:uint = 0;
         if(this.m_UncommittedType)
         {
            this.m_UIImbuingItemAppearance.appearance = Tibia.s_GetAppearanceStorage().createObjectInstance(this.m_AppearanceTypeID,0);
            ShapeWrapper(this.m_UIImbuingItemAppearance.parent).invalidateSize();
            ShapeWrapper(this.m_UIImbuingItemAppearance.parent).invalidateDisplayList();
            this.m_UncommittedType = false;
         }
         if(this.m_UncommittedImbuingImages)
         {
            this.m_UncommittedImbuingImages = false;
            _loc1_ = 0;
            while(_loc1_ < this.m_ImbuementSlots.length)
            {
               if(_loc1_ < this.m_ImbuingSlotImages.length)
               {
                  this.m_ImbuementSlots[_loc1_].imbuingImage = this.m_ImbuingSlotImages[_loc1_];
               }
               else
               {
                  this.m_ImbuementSlots[_loc1_].disabled = true;
               }
               _loc1_++;
            }
         }
         if(this.m_UncommittedImbuementSlotMouseAction)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_ImbuementSlots.length)
            {
               if(_loc1_ == this.m_SelectedExistingImbuementIndex)
               {
                  this.m_ImbuementSlots[this.m_SelectedExistingImbuementIndex].borderStyle = ImbuementSlotWidget.BORDER_STYLE_SELECTED;
               }
               else if(_loc1_ == this.m_CurrentlyHoveredImbuementSlotIndex)
               {
                  this.m_ImbuementSlots[this.m_CurrentlyHoveredImbuementSlotIndex].borderStyle = ImbuementSlotWidget.BORDER_STYLE_HOVER;
               }
               else
               {
                  this.m_ImbuementSlots[_loc1_].borderStyle = ImbuementSlotWidget.BORDER_STYLE_NONE;
               }
               _loc1_++;
            }
            this.m_UncommittedImbuementSlotMouseAction = false;
         }
      }
      
      public function get selectedImbuingSlot() : int
      {
         return this.m_SelectedExistingImbuementIndex;
      }
      
      public function get tooltipText() : String
      {
         return this.m_TooltipText;
      }
      
      public function get apperanceTypeID() : uint
      {
         return this.m_AppearanceTypeID;
      }
      
      override protected function createChildren() : void
      {
         var _loc9_:ImbuementSlotWidget = null;
         super.createChildren();
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         var _loc2_:Label = new Label();
         _loc2_.text = resourceManager.getString(BUNDLE,"LBL_ITEM_INFORMATION");
         _loc1_.addChild(_loc2_);
         var _loc3_:HBox = new HBox();
         _loc3_.percentWidth = 100;
         var _loc4_:ShapeWrapper = new ShapeWrapper();
         this.m_UIImbuingItemAppearance = new SimpleAppearanceRenderer();
         this.m_UIImbuingItemAppearance.scale = 2;
         _loc4_.addChild(this.m_UIImbuingItemAppearance);
         var _loc5_:HBox = new HBox();
         var _loc6_:Label = new Label();
         _loc6_.text = resourceManager.getString(BUNDLE,"LBL_SLOTS_INFORMATION");
         _loc5_.addChild(_loc6_);
         var _loc7_:uint = 0;
         while(_loc7_ < 3)
         {
            _loc9_ = new ImbuementSlotWidget();
            _loc5_.addChild(_loc9_);
            _loc9_.addEventListener(MouseEvent.MOUSE_OVER,this.onImbuementSlotMouseEvent);
            _loc9_.addEventListener(MouseEvent.MOUSE_OUT,this.onImbuementSlotMouseEvent);
            _loc9_.addEventListener(MouseEvent.CLICK,this.onImbuementSlotMouseEvent);
            this.m_ImbuementSlots.push(_loc9_);
            _loc7_++;
         }
         this.m_ImbuementSlots[0].selected = true;
         _loc3_.addChild(_loc4_);
         var _loc8_:Spacer = new Spacer();
         _loc8_.percentWidth = 100;
         _loc3_.addChild(_loc8_);
         _loc3_.addChild(_loc5_);
         _loc1_.addChild(_loc3_);
         addChild(_loc1_);
         _loc2_.styleName = "headerLabel";
         _loc3_.styleName = "itemAndSlotBox";
         _loc5_.styleName = "slotsBox";
         this.styleName = "sectionBorder";
      }
      
      public function set selectedImbuingSlot(param1:int) : void
      {
         this.m_SelectedExistingImbuementIndex = param1;
         this.m_UncommittedImbuementSlotMouseAction = true;
         invalidateProperties();
      }
      
      public function dispose() : void
      {
         var _loc1_:ImbuementSlotWidget = null;
         for each(_loc1_ in this.m_ImbuementSlots)
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.onImbuementSlotMouseEvent);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.onImbuementSlotMouseEvent);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onImbuementSlotMouseEvent);
         }
      }
      
      public function set apperanceTypeID(param1:uint) : void
      {
         if(param1 != this.m_AppearanceTypeID)
         {
            this.m_AppearanceTypeID = param1;
            this.m_UncommittedType = true;
            invalidateProperties();
         }
      }
      
      public function sendTooltipEvent(param1:String) : void
      {
         var _loc2_:ExtendedTooltipEvent = null;
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = new ExtendedTooltipEvent(ExtendedTooltipEvent.SHOW,true,false,param1);
            dispatchEvent(_loc2_);
         }
         else
         {
            _loc2_ = new ExtendedTooltipEvent(ExtendedTooltipEvent.HIDE);
            dispatchEvent(_loc2_);
         }
      }
   }
}
