['pragma solidity ^0.4.24;\n', 'contract ERC256 {\n', '  uint public totalSupply;\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function balanceOf(address who) public view returns (uint);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) public onlyOwner  {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', 'contract ContractReceiver {\n', '\n', '    struct MYJ {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '        MYJ memory myj;\n', '        myj.sender = _from;\n', '        myj.value = _value;\n', '        myj.data = _data;\n', '        uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '        myj.sig = bytes4(u);\n', '    }\n', '}\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract MYJ256 is ERC256, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  string public name = "GAMERTOKEN";\n', '  string public symbol = "GAMER";\n', '  uint8 public decimals = 8;\n', '  uint256 public distributeAmount = 0;\n', '  uint256 public initialSupply = 10e9 * 1e8;\n', '  uint256 public totalSupply;\n', '  bool public mintingFinished = false;\n', '\n', ' mapping(address => uint256) public balanceOf;\n', ' mapping(address => mapping (address => uint256)) public allowance;\n', ' mapping (address => bool) public frozenAccount;\n', ' mapping (address => uint256) public unlockUnixTime;\n', '\n', '  event FrozenFunds(address indexed target, bool frozen);\n', '  event LockedFunds(address indexed target, uint256 locked);\n', '  event Burn(address indexed burner, uint256 amount);\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  function MYJ256() public {\n', '    totalSupply = initialSupply;\n', '    balanceOf[msg.sender] = totalSupply;\n', '  }\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {\n', '        require(targets.length > 0);\n', '\n', '        for (uint j = 0; j < targets.length; j++) {\n', '            require(targets[j] != 0x0);\n', '            frozenAccount[targets[j]] = isFrozen;\n', '            FrozenFunds(targets[j], isFrozen);\n', '        }\n', '    }\n', '\n', '\n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(targets.length > 0\n', '                && targets.length == unixTimes.length);\n', '\n', '        for(uint j = 0; j < targets.length; j++){\n', '            require(unlockUnixTime[targets[j]] < unixTimes[j]);\n', '            unlockUnixTime[targets[j]] = unixTimes[j];\n', '            LockedFunds(targets[j], unixTimes[j]);\n', '        }\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false\n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender]\n', '                && now > unlockUnixTime[_to]);\n', '\n', '        if (isContract(_to)) {\n', '            require(balanceOf[msg.sender] >= _value);\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '            balanceOf[_to] = balanceOf[_to].add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value, _data);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false\n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender]\n', '                && now > unlockUnixTime[_to]);\n', '\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false\n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender]\n', '                && now > unlockUnixTime[_to]);\n', '\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)\n', '                && _value > 0\n', '                && balanceOf[_from] >= _value\n', '                && allowance[_from][msg.sender] >= _value\n', '                && frozenAccount[_from] == false\n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[_from]\n', '                && now > unlockUnixTime[_to]);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '    \n', '    function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {\n', '        require(_unitAmount > 0);\n', '        \n', '        totalSupply = totalSupply.add(_unitAmount);\n', '        balanceOf[_to] = balanceOf[_to].add(_unitAmount);\n', '        Mint(_to, _unitAmount);\n', '        Transfer(address(0), _to, _unitAmount);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '\n', '    function burn(address _from, uint256 _unitAmount) onlyOwner public {\n', '        require(_unitAmount > 0\n', '                && balanceOf[_from] >= _unitAmount);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_unitAmount);\n', '        totalSupply = totalSupply.sub(_unitAmount);\n', '        Burn(_from, _unitAmount);\n', '    }\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '\n', '\n', '\n', '    function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {\n', '        require(amount > 0 \n', '                && addresses.length > 0\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '\n', '        amount = amount.mul(1e8);\n', '        uint256 totalAmount = amount.mul(addresses.length);\n', '        require(balanceOf[msg.sender] >= totalAmount);\n', '        \n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);\n', '            Transfer(msg.sender, addresses[j], amount);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {\n', '        require(addresses.length > 0\n', '                && addresses.length == amounts.length\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '                \n', '        uint256 totalAmount = 0;\n', '        \n', '        for(uint j = 0; j < addresses.length; j++){\n', '            require(amounts[j] > 0\n', '                    && addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '                    \n', '            amounts[j] = amounts[j].mul(1e8);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '        }\n', '        require(balanceOf[msg.sender] >= totalAmount);\n', '        \n', '        for (j = 0; j < addresses.length; j++) {\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);\n', '            Transfer(msg.sender, addresses[j], amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0\n', '                && addresses.length == amounts.length);\n', '\n', '        uint256 totalAmount = 0;\n', '        \n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0\n', '                    && addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '                    \n', '            amounts[j] = amounts[j].mul(1e8);\n', '            require(balanceOf[addresses[j]] >= amounts[j]);\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            Transfer(addresses[j], msg.sender, amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    function setDistributeAmount(uint256 _unitAmount) onlyOwner public {\n', '        distributeAmount = _unitAmount;\n', '    }\n', '    \n', '    function autoDistribute() payable public {\n', '        require(distributeAmount > 0\n', '                && balanceOf[owner] >= distributeAmount\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '        if(msg.value > 0) owner.transfer(msg.value);\n', '        \n', '        balanceOf[owner] = balanceOf[owner].sub(distributeAmount);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);\n', '        Transfer(owner, msg.sender, distributeAmount);\n', '    }\n', '\n', '\n', '    function() payable public {\n', '        autoDistribute();\n', '    }\n', '}']