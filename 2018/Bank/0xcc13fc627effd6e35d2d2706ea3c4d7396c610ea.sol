['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title IDXM Contract. IDEX Membership Token contract.\n', ' *\n', ' * @author Ray Pulver, ray@auroradao.com\n', ' */\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) returns (uint256) {\n', '    uint256 c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function safeSub(uint256 a, uint256 b) returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '  function safeAdd(uint256 a, uint256 b) returns (uint256) {\n', '    uint c = a + b;\n', '    require(c >= a && c >= b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Owned {\n', '  address public owner;\n', '  function Owned() {\n', '    owner = msg.sender;\n', '  }\n', '  function setOwner(address _owner) returns (bool success) {\n', '    owner = _owner;\n', '    return true;\n', '  }\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract IDXM is Owned, SafeMath {\n', '  uint8 public decimals = 8;\n', "  bytes32 public standard = 'Token 0.1';\n", "  bytes32 public name = 'IDEX Membership';\n", "  bytes32 public symbol = 'IDXM';\n", '  uint256 public totalSupply;\n', '\n', '  event Approval(address indexed from, address indexed spender, uint256 amount);\n', '\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  uint256 public baseFeeDivisor;\n', '  uint256 public feeDivisor;\n', '  uint256 public singleIDXMQty;\n', '\n', '  function () external {\n', '    throw;\n', '  }\n', '\n', '  uint8 public feeDecimals = 8;\n', '\n', '  struct Validity {\n', '    uint256 last;\n', '    uint256 ts;\n', '  }\n', '\n', '  mapping (address => Validity) public validAfter;\n', '  uint256 public mustHoldFor = 604800;\n', '  mapping (address => uint256) public exportFee;\n', '\n', '  /**\n', '   * Constructor.\n', '   *\n', '   */\n', '  function IDXM() {\n', '    totalSupply = 200000000000;\n', '    balanceOf[msg.sender] = totalSupply;\n', '    exportFee[0x00000000000000000000000000000000000000ff] = 100000000;\n', '    precalculate();\n', '  }\n', '\n', '  bool public balancesLocked = false;\n', '\n', '  function uploadBalances(address[] addresses, uint256[] balances) onlyOwner {\n', '    require(!balancesLocked);\n', '    require(addresses.length == balances.length);\n', '    uint256 sum;\n', '    for (uint256 i = 0; i < uint256(addresses.length); i++) {\n', '      sum = safeAdd(sum, safeSub(balances[i], balanceOf[addresses[i]]));\n', '      balanceOf[addresses[i]] = balances[i];\n', '    }\n', '    balanceOf[owner] = safeSub(balanceOf[owner], sum);\n', '  }\n', '\n', '  function lockBalances() onlyOwner {\n', '    balancesLocked = true;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfer `_amount` from `msg.sender.address()` to `_to`.\n', '   *\n', '   * @param _to Address that will receive.\n', '   * @param _amount Amount to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _amount) returns (bool success) {\n', '    require(!locked);\n', '    require(balanceOf[msg.sender] >= _amount);\n', '    require(balanceOf[_to] + _amount >= balanceOf[_to]);\n', '    balanceOf[msg.sender] -= _amount;\n', '    uint256 preBalance = balanceOf[_to];\n', '    balanceOf[_to] += _amount;\n', '    bool alreadyMax = preBalance >= singleIDXMQty;\n', '    if (!alreadyMax) {\n', '      if (now >= validAfter[_to].ts + mustHoldFor) validAfter[_to].last = preBalance;\n', '      validAfter[_to].ts = now;\n', '    }\n', '    if (validAfter[msg.sender].last > balanceOf[msg.sender]) validAfter[msg.sender].last = balanceOf[msg.sender];\n', '    Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfer `_amount` from `_from` to `_to`.\n', '   *\n', '   * @param _from Origin address\n', '   * @param _to Address that will receive\n', '   * @param _amount Amount to be transferred.\n', '   * @return result of the method call\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {\n', '    require(!locked);\n', '    require(balanceOf[_from] >= _amount);\n', '    require(balanceOf[_to] + _amount >= balanceOf[_to]);\n', '    require(_amount <= allowance[_from][msg.sender]);\n', '    balanceOf[_from] -= _amount;\n', '    uint256 preBalance = balanceOf[_to];\n', '    balanceOf[_to] += _amount;\n', '    allowance[_from][msg.sender] -= _amount;\n', '    bool alreadyMax = preBalance >= singleIDXMQty;\n', '    if (!alreadyMax) {\n', '      if (now >= validAfter[_to].ts + mustHoldFor) validAfter[_to].last = preBalance;\n', '      validAfter[_to].ts = now;\n', '    }\n', '    if (validAfter[_from].last > balanceOf[_from]) validAfter[_from].last = balanceOf[_from];\n', '    Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`\n', '   *\n', '   * @param _spender Address that receives the cheque\n', '   * @param _amount Amount on the cheque\n', '   * @param _extraData Consequential contract to be executed by spender in same transcation.\n', '   * @return result of the method call\n', '   */\n', '  function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {\n', '    tokenRecipient spender = tokenRecipient(_spender);\n', '    if (approve(_spender, _amount)) {\n', '      spender.receiveApproval(msg.sender, _amount, this, _extraData);\n', '      return true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`\n', '   *\n', '   * @param _spender Address that receives the cheque\n', '   * @param _amount Amount on the cheque\n', '   * @return result of the method call\n', '   */\n', '  function approve(address _spender, uint256 _amount) returns (bool success) {\n', '    require(!locked);\n', '    allowance[msg.sender][_spender] = _amount;\n', '    Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  function setExportFee(address addr, uint256 fee) onlyOwner {\n', '    require(addr != 0x00000000000000000000000000000000000000ff);\n', '    exportFee[addr] = fee;\n', '  }\n', '\n', '  function setHoldingPeriod(uint256 ts) onlyOwner {\n', '    mustHoldFor = ts;\n', '  }\n', '\n', '\n', '  /* --------------- fee calculation method ---------------- */\n', '\n', '  /**\n', "   * @notice 'Returns the fee for a transfer from `from` to `to` on an amount `amount`.\n", '   *\n', "   * Fee's consist of a possible\n", '   *    - import fee on transfers to an address\n', '   *    - export fee on transfers from an address\n', '   * IDXM ownership on an address\n', '   *    - reduces fee on a transfer from this address to an import fee-ed address\n', '   *    - reduces the fee on a transfer to this address from an export fee-ed address\n', '   * IDXM discount does not work for addresses that have an import fee or export fee set up against them.\n', '   *\n', '   * IDXM discount goes up to 100%\n', '   *\n', '   * @param from From address\n', '   * @param to To address\n', '   * @param amount Amount for which fee needs to be calculated.\n', '   *\n', '   */\n', '  function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value) {\n', '    uint256 fee = exportFee[from];\n', '    if (fee == 0) return 0;\n', '    uint256 amountHeld;\n', '    if (balanceOf[to] != 0) {\n', '      if (validAfter[to].ts + mustHoldFor < now) amountHeld = balanceOf[to];\n', '      else amountHeld = validAfter[to].last;\n', '      if (amountHeld >= singleIDXMQty) return 0;\n', '      return amount*fee*(singleIDXMQty - amountHeld) / feeDivisor;\n', '    } else return amount*fee / baseFeeDivisor;\n', '  }\n', '  \n', '  bool public locked = true;\n', '\n', '  function unlockToken() onlyOwner {\n', '    locked = false;\n', '  }\n', '\n', '  function precalculate() internal returns (bool success) {\n', '    baseFeeDivisor = pow10(1, feeDecimals);\n', '    feeDivisor = pow10(1, feeDecimals + decimals);\n', '    singleIDXMQty = pow10(1, decimals);\n', '  }\n', '  function div10(uint256 a, uint8 b) internal returns (uint256 result) {\n', '    for (uint8 i = 0; i < b; i++) {\n', '      a /= 10;\n', '    }\n', '    return a;\n', '  }\n', '  function pow10(uint256 a, uint8 b) internal returns (uint256 result) {\n', '    for (uint8 i = 0; i < b; i++) {\n', '      a *= 10;\n', '    }\n', '    return a;\n', '  }\n', '}']