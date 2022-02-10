['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) pure internal  returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) pure internal  returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) pure internal  returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) pure internal  returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/Token.sol\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'pragma solidity ^0.4.8;\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '    address public sale;\n', '    bool public transfersAllowed;\n', '    \n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// File: contracts/Disbursement.sol\n', '\n', '// NOTE: ORIGINALLY THIS WAS "TOKENS/ABSTRACTTOKEN.SOL"... CHECK THAT\n', '\n', '\n', '/// @title Disbursement contract - allows to distribute tokens over time\n', '/// @author Stefan George - <stefan@gnosis.pm>\n', 'contract Disbursement {\n', '\n', '    /*\n', '     *  Storage\n', '     */\n', '    address public owner;\n', '    address public receiver;\n', '    uint public disbursementPeriod;\n', '    uint public startDate;\n', '    uint public withdrawnTokens;\n', '    Token public token;\n', '\n', '    /*\n', '     *  Modifiers\n', '     */\n', '    modifier isOwner() {\n', '        if (msg.sender != owner)\n', '            // Only owner is allowed to proceed\n', '            revert();\n', '        _;\n', '    }\n', '\n', '    modifier isReceiver() {\n', '        if (msg.sender != receiver)\n', '            // Only receiver is allowed to proceed\n', '            revert();\n', '        _;\n', '    }\n', '\n', '    modifier isSetUp() {\n', '        if (address(token) == 0)\n', '            // Contract is not set up\n', '            revert();\n', '        _;\n', '    }\n', '\n', '    /*\n', '     *  Public functions\n', '     */\n', '    /// @dev Constructor function sets contract owner\n', '    /// @param _receiver Receiver of vested tokens\n', '    /// @param _disbursementPeriod Vesting period in seconds\n', '    /// @param _startDate Start date of disbursement period (cliff)\n', '    function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)\n', '        public\n', '    {\n', '        if (_receiver == 0 || _disbursementPeriod == 0)\n', '            // Arguments are null\n', '            revert();\n', '        owner = msg.sender;\n', '        receiver = _receiver;\n', '        disbursementPeriod = _disbursementPeriod;\n', '        startDate = _startDate;\n', '        if (startDate == 0)\n', '            startDate = now;\n', '    }\n', '\n', "    /// @dev Setup function sets external contracts' addresses\n", '    /// @param _token Token address\n', '    function setup(Token _token)\n', '        public\n', '        isOwner\n', '    {\n', '        if (address(token) != 0 || address(_token) == 0)\n', '            // Setup was executed already or address is null\n', '            revert();\n', '        token = _token;\n', '    }\n', '\n', '    /// @dev Transfers tokens to a given address\n', '    /// @param _to Address of token receiver\n', '    /// @param _value Number of tokens to transfer\n', '    function withdraw(address _to, uint256 _value)\n', '        public\n', '        isReceiver\n', '        isSetUp\n', '    {\n', '        uint maxTokens = calcMaxWithdraw();\n', '        if (_value > maxTokens)\n', '            revert();\n', '        withdrawnTokens = SafeMath.add(withdrawnTokens, _value);\n', '        token.transfer(_to, _value);\n', '    }\n', '\n', '    /// @dev Calculates the maximum amount of vested tokens\n', '    /// @return Number of vested tokens to withdraw\n', '    function calcMaxWithdraw()\n', '        public\n', '        constant\n', '        returns (uint)\n', '    {\n', '        uint maxTokens = SafeMath.mul(SafeMath.add(token.balanceOf(this), withdrawnTokens), SafeMath.sub(now,startDate)) / disbursementPeriod;\n', '        //uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;\n', '        if (withdrawnTokens >= maxTokens || startDate > now)\n', '            return 0;\n', '        if (SafeMath.sub(maxTokens, withdrawnTokens) > token.totalSupply())\n', '            return token.totalSupply();\n', '        return SafeMath.sub(maxTokens, withdrawnTokens);\n', '    }\n', '}\n', '\n', '// File: contracts/Owned.sol\n', '\n', 'contract Owned {\n', '  event OwnerAddition(address indexed owner);\n', '\n', '  event OwnerRemoval(address indexed owner);\n', '\n', '  // owner address to enable admin functions\n', '  mapping (address => bool) public isOwner;\n', '\n', '  address[] public owners;\n', '\n', '  address public operator;\n', '\n', '  modifier onlyOwner {\n', '\n', '    require(isOwner[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  modifier onlyOperator {\n', '    require(msg.sender == operator);\n', '    _;\n', '  }\n', '\n', '  function setOperator(address _operator) external onlyOwner {\n', '    require(_operator != address(0));\n', '    operator = _operator;\n', '  }\n', '\n', '  function removeOwner(address _owner) public onlyOwner {\n', '    require(owners.length > 1);\n', '    isOwner[_owner] = false;\n', '    for (uint i = 0; i < owners.length - 1; i++) {\n', '      if (owners[i] == _owner) {\n', '        owners[i] = owners[SafeMath.sub(owners.length, 1)];\n', '        break;\n', '      }\n', '    }\n', '    owners.length = SafeMath.sub(owners.length, 1);\n', '    OwnerRemoval(_owner);\n', '  }\n', '\n', '  function addOwner(address _owner) external onlyOwner {\n', '    require(_owner != address(0));\n', '    if(isOwner[_owner]) return;\n', '    isOwner[_owner] = true;\n', '    owners.push(_owner);\n', '    OwnerAddition(_owner);\n', '  }\n', '\n', '  function setOwners(address[] _owners) internal {\n', '    for (uint i = 0; i < _owners.length; i++) {\n', '      require(_owners[i] != address(0));\n', '      isOwner[_owners[i]] = true;\n', '      OwnerAddition(_owners[i]);\n', '    }\n', '    owners = _owners;\n', '  }\n', '\n', '  function getOwners() public constant returns (address[])  {\n', '    return owners;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/TokenLock.sol\n', '\n', '/**\n', 'this contract should be the address for disbursement contract.\n', 'It should not allow to disburse any token for a given time "initialLockTime"\n', 'lock "50%" of tokens for 10 years.\n', 'transfer 50% of tokens to a given address.\n', '*/\n', 'contract TokenLock is Owned {\n', '  using SafeMath for uint;\n', '\n', '  uint public shortLock;\n', '\n', '  uint public longLock;\n', '\n', '  uint public shortShare;\n', '\n', '  address public levAddress;\n', '\n', '  address public disbursement;\n', '\n', '  uint public longTermTokens;\n', '\n', '  modifier validAddress(address _address){\n', '    require(_address != 0);\n', '    _;\n', '  }\n', '\n', '  function TokenLock(address[] _owners, uint _shortLock, uint _longLock, uint _shortShare) public {\n', '    require(_longLock > _shortLock);\n', '    require(_shortLock > 0);\n', '    require(_shortShare <= 100);\n', '    setOwners(_owners);\n', '    shortLock = block.timestamp.add(_shortLock);\n', '    longLock = block.timestamp.add(_longLock);\n', '    shortShare = _shortShare;\n', '  }\n', '\n', '  function setup(address _disbursement, address _levToken) public onlyOwner {\n', '    require(_disbursement != address(0));\n', '    require(_levToken != address(0));\n', '    disbursement = _disbursement;\n', '    levAddress = _levToken;\n', '  }\n', '\n', '  function transferShortTermTokens(address _wallet) public validAddress(_wallet) onlyOwner {\n', '    require(now > shortLock);\n', '    uint256 tokenBalance = Token(levAddress).balanceOf(disbursement);\n', '    // long term tokens can be set only once.\n', '    if (longTermTokens == 0) {\n', '      longTermTokens = tokenBalance.mul(100 - shortShare).div(100);\n', '    }\n', '    require(tokenBalance > longTermTokens);\n', '    uint256 amountToSend = tokenBalance.sub(longTermTokens);\n', '    Disbursement(disbursement).withdraw(_wallet, amountToSend);\n', '  }\n', '\n', '  function transferLongTermTokens(address _wallet) public validAddress(_wallet) onlyOwner {\n', '    require(now > longLock);\n', '    // 1. Get how many tokens this contract has with a token instance and check this token balance\n', '    uint256 tokenBalance = Token(levAddress).balanceOf(disbursement);\n', '\n', '    // 2. Transfer those tokens with the _shortShare percentage\n', '    Disbursement(disbursement).withdraw(_wallet, tokenBalance);\n', '  }\n', '}']