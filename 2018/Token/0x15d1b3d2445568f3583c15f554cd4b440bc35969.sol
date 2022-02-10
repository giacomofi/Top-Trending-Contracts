['pragma solidity ^0.4.24;\n', '\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value) external returns (bool);\n', '}\n', '\n', 'contract onlyOwner {\n', '  address public owner;\n', '  /** \n', '  * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '  * account.\n', '  */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '\n', '  }\n', '  modifier isOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract Campaigns is onlyOwner{\n', '\n', '  Token token;\n', '  event TransferredToken(address indexed to, uint256 value);\n', '\n', '\n', '  constructor(address _contract) public{\n', '      address _tokenAddr = _contract; //here pass address of your token\n', '      token = Token(_tokenAddr);\n', '  }\n', '\n', '\n', '    function sendResidualAmount(uint256 value) isOwner public returns(bool){\n', '        token.transfer(owner, value*10**18);\n', '        emit TransferredToken(msg.sender, value);\n', '        return true;\n', '    }    \n', '    \n', '    function sendAmount(address[] _user, uint256 value) isOwner public returns(bool){\n', '        for(uint i=0; i<_user.length; i++)\n', '        token.transfer(_user[i], value*10**18);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction sendIndividualAmount(address[] _user, uint256[] value) isOwner public returns(bool){\n', '        for(uint i=0; i<_user.length; i++)\n', '        token.transfer(_user[i], value[i]*10**18);\n', '        return true;\n', '    }\n', '  \n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value) external returns (bool);\n', '}\n', '\n', 'contract onlyOwner {\n', '  address public owner;\n', '  /** \n', '  * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '  * account.\n', '  */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '\n', '  }\n', '  modifier isOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract Campaigns is onlyOwner{\n', '\n', '  Token token;\n', '  event TransferredToken(address indexed to, uint256 value);\n', '\n', '\n', '  constructor(address _contract) public{\n', '      address _tokenAddr = _contract; //here pass address of your token\n', '      token = Token(_tokenAddr);\n', '  }\n', '\n', '\n', '    function sendResidualAmount(uint256 value) isOwner public returns(bool){\n', '        token.transfer(owner, value*10**18);\n', '        emit TransferredToken(msg.sender, value);\n', '        return true;\n', '    }    \n', '    \n', '    function sendAmount(address[] _user, uint256 value) isOwner public returns(bool){\n', '        for(uint i=0; i<_user.length; i++)\n', '        token.transfer(_user[i], value*10**18);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction sendIndividualAmount(address[] _user, uint256[] value) isOwner public returns(bool){\n', '        for(uint i=0; i<_user.length; i++)\n', '        token.transfer(_user[i], value[i]*10**18);\n', '        return true;\n', '    }\n', '  \n', '}']
