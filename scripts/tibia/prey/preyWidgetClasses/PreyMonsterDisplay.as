package tibia.prey.preyWidgetClasses
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Image;
   import shared.controls.ShapeWrapper;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   import tibia.prey.PreyData;
   
   public class PreyMonsterDisplay extends HBox
   {
      
      private static const PREY_NO_BONUS_CLASS:Class = PreyMonsterDisplay_PREY_NO_BONUS_CLASS;
      
      private static const PREY_NO_PREY_CLASS:Class = PreyMonsterDisplay_PREY_NO_PREY_CLASS;
      
      private static const PREY_DAMAGE_REDUCTION_CLASS:Class = PreyMonsterDisplay_PREY_DAMAGE_REDUCTION_CLASS;
      
      private static const PREY_STAR_INACTIVE_CLASS:Class = PreyMonsterDisplay_PREY_STAR_INACTIVE_CLASS;
      
      public static const PREY_STAR_ACTIVE:BitmapData = Bitmap(new PREY_STAR_ACTIVE_CLASS()).bitmapData;
      
      public static const PREY_IMPROVED_LOOT:BitmapData = Bitmap(new PREY_IMPROVED_LOOT_CLASS()).bitmapData;
      
      public static const PREY_DAMAGE_BOOST:BitmapData = Bitmap(new PREY_DAMAGE_BOOST_CLASS()).bitmapData;
      
      private static const PREY_STAR_ACTIVE_CLASS:Class = PreyMonsterDisplay_PREY_STAR_ACTIVE_CLASS;
      
      public static const PREY_IMPROVED_XP:BitmapData = Bitmap(new PREY_IMPROVED_XP_CLASS()).bitmapData;
      
      private static const PREY_IMPROVED_LOOT_CLASS:Class = PreyMonsterDisplay_PREY_IMPROVED_LOOT_CLASS;
      
      public static const PREY_DAMAGE_REDUCTION:BitmapData = Bitmap(new PREY_DAMAGE_REDUCTION_CLASS()).bitmapData;
      
      public static const PREY_STAR_INACTIVE:BitmapData = Bitmap(new PREY_STAR_INACTIVE_CLASS()).bitmapData;
      
      public static const PREY_NO_BONUS:BitmapData = Bitmap(new PREY_NO_BONUS_CLASS()).bitmapData;
      
      public static const PREY_NO_PREY:BitmapData = Bitmap(new PREY_NO_PREY_CLASS()).bitmapData;
      
      private static const PREY_DAMAGE_BOOST_CLASS:Class = PreyMonsterDisplay_PREY_DAMAGE_BOOST_CLASS;
      
      private static const PREY_IMPROVED_XP_CLASS:Class = PreyMonsterDisplay_PREY_IMPROVED_XP_CLASS;
       
      
      private var m_UIBonusImage:Image = null;
      
      private var m_UICompleted:Boolean = false;
      
      private var m_BonusType:uint = 4;
      
      private var m_UncommittedMonster:Boolean = false;
      
      private var m_BonusValue:uint = 0;
      
      private var m_UIMonsterDisplay:SimpleAppearanceRenderer = null;
      
      private var m_UIBonusStars:Vector.<Image>;
      
      private var m_PreyMonster:AppearanceInstance = null;
      
      private var m_UINoMonster:Image = null;
      
      private var m_BonusGrade:uint = 0;
      
      private var m_UncommittedBonus:Boolean = false;
      
      public function PreyMonsterDisplay()
      {
         this.m_UIBonusStars = new Vector.<Image>();
         super();
         setStyle("verticalGap",4);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedMonster)
         {
            this.m_UIMonsterDisplay.appearance = this.m_PreyMonster;
            this.m_UIMonsterDisplay.patternX = 2;
            this.m_UIMonsterDisplay.patternY = 0;
            this.m_UIMonsterDisplay.patternZ = 0;
            (this.m_UIMonsterDisplay.parent as ShapeWrapper).visible = this.m_PreyMonster != null;
            (this.m_UIMonsterDisplay.parent as ShapeWrapper).includeInLayout = this.m_PreyMonster != null;
            (this.m_UIMonsterDisplay.parent as ShapeWrapper).invalidateSize();
            (this.m_UIMonsterDisplay.parent as ShapeWrapper).invalidateDisplayList();
            if(this.m_PreyMonster != null)
            {
               if(contains(this.m_UINoMonster))
               {
                  removeChild(this.m_UINoMonster);
               }
            }
            else
            {
               addChildAt(this.m_UINoMonster,0);
            }
            this.m_UncommittedMonster = false;
         }
         if(this.m_UncommittedBonus)
         {
            this.m_UIBonusImage.removeChildren();
            _loc1_ = this.getBonusTypeBitmapData();
            this.m_UIBonusImage.addChild(new Bitmap(_loc1_));
            this.m_UIBonusImage.width = _loc1_.width;
            this.m_UIBonusImage.height = _loc1_.height;
            _loc2_ = 0;
            while(_loc2_ < this.m_UIBonusStars.length)
            {
               this.m_UIBonusStars[_loc2_].removeChildren();
               this.m_UIBonusStars[_loc2_].addChild(new Bitmap(_loc2_ < this.m_BonusGrade?PREY_STAR_ACTIVE:PREY_STAR_INACTIVE));
               _loc2_++;
            }
            this.m_UncommittedBonus = false;
         }
      }
      
      public function setMonster(param1:AppearanceInstance) : void
      {
         this.m_PreyMonster = param1;
         this.m_UncommittedMonster = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ShapeWrapper = null;
         var _loc3_:VBox = null;
         var _loc4_:HBox = null;
         var _loc5_:HBox = null;
         var _loc6_:uint = 0;
         var _loc7_:Image = null;
         super.createChildren();
         if(!this.m_UICompleted)
         {
            _loc1_ = 128;
            this.m_UIMonsterDisplay = new SimpleAppearanceRenderer();
            this.m_UIMonsterDisplay.scale = 2;
            _loc2_ = new ShapeWrapper();
            _loc2_.explicitWidth = _loc1_;
            _loc2_.explicitHeight = _loc1_;
            _loc2_.setStyle("horizontalAlign","right");
            _loc2_.setStyle("verticalAlign","bottom");
            _loc2_.addChild(this.m_UIMonsterDisplay);
            addChild(_loc2_);
            this.m_UINoMonster = new Image();
            this.m_UINoMonster.addChild(new Bitmap(PREY_NO_PREY));
            this.m_UINoMonster.explicitWidth = _loc1_;
            this.m_UINoMonster.explicitHeight = _loc1_;
            this.m_UINoMonster.setStyle("horizontalAlign","center");
            this.m_UINoMonster.setStyle("verticalAlign","middle");
            _loc3_ = new VBox();
            _loc3_.percentWidth = 100;
            _loc3_.setStyle("horizontalAlign","center");
            _loc3_.setStyle("paddingLeft",15);
            addChild(_loc3_);
            this.m_UIBonusImage = new Image();
            _loc3_.addChild(this.m_UIBonusImage);
            _loc4_ = new HBox();
            _loc4_.percentWidth = 100;
            _loc4_.setStyle("horizontalGap",2);
            _loc3_.addChild(_loc4_);
            _loc5_ = new HBox();
            _loc5_.percentWidth = 100;
            _loc5_.setStyle("horizontalGap",2);
            _loc3_.addChild(_loc5_);
            _loc6_ = 0;
            while(_loc6_ < PreyData.PREY_MAXIMUM_GRADE)
            {
               _loc7_ = new Image();
               _loc7_.width = PREY_STAR_ACTIVE.width;
               _loc7_.height = PREY_STAR_ACTIVE.width;
               if(_loc6_ < PreyData.PREY_MAXIMUM_GRADE / 2)
               {
                  _loc4_.addChild(_loc7_);
               }
               else
               {
                  _loc5_.addChild(_loc7_);
               }
               this.m_UIBonusStars.push(_loc7_);
               _loc6_++;
            }
            this.m_UICompleted = true;
         }
      }
      
      public function setBonus(param1:uint, param2:uint, param3:uint) : void
      {
         this.m_BonusType = param1;
         this.m_BonusValue = param2;
         this.m_BonusGrade = param3;
         this.m_UncommittedBonus = true;
         invalidateProperties();
      }
      
      private function getBonusTypeBitmapData() : BitmapData
      {
         if(this.m_BonusType == PreyData.BONUS_DAMAGE_BOOST)
         {
            return PREY_DAMAGE_BOOST;
         }
         if(this.m_BonusType == PreyData.BONUS_DAMAGE_REDUCTION)
         {
            return PREY_DAMAGE_REDUCTION;
         }
         if(this.m_BonusType == PreyData.BONUS_IMPROVED_LOOT)
         {
            return PREY_IMPROVED_LOOT;
         }
         if(this.m_BonusType == PreyData.BONUS_XP_BONUS)
         {
            return PREY_IMPROVED_XP;
         }
         return PREY_NO_BONUS;
      }
   }
}
