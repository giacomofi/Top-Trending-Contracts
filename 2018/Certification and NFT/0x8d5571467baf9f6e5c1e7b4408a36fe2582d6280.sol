['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' *\n', ' * Version D\n', ' * @author  Pratyush Bhatt <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="501d29232439331d3f3e233f3f3e1020223f243f3e3d31393c7e333f3d">[email&#160;protected]</a>>\n', ' *\n', ' * Overview:\n', ' * This is an implimentation of a simple sale token. The tokens do not pay any dividends -- they only exist\n', ' * as a database of purchasers. A limited number of tokens are created on-the-fly as funds are deposited into the\n', ' * contract. All of the funds are tranferred to the beneficiary at the end of the token-sale.\n', ' */\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '/*\n', '    Overflow protected math functions\n', '*/\n', 'contract SafeMath {\n', '    /**\n', '        constructor\n', '    */\n', '    function SafeMath() public {\n', '    }\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '// Token standard API\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract iERC20Token {\n', '  function totalSupply() public constant returns (uint supply);\n', '  function balanceOf( address who ) public constant returns (uint value);\n', '  function allowance( address owner, address spender ) public constant returns (uint remaining);\n', '\n', '  function transfer( address to, uint value) public returns (bool ok);\n', '  function transferFrom( address from, address to, uint value) public returns (bool ok);\n', '  function approve( address spender, uint value ) public returns (bool ok);\n', '\n', '  event Transfer( address indexed from, address indexed to, uint value);\n', '  event Approval( address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract SimpleSaleToken is iERC20Token, SafeMath {\n', '\n', '  event PaymentEvent(address indexed from, uint amount);\n', '  event TransferEvent(address indexed from, address indexed to, uint amount);\n', '  event ApprovalEvent(address indexed from, address indexed to, uint amount);\n', '\n', '  string  public symbol;\n', '  string  public name;\n', '  bool    public isLocked;\n', '  uint    public decimals;\n', '  uint    public tokenPrice;\n', '  uint           tokenSupply;\n', '  uint           tokensRemaining;\n', '  uint    public contractSendGas = 100000;\n', '  address public owner;\n', '  address public beneficiary;\n', '  mapping (address => uint) balances;\n', '  mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to\n', '\n', '\n', '  modifier ownerOnly {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier unlockedOnly {\n', '    require(!isLocked);\n', '    _;\n', '  }\n', '\n', '  modifier duringSale {\n', '    require(tokenPrice != 0 && tokensRemaining > 0);\n', '    _;\n', '  }\n', '\n', '  //this is to protect from short-address attack. use this to verify size of args, especially when an address arg preceeds\n', '  //a value arg. see: https://www.reddit.com/r/ethereum/comments/63s917/worrysome_bug_exploit_with_erc20_token/dfwmhc3/\n', '  modifier onlyPayloadSize(uint size) {\n', '    assert(msg.data.length >= size + 4);\n', '    _;\n', '  }\n', '\n', '  //\n', '  //constructor\n', '  //\n', '  function SimpleSaleToken() public {\n', '    owner = msg.sender;\n', '    beneficiary = msg.sender;\n', '  }\n', '\n', '\n', '  //\n', '  // ERC-20\n', '  //\n', '\n', '  function totalSupply() public constant returns (uint supply) {\n', '    //if tokenSupply was not limited then we would use safeAdd...\n', '    supply = tokenSupply + tokensRemaining;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) public onlyPayloadSize(2*32) returns (bool success) {\n', '    //prevent wrap\n', '    if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      TransferEvent(msg.sender, _to, _value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3*32) public returns (bool success) {\n', '    //prevent wrap:\n', '    if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '      balances[_from] -= _value;\n', '      balances[_to] += _value;\n', '      approvals[_from][msg.sender] -= _value;\n', '      TransferEvent(_from, _to, _value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    balance = balances[_owner];\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint _value) public onlyPayloadSize(2*32) returns (bool success) {\n', '    approvals[msg.sender][_spender] = _value;\n', '    ApprovalEvent(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return approvals[_owner][_spender];\n', '  }\n', '\n', '  //\n', '  // END ERC20\n', '  //\n', '\n', '\n', '  //\n', '  // default payable function.\n', '  //\n', '  function () public payable duringSale {\n', '    uint _quantity = msg.value / tokenPrice;\n', '    if (_quantity > tokensRemaining)\n', '       _quantity = tokensRemaining;\n', '    require(_quantity >= 1);\n', '    uint _cost = safeMul(_quantity, tokenPrice);\n', '    uint _refund = safeSub(msg.value, _cost);\n', '    balances[msg.sender] = safeAdd(balances[msg.sender], _quantity);\n', '    tokenSupply = safeAdd(tokenSupply, _quantity);\n', '    tokensRemaining = safeSub(tokensRemaining, _quantity);\n', '    if (_refund > 0)\n', '        msg.sender.transfer(_refund);\n', '    PaymentEvent(msg.sender, msg.value);\n', '  }\n', '\n', '  function setName(string _name, string _symbol) public ownerOnly {\n', '    name = _name;\n', '    symbol = _symbol;\n', '  }\n', '\n', '\n', '  //if decimals = 3, and you want 1 ETH/token, then pass in _tokenPrice = 0.001 * (wei / ether)\n', '  function setBeneficiary(address _beneficiary, uint _decimals, uint _tokenPrice, uint _tokensRemaining) public ownerOnly unlockedOnly {\n', '    beneficiary = _beneficiary;\n', '    decimals = _decimals;\n', '    tokenPrice = _tokenPrice;\n', '    tokensRemaining = _tokensRemaining;\n', '  }\n', '\n', '  function lock() public ownerOnly {\n', '    require(beneficiary != 0 && tokenPrice != 0);\n', '    isLocked = true;\n', '  }\n', '\n', '  function endSale() public ownerOnly {\n', '    require(beneficiary != 0);\n', '    //beneficiary is most likely a contract...\n', '    if (!beneficiary.call.gas(contractSendGas).value(this.balance)())\n', '      revert();\n', '    tokensRemaining = 0;\n', '  }\n', '\n', '  function tune(uint _contractSendGas) public ownerOnly {\n', '    contractSendGas = _contractSendGas;\n', '  }\n', '\n', '  //for debug\n', '  //only available before the contract is locked\n', '  function haraKiri() public ownerOnly unlockedOnly {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '}']