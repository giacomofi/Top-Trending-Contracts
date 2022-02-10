['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.4.25;\n', '\n', 'import "./ownership/Ownable.sol";\n', 'import "./math/SafeMath.sol";\n', 'import "./token/ERC20.sol";\n', 'import "./token/ERC20Detailed.sol";\n', 'import "./interfaces/ICERC20.sol";\n', 'import "./interfaces/IWETH.sol";\n', 'import "./security/ReentrancyGuard.sol";\n', '\n', 'contract Bread is Ownable, ERC20, ERC20Detailed, ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    IERC20 public reserveToken;\n', '    ICERC20 public cReserveToken;\n', '    uint256 public totalReserve;\n', '\n', '    event Minted(address sender, uint256 amount);\n', '    event Burned(address sender, uint256 amount);\n', '\n', '    constructor(\n', '        address _reserveTokenAddress,\n', '        address _cReserveTokenAddress\n', '    ) public ERC20Detailed("Breadchain Stablecoin", "BREAD", 18) {\n', '        reserveToken = IERC20(_reserveTokenAddress);\n', '        cReserveToken = ICERC20(_cReserveTokenAddress);\n', '    }\n', '\n', '    function mint(uint256 _amount) public {\n', '        _handleMint(_amount);\n', '        require(reserveToken.transferFrom(msg.sender, address(this), _amount), "mint() ERC20.transferFrom failed.");\n', '        require(reserveToken.approve(address(cReserveToken), _amount), "mint() ERC20.approve failed.");\n', '        require(cReserveToken.mint(_amount) == 0, "mint() cERC20.mint failed.");\n', '        totalReserve = totalReserve.add(_amount);\n', '    }\n', '\n', '    function burn(uint256 _amount) public nonReentrant {\n', '        _handleBurn(_amount);\n', '        require(cReserveToken.redeemUnderlying(_amount) == 0, "burn() cERC20.redeemUnderlying failed.");\n', '        totalReserve = totalReserve.sub(_amount);\n', '        require(reserveToken.transfer(msg.sender, _amount), "burn() ERC20.transfer failed.");\n', '    }\n', '\n', '    function withdrawInterest(uint256 _amount) public onlyOwner nonReentrant {\n', '        require(_amount > 0, "withdrawInterest() cannot withdraw 0");\n', '        uint256 interest = interestAvailable();\n', '        require(interest >= _amount, "withdrawInterest() interest accrued is below withdraw amount");\n', '        require(cReserveToken.redeemUnderlying(_amount) == 0, "withdrawInterest() cERC20.redeemUnderlying failed.");\n', '        require(reserveToken.transfer(owner(), _amount), "withdrawInterest() ERC20.transfer failed.");\n', '    }\n', '\n', '    function withdrawToken(address _tokenAddress, uint256 _amount) public onlyOwner nonReentrant {\n', '        require(_tokenAddress != address(cReserveToken), "withdrawToken() cannot withdraw collateral token.");\n', '        if (_tokenAddress == ETH) {\n', '            require(address(this).balance >= _amount, "withdrawToken() balance too low");\n', '            owner().transfer(_amount);\n', '        } else {\n', '            require(IERC20(_tokenAddress).transfer(owner(), _amount), "withdrawToken() ERC20.transfer failed.");\n', '        }\n', '    }\n', '\n', '    function interestAvailable() public view returns (uint256) {\n', '        return cReserveToken.balanceOfUnderlying(address(this)).sub(totalReserve);\n', '    }\n', '\n', '    function _handleMint(uint256 _amount) internal {\n', '        require(_amount > 0, "Deposit must be non-zero.");\n', '        _mint(msg.sender, _amount);\n', '        emit Minted(msg.sender, _amount);\n', '    }\n', '\n', '    function _handleBurn(uint256 _amount) internal {\n', '        require(_amount > 0, "Amount must be non-zero.");\n', '        require(balanceOf(msg.sender) >= _amount, "Insufficient tokens to burn.");\n', '\n', '        _burn(msg.sender, _amount);\n', '        emit Burned(msg.sender, _amount);\n', '    }\n', '\n', '    function () external payable {}\n', '}\n', '\n', 'pragma solidity 0.4.25;\n', '\n', '/**\n', ' * @title CErc20 interface for Compound ERC20 assets\n', ' */\n', 'interface ICERC20 {\n', '    function mint(uint256 mintAmount) external returns (uint256);\n', '    function redeem(uint256 redeemTokens) external returns (uint256);\n', '    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);\n', '    function borrow(uint256 borrowAmount) external returns (uint256);\n', '    function repayBorrow(uint256 repayAmount) external returns (uint256);\n', '    function balanceOfUnderlying(address account) external view returns (uint256);\n', '    function exchangeRateCurrent() external view returns (uint256);\n', '}\n', '\n', 'pragma solidity 0.4.25;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'pragma solidity 0.4.25;\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '}\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier\n', ' * available, which can be applied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' *\n', ' * TIP: If you would like to learn more about reentrancy and alternative ways\n', ' * to protect against it, check out our blog post\n', ' * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].\n', ' */\n', 'contract ReentrancyGuard {\n', '    // Booleans are more expensive than uint256 or any type that takes up a full\n', '    // word because each write operation emits an extra SLOAD to first read the\n', "    // slot's contents, replace the bits taken up by the boolean, and then write\n", "    // back. This is the compiler's defense against contract upgrades and\n", '    // pointer aliasing, and it cannot be disabled.\n', '\n', '    // The values being non-zero value makes deployment a bit more expensive,\n', '    // but in exchange the refund on every call to nonReentrant will be lower in\n', '    // amount. Since refunds are capped to a percentage of the total\n', "    // transaction's gas, it is best to keep them low in cases like this one, to\n", '    // increase the likelihood of the full refund coming into effect.\n', '    uint256 private constant _NOT_ENTERED = 1;\n', '    uint256 private constant _ENTERED = 2;\n', '\n', '    uint256 private _status;\n', '\n', '    constructor() public {\n', '        _status = _NOT_ENTERED;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        // On the first call to nonReentrant, _notEntered will be true\n', '        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");\n', '\n', '        // Any calls to nonReentrant after this point will fail\n', '        _status = _ENTERED;\n', '\n', '        _;\n', '\n', '        // By storing the original value once again, a refund is triggered (see\n', '        // https://eips.ethereum.org/EIPS/eip-2200)\n', '        _status = _NOT_ENTERED;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', 'import "../interfaces/IERC20.sol";\n', 'import "../math/SafeMath.sol";\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' *\n', ' * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for\n', " * all accounts just by listening to said events. Note that this isn't required by the specification, and other\n", ' * compliant implementations may not do it.\n', ' */\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '     * @dev Total number of tokens in existence\n', '     */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner The address to query the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified address\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified addresses\n', '     * @param from The address to transfer from.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(spender != address(0));\n', '        require(owner != address(0));\n', '\n', '        _allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _burn(account, value);\n', '        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));\n', '    }\n', '}\n', '\n', 'pragma solidity 0.4.25;\n', '\n', 'import "../interfaces/IERC20.sol";\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor(string name, string symbol, uint8 decimals) public {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  /**\n', '   * @return the name of the token.\n', '   */\n', '  function name() public view returns(string) {\n', '    return _name;\n', '  }\n', '\n', '  /**\n', '   * @return the symbol of the token.\n', '   */\n', '  function symbol() public view returns(string) {\n', '    return _symbol;\n', '  }\n', '\n', '  /**\n', '   * @return the number of decimals of the token.\n', '   */\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '}\n', '\n', '{\n', '  "evmVersion": "byzantium",\n', '  "libraries": {},\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "remappings": [],\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']