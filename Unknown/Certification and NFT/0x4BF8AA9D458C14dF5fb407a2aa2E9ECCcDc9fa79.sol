['pragma solidity ^0.4.11;\n', '/**\n', ' * Overflow aware uint math functions.\n', ' */\n', 'contract SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function pct(uint numerator, uint denominator, uint precision) internal returns(uint quotient) {\n', '    uint _numerator = numerator * 10 ** (precision+1);\n', '    uint _quotient = ((_numerator / denominator) + 5) / 10;\n', '    return (_quotient);\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * ERC 20 token\n', ' */\n', 'contract Token is SafeMath {\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = sub(balances[msg.sender], _value);\n', '            balances[_to] = add(balances[_to], _value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = add(balances[_to], _value);\n', '            balances[_from] = sub(balances[_from], _value);\n', '            allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    // A vulernability of the approve method in the ERC20 standard was identified by\n', '    // Mikhail Vladimirov and Dmitry Khovratovich here:\n', '    // https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM\n', '    // It&#39;s better to use this method which is not susceptible to over-withdrawing by the approvee.\n', '    /// @param _spender The address to approve\n', '    /// @param _currentValue The previous value approved, which can be retrieved with allowance(msg.sender, _spender)\n', '    /// @param _newValue The new value to approve, this will replace the _currentValue\n', '    /// @return bool Whether the approval was a success (see ERC20&#39;s `approve`)\n', '    function compareAndApprove(address _spender, uint256 _currentValue, uint256 _newValue) public returns(bool) {\n', '        if (allowed[msg.sender][_spender] != _currentValue) {\n', '            return false;\n', '        }\n', '            return approve(_spender, _newValue);\n', '    }\n', '}\n', '\n', 'contract CHEXToken is Token {\n', '\n', '    string public constant name = "CHEX Token";\n', '    string public constant symbol = "CHX";\n', '    uint public constant decimals = 18;\n', '    uint public startBlock; //crowdsale start block\n', '    uint public endBlock; //crowdsale end block\n', '\n', '    address public founder;\n', '    address public owner;\n', '    \n', '    uint public totalSupply = 2000000000 * 10**decimals; // 2b tokens, each divided to up to 10^decimals units.\n', '    uint public etherCap = 2500000 * 10**decimals;\n', '    \n', '    uint public totalTokens = 0;\n', '    uint public presaleSupply = 0;\n', '    uint public presaleEtherRaised = 0;\n', '\n', '    event Buy(address indexed recipient, uint eth, uint chx);\n', '    event Deliver(address indexed recipient, uint chx, string _for);\n', '\n', '    uint public presaleAllocation = totalSupply / 2; //50% of token supply allocated for crowdsale\n', '    uint public strategicAllocation = totalSupply / 4; //25% of token supply allocated post-crowdsale for strategic supply\n', '    uint public reserveAllocation = totalSupply / 4; //25% of token supply allocated post-crowdsale for internal\n', '    bool public strategicAllocated = false;\n', '    bool public reserveAllocated = false;\n', '\n', '    uint public transferLockup = 5760; //no transfers until 1 day after sale is over\n', '    uint public strategicLockup = 80640; //strategic supply locked until 14 days after sale is over\n', '    uint public reserveLockup = 241920; //first wave of reserve locked until 42 days after sale is over\n', '\n', '    uint public reserveWave = 0; //increments each time 10% of reserve is allocated, to a max of 10\n', '    uint public reserveWaveTokens = reserveAllocation / 10; //10% of reserve will be released on each wave\n', '    uint public reserveWaveLockup = 172800; //30 day intervals before subsequent wave of reserve tokens can be released\n', '\n', '    uint public constant MIN_ETHER = 1 finney;\n', '\n', '    enum TokenSaleState {\n', '        Initial,    //contract initialized, bonus token\n', '        Presale,    //limited time crowdsale\n', '        Live,       //default price\n', '        Frozen      //prevent sale of tokens\n', '    }\n', '\n', '    TokenSaleState public _saleState = TokenSaleState.Initial;\n', '\n', '    function CHEXToken(address founderInput, address ownerInput, uint startBlockInput, uint endBlockInput) {\n', '        founder = founderInput;\n', '        owner = ownerInput;\n', '        startBlock = startBlockInput;\n', '        endBlock = endBlockInput;\n', '        \n', '        updateTokenSaleState();\n', '    }\n', '\n', '    function price() constant returns(uint) {\n', '        if (_saleState == TokenSaleState.Initial) return 6001;\n', '        if (_saleState == TokenSaleState.Presale) {\n', '            uint percentRemaining = pct((endBlock - block.number), (endBlock - startBlock), 3);\n', '            return 3000 + 3 * percentRemaining;\n', '        }\n', '        return 3000;\n', '    }\n', '\n', '    function updateTokenSaleState () {\n', '        if (_saleState == TokenSaleState.Frozen) return;\n', '\n', '        if (_saleState == TokenSaleState.Live && block.number > endBlock) return;\n', '        \n', '        if (_saleState == TokenSaleState.Initial && block.number >= startBlock) {\n', '            _saleState = TokenSaleState.Presale;\n', '        }\n', '        \n', '        if (_saleState == TokenSaleState.Presale && block.number > endBlock) {\n', '            _saleState = TokenSaleState.Live;\n', '        }\n', '    }\n', '\n', '    function() payable {\n', '        buy(msg.sender);\n', '    }\n', '\n', '    function buy(address recipient) payable {\n', '        if (recipient == 0x0) throw;\n', '        if (msg.value < MIN_ETHER) throw;\n', '        if (_saleState == TokenSaleState.Frozen) throw;\n', '        if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;\n', '        if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleEtherRaised >= etherCap) throw;\n', '\n', '        updateTokenSaleState();\n', '        uint tokens = mul(msg.value, price());\n', '\n', '        if (tokens <= 0) throw;\n', '        \n', '        balances[recipient] = add(balances[recipient], tokens);\n', '        totalTokens = add(totalTokens, tokens);\n', '\n', '        if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {\n', '            presaleEtherRaised = add(presaleEtherRaised, msg.value);\n', '            presaleSupply = add(presaleSupply, tokens);\n', '        }\n', '\n', '        founder.transfer(msg.value);\n', '        \n', '        Transfer(0, recipient, tokens);\n', '        Buy(recipient, msg.value, tokens);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (block.number <= endBlock + transferLockup && msg.sender != founder && msg.sender != owner) throw;\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (block.number <= endBlock + transferLockup && msg.sender != founder && msg.sender != owner) throw;\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    modifier onlyInternal {\n', '        require(msg.sender == owner || msg.sender == founder);\n', '        _;\n', '    }\n', '\n', '    function deliver(address recipient, uint tokens, string _for) onlyInternal {\n', '        if (tokens <= 0) throw;\n', '        if (totalTokens >= totalSupply) throw;\n', '        if (_saleState == TokenSaleState.Frozen) throw;\n', '        if ((_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) && presaleSupply >= presaleAllocation) throw;\n', '\n', '        updateTokenSaleState();\n', '\n', '        balances[recipient] = add(balances[recipient], tokens);\n', '        totalTokens = add(totalTokens, tokens);\n', '\n', '        if (_saleState == TokenSaleState.Initial || _saleState == TokenSaleState.Presale) {\n', '            presaleSupply = add(presaleSupply, tokens);\n', '        }\n', '\n', '        Transfer(0, recipient, tokens);    \n', '        Deliver(recipient, tokens, _for);\n', '    }\n', '\n', '    function allocateStrategicTokens() onlyInternal {\n', '        if (block.number <= endBlock + strategicLockup) throw;\n', '        if (strategicAllocated) throw;\n', '\n', '        balances[owner] = add(balances[owner], strategicAllocation);\n', '        totalTokens = add(totalTokens, strategicAllocation);\n', '\n', '        strategicAllocated = true;\n', '    }\n', '\n', '    function allocateReserveTokens() onlyInternal {\n', '        if (block.number <= endBlock + reserveLockup + (reserveWaveLockup * reserveWave)) throw;\n', '        if (reserveAllocated) throw;\n', '\n', '        balances[founder] = add(balances[founder], reserveWaveTokens);\n', '        totalTokens = add(totalTokens, reserveWaveTokens);\n', '\n', '        reserveWave++;\n', '        if (reserveWave >= 10) {\n', '            reserveAllocated = true;\n', '        }\n', '    }\n', '\n', '    function freeze() onlyInternal {\n', '        _saleState = TokenSaleState.Frozen;\n', '    }\n', '\n', '    function unfreeze() onlyInternal {\n', '        _saleState = TokenSaleState.Presale;\n', '        updateTokenSaleState();\n', '    }\n', '\n', '}']