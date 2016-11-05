package tibia.appearances
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   
   public class Marks extends EventDispatcher
   {
      
      public static const MARK_AIM_FOLLOW:uint = MARK_NUM_COLOURS + 3;
      
      public static const MARK_ATTACK:uint = MARK_NUM_COLOURS + 4;
      
      public static const MARK_FOLLOW:uint = MARK_NUM_COLOURS + 5;
      
      public static const MARK_TYPE_CLIENT_MAPWINDOW:uint = 1;
      
      public static const MARK_AIM:uint = MARK_NUM_COLOURS + 1;
      
      public static const MARK_AIM_ATTACK:uint = MARK_NUM_COLOURS + 2;
      
      public static const MARK_TYPE_CLIENT_BATTLELIST:uint = 2;
      
      public static const MARK_NUM_TOTAL:uint = MARK_FOLLOW + 1;
      
      public static const MARK_TYPE_ONE_SECOND_TEMP:uint = 3;
      
      public static const MARK_TYPE_PERMANENT:uint = 4;
      
      public static const MARK_NUM_COLOURS:uint = 216;
      
      public static const MARK_UNMARKED:uint = 255;
       
      
      private var m_CurrentMarks:Dictionary = null;
      
      public function Marks()
      {
         super();
      }
      
      public function getMarkColor(param1:uint) : uint
      {
         if(this.m_CurrentMarks == null)
         {
            return MARK_UNMARKED;
         }
         if(this.m_CurrentMarks[param1] as Marks != null)
         {
            return (this.m_CurrentMarks[param1] as Marks).m_MarkColor;
         }
         return MARK_UNMARKED;
      }
      
      public function areAnyMarksSet(param1:Vector.<uint>) : Boolean
      {
         var _loc3_:uint = 0;
         if(this.m_CurrentMarks == null)
         {
            return false;
         }
         var _loc2_:Boolean = false;
         for each(_loc3_ in param1)
         {
            _loc2_ = this.isMarkSet(_loc3_) || _loc2_;
         }
         return _loc2_;
      }
      
      public function areAllMarksSet(param1:Vector.<uint>) : Boolean
      {
         var _loc3_:uint = 0;
         if(this.m_CurrentMarks == null)
         {
            return false;
         }
         var _loc2_:Boolean = true;
         for each(_loc3_ in param1)
         {
            _loc2_ = this.isMarkSet(_loc3_) && _loc2_;
         }
         return _loc2_;
      }
      
      public function isMarkSet(param1:uint) : Boolean
      {
         if(this.m_CurrentMarks == null)
         {
            return false;
         }
         if(this.m_CurrentMarks[param1] as Marks != null)
         {
            return (this.m_CurrentMarks[param1] as Marks).isSet;
         }
         return false;
      }
      
      public function clear() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:PropertyChangeEvent = null;
         if(this.m_CurrentMarks == null)
         {
            return;
         }
         var _loc1_:Boolean = false;
         for each(_loc2_ in this.m_CurrentMarks)
         {
            delete this.m_CurrentMarks[_loc2_];
            _loc1_ = true;
         }
         if(_loc1_)
         {
            _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc3_.kind = PropertyChangeEventKind.DELETE;
            _loc3_.property = "marks";
            dispatchEvent(_loc3_);
         }
      }
      
      public function setMark(param1:uint, param2:uint) : void
      {
         var _loc4_:PropertyChangeEvent = null;
         if(this.m_CurrentMarks == null)
         {
            if(param2 != MARK_UNMARKED)
            {
               this.m_CurrentMarks = new Dictionary();
            }
            else
            {
               return;
            }
         }
         if(this.m_CurrentMarks.hasOwnProperty(param1) == false)
         {
            switch(param1)
            {
               case MARK_TYPE_ONE_SECOND_TEMP:
                  this.m_CurrentMarks[MARK_TYPE_ONE_SECOND_TEMP] = new MarkTimeout(1000);
                  break;
               default:
                  this.m_CurrentMarks[param1] = new MarkBase();
            }
         }
         var _loc3_:uint = this.getMarkColor(param1);
         if(this.isMarkSet(param1) == false || this.getMarkColor(param1) != param2)
         {
            (this.m_CurrentMarks[param1] as Marks).set(param2);
            _loc4_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc4_.kind = PropertyChangeEventKind.UPDATE;
            _loc4_.property = "marks";
            _loc4_.oldValue = _loc3_;
            _loc4_.newValue = param2;
            dispatchEvent(_loc4_);
         }
      }
   }
}

class MarkBase
{
    
   
   public var m_MarkColor:uint = 255;
   
   function MarkBase()
   {
      super();
   }
   
   public function set(param1:uint) : void
   {
      this.m_MarkColor = param1;
   }
   
   public function get isSet() : Boolean
   {
      return this.m_MarkColor != MarkBase.MARK_UNMARKED;
   }
}

import flash.utils.getTimer;

class MarkTimeout extends MarkBase
{
    
   
   private var m_TimeoutMilliseconds:uint = 1000;
   
   private var m_SetTimestamp:Number = 0;
   
   function MarkTimeout(param1:uint)
   {
      super();
      this.m_TimeoutMilliseconds = param1;
   }
   
   override public function get isSet() : Boolean
   {
      return super.isSet && this.m_SetTimestamp + this.m_TimeoutMilliseconds > getTimer();
   }
   
   override public function set(param1:uint) : void
   {
      super.set(param1);
      this.m_SetTimestamp = getTimer();
   }
}
