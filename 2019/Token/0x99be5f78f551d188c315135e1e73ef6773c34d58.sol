['/**\n', ' * Source Code first verified at https://etherscan.io on Saturday, April 20, 2019\n', ' (UTC) */\n', '\n', 'pragma solidity 0.5.2;\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        require(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        require(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        require((value == 0) || (token.allowance(msg.sender, spender) == 0));\n', '        require(token.approve(spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '}\n', '\n', '// File: contracts/TRYTokenVesting.sol\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TRYTokenVesting is Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    IERC20 private TRYToken;\n', '    uint256 private tokensToVest = 0;\n', '    uint256 private vestingId = 0;\n', '\n', '    string private constant INSUFFICIENT_BALANCE = "Insufficient balance";\n', '    string private constant INVALID_VESTING_ID = "Invalid vesting id";\n', '    string private constant VESTING_ALREADY_RELEASED = "Vesting already released";\n', '    string private constant INVALID_BENEFICIARY = "Invalid beneficiary address";\n', '    string private constant NOT_VESTED = "Tokens have not vested yet";\n', '\n', '    struct Vesting {\n', '        uint256 releaseTime;\n', '        uint256 amount;\n', '        address beneficiary;\n', '        bool released;\n', '    }\n', '    mapping(uint256 => Vesting) public vestings;\n', '\n', '    event TokenVestingReleased(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);\n', '    event TokenVestingAdded(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);\n', '    event TokenVestingRemoved(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);\n', '\n', '    constructor(IERC20 _token) public {\n', '        require(address(_token) != address(0x0), "Matic token address is not valid");\n', '        TRYToken = _token;\n', '\n', '        uint256 SCALING_FACTOR = 10 ** 18;\n', '        uint256 day = 1 days;\n', '\n', '        addVesting(0x1FD8DFd8Ee9cE53b62C2d5bc944D5F40DA5330C1, now + 0, 100 * SCALING_FACTOR);\n', '        addVesting(0x1FD8DFd8Ee9cE53b62C2d5bc944D5F40DA5330C1, now + 30 * day, 100 * SCALING_FACTOR);\n', '        addVesting(0x1FD8DFd8Ee9cE53b62C2d5bc944D5F40DA5330C1, now + 61 * day, 100 * SCALING_FACTOR);\n', '        \n', '        addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 1279 * day, 273304816 * SCALING_FACTOR);\n', '    }\n', '\n', '    function token() public view returns (IERC20) {\n', '        return TRYToken;\n', '    }\n', '\n', '    function beneficiary(uint256 _vestingId) public view returns (address) {\n', '        return vestings[_vestingId].beneficiary;\n', '    }\n', '\n', '    function releaseTime(uint256 _vestingId) public view returns (uint256) {\n', '        return vestings[_vestingId].releaseTime;\n', '    }\n', '\n', '    function vestingAmount(uint256 _vestingId) public view returns (uint256) {\n', '        return vestings[_vestingId].amount;\n', '    }\n', '\n', '    function removeVesting(uint256 _vestingId) public onlyOwner {\n', '        Vesting storage vesting = vestings[_vestingId];\n', '        require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);\n', '        require(!vesting.released , VESTING_ALREADY_RELEASED);\n', '        vesting.released = true;\n', '        tokensToVest = tokensToVest.sub(vesting.amount);\n', '        emit TokenVestingRemoved(_vestingId, vesting.beneficiary, vesting.amount);\n', '    }\n', '\n', '    function addVesting(address _beneficiary, uint256 _releaseTime, uint256 _amount) public onlyOwner {\n', '        require(_beneficiary != address(0x0), INVALID_BENEFICIARY);\n', '        tokensToVest = tokensToVest.add(_amount);\n', '        vestingId = vestingId.add(1);\n', '        vestings[vestingId] = Vesting({\n', '            beneficiary: _beneficiary,\n', '            releaseTime: _releaseTime,\n', '            amount: _amount,\n', '            released: false\n', '        });\n', '        emit TokenVestingAdded(vestingId, _beneficiary, _amount);\n', '    }\n', '\n', '    function release(uint256 _vestingId) public {\n', '        Vesting storage vesting = vestings[_vestingId];\n', '        require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);\n', '        require(!vesting.released , VESTING_ALREADY_RELEASED);\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= vesting.releaseTime, NOT_VESTED);\n', '\n', '        require(TRYToken.balanceOf(address(this)) >= vesting.amount, INSUFFICIENT_BALANCE);\n', '        vesting.released = true;\n', '        tokensToVest = tokensToVest.sub(vesting.amount);\n', '        TRYToken.safeTransfer(vesting.beneficiary, vesting.amount);\n', '        emit TokenVestingReleased(_vestingId, vesting.beneficiary, vesting.amount);\n', '    }\n', '\n', '    function retrieveExcessTokens(uint256 _amount) public onlyOwner {\n', '        require(_amount <= TRYToken.balanceOf(address(this)).sub(tokensToVest), INSUFFICIENT_BALANCE);\n', '        TRYToken.safeTransfer(owner(), _amount);\n', '    }\n', '}']