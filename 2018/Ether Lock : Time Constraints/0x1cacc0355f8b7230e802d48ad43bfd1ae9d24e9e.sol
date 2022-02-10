['pragma solidity ^0.4.24;\n', '\n', 'contract CryptoBeautyVoting {\n', '\n', '  event Won(address indexed _winner, uint256 _value);\n', '  bool votingStart = false;\n', '  uint32 private restartTime;\n', '  uint32 private readyTime;\n', '  uint256 private votePrice;\n', '  address[] private arrOfVoters;\n', '  uint256[] private arrOfBeautyIdMatchedVoters;\n', '  address private owner;\n', '  \n', '  constructor() public {\n', '    owner = msg.sender;\n', '    restartTime = 7 days;\n', '    readyTime = uint32(now + restartTime);\n', '    votePrice = 0.002 ether;\n', '  }\n', '\n', '  /* Modifiers */\n', '  modifier onlyOwner() {\n', '    require(owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '   /* Owner */\n', '  function setOwner (address _owner) onlyOwner() public {\n', '    owner = _owner;\n', '  }\n', '\n', '  function withdrawAll () onlyOwner() public {\n', '    owner.transfer(address(this).balance);\n', '  }\n', '\n', '  function withdrawAmount (uint256 _amount) onlyOwner() public {\n', '    owner.transfer(_amount);\n', '  }\n', '\n', '  function getCurrentBalance() public view returns (uint256 balance) {\n', '      return address(this).balance;\n', '  }\n', '\n', '  /* Voting */\n', '  function startVoting() onlyOwner() public {\n', '    votingStart = true;\n', '  }\n', '\n', '  function stopVoting() onlyOwner() public {\n', '    votingStart = false;\n', '  }\n', '\n', '  function changeRestarTime(uint32 _rTime) onlyOwner() public {\n', '    restartTime = _rTime;\n', '  }\n', '\n', '  function changevotePrice(uint256 _votePrice) onlyOwner() public {\n', '    votePrice = _votePrice;\n', '  }\n', '\n', '  function _isReady() internal view returns (bool) {\n', '    return (readyTime <= now);\n', '  }\n', '\n', '  function _isOne(address _voter) private view returns (bool) {\n', '    uint256 j = 0;\n', '    for(uint256 i = 0; i < arrOfVoters.length; i++) {\n', '      if(keccak256(abi.encodePacked(arrOfVoters[i])) == keccak256(abi.encodePacked(_voter)))\n', '      {\n', '        j++;\n', '      }\n', '    }\n', '    if(j == 0) {\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  function vote(uint256 _itemId) payable public {\n', '    require(votingStart);\n', '    require(msg.value >= votePrice);\n', '    require(!isContract(msg.sender));\n', '    require(msg.sender != address(0));\n', '    require(_isOne(msg.sender));\n', '\n', '    arrOfVoters.push(msg.sender);\n', '    arrOfBeautyIdMatchedVoters.push(_itemId);\n', '  }\n', '\n', '  function getVoteResult() onlyOwner() public view returns (address[], uint256[]) {\n', '    require(_isReady());\n', '    return (arrOfVoters, arrOfBeautyIdMatchedVoters);\n', '  }\n', '\n', '  function voteResultPublish(address[] _winner, uint256[] _value) onlyOwner() public {\n', '    require(votingStart);\n', '    votingStart = false;\n', '    for (uint256 i = 0; i < _winner.length; i++) {\n', '     _winner[i].transfer(_value[i]);\n', '     emit Won(_winner[i], _value[i]);\n', '    }\n', '  }\n', '\n', '  function clear() onlyOwner() public {\n', '    delete arrOfVoters;\n', '    delete arrOfBeautyIdMatchedVoters;\n', '    readyTime = uint32(now + restartTime);\n', '    votingStart = true;\n', '  }\n', '  function getRestarTime() public view returns (uint32) {\n', '    return restartTime;\n', '  }\n', '\n', '  function getVotingStatus() public view returns (bool) {\n', '    return votingStart;\n', '  }\n', '\n', '  function getVotePrice() public view returns (uint256) {\n', '    return votePrice;\n', '  }\n', '\n', '  /* Util */\n', '  function isContract(address addr) internal view returns (bool) {\n', '    uint size;\n', '    assembly { size := extcodesize(addr) } // solium-disable-line\n', '    return size > 0;\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract CryptoBeautyVoting {\n', '\n', '  event Won(address indexed _winner, uint256 _value);\n', '  bool votingStart = false;\n', '  uint32 private restartTime;\n', '  uint32 private readyTime;\n', '  uint256 private votePrice;\n', '  address[] private arrOfVoters;\n', '  uint256[] private arrOfBeautyIdMatchedVoters;\n', '  address private owner;\n', '  \n', '  constructor() public {\n', '    owner = msg.sender;\n', '    restartTime = 7 days;\n', '    readyTime = uint32(now + restartTime);\n', '    votePrice = 0.002 ether;\n', '  }\n', '\n', '  /* Modifiers */\n', '  modifier onlyOwner() {\n', '    require(owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '   /* Owner */\n', '  function setOwner (address _owner) onlyOwner() public {\n', '    owner = _owner;\n', '  }\n', '\n', '  function withdrawAll () onlyOwner() public {\n', '    owner.transfer(address(this).balance);\n', '  }\n', '\n', '  function withdrawAmount (uint256 _amount) onlyOwner() public {\n', '    owner.transfer(_amount);\n', '  }\n', '\n', '  function getCurrentBalance() public view returns (uint256 balance) {\n', '      return address(this).balance;\n', '  }\n', '\n', '  /* Voting */\n', '  function startVoting() onlyOwner() public {\n', '    votingStart = true;\n', '  }\n', '\n', '  function stopVoting() onlyOwner() public {\n', '    votingStart = false;\n', '  }\n', '\n', '  function changeRestarTime(uint32 _rTime) onlyOwner() public {\n', '    restartTime = _rTime;\n', '  }\n', '\n', '  function changevotePrice(uint256 _votePrice) onlyOwner() public {\n', '    votePrice = _votePrice;\n', '  }\n', '\n', '  function _isReady() internal view returns (bool) {\n', '    return (readyTime <= now);\n', '  }\n', '\n', '  function _isOne(address _voter) private view returns (bool) {\n', '    uint256 j = 0;\n', '    for(uint256 i = 0; i < arrOfVoters.length; i++) {\n', '      if(keccak256(abi.encodePacked(arrOfVoters[i])) == keccak256(abi.encodePacked(_voter)))\n', '      {\n', '        j++;\n', '      }\n', '    }\n', '    if(j == 0) {\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  function vote(uint256 _itemId) payable public {\n', '    require(votingStart);\n', '    require(msg.value >= votePrice);\n', '    require(!isContract(msg.sender));\n', '    require(msg.sender != address(0));\n', '    require(_isOne(msg.sender));\n', '\n', '    arrOfVoters.push(msg.sender);\n', '    arrOfBeautyIdMatchedVoters.push(_itemId);\n', '  }\n', '\n', '  function getVoteResult() onlyOwner() public view returns (address[], uint256[]) {\n', '    require(_isReady());\n', '    return (arrOfVoters, arrOfBeautyIdMatchedVoters);\n', '  }\n', '\n', '  function voteResultPublish(address[] _winner, uint256[] _value) onlyOwner() public {\n', '    require(votingStart);\n', '    votingStart = false;\n', '    for (uint256 i = 0; i < _winner.length; i++) {\n', '     _winner[i].transfer(_value[i]);\n', '     emit Won(_winner[i], _value[i]);\n', '    }\n', '  }\n', '\n', '  function clear() onlyOwner() public {\n', '    delete arrOfVoters;\n', '    delete arrOfBeautyIdMatchedVoters;\n', '    readyTime = uint32(now + restartTime);\n', '    votingStart = true;\n', '  }\n', '  function getRestarTime() public view returns (uint32) {\n', '    return restartTime;\n', '  }\n', '\n', '  function getVotingStatus() public view returns (bool) {\n', '    return votingStart;\n', '  }\n', '\n', '  function getVotePrice() public view returns (uint256) {\n', '    return votePrice;\n', '  }\n', '\n', '  /* Util */\n', '  function isContract(address addr) internal view returns (bool) {\n', '    uint size;\n', '    assembly { size := extcodesize(addr) } // solium-disable-line\n', '    return size > 0;\n', '  }\n', '}']
