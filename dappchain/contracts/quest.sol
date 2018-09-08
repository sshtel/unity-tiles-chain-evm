pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

contract LegendQuest is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewQuest(uint uid, string title);

  uint cooldownTime = 30 seconds;
  uint questRandModulus = 10;
  
  struct Party {

  }
  struct Monster {

  }

  struct Quest {
    string title;
    uint periodTime;

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

  mapping (address => uint) public ownerUid;
  mapping (uint => address) public questToOwner;
  mapping (address => uint) ownerQuestCount;

  function createQuest(string title, uint periodTime, string monsterName, uint monsterPower) public onlyOwner {
    uint id = quests.push(Quest(title, periodTime, monsterName, monsterPower)) - 1;
    questToOwner[id] = msg.sender;
    ownerQuestCount[msg.sender] = 0;
    NewQuest(id, title);
  }

  function openRandomQuest(uint _uid) public returns (uint uid, uint qid) {
    uint rand = uint(keccak256(now, uid));
    uint randQid = rand % questRandModulus;

    return (_uid, randQid);
  }

  function createUser(string username) public returns (uint uid) {
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
