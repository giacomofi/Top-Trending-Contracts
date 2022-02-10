['pragma solidity ^0.4.24;\n', '\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value) external returns (bool);\n', '}\n', '\n', 'contract onlyOwner {\n', '  address public owner;\n', '    bool private stopped = false;\n', '  /** \n', '  * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '  * account.\n', '  */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '\n', '  }\n', '    \n', '    modifier isRunning {\n', '        require(!stopped);\n', '        _;\n', '    }\n', '    \n', '    function stop() isOwner public {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() isOwner public {\n', '        stopped = false;\n', '    }\n', '  /**\n', '  * @dev Throws if called by any account other than the owner. \n', '  */\n', '  modifier isOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract AirDrop is onlyOwner{\n', '\n', '  Token token;\n', '\n', '  event TransferredToken(address indexed to, uint256 value);\n', '\n', '\n', '  constructor() public{\n', '      address _tokenAddr = 0x99092a458b405fb8c06c5a3aa01cffd826019568; //here pass address of your token\n', '      token = Token(_tokenAddr);\n', '  }\n', '\n', '    function() external payable{\n', '        withdraw();\n', '    }\n', '    \n', '    \n', '  function sendInternally(uint256 tokensToSend, uint256 valueToPresent) internal {\n', '    require(msg.sender != address(0));\n', '    token.transfer(msg.sender, tokensToSend);\n', '    emit TransferredToken(msg.sender, valueToPresent);\n', '    \n', '  }\n', '\n', '  function withdraw() isRunning private returns(bool) {\n', '    sendInternally(400*10**18,400);\n', '    return true;   \n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value) external returns (bool);\n', '}\n', '\n', 'contract onlyOwner {\n', '  address public owner;\n', '    bool private stopped = false;\n', '  /** \n', '  * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '  * account.\n', '  */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '\n', '  }\n', '    \n', '    modifier isRunning {\n', '        require(!stopped);\n', '        _;\n', '    }\n', '    \n', '    function stop() isOwner public {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() isOwner public {\n', '        stopped = false;\n', '    }\n', '  /**\n', '  * @dev Throws if called by any account other than the owner. \n', '  */\n', '  modifier isOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract AirDrop is onlyOwner{\n', '\n', '  Token token;\n', '\n', '  event TransferredToken(address indexed to, uint256 value);\n', '\n', '\n', '  constructor() public{\n', '      address _tokenAddr = 0x99092a458b405fb8c06c5a3aa01cffd826019568; //here pass address of your token\n', '      token = Token(_tokenAddr);\n', '  }\n', '\n', '    function() external payable{\n', '        withdraw();\n', '    }\n', '    \n', '    \n', '  function sendInternally(uint256 tokensToSend, uint256 valueToPresent) internal {\n', '    require(msg.sender != address(0));\n', '    token.transfer(msg.sender, tokensToSend);\n', '    emit TransferredToken(msg.sender, valueToPresent);\n', '    \n', '  }\n', '\n', '  function withdraw() isRunning private returns(bool) {\n', '    sendInternally(400*10**18,400);\n', '    return true;   \n', '  }\n', '}']
