['pragma solidity ^0.4.23;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  // mitigate short address attack\n', '  // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.\n', '  modifier onlyPayloadSize(uint numWords) {\n', '     assert(msg.data.length >= numWords * 32 + 4);\n', '     _;\n', '  }\n', '}\n', '\n', '// ERC20 standard\n', 'contract Token {\n', '    function balanceOf(address _owner) public  view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);\n', '    function approve(address _spender, uint256 _value)  public returns (bool success);\n', '    function allowance(address _owner, address _spender) public  view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token, SafeMath {\n', '    uint256 public totalSupply;\n', '\n', '    function transfer(address _to, uint256 _value) public  onlyPayloadSize(2) returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // To change the approve amount you first have to reduce the addresses&#39;\n', '    //  allowance to zero by calling &#39;approve(_spender, 0)&#39; if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success) {\n', '        require(allowed[msg.sender][_spender] == _oldValue);\n', '        allowed[msg.sender][_spender] = _newValue;\n', '        emit Approval(msg.sender, _spender, _newValue);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256)  balances;\n', '    mapping (address => mapping (address => uint256))  allowed;\n', '}\n', '\n', 'contract STCDR is StandardToken {\n', '\tstring public name = "STCDR";\n', '\tstring public symbol = "STCDR";\n', '\tuint256 public decimals = 8;\n', '\tstring public version = "1.0";\n', '\tuint256 public tokenCap = 1000000000 * 10**8;\n', '\tuint256 public tokenBurned = 0;\n', '\tuint256 public tokenAllocated = 0;\n', '  // root control\n', '\taddress public fundWallet;\n', '\t// maps addresses\n', '  mapping (address => bool) public whitelist;\n', '\n', '\tevent Whitelist(address indexed participant);\n', '\n', '  modifier onlyWhitelist {\n', '\t\trequire(whitelist[msg.sender]);\n', '\t\t_;\n', '\t}\n', '\tmodifier onlyFundWallet {\n', '\t\trequire(msg.sender == fundWallet);\n', '\t\t_;\n', '\t}\n', '\n', '\tconstructor() public  {\n', '\t\tfundWallet = msg.sender;\n', '\t\twhitelist[fundWallet] = true;\n', '\t}\n', '\n', '\tfunction setTokens(address participant, uint256  amountTokens) private {\n', '\t\tuint256 thisamountTokens = amountTokens;\n', '\t\tuint256 newtokenAllocated =  safeAdd(tokenAllocated, thisamountTokens);\n', '\n', '    if(newtokenAllocated > tokenCap){\n', '\t\t\tthisamountTokens = safeSub(tokenCap,thisamountTokens);\n', '\t\t\tnewtokenAllocated = safeAdd(tokenAllocated, thisamountTokens);\n', '\t\t}\n', '\n', '\t\trequire(newtokenAllocated <= tokenCap);\n', '\n', '\t\ttokenAllocated = newtokenAllocated;\n', '\t\twhitelist[participant] = true;\n', '\t\tbalances[participant] = safeAdd(balances[participant], thisamountTokens);\n', '\t\ttotalSupply = safeAdd(totalSupply, thisamountTokens);\t\t\n', '\t}\n', '\n', '\tfunction allocateTokens(address participant, uint256  amountTokens, address recommended) external onlyFundWallet  {\n', '\t\tsetTokens(participant, amountTokens);\n', '\n', '\t\tif (recommended != participant)\t{\n', '      require(whitelist[recommended]);\n', '      setTokens(recommended, amountTokens);\n', '    }\n', '\t}\n', '\n', '\tfunction burnTokens(address participant, uint256  amountTokens) external onlyFundWallet  {\n', '\t\tuint256 newTokValue = amountTokens;\n', '\t\taddress thisparticipant = participant;\n', '\n', '\t\tif (balances[thisparticipant] < newTokValue) {\n', '      newTokValue = balances[thisparticipant];\n', '    }\n', '\n', '\t\tuint256 newtokenBurned = safeAdd(tokenBurned, newTokValue);\n', '\t\trequire(newtokenBurned <= tokenCap);\n', '\t\ttokenBurned = newtokenBurned;\n', '\t\tbalances[thisparticipant] = safeSub(balances[thisparticipant], newTokValue);\n', '\t\ttotalSupply = safeSub(totalSupply, newTokValue);\n', '\t}\n', '\n', '\tfunction burnMyTokens(uint256 amountTokens) external onlyWhitelist  {\n', '\t\tuint256 newTokValue = amountTokens;\n', '\t\taddress thisparticipant = msg.sender;\n', '\n', '    if (balances[thisparticipant] < newTokValue) {\n', '      newTokValue = balances[thisparticipant];\n', '    }\n', '\n', '\t\tuint256 newtokenBurned = safeAdd(tokenBurned, newTokValue);\n', '\t\trequire(newtokenBurned <= tokenCap);\n', '\t\ttokenBurned = newtokenBurned;\n', '\t\tbalances[msg.sender] = safeSub(balances[thisparticipant],newTokValue );\n', '\t\ttotalSupply = safeSub(totalSupply, newTokValue);\n', '\t}\n', '\n', '  function changeFundWallet(address newFundWallet) external onlyFundWallet {\n', '\t\trequire(newFundWallet != address(0));\n', '\t\tfundWallet = newFundWallet;\n', '\t}\n', '\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool success) {\n', '\t\twhitelist[_to] = true;\n', '\t\treturn super.transfer(_to, _value);\n', '\t}\n', '\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\t\twhitelist[_to] = true;\n', '\t\treturn super.transferFrom(_from, _to, _value);\n', '\t}\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  // mitigate short address attack\n', '  // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.\n', '  modifier onlyPayloadSize(uint numWords) {\n', '     assert(msg.data.length >= numWords * 32 + 4);\n', '     _;\n', '  }\n', '}\n', '\n', '// ERC20 standard\n', 'contract Token {\n', '    function balanceOf(address _owner) public  view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);\n', '    function approve(address _spender, uint256 _value)  public returns (bool success);\n', '    function allowance(address _owner, address _spender) public  view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token, SafeMath {\n', '    uint256 public totalSupply;\n', '\n', '    function transfer(address _to, uint256 _value) public  onlyPayloadSize(2) returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', "    // To change the approve amount you first have to reduce the addresses'\n", "    //  allowance to zero by calling 'approve(_spender, 0)' if it is not\n", '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success) {\n', '        require(allowed[msg.sender][_spender] == _oldValue);\n', '        allowed[msg.sender][_spender] = _newValue;\n', '        emit Approval(msg.sender, _spender, _newValue);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256)  balances;\n', '    mapping (address => mapping (address => uint256))  allowed;\n', '}\n', '\n', 'contract STCDR is StandardToken {\n', '\tstring public name = "STCDR";\n', '\tstring public symbol = "STCDR";\n', '\tuint256 public decimals = 8;\n', '\tstring public version = "1.0";\n', '\tuint256 public tokenCap = 1000000000 * 10**8;\n', '\tuint256 public tokenBurned = 0;\n', '\tuint256 public tokenAllocated = 0;\n', '  // root control\n', '\taddress public fundWallet;\n', '\t// maps addresses\n', '  mapping (address => bool) public whitelist;\n', '\n', '\tevent Whitelist(address indexed participant);\n', '\n', '  modifier onlyWhitelist {\n', '\t\trequire(whitelist[msg.sender]);\n', '\t\t_;\n', '\t}\n', '\tmodifier onlyFundWallet {\n', '\t\trequire(msg.sender == fundWallet);\n', '\t\t_;\n', '\t}\n', '\n', '\tconstructor() public  {\n', '\t\tfundWallet = msg.sender;\n', '\t\twhitelist[fundWallet] = true;\n', '\t}\n', '\n', '\tfunction setTokens(address participant, uint256  amountTokens) private {\n', '\t\tuint256 thisamountTokens = amountTokens;\n', '\t\tuint256 newtokenAllocated =  safeAdd(tokenAllocated, thisamountTokens);\n', '\n', '    if(newtokenAllocated > tokenCap){\n', '\t\t\tthisamountTokens = safeSub(tokenCap,thisamountTokens);\n', '\t\t\tnewtokenAllocated = safeAdd(tokenAllocated, thisamountTokens);\n', '\t\t}\n', '\n', '\t\trequire(newtokenAllocated <= tokenCap);\n', '\n', '\t\ttokenAllocated = newtokenAllocated;\n', '\t\twhitelist[participant] = true;\n', '\t\tbalances[participant] = safeAdd(balances[participant], thisamountTokens);\n', '\t\ttotalSupply = safeAdd(totalSupply, thisamountTokens);\t\t\n', '\t}\n', '\n', '\tfunction allocateTokens(address participant, uint256  amountTokens, address recommended) external onlyFundWallet  {\n', '\t\tsetTokens(participant, amountTokens);\n', '\n', '\t\tif (recommended != participant)\t{\n', '      require(whitelist[recommended]);\n', '      setTokens(recommended, amountTokens);\n', '    }\n', '\t}\n', '\n', '\tfunction burnTokens(address participant, uint256  amountTokens) external onlyFundWallet  {\n', '\t\tuint256 newTokValue = amountTokens;\n', '\t\taddress thisparticipant = participant;\n', '\n', '\t\tif (balances[thisparticipant] < newTokValue) {\n', '      newTokValue = balances[thisparticipant];\n', '    }\n', '\n', '\t\tuint256 newtokenBurned = safeAdd(tokenBurned, newTokValue);\n', '\t\trequire(newtokenBurned <= tokenCap);\n', '\t\ttokenBurned = newtokenBurned;\n', '\t\tbalances[thisparticipant] = safeSub(balances[thisparticipant], newTokValue);\n', '\t\ttotalSupply = safeSub(totalSupply, newTokValue);\n', '\t}\n', '\n', '\tfunction burnMyTokens(uint256 amountTokens) external onlyWhitelist  {\n', '\t\tuint256 newTokValue = amountTokens;\n', '\t\taddress thisparticipant = msg.sender;\n', '\n', '    if (balances[thisparticipant] < newTokValue) {\n', '      newTokValue = balances[thisparticipant];\n', '    }\n', '\n', '\t\tuint256 newtokenBurned = safeAdd(tokenBurned, newTokValue);\n', '\t\trequire(newtokenBurned <= tokenCap);\n', '\t\ttokenBurned = newtokenBurned;\n', '\t\tbalances[msg.sender] = safeSub(balances[thisparticipant],newTokValue );\n', '\t\ttotalSupply = safeSub(totalSupply, newTokValue);\n', '\t}\n', '\n', '  function changeFundWallet(address newFundWallet) external onlyFundWallet {\n', '\t\trequire(newFundWallet != address(0));\n', '\t\tfundWallet = newFundWallet;\n', '\t}\n', '\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool success) {\n', '\t\twhitelist[_to] = true;\n', '\t\treturn super.transfer(_to, _value);\n', '\t}\n', '\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\t\twhitelist[_to] = true;\n', '\t\treturn super.transferFrom(_from, _to, _value);\n', '\t}\n', '}']
