pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

contract LegendQuest is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewQuest(uint uid, string title);

  uint cooldownTime = 30 seconds;

  struct Party {

  }
  struct Monster {

  }

  struct Quest {
    uint key;
    string title;
    uint periodTime;
    uint endTime;
    // Party MyParty;
    // Monster MyMonster;

    string monsterName;
    // string monsterThumbImageId;
    uint monsterPower;
    // uint[] Normal_Trophy;    //2
    // uint[] Random_Trophy;    //6
    // uint Trophy_Count_Possible;
    // bool[] Trophy_Checked;
    // uint Trophy_Count_Selected;
  }

  struct User {
    string username;
  }

  Quest[] public quests;
  User[] public users;

  mapping (address => uint) public ownerUid;      // msg.sender : uid(idx)
  mapping (uint => address) public questToOwner;  // rand Key : msg.sender
  mapping (address => uint) ownerQuestCount;      // msg.sender : number of quests

  function createQuest(string title, uint periodTime, string monsterName, uint monsterPower) public onlyOwner {
    uint randKey = uint(keccak256(now, title));
    uint endTime = now + periodTime;
    uint id = quests.push(Quest(randKey, title, periodTime, endTime, monsterName, monsterPower)) - 1;
    questToOwner[randKey] = msg.sender;
    NewQuest(id, title);
  }

  function openRandomQuest(uint _uid) public returns (uint uid, uint qid) {
    uint rand = uint(keccak256(now, uid));
    uint questRandModulus = quests.length;
    uint randQid = rand % questRandModulus;
    ownerQuestCount[msg.sender] = ownerQuestCount[msg.sender].add(1);
    return (_uid, randQid);
  }

  function createUser(string username) public returns (uint uid) {
    if (ownerUid[msg.sender] > 0) throw;
    uint id = users.push(User(username)) - 1;
    ownerUid[msg.sender] = id;
    return id;
  }

  function getUserInfo(address owner) public returns (string username) {
    uint uid = ownerUid[owner];
    User user = users[uid];
    return user.username;
  }

  function getUserCount() public constant returns(uint count) {
      return users.length;
  }

  function getQuestCount() public constant returns(uint count) {
      return quests.length;
  }

}
