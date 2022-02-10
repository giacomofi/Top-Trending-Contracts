['/* Copernic Space Cryptocurrency Token  */\n', '/*     Released on 11.11.2018 v.1.1     */\n', '/*   To celebrate 100 years of Polish   */\n', '/*             INDEPENDENCE             */\n', '/* ==================================== */\n', '/* National Independence Day is a       */\n', '/* national day in Poland celebrated on */\n', '/* 11 November to commemorate the       */\n', '/* anniversary of the restoration of    */\n', "/* Poland's sovereignty as the          */\n", '/* Second Polish Republic in 1918 from  */\n', '/* German, Austrian and Russian Empires */\n', '/* Following the partitions in the late */\n', '/* 18th century, Poland ceased to exist */\n', '/* for 123 years until the end of       */\n', '/* World War I, when the destruction of */\n', '/* the neighbouring powers allowed the  */\n', '/* country to reemerge.                 */\n', '\n', 'pragma solidity 0.5.0;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract ERC223Interface {\n', '    function balanceOf(address who) public view returns (uint);\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '    function transfer(address _to, uint _value, bytes memory _data) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes memory _data) public;\n', '}\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '    constructor() internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '    bool private _paused;\n', '    constructor() internal {\n', '        _paused = false;\n', '    }\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '    function pause() public onlyOwner whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '    function unpause() public onlyOwner whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external pure returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'contract CPRToken is IERC20, ERC223Interface, Ownable, Pausable {\n', '    using SafeMath for uint;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint256)) private _allowed;\n', '    string  private constant        _name = "Copernic";\n', '    string  private constant      _symbol = "CPR";\n', '    uint8   private constant    _decimals = 6;\n', '    uint256 private constant _totalSupply = 40000000 * (10 ** 6);\n', '    constructor() public {\n', '        balances[msg.sender] = balances[msg.sender].add(_totalSupply);\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '    function totalSupply() public pure returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function name() public pure returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public pure returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public pure returns (uint8) {\n', '        return _decimals;\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint256)\n', '    {\n', '        return _allowed[owner][spender];\n', '    }\n', '    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool)\n', '    {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = (\n', '        _allowed[msg.sender][spender].add(addedValue));\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool)\n', '    {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = (\n', '        _allowed[msg.sender][spender].sub(subtractedValue));\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= _allowed[_from][msg.sender]);\n', '        require(_to != address(0));\n', '        require(balances[_to] + _value > balances[_to]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        uint codeLength;\n', '        bytes memory empty;\n', '        assembly {\n', '            codeLength := extcodesize(_to)\n', '        }\n', '        if (codeLength > 0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(_from, _value, empty);\n', '        }\n', '        emit Transfer(_from, _to, _value);\n', '        emit Transfer(_from, _to, _value, empty);\n', '        return true;\n', '    }\n', '    function transfer(address _to, uint _value, bytes memory _data) public whenNotPaused returns (bool) {\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    function transferToAddress(address _to, uint _value, bytes memory _data) internal returns (bool success) {\n', '        require(_value <= balances[msg.sender]);\n', '        require(_to != address(0));\n', '        require(balances[_to] + _value > balances[_to]);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    function transferToContract(address _to, uint _value, bytes memory _data) internal returns (bool success) {\n', '        require(_value <= balances[msg.sender]);\n', '        require(_to != address(0));\n', '        require(balances[_to] + _value > balances[_to]);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    function isContract(address _address) internal view returns (bool is_contract) {\n', '        uint length;\n', '        if (_address == address(0)) return false;\n', '        assembly {\n', '            length := extcodesize(_address)\n', '        }\n', '        if (length > 0) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '    function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '        return true;\n', '    }\n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    function tokenFallback(address _from, uint _value, bytes memory _data) pure public {\n', '        TKN memory tkn;\n', '        tkn.sender = _from;\n', '        tkn.value = _value;\n', '        tkn.data = _data;\n', '        uint32 u = uint32(uint8(_data[3])) + (uint32(uint8(_data[2])) << 8) + (uint32(uint8(_data[1])) << 16) + (uint32(uint8(_data[0])) << 24);\n', '        tkn.sig = bytes4(u);\n', '    }\n', '}']