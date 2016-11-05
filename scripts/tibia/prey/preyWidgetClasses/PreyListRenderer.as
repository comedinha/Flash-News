package tibia.prey.preyWidgetClasses
{
   import mx.containers.HBox;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import mx.controls.Image;
   import tibia.prey.PreyData;
   import shared.controls.ShapeWrapper;
   import mx.containers.VBox;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   import mx.controls.Label;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   import tibia.creatures.statusWidgetClasses.BitmapProgressBar;
   import shared.utility.StringHelper;
   import mx.containers.Box;
   import mx.events.PropertyChangeEvent;
   
   public class PreyListRenderer extends HBox implements IListItemRenderer, IDataRenderer
   {
      
      private static const BUNDLE:String = "PreyWidget";
      
      private static const PREY_NO_BONUS_CLASS:Class = PreyListRenderer_PREY_NO_BONUS_CLASS;
      
      private static const PREY_DAMAGE_REDUCTION_CLASS:Class = PreyListRenderer_PREY_DAMAGE_REDUCTION_CLASS;
      
      public static const PREY_IMPROVED_LOOT:BitmapData = Bitmap(new PREY_IMPROVED_LOOT_CLASS()).bitmapData;
      
      private static const PREY_NO_PREY_CLASS:Class = PreyListRenderer_PREY_NO_PREY_CLASS;
      
      public static const PREY_DAMAGE_BOOST:BitmapData = Bitmap(new PREY_DAMAGE_BOOST_CLASS()).bitmapData;
      
      public static const HEIGHT_HINT:int = 32;
      
      public static const MONSTER_SIZE:int = 32;
      
      public static const PREY_IMPROVED_XP:BitmapData = Bitmap(new PREY_IMPROVED_XP_CLASS()).bitmapData;
      
      private static const PREY_IMPROVED_LOOT_CLASS:Class = PreyListRenderer_PREY_IMPROVED_LOOT_CLASS;
      
      public static const PREY_DAMAGE_REDUCTION:BitmapData = Bitmap(new PREY_DAMAGE_REDUCTION_CLASS()).bitmapData;
      
      public static const PREY_NO_BONUS:BitmapData = Bitmap(new PREY_NO_BONUS_CLASS()).bitmapData;
      
      public static const PREY_NO_PREY:BitmapData = Bitmap(new PREY_NO_PREY_CLASS()).bitmapData;
      
      private static const PREY_DAMAGE_BOOST_CLASS:Class = PreyListRenderer_PREY_DAMAGE_BOOST_CLASS;
      
      private static const PREY_IMPROVED_XP_CLASS:Class = PreyListRenderer_PREY_IMPROVED_XP_CLASS;
       
      
      private var m_UIBonusImage:Image = null;
      
      private var m_UncommittedPrey:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UINoMonster:Image = null;
      
      private var m_UIMonsterDisplay:SimpleAppearanceRenderer = null;
      
      private var m_UIProgress:BitmapProgressBar = null;
      
      private var m_UIMonsterName:Label = null;
      
      public function PreyListRenderer()
      {
         super();
         minHeight = HEIGHT_HINT;
         setStyle("verticalAlign","middle");
         setStyle("horizontalGap",2);
      }
      
      private function getBonusTypeBitmapData(param1:uint) : BitmapData
      {
         if(param1 == PreyData.BONUS_DAMAGE_BOOST)
         {
            return PREY_DAMAGE_BOOST;
         }
         if(param1 == PreyData.BONUS_DAMAGE_REDUCTION)
         {
            return PREY_DAMAGE_REDUCTION;
         }
         if(param1 == PreyData.BONUS_IMPROVED_LOOT)
         {
            return PREY_IMPROVED_LOOT;
         }
         if(param1 == PreyData.BONUS_XP_BONUS)
         {
            return PREY_IMPROVED_XP;
         }
         return PREY_NO_BONUS;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:ShapeWrapper = null;
         var _loc2_:VBox = null;
         super.createChildren();
         if(!this.m_UIConstructed)
         {
            this.m_UIMonsterDisplay = new SimpleAppearanceRenderer();
            this.m_UIMonsterDisplay.scale = 0.5;
            _loc1_ = new ShapeWrapper();
            _loc1_.explicitWidth = MONSTER_SIZE;
            _loc1_.explicitHeight = MONSTER_SIZE;
            _loc1_.setStyle("horizontalAlign","right");
            _loc1_.setStyle("verticalAlign","bottom");
            _loc1_.addChild(this.m_UIMonsterDisplay);
            addChild(_loc1_);
            this.m_UINoMonster = new Image();
            this.m_UINoMonster.addChild(new Bitmap(PREY_NO_PREY));
            this.m_UINoMonster.width = MONSTER_SIZE;
            this.m_UINoMonster.height = PREY_NO_PREY.height;
            this.m_UIBonusImage = new Image();
            addChild(this.m_UIBonusImage);
            _loc2_ = new VBox();
            _loc2_.percentWidth = 100;
            _loc2_.setStyle("verticalGap",0);
            addChild(_loc2_);
            this.m_UIMonsterName = new Label();
            this.m_UIMonsterName.setStyle("fontSize",11);
            this.m_UIMonsterName.setStyle("fontWeight","bold");
            this.m_UIMonsterName.width = 125;
            this.m_UIMonsterName.truncateToFit = true;
            this.m_UIMonsterName.filters = [new GlowFilter(0,1,2,2,4,BitmapFilterQuality.LOW,false,false)];
            _loc2_.addChild(this.m_UIMonsterName);
            this.m_UIProgress = new BitmapProgressBar();
            this.m_UIProgress.width = this.m_UIMonsterName.width;
            this.m_UIProgress.styleName = "preyDurationProgressSidebar";
            this.m_UIProgress.minValue = 0;
            this.m_UIProgress.maxValue = PreyData.PREY_FULL_DURATION;
            _loc2_.addChild(this.m_UIProgress);
            this.m_UIConstructed = true;
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:PreyData = null;
         var _loc2_:BitmapData = null;
         super.commitProperties();
         if(this.m_UncommittedPrey)
         {
            _loc1_ = data as PreyData;
            if(_loc1_ != null)
            {
               visible = includeInLayout = _loc1_.state != PreyData.STATE_LOCKED;
               removeChildAt(0);
               if(_loc1_.state == PreyData.STATE_ACTIVE)
               {
                  addChildAt(this.m_UIMonsterDisplay.parent,0);
               }
               else
               {
                  addChildAt(this.m_UINoMonster,0);
               }
               if(_loc1_.monster != null)
               {
                  this.m_UIMonsterDisplay.appearance = _loc1_.monster.monsterAppearanceInstance;
                  this.m_UIMonsterDisplay.patternX = 2;
                  this.m_UIMonsterDisplay.patternY = 0;
                  this.m_UIMonsterDisplay.patternZ = 0;
                  (this.m_UIMonsterDisplay.parent as ShapeWrapper).invalidateSize();
                  (this.m_UIMonsterDisplay.parent as ShapeWrapper).invalidateDisplayList();
                  this.m_UIMonsterName.text = _loc1_.monster.monsterName;
               }
               else
               {
                  this.m_UIMonsterName.text = resourceManager.getString(BUNDLE,"PREY_INACTIVE");
               }
               this.m_UIBonusImage.removeChildren();
               _loc2_ = this.getBonusTypeBitmapData(_loc1_.bonusType);
               this.m_UIBonusImage.addChild(new Bitmap(_loc2_));
               this.m_UIBonusImage.width = _loc2_.width;
               this.m_UIBonusImage.height = _loc2_.height;
               if(_loc1_.state == PreyData.STATE_ACTIVE)
               {
                  toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_PREY_ACTIVE",[_loc1_.monster.monsterName,StringHelper.s_MillisecondsToTimeString(_loc1_.preyTimeLeft * 60 * 1000,false).slice(0,-3),_loc1_.bonusValue,_loc1_.generateBonusString(),_loc1_.generateBonusDescription()]);
               }
               else
               {
                  toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_PREY_INACTIVE");
               }
               this.m_UIProgress.value = _loc1_.preyTimeLeft;
            }
            else
            {
               visible = includeInLayout = false;
            }
            (parent as Box).invalidateDisplayList();
            (parent as Box).invalidateSize();
            this.m_UncommittedPrey = false;
         }
      }
      
      override public function set data(param1:Object) : void
      {
         if(data != null)
         {
            (data as PreyData).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyDataChanged);
         }
         super.data = param1;
         this.m_UncommittedPrey = true;
         invalidateProperties();
         if(data != null)
         {
            (data as PreyData).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyDataChanged);
         }
      }
      
      protected function onPreyDataChanged(param1:PropertyChangeEvent) : void
      {
         this.m_UncommittedPrey = true;
         invalidateProperties();
      }
   }
}
