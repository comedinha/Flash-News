package tibia.questlog
{
   public class QuestLine
   {
      
      public static const MAX_NAME_LENGTH:int = 50;
       
      
      private var m_ID:int = -1;
      
      private var m_Completed:Boolean = false;
      
      private var m_Name:String = null;
      
      public function QuestLine(param1:int, param2:String, param3:Boolean)
      {
         super();
         if(param1 < 0)
         {
            throw new ArgumentError("QuestLine.QuestLine: Invalid ID: " + param1 + ".");
         }
         this.m_ID = param1;
         if(param2 == null || param2.length > MAX_NAME_LENGTH)
         {
            throw new ArgumentError("QuestLine.QuestLine: Invalid name: \"" + param2 + "\".");
         }
         this.m_Name = param2;
         this.m_Completed = param3;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function get completed() : Boolean
      {
         return this.m_Completed;
      }
   }
}
