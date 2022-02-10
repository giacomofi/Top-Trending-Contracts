['pragma solidity 0.4.24;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : dave@akomba.com\n', '// released under Apache 2.0 licence\n', '// input  /root/code/solidity/xixoio-contracts/flat/TokenPool.sol\n', '// flattened :  Monday, 03-Dec-18 10:34:17 UTC\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'interface ITokenPool {\n', '    function balanceOf(uint128 id) public view returns (uint256);\n', '    function allocate(uint128 id, uint256 value) public;\n', '    function withdraw(uint128 id, address to, uint256 value) public;\n', '    function complete() public;\n', '}\n', '\n', 'contract TokenPool is ITokenPool, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    IERC20 public token;\n', '    bool public completed = false;\n', '\n', '    mapping(uint128 => uint256) private balances;\n', '    uint256 public allocated = 0;\n', '\n', '    event FundsAllocated(uint128 indexed account, uint256 value);\n', '    event FundsWithdrawn(uint128 indexed account, address indexed to, uint256 value);\n', '\n', '    constructor(address tokenAddress) public {\n', '        token = IERC20(tokenAddress);\n', '    }\n', '\n', '    /**\n', '     * @return The balance of the account in pool\n', '     */\n', '    function balanceOf(uint128 account) public view returns (uint256) {\n', '        return balances[account];\n', '    }\n', '\n', '    /**\n', '     * Token allocation function\n', '     * @dev should be called after every token deposit to allocate these token to the account\n', '     */\n', '    function allocate(uint128 account, uint256 value) public onlyOwner {\n', '        require(!completed, "Pool is already completed");\n', '        assert(unallocated() >= value);\n', '        allocated = allocated.add(value);\n', '        balances[account] = balances[account].add(value);\n', '        emit FundsAllocated(account, value);\n', '    }\n', '\n', '    /**\n', '     * Allows withdrawal of tokens and dividends from temporal storage to the wallet\n', '     * @dev transfers corresponding amount of dividend in ETH\n', '     */\n', '    function withdraw(uint128 account, address to, uint256 value) public onlyOwner {\n', '        balances[account] = balances[account].sub(value);\n', '        uint256 balance = address(this).balance;\n', '        uint256 dividend = balance.mul(value).div(allocated);\n', '        allocated = allocated.sub(value);\n', '        token.transfer(to, value);\n', '        if (dividend > 0) {\n', '            to.transfer(dividend);\n', '        }\n', '        emit FundsWithdrawn(account, to, value);\n', '    }\n', '\n', '    /**\n', '     * Concludes allocation of tokens and serves as a drain for unallocated tokens\n', '     */\n', '    function complete() public onlyOwner {\n', '        completed = true;\n', '        token.transfer(msg.sender, unallocated());\n', '    }\n', '\n', '    /**\n', '     * Fallback function enabling deposit of dividends in ETH\n', '     * @dev dividend has to be deposited only after pool completion, as additional token\n', '     *      allocations after the deposit would skew shares\n', '     */\n', '    function () public payable {\n', '        require(completed, "Has to be completed first");\n', '    }\n', '\n', '    /**\n', '     * @return Amount of unallocated tokens in the pool\n', '     */\n', '    function unallocated() internal view returns (uint256) {\n', '        return token.balanceOf(this).sub(allocated);\n', '    }\n', '}']