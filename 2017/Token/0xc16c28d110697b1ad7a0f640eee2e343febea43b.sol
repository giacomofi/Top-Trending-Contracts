['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' *\n', ' * @author  <newtwist@protonmail.com>\n', ' *\n', ' * Version C\n', ' *\n', ' * Overview:\n', ' * This is an implimentation of a `burnable` token. The tokens do not pay any dividends; however if/when tokens\n', ' * are `burned`, the burner gets a share of whatever funds the contract owns at that time. No provision is made\n', ' * for how tokens are sold; all tokens are initially credited to the contract owner. There is a provision to\n', ' * establish a single `restricted` account. The restricted account can own tokens, but cannot transfer them or\n', ' * burn them until after a certain date. . There is also a function to burn tokens without getting paid. This is\n', ' * useful, for example, if the sale-contract/owner wants to reduce the supply of tokens.\n', ' *\n', ' */\n', 'pragma solidity ^0.4.11;\n', '\n', '/*\n', '    Overflow protected math functions\n', '*/\n', 'contract SafeMath {\n', '    /**\n', '        constructor\n', '    */\n', '    function SafeMath() public {\n', '    }\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '//Burnable Token interface\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '// Token standard API\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract iERC20Token {\n', '  function totalSupply() public constant returns (uint supply);\n', '  function balanceOf( address who ) public constant returns (uint value);\n', '  function allowance( address owner, address spender ) public constant returns (uint remaining);\n', '\n', '  function transfer( address to, uint value) public returns (bool ok);\n', '  function transferFrom( address from, address to, uint value) public returns (bool ok);\n', '  function approve( address spender, uint value ) public returns (bool ok);\n', '\n', '  event Transfer( address indexed from, address indexed to, uint value);\n', '  event Approval( address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract iBurnableToken is iERC20Token {\n', '  function burnTokens(uint _burnCount) public;\n', '  function unPaidBurnTokens(uint _burnCount) public;\n', '}\n', '\n', 'contract BurnableToken is iBurnableToken, SafeMath {\n', '\n', '  event PaymentEvent(address indexed from, uint amount);\n', '  event TransferEvent(address indexed from, address indexed to, uint amount);\n', '  event ApprovalEvent(address indexed from, address indexed to, uint amount);\n', '  event BurnEvent(address indexed from, uint count, uint value);\n', '\n', '  string  public symbol;\n', '  string  public name;\n', '  bool    public isLocked;\n', '  uint    public decimals;\n', '  uint    public restrictUntil;                              //vesting for developer tokens\n', '  uint           tokenSupply;                                //can never be increased; but tokens can be burned\n', '  address public owner;\n', '  address public restrictedAcct;                             //no transfers from this addr during vest time\n', '  mapping (address => uint) balances;\n', '  mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to\n', '\n', '\n', '  modifier ownerOnly {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier unlockedOnly {\n', '    require(!isLocked);\n', '    _;\n', '  }\n', '\n', '  modifier preventRestricted {\n', '    require((msg.sender != restrictedAcct) || (now >= restrictUntil));\n', '    _;\n', '  }\n', '\n', '\n', '  //\n', '  //constructor\n', '  //\n', '  function BurnableToken() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  //\n', '  // ERC-20\n', '  //\n', '\n', '  function totalSupply() public constant returns (uint supply) { supply = tokenSupply; }\n', '\n', '  function transfer(address _to, uint _value) public preventRestricted returns (bool success) {\n', '    //if token supply was not limited then we would prevent wrap:\n', '    //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to])\n', '    if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      TransferEvent(msg.sender, _to, _value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '    //if token supply was not limited then we would prevent wrap:\n', '    //if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to])\n', '    if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_from] -= _value;\n', '      balances[_to] += _value;\n', '      approvals[_from][msg.sender] -= _value;\n', '      TransferEvent(_from, _to, _value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    balance = balances[_owner];\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint _value) public preventRestricted returns (bool success) {\n', '    approvals[msg.sender][_spender] = _value;\n', '    ApprovalEvent(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return approvals[_owner][_spender];\n', '  }\n', '\n', '\n', '  //\n', '  // END ERC20\n', '  //\n', '\n', '\n', '  //\n', '  // default payable function.\n', '  //\n', '  function () public payable {\n', '    PaymentEvent(msg.sender, msg.value);\n', '  }\n', '\n', '  function initTokenSupply(uint _tokenSupply, uint _decimals) public ownerOnly {\n', '    require(tokenSupply == 0);\n', '    tokenSupply = _tokenSupply;\n', '    balances[owner] = tokenSupply;\n', '    decimals = _decimals;\n', '  }\n', '\n', '  function setName(string _name, string _symbol) public ownerOnly {\n', '    name = _name;\n', '    symbol = _symbol;\n', '  }\n', '\n', '  function lock() public ownerOnly {\n', '    isLocked = true;\n', '  }\n', '\n', '  function setRestrictedAcct(address _restrictedAcct, uint _restrictUntil) public ownerOnly unlockedOnly {\n', '    restrictedAcct = _restrictedAcct;\n', '    restrictUntil = _restrictUntil;\n', '  }\n', '\n', '  function tokenValue() constant public returns (uint value) {\n', '    value = this.balance / tokenSupply;\n', '  }\n', '\n', '  function valueOf(address _owner) constant public returns (uint value) {\n', '    value = this.balance * balances[_owner] / tokenSupply;\n', '  }\n', '\n', '  function burnTokens(uint _burnCount) public preventRestricted {\n', '    if (balances[msg.sender] >= _burnCount && _burnCount > 0) {\n', '      uint _value = this.balance * _burnCount / tokenSupply;\n', '      tokenSupply -= _burnCount;\n', '      balances[msg.sender] -= _burnCount;\n', '      msg.sender.transfer(_value);\n', '      BurnEvent(msg.sender, _burnCount, _value);\n', '    }\n', '  }\n', '\n', '  function unPaidBurnTokens(uint _burnCount) public preventRestricted {\n', '    if (balances[msg.sender] >= _burnCount && _burnCount > 0) {\n', '      tokenSupply -= _burnCount;\n', '      balances[msg.sender] -= _burnCount;\n', '      BurnEvent(msg.sender, _burnCount, 0);\n', '    }\n', '  }\n', '\n', '  //for debug\n', '  //only available before the contract is locked\n', '  function haraKiri() public ownerOnly unlockedOnly {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '}']