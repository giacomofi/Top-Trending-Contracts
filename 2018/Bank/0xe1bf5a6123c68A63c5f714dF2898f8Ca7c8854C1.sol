['pragma solidity ^0.4.20;\n', '\n', 'contract Nine {\n', '  address public God;\n', '\n', '  function Nine() public {\n', '    God = msg.sender;\n', '  }\n', '\n', '  modifier onlyGod() {\n', '    require(msg.sender == God);\n', '    _;\n', '  }\n', '\n', '  function destroyTheUniverse () private {\n', '    selfdestruct(God);\n', '  }\n', '\n', '  address public agentAddress;\n', '  uint256 public nameValue = 10 finney;\n', '\n', '  function setAgent(address _newAgent) external onlyGod {\n', '    require(_newAgent != address(0));\n', '    agentAddress = _newAgent;\n', '  }\n', '\n', '  modifier onlyAgent() {\n', '    require(msg.sender == agentAddress);\n', '    _;\n', '  }\n', '\n', '  function withdrawBalance(uint256 amount) external onlyAgent {\n', '    msg.sender.transfer(amount <= 0 ? address(this).balance : amount);\n', '  }\n', '\n', '  function setNameValue(uint256 val) external onlyAgent {\n', '    nameValue = val;\n', '  }\n', '\n', '\n', '  string public constant name = "TheNineBillionNamesOfGod";\n', '  string public constant symbol = "NOG";\n', '  uint256 public constant totalSupply = 9000000000;\n', '\n', '  struct Name {\n', '    uint64 recordTime;\n', '  }\n', '\n', '\n', '  Name[] names;\n', '\n', '  mapping (uint256 => address) public nameIndexToOwner;\n', '\n', '  mapping (address => uint256) ownershipTokenCount;\n', '\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '  event Record(address owner, uint256 nameId);\n', '\n', '  function _transfer(address _from, address _to, uint256 _tokenId) internal {\n', '    ownershipTokenCount[_to]++;\n', '\n', '    nameIndexToOwner[_tokenId] = _to;\n', '\n', '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '    }\n', '\n', '    emit Transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  function _recordName(address _owner)\n', '    internal\n', '    returns (uint)\n', '  {\n', '    Name memory _name = Name({recordTime: uint64(now)});\n', '    uint256 newNameId = names.push(_name) - 1;\n', '\n', '    require(newNameId == uint256(uint32(newNameId)));\n', '\n', '    emit Record(_owner,newNameId);\n', '\n', '    _transfer(0, _owner, newNameId);\n', '\n', '    if (names.length == totalSupply) {\n', '      destroyTheUniverse();\n', '    }\n', '\n', '    return newNameId;\n', '  }\n', '\n', '  function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {\n', '    return nameIndexToOwner[_tokenId] == _claimant;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 count) {\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '\n', '  function transfer(\n', '                    address _to,\n', '                    uint256 _tokenId\n', '                    )\n', '    external\n', '  {\n', '    require(_to != address(0));\n', '\n', '    require(_to != address(this));\n', '\n', '    require(_owns(msg.sender, _tokenId));\n', '\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '\n', '  function recordNameCount() public view returns (uint) {\n', '    return names.length;\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId)\n', '    external\n', '    view\n', '    returns (address owner)\n', '  {\n', '    owner = nameIndexToOwner[_tokenId];\n', '\n', '    require(owner != address(0));\n', '  }\n', '\n', '  function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '\n', '    if (tokenCount == 0) {\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalRecord = recordNameCount();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 nId;\n', '\n', '      for (nId = 1; nId < totalRecord; nId++) {\n', '        if (nameIndexToOwner[nId] == _owner) {\n', '          result[resultIndex] = nId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '\n', '      return result;\n', '    }\n', '  }\n', '\n', '\n', '  function getName(uint256 _id)\n', '    external\n', '    view\n', '    returns (uint256 recordTime) {\n', '    recordTime = uint256(names[_id].recordTime);\n', '  }\n', '\n', '  function tryToRecord(address _sender, uint256 _value) internal {\n', '    uint times = _value / nameValue;\n', '    for (uint i = 0; i < times; i++) {\n', '      _recordName(_sender);\n', '    }\n', '  }\n', '\n', '  function recordName() external payable {\n', '    tryToRecord(msg.sender, msg.value);\n', '  }\n', '\n', '  function() external payable {\n', '    tryToRecord(msg.sender, msg.value);\n', '  }\n', '}']