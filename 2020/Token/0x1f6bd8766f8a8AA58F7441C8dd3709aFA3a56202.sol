['pragma solidity =0.6.5;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        _owner = 0x0B4509F330Ff558090571861a723F71657a26f78;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ZyroToken is IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '    uint256 private _totalSupply;\n', '\n', '    constructor() public {\n', '        symbol = "ZYRO";\n', '        name = "zyro";\n', '        decimals = 8;\n', '        uint _totalTokenAmount = (3*10 ** 8) * (10 ** 8); // 300million\n', '        _totalSupply = _totalTokenAmount;\n', '        _balances[owner()] = _totalTokenAmount;\n', '        emit Transfer(address(0x0), owner(), _totalTokenAmount);\n', '    }\n', '\n', '    function totalSupply() override public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address owner) override public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    function allowance(address owner, address spender) override public view returns (uint256)\n', '    {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) override public returns (bool) {\n', '        require(value <= _balances[msg.sender]);\n', '        require(to != address(0));\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) override public returns (bool)\n', '    {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) override public returns (bool)\n', '    {\n', '        require(value <= _balances[from]);\n', '        require(value <= _allowed[from][msg.sender]);\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '}']