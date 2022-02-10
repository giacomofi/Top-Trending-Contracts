['pragma solidity ^0.4.25;\n', '/****\n', 'This is an interesting project.\n', '****/\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' *      ERC223 contract interface with ERC20 functions and events\n', ' *      Fully backward compatible with ERC20\n', ' *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended\n', ' */\n', 'contract ERC223 {\n', '\n', '\n', '    // ERC223 and ERC20 functions \n', '    function balanceOf(address who) public view returns (uint256);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function transfer(address to, uint256 value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data); \n', '\n', '    // ERC223 functions\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '\n', '    // ERC20 functions \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedFunds(address indexed target, uint256 locked);\n', '}\n', '\n', '\n', 'contract OtherToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', '\n', '\n', 'contract YEYE is ERC223  {\n', '    \n', '    using SafeMath for uint256;\n', '    using SafeMath for uint;\n', '    address owner = msg.sender;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public blacklist;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '    address[] StoreWelfareAddress;\n', '    mapping (address => string) StoreWelfareDetails;  \n', '    address public OrganizationAddress;\n', '    string internal constant _name = "YEYE";\n', '    string internal constant _symbol = "YE";\n', '    uint8 internal constant _decimals = 8;\n', '    uint256 internal _totalSupply = 2000000000e8;\n', '    uint256 internal StartEth = 1e16;\n', '    uint256 private  RandNonce;\n', '    uint256 public Organization = _totalSupply.div(100).mul(5);\n', '    uint256 public totalRemaining = _totalSupply;\n', '    uint256 public totalDistributed = 0;\n', '    uint256 public EthGet=1500000e8;\n', '    uint256 public Send0GiveBase = 3000e8;\n', '    bool internal EndDistr = false;\n', '    bool internal EndSend0GetToken = false;\n', '    bool internal EndEthGetToken = false; \n', '    bool internal CanTransfer = true;   \n', '    bool internal EndGamGetToken = false;\n', '  \n', '    modifier canDistr() {\n', '        require(!EndDistr);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier canTrans() {\n', '        require(CanTransfer == true);\n', '        _;\n', '    }    \n', '    modifier onlyWhitelist() {\n', '        require(blacklist[msg.sender] == false);\n', '        _;\n', '    }\n', '    \n', '    constructor(address _Organization) public {\n', '        owner = msg.sender;\n', '        OrganizationAddress = _Organization;\n', '        distr(OrganizationAddress , Organization);\n', '        RandNonce = uint(keccak256(abi.encodePacked(now)));\n', '        RandNonce = RandNonce**10;\n', '    }\n', '    \n', '    function changeOwner(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '      }\n', '\n', '    \n', '    function enableWhitelist(address[] addresses) onlyOwner public {\n', '        require(addresses.length <= 255);\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            blacklist[addresses[i]] = false;\n', '        }\n', '    }\n', '\n', '    function disableWhitelist(address[] addresses) onlyOwner public {\n', '        require(addresses.length <= 255);\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            blacklist[addresses[i]] = true;\n', '        }\n', '    }\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        EndDistr = true;\n', '        return true;\n', '    }\n', '    function startDistribution() onlyOwner  public returns (bool) {\n', '        EndDistr = false;\n', '        return true;\n', '    }\n', '    function finishFreeGet() onlyOwner canDistr public returns (bool) {\n', '        EndSend0GetToken = true;\n', '        return true;\n', '    }\n', '    function finishEthGet() onlyOwner canDistr public returns (bool) {\n', '        EndEthGetToken = true;\n', '        return true;\n', '    }\n', '    function startFreeGet() onlyOwner canDistr public returns (bool) {\n', '        EndSend0GetToken = false;\n', '        return true;\n', '    }\n', '    function startEthGet() onlyOwner canDistr public returns (bool) {\n', '        EndEthGetToken = false;\n', '        return true;\n', '    }\n', '    function startTransfer() onlyOwner  public returns (bool) {\n', '        CanTransfer = true;\n', '        return true;\n', '    }\n', '    function stopTransfer() onlyOwner  public returns (bool) {\n', '        CanTransfer = false;\n', '        return true;\n', '    }\n', '    function startGamGetToken() onlyOwner  public returns (bool) {\n', '        EndGamGetToken = false;\n', '        return true;\n', '    }\n', '    function stopGamGetToken() onlyOwner  public returns (bool) {\n', '        EndGamGetToken = true;\n', '        return true;\n', '    }\n', '    function changeParam(uint _Send0GiveBase, uint _EthGet, uint _StartEth) onlyOwner public returns (bool) {\n', '        Send0GiveBase = _Send0GiveBase;\n', '        EthGet=_EthGet;\n', '        StartEth = _StartEth;\n', '        return true;\n', '    }\n', '    function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {\n', '        require(targets.length > 0);\n', '\n', '        for (uint j = 0; j < targets.length; j++) {\n', '            require(targets[j] != 0x0);\n', '            frozenAccount[targets[j]] = isFrozen;\n', '            emit FrozenFunds(targets[j], isFrozen);\n', '        }\n', '    }\n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(targets.length > 0\n', '                && targets.length == unixTimes.length);\n', '                \n', '        for(uint j = 0; j < targets.length; j++){\n', '            require(unlockUnixTime[targets[j]] < unixTimes[j]);\n', '            unlockUnixTime[targets[j]] = unixTimes[j];\n', '            emit LockedFunds(targets[j], unixTimes[j]);\n', '        }\n', '    }    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        require(totalRemaining >= 0);\n', '        require(_amount<=totalRemaining);\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        totalRemaining = totalRemaining.sub(_amount);\n', '\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(amount <= totalRemaining);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amount <= totalRemaining);\n', '            distr(addresses[i], amount);\n', '        }\n', '  \n', '        if (totalDistributed >= _totalSupply) {\n', '            EndDistr = true;\n', '        }\n', '    }\n', '    \n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amounts[i] <= totalRemaining);\n', '            distr(addresses[i], amounts[i]);\n', '            \n', '            if (totalDistributed >= _totalSupply) {\n', '                EndDistr = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function () external payable {\n', '            autoDistribute();\n', '     }   \n', '    function autoDistribute() payable canDistr onlyWhitelist public {\n', '\n', '        \n', '        if (Send0GiveBase > totalRemaining) {\n', '            Send0GiveBase = totalRemaining;\n', '        }\n', '        uint256 etherValue=msg.value;\n', '        uint256 value;\n', '        address sender = msg.sender;\n', '        require(sender == tx.origin && !isContract(sender));\n', '        if(etherValue>StartEth){\n', '            require(EndEthGetToken==false);\n', '            RandNonce = RandNonce.add(Send0GiveBase);\n', '            uint256 random1 = uint(keccak256(abi.encodePacked(blockhash(RandNonce % 100),RandNonce,sender))) % 10;\n', '            RandNonce = RandNonce.add(random1);\n', '            value = etherValue.mul(EthGet);\n', '            value = value.div(1 ether);\n', '            if(random1 < 2) value = value.add(value);\n', '            value = value.add(Send0GiveBase);\n', '            Send0GiveBase = Send0GiveBase.div(100000).mul(99999);\n', '            require(value <= totalRemaining);\n', '            distr(sender, value);\n', '            owner.transfer(etherValue);          \n', '\n', '        }else{\n', '            uint256 balance = balances[sender];\n', '            if(balance == 0){\n', '                require(EndSend0GetToken==false && Send0GiveBase <= totalRemaining);\n', '                Send0GiveBase = Send0GiveBase.div(100000).mul(99999);\n', '                distr(sender, Send0GiveBase);\n', '            }else{\n', '                require(EndGamGetToken == false);\n', '                RandNonce = RandNonce.add(Send0GiveBase);\n', '                uint256 random = uint(keccak256(abi.encodePacked(blockhash(RandNonce % 100), RandNonce,sender))) % 10;\n', '                RandNonce = RandNonce.add(random);\n', '                if(random > 4){\n', '                    distr(sender, balance);                    \n', '                }else{\n', '                    balances[sender] = 0;\n', '                    totalRemaining = totalRemaining.add(balance);\n', '                    totalDistributed = totalDistributed.sub(balance);  \n', '                    emit Transfer(sender, address(this), balance);                  \n', '                }\n', '\n', '            }\n', '        }        \n', '        if (totalDistributed >= _totalSupply) {\n', '            EndDistr = true;\n', '        }\n', '\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) canTrans  onlyWhitelist public returns (bool success) {\n', '\n', '        require(_to != address(0) \n', '                && _amount <= balances[msg.sender]\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]\n', '                );\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) canTrans onlyWhitelist public returns (bool success) {\n', '        require(_to != address(0)\n', '                && _value > 0\n', '                && balances[_from] >= _value\n', '                && allowed[_from][msg.sender] >= _value\n', '                && frozenAccount[_from] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[_from] \n', '                && now > unlockUnixTime[_to]\n', '                );\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', ' \n', '    \n', '    function withdraw(address receiveAddress) onlyOwner public {\n', '        uint256 etherBalance = address(this).balance;\n', '        if(!receiveAddress.send(etherBalance))revert();   \n', '\n', '    }\n', '    function recycling(uint _amount) onlyOwner public {\n', '        require(_amount <= balances[msg.sender]);\n', '        balances[msg.sender].sub(_amount);\n', '        totalRemaining = totalRemaining.add(_amount);\n', '        totalDistributed = totalDistributed.sub(_amount);  \n', '        emit Transfer(msg.sender, address(this), _amount);  \n', '\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        _totalSupply = _totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '    \n', '    function withdrawOtherTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        OtherToken token = OtherToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '    function storeWelfare(address _welfareAddress, string _details) onlyOwner public returns (bool) {\n', '        StoreWelfareAddress.push(_welfareAddress);\n', '        StoreWelfareDetails[_welfareAddress] = _details;\n', '        return true;\n', '    }\n', '    function readWelfareDetails(address _welfareAddress)  public view returns (string) {\n', '        return  StoreWelfareDetails[_welfareAddress];\n', '\n', '    }\n', '    function readWelfareAddress(uint _id)  public view returns (address) {\n', '        return  StoreWelfareAddress[_id];\n', '\n', '    }\n', '    function name() public view returns (string Name) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string Symbol) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8 Decimals) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 TotalSupply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}']