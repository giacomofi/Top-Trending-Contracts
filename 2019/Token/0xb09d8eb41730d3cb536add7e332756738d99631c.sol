['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/ERC20.sol\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '\n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function decimals() public view returns (uint8 _decimals);\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function allowance(address _owner, address _spender) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '\n', '  event Transfer( address indexed from, address indexed to, uint256 value);\n', '  event Approval( address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/Ownable.sol\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/Xmalltoken.sol\n', '\n', 'contract ContractReceiver {\n', '   struct TKN {\n', '       address sender;\n', '       uint value;\n', '       bytes data;\n', '       bytes4 sig;\n', '   }\n', '   function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '       TKN memory tkn;\n', '       tkn.sender = _from;\n', '       tkn.value = _value;\n', '       tkn.data = _data;\n', '       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '       tkn.sig = bytes4(u);\n', '   }\n', '}\n', '\n', 'contract Xmalltoken is ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "cryptomall token";\n', '    string public symbol = "XMALL";\n', '    uint8 public decimals = 18;\n', '    uint private constant DECIMALS = 1000000000000000000;\n', '    uint256 public totalSupply = 50000000000 * DECIMALS; // 50milion\n', '\n', '    address private founder;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '\n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedUp(address indexed target, uint256 locked);\n', '    event Burn(address indexed from, uint256 amount);\n', '\n', '    /**\n', '     * @dev Constructor is called only once and can not be called again\n', '     */\n', '    function Xmalltoken(\n', '      address _address\n', '    ) public {\n', '        founder  = _address;\n', '        balanceOf[founder] += 50000000000 * DECIMALS;\n', '    }\n', '\n', '    function name() public view returns (string _name) { return name; }\n', '    function symbol() public view returns (string _symbol) { return symbol; }\n', '    function decimals() public view returns (uint8 _decimals) { return decimals; }\n', '    function totalSupply() public view returns (uint256 _totalSupply) { return totalSupply; }\n', '    function balanceOf(address _owner) public view returns (uint256 balance) { return balanceOf[_owner]; }\n', '\n', '    function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {\n', '        require(targets.length > 0);\n', '\n', '        for (uint j = 0; j < targets.length; j++) {\n', '            require(targets[j] != 0x0);\n', '            frozenAccount[targets[j]] = isFrozen;\n', '            FrozenFunds(targets[j], isFrozen);\n', '        }\n', '    }\n', '\n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(targets.length > 0\n', '                && targets.length == unixTimes.length);\n', '\n', '        for(uint j = 0; j < targets.length; j++){\n', '            unlockUnixTime[targets[j]] = unixTimes[j];\n', '            LockedUp(targets[j], unixTimes[j]);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        require(\n', '          _value > 0\n', '          && frozenAccount[msg.sender] == false\n', '          && frozenAccount[_to] == false\n', '          && now > unlockUnixTime[msg.sender]\n', '          && now > unlockUnixTime[_to]\n', '        );\n', '        if (isContract(_to)) {\n', '            require(balanceOf[msg.sender] >= _value);\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '            balanceOf[_to] = balanceOf[_to].add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {\n', '        require(\n', '          _value > 0\n', '          && frozenAccount[msg.sender] == false\n', '          && frozenAccount[_to] == false\n', '          && now > unlockUnixTime[msg.sender]\n', '          && now > unlockUnixTime[_to]\n', '        );\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false\n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender]\n', '                && now > unlockUnixTime[_to]);\n', '\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)\n', '                && _value > 0\n', '                && balanceOf[_from] >= _value\n', '                && allowance[_from][msg.sender] >= _value\n', '                && frozenAccount[_from] == false\n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[_from]\n', '                && now > unlockUnixTime[_to]);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '    function burn(address _from, uint256 _unitAmount) onlyOwner public {\n', '        require(_unitAmount > 0\n', '                && balanceOf[_from] >= _unitAmount);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_unitAmount);\n', '        totalSupply = totalSupply.sub(_unitAmount);\n', '        Burn(_from, _unitAmount);\n', '    }\n', '\n', '    function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {\n', '        require(addresses.length > 0\n', '                && addresses.length == amounts.length\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '\n', '        uint256 totalAmount = 0;\n', '\n', '        for(uint j = 0; j < addresses.length; j++){\n', '            require(amounts[j] > 0\n', '                    && addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '\n', '            amounts[j] = amounts[j].mul(1e8);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '        }\n', '        require(balanceOf[msg.sender] >= totalAmount);\n', '\n', '        for (j = 0; j < addresses.length; j++) {\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);\n', '            Transfer(msg.sender, addresses[j], amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0 && addresses.length == amounts.length);\n', '        uint256 totalAmount = 0;\n', '\n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0\n', '                    && addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '\n', '            amounts[j] = amounts[j].mul(1e8);\n', '            require(balanceOf[addresses[j]] >= amounts[j]);\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            Transfer(addresses[j], msg.sender, amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    function() payable public { }\n', '\n', '}']