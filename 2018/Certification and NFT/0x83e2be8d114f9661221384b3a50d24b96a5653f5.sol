['pragma solidity ^0.4.24;\n', '\n', '// File: @0xcert/ethereum-erc20/contracts/tokens/ERC20.sol\n', '\n', '/**\n', ' * @title A standard interface for tokens.\n', ' */\n', 'interface ERC20 {\n', '\n', '  /**\n', '   * @dev Returns the name of the token.\n', '   */\n', '  function name()\n', '    external\n', '    view\n', '    returns (string _name);\n', '\n', '  /**\n', '   * @dev Returns the symbol of the token.\n', '   */\n', '  function symbol()\n', '    external\n', '    view\n', '    returns (string _symbol);\n', '\n', '  /**\n', '   * @dev Returns the number of decimals the token uses.\n', '   */\n', '  function decimals()\n', '    external\n', '    view\n', '    returns (uint8 _decimals);\n', '\n', '  /**\n', '   * @dev Returns the total token supply.\n', '   */\n', '  function totalSupply()\n', '    external\n', '    view\n', '    returns (uint256 _totalSupply);\n', '\n', '  /**\n', '   * @dev Returns the account balance of another account with address _owner.\n', '   * @param _owner The address from which the balance will be retrieved.\n', '   */\n', '  function balanceOf(\n', '    address _owner\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _balance);\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The\n', '   * function SHOULD throw if the _from account balance does not have enough tokens to spend.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the\n', '   * Transfer event.\n', '   * @param _from The address of the sender.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Allows _spender to withdraw from your account multiple times, up to\n', '   * the _value amount. If this function is called again it overwrites the current\n', '   * allowance with _value.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   * @param _value The amount of tokens to be approved for transfer.\n', '   */\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Returns the amount which _spender is still allowed to withdraw from _owner.\n', '   * @param _owner The address of the account owning tokens.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _remaining);\n', '\n', '  /**\n', '   * @dev Triggers when tokens are transferred, including zero value transfers.\n', '   */\n', '  event Transfer(\n', '    address indexed _from,\n', '    address indexed _to,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Triggers on any successful call to approve(address _spender, uint256 _value).\n', '   */\n', '  event Approval(\n', '    address indexed _owner,\n', '    address indexed _spender,\n', '    uint256 _value\n', '  );\n', '\n', '}\n', '\n', '// File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @dev Math operations with safety checks that throw on error. This contract is based\n', ' * on the source code at https://goo.gl/iyQsmU.\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '   * @dev Multiplies two numbers, throws on overflow.\n', '   * @param _a Factor number.\n', '   * @param _b Factor number.\n', '   */\n', '  function mul(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Integer division of two numbers, truncating the quotient.\n', '   * @param _a Dividend number.\n', '   * @param _b Divisor number.\n', '   */\n', '  function div(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    uint256 c = _a / _b;\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   * @param _a Minuend number.\n', '   * @param _b Subtrahend number.\n', '   */\n', '  function sub(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   * @param _a Number.\n', '   * @param _b Number.\n', '   */\n', '  function add(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    uint256 c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '// File: @0xcert/ethereum-erc20/contracts/tokens/Token.sol\n', '\n', '/**\n', ' * @title ERC20 standard token implementation.\n', ' * @dev Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.\n', ' */\n', 'contract Token is\n', '  ERC20\n', '{\n', '  using SafeMath for uint256;\n', '\n', '  /**\n', '   * Token name.\n', '   */\n', '  string internal tokenName;\n', '\n', '  /**\n', '   * Token symbol.\n', '   */\n', '  string internal tokenSymbol;\n', '\n', '  /**\n', '   * Number of decimals.\n', '   */\n', '  uint8 internal tokenDecimals;\n', '\n', '  /**\n', '   * Total supply of tokens.\n', '   */\n', '  uint256 internal tokenTotalSupply;\n', '\n', '  /**\n', '   * Balance information map.\n', '   */\n', '  mapping (address => uint256) internal balances;\n', '\n', '  /**\n', '   * Token allowance mapping.\n', '   */\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /**\n', '   * @dev Trigger when tokens are transferred, including zero value transfers.\n', '   */\n', '  event Transfer(\n', '    address indexed _from,\n', '    address indexed _to,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Trigger on any successful call to approve(address _spender, uint256 _value).\n', '   */\n', '  event Approval(\n', '    address indexed _owner,\n', '    address indexed _spender,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Returns the name of the token.\n', '   */\n', '  function name()\n', '    external\n', '    view\n', '    returns (string _name)\n', '  {\n', '    _name = tokenName;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the symbol of the token.\n', '   */\n', '  function symbol()\n', '    external\n', '    view\n', '    returns (string _symbol)\n', '  {\n', '    _symbol = tokenSymbol;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the number of decimals the token uses.\n', '   */\n', '  function decimals()\n', '    external\n', '    view\n', '    returns (uint8 _decimals)\n', '  {\n', '    _decimals = tokenDecimals;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the total token supply.\n', '   */\n', '  function totalSupply()\n', '    external\n', '    view\n', '    returns (uint256 _totalSupply)\n', '  {\n', '    _totalSupply = tokenTotalSupply;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the account balance of another account with address _owner.\n', '   * @param _owner The address from which the balance will be retrieved.\n', '   */\n', '  function balanceOf(\n', '    address _owner\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _balance)\n', '  {\n', '    _balance = balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The\n', '   * function SHOULD throw if the _from account balance does not have enough tokens to spend.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    _success = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If\n', '   * this function is called again it overwrites the current allowance with _value.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   * @param _value The amount of tokens to be approved for transfer.\n', '   */\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '\n', '    emit Approval(msg.sender, _spender, _value);\n', '    _success = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the amount which _spender is still allowed to withdraw from _owner.\n', '   * @param _owner The address of the account owning tokens.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _remaining)\n', '  {\n', '    _remaining = allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the\n', '   * Transfer event.\n', '   * @param _from The address of the sender.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '    _success = true;\n', '  }\n', '\n', '}\n', '\n', '// File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @dev The contract has an owner address, and provides basic authorization control whitch\n', ' * simplifies the implementation of user permissions. This contract is based on the source code\n', ' * at https://goo.gl/n2ZGVt.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev An event which is triggered when the owner is changed.\n', '   * @param previousOwner The address of the previous owner.\n', '   * @param newOwner The address of the new owner.\n', '   */\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  constructor()\n', '    public\n', '  {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(\n', '    address _newOwner\n', '  )\n', '    onlyOwner\n', '    public\n', '  {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: @0xcert/ethereum-utils/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @dev The contract has an owner address, and provides basic authorization control whitch\n', ' * simplifies the implementation of user permissions. This contract is based on the source code\n', ' * at goo.gl/CfEAkv and upgrades Ownable contracts with additional claim step which makes ownership\n', ' * transfers less prone to errors.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev An event which is triggered when the owner is changed.\n', '   * @param previousOwner The address of the previous owner.\n', '   * @param newOwner The address of the new owner.\n', '   */\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev Allows the current owner to give new owner ability to claim the ownership of the contract.\n', '   * This differs from the Owner&#39;s function in that it allows setting pedingOwner address to 0x0,\n', '   * which effectively cancels an active claim.\n', '   * @param _newOwner The address which can claim ownership of the contract.\n', '   */\n', '  function transferOwnership(\n', '    address _newOwner\n', '  )\n', '    onlyOwner\n', '    public\n', '  {\n', '    pendingOwner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current pending owner to claim the ownership of the contract. It emits\n', '   * OwnershipTransferred event and resets pending owner to 0.\n', '   */\n', '  function claimOwnership()\n', '    public\n', '  {\n', '    require(msg.sender == pendingOwner);\n', '    address previousOwner = owner;\n', '    owner = pendingOwner;\n', '    pendingOwner = 0;\n', '    emit OwnershipTransferred(previousOwner, owner);\n', '  }\n', '}\n', '\n', '// File: contracts/tokens/Zxc.sol\n', '\n', '/*\n', ' * @title ZXC protocol token.\n', ' * @dev Standard ERC20 token used by the 0xcert protocol. This contract follows the implementation\n', ' * at https://goo.gl/twbPwp.\n', ' */\n', 'contract Zxc is\n', '  Token,\n', '  Claimable\n', '{\n', '  using SafeMath for uint256;\n', '\n', '  /**\n', '   * Transfer feature state.\n', '   */\n', '  bool internal transferEnabled;\n', '\n', '  /**\n', '   * Crowdsale smart contract address.\n', '   */\n', '  address public crowdsaleAddress;\n', '\n', '  /**\n', '   * @dev An event which is triggered when tokens are burned.\n', '   * @param _burner The address which burns tokens.\n', '   * @param _value The amount of burned tokens.\n', '   */\n', '  event Burn(\n', '    address indexed _burner,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Assures that the provided address is a valid destination to transfer tokens to.\n', '   * @param _to Target address.\n', '   */\n', '  modifier validDestination(\n', '    address _to\n', '  )\n', '  {\n', '    require(_to != address(0x0));\n', '    require(_to != address(this));\n', '    require(_to != address(crowdsaleAddress));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Assures that tokens can be transfered.\n', '   */\n', '  modifier onlyWhenTransferAllowed()\n', '  {\n', '    require(transferEnabled || msg.sender == crowdsaleAddress);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Contract constructor.\n', '   */\n', '  constructor()\n', '    public\n', '  {\n', '    tokenName = "0xcert Protocol Token";\n', '    tokenSymbol = "ZXC";\n', '    tokenDecimals = 18;\n', '    tokenTotalSupply = 500000000000000000000000000;\n', '    transferEnabled = false;\n', '\n', '    balances[owner] = tokenTotalSupply;\n', '    emit Transfer(address(0x0), owner, tokenTotalSupply);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers token to a specified address.\n', '   * @param _to The address to transfer to.\n', '   * @param _value The amount to be transferred.\n', '   */\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    onlyWhenTransferAllowed()\n', '    validDestination(_to)\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    _success = super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers tokens from one address to another.\n', '   * @param _from address The address which you want to send tokens from.\n', '   * @param _to address The address which you want to transfer to.\n', '   * @param _value uint256 The amount of tokens to be transferred.\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    onlyWhenTransferAllowed()\n', '    validDestination(_to)\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    _success = super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Enables token transfers.\n', '   */\n', '  function enableTransfer()\n', '    onlyOwner()\n', '    external\n', '  {\n', '    transferEnabled = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens. This function is based on BurnableToken implementation\n', '   * at goo.gl/GZEhaq.\n', '   * @notice Only owner is allowed to perform this operation.\n', '   * @param _value The amount of tokens to be burned.\n', '   */\n', '  function burn(\n', '    uint256 _value\n', '  )\n', '    onlyOwner()\n', '    external\n', '  {\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[owner] = balances[owner].sub(_value);\n', '    tokenTotalSupply = tokenTotalSupply.sub(_value);\n', '\n', '    emit Burn(owner, _value);\n', '    emit Transfer(owner, address(0x0), _value);\n', '  }\n', '\n', '  /**\n', '    * @dev Set crowdsale address which can distribute tokens even when onlyWhenTransferAllowed is\n', '    * false.\n', '    * @param crowdsaleAddr Address of token offering contract.\n', '    */\n', '  function setCrowdsaleAddress(\n', '    address crowdsaleAddr\n', '  )\n', '    external\n', '    onlyOwner()\n', '  {\n', '    crowdsaleAddress = crowdsaleAddr;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// File: @0xcert/ethereum-erc20/contracts/tokens/ERC20.sol\n', '\n', '/**\n', ' * @title A standard interface for tokens.\n', ' */\n', 'interface ERC20 {\n', '\n', '  /**\n', '   * @dev Returns the name of the token.\n', '   */\n', '  function name()\n', '    external\n', '    view\n', '    returns (string _name);\n', '\n', '  /**\n', '   * @dev Returns the symbol of the token.\n', '   */\n', '  function symbol()\n', '    external\n', '    view\n', '    returns (string _symbol);\n', '\n', '  /**\n', '   * @dev Returns the number of decimals the token uses.\n', '   */\n', '  function decimals()\n', '    external\n', '    view\n', '    returns (uint8 _decimals);\n', '\n', '  /**\n', '   * @dev Returns the total token supply.\n', '   */\n', '  function totalSupply()\n', '    external\n', '    view\n', '    returns (uint256 _totalSupply);\n', '\n', '  /**\n', '   * @dev Returns the account balance of another account with address _owner.\n', '   * @param _owner The address from which the balance will be retrieved.\n', '   */\n', '  function balanceOf(\n', '    address _owner\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _balance);\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The\n', '   * function SHOULD throw if the _from account balance does not have enough tokens to spend.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the\n', '   * Transfer event.\n', '   * @param _from The address of the sender.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Allows _spender to withdraw from your account multiple times, up to\n', '   * the _value amount. If this function is called again it overwrites the current\n', '   * allowance with _value.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   * @param _value The amount of tokens to be approved for transfer.\n', '   */\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Returns the amount which _spender is still allowed to withdraw from _owner.\n', '   * @param _owner The address of the account owning tokens.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _remaining);\n', '\n', '  /**\n', '   * @dev Triggers when tokens are transferred, including zero value transfers.\n', '   */\n', '  event Transfer(\n', '    address indexed _from,\n', '    address indexed _to,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Triggers on any successful call to approve(address _spender, uint256 _value).\n', '   */\n', '  event Approval(\n', '    address indexed _owner,\n', '    address indexed _spender,\n', '    uint256 _value\n', '  );\n', '\n', '}\n', '\n', '// File: @0xcert/ethereum-utils/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @dev Math operations with safety checks that throw on error. This contract is based\n', ' * on the source code at https://goo.gl/iyQsmU.\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '   * @dev Multiplies two numbers, throws on overflow.\n', '   * @param _a Factor number.\n', '   * @param _b Factor number.\n', '   */\n', '  function mul(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Integer division of two numbers, truncating the quotient.\n', '   * @param _a Dividend number.\n', '   * @param _b Divisor number.\n', '   */\n', '  function div(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    uint256 c = _a / _b;\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   * @param _a Minuend number.\n', '   * @param _b Subtrahend number.\n', '   */\n', '  function sub(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   * @param _a Number.\n', '   * @param _b Number.\n', '   */\n', '  function add(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    uint256 c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '// File: @0xcert/ethereum-erc20/contracts/tokens/Token.sol\n', '\n', '/**\n', ' * @title ERC20 standard token implementation.\n', ' * @dev Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.\n', ' */\n', 'contract Token is\n', '  ERC20\n', '{\n', '  using SafeMath for uint256;\n', '\n', '  /**\n', '   * Token name.\n', '   */\n', '  string internal tokenName;\n', '\n', '  /**\n', '   * Token symbol.\n', '   */\n', '  string internal tokenSymbol;\n', '\n', '  /**\n', '   * Number of decimals.\n', '   */\n', '  uint8 internal tokenDecimals;\n', '\n', '  /**\n', '   * Total supply of tokens.\n', '   */\n', '  uint256 internal tokenTotalSupply;\n', '\n', '  /**\n', '   * Balance information map.\n', '   */\n', '  mapping (address => uint256) internal balances;\n', '\n', '  /**\n', '   * Token allowance mapping.\n', '   */\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /**\n', '   * @dev Trigger when tokens are transferred, including zero value transfers.\n', '   */\n', '  event Transfer(\n', '    address indexed _from,\n', '    address indexed _to,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Trigger on any successful call to approve(address _spender, uint256 _value).\n', '   */\n', '  event Approval(\n', '    address indexed _owner,\n', '    address indexed _spender,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Returns the name of the token.\n', '   */\n', '  function name()\n', '    external\n', '    view\n', '    returns (string _name)\n', '  {\n', '    _name = tokenName;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the symbol of the token.\n', '   */\n', '  function symbol()\n', '    external\n', '    view\n', '    returns (string _symbol)\n', '  {\n', '    _symbol = tokenSymbol;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the number of decimals the token uses.\n', '   */\n', '  function decimals()\n', '    external\n', '    view\n', '    returns (uint8 _decimals)\n', '  {\n', '    _decimals = tokenDecimals;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the total token supply.\n', '   */\n', '  function totalSupply()\n', '    external\n', '    view\n', '    returns (uint256 _totalSupply)\n', '  {\n', '    _totalSupply = tokenTotalSupply;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the account balance of another account with address _owner.\n', '   * @param _owner The address from which the balance will be retrieved.\n', '   */\n', '  function balanceOf(\n', '    address _owner\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _balance)\n', '  {\n', '    _balance = balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The\n', '   * function SHOULD throw if the _from account balance does not have enough tokens to spend.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    _success = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If\n', '   * this function is called again it overwrites the current allowance with _value.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   * @param _value The amount of tokens to be approved for transfer.\n', '   */\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '\n', '    emit Approval(msg.sender, _spender, _value);\n', '    _success = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the amount which _spender is still allowed to withdraw from _owner.\n', '   * @param _owner The address of the account owning tokens.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _remaining)\n', '  {\n', '    _remaining = allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the\n', '   * Transfer event.\n', '   * @param _from The address of the sender.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '    _success = true;\n', '  }\n', '\n', '}\n', '\n', '// File: @0xcert/ethereum-utils/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @dev The contract has an owner address, and provides basic authorization control whitch\n', ' * simplifies the implementation of user permissions. This contract is based on the source code\n', ' * at https://goo.gl/n2ZGVt.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev An event which is triggered when the owner is changed.\n', '   * @param previousOwner The address of the previous owner.\n', '   * @param newOwner The address of the new owner.\n', '   */\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  constructor()\n', '    public\n', '  {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(\n', '    address _newOwner\n', '  )\n', '    onlyOwner\n', '    public\n', '  {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: @0xcert/ethereum-utils/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @dev The contract has an owner address, and provides basic authorization control whitch\n', ' * simplifies the implementation of user permissions. This contract is based on the source code\n', ' * at goo.gl/CfEAkv and upgrades Ownable contracts with additional claim step which makes ownership\n', ' * transfers less prone to errors.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev An event which is triggered when the owner is changed.\n', '   * @param previousOwner The address of the previous owner.\n', '   * @param newOwner The address of the new owner.\n', '   */\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev Allows the current owner to give new owner ability to claim the ownership of the contract.\n', "   * This differs from the Owner's function in that it allows setting pedingOwner address to 0x0,\n", '   * which effectively cancels an active claim.\n', '   * @param _newOwner The address which can claim ownership of the contract.\n', '   */\n', '  function transferOwnership(\n', '    address _newOwner\n', '  )\n', '    onlyOwner\n', '    public\n', '  {\n', '    pendingOwner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current pending owner to claim the ownership of the contract. It emits\n', '   * OwnershipTransferred event and resets pending owner to 0.\n', '   */\n', '  function claimOwnership()\n', '    public\n', '  {\n', '    require(msg.sender == pendingOwner);\n', '    address previousOwner = owner;\n', '    owner = pendingOwner;\n', '    pendingOwner = 0;\n', '    emit OwnershipTransferred(previousOwner, owner);\n', '  }\n', '}\n', '\n', '// File: contracts/tokens/Zxc.sol\n', '\n', '/*\n', ' * @title ZXC protocol token.\n', ' * @dev Standard ERC20 token used by the 0xcert protocol. This contract follows the implementation\n', ' * at https://goo.gl/twbPwp.\n', ' */\n', 'contract Zxc is\n', '  Token,\n', '  Claimable\n', '{\n', '  using SafeMath for uint256;\n', '\n', '  /**\n', '   * Transfer feature state.\n', '   */\n', '  bool internal transferEnabled;\n', '\n', '  /**\n', '   * Crowdsale smart contract address.\n', '   */\n', '  address public crowdsaleAddress;\n', '\n', '  /**\n', '   * @dev An event which is triggered when tokens are burned.\n', '   * @param _burner The address which burns tokens.\n', '   * @param _value The amount of burned tokens.\n', '   */\n', '  event Burn(\n', '    address indexed _burner,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Assures that the provided address is a valid destination to transfer tokens to.\n', '   * @param _to Target address.\n', '   */\n', '  modifier validDestination(\n', '    address _to\n', '  )\n', '  {\n', '    require(_to != address(0x0));\n', '    require(_to != address(this));\n', '    require(_to != address(crowdsaleAddress));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Assures that tokens can be transfered.\n', '   */\n', '  modifier onlyWhenTransferAllowed()\n', '  {\n', '    require(transferEnabled || msg.sender == crowdsaleAddress);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Contract constructor.\n', '   */\n', '  constructor()\n', '    public\n', '  {\n', '    tokenName = "0xcert Protocol Token";\n', '    tokenSymbol = "ZXC";\n', '    tokenDecimals = 18;\n', '    tokenTotalSupply = 500000000000000000000000000;\n', '    transferEnabled = false;\n', '\n', '    balances[owner] = tokenTotalSupply;\n', '    emit Transfer(address(0x0), owner, tokenTotalSupply);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers token to a specified address.\n', '   * @param _to The address to transfer to.\n', '   * @param _value The amount to be transferred.\n', '   */\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    onlyWhenTransferAllowed()\n', '    validDestination(_to)\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    _success = super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers tokens from one address to another.\n', '   * @param _from address The address which you want to send tokens from.\n', '   * @param _to address The address which you want to transfer to.\n', '   * @param _value uint256 The amount of tokens to be transferred.\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    onlyWhenTransferAllowed()\n', '    validDestination(_to)\n', '    public\n', '    returns (bool _success)\n', '  {\n', '    _success = super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Enables token transfers.\n', '   */\n', '  function enableTransfer()\n', '    onlyOwner()\n', '    external\n', '  {\n', '    transferEnabled = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens. This function is based on BurnableToken implementation\n', '   * at goo.gl/GZEhaq.\n', '   * @notice Only owner is allowed to perform this operation.\n', '   * @param _value The amount of tokens to be burned.\n', '   */\n', '  function burn(\n', '    uint256 _value\n', '  )\n', '    onlyOwner()\n', '    external\n', '  {\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[owner] = balances[owner].sub(_value);\n', '    tokenTotalSupply = tokenTotalSupply.sub(_value);\n', '\n', '    emit Burn(owner, _value);\n', '    emit Transfer(owner, address(0x0), _value);\n', '  }\n', '\n', '  /**\n', '    * @dev Set crowdsale address which can distribute tokens even when onlyWhenTransferAllowed is\n', '    * false.\n', '    * @param crowdsaleAddr Address of token offering contract.\n', '    */\n', '  function setCrowdsaleAddress(\n', '    address crowdsaleAddr\n', '  )\n', '    external\n', '    onlyOwner()\n', '  {\n', '    crowdsaleAddress = crowdsaleAddr;\n', '  }\n', '\n', '}']
