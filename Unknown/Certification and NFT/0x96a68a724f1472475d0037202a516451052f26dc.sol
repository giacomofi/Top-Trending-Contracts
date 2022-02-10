['pragma solidity ^0.4.16;\n', '\n', '\n', '\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) constant returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function allowance(address owner, address spender) constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool);\n', '\n', '    function approve(address spender, uint256 value) returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      uint256 c = a * b;\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '    }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '      uint256 c = a / b;\n', '      // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '      return c;\n', '    }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '      balances[msg.sender] = balances[msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '      return balances[_owner];\n', '    }\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '      var _allowance = allowed[_from][msg.sender];\n', '\n', '      // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '      // require (_value <= _allowance);\n', '\n', '      balances[_to] = balances[_to].add(_value);\n', '      balances[_from] = balances[_from].sub(_value);\n', '      allowed[_from][msg.sender] = _allowance.sub(_value);\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '      // To change the approve amount you first have to reduce the addresses`\n', '      //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '      //  already 0 to mitigate the race condition described here:\n', '      //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '      require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '      allowed[msg.sender][_spender] = _value;\n', '      Approval(msg.sender, _spender, _value);\n', '      return true;\n', '    }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '      owner = msg.sender;\n', '    }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '      require(newOwner != address(0));\n', '      owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract Token is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '  // start and end block where investments are allowed (both inclusive)\n', '    uint256 public startBlock;\n', '    uint256 public endBlock;\n', '  // address where funds are collected\n', '    address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '    uint256 public tokensPerEther;\n', '\n', '  // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '\n', '    uint256 public cap;\n', '    uint256 public issuedTokens;\n', '    string public name = "Realestateco.in";\n', '    string public symbol = "REAL";\n', '    uint public decimals = 4;\n', '    uint public INITIAL_SUPPLY = 80000000000000;\n', '    uint factor;\n', '    bool internal isCrowdSaleRunning;\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '    function Token() {\n', '\n', '        wallet = address(0x879bf61F63a8C58D802EC612Aa8E868882E532c6);\n', '        tokensPerEther = 331;\n', '        endBlock = block.number + 400000;\n', '\n', '        totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        startBlock = block.number;\n', '        cap = INITIAL_SUPPLY;\n', '        issuedTokens = 0;\n', '        factor = 10**14;\n', '        isCrowdSaleRunning = true;\n', '        }\n', '\n', '    // crowdsale entrypoint\n', '    // fallback function can be used to buy tokens\n', '\n', '  function () payable {\n', '      buyTokens(msg.sender);\n', '    }\n', '\n', '  function stopCrowdSale() onlyOwner {\n', '    isCrowdSaleRunning = false;\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable {\n', '      require(beneficiary != 0x0);\n', '      require(validPurchase());\n', '\n', '      uint256 weiAmount = msg.value;\n', '      // calculate token amount to be created\n', '      uint256 tokens = weiAmount.mul(tokensPerEther).div(factor);\n', '\n', '\n', '      // check if the tokens are more than the cap\n', '      require(issuedTokens.add(tokens) <= cap);\n', '      // update state\n', '      weiRaised = weiRaised.add(weiAmount);\n', '      issuedTokens = issuedTokens.add(tokens);\n', '\n', '      forwardFunds();\n', '      // transfer the token\n', '      issueToken(beneficiary,tokens);\n', '      TokenPurchase(msg.sender, beneficiary, msg.value, tokens);\n', '\n', '    }\n', '\n', '  // can be issued to anyone without owners concent but as this method is internal only buyToken is calling it.\n', '  function issueToken(address beneficiary, uint256 tokens) internal {\n', '\n', '      balances[owner] = balances[owner].sub(tokens);\n', '      balances[beneficiary] = balances[beneficiary].add(tokens);\n', '    }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '      // to normalize the input\n', '      wallet.transfer(msg.value);\n', '\n', '    }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '      uint256 current = block.number;\n', '      bool withinPeriod = current >= startBlock && current <= endBlock;\n', '      bool nonZeroPurchase = msg.value != 0;\n', '      return withinPeriod && nonZeroPurchase && isCrowdSaleRunning;\n', '    }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '      return (block.number > endBlock) && isCrowdSaleRunning;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '\n', '\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) constant returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function allowance(address owner, address spender) constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool);\n', '\n', '    function approve(address spender, uint256 value) returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      uint256 c = a * b;\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '    }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '      uint256 c = a / b;\n', "      // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '      return c;\n', '    }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '      balances[msg.sender] = balances[msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '      return balances[_owner];\n', '    }\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '      var _allowance = allowed[_from][msg.sender];\n', '\n', '      // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '      // require (_value <= _allowance);\n', '\n', '      balances[_to] = balances[_to].add(_value);\n', '      balances[_from] = balances[_from].sub(_value);\n', '      allowed[_from][msg.sender] = _allowance.sub(_value);\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '      // To change the approve amount you first have to reduce the addresses`\n', '      //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '      //  already 0 to mitigate the race condition described here:\n', '      //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '      require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '      allowed[msg.sender][_spender] = _value;\n', '      Approval(msg.sender, _spender, _value);\n', '      return true;\n', '    }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '      owner = msg.sender;\n', '    }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '      require(newOwner != address(0));\n', '      owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract Token is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '  // start and end block where investments are allowed (both inclusive)\n', '    uint256 public startBlock;\n', '    uint256 public endBlock;\n', '  // address where funds are collected\n', '    address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '    uint256 public tokensPerEther;\n', '\n', '  // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '\n', '    uint256 public cap;\n', '    uint256 public issuedTokens;\n', '    string public name = "Realestateco.in";\n', '    string public symbol = "REAL";\n', '    uint public decimals = 4;\n', '    uint public INITIAL_SUPPLY = 80000000000000;\n', '    uint factor;\n', '    bool internal isCrowdSaleRunning;\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '    function Token() {\n', '\n', '        wallet = address(0x879bf61F63a8C58D802EC612Aa8E868882E532c6);\n', '        tokensPerEther = 331;\n', '        endBlock = block.number + 400000;\n', '\n', '        totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        startBlock = block.number;\n', '        cap = INITIAL_SUPPLY;\n', '        issuedTokens = 0;\n', '        factor = 10**14;\n', '        isCrowdSaleRunning = true;\n', '        }\n', '\n', '    // crowdsale entrypoint\n', '    // fallback function can be used to buy tokens\n', '\n', '  function () payable {\n', '      buyTokens(msg.sender);\n', '    }\n', '\n', '  function stopCrowdSale() onlyOwner {\n', '    isCrowdSaleRunning = false;\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable {\n', '      require(beneficiary != 0x0);\n', '      require(validPurchase());\n', '\n', '      uint256 weiAmount = msg.value;\n', '      // calculate token amount to be created\n', '      uint256 tokens = weiAmount.mul(tokensPerEther).div(factor);\n', '\n', '\n', '      // check if the tokens are more than the cap\n', '      require(issuedTokens.add(tokens) <= cap);\n', '      // update state\n', '      weiRaised = weiRaised.add(weiAmount);\n', '      issuedTokens = issuedTokens.add(tokens);\n', '\n', '      forwardFunds();\n', '      // transfer the token\n', '      issueToken(beneficiary,tokens);\n', '      TokenPurchase(msg.sender, beneficiary, msg.value, tokens);\n', '\n', '    }\n', '\n', '  // can be issued to anyone without owners concent but as this method is internal only buyToken is calling it.\n', '  function issueToken(address beneficiary, uint256 tokens) internal {\n', '\n', '      balances[owner] = balances[owner].sub(tokens);\n', '      balances[beneficiary] = balances[beneficiary].add(tokens);\n', '    }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '      // to normalize the input\n', '      wallet.transfer(msg.value);\n', '\n', '    }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '      uint256 current = block.number;\n', '      bool withinPeriod = current >= startBlock && current <= endBlock;\n', '      bool nonZeroPurchase = msg.value != 0;\n', '      return withinPeriod && nonZeroPurchase && isCrowdSaleRunning;\n', '    }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '      return (block.number > endBlock) && isCrowdSaleRunning;\n', '    }\n', '\n', '}']
