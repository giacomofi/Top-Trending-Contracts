['pragma solidity ^0.5.7;\n', '\n', '// wesion Airdrop Fund\n', '//   Keep your ETH balance > (...)\n', '//      See https://wesion.io/en/latest/token/airdrop_via_contract.html\n', '//\n', '//   And call this contract (send 0 ETH here),\n', '//   and you will receive 100-200 VNET Tokens immediately.\n', '\n', '/**\n', ' * @title Ownable\n', ' */\n', 'contract Ownable {\n', '    address internal _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract\n', '     * to the sender account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        address __previousOwner = _owner;\n', '        _owner = newOwner;\n', '        emit OwnershipTransferred(__previousOwner, newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Rescue compatible ERC20 Token\n', '     *\n', '     * @param tokenAddr ERC20 The address of the ERC20 token contract\n', '     * @param receiver The address of the receiver\n', '     * @param amount uint256\n', '     */\n', '    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {\n', '        IERC20 _token = IERC20(tokenAddr);\n', '        require(receiver != address(0));\n', '        uint256 balance = _token.balanceOf(address(this));\n', '\n', '        require(balance >= amount);\n', '        assert(_token.transfer(receiver, amount));\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw Ether\n', '     */\n', '    function withdrawEther(address payable to, uint256 amount) external onlyOwner {\n', '        require(to != address(0));\n', '\n', '        uint256 balance = address(this).balance;\n', '\n', '        require(balance >= amount);\n', '        to.transfer(amount);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20{\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient,\n', '     * reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title wesion Airdrop\n', ' */\n', 'contract WesionAirdrop is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    IERC20 public wesion;\n', '\n', '    uint256 private _wei_min;\n', '\n', '    mapping(address => bool) public _airdopped;\n', '\n', '    event Donate(address indexed account, uint256 amount);\n', '\n', '    /**\n', '     * @dev Wei Min\n', '     */\n', '    function wei_min() public view returns (uint256) {\n', '        return _wei_min;\n', '    }\n', '\n', '    /**\n', '     * @dev constructor\n', '     */\n', '    constructor() public {\n', '        wesion = IERC20(0xF0921CF26f6BA21739530ccA9ba2548bB34308f1);\n', '    }\n', '\n', '    /**\n', '     * @dev receive ETH and send wesions\n', '     */\n', '    function () external payable {\n', '        require(_airdopped[msg.sender] != true);\n', '        require(msg.sender.balance >= _wei_min);\n', '\n', '        uint256 balance = wesion.balanceOf(address(this));\n', '        require(balance > 0);\n', '\n', '        uint256 wesionAmount = 100;\n', '        wesionAmount = wesionAmount.add(uint256(keccak256(abi.encode(now, msg.sender, now))) % 100).mul(10 ** 6);\n', '\n', '        if (wesionAmount <= balance) {\n', '            assert(wesion.transfer(msg.sender, wesionAmount));\n', '        } else {\n', '            assert(wesion.transfer(msg.sender, balance));\n', '        }\n', '\n', '        if (msg.value > 0) {\n', '            emit Donate(msg.sender, msg.value);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev set wei min\n', '     */\n', '    function setWeiMin(uint256 value) external onlyOwner {\n', '        _wei_min = value;\n', '    }\n', '}']