pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

contract LegendQuest is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewQuest(bool success, uint qid, uint questSlotId, string reason);
  event NewUser(uint uid, string title);
  event StartQuest(uint questSlotId, uint endTime);
  event ResultQuest(string status, uint questSlotId, uint qid, uint remainTime);
  event DeleteQuest(bool success, uint questSlotId);
  event ReportQuest(uint idx, bool inReady, bool inRunning, uint qid, uint periodTime, uint endTime);

  uint cooldownTime = 30 seconds;

  struct Quest {
    bool inReady;
    bool inRunning;
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


  mapping (address => Quest) public quest0;
  mapping (address => Quest) public quest1;
  mapping (address => Quest) public quest2;
  mapping (address => Quest) public quest3;
  mapping (address => Quest) public quest4;
  mapping (address => Quest) public quest5;
  mapping (address => Quest) public quest6;
  mapping (address => Quest) public quest7;
  mapping (address => Quest) public quest8;
  mapping (address => Quest) public quest9;
  mapping (address => Quest) public quest10;
  mapping (address => Quest) public quest11;
  Quest public dummy;

  mapping (address => uint) public readyQuestCount;
  mapping (address => uint) public runningQuestCount;

  uint private maxQuestCount = 12;
  uint private maxReadyQuestCount = 4;


  // function questSlotCount() private returns(uint) {
  //   uint count = 0;
  //   if (quest1[msg.sender].inUse == 1) { count++; }
  //   if (quest2[msg.sender].inUse == 1) { count++; }
  //   if (quest3[msg.sender].inUse == 1) { count++; }
  //   if (quest4[msg.sender].inUse == 1) { count++; }
  //   if (quest5[msg.sender].inUse == 1) { count++; }
  //   if (quest6[msg.sender].inUse == 1) { count++; }
  //   if (quest7[msg.sender].inUse == 1) { count++; }
  //   if (quest8[msg.sender].inUse == 1) { count++; }
  //   return count;
  // }

  function createQuest(uint qid, uint periodTime) public {
    uint inReadyCount = 0;
    for (uint i = 0; i < maxQuestCount; i++) {
      if(inReadyCount >= maxReadyQuestCount) {
        emit NewQuest(false, qid, 99, "Quest Queue full"); //fail
        return;
      }

      Quest storage q = getQuest(msg.sender, i);
      if (q.inReady) {
        inReadyCount++;
        continue;
      }
      if (q.inRunning) { continue; }
      q.inReady = true;
      q.qid = qid;
      q.periodTime = periodTime;
      emit NewQuest(true, qid, i, "Quest created");
      return;
    }
    emit NewQuest(false, qid, 99, "Quest Queue full"); //fail
    return;
  }
  function getQuest(address owner, uint idx) private view returns (Quest storage) {
    if (idx == 0) return quest0[owner];
    else if (idx == 1) return quest1[owner];
    else if (idx == 2) return quest2[owner];
    else if (idx == 3) return quest3[owner];
    else if (idx == 4) return quest4[owner];
    else if (idx == 5) return quest5[owner];
    else if (idx == 6) return quest6[owner];
    else if (idx == 7) return quest7[owner];
    else if (idx == 8) return quest8[owner];
    else if (idx == 9) return quest9[owner];
    else if (idx == 10) return quest10[owner];
    else if (idx == 11) return quest11[owner];
    else return dummy;
  }

  function getReadyQuestCount() public view returns (uint) {
    return readyQuestCount[msg.sender];
  }

  function getRunningQuestCount() public view returns (uint) {
    return runningQuestCount[msg.sender];
  }

  function startQuest(uint questSlotId) public {
    uint endTime;
    Quest storage quest = getQuest(msg.sender, questSlotId);
    if(quest.inReady) {
      quest.inReady = false;
      quest.inRunning = true;
      endTime = now + quest.periodTime;
      quest.endTime = endTime;
    } else {
      emit StartQuest(99, 0);
      return;
    }

    readyQuestCount[msg.sender]--;
    runningQuestCount[msg.sender]++;
    emit StartQuest(questSlotId, endTime);
  }

  function resultQuest(uint questSlotId) public {
    Quest storage quest = getQuest(msg.sender, questSlotId);

    if (quest.inRunning) {
      if (quest.endTime >= now) {
        emit ResultQuest("running", questSlotId, quest.qid, quest.endTime - now);
      } else {
        quest.inRunning = false;
        quest.inReady = false;
        runningQuestCount[msg.sender]--;
        emit ResultQuest("done", questSlotId, quest.qid, 0);
      }
    } else if (quest.inReady) {
      emit ResultQuest("ready", questSlotId, quest.qid, 0);
    } else {
      emit ResultQuest("empty", questSlotId, 0, 0);
    }
  }

  function deleteQuest(uint questSlotId) public {
    Quest storage quest = getQuest(msg.sender, questSlotId);
    quest.inReady = false;
    quest.inRunning = false;
    quest.qid = 0;
    quest.periodTime = 0;
    quest.endTime = 0;
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

  function rand(uint modulus) public view returns (uint) {
    uint ret = uint(keccak256(now, msg.sender));
    return ret % modulus;
  }

  function nowTime() public view returns (uint) {
    return now;
  }

  function showQuestList() public returns(uint) {
    for (uint i = 0; i < maxQuestCount; i++){
      Quest storage q = getQuest(msg.sender, i);
      emit ReportQuest(i, q.inReady, q.inRunning, q.qid, q.periodTime, q.endTime);
    }
    return 1;
  }

  function showQuest(uint idx) public returns(uint) {
    Quest storage q = getQuest(msg.sender, idx);
    emit ReportQuest(idx, q.inReady, q.inRunning, q.qid, q.periodTime, q.endTime);
    return 1;
  }
}
