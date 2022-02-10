['pragma solidity ^0.4.20;\n', '\n', '/*   HadesCoin go to the moon\n', ' *  \n', ' *  $$    $$   $$$$$$   $$$$$$$$   $$$$$$$$$   $$$$$$$$  \n', ' *  $$    $$  $$    $$  $$     $$  $$          $$  \n', ' *  $$    $$  $$    $$  $$     $$  $$          $$   \n', ' *  $$$$$$$$  $$$$$$$$  $$     $$  $$$$$$$$$   $$$$$$$$  \n', ' *  $$    $$  $$    $$  $$     $$  $$                $$  \n', ' *  $$    $$  $$    $$  $$     $$  $$                $$  \n', ' *  $$    $$  $$    $$  $$$$$$$$   $$$$$$$$$   $$$$$$$$   \n', ' */\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' *      ERC223 contract interface with ERC20 functions and events\n', ' *      Fully backward compatible with ERC20\n', ' *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended\n', ' */\n', 'contract ERC223 {\n', '    function balanceOf(address who) public view returns (uint);\n', '\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '}\n', '\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', '\n', '\n', 'contract Hadescoin is ERC223  {\n', '    \n', '    using SafeMath for uint256;\n', '    using SafeMath for uint;\n', '    address public owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public blacklist;\n', '    mapping (address => uint) public increase;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '    uint  public maxIncrease=20;\n', '    address public target;\n', '    string internal name_= "HadesCoin";\n', '    string internal symbol_ = "HAC";\n', '    uint8 internal decimals_= 18;\n', '    uint256 internal totalSupply_= 2000000000e18;\n', '    uint256 public toGiveBase = 5000e18;\n', '    uint256 public increaseBase = 500e18;\n', '\n', '\n', '    uint256 public OfficalHold = totalSupply_.mul(18).div(100);\n', '    uint256 public totalRemaining = totalSupply_;\n', '    uint256 public totalDistributed = 0;\n', '    bool public canTransfer = true;\n', '    uint256 public etherGetBase=5000000;\n', '\n', '\n', '\n', '    bool public distributionFinished = false;\n', '    bool public finishFreeGetToken = false;\n', '    bool public finishEthGetToken = false;    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier canTrans() {\n', '        require(canTransfer == true);\n', '        _;\n', '    }    \n', '    modifier onlyWhitelist() {\n', '        require(blacklist[msg.sender] == false);\n', '        _;\n', '    }\n', '    \n', '    function Hadescoin (address _target) public {\n', '        owner = msg.sender;\n', '        target = _target;\n', '        distr(target, OfficalHold);\n', '    }\n', '\n', '    // Function to access name of token .\n', '    function name() public view returns (string _name) {\n', '      return name_;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() public view returns (string _symbol) {\n', '      return symbol_;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() public view returns (uint8 _decimals) {\n', '      return decimals_;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '      return totalSupply_;\n', '    }\n', '\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) canTrans public returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '    }\n', '\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) canTrans public returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '    }\n', '\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) canTrans public returns (bool success) {\n', '      \n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '      }\n', '      return (length>0);\n', '    }\n', '\n', '    //function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '    }\n', '\n', '    //function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    ContractReceiver receiver = ContractReceiver(_to);\n', '    receiver.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '    }\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '    return balances[_owner];\n', '    }\n', '\n', '    \n', '    function changeOwner(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '      }\n', '\n', '    \n', '    function enableWhitelist(address[] addresses) onlyOwner public {\n', '        require(addresses.length <= 255);\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            blacklist[addresses[i]] = false;\n', '        }\n', '    }\n', '\n', '    function disableWhitelist(address[] addresses) onlyOwner public {\n', '        require(addresses.length <= 255);\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            blacklist[addresses[i]] = true;\n', '        }\n', '    }\n', '    function changeIncrease(address[] addresses, uint256[] _amount) onlyOwner public {\n', '        require(addresses.length <= 255);\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(_amount[i] <= maxIncrease);\n', '            increase[addresses[i]] = _amount[i];\n', '        }\n', '    }\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        return true;\n', '    }\n', '    function startDistribution() onlyOwner  public returns (bool) {\n', '        distributionFinished = false;\n', '        return true;\n', '    }\n', '    function finishFreeGet() onlyOwner canDistr public returns (bool) {\n', '        finishFreeGetToken = true;\n', '        return true;\n', '    }\n', '    function finishEthGet() onlyOwner canDistr public returns (bool) {\n', '        finishEthGetToken = true;\n', '        return true;\n', '    }\n', '    function startFreeGet() onlyOwner canDistr public returns (bool) {\n', '        finishFreeGetToken = false;\n', '        return true;\n', '    }\n', '    function startEthGet() onlyOwner canDistr public returns (bool) {\n', '        finishEthGetToken = false;\n', '        return true;\n', '    }\n', '    function startTransfer() onlyOwner  public returns (bool) {\n', '        canTransfer = true;\n', '        return true;\n', '    }\n', '    function stopTransfer() onlyOwner  public returns (bool) {\n', '        canTransfer = false;\n', '        return true;\n', '    }\n', '    function changeBaseValue(uint256 _toGiveBase,uint256 _increaseBase,uint256 _etherGetBase,uint _maxIncrease) onlyOwner public returns (bool) {\n', '        toGiveBase = _toGiveBase;\n', '        increaseBase = _increaseBase;\n', '        etherGetBase=_etherGetBase;\n', '        maxIncrease=_maxIncrease;\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        require(totalRemaining >= 0);\n', '        require(_amount<=totalRemaining);\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        totalRemaining = totalRemaining.sub(_amount);\n', '\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(amount <= totalRemaining);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amount <= totalRemaining);\n', '            distr(addresses[i], amount);\n', '        }\n', '  \n', '        if (totalDistributed >= totalSupply_) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amounts[i] <= totalRemaining);\n', '            distr(addresses[i], amounts[i]);\n', '            \n', '            if (totalDistributed >= totalSupply_) {\n', '                distributionFinished = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function () external payable {\n', '            getTokens();\n', '     }   \n', '    function getTokens() payable canDistr onlyWhitelist public {\n', '\n', '        \n', '        if (toGiveBase > totalRemaining) {\n', '            toGiveBase = totalRemaining;\n', '        }\n', '        address investor = msg.sender;\n', '        uint256 etherValue=msg.value;\n', '        uint256 value;\n', '        \n', '        if(etherValue>1e15){\n', '            require(finishEthGetToken==false);\n', '            value=etherValue.mul(etherGetBase);\n', '            value=value.add(toGiveBase);\n', '            require(value <= totalRemaining);\n', '            distr(investor, value);\n', '            if(!owner.send(etherValue))revert();           \n', '\n', '        }else{\n', '            require(finishFreeGetToken==false\n', '            && toGiveBase <= totalRemaining\n', '            && increase[investor]<=maxIncrease\n', '            && now>=unlockUnixTime[investor]);\n', '            value=value.add(increase[investor].mul(increaseBase));\n', '            value=value.add(toGiveBase);\n', '            increase[investor]+=1;\n', '            distr(investor, value);\n', '            unlockUnixTime[investor]=now+1 days;\n', '        }        \n', '        if (totalDistributed >= totalSupply_) {\n', '            distributionFinished = true;\n', '        }\n', '\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) canTrans public returns (bool success) {\n', '        require(_to != address(0)\n', '                && _value > 0\n', '                && balances[_from] >= _value\n', '                && allowed[_from][msg.sender] >= _value\n', '                && blacklist[_from] == false \n', '                && blacklist[_to] == false);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint256){\n', '        ForeignToken t = ForeignToken(tokenAddress);\n', '        uint256 bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw(address receiveAddress) onlyOwner public {\n', '        uint256 etherBalance = this.balance;\n', '        if(!receiveAddress.send(etherBalance))revert();   \n', '\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '\n', '}']