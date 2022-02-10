['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public constant returns (uint256);\n', '  function balanceOf(address tokenOwner) public constant returns (uint256 balance);\n', '  function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', 'contract Owned {\n', '  address public owner;\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Constructor\n', '  // ------------------------------------------------------------------------\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner returns (address account) {\n', '    owner = newOwner;\n', '    return owner;\n', '  }\n', '}\n', '\n', 'contract CSTKDropToken is ERC20, Owned {\n', '  using SafeMath for uint256;\n', '\n', '  string public symbol;\n', '  string public  name;\n', '  uint256 public decimals;\n', '  uint256 _totalSupply;\n', '\n', '  bool public started;\n', '\n', '  address public token;\n', '\n', '  struct Level {\n', '    uint256 price;\n', '    uint256 available;\n', '  }\n', '\n', '  Level[] levels;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping(address => mapping(string => uint256)) orders;\n', '\n', '  event TransferETH(address indexed from, address indexed to, uint256 eth);\n', '  event Sell(address indexed to, uint256 tokens, uint256 eth);\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Constructor\n', '  // ------------------------------------------------------------------------\n', '  constructor(string _symbol, string _name, uint256 _supply, uint256 _decimals, address _token) public {\n', '    symbol = _symbol;\n', '    name = _name;\n', '    decimals = _decimals;\n', '    token = _token;\n', '    _totalSupply = _supply;\n', '    balances[owner] = _totalSupply;\n', '    started = false;\n', '    emit Transfer(address(0), owner, _totalSupply);\n', '  }\n', '\n', '  function destruct() public onlyOwner {\n', '    ERC20 tokenInstance = ERC20(token);\n', '\n', '    uint256 balance = tokenInstance.balanceOf(this);\n', '\n', '    if (balance > 0) {\n', '      tokenInstance.transfer(owner, balance);\n', '    }\n', '\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Changes the address of the supported token\n', '  // ------------------------------------------------------------------------\n', '  function setToken(address newTokenAddress) public onlyOwner returns (bool success) {\n', '    token = newTokenAddress;\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Total supply\n', '  // ------------------------------------------------------------------------\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply.sub(balances[address(0)]);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Changes the total supply value\n', '  //\n', '  // a new supply must be no less then the current supply\n', '  // or the owner must have enough amount to cover supply reduction\n', '  // ------------------------------------------------------------------------\n', '  function changeTotalSupply(uint256 newSupply) public onlyOwner returns (bool success) {\n', '    require(newSupply >= 0 && (\n', '      newSupply >= _totalSupply || _totalSupply - newSupply <= balances[owner]\n', '    ));\n', '    uint256 diff = 0;\n', '    if (newSupply >= _totalSupply) {\n', '      diff = newSupply.sub(_totalSupply);\n', '      balances[owner] = balances[owner].add(diff);\n', '      emit Transfer(address(0), owner, diff);\n', '    } else {\n', '      diff = _totalSupply.sub(newSupply);\n', '      balances[owner] = balances[owner].sub(diff);\n', '      emit Transfer(owner, address(0), diff);\n', '    }\n', '    _totalSupply = newSupply;\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Get the token balance for account `tokenOwner`\n', '  // ------------------------------------------------------------------------\n', '  function balanceOf(address tokenOwner) public view returns (uint256 balance) {\n', '    return balances[tokenOwner];\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Start accept orders\n', '  // ------------------------------------------------------------------------\n', '  function start() public onlyOwner {\n', '    started = true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Start accept orders\n', '  // ------------------------------------------------------------------------\n', '  function stop() public onlyOwner {\n', '    started = false;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Adds new Level to the levels array\n', '  // ------------------------------------------------------------------------\n', '  function addLevel(uint256 price, uint256 available) public onlyOwner {\n', '    levels.push(Level(price, available));\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Removes a level with specified price from the levels array\n', '  // ------------------------------------------------------------------------\n', '  function removeLevel(uint256 price) public onlyOwner {\n', '    if (levels.length < 1) {\n', '      return;\n', '    }\n', '\n', '    Level[] memory tmp = levels;\n', '\n', '    delete levels;\n', '\n', '    for (uint i = 0; i < tmp.length; i++) {\n', '      if (tmp[i].price != price) {\n', '        levels.push(tmp[i]);\n', '      }\n', '    }\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Replaces a particular level index by a new Level values\n', '  // ------------------------------------------------------------------------\n', '  function replaceLevel(uint index, uint256 price, uint256 available) public onlyOwner {\n', '    levels[index] = Level(price, available);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Clears the levels array\n', '  // ------------------------------------------------------------------------\n', '  function clearLevels() public onlyOwner {\n', '    delete levels;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Finds a level with specified price and returns an amount of available tokens on the level\n', '  // ------------------------------------------------------------------------\n', '  function getLevelAmount(uint256 price) public view returns (uint256 available) {\n', '    if (levels.length < 1) {\n', '      return 0;\n', '    }\n', '\n', '    for (uint i = 0; i < levels.length; i++) {\n', '      if (levels[i].price == price) {\n', '        return levels[i].available;\n', '      }\n', '    }\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Returns a Level by it&#39;s array index\n', '  // ------------------------------------------------------------------------\n', '  function getLevelByIndex(uint index) public view returns (uint256 price, uint256 available) {\n', '    price = levels[index].price;\n', '    available = levels[index].available;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Returns a count of levels\n', '  // ------------------------------------------------------------------------\n', '  function getLevelsCount() public view returns (uint) {\n', '    return levels.length;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Returns a Level by it&#39;s array index\n', '  // ------------------------------------------------------------------------\n', '  function getCurrentLevel() public view returns (uint256 price, uint256 available) {\n', '    if (levels.length < 1) {\n', '      return;\n', '    }\n', '\n', '    for (uint i = 0; i < levels.length; i++) {\n', '      if (levels[i].available > 0) {\n', '        price = levels[i].price;\n', '        available = levels[i].available;\n', '        break;\n', '      }\n', '    }\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Get the order&#39;s balance of tokens for account `customer`\n', '  // ------------------------------------------------------------------------\n', '  function orderTokensOf(address customer) public view returns (uint256 balance) {\n', '    return orders[customer][&#39;tokens&#39;];\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Get the order&#39;s balance of ETH for account `customer`\n', '  // ------------------------------------------------------------------------\n', '  function orderEthOf(address customer) public view returns (uint256 balance) {\n', '    return orders[customer][&#39;eth&#39;];\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Delete customer&#39;s order\n', '  // ------------------------------------------------------------------------\n', '  function cancelOrder(address customer) public onlyOwner returns (bool success) {\n', '    orders[customer][&#39;eth&#39;] = 0;\n', '    orders[customer][&#39;tokens&#39;] = 0;\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Checks the order values by the customer&#39;s address and sends required\n', '  // promo tokens based on the received amount of `this` tokens and ETH\n', '  // ------------------------------------------------------------------------\n', '  function _checkOrder(address customer) private returns (uint256 tokens, uint256 eth) {\n', '    require(started);\n', '\n', '    eth = 0;\n', '    tokens = 0;\n', '\n', '    if (getLevelsCount() <= 0 || orders[customer][&#39;tokens&#39;] <= 0 || orders[customer][&#39;eth&#39;] <= 0) {\n', '      return;\n', '    }\n', '\n', '    ERC20 tokenInstance = ERC20(token);\n', '    uint256 balance = tokenInstance.balanceOf(this);\n', '\n', '    uint256 orderEth = orders[customer][&#39;eth&#39;];\n', '    uint256 orderTokens = orders[customer][&#39;tokens&#39;] > balance ? balance : orders[customer][&#39;tokens&#39;];\n', '\n', '    for (uint i = 0; i < levels.length; i++) {\n', '      if (levels[i].available <= 0) {\n', '        continue;\n', '      }\n', '\n', '      uint256 _tokens = (10**decimals) * orderEth / levels[i].price;\n', '\n', '      // check if there enough tokens on the level\n', '      if (_tokens > levels[i].available) {\n', '        _tokens = levels[i].available;\n', '      }\n', '\n', '      // check the order tokens limit\n', '      if (_tokens > orderTokens) {\n', '        _tokens = orderTokens;\n', '      }\n', '\n', '      uint256 _eth = _tokens * levels[i].price / (10**decimals);\n', '      levels[i].available -= _tokens;\n', '\n', '      // accumulate total price and tokens\n', '      eth += _eth;\n', '      tokens += _tokens;\n', '\n', '      // reduce remaining limits\n', '      orderEth -= _eth;\n', '      orderTokens -= _tokens;\n', '\n', '      if (orderEth <= 0 || orderTokens <= 0 || levels[i].available > 0) {\n', '        // order is calculated\n', '        break;\n', '      }\n', '    }\n', '\n', '    // charge required amount of the tokens and ETHs\n', '    orders[customer][&#39;tokens&#39;] = orders[customer][&#39;tokens&#39;].sub(tokens);\n', '    orders[customer][&#39;eth&#39;] = orders[customer][&#39;eth&#39;].sub(eth);\n', '\n', '    tokenInstance.transfer(customer, tokens);\n', '\n', '    emit Sell(customer, tokens, eth);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // public entry point for the `_checkOrder` function\n', '  // ------------------------------------------------------------------------\n', '  function checkOrder(address customer) public onlyOwner returns (uint256 tokens, uint256 eth) {\n', '    return _checkOrder(customer);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Transfer the balance from token owner&#39;s account to `to` account\n', '  // - Owner&#39;s account must have sufficient balance to transfer\n', '  // - 0 value transfers are allowed\n', '  // - only owner is allowed to send tokens to any address\n', '  // - not owners can transfer the balance only to owner&#39;s address\n', '  // ------------------------------------------------------------------------\n', '  function transfer(address to, uint256 tokens) public returns (bool success) {\n', '    require(msg.sender == owner || to == owner || to == address(this));\n', '    address receiver = msg.sender == owner ? to : owner;\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '    balances[receiver] = balances[receiver].add(tokens);\n', '\n', '    emit Transfer(msg.sender, receiver, tokens);\n', '\n', '    if (receiver == owner) {\n', '      orders[msg.sender][&#39;tokens&#39;] = orders[msg.sender][&#39;tokens&#39;].add(tokens);\n', '      _checkOrder(msg.sender);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // `allowance` is not allowed\n', '  // ------------------------------------------------------------------------\n', '  function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {\n', '    tokenOwner;\n', '    spender;\n', '    return uint256(0);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // `approve` is not allowed\n', '  // ------------------------------------------------------------------------\n', '  function approve(address spender, uint tokens) public returns (bool success) {\n', '    spender;\n', '    tokens;\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // `transferFrom` is not allowed\n', '  // ------------------------------------------------------------------------\n', '  function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {\n', '    from;\n', '    to;\n', '    tokens;\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Accept ETH\n', '  // ------------------------------------------------------------------------\n', '  function () public payable {\n', '    owner.transfer(msg.value);\n', '    emit TransferETH(msg.sender, address(this), msg.value);\n', '\n', '    orders[msg.sender][&#39;eth&#39;] = orders[msg.sender][&#39;eth&#39;].add(msg.value);\n', '    _checkOrder(msg.sender);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Owner can transfer out any accidentally sent ERC20 tokens\n', '  // ------------------------------------------------------------------------\n', '  function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {\n', '    return ERC20(tokenAddress).transfer(owner, tokens);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Owner can transfer out promo token\n', '  // ------------------------------------------------------------------------\n', '  function transferToken(uint256 tokens) public onlyOwner returns (bool success) {\n', '    return transferAnyERC20Token(token, tokens);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Owner can return specified amount from `tokenOwner`\n', '  // ------------------------------------------------------------------------\n', '  function returnFrom(address tokenOwner, uint256 tokens) public onlyOwner returns (bool success) {\n', '    balances[tokenOwner] = balances[tokenOwner].sub(tokens);\n', '    balances[owner] = balances[owner].add(tokens);\n', '    emit Transfer(tokenOwner, owner, tokens);\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Owner can return all tokens from `tokenOwner`\n', '  // ------------------------------------------------------------------------\n', '  function nullifyFrom(address tokenOwner) public onlyOwner returns (bool success) {\n', '    return returnFrom(tokenOwner, balances[tokenOwner]);\n', '  }\n', '}\n', '\n', 'contract CSTK_KRM is CSTKDropToken(&#39;CSTK_KRM&#39;, &#39;CryptoStock KRM Promo Token&#39;, 100000000 * 10**5, 5, 0x124c801606Be4b90bb46Fbb03fc0264B461B821B) {\n', '\n', '}']