pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

contract LegendQuest is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewQuest(bool success, uint qid);
  event NewUser(uint uid, string title);
  event StartQuest(uint questSlotId, uint endTime);
  event ResultQuest(bool success, uint questSlotId, uint qid, uint remainTime);
  event DeleteQuest(bool success, uint questSlotId);

  uint cooldownTime = 30 seconds;

  struct Quest {
    uint inUse;
    uint qid;
    uint periodTime;
    uint endTime;
    // Party MyParty;
    // Monster MyMonster;
  }

  struct User {
    string username;
  }

  User[] public users;
  uint public userCount = 0;

  mapping (address => uint) public ownerUid;      // msg.sender : uid(idx)
  mapping (address => uint) public ownerQuestCount;      // msg.sender : number of quests

  mapping (address => Quest) public quest1;
  mapping (address => Quest) public quest2;
  mapping (address => Quest) public quest3;
  mapping (address => Quest) public quest4;
  

  function createQuest(uint qid, uint periodTime) public {
    if (quest1[msg.sender].inUse == 0) {
      quest1[msg.sender].inUse = 1;
      quest1[msg.sender].qid = qid;
      quest1[msg.sender].periodTime = periodTime;
    } else if (quest2[msg.sender].inUse == 0) {
      quest2[msg.sender].inUse = 1;
      quest2[msg.sender].qid = qid;
      quest2[msg.sender].periodTime = periodTime;
    } else if (quest3[msg.sender].inUse == 0) {
      quest3[msg.sender].inUse = 1;
      quest3[msg.sender].qid = qid;
      quest3[msg.sender].periodTime = periodTime;
    } else if (quest4[msg.sender].inUse == 0) {
      quest4[msg.sender].inUse = 1;
      quest4[msg.sender].qid = qid;
      quest4[msg.sender].periodTime = periodTime;
    } else {
      emit NewQuest(false, qid); //fail
      return;
    }
    emit NewQuest(true, qid);
  }

  function startQuest(uint questSlotId) public {
    uint endTime;
    if (questSlotId == 1) {
      endTime = now + quest1[msg.sender].periodTime;
      quest1[msg.sender].endTime = endTime;
    } else if (questSlotId == 2) {
      endTime = now + quest2[msg.sender].periodTime;
      quest2[msg.sender].endTime = endTime;
    } else if (questSlotId == 3) {
      endTime = now + quest3[msg.sender].periodTime;
      quest3[msg.sender].endTime = endTime;
    } else if (questSlotId == 4) {
      endTime = now + quest4[msg.sender].periodTime;
      quest4[msg.sender].endTime = endTime;
    } else {
      return;
    }
    emit StartQuest(questSlotId, endTime);
  }

  function resultQuest(uint questSlotId) public {
    Quest storage quest;
    if (questSlotId == 1) {
      quest = quest1[msg.sender];
    } else if (questSlotId == 2) {
      quest = quest2[msg.sender];
    } else if (questSlotId == 3) {
      quest = quest3[msg.sender];
    } else if (questSlotId == 4) {
      quest = quest4[msg.sender];
    }

    if (quest.inUse == 1) {
      if (quest.endTime >= now) {
        emit ResultQuest(true, questSlotId, quest.qid, quest.endTime - now);
      } else {
        quest.inUse = 0;
        emit ResultQuest(true, questSlotId, quest.qid, 0);
      }
    } else {
      emit ResultQuest(false, questSlotId, 0, 0);
    }
  }

  function deleteQuest(uint questSlotId) public {
    if (questSlotId == 1) {
      quest1[msg.sender].inUse = 0;
      quest1[msg.sender].qid = 0;
      quest1[msg.sender].periodTime = 0;
    } else if (questSlotId == 2) {
      quest2[msg.sender].inUse = 0;
      quest2[msg.sender].qid = 0;
      quest2[msg.sender].periodTime = 0;
    } else if (questSlotId == 3) {
      quest3[msg.sender].inUse = 0;
      quest3[msg.sender].qid = 0;
      quest3[msg.sender].periodTime = 0;
    } else if (questSlotId == 4) {
      quest4[msg.sender].inUse = 0;
      quest4[msg.sender].qid = 0;
      quest4[msg.sender].periodTime = 0;
    } else {
      emit DeleteQuest(false, questSlotId);
      return;
    }
    emit DeleteQuest(true, questSlotId);
  }

  function createUser(string username) public {
    users.push(User(username));
    ownerUid[msg.sender] = userCount;
    userCount++;
    uint idx = userCount - 1;
    emit NewUser(idx, username);
  }

  function getUserInfo() public view returns (uint, string) {
    uint uid = ownerUid[msg.sender];
    User storage user = users[uid];
    return (uid, user.username);
  }

  function getUserCount() public constant returns(uint) {
      return users.length;
  }

  function whoAmI() public view returns (address) {
    return msg.sender;
  }

  function ping() public pure returns (uint) {
    return 1;
  }

  function rand(uint modulus) public returns (uint) {
    uint ret = uint(keccak256(now, msg.sender));
    return ret % modulus;
  }

  function nowTime() public returns (uint) {
    return now;
  }

}
