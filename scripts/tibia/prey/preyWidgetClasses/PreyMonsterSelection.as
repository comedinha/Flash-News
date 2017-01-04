package tibia.prey.preyWidgetClasses
{
   import mx.collections.ArrayCollection;
   import mx.core.ClassFactory;
   import shared.controls.CustomTileList;
   import tibia.prey.PreyMonsterInformation;
   
   public class PreyMonsterSelection extends CustomTileList
   {
       
      
      private var m_MonsterList:Vector.<PreyMonsterInformation> = null;
      
      private var m_UncommittedMonsterList:Boolean = false;
      
      public function PreyMonsterSelection()
      {
         super();
         itemRenderer = new ClassFactory(PreyMonsterSelection);
         columnWidth = PreyMonsterSelection.RENDERER_SIZE;
         rowHeight = PreyMonsterSelection.RENDERER_SIZE;
         maxColumns = maxRows = 3;
         styleName = "preyMonsterList";
      }
      
      public function set monsterList(param1:Vector.<PreyMonsterInformation>) : void
      {
         clearSelected();
         this.m_MonsterList = param1;
         this.m_UncommittedMonsterList = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedMonsterList)
         {
            if(this.m_MonsterList != null)
            {
               _loc1_ = new Array();
               _loc2_ = 0;
               while(_loc2_ < this.m_MonsterList.length)
               {
                  _loc1_.push(this.m_MonsterList[_loc2_]);
                  _loc2_++;
               }
               dataProvider = new ArrayCollection(_loc1_);
            }
            else
            {
               dataProvider = null;
            }
            this.m_UncommittedMonsterList = false;
         }
      }
      
      public function get selectedMonsterIndex() : int
      {
         return selectedIndex;
      }
   }
}

import mx.controls.listClasses.IListItemRenderer;
import shared.controls.ShapeWrapper;
import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
import tibia.prey.PreyMonsterInformation;

class PreyMonsterRenderer extends ShapeWrapper implements IListItemRenderer
{
   
   public static const RENDERER_SIZE:uint = 64;
    
   
   private var m_UICompleted:Boolean = false;
   
   private var m_UncommittedMonster:Boolean = false;
   
   private var m_UIAppearanceRenderer:SimpleAppearanceRenderer = null;
   
   private var m_PreyMonster:PreyMonsterInformation = null;
   
   function PreyMonsterRenderer()
   {
      super();
      explicitWidth = explicitHeight = RENDERER_SIZE;
      setStyle("horizontalAlign","right");
      setStyle("verticalAlign","bottom");
   }
   
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if(this.m_UncommittedMonster)
      {
         if(this.m_PreyMonster != null)
         {
            this.m_UIAppearanceRenderer.appearance = this.m_PreyMonster.monsterAppearanceInstance;
            this.m_UIAppearanceRenderer.patternX = 2;
            this.m_UIAppearanceRenderer.patternY = 0;
            this.m_UIAppearanceRenderer.patternZ = 0;
            toolTip = this.m_PreyMonster.monsterName;
            invalidateSize();
            invalidateDisplayList();
         }
         else
         {
            this.m_UIAppearanceRenderer.appearance = null;
            toolTip = "";
         }
         this.m_UncommittedMonster = false;
      }
   }
   
   public function get data() : Object
   {
      return this.m_PreyMonster;
   }
   
   public function set data(param1:Object) : void
   {
      this.m_PreyMonster = param1 as PreyMonsterInformation;
      this.m_UncommittedMonster = true;
      invalidateProperties();
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      if(!this.m_UICompleted)
      {
         this.m_UIAppearanceRenderer = new SimpleAppearanceRenderer();
         this.m_UIAppearanceRenderer.scale = 1;
         addChild(this.m_UIAppearanceRenderer);
         this.m_UICompleted = true;
      }
   }
}
