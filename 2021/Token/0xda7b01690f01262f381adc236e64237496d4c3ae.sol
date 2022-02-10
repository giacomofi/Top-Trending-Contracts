['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-20\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Math operations with safety checks that throw on error. This contract is based\n', ' * on the source code at https://goo.gl/iyQsmU.\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   * @param _a Minuend number.\n', '   * @param _b Subtrahend number.\n', '   */\n', '  function sub(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   * @param _a Number.\n', '   * @param _b Number.\n', '   */\n', '  function add(\n', '    uint256 _a,\n', '    uint256 _b\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    uint256 c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'interface ERC20 {\n', '\n', '  /**\n', '   * @dev Returns the name of the token.\n', '   */\n', '  function name()\n', '    external\n', '    view\n', '    returns (string memory _name);\n', '\n', '  /**\n', '   * @dev Returns the symbol of the token.\n', '   */\n', '  function symbol()\n', '    external\n', '    view\n', '    returns (string memory _symbol);\n', '\n', '  /**\n', '   * @dev Returns the number of decimals the token uses.\n', '   */\n', '  function decimals()\n', '    external\n', '    view\n', '    returns (uint8 _decimals);\n', '\n', '  /**\n', '   * @dev Returns the total token supply.\n', '   */\n', '  function totalSupply()\n', '    external\n', '    view\n', '    returns (uint256 _totalSupply);\n', '\n', '  /**\n', '   * @dev Returns the account balance of another account with address _owner.\n', '   * @param _owner The address from which the balance will be retrieved.\n', '   */\n', '  function balanceOf(\n', '    address _owner\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _balance);\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The\n', '   * function SHOULD throw if the _from account balance does not have enough tokens to spend.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the\n', '   * Transfer event.\n', '   * @param _from The address of the sender.\n', '   * @param _to The address of the recipient.\n', '   * @param _value The amount of token to be transferred.\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Allows _spender to withdraw from your account multiple times, up to\n', '   * the _value amount. If this function is called again it overwrites the current\n', '   * allowance with _value.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   * @param _value The amount of tokens to be approved for transfer.\n', '   */\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    external\n', '    returns (bool _success);\n', '\n', '  /**\n', '   * @dev Returns the amount which _spender is still allowed to withdraw from _owner.\n', '   * @param _owner The address of the account owning tokens.\n', '   * @param _spender The address of the account able to transfer the tokens.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 _remaining);\n', '\n', '  /**\n', '   * @dev Triggers when tokens are transferred, including zero value transfers.\n', '   */\n', '  event Transfer(\n', '    address indexed _from,\n', '    address indexed _to,\n', '    uint256 _value\n', '  );\n', '\n', '  /**\n', '   * @dev Triggers on any successful call to approve(address _spender, uint256 _value).\n', '   */\n', '  event Approval(\n', '    address indexed _owner,\n', '    address indexed _spender,\n', '    uint256 _value\n', '  );\n', '\n', '}\n', '\n', 'contract Token is\n', '  ERC20\n', '{\n', '  using SafeMath for uint256;\n', '\n', '  /*\n', '   * Token name.\n', '   */\n', '  string internal tokenName;\n', '\n', '  /*\n', '   * Token symbol.\n', '   */\n', '   \n', '  string internal tokenSymbol;\n', '\n', '  /*\n', '   * Number of decimals.\n', '   */\n', '  uint8 internal tokenDecimals;\n', '\n', '  /*\n', '   * Total supply of tokens.\n', '   */\n', '  uint256 internal tokenTotalSupply;\n', '\n', '  /*\n', '   * Balance information map.\n', '   */\n', '  mapping (address => uint256) internal balances;\n', '\n', '  /*\n', '   * Token allowance mapping.\n', '   */\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /*\n', '   * dev Trigger when tokens are transferred, including zero value transfers.\n', '   */\n', '  event Transfer(\n', '    address indexed _from,\n', '    address indexed _to,\n', '    uint256 _value\n', '  );\n', '\n', '  /*\n', '   * dev Trigger on any successful call to approve(address _spender, uint256 _value).\n', '   */\n', '  event Approval(\n', '    address indexed _owner,\n', '    address indexed _spender,\n', '    uint256 _value\n', '  );\n', '\n', '  /*\n', '   * dev Returns the name of the token.\n', '   */\n', '  function name()\n', '    public\n', '    view\n', '    override \n', '    returns (string memory _name)\n', '  {\n', '    _name = tokenName;\n', '  }\n', '\n', '  /*\n', '   * dev Returns the symbol of the token.\n', '   */\n', '  function symbol()\n', '    public\n', '    view\n', '    override \n', '    returns (string memory _symbol)\n', '  {\n', '    _symbol = tokenSymbol;\n', '  }\n', '\n', '  /*\n', '   * dev Returns the number of decimals the token uses.\n', '   */\n', '  function decimals()\n', '    public\n', '    view\n', '    override \n', '    returns (uint8 _decimals)\n', '  {\n', '    _decimals = tokenDecimals;\n', '  }\n', '\n', '  /*\n', '   * dev Returns the total token supply.\n', '   */\n', '  function totalSupply()\n', '    public\n', '    view\n', '    override \n', '    returns (uint256 _totalSupply)\n', '  {\n', '    _totalSupply = tokenTotalSupply;\n', '  }\n', '\n', '  /*\n', '   * dev Returns the account balance of another account with address _owner.\n', '   * param _owner The address from which the balance will be retrieved.\n', '   */\n', '  function balanceOf(\n', '    address _owner\n', '  )\n', '    public\n', '    view\n', '    override \n', '    returns (uint256 _balance)\n', '  {\n', '    _balance = balances[_owner];\n', '  }\n', '\n', '  /*\n', '   * dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The\n', '   * function SHOULD throw if the _from account balance does not have enough tokens to spend.\n', '   * param _to The address of the recipient.\n', '   * param _value The amount of token to be transferred.\n', '   */\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    override \n', '    returns (bool _success)\n', '  {\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    _success = true;\n', '  }\n', '\n', '  /*\n', '   * dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If\n', '   * this function is called again it overwrites the current allowance with _value.\n', '   * param _spender The address of the account able to transfer the tokens.\n', '   * param _value The amount of tokens to be approved for transfer.\n', '   */\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    override \n', '    returns (bool _success)\n', '  {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '\n', '    emit Approval(msg.sender, _spender, _value);\n', '    _success = true;\n', '  }\n', '\n', '  /*\n', '   * dev Returns the amount which _spender is still allowed to withdraw from _owner.\n', '   * param _owner The address of the account owning tokens.\n', '   * param _spender The address of the account able to transfer the tokens.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '  )\n', '    external\n', '    view\n', '    override \n', '    returns (uint256 _remaining)\n', '  {\n', '    _remaining = allowed[_owner][_spender];\n', '  }\n', '\n', '  /*\n', '   * dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the\n', '   * Transfer event.\n', '   * param _from The address of the sender.\n', '   * param _to The address of the recipient.\n', '   * param _value The amount of token to be transferred.\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    override \n', '    returns (bool _success)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '    _success = true;\n', '  }\n', '\n', '}\n', '\n', 'contract DATBOI is Token {\n', '\n', '  uint256 public buyPrice = 10000000;\n', '  address payable public owner;\n', '  uint256 public datboiSupply = 100000000000;\n', '  \n', '  constructor()\n', '    payable public\n', '  {\n', '    tokenName = "DatBoi";\n', '    tokenSymbol = "DATBOI";\n', '    tokenDecimals = 18;\n', '    // 18 decimals is the strongly suggested default\n', '    tokenTotalSupply = datboiSupply * 10 ** uint256(tokenDecimals);\n', '    balances[msg.sender] = tokenTotalSupply; // Give the owner of the contract the whole balance\n', '    owner = msg.sender;\n', '  }\n', '  \n', '    fallback() payable external {\n', '        \n', '        uint amount = msg.value * buyPrice;                    // calculates the amount, made it so you can get many BOIS but to get MANY BOIS you have to spend ETH and not WEI\n', '        uint amountRaised;                                     \n', '        amountRaised += msg.value;                            //many thanks bois, couldnt do it without all the bois\n', '        require(balances[owner] >= amount);               // checks if it has enough to sell\n', '        require(msg.value <  (1+ 10**18) );\n', "        balances[msg.sender] += amount;                  // adds the amount to buyer's balance\n", '        balances[owner] -= amount;                        // sends ETH to DatBoiCoinMint\n', '        Transfer(owner, msg.sender, amount);               // execute an event reflecting the change\n', '        owner.transfer(amountRaised);\n', '    }\n', '}']