['pragma solidity ^0.5.7;\n', '\n', '// Wesion Early Investors Fund\n', '//   Freezed till 2020-06-30 23:59:59, (timestamp 1593532799).\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient,\n', '     * reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' */\n', 'contract Ownable {\n', '    address internal _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract\n', '     * to the sender account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        _owner = newOwner;\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw Ether\n', '     */\n', '    function withdrawEther(address payable to, uint256 amount) external onlyOwner {\n', '        require(to != address(0));\n', '\n', '        uint256 balance = address(this).balance;\n', '\n', '        require(balance >= amount);\n', '        to.transfer(amount);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20{\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '}\n', '\n', '\n', '/**\n', ' * @title Wesion Early Investors Fund\n', ' */\n', 'contract WesionEarlyInvestorsFund is Ownable{\n', '    using SafeMath for uint256;\n', '\n', '    IERC20 public Wesion;\n', '\n', '    uint32 private _till = 1592722800;\n', '    uint256 private _holdings;\n', '\n', '    mapping (address => uint256) private _investors;\n', '\n', '    event InvestorRegistered(address indexed account, uint256 amount);\n', '    event Donate(address indexed account, uint256 amount);\n', '\n', '\n', '    /**\n', '     * @dev constructor\n', '     */\n', '    constructor() public {\n', '        Wesion = IERC20(0x2c1564A74F07757765642ACef62a583B38d5A213);\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw or Donate by any amount\n', '     */\n', '    function () external payable {\n', '        if (now > _till && _investors[msg.sender] > 0) {\n', '            assert(Wesion.transfer(msg.sender, _investors[msg.sender]));\n', '            _investors[msg.sender] = 0;\n', '        }\n', '\n', '        if (msg.value > 0) {\n', '            emit Donate(msg.sender, msg.value);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev holdings amount\n', '     */\n', '    function holdings() public view returns (uint256) {\n', '        return _holdings;\n', '    }\n', '\n', '    /**\n', '     * @dev balance of the owner\n', '     */\n', '    function investor(address owner) public view returns (uint256) {\n', '        return _investors[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev register an investor\n', '     */\n', '    function registerInvestor(address to, uint256 amount) external onlyOwner {\n', '        _holdings = _holdings.add(amount);\n', '        require(_holdings <= Wesion.balanceOf(address(this)));\n', '        _investors[to] = _investors[to].add(amount);\n', '        emit InvestorRegistered(to, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Rescue compatible ERC20 Token, except "Wesion"\n', '     *\n', '     * @param tokenAddr ERC20 The address of the ERC20 token contract\n', '     * @param receiver The address of the receiver\n', '     * @param amount uint256\n', '     */\n', '    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {\n', '        IERC20 _token = IERC20(tokenAddr);\n', '        require(Wesion != _token);\n', '        require(receiver != address(0));\n', '\n', '        uint256 balance = _token.balanceOf(address(this));\n', '        require(balance >= amount);\n', '        assert(_token.transfer(receiver, amount));\n', '    }\n', '\n', '    /**\n', '     * @dev set Wesion Address\n', '     */\n', '    function setWesionAddress(address _WesionAddr) public onlyOwner {\n', '        Wesion = IERC20(_WesionAddr);\n', '    }\n', '}']