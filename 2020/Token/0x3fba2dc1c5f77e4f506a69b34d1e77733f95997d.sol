['pragma solidity 0.6.0;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () public {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract gainsfinance is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    event LogRebase(uint256 indexed epoch, uint256 totalSupply);\n', '\n', '    modifier validRecipient(address to) {\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    string public constant name = "gains.finance";\n', '    string public constant symbol = "GAINS";\n', '    uint256 public constant decimals = 18;\n', '\n', '    uint256 private constant DECIMALS = 18;\n', '    uint256 private constant MAX_UINT256 = ~uint256(0);\n', '    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 30000 * 10**DECIMALS;\n', '\n', '    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);\n', '\n', '    uint256 private constant MAX_SUPPLY = ~uint128(0);\n', '\n', '    uint256 private _totalSupply;\n', '    uint256 private _gonsPerFragment;\n', '    mapping(address => uint256) private _gonBalances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowedFragments;\n', '    \n', '\n', '    function rebase(uint256 epoch, uint256 supplyDelta)\n', '        external\n', '        onlyOwner\n', '        returns (uint256)\n', '    {\n', '        if (supplyDelta == 0) {\n', '            emit LogRebase(epoch, _totalSupply);\n', '            return _totalSupply;\n', '        }\n', '\n', '         _totalSupply = _totalSupply.sub(supplyDelta);\n', '\n', '        \n', '        if (_totalSupply > MAX_SUPPLY) {\n', '            _totalSupply = MAX_SUPPLY;\n', '        }\n', '\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '        emit LogRebase(epoch, _totalSupply);\n', '        return _totalSupply;\n', '    }\n', '\n', '    constructor() public override {\n', '        _owner = msg.sender;\n', '        \n', '        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;\n', '        _gonBalances[_owner] = TOTAL_GONS;\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '        emit Transfer(address(0x0), _owner, _totalSupply);\n', '    }\n', '\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _gonBalances[who].div(_gonsPerFragment);\n', '    }\n', '\n', '    function transfer(address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        returns (bool)\n', '    {\n', '        uint256 gonValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);\n', '        _gonBalances[to] = _gonBalances[to].add(gonValue);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner_, address spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowedFragments[owner_][spender];\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);\n', '\n', '        uint256 gonValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[from] = _gonBalances[from].sub(gonValue);\n', '        _gonBalances[to] = _gonBalances[to].add(gonValue);\n', '        emit Transfer(from, to, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] =\n', '            _allowedFragments[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = _allowedFragments[msg.sender][spender];\n', '        if (subtractedValue >= oldValue) {\n', '            _allowedFragments[msg.sender][spender] = 0;\n', '        } else {\n', '            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '}']