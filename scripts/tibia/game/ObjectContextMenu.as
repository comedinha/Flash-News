package tibia.game
{
   import flash.system.System;
   import mx.core.IUIComponent;
   import shared.utility.Vector3D;
   import shared.utility.closure;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.ObjectInstance;
   import tibia.container.ContainerStorage;
   import tibia.creatures.Creature;
   import tibia.creatures.CreatureStorage;
   import tibia.creatures.Player;
   import tibia.input.gameaction.BrowseFieldActionImpl;
   import tibia.input.gameaction.BuddylistActionImpl;
   import tibia.input.gameaction.LookActionImpl;
   import tibia.input.gameaction.MoveActionImpl;
   import tibia.input.gameaction.NameFilterActionImpl;
   import tibia.input.gameaction.PartyActionImpl;
   import tibia.input.gameaction.PrivateChatActionImpl;
   import tibia.input.gameaction.SafeTradeActionImpl;
   import tibia.input.gameaction.SendBugReportActionImpl;
   import tibia.input.gameaction.ToggleWrapStateActionImpl;
   import tibia.input.gameaction.TurnActionImpl;
   import tibia.input.gameaction.UseActionImpl;
   import tibia.input.staticaction.StaticActionList;
   import tibia.reporting.ReportWidget;
   import tibia.reporting.reportType.Type;
   import tibia.worldmap.WorldMapStorage;
   
   public class ObjectContextMenu extends ContextMenuBase
   {
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      protected static const PK_REVENGE:int = 6;
      
      protected static const SKILL_FIGHTCLUB:int = 10;
      
      protected static const NPC_SPEECH_TRAVEL:uint = 5;
      
      protected static const RISKINESS_DANGEROUS:int = 1;
      
      protected static const NUM_PVP_HELPERS_FOR_RISKINESS_DANGEROUS:uint = 5;
      
      protected static const PK_PARTYMODE:int = 2;
      
      protected static const RISKINESS_NONE:int = 0;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      protected static const TYPE_SUMMON_OTHERS:int = 4;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const SKILL_STAMINA:int = 17;
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const STATE_NONE:int = -1;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_GUILTY:int = 7;
      
      protected static const SKILL_FIGHTSHIELD:int = 8;
      
      protected static const SKILL_MANA_LEECH_CHANCE:int = 23;
      
      protected static const SKILL_FIGHTDISTANCE:int = 9;
      
      protected static const PK_EXCPLAYERKILLER:int = 5;
      
      protected static const NUM_CREATURES:int = 1300;
      
      protected static const NUM_TRAPPERS:int = 8;
      
      protected static const SKILL_FED:int = 15;
      
      protected static const SKILL_MAGLEVEL:int = 2;
      
      protected static const SKILL_FISHING:int = 14;
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      private static const ACTION_ATTACK:int = 1;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      private static const BUNDLE:String = "ObjectContextMenu";
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const PARTY_LEADER:int = 1;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      private static const ACTION_OPEN:int = 8;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:int = 9;
      
      protected static const GUILD_WAR_ALLY:int = 1;
      
      protected static const PK_NONE:int = 0;
      
      protected static const PROFESSION_SORCERER:int = 3;
      
      protected static const STATE_SLOW:int = 5;
      
      protected static const PARTY_NONE:int = 0;
      
      protected static const SKILL_CRITICAL_HIT_CHANCE:int = 19;
      
      private static const ACTION_TALK:int = 9;
      
      protected static const SUMMON_OWN:int = 1;
      
      private static const ACTION_LOOK:int = 6;
      
      protected static const SKILL_EXPERIENCE_GAIN:int = -2;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const TYPE_SUMMON_OWN:int = 3;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_FIRE_OF_SUNS << 1;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const STATE_FAST:int = 6;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      protected static const BLESSING_NONE:int = 0;
      
      protected static const GUILD_OTHER:int = 5;
      
      protected static const TYPE_PLAYER:int = 0;
      
      protected static const SKILL_HITPOINTS:int = 4;
      
      protected static const SKILL_OFFLINETRAINING:int = 18;
      
      protected static const STATE_MANA_SHIELD:int = 4;
      
      protected static const SKILL_MANA:int = 5;
      
      protected static const PROFESSION_MASK_PALADIN:int = 1 << PROFESSION_PALADIN;
      
      protected static const STATE_CURSED:int = 11;
      
      protected static const BLESSING_ADVENTURER:int = 1;
      
      protected static const STATE_FREEZING:int = 9;
      
      private static const ACTION_NONE:int = 0;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      protected static const TYPE_MONSTER:int = 1;
      
      protected static const STATE_BURNING:int = 1;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
      private static const ACTION_UNSET:int = -1;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      protected static const PK_AGGRESSOR:int = 3;
      
      protected static const GUILD_WAR_ENEMY:int = 2;
      
      protected static const SKILL_LEVEL:int = 1;
      
      protected static const STATE_STRENGTHENED:int = 12;
      
      protected static const STATE_HUNGRY:int = 31;
      
      protected static const PROFESSION_MASK_ANY:int = PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER;
      
      protected static const SUMMON_NONE:int = 0;
      
      private static const ACTION_USE:int = 7;
      
      protected static const PROFESSION_DRUID:int = 4;
      
      protected static const STATE_FIGHTING:int = 7;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      protected static const NPC_SPEECH_QUEST:uint = 3;
      
      protected static const NPC_SPEECH_NORMAL:uint = 1;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_ADVENTURER << 1;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
       
      
      private var m_LookTarget:Object = null;
      
      private var m_UseTarget:Object = null;
      
      private var m_Absolute:Vector3D = null;
      
      private var m_CreatureTarget:Creature = null;
      
      public function ObjectContextMenu(param1:Vector3D, param2:Object, param3:Object, param4:Creature)
      {
         super();
         if(param1 == null || param1.x == 65535 && param1.y == 0)
         {
            throw new ArgumentError("MapContextMenu.MapContextMenu: Invalid co-ordinate " + param1 + ".");
         }
         this.m_Absolute = param1;
         if(param2 == null)
         {
            throw new ArgumentError("MapContextMenu.MapContextMenu: Invalid look target.");
         }
         this.m_LookTarget = param2;
         if(param3 == null)
         {
            throw new ArgumentError("MapContextMenu.MapContextMenu: Invalid use target.");
         }
         this.m_UseTarget = param3;
         this.m_CreatureTarget = param4;
      }
      
      override public function display(param1:IUIComponent, param2:Number, param3:Number) : void
      {
         var _Creature:Creature = null;
         var a_Owner:IUIComponent = param1;
         var a_StageX:Number = param2;
         var a_StageY:Number = param3;
         var LookObj:ObjectInstance = this.m_LookTarget.object as ObjectInstance;
         var UseObj:ObjectInstance = this.m_UseTarget.object as ObjectInstance;
         var PartyAction:Function = function(param1:int, param2:Creature, param3:*):void
         {
            new PartyActionImpl(param1,param2).perform();
         };
         if(LookObj != null)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_LOOK"),function(param1:*):void
            {
               if(m_LookTarget.object != null)
               {
                  new LookActionImpl(m_Absolute,m_LookTarget.object,m_LookTarget.position).perform();
               }
            });
         }
         if(UseObj != null && (UseObj.type.isContainer || UseObj.type.defaultAction == ACTION_OPEN))
         {
            if(this.m_Absolute.x == 65535 && this.m_Absolute.y >= 64)
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_OPEN"),function(param1:*):void
               {
                  if(m_UseTarget.object != null)
                  {
                     Tibia.s_GameActionFactory.createUseAction(m_Absolute,m_UseTarget.object,m_UseTarget.position,UseActionImpl.TARGET_AUTO).perform();
                  }
               });
               createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_OPEN_NEW_WINDOW"),function(param1:*):void
               {
                  if(m_UseTarget.object != null)
                  {
                     Tibia.s_GameActionFactory.createUseAction(m_Absolute,m_UseTarget.object,m_UseTarget.position,UseActionImpl.TARGET_NEW_WINDOW).perform();
                  }
               });
            }
            else
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_OPEN"),function(param1:*):void
               {
                  if(m_UseTarget.object != null)
                  {
                     Tibia.s_GameActionFactory.createUseAction(m_Absolute,m_UseTarget.object,m_UseTarget.position,UseActionImpl.TARGET_NEW_WINDOW).perform();
                  }
               });
            }
         }
         if(UseObj != null && !UseObj.type.isContainer)
         {
            createTextItem(resourceManager.getString(BUNDLE,!!UseObj.type.isMultiUse?"CTX_OBJECT_MULTIUSE":"CTX_OBJECT_USE"),function(param1:*):void
            {
               if(m_UseTarget.object != null)
               {
                  Tibia.s_GameActionFactory.createUseAction(m_Absolute,m_UseTarget.object,m_UseTarget.position,UseActionImpl.TARGET_AUTO).perform();
               }
            });
         }
         if(UseObj != null && UseObj.type.isWrappable)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_WRAP"),function(param1:*):void
            {
               if(m_UseTarget.object != null)
               {
                  new ToggleWrapStateActionImpl(m_Absolute,m_UseTarget.object,m_UseTarget.position).perform();
               }
            });
         }
         if(UseObj != null && UseObj.type.isUnwrappable)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_UNWRAP"),function(param1:*):void
            {
               if(m_UseTarget.object != null)
               {
                  new ToggleWrapStateActionImpl(m_Absolute,m_UseTarget.object,m_UseTarget.position).perform();
               }
            });
         }
         if(UseObj != null && UseObj.type.isRotateable)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_TURN"),function(param1:*):void
            {
               if(m_UseTarget.object != null)
               {
                  new TurnActionImpl(m_Absolute,m_UseTarget.object,m_UseTarget.position).perform();
               }
            });
         }
         var _WorldMapStorage:WorldMapStorage = Tibia.s_GetWorldMapStorage();
         var Map:Vector3D = null;
         var FirstObj:ObjectInstance = null;
         if(this.m_Absolute.x != 65535 && _WorldMapStorage != null && (Map = _WorldMapStorage.toMap(this.m_Absolute)) != null && (FirstObj = _WorldMapStorage.getObject(Map.x,Map.y,Map.z,0)) != null && FirstObj.type.isBank)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_BROWSE_FIELD"),function(param1:*):void
            {
               new BrowseFieldActionImpl(m_Absolute).perform();
            });
            if(Tibia.s_GetCommunication().allowBugreports)
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_REPORT_FIELD"),function(param1:*):void
               {
                  new SendBugReportActionImpl(null,m_Absolute,null,BugReportWidget.BUG_CATEGORY_MAP).perform();
               });
            }
         }
         createSeparatorItem();
         if(LookObj != null && LookObj.ID != AppearanceInstance.CREATURE && !LookObj.type.isUnmoveable && LookObj.type.isTakeable)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_TRADE"),function(param1:*):void
            {
               if(m_LookTarget.object != null)
               {
                  new SafeTradeActionImpl(m_Absolute,m_LookTarget.object,m_LookTarget.position).perform();
               }
            });
         }
         var _ContainerStorage:ContainerStorage = Tibia.s_GetContainerStorage();
         if(_ContainerStorage != null && LookObj != null && this.m_Absolute.x == 65535 && this.m_Absolute.y >= 64 && _ContainerStorage.getContainerView(this.m_Absolute.y - 64).isSubContainer)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_OBJECT_MOVE_UP"),function(param1:*):void
            {
               var _loc2_:Vector3D = null;
               if(m_LookTarget.object != null)
               {
                  _loc2_ = new Vector3D(m_Absolute.x,m_Absolute.y,254);
                  Tibia.s_GameActionFactory.createMoveAction(m_Absolute,m_LookTarget.object,m_LookTarget.position,_loc2_,MoveActionImpl.MOVE_ALL).perform();
               }
            });
         }
         var _CreatureStorage:CreatureStorage = Tibia.s_GetCreatureStorage();
         var _Player:Player = Tibia.s_GetPlayer();
         if(_CreatureStorage != null && _Player != null && this.m_CreatureTarget != null && this.m_CreatureTarget.ID != _Player.ID)
         {
            _Creature = _CreatureStorage.getAttackTarget();
            if(this.m_CreatureTarget.isNPC)
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_CREATURE_TALK"),function(param1:*):void
               {
                  Tibia.s_GameActionFactory.createGreetAction(m_CreatureTarget).perform();
               });
            }
            else
            {
               createTextItem(resourceManager.getString(BUNDLE,_Creature != null && _Creature.ID == this.m_CreatureTarget.ID?"CTX_CREATURE_ATTACK_STOP":"CTX_CREATURE_ATTACK_START"),closure(null,function(param1:CreatureStorage, param2:Creature, param3:*):void
               {
                  Tibia.s_GameActionFactory.createToggleAttackTargetAction(param2,true).perform();
               },_CreatureStorage,this.m_CreatureTarget));
            }
            _Creature = _CreatureStorage.getFollowTarget();
            createTextItem(resourceManager.getString(BUNDLE,_Creature != null && _Creature.ID == this.m_CreatureTarget.ID?"CTX_CREATURE_FOLLOW_STOP":"CTX_CREATURE_FOLLOW_START"),closure(null,function(param1:CreatureStorage, param2:Creature, param3:*):void
            {
               param1.toggleFollowTarget(param2,true);
            },_CreatureStorage,this.m_CreatureTarget));
            if(this.m_CreatureTarget.isConfirmedPartyMember)
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_JOIN_AGGRESSION",[this.m_CreatureTarget.name]),function(param1:*):void
               {
                  new PartyActionImpl(PartyActionImpl.JOIN_AGGRESSION,m_CreatureTarget).perform();
               });
            }
            if(this.m_CreatureTarget.isHuman)
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_CHAT_MESSAGE",[this.m_CreatureTarget.name]),function(param1:*):void
               {
                  if(m_CreatureTarget != null)
                  {
                     new PrivateChatActionImpl(PrivateChatActionImpl.OPEN_MESSAGE_CHANNEL,PrivateChatActionImpl.CHAT_CHANNEL_NO_CHANNEL,m_CreatureTarget.name).perform();
                  }
               });
               if(Tibia.s_GetChatStorage().hasOwnPrivateChannel)
               {
                  createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_CHAT_INVITE"),function(param1:*):void
                  {
                     if(m_CreatureTarget != null)
                     {
                        new PrivateChatActionImpl(PrivateChatActionImpl.CHAT_CHANNEL_INVITE,Tibia.s_GetChatStorage().ownPrivateChannelID,m_CreatureTarget.name).perform();
                     }
                  });
               }
               if(!BuddylistActionImpl.s_IsBuddy(this.m_CreatureTarget.ID))
               {
                  createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_ADD_BUDDY"),function(param1:*):void
                  {
                     if(m_CreatureTarget != null)
                     {
                        new BuddylistActionImpl(BuddylistActionImpl.ADD_BY_NAME,m_CreatureTarget.name).perform();
                     }
                  });
               }
               if(NameFilterActionImpl.s_IsBlacklisted(this.m_CreatureTarget.name))
               {
                  createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_UNIGNORE",[this.m_CreatureTarget.name]),function(param1:*):void
                  {
                     if(m_CreatureTarget != null)
                     {
                        new NameFilterActionImpl(NameFilterActionImpl.UNIGNORE,m_CreatureTarget.name).perform();
                     }
                  });
               }
               else
               {
                  createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_IGNORE",[this.m_CreatureTarget.name]),function(param1:*):void
                  {
                     if(m_CreatureTarget != null)
                     {
                        new NameFilterActionImpl(NameFilterActionImpl.IGNORE,m_CreatureTarget.name).perform();
                     }
                  });
               }
               switch(_Player.partyFlag)
               {
                  case PARTY_LEADER:
                     if(this.m_CreatureTarget.partyFlag == PARTY_MEMBER)
                     {
                        createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_EXCLUDE",[this.m_CreatureTarget.name]),closure(null,PartyAction,PartyActionImpl.EXCLUDE,this.m_CreatureTarget));
                     }
                     break;
                  case PARTY_LEADER_SEXP_ACTIVE:
                  case PARTY_LEADER_SEXP_INACTIVE_GUILTY:
                  case PARTY_LEADER_SEXP_INACTIVE_INNOCENT:
                  case PARTY_LEADER_SEXP_OFF:
                     if(this.m_CreatureTarget.partyFlag == PARTY_MEMBER)
                     {
                        createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_EXCLUDE",[this.m_CreatureTarget.name]),closure(null,PartyAction,PartyActionImpl.EXCLUDE,this.m_CreatureTarget));
                     }
                     else if(this.m_CreatureTarget.partyFlag == PARTY_MEMBER_SEXP_OFF || this.m_CreatureTarget.partyFlag == PARTY_MEMBER_SEXP_ACTIVE || this.m_CreatureTarget.partyFlag == PARTY_MEMBER_SEXP_INACTIVE_GUILTY || this.m_CreatureTarget.partyFlag == PARTY_MEMBER_SEXP_INACTIVE_INNOCENT)
                     {
                        createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_PASS_LEADERSHIP",[this.m_CreatureTarget.name]),closure(null,PartyAction,PartyActionImpl.PASS_LEADERSHIP,this.m_CreatureTarget));
                     }
                     else
                     {
                        createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_INVITE",[this.m_CreatureTarget.name]),closure(null,PartyAction,PartyActionImpl.INVITE,this.m_CreatureTarget));
                     }
                     break;
                  case PARTY_MEMBER_SEXP_ACTIVE:
                  case PARTY_MEMBER_SEXP_INACTIVE_GUILTY:
                  case PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:
                  case PARTY_MEMBER_SEXP_OFF:
                     break;
                  case PARTY_NONE:
                  case PARTY_MEMBER:
                     if(this.m_CreatureTarget.partyFlag == PARTY_LEADER)
                     {
                        createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_JOIN",[this.m_CreatureTarget.name]),closure(null,PartyAction,PartyActionImpl.JOIN,this.m_CreatureTarget));
                     }
                     else if(this.m_CreatureTarget.partyFlag != PARTY_OTHER)
                     {
                        createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_INVITE",[this.m_CreatureTarget.name]),closure(null,PartyAction,PartyActionImpl.INVITE,this.m_CreatureTarget));
                     }
               }
            }
            createSeparatorItem();
            if(this.m_CreatureTarget.isReportTypeAllowed(Type.REPORT_NAME))
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_REPORT_NAME"),function(param1:*):void
               {
                  if(m_CreatureTarget != null)
                  {
                     new ReportWidget(Type.REPORT_NAME,m_CreatureTarget).show();
                  }
               });
            }
            if(this.m_CreatureTarget.isReportTypeAllowed(Type.REPORT_BOT))
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_REPORT_BOT"),function(param1:*):void
               {
                  if(m_CreatureTarget != null)
                  {
                     new ReportWidget(Type.REPORT_BOT,m_CreatureTarget).show();
                  }
               });
            }
         }
         createSeparatorItem();
         if(this.m_CreatureTarget != null && this.m_CreatureTarget.ID == _Player.ID)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_SET_OUTFIT"),function(param1:*):void
            {
               StaticActionList.MISC_SHOW_OUTFIT.perform();
            });
            createTextItem(resourceManager.getString(BUNDLE,_Player.mountOutfit == null?"CTX_PLAYER_MOUNT":"CTX_PLAYER_DISMOUNT"),function(param1:*):void
            {
               StaticActionList.PLAYER_MOUNT.perform();
            });
            createTextItem(resourceManager.getString(BUNDLE,"CTX_PLAYER_OPEN_PREY_DIALOG"),function(param1:*):void
            {
               StaticActionList.MISC_SHOW_PREY_DIALOG.perform();
            });
            if(_Player.isPartyLeader && !_Player.isFighting)
            {
               if(_Player.isPartySharedExperienceActive)
               {
                  createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_DISABLE_SHARED_EXPERIENCE"),closure(null,PartyAction,PartyActionImpl.DISABLE_SHARED_EXPERIENCE,null));
               }
               else
               {
                  createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_ENABLE_SHARED_EXPERIENCE"),closure(null,PartyAction,PartyActionImpl.ENABLE_SHARED_EXPERIENCE,null));
               }
            }
            if(_Player.isPartyMember && !_Player.isFighting)
            {
               createTextItem(resourceManager.getString(BUNDLE,"CTX_PARTY_LEAVE"),closure(null,PartyAction,PartyActionImpl.LEAVE,null));
            }
         }
         createSeparatorItem();
         if(this.m_CreatureTarget != null)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_CREATURE_COPY_NAME"),function(param1:*):void
            {
               if(m_CreatureTarget != null)
               {
                  System.setClipboard(m_CreatureTarget.name);
               }
            });
         }
         super.display(a_Owner,a_StageX,a_StageY);
      }
   }
}
