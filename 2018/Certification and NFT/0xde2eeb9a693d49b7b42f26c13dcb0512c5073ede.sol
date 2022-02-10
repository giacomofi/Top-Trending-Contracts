['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', '//\n', '// Funds Gateway contract\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Owned {\n', '\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '\n', '  event OwnershipTransferProposed(address indexed _from, address indexed _to);\n', '  event OwnershipTransferConfirmed(address indexed _from, address indexed _to);\n', '\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  constructor() public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  function transferOwnership(address _newOwner) onlyOwner public{\n', '    require(_newOwner != owner);\n', '    emit OwnershipTransferProposed(owner, _newOwner);\n', '    newOwner = _newOwner;\n', '  }\n', '\n', '\n', '  function confirmOwnership() public{\n', '    assert(msg.sender == newOwner);\n', '    emit OwnershipTransferConfirmed(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '  //from ERC20 standard\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', 'contract Gateway is Owned {\n', '\n', '  address public targetWallet;\n', '  address public whitelistWallet;\n', '\n', '\n', '  bool public gatewayOpened = false;\n', '\n', '    \n', '  mapping(address => bool) public whitelist;\n', '\n', '  \n', '  event TargetWalletUpdated(address _newWallet);\n', '  event WhitelistWalletUpdated(address _newWhitelistWallet);\n', '  event GatewayStatusUpdated(bool _status);\n', '  event WhitelistUpdated(address indexed _participant, bool _status);\n', '  event PassedGateway(address _participant, uint _value);\n', '  \n', '\n', '  constructor() public{\n', '    targetWallet = owner;\n', '    whitelistWallet = owner;\n', '    newOwner = address(0x0);\n', '  }\n', '\n', '  \n', '  function () payable public{\n', '    passGateway();\n', '  }\n', '\n', '\n', '  function addToWhitelist(address _participant) external{\n', '    require(msg.sender == whitelistWallet || msg.sender == owner);\n', '    whitelist[_participant] = true;\n', '    emit WhitelistUpdated(_participant, true);\n', '  }  \n', '\n', '\n', '  function addToWhitelistMultiple(address[] _participants) external{\n', '    require(msg.sender == whitelistWallet || msg.sender == owner);\n', '    for (uint i = 0; i < _participants.length; i++) {\n', '      whitelist[_participants[i]] = true;\n', '      emit WhitelistUpdated(_participants[i], true);\n', '    }\n', '  }\n', '\n', '\n', '  function removeFromWhitelist(address _participant) external{\n', '    require(msg.sender == whitelistWallet || msg.sender == owner);\n', '    whitelist[_participant] = false;\n', '    emit WhitelistUpdated(_participant, false);\n', '  }  \n', '\n', '\n', '  function removeFromWhitelistMultiple(address[] _participants) external{\n', '    require(msg.sender == whitelistWallet || msg.sender == owner);\n', '    for (uint i = 0; i < _participants.length; i++) {\n', '      whitelist[_participants[i]] = false;\n', '      emit WhitelistUpdated(_participants[i], false);\n', '    }\n', '  }\n', '\n', '\n', '  function setTargetWallet(address _wallet) onlyOwner external{\n', '    require(_wallet != address(0x0));\n', '    targetWallet = _wallet;\n', '    emit TargetWalletUpdated(_wallet);\n', '  }\n', '  \n', '\n', '  function setWhitelistWallet(address _wallet) onlyOwner external{\n', '    whitelistWallet = _wallet;\n', '    emit WhitelistWalletUpdated(_wallet);\n', '  }\n', '\n', '\n', '  function openGateway() onlyOwner external{\n', '    require(!gatewayOpened);\n', '    gatewayOpened = true;\n', '    \n', '    emit GatewayStatusUpdated(true);\n', '  }\n', '\n', '\n', '  function closeGateway() onlyOwner external{\n', '    require(gatewayOpened);\n', '    gatewayOpened = false;\n', '    \n', '    emit GatewayStatusUpdated(false);\n', '  }\n', '\n', '\n', '  function passGateway() private{\n', '\n', '    require(gatewayOpened);\n', '    require(whitelist[msg.sender]);\n', '\n', '\t  // sends Eth forward; covers edge case of mining/selfdestructing Eth to the contract address\n', '\t  // note: address uses a different "transfer" than ERC20.\n', '    address(targetWallet).transfer(address(this).balance);\n', '\n', '    // log event\n', '    emit PassedGateway(msg.sender, msg.value);\n', '  }\n', '  \n', '  \n', '  \n', '      \n', '  //from ERC20 standard\n', '  //Used if someone sends tokens to the bouncer contract.\n', '  function transferAnyERC20Token(\n', '    address tokenAddress,\n', '    uint256 tokens\n', '  )\n', '    public\n', '    onlyOwner\n', '    returns (bool success)\n', '  {\n', '    return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '  }\n', '  \n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', '//\n', '// Funds Gateway contract\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Owned {\n', '\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '\n', '  event OwnershipTransferProposed(address indexed _from, address indexed _to);\n', '  event OwnershipTransferConfirmed(address indexed _from, address indexed _to);\n', '\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  constructor() public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  function transferOwnership(address _newOwner) onlyOwner public{\n', '    require(_newOwner != owner);\n', '    emit OwnershipTransferProposed(owner, _newOwner);\n', '    newOwner = _newOwner;\n', '  }\n', '\n', '\n', '  function confirmOwnership() public{\n', '    assert(msg.sender == newOwner);\n', '    emit OwnershipTransferConfirmed(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '  //from ERC20 standard\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', 'contract Gateway is Owned {\n', '\n', '  address public targetWallet;\n', '  address public whitelistWallet;\n', '\n', '\n', '  bool public gatewayOpened = false;\n', '\n', '    \n', '  mapping(address => bool) public whitelist;\n', '\n', '  \n', '  event TargetWalletUpdated(address _newWallet);\n', '  event WhitelistWalletUpdated(address _newWhitelistWallet);\n', '  event GatewayStatusUpdated(bool _status);\n', '  event WhitelistUpdated(address indexed _participant, bool _status);\n', '  event PassedGateway(address _participant, uint _value);\n', '  \n', '\n', '  constructor() public{\n', '    targetWallet = owner;\n', '    whitelistWallet = owner;\n', '    newOwner = address(0x0);\n', '  }\n', '\n', '  \n', '  function () payable public{\n', '    passGateway();\n', '  }\n', '\n', '\n', '  function addToWhitelist(address _participant) external{\n', '    require(msg.sender == whitelistWallet || msg.sender == owner);\n', '    whitelist[_participant] = true;\n', '    emit WhitelistUpdated(_participant, true);\n', '  }  \n', '\n', '\n', '  function addToWhitelistMultiple(address[] _participants) external{\n', '    require(msg.sender == whitelistWallet || msg.sender == owner);\n', '    for (uint i = 0; i < _participants.length; i++) {\n', '      whitelist[_participants[i]] = true;\n', '      emit WhitelistUpdated(_participants[i], true);\n', '    }\n', '  }\n', '\n', '\n', '  function removeFromWhitelist(address _participant) external{\n', '    require(msg.sender == whitelistWallet || msg.sender == owner);\n', '    whitelist[_participant] = false;\n', '    emit WhitelistUpdated(_participant, false);\n', '  }  \n', '\n', '\n', '  function removeFromWhitelistMultiple(address[] _participants) external{\n', '    require(msg.sender == whitelistWallet || msg.sender == owner);\n', '    for (uint i = 0; i < _participants.length; i++) {\n', '      whitelist[_participants[i]] = false;\n', '      emit WhitelistUpdated(_participants[i], false);\n', '    }\n', '  }\n', '\n', '\n', '  function setTargetWallet(address _wallet) onlyOwner external{\n', '    require(_wallet != address(0x0));\n', '    targetWallet = _wallet;\n', '    emit TargetWalletUpdated(_wallet);\n', '  }\n', '  \n', '\n', '  function setWhitelistWallet(address _wallet) onlyOwner external{\n', '    whitelistWallet = _wallet;\n', '    emit WhitelistWalletUpdated(_wallet);\n', '  }\n', '\n', '\n', '  function openGateway() onlyOwner external{\n', '    require(!gatewayOpened);\n', '    gatewayOpened = true;\n', '    \n', '    emit GatewayStatusUpdated(true);\n', '  }\n', '\n', '\n', '  function closeGateway() onlyOwner external{\n', '    require(gatewayOpened);\n', '    gatewayOpened = false;\n', '    \n', '    emit GatewayStatusUpdated(false);\n', '  }\n', '\n', '\n', '  function passGateway() private{\n', '\n', '    require(gatewayOpened);\n', '    require(whitelist[msg.sender]);\n', '\n', '\t  // sends Eth forward; covers edge case of mining/selfdestructing Eth to the contract address\n', '\t  // note: address uses a different "transfer" than ERC20.\n', '    address(targetWallet).transfer(address(this).balance);\n', '\n', '    // log event\n', '    emit PassedGateway(msg.sender, msg.value);\n', '  }\n', '  \n', '  \n', '  \n', '      \n', '  //from ERC20 standard\n', '  //Used if someone sends tokens to the bouncer contract.\n', '  function transferAnyERC20Token(\n', '    address tokenAddress,\n', '    uint256 tokens\n', '  )\n', '    public\n', '    onlyOwner\n', '    returns (bool success)\n', '  {\n', '    return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '  }\n', '  \n', '}']