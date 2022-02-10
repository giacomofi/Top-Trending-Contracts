['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  function() public payable { }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '   /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract ESCBAirdropper is Ownable {\n', '    using SafeMath for uint256;\n', '    uint256 public airdropTokens;\n', '    uint256 public totalClaimed;\n', '    uint256 public amountOfTokens;\n', '    mapping (address => bool) public tokensReceived;\n', '    mapping (address => bool) public craneList;\n', '    mapping (address => bool) public airdropAgent;\n', '    ERC20 public token;\n', '    bool public craneEnabled = false;\n', '\n', '    modifier onlyAirdropAgent() {\n', '        require(airdropAgent[msg.sender]);\n', '         _;\n', '    }\n', '\n', '    modifier whenCraneEnabled() {\n', '        require(craneEnabled);\n', '         _;\n', '    }\n', '\n', '    function ESCBAirdropper(uint256 _amount, address _tokenAddress) public {\n', '        totalClaimed = 0;\n', '        amountOfTokens = _amount;\n', '        token = ERC20(_tokenAddress);\n', '    }\n', '\n', '    // Send a static number of tokens to each user in an array (e.g. each user receives 100 tokens)\n', '    function airdrop(address[] _recipients) public onlyAirdropAgent {\n', '        for (uint256 i = 0; i < _recipients.length; i++) {\n', '            require(!tokensReceived[_recipients[i]]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.\n', '            require(token.transfer(_recipients[i], amountOfTokens));\n', '            tokensReceived[_recipients[i]] = true;\n', '        }\n', '        totalClaimed = totalClaimed.add(amountOfTokens * _recipients.length);\n', '    }\n', '\n', '    // Send a dynamic number of tokens to each user in an array (e.g. each user receives 10% of their original contribution)\n', '    function airdropDynamic(address[] _recipients, uint256[] _amount) public onlyAirdropAgent {\n', '        for (uint256 i = 0; i < _recipients.length; i++) {\n', '            require(!tokensReceived[_recipients[i]]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.\n', '            require(token.transfer(_recipients[i], _amount[i]));\n', '            tokensReceived[_recipients[i]] = true;\n', '            totalClaimed = totalClaimed.add(_amount[i]);\n', '        }\n', '    }\n', '\n', '    // Allow this agent to call the airdrop functions\n', '    function setAirdropAgent(address _agentAddress, bool state) public onlyOwner {\n', '        airdropAgent[_agentAddress] = state;\n', '    }\n', '\n', '    // Return any unused tokens back to the contract owner\n', '    function reset() public onlyOwner {\n', '        require(token.transfer(owner, remainingTokens()));\n', '    }\n', '\n', '    // Change the ERC20 token address\n', '    function changeTokenAddress(address _tokenAddress) public onlyOwner {\n', '        token = ERC20(_tokenAddress);\n', '    }\n', '\n', '    // Set the amount of tokens to send each user for a static airdrop\n', '    function changeTokenAmount(uint256 _amount) public onlyOwner {\n', '        amountOfTokens = _amount;\n', '    }\n', '\n', '    // Enable or disable crane\n', '    function changeCraneStatus(bool _status) public onlyOwner {\n', '        craneEnabled = _status;\n', '    }\n', '\n', '    // Return the amount of tokens that the contract currently holds\n', '    function remainingTokens() public view returns (uint256) {\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    // Add recipient in crane list\n', '    function addAddressToCraneList(address[] _recipients) public onlyAirdropAgent {\n', '        for (uint256 i = 0; i < _recipients.length; i++) {\n', '            require(!tokensReceived[_recipients[i]]); // If not received yet\n', '            require(!craneList[_recipients[i]]);\n', '            craneList[_recipients[i]] = true;\n', '        }\n', '    }\n', '\n', '    // Get free tokens by crane\n', '    function getFreeTokens() public\n', '      whenCraneEnabled\n', '    {\n', '        require(craneList[msg.sender]);\n', '        require(!tokensReceived[msg.sender]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.\n', '        require(token.transfer(msg.sender, amountOfTokens));\n', '        tokensReceived[msg.sender] = true;\n', '        totalClaimed = totalClaimed.add(amountOfTokens);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  function() public payable { }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '   /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract ESCBAirdropper is Ownable {\n', '    using SafeMath for uint256;\n', '    uint256 public airdropTokens;\n', '    uint256 public totalClaimed;\n', '    uint256 public amountOfTokens;\n', '    mapping (address => bool) public tokensReceived;\n', '    mapping (address => bool) public craneList;\n', '    mapping (address => bool) public airdropAgent;\n', '    ERC20 public token;\n', '    bool public craneEnabled = false;\n', '\n', '    modifier onlyAirdropAgent() {\n', '        require(airdropAgent[msg.sender]);\n', '         _;\n', '    }\n', '\n', '    modifier whenCraneEnabled() {\n', '        require(craneEnabled);\n', '         _;\n', '    }\n', '\n', '    function ESCBAirdropper(uint256 _amount, address _tokenAddress) public {\n', '        totalClaimed = 0;\n', '        amountOfTokens = _amount;\n', '        token = ERC20(_tokenAddress);\n', '    }\n', '\n', '    // Send a static number of tokens to each user in an array (e.g. each user receives 100 tokens)\n', '    function airdrop(address[] _recipients) public onlyAirdropAgent {\n', '        for (uint256 i = 0; i < _recipients.length; i++) {\n', '            require(!tokensReceived[_recipients[i]]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.\n', '            require(token.transfer(_recipients[i], amountOfTokens));\n', '            tokensReceived[_recipients[i]] = true;\n', '        }\n', '        totalClaimed = totalClaimed.add(amountOfTokens * _recipients.length);\n', '    }\n', '\n', '    // Send a dynamic number of tokens to each user in an array (e.g. each user receives 10% of their original contribution)\n', '    function airdropDynamic(address[] _recipients, uint256[] _amount) public onlyAirdropAgent {\n', '        for (uint256 i = 0; i < _recipients.length; i++) {\n', '            require(!tokensReceived[_recipients[i]]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.\n', '            require(token.transfer(_recipients[i], _amount[i]));\n', '            tokensReceived[_recipients[i]] = true;\n', '            totalClaimed = totalClaimed.add(_amount[i]);\n', '        }\n', '    }\n', '\n', '    // Allow this agent to call the airdrop functions\n', '    function setAirdropAgent(address _agentAddress, bool state) public onlyOwner {\n', '        airdropAgent[_agentAddress] = state;\n', '    }\n', '\n', '    // Return any unused tokens back to the contract owner\n', '    function reset() public onlyOwner {\n', '        require(token.transfer(owner, remainingTokens()));\n', '    }\n', '\n', '    // Change the ERC20 token address\n', '    function changeTokenAddress(address _tokenAddress) public onlyOwner {\n', '        token = ERC20(_tokenAddress);\n', '    }\n', '\n', '    // Set the amount of tokens to send each user for a static airdrop\n', '    function changeTokenAmount(uint256 _amount) public onlyOwner {\n', '        amountOfTokens = _amount;\n', '    }\n', '\n', '    // Enable or disable crane\n', '    function changeCraneStatus(bool _status) public onlyOwner {\n', '        craneEnabled = _status;\n', '    }\n', '\n', '    // Return the amount of tokens that the contract currently holds\n', '    function remainingTokens() public view returns (uint256) {\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    // Add recipient in crane list\n', '    function addAddressToCraneList(address[] _recipients) public onlyAirdropAgent {\n', '        for (uint256 i = 0; i < _recipients.length; i++) {\n', '            require(!tokensReceived[_recipients[i]]); // If not received yet\n', '            require(!craneList[_recipients[i]]);\n', '            craneList[_recipients[i]] = true;\n', '        }\n', '    }\n', '\n', '    // Get free tokens by crane\n', '    function getFreeTokens() public\n', '      whenCraneEnabled\n', '    {\n', '        require(craneList[msg.sender]);\n', '        require(!tokensReceived[msg.sender]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.\n', '        require(token.transfer(msg.sender, amountOfTokens));\n', '        tokensReceived[msg.sender] = true;\n', '        totalClaimed = totalClaimed.add(amountOfTokens);\n', '    }\n', '\n', '}']